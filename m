From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix CIFS_IOC_GET_MNT_INFO oops
Date: Wed, 3 May 2017 19:40:46 -0500
Message-ID: <CAH2r5mtCdORq1mzPkt6Sn01u7duofsBwAqTPfk3axCE-8UKgWA@mail.gmail.com>
References: <20170503224113.28791-1-ddiss@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170503224113.28791-1-ddiss-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git thx

On Wed, May 3, 2017 at 5:41 PM, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org> wrote:
> An open directory may have a NULL private_data pointer prior to readdir.
>
> Fixes: 0de1f4c6f6c0 ("Add way to query server fs info for smb3")
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/ioctl.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 4d598a71cf84..76fb0917dc8c 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -209,6 +209,8 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>                                 rc = -EOPNOTSUPP;
>                         break;
>                 case CIFS_IOC_GET_MNT_INFO:
> +                       if (pSMBFile == NULL)
> +                               break;
>                         tcon = tlink_tcon(pSMBFile->tlink);
>                         rc = smb_mnt_get_fsinfo(xid, tcon, (void __user *)arg);
>                         break;
> --
> 2.12.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
