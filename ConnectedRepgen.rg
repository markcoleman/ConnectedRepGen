SUBROUTINE DEMAND WINDOWS

TARGET = ACCOUNT

DEFINE

firstName = CHARACTER
TEMPCHARACTER = CHARACTER
I = NUMBER
INPUTCOUNT = NUMBER
INPUTFORM = CHARACTER(132) ARRAY(99)
strSubErrorText = CHARACTER
strErrorText = CHARACTER

END

SETUP
CALL WRITEHTML
CALL LOADFORMRESULTS
POPUPMESSAGE(0,"First Name: " + firstName)
END

PRINT TITLE = "NO TITLE"
TEMPCHARACTER = ""
END

PROCEDURE WRITEHTML

HTMLVIEWOPEN
HTMLVIEWLINE("<!DOCTYPE html>")
HTMLVIEWLINE("<html lang='en' xmlns='http://www.w3.org/1999/xhtml'>")
HTMLVIEWLINE("<head>")
HTMLVIEWLINE("    <meta charset='utf-8' />")
HTMLVIEWLINE("    <title></title>")
HTMLVIEWLINE("    <style type='text/css'>")
HTMLVIEWLINE("        iframe")
HTMLVIEWLINE("        {")
HTMLVIEWLINE("            width: 100%;")
HTMLVIEWLINE("            border: none;")
HTMLVIEWLINE("        }")
HTMLVIEWLINE("    </style>")
HTMLVIEWLINE("</head>")
HTMLVIEWLINE("<body>")
HTMLVIEWLINE("    <form id='symitarForm' method='post' name='symitarForm' action='symitar://HTMLView~Action=Post'>")
HTMLVIEWLINE("        <input type='hidden' id='memberDetails.FirstName' name='FirstName' />")
HTMLVIEWLINE("        <input type='hidden' id='memberDetails.LastName' name='LastName' />")
HTMLVIEWLINE("        <input type='hidden' id='memberDetails.BirthDate' name='BirthDate' />")
HTMLVIEWLINE("        <input type='hidden' id='memberDetails.Address.AddressLine1' name='AddressLine1' />")
HTMLVIEWLINE("        <input type='hidden' id='memberDetails.Address.AddressLine2' name='AddressLine2' />")
HTMLVIEWLINE("        <input type='hidden' id='memberDetails.Address.City' name='City' />  ")
HTMLVIEWLINE("        <input type='hidden'  id='memberDetails.Address.State' name='State' />  ")
HTMLVIEWLINE("        <input type='hidden' id='memberDetails.Address.PostalCode' name='PostalCode' />")
HTMLVIEWLINE("        <input type='hidden' id='memberDetails.Contact.EmailAddress' name='EmailAddress' />")
HTMLVIEWLINE("        <input type='hidden' id='memberDetails.Contact.PhoneNumber' name='PhoneNumber' />")
HTMLVIEWLINE("    </form>")
HTMLVIEWLINE("    <iframe id='start' src='http://itsdevp1006/start.html'></iframe>")
HTMLVIEWLINE("</body>")
HTMLVIEWLINE("<script src='http://code.jquery.com/jquery-1.9.1.min.js' type='text/javascript'></script>")
HTMLVIEWLINE("<script src='http://itsdevp1006/lib/jquery.json-2.4.min.js'></script>")
HTMLVIEWLINE("<script type='text/javascript'>")
HTMLVIEWLINE("    $(function () {")
HTMLVIEWLINE("        $('iframe').height($(window).height());")
HTMLVIEWLINE("    });")
HTMLVIEWLINE("    var data = {")
HTMLVIEWLINE("        AssociateName: 'Mark Coleman',")
HTMLVIEWLINE("        MemberDetails: {")
HTMLVIEWLINE("            FirstName: 'John',")
HTMLVIEWLINE("            MiddleName: null,")
HTMLVIEWLINE("            LastName: 'Smith',")
HTMLVIEWLINE("            BirthDate: '2013-12-01T00:00:00',")
HTMLVIEWLINE("            Contact: {")
HTMLVIEWLINE("                EmailAddress: 'asdfsa@saf.com',")
HTMLVIEWLINE("                PhoneNumber: '7177777777'")
HTMLVIEWLINE("            },")
HTMLVIEWLINE("            Address: {")
HTMLVIEWLINE("                AddressLine1: '123 Fake Street',")
HTMLVIEWLINE("                AddressLine2: '',")
HTMLVIEWLINE("                City: 'Fake Town',")
HTMLVIEWLINE("                State: 'CT',")
HTMLVIEWLINE("                PostalCode: '12345'")
HTMLVIEWLINE("            }")
HTMLVIEWLINE("        },")
HTMLVIEWLINE("        Complete: false")
HTMLVIEWLINE("    };")
HTMLVIEWLINE("    setTimeout(function () {")
HTMLVIEWLINE("        $('#start')[0].contentWindow.postMessage($.toJSON(data), '*');")
HTMLVIEWLINE("    }, 500);")
HTMLVIEWLINE("    (function () {")
HTMLVIEWLINE("        if (window.attachEvent) {")
HTMLVIEWLINE("            window.attachEvent('onmessage', message);")
HTMLVIEWLINE("        }")
HTMLVIEWLINE("        else {")
HTMLVIEWLINE("            window.addEventListener('message', message, false);")
HTMLVIEWLINE("        }")
HTMLVIEWLINE("        function message(event) {")
HTMLVIEWLINE("            var memberDetails = $.parseJSON(event.data).MemberDetails;")
HTMLVIEWLINE("            document.getElementById('memberDetails.FirstName').value = memberDetails.FirstName;")
HTMLVIEWLINE("            document.getElementById('memberDetails.LastName').value = memberDetails.LastName;")
HTMLVIEWLINE("            document.getElementById('memberDetails.BirthDate').value = memberDetails.BirthDate;")
HTMLVIEWLINE("            document.getElementById('memberDetails.Contact.PhoneNumber').value = memberDetails.Contact.PhoneNumber;")
HTMLVIEWLINE("            document.getElementById('memberDetails.Contact.EmailAddress').value = memberDetails.Contact.EmailAddress;")
HTMLVIEWLINE("            document.getElementById('memberDetails.Address.AddressLine1').value = memberDetails.Address.AddressLine1;")
HTMLVIEWLINE("            document.getElementById('memberDetails.Address.AddressLine2').value = memberDetails.Address.AddressLine2;")
HTMLVIEWLINE("            document.getElementById('memberDetails.Address.City').value = memberDetails.Address.City;")
HTMLVIEWLINE("            document.getElementById('memberDetails.Address.State').value = memberDetails.Address.State;")
HTMLVIEWLINE("            document.getElementById('memberDetails.Address.PostalCode').value = memberDetails.Address.PostalCode;")
HTMLVIEWLINE("            $('#symitarForm').submit();")
HTMLVIEWLINE("        }")
HTMLVIEWLINE("    })();")
HTMLVIEWLINE("</script>")
HTMLVIEWLINE("</html>")
HTMLVIEWDISPLAY

END


PROCEDURE LOADFORMRESULTS

INPUTCOUNT = 0
WHILE (INPUTFORM(INPUTCOUNT) <> "EOD")
	DO
		INPUTCOUNT = INPUTCOUNT + 1
		INPUTFORM(INPUTCOUNT) = ENTERLINE(0)
	END

[If nothing was passed, the teller aborted]
IF(INPUTCOUNT > 0) THEN DO
FOR I = 1 TO INPUTCOUNT
	DO
		TEMPCHARACTER = INPUTFORM(I)
		IF UPPERCASE(SEGMENT(TEMPCHARACTER, 1, 10)) = "FIRSTNAME=" THEN
			firstName = UPPERCASE(SEGMENT(TEMPCHARACTER, 11, LENGTH(TEMPCHARACTER)))
		END
	END
END
