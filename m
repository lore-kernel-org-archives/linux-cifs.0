From: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Subject: Re: [PATCH 0/4] allow freezing of tasks with netfs calls in flight
Date: Tue, 11 Oct 2011 21:19:06 +0200
Message-ID: <201110112119.06547.rjw@sisk.pl>
References: <1317210761-11518-1-git-send-email-jlayton@redhat.com> <20111011061819.GA1377@ucw.cz> <20111011060531.09bc378a@tlielax.poochiereds.net>
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
In-Reply-To: <20111011060531.09bc378a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Tuesday, October 11, 2011, Jeff Layton wrote:
> On Tue, 11 Oct 2011 08:18:19 +0200
> Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org> wrote:
> 
> > Hi!
> > 
> > > We've had a number of reports recently of people with NFS and CIFS
> > > mounts that were unable to suspend or hibernate their machines. Here
> > > are a couple of Fedora bugs that illustrate the problem:
> > > 
> > >     https://bugzilla.redhat.com/show_bug.cgi?id=712088
> > >     https://bugzilla.redhat.com/show_bug.cgi?id=717735
> > > 
> > > When it occurs the problem is pretty clear. We have a task that's
> > > sleeping in the kernel in TASK_KILLABLE sleep, generally waiting
> > > for a reply to come in. Often though, userspace has already taken
> > > down the interface so that reply will never come. The process then
> > > fails to freeze and the suspend fails.
> > 
> > Userspace should not take interface down for suspend (*). Why do that?
> > 
> 
> I suspect that NetworkManager does this to try and allow for the case
> where someone suspends their laptop and then wanders off to another
> network and then resumes.

That's correct.

> Either way, we still want to allow suspend and hibernate to work regardless
> of what userspace does during the process.

Very true. :-)

Thanks,
Rafael
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
