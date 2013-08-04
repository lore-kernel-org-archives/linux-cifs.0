From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: smb2 logoff
Date: Sun, 4 Aug 2013 10:51:44 -0500
Message-ID: <CADT32eKr2K8G58ub50FELC=oh78pmBPDs+Fgpd1=_UqKa4OmmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs client does not handle error code returned by smb2 session logoff.
What if the server returns access denied?
I looked in ms-smb2 but it does not say anything about how a client should
handle error by smb2 logoff response.
This happens when cifs client sends a smb2 logoff request without a
signature (because we remove the session from the list before
sending off a request and handling the response) and can't verify
signature in the response.
Also, not sure what happens at the server if the session logoff
request is a) unsigned and/or b) server returns error as a response.

I think the patch should be to remove the session from the list
after the smb2 logoff request is sent and response is handled.
Will submit a patch as part of changing per smb connection key
to per session key patchset resubmission.

Regards,

Shirish
