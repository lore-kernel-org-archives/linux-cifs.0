From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mount failure due to restricted access to a point along the mount path
Date: Mon, 4 Feb 2013 13:55:07 -0600
Message-ID: <CAH2r5mtip2FT5BBdfYEZvtDFyqMDL906iAqT_r0-2XAac5DszQ@mail.gmail.com>
References: <510FD4FD.3010001@suse.com>
	<20130204144152.1c839176@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130204144152.1c839176-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 4, 2013 at 1:41 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Mon, 04 Feb 2013 21:04:21 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
>
> > Hi all,
> >
> > I have been looking at the $SUBJECT. And there is already a bug reported
> > in the samba.org bugzilla
> >
> > https://bugzilla.samba.org/show_bug.cgi?id=8950
> >
> > cifs gets "Access denied" while trying to get the root inode. Suppose if
> > you are trying to mount /share/dir/subdir and if the user doesn't have
> > access to any of point along the path ie. /share or /dir, mount will
> > fail.
> >
> > As noted by Jeff Layton in the bug report, this seems to be a known
> > problem since we started using the shared superblock model. Though we
> > can work around this problem by providing neccessary permissions for the
> > entire path, users consider this as a regression. I tend to agree with
> > them and think that may be we should have addressed this problem before
> > pushing the shared superblock changes.
> >
> > From the changelog it appears that this results in better performance
> > when we use SMB2.1 leases. How much better performance we are seeing?
> > Is that worth living with this regression?
> >
> > Does this affect the CIFS users who are not using SMB2.1 in anyway?
> >
> >
> > Thanks
> >
>
> Well, more than that, it's a cache coherency thing. If you have an
> inode that's reachable via 2 mounts, you want the caches to be coherent
> between the two. Note that superblock sharing was a requirement for the
> fscache patches NFS, so I was never clear why that wasn't the case for
> CIFS...
>
> In any case, yes this is a problem regardless of CIFS version in use.
>
> What we probably ought to do is come up with a way to instantiate the
> intermediate dentries with "dummy" inodes at mount time. Those will need
> to be revalidated (and rehashed) if they ever come to life suddenly
> though.

Agreed


--
Thanks,

Steve
