From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs_dbg() outputs an uninitialized buffer in cifs_readdir()
Date: Thu, 14 Jan 2016 15:04:21 -0600
Message-ID: <CAH2r5muEGLku_nSRtw=2hGaKf6fr0EQzbvVVw+0bme8V+8DCNA@mail.gmail.com>
References: <56977B4A.3070002@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56977B4A.3070002-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git and added cc:stable

Let me know if other cifs/smb3 patches planned for 4.5

On Thu, Jan 14, 2016 at 4:41 AM, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> In some cases tmp_bug can be not filled in cifs_filldir and stay uninitialized,
> therefore its printk with "%s" modifier can leak content of kernelspace memory.
> If old content of this buffer does not contain '\0' access bejond end of
> allocated object can crash the host.
>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  fs/cifs/readdir.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 0557c45..b30a4a6 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -847,6 +847,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>                  * if buggy server returns . and .. late do we want to
>                  * check for that here?
>                  */
> +               *tmp_buf = 0;
>                 rc = cifs_filldir(current_entry, file, ctx,
>                                   tmp_buf, max_len);
>                 if (rc) {
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
