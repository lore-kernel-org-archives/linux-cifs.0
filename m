From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH v1 2/3] CIFS: make IPC a regular tcon
Date: Thu, 18 Jan 2018 00:27:34 +0000
Message-ID: <DM5PR2101MB0936C7D8EE43D6E069870B10B6E80@DM5PR2101MB0936.namprd21.prod.outlook.com>
References: <20180117172200.3221-1-aaptel@suse.com>
 <20180117172200.3221-3-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117172200.3221-3-aaptel-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2018-01-17 9:21 GMT-08:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> * Remove ses->ipc_tid.
> * Make IPC$ regular tcon by having it stored in the session tcon list.

Thank you for doing this, I suspected that we would end up with something l=
ike it anyway.

> * Add a direct pointer to it in ses->tcon_ipc.
> * Distinguish PIPE tcon from IPC tcon by adding a tcon->pipe flag. All
>   IPC tcons are pipes but not all pipes are IPC.
> * All TreeConnect functions now cannot take a NULL tcon object.
>
> The IPC tcon has the same lifetime as the session it belongs to. It is
> created when the session is created and destroyed when the session is
> destroyed.
>
> Since no mounts directly refer to the IPC tcon, its refcount should
> always be 0. Thus we make sure cifs_put_tcon() skips it.
>
> If the mount request resulting in a new session being created requires
> encryption, try to require it too for IPC.
>
> NOTE TO BACKPORTER: the previous SERVER_NAME_LENGTH change MUST be
> included with this.

The 1st patch is small, so let's merge both patches that would make backpor=
ter's life easier.

>
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |   7 ++-
>  fs/cifs/cifssmb.c  |   5 +-
>  fs/cifs/connect.c  | 159 ++++++++++++++++++++++++++++++++++++++++-------=
------
>  fs/cifs/inode.c    |   2 +-
>  fs/cifs/smb2pdu.c  |  32 ++---------
>  5 files changed, 134 insertions(+), 71 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index eca386d8dcfb..804ec79af5e1 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -822,12 +822,12 @@ static inline void cifs_set_net_ns(struct TCP_Serve=
r_Info *srv, struct net *net)
>  struct cifs_ses {
>         struct list_head smb_ses_list;
>         struct list_head tcon_list;
> +       struct cifs_tcon *tcon_ipc;
>         struct mutex session_mutex;
>         struct TCP_Server_Info *server; /* pointer to server info */
>         int ses_count;          /* reference counter */
>         enum statusEnum status;
>         unsigned overrideSecFlg;  /* if non-zero override global sec flag=
s */
> -       __u32 ipc_tid;          /* special tid for connection to IPC shar=
e */
>         char *serverOS;         /* name of operating system underlying se=
rver */
>         char *serverNOS;        /* name of network operating system of se=
rver */
>         char *serverDomain;     /* security realm of server */
> @@ -930,7 +930,9 @@ struct cifs_tcon {
>         FILE_SYSTEM_DEVICE_INFO fsDevInfo;
>         FILE_SYSTEM_ATTRIBUTE_INFO fsAttrInfo; /* ok if fs name truncated=
 */
>         FILE_SYSTEM_UNIX_INFO fsUnixInfo;
> -       bool ipc:1;             /* set if connection to IPC$ eg for RPC/P=
IPES */
> +       bool ipc:1;   /* set if connection to IPC$ share (always also pip=
e) */
> +       bool pipe:1;  /* set if connection to pipe share */
> +       bool print:1; /* set if connection to printer share */
>         bool retry:1;
>         bool nocase:1;
>         bool seal:1;      /* transport encryption for this mounted share =
*/
> @@ -943,7 +945,6 @@ struct cifs_tcon {
>         bool need_reopen_files:1; /* need to reopen tcon file handles */
>         bool use_resilient:1; /* use resilient instead of durable handles=
 */
>         bool use_persistent:1; /* use persistent instead of durable handl=
es */
> -       bool print:1;           /* set if connection to printer share */
>         __le32 capabilities;
>         __u32 share_flags;
>         __u32 maximal_access;
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 35dc5bf01ee2..2f8dea905ef9 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4822,8 +4822,9 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs=
_ses *ses,
>         *target_nodes =3D NULL;
>
>         cifs_dbg(FYI, "In GetDFSRefer the path %s\n", search_name);
> -       if (ses =3D=3D NULL)
> +       if (ses =3D=3D NULL || ses->tcon_ipc =3D=3D NULL)
>                 return -ENODEV;
> +
>  getDFSRetry:
>         rc =3D smb_init(SMB_COM_TRANSACTION2, 15, NULL, (void **) &pSMB,
>                       (void **) &pSMBr);
> @@ -4833,7 +4834,7 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs=
_ses *ses,
>         /* server pointer checked in called function,
>         but should never be null here anyway */
>         pSMB->hdr.Mid =3D get_next_mid(ses->server);
> -       pSMB->hdr.Tid =3D ses->ipc_tid;
> +       pSMB->hdr.Tid =3D ses->tcon_ipc->tid;
>         pSMB->hdr.Uid =3D ses->Suid;
>         if (ses->capabilities & CAP_STATUS32)
>                 pSMB->hdr.Flags2 |=3D SMBFLG2_ERR_STATUS;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 0bfc2280436d..5ae393fe0c5d 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -353,7 +353,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
>         list_for_each(tmp, &server->smb_ses_list) {
>                 ses =3D list_entry(tmp, struct cifs_ses, smb_ses_list);
>                 ses->need_reconnect =3D true;
> -               ses->ipc_tid =3D 0;
>                 list_for_each(tmp2, &ses->tcon_list) {
>                         tcon =3D list_entry(tmp2, struct cifs_tcon, tcon_=
list);
>                         tcon->need_reconnect =3D true;
> @@ -2381,6 +2380,104 @@ static int match_session(struct cifs_ses *ses, st=
ruct smb_vol *vol)
>         return 1;
>  }
>
> +/**
> + * cifs_setup_ipc - helper to setup the IPC tcon for the session
> + *
> + * A new IPC connection is made and added to the session tcon list
> + * (also accessible through ses->tcon_ipc). The IPC tcon has the same
> + * lifetime as the session.
> + */
> +static int
> +cifs_setup_ipc(struct cifs_ses *ses, struct smb_vol *volume_info)
> +{
> +       int rc =3D 0, xid;
> +       struct cifs_tcon *tcon;
> +       struct nls_table *nls_codepage;
> +       char unc[SERVER_NAME_LENGTH + sizeof("//x/IPC$")] =3D {0};
> +       bool seal =3D false;
> +
> +       /*
> +        * If the mount request that resulted in the creation of the
> +        * session requires encryption, force IPC to be encrypted too.
> +        */
> +       if (volume_info->seal) {
> +               if (ses->server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTIO=
N)
> +                       seal =3D true;
> +               else {
> +                       cifs_dbg(VFS,
> +                                "IPC: server doesn't support encryption\=
n");
> +                       return -EOPNOTSUPP;
> +               }
> +       }
> +
> +       tcon =3D tconInfoAlloc();
> +       if (tcon =3D=3D NULL)
> +               return -ENOMEM;
> +
> +       snprintf(unc, sizeof(unc), "\\\\%s\\IPC$", ses->serverName);
> +
> +       /* cannot fail */
> +       nls_codepage =3D load_nls_default();
> +
> +       xid =3D get_xid();
> +       tcon->ses =3D ses;
> +       tcon->ipc =3D true;
> +       tcon->seal =3D seal;
> +       rc =3D ses->server->ops->tree_connect(xid, ses, unc, tcon, nls_co=
depage);
> +       free_xid(xid);
> +
> +       if (rc) {
> +               cifs_dbg(VFS, "failed to connect to IPC (rc=3D%d)\n", rc)=
;
> +               tconInfoFree(tcon);
> +               goto out;
> +       }
> +
> +       cifs_dbg(FYI, "IPC tcon rc =3D %d ipc tid =3D %d\n", rc, tcon->ti=
d);
> +
> +       spin_lock(&cifs_tcp_ses_lock);
> +       list_add(&tcon->tcon_list, &ses->tcon_list);
> +       ses->tcon_ipc =3D tcon;
> +       spin_unlock(&cifs_tcp_ses_lock);
> +
> +out:
> +       unload_nls(nls_codepage);
> +       return rc;
> +}
> +
> +/**
> + * cifs_free_ipc - helper to release the session IPC tcon
> + *
> + * Needs to be called everytime a session is destroyed
> + */
> +static int
> +cifs_free_ipc(struct cifs_ses *ses)
> +{
> +       int rc =3D 0, xid;
> +       struct cifs_tcon *tcon;
> +
> +       spin_lock(&cifs_tcp_ses_lock);
> +       tcon =3D ses->tcon_ipc;
> +       if (tcon =3D=3D NULL) {
> +               spin_unlock(&cifs_tcp_ses_lock);
> +               return 0;
> +       }
> +       list_del_init(&tcon->tcon_list);
> +       spin_unlock(&cifs_tcp_ses_lock);
> +
> +       if (ses->server->ops->tree_disconnect) {
> +               xid =3D get_xid();
> +               rc =3D ses->server->ops->tree_disconnect(xid, tcon);
> +               free_xid(xid);
> +       }
> +
> +       if (rc)
> +               cifs_dbg(FYI, "failed to disconnect IPC tcon (rc=3D%d)\n"=
, rc);
> +
> +       tconInfoFree(tcon);
> +       ses->tcon_ipc =3D NULL;

Minor: it should probably work this way, but since we set ses->tcon_ipc und=
er a spinlock in cifs_setup_ipc(), it would be better to do something simil=
ar here.

> +       return rc;
> +}
> +
>  static struct cifs_ses *
>  cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
>  {
> @@ -2421,6 +2518,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
>                 ses->status =3D CifsExiting;
>         spin_unlock(&cifs_tcp_ses_lock);
>
> +       cifs_free_ipc(ses);
> +
>         if (ses->status =3D=3D CifsExiting && server->ops->logoff) {
>                 xid =3D get_xid();
>                 rc =3D server->ops->logoff(xid, ses);
> @@ -2665,6 +2764,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, st=
ruct smb_vol *volume_info)
>         spin_unlock(&cifs_tcp_ses_lock);
>
>         free_xid(xid);
> +
> +       cifs_setup_ipc(ses, volume_info);
> +
>         return ses;
>
>  get_ses_fail:
> @@ -2709,8 +2811,16 @@ void
>  cifs_put_tcon(struct cifs_tcon *tcon)
>  {
>         unsigned int xid;
> -       struct cifs_ses *ses =3D tcon->ses;
> +       struct cifs_ses *ses;
> +
> +       /*
> +        * IPC tcon share the lifetime of their session and are
> +        * destroyed in the session put function
> +        */
> +       if (tcon =3D=3D NULL || tcon->ipc)
> +               return;
>
> +       ses =3D tcon->ses;
>         cifs_dbg(FYI, "%s: tc_count=3D%d\n", __func__, tcon->tc_count);
>         spin_lock(&cifs_tcp_ses_lock);
>         if (--tcon->tc_count > 0) {
> @@ -2986,39 +3096,17 @@ get_dfs_path(const unsigned int xid, struct cifs_=
ses *ses, const char *old_path,
>              const struct nls_table *nls_codepage, unsigned int *num_refe=
rrals,
>              struct dfs_info3_param **referrals, int remap)
>  {
> -       char *temp_unc;
>         int rc =3D 0;
>
> -       if (!ses->server->ops->tree_connect || !ses->server->ops->get_dfs=
_refer)
> +       if (!ses->server->ops->get_dfs_refer)
>                 return -ENOSYS;
>
>         *num_referrals =3D 0;
>         *referrals =3D NULL;
>
> -       if (ses->ipc_tid =3D=3D 0) {
> -               temp_unc =3D kmalloc(2 /* for slashes */ +
> -                       strnlen(ses->serverName, SERVER_NAME_LEN_WITH_NUL=
L * 2)
> -                               + 1 + 4 /* slash IPC$ */ + 2, GFP_KERNEL)=
;
> -               if (temp_unc =3D=3D NULL)
> -                       return -ENOMEM;
> -               temp_unc[0] =3D '\\';
> -               temp_unc[1] =3D '\\';
> -               strcpy(temp_unc + 2, ses->serverName);
> -               strcpy(temp_unc + 2 + strlen(ses->serverName), "\\IPC$");
> -               rc =3D ses->server->ops->tree_connect(xid, ses, temp_unc,=
 NULL,
> -                                                   nls_codepage);
> -               cifs_dbg(FYI, "Tcon rc =3D %d ipc_tid =3D %d\n", rc, ses-=
>ipc_tid);
> -               kfree(temp_unc);
> -       }
> -       if (rc =3D=3D 0)
> -               rc =3D ses->server->ops->get_dfs_refer(xid, ses, old_path=
,
> -                                                    referrals, num_refer=
rals,
> -                                                    nls_codepage, remap)=
;
> -       /*
> -        * BB - map targetUNCs to dfs_info3 structures, here or in
> -        * ses->server->ops->get_dfs_refer.
> -        */

Is this no longer needed?

> -
> +       rc =3D ses->server->ops->get_dfs_refer(xid, ses, old_path,
> +                                            referrals, num_referrals,
> +                                            nls_codepage, remap);
>         return rc;
>  }
>
> @@ -3783,7 +3871,7 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb=
_vol *volume_info)
>                 tcon->unix_ext =3D 0; /* server does not support them */
>
>         /* do not care if a following call succeed - informational */
> -       if (!tcon->ipc && server->ops->qfs_tcon)
> +       if (!tcon->pipe && server->ops->qfs_tcon)
>                 server->ops->qfs_tcon(xid, tcon);
>
>         cifs_sb->wsize =3D server->ops->negotiate_wsize(tcon, volume_info=
);
> @@ -3913,8 +4001,7 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb=
_vol *volume_info)
>  }
>
>  /*
> - * Issue a TREE_CONNECT request. Note that for IPC$ shares, that the tco=
n
> - * pointer may be NULL.
> + * Issue a TREE_CONNECT request.
>   */
>  int
>  CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
> @@ -3950,7 +4037,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *s=
es,
>         pSMB->AndXCommand =3D 0xFF;
>         pSMB->Flags =3D cpu_to_le16(TCON_EXTENDED_SECINFO);
>         bcc_ptr =3D &pSMB->Password[0];
> -       if (!tcon || (ses->server->sec_mode & SECMODE_USER)) {
> +       if (tcon->pipe || (ses->server->sec_mode & SECMODE_USER)) {
>                 pSMB->PasswordLength =3D cpu_to_le16(1);  /* minimum */
>                 *bcc_ptr =3D 0; /* password is null byte */
>                 bcc_ptr++;              /* skip password */
> @@ -4022,7 +4109,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *s=
es,
>                          0);
>
>         /* above now done in SendReceive */
> -       if ((rc =3D=3D 0) && (tcon !=3D NULL)) {
> +       if (rc =3D=3D 0) {
>                 bool is_unicode;
>
>                 tcon->tidStatus =3D CifsGood;
> @@ -4042,7 +4129,8 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *s=
es,
>                         if ((bcc_ptr[0] =3D=3D 'I') && (bcc_ptr[1] =3D=3D=
 'P') &&
>                             (bcc_ptr[2] =3D=3D 'C')) {
>                                 cifs_dbg(FYI, "IPC connection\n");
> -                               tcon->ipc =3D 1;
> +                               tcon->ipc =3D true;
> +                               tcon->pipe =3D true;
>                         }
>                 } else if (length =3D=3D 2) {
>                         if ((bcc_ptr[0] =3D=3D 'A') && (bcc_ptr[1] =3D=3D=
 ':')) {
> @@ -4069,9 +4157,6 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *s=
es,
>                 else
>                         tcon->Flags =3D 0;
>                 cifs_dbg(FYI, "Tcon flags: 0x%x\n", tcon->Flags);
> -       } else if ((rc =3D=3D 0) && tcon =3D=3D NULL) {
> -               /* all we need to save for IPC$ connection */
> -               ses->ipc_tid =3D smb_buffer_response->Tid;
>         }
>
>         cifs_buf_release(smb_buffer);
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index ecb99079363a..8f9a8cc7cc62 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1049,7 +1049,7 @@ struct inode *cifs_root_iget(struct super_block *sb=
)
>         tcon->resource_id =3D CIFS_I(inode)->uniqueid;
>  #endif
>
> -       if (rc && tcon->ipc) {
> +       if (rc && tcon->pipe) {
>                 cifs_dbg(FYI, "ipc connection - fake read inode\n");
>                 spin_lock(&inode->i_lock);
>                 inode->i_mode |=3D S_IFDIR;
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 01346b8b6edb..a5c94f8308eb 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1283,8 +1283,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *=
ses, const char *tree,
>         }
>
>         /* SMB2 TREE_CONNECT request must be called with TreeId =3D=3D 0 =
*/
> -       if (tcon)
> -               tcon->tid =3D 0;
> +       tcon->tid =3D 0;
>
>         rc =3D small_smb2_init(SMB2_TREE_CONNECT, tcon, (void **) &req);
>         if (rc) {
> @@ -1292,15 +1291,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses =
*ses, const char *tree,
>                 return rc;
>         }
>
> -       if (tcon =3D=3D NULL) {
> -               if ((ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)=
)
> -                       flags |=3D CIFS_TRANSFORM_REQ;
> -
> -               /* since no tcon, smb2_init can not do this, so do here *=
/
> -               req->hdr.sync_hdr.SessionId =3D ses->Suid;
> -               if (ses->server->sign)
> -                       req->hdr.sync_hdr.Flags |=3D SMB2_FLAGS_SIGNED;
> -       } else if (encryption_required(tcon))
> +       if (encryption_required(tcon))
>                 flags |=3D CIFS_TRANSFORM_REQ;
>
>         iov[0].iov_base =3D (char *)req;
> @@ -1328,21 +1319,16 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses=
 *ses, const char *tree,
>                 goto tcon_error_exit;
>         }
>
> -       if (tcon =3D=3D NULL) {
> -               ses->ipc_tid =3D rsp->hdr.sync_hdr.TreeId;
> -               goto tcon_exit;
> -       }
> -
>         switch (rsp->ShareType) {
>         case SMB2_SHARE_TYPE_DISK:
>                 cifs_dbg(FYI, "connection to disk share\n");
>                 break;
>         case SMB2_SHARE_TYPE_PIPE:
> -               tcon->ipc =3D true;
> +               tcon->pipe =3D true;
>                 cifs_dbg(FYI, "connection to pipe share\n");
>                 break;
>         case SMB2_SHARE_TYPE_PRINT:
> -               tcon->ipc =3D true;
> +               tcon->print =3D true;
>                 cifs_dbg(FYI, "connection to printer\n");
>                 break;
>         default:
> @@ -1913,16 +1899,6 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tco=
n *tcon, u64 persistent_fid,
>         if (rc)
>                 return rc;
>
> -       if (use_ipc) {
> -               if (ses->ipc_tid =3D=3D 0) {
> -                       cifs_small_buf_release(req);
> -                       return -ENOTCONN;
> -               }
> -
> -               cifs_dbg(FYI, "replacing tid 0x%x with IPC tid 0x%x\n",
> -                        req->hdr.sync_hdr.TreeId, ses->ipc_tid);
> -               req->hdr.sync_hdr.TreeId =3D ses->ipc_tid;
> -       }
>         if (encryption_required(tcon))
>                 flags |=3D CIFS_TRANSFORM_REQ;
>
> --
> 2.12.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
Best regards,
Pavel Shilovsky
