From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] cifs: Allow directIO read/write during cache=strict
Date: Fri, 22 Aug 2014 11:13:37 -0500
Message-ID: <CAH2r5mvy0ctR60QS1XFTrLS3tsA8UcQYQ8RKEAt=p1LQ0hSTCg@mail.gmail.com>
References: <000001cfbdc9$1ea5eb20$5bf1c160$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000001cfbdc9$1ea5eb20$5bf1c160$@samsung.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Fri, Aug 22, 2014 at 12:22 AM, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
> Currently cifs have all or nothing approach for directIO operations.
> cache=strict mode does not allow directIO while cache=none mode performs
> all the operations as directIO even when user does not specify O_DIRECT
> flag. This patch enables strict cache mode to honour directIO semantics.
>
> Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
> *Changelog
>  v2:
>   - Also consider CIFS_MOUNT_NO_BRL flag.
>
>  fs/cifs/dir.c  |    8 ++++++++
>  fs/cifs/file.c |    8 ++++++++
>  2 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 3db0c5f..6cbd9c6 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -497,6 +497,14 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
>                 goto out;
>         }
>
> +       if (file->f_flags & O_DIRECT &&
> +           CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
> +               if (CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
> +                       file->f_op = &cifs_file_direct_nobrl_ops;
> +               else
> +                       file->f_op = &cifs_file_direct_ops;
> +               }
> +
>         file_info = cifs_new_fileinfo(&fid, file, tlink, oplock);
>         if (file_info == NULL) {
>                 if (server->ops->close)
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index bee733e..2e3720f 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -467,6 +467,14 @@ int cifs_open(struct inode *inode, struct file *file)
>         cifs_dbg(FYI, "inode = 0x%p file flags are 0x%x for %s\n",
>                  inode, file->f_flags, full_path);
>
> +       if (file->f_flags & O_DIRECT &&
> +           cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
> +               if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
> +                       file->f_op = &cifs_file_direct_nobrl_ops;
> +               else
> +                       file->f_op = &cifs_file_direct_ops;
> +       }
> +
>         if (server->oplocks)
>                 oplock = REQ_OPLOCK;
>         else
> --
> 1.7.7
>



-- 
Thanks,

Steve
