From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Terminate 5 minute timeout for CIFS mount to missing server in
 stab?
Date: Tue, 27 Nov 2012 12:27:31 -0500
Message-ID: <20121127122731.6b01cf2f@tlielax.poochiereds.net>
References: <1296DFE4-00F0-43E0-A554-1414D53F077D@exacq.com>
	<20121127062051.382b5462@tlielax.poochiereds.net>
	<811AE6D4-30BA-44CF-9D8E-D5DA4FD24115@exacq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matthew M. DeLoera" <mdeloera-CERpylIU+L8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <811AE6D4-30BA-44CF-9D8E-D5DA4FD24115-CERpylIU+L8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 27 Nov 2012 08:58:41 -0500
"Matthew M. DeLoera" <mdeloera-CERpylIU+L8AvxtiuMwx3w@public.gmane.org> wrote:

> I'm testing in an older kernel - 2.6.15-55-386. While mount sits and waits, I see cifsoplockd and cifsnotifyd, but no cifsd. And no /proc/PID/stack for either. When I kill mount -a, both of those cifs daemons remain running (both sleeping).
> 
> I then tried later 2.6.24-24-generic kernel and got same behavior.
> 
> Either way, for the record, cifsnotifyd was already running. Once I started mount, then cifsoplockd started.
> 
> Now in an even newer kernel, 2.6.32-15.generic, I get much quicker timeout - just over 30 seconds.
> 
> I still have to work with the older kernels I mentioned, though I'm glad to see the behavior in 32-15. And FYI, I never saw cifsd running in 32-15.
> 
> Agreed about kill -9. It seems like cifs timeout behavior must have changed along the way, but my kernels span about 6 years, so that doesn't surprise me. But since I am still stuck with the older kernels I mentioned, is there something better that I could do, or just settle for kill -9 and allow enough time for newer kernels to timeout? Is there a way that I might be able to detect what timeout value I might expect?
> 
> Cheers,
> - Matthew
> 
> 

Strange...cifsd is the demultiplex thread that handles the receive
path. It usually also handles connecting the socket, but I don't recall
if that was always the case as far back as 2.6.15...

In any case, I think your choices boil down to backporting patches to
lower the timeouts, or somehow working around the problem in userspace.

If you know that the thing won't be mountable at boot time, you can
always set it up as a "noauto" mount and simply mount it by hand when
you know the connection is there.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
