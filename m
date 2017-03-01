From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 5/7] CIFS: set signing flag in SMB2+ TreeConnect if needed
Date: Tue, 28 Feb 2017 18:37:53 -0800
Message-ID: <CAKywueSQVP8LZUwDndZgawiF1RQwAEJnOTYobO5wOXVBc4g0rw@mail.gmail.com>
References: <20170228184034.18771-1-aaptel@suse.com> <20170228184034.18771-6-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170228184034.18771-6-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-02-28 10:40 GMT-08:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> cifs_enable_signing() already sets server->sign according to what the
> server requires/offers and what mount options allows/forbids, so use
> that.
>
> this is required for IPC tcon that connects to signing-required servers.
>
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 8c4532d..2fd93ee 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1168,8 +1168,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
>
>                 /* since no tcon, smb2_init can not do this, so do here */
>                 req->hdr.sync_hdr.SessionId = ses->Suid;
> -               /* if (ses->server->sec_mode & SECMODE_SIGN_REQUIRED)
> -                       req->hdr.Flags |= SMB2_FLAGS_SIGNED; */
> +               if (ses->server->sign)
> +                       req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
>         } else if (encryption_required(tcon))
>                 flags |= CIFS_TRANSFORM_REQ;
>
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
