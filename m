From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] cifs: Add support of Alternate Data Streams
Date: Wed, 10 Oct 2012 13:25:59 -0400
Message-ID: <20121010132559.0634822b@corrin.poochiereds.net>
References: <1349881906-9791-1-git-send-email-shirishpargaonkar@gmail.com>
	<20121010121435.124d9ce5@corrin.poochiereds.net>
	<CADT32eLA3+GpxLDJZq1MTAGLc2fRcQAo4=9G+FKw7HippkLc=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLA3+GpxLDJZq1MTAGLc2fRcQAo4=9G+FKw7HippkLc=w@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 10 Oct 2012 12:22:16 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Oct 10, 2012 at 11:14 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Wed, 10 Oct 2012 10:11:46 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >>
> >> Add support of Alternate Data Streams (ads).
> >>
> >> The generic access flags that cifs client currently employs are sufficient
> >> for alternate data streams as well (MS-CIFS 2.2.4.64.1).
> >>
> >> The stream file and stream type are specified using : after the file name,
> >> so that is used to differentiate between a regular file and its
> >> alternate data streams and stream types.
> >> Since they all have the same file id, each path name,
> >> file name:stream name:stream type, has a separate inode with that same
> >> file id but a distinct private data (path name) in that inode to
> >> distinguish them.
> >>
> >> This scheme applies only to non-posix compliant servers such as Windows.
> >>
> >> One operation that does not work is Rename (0x7).
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >>  fs/cifs/cifsfs.c   |    1 +
> >>  fs/cifs/cifsglob.h |    2 ++
> >>  fs/cifs/inode.c    |   33 ++++++++++++++++++++++++++++++++-
> >>  3 files changed, 35 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> index e7931cc..3068992 100644
> >> --- a/fs/cifs/cifsfs.c
> >> +++ b/fs/cifs/cifsfs.c
> >> @@ -264,6 +264,7 @@ cifs_evict_inode(struct inode *inode)
> >>  {
> >>       truncate_inode_pages(&inode->i_data, 0);
> >>       clear_inode(inode);
> >> +     kfree(inode->i_private);
> >>       cifs_fscache_release_inode_cookie(inode);
> >>  }
> >>
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index f5af252..26d65c7 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -1251,6 +1251,7 @@ struct dfs_info3_param {
> >>  #define CIFS_FATTR_DELETE_PENDING    0x2
> >>  #define CIFS_FATTR_NEED_REVAL                0x4
> >>  #define CIFS_FATTR_INO_COLLISION     0x8
> >> +#define CIFS_FATTR_ALTDATASTR                0x10
> >>
> >>  struct cifs_fattr {
> >>       u32             cf_flags;
> >> @@ -1268,6 +1269,7 @@ struct cifs_fattr {
> >>       struct timespec cf_atime;
> >>       struct timespec cf_mtime;
> >>       struct timespec cf_ctime;
> >> +     char            *cf_private;
> >>  };
> >>
> >>  static inline void free_dfs_info_param(struct dfs_info3_param *param)
> >> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> >> index afdff79..93b010b 100644
> >> --- a/fs/cifs/inode.c
> >> +++ b/fs/cifs/inode.c
> >> @@ -619,6 +619,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
> >>       struct cifs_fattr fattr;
> >>       struct cifs_search_info *srchinf = NULL;
> >>
> >> +     fattr.cf_private = NULL;
> >>       tlink = cifs_sb_tlink(cifs_sb);
> >>       if (IS_ERR(tlink))
> >>               return PTR_ERR(tlink);
> >> @@ -746,14 +747,34 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
> >>       }
> >>
> >>       if (!*inode) {
> >> +             if (strstr(full_path, ":")) {
> >> +                     fattr.cf_private = kstrdup(full_path, GFP_KERNEL);
> >> +                     if (!fattr.cf_private) {
> >> +                             rc = -ENOMEM;
> >> +                             goto cgii_exit;
> >> +                     }
> >> +                     fattr.cf_flags |= CIFS_FATTR_ALTDATASTR;
> >> +             }
> >> +
> >>               *inode = cifs_iget(sb, &fattr);
> >> -             if (!*inode)
> >> +             if (*inode) {
> >> +                     if (strstr(full_path, ":") &&
> >> +                                     !((*inode)->i_flags & S_PRIVATE)) {
> >> +                             (*inode)->i_private = kstrdup(fattr.cf_private,
> >> +                                                     GFP_KERNEL);
> >> +                             if ((*inode)->i_private)
> >> +                                     (*inode)->i_flags |= S_PRIVATE;
> >> +                             else
> >> +                                     rc = -ENOMEM;
> >> +                     }
> >> +             } else
> >>                       rc = -ENOMEM;
> >>       } else {
> >>               cifs_fattr_to_inode(*inode, &fattr);
> >>       }
> >>
> >>  cgii_exit:
> >> +     kfree(fattr.cf_private);
> >>       kfree(buf);
> >>       cifs_put_tlink(tlink);
> >>       return rc;
> >> @@ -784,6 +805,16 @@ cifs_find_inode(struct inode *inode, void *opaque)
> >>       if (S_ISDIR(inode->i_mode) && !hlist_empty(&inode->i_dentry))
> >>               fattr->cf_flags |= CIFS_FATTR_INO_COLLISION;
> >>
> >> +     /* looking for an inode of a alternate data stream (full pathname) */
> >> +     if (fattr->cf_flags & CIFS_FATTR_ALTDATASTR) {
> >> +             if (!(inode->i_flags & S_PRIVATE)) {
> >> +                     return 0;
> >> +             } else {
> >> +                     if (strcmp(inode->i_private, fattr->cf_private))
> >> +                             return 0;
> >> +             }
> >> +     }
> >> +
> >>       return 1;
> >>  }
> >>
> >
> > I have real doubts as to whether this patch is necessary. Here's why:
> >
> > AIUI, the main concern is that you'll open the "normal" data stream on
> > the file, cache a bunch of data. Then, if you open the alternate
> > datastream, the kernel will see that as the same inode -- it'll look
> > like a hardlink. Then when you go to read, you'll get back the cached
> > data from the original datastream instead of the alternate one.
> >
> > The key point that's missing here is that servers do not hand out
> > oplocks for alternate data streams. As long as you've mounted in
> > cache=strict mode (which is the default for 3.7), then there should be
> > no problem at all, right?
> 
> Jeff, where does it say that a server should_not/does_not hand out
> oplocks for an alternate data stream?
> I have looked for such a documentation and have not found.
> The one I read,
>  http://msdn.microsoft.com/en-us/library/cc308443.aspx
> does not mention/preclude alternate data streams from obtaining oplocks.
> 

I believe Jeremy or Chris mentioned it when we were at SDC this year
and I'm cc'ing them here. I don't recall where they said that was
stated.

> >
> > When you go to open the alternate data stream, it won't matter if the
> > original datastream had a bunch of data cached. You'll have no oplock
> > for the file anymore and so you'll if effect be doing DIO to the server
> > for the alternate datastream anyway.
> >
> > The only remaining question I have is whether the servers issue oplock
> > breaks for the "normal" datastream when an alternate datastream is
> > opened. For instance, suppose I do the following pseudocode:
> >
> > normal = open("file", ...);
> >
> > ...server issues an oplock for the open. If I then I do:
> >
> > alternate = open("file:alternate", ...);
> >
> > ...does the server issue an oplock break for the original oplock prior
> > to performing second open?
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> In the above case, server does not issue oplock break for the original oplock.
> 

Pity.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
