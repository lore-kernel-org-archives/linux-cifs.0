From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/9] cifs: second pile of cleanups for cifsacl
Date: Mon, 29 Oct 2012 10:25:32 -0500
Message-ID: <CAH2r5mu9K=Btemz0bT7B_cSjJ2mu80-Mt_mzUyfvMPAwzj3rpA@mail.gmail.com>
References: <1350649250-5343-1-git-send-email-jlayton@redhat.com>
	<20121029073152.2148f03b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121029073152.2148f03b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 29, 2012 at 6:31 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Fri, 19 Oct 2012 08:20:41 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> > This patchset is a respin of the second pile of cleanups for the cifsacl
> > code. Most of the changes to the already-sent patches are pretty minor
> > cleanups and such.
> >
> > The last two patches in the series are new. The first adds a timeout to
> > the idmap keys so that they can eventually work their way out of the
> > cache. The second fixes an existing bug that caused "ls -l" to show the
> > ownership wrong when cifsacl is used.
> >
> > With this set, everything seems to work as expected. Steve, could you
> > pull these into your for-next branch soon so we can get them some
> > testing exposure?
> >
> > Jeff Layton (9):
> >   cifs: make cifs_copy_sid handle a source sid with variable size
> >     subauth arrays
> >   cifs: redefine NUM_SUBAUTH constant from 5 to 15
> >   cifs: fix the format specifiers in sid_to_str
> >   cifs: remove uneeded __KERNEL__ block from cifsacl.h
> >   cifs: simplify id_to_sid and sid_to_id mapping code
> >   cifs: avoid extra allocation for small cifs.idmap keys
> >   cifs: don't override the uid/gid in getattr when cifsacl is enabled
> >   cifs: set a timeout on keys in cifs.idmap cache
> >   cifs: ensure we revalidate the inode after readdir if cifsacl is
> >     enabled
> >
> >  fs/cifs/cifsacl.c   | 573
> > ++++++++++++----------------------------------------
> >  fs/cifs/cifsacl.h   |  49 ++---
> >  fs/cifs/cifsfs.c    |   1 -
> >  fs/cifs/cifsproto.h |   1 -
> >  fs/cifs/inode.c     |   7 +-
> >  fs/cifs/readdir.c   |  10 +
> >  6 files changed, 161 insertions(+), 480 deletions(-)
> >
>
> Hi Steve,
>
> I've got an updated version of this patchset in my tree. Most of the
> change are pretty minor, the main one being that I dropped this patch
> from the set:
>
>     cifs: set a timeout on keys in cifs.idmap cache
>
> ...as I think it's better to let the userspace program decide this
> timeout.
>
> In any case, the new series is in my cifs-next branch. I think it would
> be best to drop the cifsacl patches you have in your for-next branch
> and pull these instead. Sound ok?

Yes - makes sense


--
Thanks,

Steve
