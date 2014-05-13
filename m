From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Set client guid on per connection basis
Date: Tue, 13 May 2014 22:49:17 +0200
Message-ID: <CAH2r5mvVoa-ns7CnpMuscYyF=EQxzB2E3TDh+xbAZeZFqfBZdw@mail.gmail.com>
References: <1399546266.2850.16.camel@sachin-laptop> <1399938492-20577-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399938492-20577-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

but added an additional patch to fix the problem where we are sending
a non-zero ClientGUID for SMB2.02 dialect (where it MUST be zero
according to MS-SMB2, it is non-zero starting in SMB2.1)

On Tue, May 13, 2014 at 1:48 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> When mounting from a Windows 2012R2 server, we hit the following
> problem:
> 1) Mount with any of the following versions - 2.0, 2.1 or 3.0
> 2) unmount
> 3) Attempt a mount again using a different SMB version >= 2.0.
>
> You end up with the following failure:
> Status code returned 0xc0000203 STATUS_USER_SESSION_DELETED
> CIFS VFS: Send error in SessSetup = -5
> CIFS VFS: cifs_mount failed w/return code = -5
>
> I cannot reproduce this issue using a Windows 2008 R2 server.
>
> This appears to be caused because we use the same client guid for the
> connection on first mount which we then disconnect and attempt to mount
> again using a different protocol version. By generating a new guid each
> time a new connection is Negotiated, we avoid hitting this problem.
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c   | 8 --------
>  fs/cifs/cifsglob.h | 1 +
>  fs/cifs/connect.c  | 3 +++
>  fs/cifs/smb2pdu.c  | 5 +++--
>  fs/cifs/smb2pdu.h  | 2 --
>  5 files changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 5be1f99..c80aa5a 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -87,10 +87,6 @@ extern mempool_t *cifs_mid_poolp;
>
>  struct workqueue_struct        *cifsiod_wq;
>
> -#ifdef CONFIG_CIFS_SMB2
> -__u8 cifs_client_guid[SMB2_CLIENT_GUID_SIZE];
> -#endif
> -
>  /*
>   * Bumps refcount for cifs super block.
>   * Note that it should be only called if a referece to VFS super block is
> @@ -1192,10 +1188,6 @@ init_cifs(void)
>         spin_lock_init(&cifs_file_list_lock);
>         spin_lock_init(&GlobalMid_Lock);
>
> -#ifdef CONFIG_CIFS_SMB2
> -       get_random_bytes(cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
> -#endif
> -
>         if (cifs_max_pending < 2) {
>                 cifs_max_pending = 2;
>                 cifs_dbg(FYI, "cifs_max_pending set to min of 2\n");
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 30f6e92..f74edd2 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -559,6 +559,7 @@ struct TCP_Server_Info {
>         int echo_credits;  /* echo reserved slots */
>         int oplock_credits;  /* oplock break reserved slots */
>         bool echoes:1; /* enable echoes */
> +       __u8 client_guid[SMB2_CLIENT_GUID_SIZE]; /* Client GUID */
>  #endif
>         u16 dialect; /* dialect index that server chose */
>         bool oplocks:1; /* enable oplocks */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8813ff7..8b8fe9b 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2144,6 +2144,9 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>                sizeof(tcp_ses->srcaddr));
>         memcpy(&tcp_ses->dstaddr, &volume_info->dstaddr,
>                 sizeof(tcp_ses->dstaddr));
> +#ifdef CONFIG_CIFS_SMB2
> +       get_random_bytes(tcp_ses->client_guid, SMB2_CLIENT_GUID_SIZE);
> +#endif
>         /*
>          * at this point we are the only ones with the pointer
>          * to the struct since the kernel thread not created yet
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 3802f8c..dc44610 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -375,7 +375,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>
>         req->Capabilities = cpu_to_le32(ses->server->vals->req_capabilities);
>
> -       memcpy(req->ClientGUID, cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
> +       memcpy(req->ClientGUID, server->client_guid, SMB2_CLIENT_GUID_SIZE);
>
>         iov[0].iov_base = (char *)req;
>         /* 4 for rfc1002 length field */
> @@ -478,7 +478,8 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>
>         vneg_inbuf.Capabilities =
>                         cpu_to_le32(tcon->ses->server->vals->req_capabilities);
> -       memcpy(vneg_inbuf.Guid, cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
> +       memcpy(vneg_inbuf.Guid, tcon->ses->server->client_guid,
> +                                       SMB2_CLIENT_GUID_SIZE);
>
>         if (tcon->ses->sign)
>                 vneg_inbuf.SecurityMode =
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index 2022c54..743e11e 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -183,8 +183,6 @@ struct smb2_symlink_err_rsp {
>
>  #define SMB2_CLIENT_GUID_SIZE 16
>
> -extern __u8 cifs_client_guid[SMB2_CLIENT_GUID_SIZE];
> -
>  struct smb2_negotiate_req {
>         struct smb2_hdr hdr;
>         __le16 StructureSize; /* Must be 36 */
> --
> 1.8.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
