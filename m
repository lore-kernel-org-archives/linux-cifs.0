From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH 1/4] freezer: make fake_signal_wake_up wake
 TASK_KILLABLE tasks too
Date: Tue, 11 Oct 2011 08:18:48 +0200
Message-ID: <20111011061847.GB1377@ucw.cz>
References: <1317210761-11518-1-git-send-email-jlayton@redhat.com>
 <1317210761-11518-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org,
	linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john-D0fwSNaahy58zQARNC3f2A@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1317210761-11518-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Hi!

> TASK_KILLABLE is often used to put tasks to sleep for quite some time.
> One of the most common uses is to put tasks to sleep while waiting for
> replies from a server on a networked filesystem (such as CIFS or NFS).
> 
> Unfortunately, fake_signal_wake_up does not currently wake up tasks
> that are sleeping in TASK_KILLABLE state. This means that even if the
> code were in place to allow them to freeze while in this sleep, it
> wouldn't work anyway.
> 
> This patch changes this function to wake tasks in this state as well.
> This should be harmless -- if the code doing the sleeping doesn't have
> handling to deal with freezer events, it should just go back to sleep.

I'm pretty sure this will break something; but that does not mean it
is bad idea, just that it should be merged early and tested a lot.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
