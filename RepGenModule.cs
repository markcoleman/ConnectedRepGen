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
                                       var memberInformation = this.Bind<MemberInformation>();
                                       var documentSession = Global.Store.OpenSession();
                                       documentSession.Store(memberInformation);
                                       documentSession.SaveChanges();

                                       documentSession.Dispose();

                                       return Response.AsJson(new
                                                                  {
                                                                      SessionId = memberInformation.Id.Replace("MemberInformations/", "")
                                                                  }, HttpStatusCode.Created);
                                   };

            Get["/Session/{sessionId}"] = parameters =>
                                              {
                                                  string sessionId = "MemberInformations/" + parameters.sessionId;

                                                  
                                                  var session = Global.Store.OpenSession();
                                                  var memberInformation = session.Load<MemberInformation>(sessionId);

                                                  session.Dispose();

                                                  return Response.AsJson(memberInformation);
                                              };

            Put["/Session/{sessionId}"] = parameters =>
                                              {
                                                  string sessionId = "MemberInformations/" + parameters.sessionId;

                                                  var updatedMemberInformation = this.Bind<MemberInformation>();

                                                  var session = Global.Store.OpenSession();
                                                  var memberInformation = session.Load<MemberInformation>(sessionId);

                                                  memberInformation.FirstName = updatedMemberInformation.FirstName;
                                                  memberInformation.LastName = updatedMemberInformation.LastName;
                                                  memberInformation.MiddleName = updatedMemberInformation.MiddleName;
                                                  memberInformation.BirthDate = updatedMemberInformation.BirthDate;
                                                  memberInformation.Contact = updatedMemberInformation.Contact;
                                                  memberInformation.Address = updatedMemberInformation.Address;

                                                  session.SaveChanges();

                                                  session.Dispose();

                                                  return Response.AsJson(HttpStatusCode.OK);
                                              };



        }
    }

    public class MemberInformation
    {
        public string Id { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public DateTime BirthDate { get; set; }
        public ContactInformation Contact { get; set; }
        public Address Address { get; set; }
        public bool Complete { get; set; }
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