From: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Subject: Re: [PATCH 1/4] freezer: make fake_signal_wake_up wake TASK_KILLABLE tasks too
Date: Tue, 11 Oct 2011 21:14:28 +0200
Message-ID: <201110112114.28478.rjw@sisk.pl>
References: <1317210761-11518-1-git-send-email-jlayton@redhat.com> <20111011061847.GB1377@ucw.cz> <20111011061000.3a3a03fe@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	john-HpsXz0BELY4AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111011061000.3a3a03fe-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Tuesday, October 11, 2011, Jeff Layton wrote:
> On Tue, 11 Oct 2011 08:18:48 +0200
> Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org> wrote:
> 
> > 
> > Hi!
> > 
> > > TASK_KILLABLE is often used to put tasks to sleep for quite some time.
> > > One of the most common uses is to put tasks to sleep while waiting for
> > > replies from a server on a networked filesystem (such as CIFS or NFS).
> > > 
> > > Unfortunately, fake_signal_wake_up does not currently wake up tasks
> > > that are sleeping in TASK_KILLABLE state. This means that even if the
> > > code were in place to allow them to freeze while in this sleep, it
> > > wouldn't work anyway.
> > > 
> > > This patch changes this function to wake tasks in this state as well.
> > > This should be harmless -- if the code doing the sleeping doesn't have
> > > handling to deal with freezer events, it should just go back to sleep.
> > 
> > I'm pretty sure this will break something; but that does not mean it
> > is bad idea, just that it should be merged early and tested a lot.
> > 
> 
> FWIW, I looked at most of the places in the kernel that do
> TASK_KILLABLE sleeps and they look like they'll handle this correctly.
> The main one I wasn't sure about was mem_cgroup_handle_oom(), but I
> think it'll do the right thing too. I certainly could have missed
> something though...
> 
> In any case, would you mind merging this via the linux-pm tree for 3.2?

I will push it for 3.2.

Thanks,
Rafael
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
