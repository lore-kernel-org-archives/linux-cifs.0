From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Problem with connecting to SMB server in 3.9.11 kernel.
Date: Sun, 26 Jan 2014 08:04:06 -0600
Message-ID: <CADT32eKWbDOHkSrsQeQPVjYb+NwToD2DH+iUjvbHuC9Wdw3QPg@mail.gmail.com>
References: <52DAB72C.9030305@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"Amit Haval (India Bangalore)" <amit.haval-ZIEO9HjW1UBWk0Htik3J/w@public.gmane.org>
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52DAB72C.9030305-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I Was thinking perhaps client not setting either
NTLMSSP_TARGET_TYPE_SERVER  or
NTLMSSP_TARGET_TYPE_DOMAIN or
NTLMSSP_TARGET_TYPE_SHARE
(the one that server sets in type 2/challenge message)
in type 3 message  is a problem but it is not (as per page 33 in
ms-nlmp document).

cifs client should change to code Target Name instead of NetBIOS
domain name from Target Info to calculate ntlmv2 response but that is
not the problem here (because they happen to be the exact same).

Is there a way to check what kind of response this  SMB server
expects i.e. NTLMv1 or NTLMv2?  There may be a conf file on the
server effecting that.

Also, if you can provide wireshark trace for any other client besides
cifs client successfully authenticating with this server, that would be
useful too.


On Sat, Jan 18, 2014 at 11:17 AM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
> Hello!
>
> A customer reported problems connecting our CIFS traffic generation test
> gear to their SMB server.
> We are using the 3.9.11+ kernel, and though it is patched, we do not have
> any
> patches to cifs.
>
> The OS is Fedora 14, 64-bit.
>
> A similar system on Fedora 14, with a 3.7.10+ kernel was working, but when
> we tried the 3.7.10+ kernel on the broken machine, it also failed to work.
> So, it could be the SMB server itself is having issues.  (In the 3.7.10+
> failure,
> the server just failed to respond after "Setup andX Request AUTH message",
> though we
> did get the TCP ack so it looks like the message was received by the
> server.)
>
> I'm attaching a capture taken on the SMB server.
>
> From looking at this page:
>
> http://msdn.microsoft.com/en-us/library/ff469913.aspx
>
> It appears the problem (STATUS_UNSUCCESSFUL) is:
>
> "The size of the extended attribute list is not correct. Check the
> EaErrorOffset field for the
> address of the SMB_GEA structure at which the error was detected."
>
> I did not see anything about extended attribute list in the capture, but if
> someone else
> with more knowledge could take a look and see if they notice any problems I
> would be grateful.
>
> Thanks!
> Ben
>
> --
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
> Candela Technologies Inc  http://www.candelatech.com
>
