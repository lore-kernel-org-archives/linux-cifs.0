From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Fix wrong directory attributes after rename
Date: Mon, 18 Aug 2014 22:34:20 -0500
Message-ID: <CAH2r5muGkPPvuqLFhnkWnv447ZpLaie3KGO9ihXvt_3Nfvr4OA@mail.gmail.com>
References: <1408380598-11737-1-git-send-email-pshilovsky@samba.org> <1408380598-11737-2-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408380598-11737-2-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The two patches have been merged into cifs-2.6.git for-next

On Mon, Aug 18, 2014 at 11:49 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> When we requests rename we also need to update attributes
> of both source and target parent directories. Not doing it
> causes generic/309 xfstest to fail on SMB2 mounts. Fix this
> by marking these directories for force revalidating.
>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/inode.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 2029e7c..cf69c95 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1720,6 +1720,12 @@ unlink_target:
>                                     target_dentry, to_name);
>         }
>
> +       /* force revalidate to go get info when needed */
> +       CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
> +
> +       source_dir->i_ctime = source_dir->i_mtime = target_dir->i_ctime =
> +               target_dir->i_mtime = current_fs_time(source_dir->i_sb);
> +
>  cifs_rename_exit:
>         kfree(info_buf_source);
>         kfree(from_name);
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
