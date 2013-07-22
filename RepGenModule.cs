using System;
using System.Linq;
using Nancy;
using Nancy.ModelBinding;
using Raven.Client.Embedded;
using Raven.Client.Linq;

namespace ConnectedRepGen
{
    public class RepGenModule : NancyModule
    {
        public RepGenModule()
            : base("/api")
        {



            Post["/Session"] = parameters =>
                                   {
                                       var memberInformation = this.Bind<RepgenSession>();
                                       var documentSession = Global.Store.OpenSession();
                                       documentSession.Store(memberInformation);
                                       documentSession.SaveChanges();

                                       documentSession.Dispose();

                                       return Response.AsJson(new
                                                                  {
                                                                      SessionId = memberInformation.Id.Replace("RepgenSessions/", "")
                                                                  }, HttpStatusCode.Created);
                                   };

            Get["/Session/{sessionId}"] = parameters =>
                                              {
                                                  string sessionId = "RepgenSessions/" + parameters.sessionId;


                                                  var session = Global.Store.OpenSession();
                                                  var memberInformation = session.Load<RepgenSession>(sessionId);

                                                  session.Dispose();

                                                  return Response.AsJson(memberInformation).WithHeader("Cache-Control", "no-store");
                                              };

            Put["/Session/{sessionId}"] = parameters =>
                                              {
                                                  string sessionId = "RepgenSessions/" + parameters.sessionId;

                                                  var updatedSession = this.Bind<RepgenSession>();

                                                  var session = Global.Store.OpenSession();
                                                  var repgenSession = session.Load<RepgenSession>(sessionId);

                                                  repgenSession.MemberDetails.FirstName = updatedSession.MemberDetails.FirstName;
                                                  repgenSession.MemberDetails.LastName = updatedSession.MemberDetails.LastName;
                                                  repgenSession.MemberDetails.MiddleName = updatedSession.MemberDetails.MiddleName;
                                                  repgenSession.MemberDetails.BirthDate = updatedSession.MemberDetails.BirthDate;
                                                  repgenSession.MemberDetails.Contact = updatedSession.MemberDetails.Contact;
                                                  repgenSession.MemberDetails.Address = updatedSession.MemberDetails.Address;
                                                  repgenSession.Complete = updatedSession.Complete;
                                                  session.SaveChanges();

                                                  session.Dispose();

                                                  return Response.AsJson(HttpStatusCode.OK);
                                              };



            After.AddItemToEndOfPipeline(ctx => ctx.Response.WithHeader("Cache-Control", "no-store"));

        }
    }
    public class RepgenSession
    {
        public string Id { get; set; }
        public string AssociateName { get; set; }
        public MemberDetails MemberDetails { get; set; }
        public bool Complete { get; set; }
    }
    public class MemberDetails
    {
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public DateTime BirthDate { get; set; }
        public ContactInformation Contact { get; set; }
        public Address Address { get; set; }
    }

    public class Address
    {
        public string AddressLine1 { get; set; }
        public string AddressLine2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
    }

    public class ContactInformation
    {
        public string EmailAddress { get; set; }
        public string PhoneNumber { get; set; }
    }
}