From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 4/7] CIFS: let ses->ipc_tid hold smb2 TreeIds
Date: Tue, 28 Feb 2017 18:36:21 -0800
Message-ID: <CAKywueQxc2wdyoL3Mp2rSZ+txqhML8evFFW8Q3E3GQape55RHQ@mail.gmail.com>
References: <20170228184034.18771-1-aaptel@suse.com> <20170228184034.18771-5-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170228184034.18771-5-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-02-28 10:40 GMT-08:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> the TreeId field went from 2 bytes in CIFS to 4 bytes in SMB2+. this
> commit updates the size of the ipc_tid field of a cifs_ses, which was
> still using 2 bytes.
>
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 1a90bb3..af224cd 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -822,7 +822,7 @@ struct cifs_ses {
>         int ses_count;          /* reference counter */
>         enum statusEnum status;
>         unsigned overrideSecFlg;  /* if non-zero override global sec flags */
> -       __u16 ipc_tid;          /* special tid for connection to IPC share */
> +       __u32 ipc_tid;          /* special tid for connection to IPC share */
>         char *serverOS;         /* name of operating system underlying server */
>         char *serverNOS;        /* name of network operating system of server */
>         char *serverDomain;     /* security realm of server */
> --
> 2.10.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky
