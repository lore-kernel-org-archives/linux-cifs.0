From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/8] cifs: We do not drop reference to tlink in
 CIFSCheckMFSymlink()
Date: Mon, 09 Dec 2013 16:23:38 +0000
Message-ID: <1386606218.2700.9.camel@sachin-laptop>
References: <1385399395-19217-1-git-send-email-sprabhu@redhat.com>
	 <1385399395-19217-2-git-send-email-sprabhu@redhat.com>
	 <CAH2r5mufmo9P_qaM7g8zRtPxKW9yaZ+HMba21PUUw9odXEpzGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mufmo9P_qaM7g8zRtPxKW9yaZ+HMba21PUUw9odXEpzGg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2013-12-09 at 09:37 -0600, Steve French wrote:
> This looks like the only one small enough to merge for 3.13 (and I put
> in cifs-2.6.git for-next).  The others in the series for 3.14.
>  Opinions?
> 

That's fine. The other code is mostly code cleanup which can be fixed to
the next version and a bug which isn't very high on the priority list.

Sachin Prabhu

> 
> On Mon, Nov 25, 2013 at 11:09 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
>         When we obtain tcon from cifs_sb, we use cifs_sb_tlink() to
>         first obtain
>         tlink which also grabs a reference to it. We do not drop this
>         reference
>         to tlink once we are done with the call.
>         
>         The patch fixes this issue by instead passing tcon as a
>         parameter and
>         avoids having to obtain a reference to the tlink. A lookup for
>         the tcon
>         is already made in the calling functions and this way we avoid
>         having to
>         re-run the lookup. This is also consistent with the argument
>         list for
>         other similar calls for M-F symlinks.
>         
>         We should also return an ENOSYS when we do not find a protocol
>         specific
>         function to lookup the MF Symlink data.
>         
>         Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>         ---
>          fs/cifs/cifsproto.h |  7 ++++---
>          fs/cifs/inode.c     |  6 ++++--
>          fs/cifs/link.c      | 26 +++++++++++---------------
>          3 files changed, 19 insertions(+), 20 deletions(-)
>         
>         diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>         index aa33976..2c29db6 100644
>         --- a/fs/cifs/cifsproto.h
>         +++ b/fs/cifs/cifsproto.h
>         @@ -477,9 +477,10 @@ extern int CIFSGetExtAttr(const unsigned
>         int xid, struct cifs_tcon *tcon,
>                                 const int netfid, __u64 *pExtAttrBits,
>         __u64 *pMask);
>          extern void cifs_autodisable_serverino(struct cifs_sb_info
>         *cifs_sb);
>          extern bool CIFSCouldBeMFSymlink(const struct cifs_fattr
>         *fattr);
>         -extern int CIFSCheckMFSymlink(struct cifs_fattr *fattr,
>         -               const unsigned char *path,
>         -               struct cifs_sb_info *cifs_sb, unsigned int
>         xid);
>         +extern int CIFSCheckMFSymlink(unsigned int xid, struct
>         cifs_tcon *tcon,
>         +                             struct cifs_sb_info *cifs_sb,
>         +                             struct cifs_fattr *fattr,
>         +                             const unsigned char *path);
>          extern int mdfour(unsigned char *, unsigned char *, int);
>          extern int E_md4hash(const unsigned char *passwd, unsigned
>         char *p16,
>                                 const struct nls_table *codepage);
>         diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>         index 36f9ebb..49719b8 100644
>         --- a/fs/cifs/inode.c
>         +++ b/fs/cifs/inode.c
>         @@ -383,7 +383,8 @@ int cifs_get_inode_info_unix(struct inode
>         **pinode,
>         
>                 /* check for Minshall+French symlinks */
>                 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
>         {
>         -               int tmprc = CIFSCheckMFSymlink(&fattr,
>         full_path, cifs_sb, xid);
>         +               int tmprc = CIFSCheckMFSymlink(xid, tcon,
>         cifs_sb, &fattr,
>         +                                              full_path);
>                         if (tmprc)
>                                 cifs_dbg(FYI, "CIFSCheckMFSymlink: %d
>         \n", tmprc);
>                 }
>         @@ -799,7 +800,8 @@ cifs_get_inode_info(struct inode **inode,
>         const char *full_path,
>         
>                 /* check for Minshall+French symlinks */
>                 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
>         {
>         -               tmprc = CIFSCheckMFSymlink(&fattr, full_path,
>         cifs_sb, xid);
>         +               tmprc = CIFSCheckMFSymlink(xid, tcon, cifs_sb,
>         &fattr,
>         +                                          full_path);
>                         if (tmprc)
>                                 cifs_dbg(FYI, "CIFSCheckMFSymlink: %d
>         \n", tmprc);
>                 }
>         diff --git a/fs/cifs/link.c b/fs/cifs/link.c
>         index cc02347..92aee08 100644
>         --- a/fs/cifs/link.c
>         +++ b/fs/cifs/link.c
>         @@ -354,34 +354,30 @@ open_query_close_cifs_symlink(const
>         unsigned char *path, char *pbuf,
>         
>         
>          int
>         -CIFSCheckMFSymlink(struct cifs_fattr *fattr,
>         -                  const unsigned char *path,
>         -                  struct cifs_sb_info *cifs_sb, unsigned int
>         xid)
>         +CIFSCheckMFSymlink(unsigned int xid, struct cifs_tcon *tcon,
>         +                  struct cifs_sb_info *cifs_sb, struct
>         cifs_fattr *fattr,
>         +                  const unsigned char *path)
>          {
>         -       int rc = 0;
>         +       int rc;
>                 u8 *buf = NULL;
>                 unsigned int link_len = 0;
>                 unsigned int bytes_read = 0;
>         -       struct cifs_tcon *ptcon;
>         
>                 if (!CIFSCouldBeMFSymlink(fattr))
>                         /* it's not a symlink */
>                         return 0;
>         
>                 buf = kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
>         -       if (!buf) {
>         -               rc = -ENOMEM;
>         -               goto out;
>         -       }
>         +       if (!buf)
>         +               return -ENOMEM;
>         
>         -       ptcon = tlink_tcon(cifs_sb_tlink(cifs_sb));
>         -       if ((ptcon->ses) &&
>         (ptcon->ses->server->ops->query_mf_symlink))
>         -               rc =
>         ptcon->ses->server->ops->query_mf_symlink(path, buf,
>         -                                                &bytes_read,
>         cifs_sb, xid);
>         +       if (tcon->ses->server->ops->query_mf_symlink)
>         +               rc =
>         tcon->ses->server->ops->query_mf_symlink(path, buf,
>         +                                               &bytes_read,
>         cifs_sb, xid);
>                 else
>         -               goto out;
>         +               rc = -ENOSYS;
>         
>         -       if (rc != 0)
>         +       if (rc)
>                         goto out;
>         
>                 if (bytes_read == 0) /* not a symlink */
>         --
>         1.8.3.1
>         
>         --
>         To unsubscribe from this list: send the line "unsubscribe
>         linux-cifs" in
>         the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>         More majordomo info at
>          http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
