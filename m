From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Use file_dentry()
Date: Wed, 20 Apr 2016 23:21:40 -0500
Message-ID: <CADT32eK7N7L1pWjgTejg8Vo8dukX_mhmqz3NDPwG+M3_mcp8YQ@mail.gmail.com>
References: <1460979712-2581-1-git-send-email-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>,
	Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460979712-2581-1-git-send-email-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks correct.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Apr 18, 2016 at 6:41 AM, Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org> wrote:
> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
>
> CIFS may be used as lower layer of overlayfs and accessing f_path.dentry can
> lead to a crash.
>
> Fix by replacing direct access of file->f_path.dentry with the
> file_dentry() accessor, which will always return a native object.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index c03d074..489ddc7 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -271,7 +271,7 @@ struct cifsFileInfo *
>  cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
>                   struct tcon_link *tlink, __u32 oplock)
>  {
> -       struct dentry *dentry = file->f_path.dentry;
> +       struct dentry *dentry = file_dentry(file);
>         struct inode *inode = d_inode(dentry);
>         struct cifsInodeInfo *cinode = CIFS_I(inode);
>         struct cifsFileInfo *cfile;
> @@ -461,7 +461,7 @@ int cifs_open(struct inode *inode, struct file *file)
>         tcon = tlink_tcon(tlink);
>         server = tcon->ses->server;
>
> -       full_path = build_path_from_dentry(file->f_path.dentry);
> +       full_path = build_path_from_dentry(file_dentry(file));
>         if (full_path == NULL) {
>                 rc = -ENOMEM;
>                 goto out;
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index b30a4a6..8806584 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -300,7 +300,7 @@ initiate_cifs_search(const unsigned int xid, struct file *file)
>         cifsFile->invalidHandle = true;
>         cifsFile->srch_inf.endOfSearch = false;
>
> -       full_path = build_path_from_dentry(file->f_path.dentry);
> +       full_path = build_path_from_dentry(file_dentry(file));
>         if (full_path == NULL) {
>                 rc = -ENOMEM;
>                 goto error_exit;
> @@ -759,7 +759,7 @@ static int cifs_filldir(char *find_entry, struct file *file,
>                  */
>                 fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
>
> -       cifs_prime_dcache(file->f_path.dentry, &name, &fattr);
> +       cifs_prime_dcache(file_dentry(file), &name, &fattr);
>
>         ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
>         return !dir_emit(ctx, name.name, name.len, ino, fattr.cf_dtype);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
