From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: set FILE_CREATED
Date: Thu, 12 Dec 2013 09:05:51 -0600
Message-ID: <CADT32eLk7f=pdsZ4o7-WVWUSmMF8OQRnECKuwdjOhhxTW=rbug@mail.gmail.com>
References: <1386800993-4250-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386800993-4250-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Some corrections in patch description...

Set FILE_CREATED on O_CREAT|O_EXCL.

cifs code didn't change during commit 116cc0225381415b96551f725455d067f63a76a0

kernel bugzilla 66251

On Wed, Dec 11, 2013 at 4:29 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Set FILE_CREATED on O_CREAT|O_EXCL.
>
> cifs code didn't change during commit 116cc0225381415b96551f725455d067f63a76a0e
>
> Samba bugzilla 66251
>
> Signed-off-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/dir.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 11ff5f1..a514e0a 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -193,7 +193,7 @@ check_name(struct dentry *direntry)
>  static int
>  cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
>                struct tcon_link *tlink, unsigned oflags, umode_t mode,
> -              __u32 *oplock, struct cifs_fid *fid, int *created)
> +              __u32 *oplock, struct cifs_fid *fid)
>  {
>         int rc = -ENOENT;
>         int create_options = CREATE_NOT_DIR;
> @@ -349,7 +349,6 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
>                                 .device = 0,
>                 };
>
> -               *created |= FILE_CREATED;
>                 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
>                         args.uid = current_fsuid();
>                         if (inode->i_mode & S_ISGID)
> @@ -480,13 +479,16 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
>         cifs_add_pending_open(&fid, tlink, &open);
>
>         rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
> -                           &oplock, &fid, opened);
> +                           &oplock, &fid);
>
>         if (rc) {
>                 cifs_del_pending_open(&open);
>                 goto out;
>         }
>
> +       if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
> +               *opened |= FILE_CREATED;
> +
>         rc = finish_open(file, direntry, generic_file_open, opened);
>         if (rc) {
>                 if (server->ops->close)
> @@ -529,7 +531,6 @@ int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
>         struct TCP_Server_Info *server;
>         struct cifs_fid fid;
>         __u32 oplock;
> -       int created = FILE_CREATED;
>
>         cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %s and dentry = 0x%p\n",
>                  inode, direntry->d_name.name, direntry);
> @@ -546,7 +547,7 @@ int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
>                 server->ops->new_lease_key(&fid);
>
>         rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
> -                           &oplock, &fid, &created);
> +                           &oplock, &fid);
>         if (!rc && server->ops->close)
>                 server->ops->close(xid, tcon, &fid);
>
> --
> 1.8.3.2
>
