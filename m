From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH 2/7] cifs: Allow directIO read/write during cache=strict
Date: Thu, 21 Aug 2014 19:07:31 +0900
Message-ID: <002b01cfbd27$b8c00580$2a401080$@samsung.com>
References: <003501cfbc62$fac9f4b0$f05dde10$@samsung.com>
 <CAH2r5mvn86=76_O7QT0WMftjnr3Ek4t5PiqcWCy1HpaKVO=GFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: 'Shirish Pargaonkar' <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	'Pavel Shilovsky' <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	'Ashish Sangwan' <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: 'Steve French' <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <CAH2r5mvn86=76_O7QT0WMftjnr3Ek4t5PiqcWCy1HpaKVO=GFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-language: ko
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> 
> What if a file is opened twice - once with o_direct and once without?
> what happens?
IMHO nothing bad happens.
Per file file->fop is initialized to inode->i_fop in do_dentry_open.
We are not changing inode->i_fop, so they still point to cached file operations.
The file which is open with O_DIRECT will get its fop changed to
cifs_file_direct_ops while the other file can still use cifs_file_strict_ops.
Also, while checking, I notice that additional check for CIFS_MOUNT_NO_BRL is
needed.
if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
        inode->i_fop = &cifs_file_direct_nobrl_ops;
else
        inode->i_fop = &cifs_file_direct_ops;
If there is no objection, I will send v2 included above additional check.

Thanks.
> 
> On Wed, Aug 20, 2014 at 5:39 AM, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
> > Currently cifs have all or nothing approach for directIO operations.
> > cache=strict mode does not allow directIO while cache=none mode performs
> > all the operations as directIO even when user does not specify O_DIRECT
> > flag. This patch enables strict cache mode to honour directIO semantics.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> > Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> > ---
> >  fs/cifs/dir.c  |    4 ++++
> >  fs/cifs/file.c |    4 ++++
> >  2 files changed, 8 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> > index 3db0c5f..30e377c 100644
> > --- a/fs/cifs/dir.c
> > +++ b/fs/cifs/dir.c
> > @@ -497,6 +497,10 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
> >                 goto out;
> >         }
> >
> > +       if (file->f_flags & O_DIRECT &&
> > +           CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
> > +               file->f_op = &cifs_file_direct_ops;
> > +
> >         file_info = cifs_new_fileinfo(&fid, file, tlink, oplock);
> >         if (file_info == NULL) {
> >                 if (server->ops->close)
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index bee733e..0d07740 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -467,6 +467,10 @@ int cifs_open(struct inode *inode, struct file *file)
> >         cifs_dbg(FYI, "inode = 0x%p file flags are 0x%x for %s\n",
> >                  inode, file->f_flags, full_path);
> >
> > +       if (file->f_flags & O_DIRECT &&
> > +           cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
> > +               file->f_op = &cifs_file_direct_ops;
> > +
> >         if (server->oplocks)
> >                 oplock = REQ_OPLOCK;
> >         else
> > --
> > 1.7.7
> >
> 
> 
> 
> --
> Thanks,
> 
> Steve
