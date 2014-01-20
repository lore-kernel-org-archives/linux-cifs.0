From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Problem with connecting to SMB server in 3.9.11 kernel.
Date: Mon, 20 Jan 2014 07:56:57 -0500
Message-ID: <20140120075657.0e61ecb2@tlielax.poochiereds.net>
References: <52DAB72C.9030305@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"Amit Haval (India Bangalore)" <amit.haval-ZIEO9HjW1UBWk0Htik3J/w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52DAB72C.9030305-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 18 Jan 2014 09:17:32 -0800
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:

> Hello!
> 
> A customer reported problems connecting our CIFS traffic generation test gear to their SMB server.
> We are using the 3.9.11+ kernel, and though it is patched, we do not have any
> patches to cifs.
> 
> The OS is Fedora 14, 64-bit.
> 
> A similar system on Fedora 14, with a 3.7.10+ kernel was working, but when
> we tried the 3.7.10+ kernel on the broken machine, it also failed to work.
> So, it could be the SMB server itself is having issues.  (In the 3.7.10+ failure,
> the server just failed to respond after "Setup andX Request AUTH message", though we
> did get the TCP ack so it looks like the message was received by the server.)
> 
> I'm attaching a capture taken on the SMB server.
> 
>  From looking at this page:
> 
> http://msdn.microsoft.com/en-us/library/ff469913.aspx
> 
> It appears the problem (STATUS_UNSUCCESSFUL) is:
> 
> "The size of the extended attribute list is not correct. Check the EaErrorOffset field for the
> address of the SMB_GEA structure at which the error was detected."
> 
> I did not see anything about extended attribute list in the capture, but if someone else
> with more knowledge could take a look and see if they notice any problems I would be grateful.
> 
> Thanks!
> Ben
> 

There's no EA list on this call so that description isn't valid here.

AIUI, NT_STATUS_UNSUCCESSFUL is basically a generic "something went
wrong" error (sort of like EIO on POSIX). It looks like the server
doesn't like something about the request being sent, but it's tough to
know what it is.

I cc'ed Shirish though as he wrote most of that code. Maybe he has some
idea?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
