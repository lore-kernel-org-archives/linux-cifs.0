From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix NULL pointer deref on SMB2_tcon() failure
Date: Wed, 11 Oct 2017 11:08:40 -0700
Message-ID: <CAKywueSS2HVooNt3OZb1_y=6TrYmFzYLRqmjHmti0Fx=4HqU1Q@mail.gmail.com>
References: <20171010230138.31832-1-lsahlber@redhat.com> <20171011112336.11263-1-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011112336.11263-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-10-11 4:23 GMT-07:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> If SendReceive2() fails rsp is set to NULL but is dereferenced in the
> error handling code.
>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 7aa67206f6da..eb658b641ded 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1168,7 +1168,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
>         struct smb2_tree_connect_req *req;
>         struct smb2_tree_connect_rsp *rsp = NULL;
>         struct kvec iov[2];
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         int rc = 0;
>         int resp_buftype;
>         int unc_path_len;
> @@ -1285,7 +1285,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
>         return rc;
>
>  tcon_error_exit:
> -       if (rsp->hdr.sync_hdr.Status == STATUS_BAD_NETWORK_NAME) {
> +       if (rsp && rsp->hdr.sync_hdr.Status == STATUS_BAD_NETWORK_NAME) {
>                 cifs_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
>         }
>         goto tcon_exit;
> --
> 2.12.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Good catch, Ronnie, Aurelien!

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

It seems like the issue exists even before SendReceive2() refactoring
but wasn't triggered until DFS support was added.

--
Best regards,
Pavel Shilovsky
