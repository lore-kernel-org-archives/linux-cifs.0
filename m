From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 9/9] cifs: ensure we revalidate the inode after
 readdir if cifsacl is enabled
Date: Sun, 25 Nov 2012 20:10:32 -0500
Message-ID: <20121125201032.5cb8193b@corrin.poochiereds.net>
References: <1350649250-5343-1-git-send-email-jlayton@redhat.com>
	<1350649250-5343-10-git-send-email-jlayton@redhat.com>
	<CAH2r5mtWcQXejvFeWOYh0W+3exdMt5Mz0pq-AvNhyHozQRmD+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtWcQXejvFeWOYh0W+3exdMt5Mz0pq-AvNhyHozQRmD+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 25 Nov 2012 14:36:59 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> For the common case of simply "ls" (vs "ls -l") does this affect
> performance (have you double checked)?
> 

I haven't measured it, but it's noticable. There really is no
alternative though -- it's a correctness issue.

> On Fri, Oct 19, 2012 at 7:20 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Otherwise, "ls -l" will simply show the ownership of the files as
> > the default mnt_uid/gid. This may make "ls -l" performance on large
> > directories super-suck in some cases, but that's the cost of cifsacl.
> >
> > One possibility to make it suck less would be to somehow proactively
> > dispatch the ACL requests asynchronously from readdir codepath, but
> > that's non-trivial to implement.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/readdir.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > index f9b5d3d..96fe44b 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -134,6 +134,16 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
> >         if (fattr->cf_cifsattrs & ATTR_READONLY)
> >                 fattr->cf_mode &= ~S_IWUGO;
> >
> > +       /*
> > +        * We of course don't get ACL info in FIND_FIRST/NEXT results, so
> > +        * mark it for revalidation so that "ls -l" will look right. It might
> > +        * be super-slow, but if we don't do this then the ownership of files
> > +        * may look wrong since the inodes may not have timed out by the time
> > +        * "ls" does a stat() call on them.
> > +        */
> > +       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
> > +               fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
> > +
> >         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL &&
> >             fattr->cf_cifsattrs & ATTR_SYSTEM) {
> >                 if (fattr->cf_eof == 0)  {
> > --
> > 1.7.11.7
> >
> 
> 
> 


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
