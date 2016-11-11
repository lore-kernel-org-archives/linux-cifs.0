From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 3/6] fs/cifs: always use ipc for DFS resolving ioctls
Date: Thu, 10 Nov 2016 16:46:02 -0800
Message-ID: <CAKywueSXJ1cftMvw6bawE8Dw3xFm-ohYnTcUaVQK-orcr++t0Q@mail.gmail.com>
References: <1478622806-19636-1-git-send-email-aaptel@suse.com> <1478622806-19636-4-git-send-email-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478622806-19636-4-git-send-email-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-11-08 8:33 GMT-08:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> since we cannot access the ipc tcon object, force the use of the ipc tid
> when crafting DFS resolving ioctl.
>
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 5ca5ea46..6d5b8db 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1645,6 +1645,10 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>         if (rc)
>                 return rc;
>
> +       /* XXX: how can we access the tcon of the IPC of the host? */
> +       if (opcode == FSCTL_DFS_GET_REFERRALS) {
> +               req->hdr.TreeId = ses->ipc_tid;
> +       }

It seems like spec (3.2.4.20.3) says that we can use any existing ses
and tcon for the current user. See my comment to the previous patch.

>         req->CtlCode = cpu_to_le32(opcode);
>         req->PersistentFileId = persistent_fid;
>         req->VolatileFileId = volatile_fid;
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards,
Pavel Shilovsky
