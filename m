From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Clean up unused variables in smb2pdu.c
Date: Sun, 9 Jul 2017 23:38:44 -0500
Message-ID: <CAH2r5mtQOKKbB0oi0pnSw1GTAne-Yk=gW-=btntwtSx2+ipk0Q@mail.gmail.com>
References: <1499597104-918-1-git-send-email-chris.gekas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christos Gkekas <chris.gekas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499597104-918-1-git-send-email-chris.gekas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Sun, Jul 9, 2017 at 5:45 AM, Christos Gkekas <chris.gekas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> There are multiple unused variables struct TCP_Server_Info *server
> defined in many methods in smb2pdu.c. They should be removed and related
> logic simplified.
>
> Signed-off-by: Christos Gkekas <chris.gekas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 35 +++++++----------------------------
>  1 file changed, 7 insertions(+), 28 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 4938e8b..ee59592 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1167,15 +1167,12 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
>         int rc = 0;
>         int resp_buftype;
>         int unc_path_len;
> -       struct TCP_Server_Info *server;
>         __le16 *unc_path = NULL;
>         int flags = 0;
>
>         cifs_dbg(FYI, "TCON\n");
>
> -       if ((ses->server) && tree)
> -               server = ses->server;
> -       else
> +       if (!(ses->server) || !tree)
>                 return -EIO;
>
>         unc_path = kmalloc(MAX_SHARENAME_LENGTH * 2, GFP_KERNEL);
> @@ -1294,15 +1291,12 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
>  {
>         struct smb2_tree_disconnect_req *req; /* response is trivial */
>         int rc = 0;
> -       struct TCP_Server_Info *server;
>         struct cifs_ses *ses = tcon->ses;
>         int flags = 0;
>
>         cifs_dbg(FYI, "Tree Disconnect\n");
>
> -       if (ses && (ses->server))
> -               server = ses->server;
> -       else
> +       if (!ses || !(ses->server))
>                 return -EIO;
>
>         if ((tcon->need_reconnect) || (tcon->ses->need_reconnect))
> @@ -1794,7 +1788,6 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>         struct smb2_ioctl_req *req;
>         struct smb2_ioctl_rsp *rsp;
>         struct smb2_sync_hdr *shdr;
> -       struct TCP_Server_Info *server;
>         struct cifs_ses *ses;
>         struct kvec iov[2];
>         struct kvec rsp_iov;
> @@ -1817,9 +1810,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>         else
>                 return -EIO;
>
> -       if (ses && (ses->server))
> -               server = ses->server;
> -       else
> +       if (!ses || !(ses->server))
>                 return -EIO;
>
>         rc = small_smb2_init(SMB2_IOCTL, tcon, (void **) &req);
> @@ -1977,7 +1968,6 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
>  {
>         struct smb2_close_req *req;
>         struct smb2_close_rsp *rsp;
> -       struct TCP_Server_Info *server;
>         struct cifs_ses *ses = tcon->ses;
>         struct kvec iov[1];
>         struct kvec rsp_iov;
> @@ -1987,9 +1977,7 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
>
>         cifs_dbg(FYI, "Close\n");
>
> -       if (ses && (ses->server))
> -               server = ses->server;
> -       else
> +       if (!ses || !(ses->server))
>                 return -EIO;
>
>         rc = small_smb2_init(SMB2_CLOSE, tcon, (void **) &req);
> @@ -2091,15 +2079,12 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
>         struct kvec rsp_iov;
>         int rc = 0;
>         int resp_buftype;
> -       struct TCP_Server_Info *server;
>         struct cifs_ses *ses = tcon->ses;
>         int flags = 0;
>
>         cifs_dbg(FYI, "Query Info\n");
>
> -       if (ses && (ses->server))
> -               server = ses->server;
> -       else
> +       if (!ses || !(ses->server))
>                 return -EIO;
>
>         rc = small_smb2_init(SMB2_QUERY_INFO, tcon, (void **) &req);
> @@ -2311,7 +2296,6 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>            u64 volatile_fid)
>  {
>         struct smb2_flush_req *req;
> -       struct TCP_Server_Info *server;
>         struct cifs_ses *ses = tcon->ses;
>         struct kvec iov[1];
>         struct kvec rsp_iov;
> @@ -2321,9 +2305,7 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>
>         cifs_dbg(FYI, "Flush\n");
>
> -       if (ses && (ses->server))
> -               server = ses->server;
> -       else
> +       if (!ses || !(ses->server))
>                 return -EIO;
>
>         rc = small_smb2_init(SMB2_FLUSH, tcon, (void **) &req);
> @@ -3010,13 +2992,10 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
>         int rc = 0;
>         int resp_buftype;
>         unsigned int i;
> -       struct TCP_Server_Info *server;
>         struct cifs_ses *ses = tcon->ses;
>         int flags = 0;
>
> -       if (ses && (ses->server))
> -               server = ses->server;
> -       else
> +       if (!ses || !(ses->server))
>                 return -EIO;
>
>         if (!num)
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
