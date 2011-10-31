From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
 fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Mon, 31 Oct 2011 16:53:35 -0700
Message-ID: <20111031235335.GL18855@google.com>
References: <20111031221743.GA18855@google.com>
 <201111010024.16659.rjw@sisk.pl>
 <CAH2r5msMiG8MjhYuVv8ehqkBLKc1Av3hi+2q6zwrrXdTTa_+YQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msMiG8MjhYuVv8ehqkBLKc1Av3hi+2q6zwrrXdTTa_+YQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

On Mon, Oct 31, 2011 at 06:45:48PM -0500, Steve French wrote:
> >> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> ---
> >> Neil, Steve, do the network filesystems need a way to indicate "I can
> >> either be killed or enter freezer"?
> 
> Probably, yes, but I will defer to Jeff as he has looked
> more recently at these issues.
> 
> I can explain cifs state, and disconnect/reconnection of sessions
> (and smb2 is a little more feature rich in this regard), but will
> let Jeff explain the more subtle points you are getting at.

Hmmm... I'm getting confused.

For nfs, this really is a non-issue.  Either the user wants nointr or
intr behavior.  NFS nointr is rather crazy - it's basically "nothing
can do anything to tasks which is doing NFS IO until it's complete"
and really meant to be used for servers sharing filesystems for /usr,
/home and stuff.  It doesn't make whole lot of sense on systems which
may go suspend and that's why there's intr option.

I suppose the problem is that cifs doesn't know how to do 'intr' yet,
right?  If that really is the problem, the correct long term solution
would be implementing proper intr behavior and it doesn't make any
sense to push this type of change to PM core to for short term
workaround.  Just use prepare_to_wait() / schedule() / finish_wait()
directly w/ INTERRUPTIBLE sleep and don't break out of wait loop on
signal_pending().  If this should be used in multiple places, write up
a wait_event_XXX() wrapper.  There is absolutely no reason to change
wakeup condition.

Thank you.

-- 
tejun
