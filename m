From: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Thu, 3 Nov 2011 00:11:23 +0100
Message-ID: <201111030011.24062.rjw@sisk.pl>
References: <20111101041337.39077229@tlielax.poochiereds.net> <20111101215710.GA13803@google.com> <20111102162331.GA31947@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111102162331.GA31947-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wednesday, November 02, 2011, Oleg Nesterov wrote:
> Hi,
> 
> On 11/01, Tejun Heo wrote:
> >
> > For now, let's go with the count/dont_count.  Can you please write up
> > a patch for that?  Jeff, does this seem okay to you?
> 
> OK, will do in a minute. On top of
> "[PATCH pm] freezer: fix wait_event_freezable/__thaw_task races"
> you sent. (btw, thanks, I forgout about it ;)
> 
> Rafael, could you remind why freezer_do_not_count/freezer_count check
> ->mm != NULL ?

You're asking difficult questions. ;-)

The intention was to prevent PF_FREEZER_SKIP from having any effect on
kernel threads, IIRC.  Anyway, there are only two legitimate users of it
(vfork and apm_ioctl) and in both cases the task in question is user space.

> The comment says "However, we don't want kernel threads to be frozen",
> but it is not clear anyway. A kernel thread simply shouldn't use this
> interface if it doesn't want to freeze.
> 
> And in any case, PF_KTHREAD looks better if we really need to filter
> out the kernel threads.

PF_FREEZER_SKIP was introduced specifically with vfork in mind and I'm not
sure if it's a good idea to re-use it for something else (at least not for
something entirely obvious).

Thanks,
Rafael
