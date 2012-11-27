From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Terminate 5 minute timeout for CIFS mount to missing server in
 stab?
Date: Tue, 27 Nov 2012 06:20:51 -0500
Message-ID: <20121127062051.382b5462@tlielax.poochiereds.net>
References: <1296DFE4-00F0-43E0-A554-1414D53F077D@exacq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matthew M. DeLoera" <mdeloera-CERpylIU+L8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296DFE4-00F0-43E0-A554-1414D53F077D-CERpylIU+L8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 26 Nov 2012 22:06:02 -0500
"Matthew M. DeLoera" <mdeloera-CERpylIU+L8AvxtiuMwx3w@public.gmane.org> wrote:

> Hello,
> 
> I searched the archive but only found some discussion regarding "wait indefinitely for responses" from 2010. I hope this isn't a redundant question!
> 
> I have a CIFS entry in my fstab to a remote server on my VPN, so it's not available when I'm not connected to my VPN. When not connected, mount -a hangs for about 5 minutes before finally failing with "connection timed out". If I connect my VPN in the middle of that wait, and verify it's connected, mount still hangs for that entire timeout before failing. If I try again, it succeeds.
> 
> Is there any issue with kill -9 for the mount -a process, in order to more quickly retry? I was planning to automate it, and to keep retrying until mount succeeds.
> 
> Basically, I need quicker failure than 5 minutes, and I can't find any CIFS timeout settings. Any suggestions would be greatly appreciated!
> 
> Thanks,
> - Matthew
> 
> 
> 
> 

What kernel is this? kill -9'ing the process likely won't hurt
anything, but it's not really a great solution.

That doesn't sound related to the fact that we wait indefinitely for
responses since the connection is presumably not even established yet.

cifs.ko is a fairly naive user of the socket APIs in the kernel and
does a blocking connect call to connect to the socket. That said, it
should be timing out a lot more quickly than that:

        socket->sk->sk_rcvtimeo = 7 * HZ;
        socket->sk->sk_sndtimeo = 5 * HZ;

A connect attempt shouldn't be hanging for 5 minutes. I'd suggest doing
a bit more investigation -- track down the [cifsd] kthread and see what
it's doing at the time. Something like:

    # cat /proc/$(pidof cifsd)/stack


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
