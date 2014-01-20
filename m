From: "Amit Haval (India Bangalore)" <amit.haval-ZIEO9HjW1UBWk0Htik3J/w@public.gmane.org>
Subject: RE: Problem with connecting to SMB server in 3.9.11 kernel.
Date: Mon, 20 Jan 2014 17:34:35 +0000
Message-ID: <0DF7592FDA7A4C428E3B3D14C1D69BDAADCF8D@AUSP01DAG0309.collaborationhost.net>
References: <52DAB72C.9030305@candelatech.com>
 <CADT32eK5_duGPjJy2Q=2-SOfN1R+Msx10RJ7wk+Zzsz+xt_-Rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"c-dl-nb-mt-nic-validation (dl-nb-mt-nic-validation-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org)"
	<dl-nb-mt-nic-validation-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eK5_duGPjJy2Q=2-SOfN1R+Msx10RJ7wk+Zzsz+xt_-Rw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Adding nic-dl...

-----Original Message-----
From: Shirish Pargaonkar [mailto:shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] 
Sent: Monday, January 20, 2014 9:24 PM
To: Ben Greear
Cc: linux-cifs; Amit Haval (India Bangalore)
Subject: Re: Problem with connecting to SMB server in 3.9.11 kernel.

yes, this looks like a authentication failure.
It probably is a NetApp server.  Can any other client (e.g. Windows, smbclient etc.) authenticate using ntlmv2/ntlmssp to this server?

SMB servers do not typically point_out/log what part of the request is invalid, so it is little harder to figure out how the request is incorrect.


On Sat, Jan 18, 2014 at 11:17 AM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
> Hello!
>
> A customer reported problems connecting our CIFS traffic generation 
> test gear to their SMB server.
> We are using the 3.9.11+ kernel, and though it is patched, we do not 
> have any patches to cifs.
>
> The OS is Fedora 14, 64-bit.
>
> A similar system on Fedora 14, with a 3.7.10+ kernel was working, but 
> when we tried the 3.7.10+ kernel on the broken machine, it also failed to work.
> So, it could be the SMB server itself is having issues.  (In the 
> 3.7.10+ failure, the server just failed to respond after "Setup andX 
> Request AUTH message", though we did get the TCP ack so it looks like 
> the message was received by the
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
> EaErrorOffset field for the address of the SMB_GEA structure at which 
> the error was detected."
>
> I did not see anything about extended attribute list in the capture, 
> but if someone else with more knowledge could take a look and see if 
> they notice any problems I would be grateful.
>
> Thanks!
> Ben
>
> --
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
> Candela Technologies Inc  http://www.candelatech.com
>

______________________________________________________________________
This email has been scanned by the Boundary Defense for Email Security System. For more information please visit http://www.apptix.com/email-security/antispam-virus
______________________________________________________________________

______________________________________________________________________
This email has been scanned by the Boundary Defense for Email Security System. For more information please visit http://www.apptix.com/email-security/antispam-virus
______________________________________________________________________
