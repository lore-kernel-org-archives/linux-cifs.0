From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: don't send invalid setxattr requests
Date: Wed, 30 Aug 2017 12:11:33 -0700
Message-ID: <CAKywueSS5eKuVOvdLn4JDewXF1M00XG6XexdxB0ttaGe3unOeA@mail.gmail.com>
References: <20170810122143.2o4jln4x6cvz5r2l@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810122143.2o4jln4x6cvz5r2l@mwanda>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-08-10 5:21 GMT-07:00 Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>:
> There is a static checker warning here because we're taking a "size"
> from the user which is in the 1-XATTR_SIZE_MAX range and we're assuming
> it's large enough to hold a sizeof(struct cifs_ntsd).  This doesn't
> cause a buffer overflow or anything, we just end up sending an invalid
> sized command to the server.  The server checks for that in
> CIFSSMBGetCIFSACL() and rejects it.
>
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> Not tested.  Please review this one carefully.
>
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index de50e749ff05..70bdce5add24 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -93,6 +93,10 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
>
>                 if (!value)
>                         goto out;
> +               if (size < sizeof(struct cifs_ntsd)) {
> +                       rc = -EINVAL;
> +                       goto out;
> +               }
>                 pacl = kmalloc(size, GFP_KERNEL);
>                 if (!pacl) {
>                         rc = -ENOMEM;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
