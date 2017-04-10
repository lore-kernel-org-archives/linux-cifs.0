From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/4] CIFS: remove bad_network_name flag
Date: Mon, 10 Apr 2017 10:39:24 -0700
Message-ID: <CAKywueS8BzQ0oXHd04cj+p3nzZddRQ2RO59eu3kJGR-voBaQgA@mail.gmail.com>
References: <cover.333fa5a2e4d6ba38ce99ad2ef69bf44685343ca0.1491415908.git-series.germano.percossi@citrix.com>
 <d573d29c68474595aaa803447ebfec8f04eb75fc.1491415908.git-series.germano.percossi@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d573d29c68474595aaa803447ebfec8f04eb75fc.1491415908.git-series.germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-04-07 4:29 GMT-07:00 Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>:
> STATUS_BAD_NETWORK_NAME can be received during node failover,
> causing the flag to be set and making the reconnect thread
> always unsuccessful, thereafter.
>
> Once the only place where it is set is removed, the remaining
> bits are rendered moot.
>
> Removing it does not prevent "mount" from failing when a non
> existent share is passed.
>
> What happens when the share really ceases to exist while the
> share is mounted is undefined now as much as it was before.
>
> Signed-off-by: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h | 1 -
>  fs/cifs/smb2pdu.c  | 5 -----
>  2 files changed, 6 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index c34bdb1..b04f107 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -947,7 +947,6 @@ struct cifs_tcon {
>         bool use_persistent:1; /* use persistent instead of durable handles */
>  #ifdef CONFIG_CIFS_SMB2
>         bool print:1;           /* set if connection to printer share */
> -       bool bad_network_name:1; /* set if ret status STATUS_BAD_NETWORK_NAME */
>         __le32 capabilities;
>         __u32 share_flags;
>         __u32 maximal_access;
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 17af75a..3d1cb32 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1171,9 +1171,6 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
>         else
>                 return -EIO;
>
> -       if (tcon && tcon->bad_network_name)
> -               return -ENOENT;
> -
>         unc_path = kmalloc(MAX_SHARENAME_LENGTH * 2, GFP_KERNEL);
>         if (unc_path == NULL)
>                 return -ENOMEM;
> @@ -1273,8 +1270,6 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
>  tcon_error_exit:
>         if (rsp->hdr.sync_hdr.Status == STATUS_BAD_NETWORK_NAME) {
>                 cifs_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
> -               if (tcon)
> -                       tcon->bad_network_name = true;
>         }
>         goto tcon_exit;
>  }
> --
> git-series 0.9.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
