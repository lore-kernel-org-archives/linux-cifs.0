From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: hide unused functions
Date: Wed, 28 Jun 2017 00:00:18 -0500
Message-ID: <CAH2r5mtmuHO71XHmLsbD=cL+c2rXrev_egaVVi8KDX3gD2UZiA@mail.gmail.com>
References: <20170627152302.806239-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170627152302.806239-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Tue, Jun 27, 2017 at 10:06 AM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> Some functions are only referenced under an #ifdef, causing a harmless
> warning:
>
> fs/cifs/smb2ops.c:1374:1: error: 'get_smb2_acl' defined but not used [-Werror=unused-function]
>
> We could mark them __maybe_unused or add another #ifdef, I picked
> the second approach here.
>
> Fixes: b3fdda4d1e1b ("cifs: Use smb 2 - 3 and cifsacl mount options getacl functions")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
>  fs/cifs/smb2ops.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 06494e11c570..941c40b7a870 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1288,6 +1288,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>         return rc;
>  }
>
> +#ifdef CONFIG_CIFS_ACL
>  static struct cifs_ntsd *
>  get_smb2_acl_by_fid(struct cifs_sb_info *cifs_sb,
>                 const struct cifs_fid *cifsfid, u32 *pacllen)
> @@ -1387,7 +1388,7 @@ get_smb2_acl(struct cifs_sb_info *cifs_sb,
>         cifsFileInfo_put(open_file);
>         return pntsd;
>  }
> -
> +#endif
>
>  static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
>                             loff_t offset, loff_t len, bool keep_size)
> --
> 2.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
