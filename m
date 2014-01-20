From: "Amit Haval (India Bangalore)" <amit.haval-ZIEO9HjW1UBWk0Htik3J/w@public.gmane.org>
Subject: RE: Problem with connecting to SMB server in 3.9.11 kernel.
Date: Mon, 20 Jan 2014 15:15:44 +0000
Message-ID: <0DF7592FDA7A4C428E3B3D14C1D69BDAADCF30@AUSP01DAG0309.collaborationhost.net>
References: <52DAB72C.9030305@candelatech.com>
 <20140120075657.0e61ecb2@tlielax.poochiereds.net>
 <fb5a5a794f9d46ffb3bafd4a7f9f5a88@BLUPR03MB328.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"Shirish Pargaonkar" <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
To: "c-dl-nb-mt-nic-validation (dl-nb-mt-nic-validation-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org)"
	<dl-nb-mt-nic-validation-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fb5a5a794f9d46ffb3bafd4a7f9f5a88-GeMU99GfrruUGfbpEvpFbeO6mTEJWrR4XA4E9RH9d+qIuWR1G4zioA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Adding our team to comment/help.

-----Original Message-----
From: Tom Talpey [mailto:ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org] 
Sent: Monday, January 20, 2014 7:17 PM
To: Jeff Layton; Ben Greear
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Amit Haval (India Bangalore); Shirish Pargaonkar
Subject: RE: Problem with connecting to SMB server in 3.9.11 kernel.

> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs- 
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jeff Layton
> Sent: Monday, January 20, 2014 7:57 AM
> To: Ben Greear
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Amit Haval (India Bangalore); Shirish 
> Pargaonkar
> Subject: Re: Problem with connecting to SMB server in 3.9.11 kernel.
> 
> On Sat, 18 Jan 2014 09:17:32 -0800
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
> 
> > Hello!
> >
> > A customer reported problems connecting our CIFS traffic generation 
> > test
> gear to their SMB server.
> > We are using the 3.9.11+ kernel, and though it is patched, we do not 
> > have any patches to cifs.
> >
> > The OS is Fedora 14, 64-bit.
> >
> > A similar system on Fedora 14, with a 3.7.10+ kernel was working, 
> > but when we tried the 3.7.10+ kernel on the broken machine, it also 
> > failed to
> work.
> > So, it could be the SMB server itself is having issues.  (In the 
> > 3.7.10+ failure, the server just failed to respond after "Setup andX 
> > Request AUTH message", though we did get the TCP ack so it looks 
> > like the message was received by the server.)
> >
> > I'm attaching a capture taken on the SMB server.
> >
> >  From looking at this page:
> >
> > http://msdn.microsoft.com/en-us/library/ff469913.aspx
> >
> > It appears the problem (STATUS_UNSUCCESSFUL) is:
> >
> > "The size of the extended attribute list is not correct. Check the 
> > EaErrorOffset field for the address of the SMB_GEA structure at 
> > which the
> error was detected."
> >
> > I did not see anything about extended attribute list in the capture, 
> > but if someone else with more knowledge could take a look and see if 
> > they
> notice any problems I would be grateful.
> >
> > Thanks!
> > Ben
> >
> 
> There's no EA list on this call so that description isn't valid here.
> 
> AIUI, NT_STATUS_UNSUCCESSFUL is basically a generic "something went 
> wrong" error (sort of like EIO on POSIX). It looks like the server 
> doesn't like something about the request being sent, but it's tough to know what it is.

The trace Ben attached shows an authentication failure, and I don't see any TRANS2_QUERY_FILE_INFORMATION in the trace at all as Ben references. The client is still sending its SESSION_SETUP attempt. Looks like the client is attempting NTLMSSP/NTLMv2 for NICVALIDATION\administrator, and this status is resulting from the authentication and not the SMB protocol.

Microsoft Message Analyzer shows no problem with the packet structure itself, in any case. So this doesn't appear to be a malformed request.

What type of server is this? The NativeOS string is "SpinStream2", which I don't recognize.
 

______________________________________________________________________
This email has been scanned by the Boundary Defense for Email Security System. For more information please visit http://www.apptix.com/email-security/antispam-virus
______________________________________________________________________

______________________________________________________________________
This email has been scanned by the Boundary Defense for Email Security System. For more information please visit http://www.apptix.com/email-security/antispam-virus
______________________________________________________________________
