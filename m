From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH v2 0/9] cifs: second pile of cleanups for cifsacl
Date: Fri, 19 Oct 2012 15:19:02 -0500
Message-ID: <CAH2r5muERfzBdGVCmG6K=DUfht_79qOPBL6-RhhvfJkWDXVZGw@mail.gmail.com>
References: <1350649250-5343-1-git-send-email-jlayton@redhat.com>
	<CAH2r5mvZnZiq4kf2eVE_bJ9GDzQhktQLweApt1J5FkS9kusO0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvZnZiq4kf2eVE_bJ9GDzQhktQLweApt1J5FkS9kusO0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, Oct 19, 2012 at 3:18 PM
Subject: Re: [PATCH v2 0/9] cifs: second pile of cleanups for cifsacl
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


These are in cifs-2.6.git for-next now.   Are there any patches in your
recent patch sets that you (or others) don't want going in until the
following release?

On Fri, Oct 19, 2012 at 7:20 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> This patchset is a respin of the second pile of cleanups for the cifsacl
> code. Most of the changes to the already-sent patches are pretty minor
> cleanups and such.
>
> The last two patches in the series are new. The first adds a timeout to
> the idmap keys so that they can eventually work their way out of the
> cache. The second fixes an existing bug that caused "ls -l" to show the
> ownership wrong when cifsacl is used.
>
> With this set, everything seems to work as expected. Steve, could you
> pull these into your for-next branch soon so we can get them some
> testing exposure?
>
> Jeff Layton (9):
>   cifs: make cifs_copy_sid handle a source sid with variable size
>     subauth arrays
>   cifs: redefine NUM_SUBAUTH constant from 5 to 15
>   cifs: fix the format specifiers in sid_to_str
>   cifs: remove uneeded __KERNEL__ block from cifsacl.h
>   cifs: simplify id_to_sid and sid_to_id mapping code
>   cifs: avoid extra allocation for small cifs.idmap keys
>   cifs: don't override the uid/gid in getattr when cifsacl is enabled
>   cifs: set a timeout on keys in cifs.idmap cache
>   cifs: ensure we revalidate the inode after readdir if cifsacl is
>     enabled
>
>  fs/cifs/cifsacl.c   | 573
> ++++++++++++----------------------------------------
>  fs/cifs/cifsacl.h   |  49 ++---
>  fs/cifs/cifsfs.c    |   1 -
>  fs/cifs/cifsproto.h |   1 -
>  fs/cifs/inode.c     |   7 +-
>  fs/cifs/readdir.c   |  10 +
>  6 files changed, 161 insertions(+), 480 deletions(-)
>
> --
> 1.7.11.7
>



--
Thanks,

Steve



--
Thanks,

Steve
