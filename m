From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: set up recurring workqueue job to do SMB echo
 requests
Date: Thu, 20 Jan 2011 13:19:31 -0500
Message-ID: <20110120131931.5b279248@barsoom.rdu.redhat.com>
References: <AANLkTikm7wx097fm-u05ZB9P1fpCsK4=WNM0i5-7nToq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikm7wx097fm-u05ZB9P1fpCsK4=WNM0i5-7nToq-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 20 Jan 2011 11:51:59 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I have merged this patch, but I agree with the hint in the comment
> below - given all of the complaints about "chattiness" of Windows cifs
> behavior, we need to allow this to be tuned for slow WANs in
> subsequent patch.
> 
> +/* SMB echo "timeout" -- FIXME: tunable? */
> +#define SMB_ECHO_INTERVAL (60 * HZ)
> 
> Had you made a patch for that?  If not, I can easily put something
> together.   Problem is it is a link issue not a "system-wide" issue so
> probably needs to be mount option (and we have a lot of these, and
> this would not be a commonly used one)
> 

No, I haven't made a patch for that. It seems like 1 (tiny) echo ping
per minute is entirely reasonable, even on a slow WAN. According to
MS-CIFS:

"Clients SHOULD, at minimum, send an SMB_COM_ECHO to the server every
few minutes."

The next patch in the series adds the "echo_retries" parameter, which
is more likely what you'll want to tune on a slow WAN.

Note that you can't make this a mount option unless you also want to
force the client to use a new socket when its setting doesn't match an
existing one.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
