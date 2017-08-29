From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 2/2] cifs: Add support for writing attributes on SMB2+
Date: Tue, 29 Aug 2017 22:16:22 +0000
Message-ID: <CY4PR21MB013548B529F77EB9ABC4AB2CB69F0@CY4PR21MB0135.namprd21.prod.outlook.com>
References: <20170824012456.10977-1-lsahlber@redhat.com>
 <20170824012456.10977-3-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170824012456.10977-3-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-08-23 18:24 GMT-07:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> This adds support for writing extended attributes on SMB2+ shares.
> Attributes can be written using the setfattr command.
>
> RH-bz: 1110709
>
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |  2 +-
>  fs/cifs/cifsproto.h |  3 ++-
>  fs/cifs/cifssmb.c   |  3 ++-
>  fs/cifs/smb2ops.c   | 60 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/cifs/smb2pdu.c   | 10 +++++++++
>  fs/cifs/smb2proto.h |  3 +++
>  fs/cifs/xattr.c     |  2 +-
>  7 files changed, 79 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 221693fe49ec..808486c29f0d 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -421,7 +421,7 @@ struct smb_version_operations {
>                         size_t, struct cifs_sb_info *);
>         int (*set_EA)(const unsigned int, struct cifs_tcon *, const char =
*,
>                         const char *, const void *, const __u16,
> -                       const struct nls_table *, int);
> +                       const struct nls_table *, struct cifs_sb_info *);
>         struct cifs_ntsd * (*get_acl)(struct cifs_sb_info *, struct inode=
 *,
>                         const char *, u32 *);
>         struct cifs_ntsd * (*get_acl_by_fid)(struct cifs_sb_info *,
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 6eb3147132e3..4143c9dec463 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -484,7 +484,8 @@ extern ssize_t CIFSSMBQAllEAs(const unsigned int xid,=
 struct cifs_tcon *tcon,
>  extern int CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
>                 const char *fileName, const char *ea_name,
>                 const void *ea_value, const __u16 ea_value_len,
> -               const struct nls_table *nls_codepage, int remap_special_c=
hars);
> +               const struct nls_table *nls_codepage,
> +               struct cifs_sb_info *cifs_sb);
>  extern int CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *t=
con,
>                         __u16 fid, struct cifs_ntsd **acl_inf, __u32 *buf=
len);
>  extern int CIFSSMBSetCIFSACL(const unsigned int, struct cifs_tcon *, __u=
16,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 72a53bd19865..48455afefec8 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -6264,7 +6264,7 @@ int
>  CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
>              const char *fileName, const char *ea_name, const void *ea_va=
lue,
>              const __u16 ea_value_len, const struct nls_table *nls_codepa=
ge,
> -            int remap)
> +            struct cifs_sb_info *cifs_sb)
>  {
>         struct smb_com_transaction2_spi_req *pSMB =3D NULL;
>         struct smb_com_transaction2_spi_rsp *pSMBr =3D NULL;
> @@ -6273,6 +6273,7 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tc=
on *tcon,
>         int rc =3D 0;
>         int bytes_returned =3D 0;
>         __u16 params, param_offset, byte_count, offset, count;
> +       int remap =3D cifs_remap(cifs_sb);
>
>         cifs_dbg(FYI, "In SetEA\n");
>  SetEARetry:
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 78516d3a133c..fb2934b9b97c 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -558,6 +558,62 @@ smb2_query_eas(const unsigned int xid, struct cifs_t=
con *tcon,
>         return rc;
>  }
>
> +
> +static int
> +smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
> +           const char *path, const char *ea_name, const void *ea_value,
> +           const __u16 ea_value_len, const struct nls_table *nls_codepag=
e,
> +           struct cifs_sb_info *cifs_sb)
> +{
> +       int rc;
> +       __le16 *utf16_path;
> +       __u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> +       struct cifs_open_parms oparms;
> +       struct cifs_fid fid;
> +       struct smb2_file_full_ea_info *ea;
> +       int ea_name_len =3D strlen(ea_name);
> +       int len;
> +
> +       if (ea_name_len > 255)
> +               return -EINVAL;
> +
> +       utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
> +       if (!utf16_path)
> +               return -ENOMEM;
> +
> +       oparms.tcon =3D tcon;
> +       oparms.desired_access =3D FILE_WRITE_EA;
> +       oparms.disposition =3D FILE_OPEN;
> +       oparms.create_options =3D 0;
> +       oparms.fid =3D &fid;
> +       oparms.reconnect =3D false;
> +
> +       rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
> +       kfree(utf16_path);
> +       if (rc) {
> +               cifs_dbg(FYI, "open failed rc=3D%d\n", rc);
> +               return rc;
> +       }
> +
> +       len =3D sizeof(ea) + ea_name_len + ea_value_len + 1;
> +       ea =3D kzalloc(len, GFP_KERNEL);
> +       if (ea =3D=3D NULL) {
> +               SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fi=
d);
> +               return -ENOMEM;
> +       }
> +
> +       ea->ea_name_length =3D ea_name_len;
> +       ea->ea_value_length =3D cpu_to_le16(ea_value_len);
> +       memcpy(ea->ea_data, ea_name, ea_name_len + 1);
> +       memcpy(ea->ea_data + ea_name_len + 1, ea_value, ea_value_len);
> +
> +       rc =3D SMB2_set_ea(xid, tcon, fid.persistent_fid, fid.volatile_fi=
d, ea,
> +                        len);
> +       SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> +
> +       return rc;
> +}
> +
>  static bool
>  smb2_can_echo(struct TCP_Server_Info *server)
>  {
> @@ -2706,6 +2762,7 @@ struct smb_version_operations smb20_operations =3D =
{
>         .select_sectype =3D smb2_select_sectype,
>  #ifdef CONFIG_CIFS_XATTR
>         .query_all_EAs =3D smb2_query_eas,
> +       .set_EA =3D smb2_set_ea,
>  #endif /* CIFS_XATTR */
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl =3D get_smb2_acl,
> @@ -2799,6 +2856,7 @@ struct smb_version_operations smb21_operations =3D =
{
>         .select_sectype =3D smb2_select_sectype,
>  #ifdef CONFIG_CIFS_XATTR
>         .query_all_EAs =3D smb2_query_eas,
> +       .set_EA =3D smb2_set_ea,
>  #endif /* CIFS_XATTR */
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl =3D get_smb2_acl,
> @@ -2902,6 +2960,7 @@ struct smb_version_operations smb30_operations =3D =
{
>         .select_sectype =3D smb2_select_sectype,
>  #ifdef CONFIG_CIFS_XATTR
>         .query_all_EAs =3D smb2_query_eas,
> +       .set_EA =3D smb2_set_ea,
>  #endif /* CIFS_XATTR */
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl =3D get_smb2_acl,
> @@ -3006,6 +3065,7 @@ struct smb_version_operations smb311_operations =3D=
 {
>         .select_sectype =3D smb2_select_sectype,
>  #ifdef CONFIG_CIFS_XATTR
>         .query_all_EAs =3D smb2_query_eas,
> +       .set_EA =3D smb2_set_ea,
>  #endif /* CIFS_XATTR */
>  };
>  #endif /* CIFS_SMB311 */
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 30ef93e459a9..93785a97b2bf 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3192,6 +3192,16 @@ SMB2_set_acl(const unsigned int xid, struct cifs_t=
con *tcon,
>  }
>
>  int
> +SMB2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
> +           u64 persistent_fid, u64 volatile_fid,
> +           struct smb2_file_full_ea_info *buf, int len)
> +{
> +       return send_set_info(xid, tcon, persistent_fid, volatile_fid,
> +               current->tgid, FILE_FULL_EA_INFORMATION, SMB2_O_INFO_FILE=
,
> +               0, 1, (void **)&buf, &len);
> +}
> +
> +int
>  SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
>                   const u64 persistent_fid, const u64 volatile_fid,
>                   __u8 oplock_level)
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 183389bfc8f6..003217099ef3 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -172,6 +172,9 @@ extern int SMB2_set_info(const unsigned int xid, stru=
ct cifs_tcon *tcon,
>  extern int SMB2_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
>                         u64 persistent_fid, u64 volatile_fid,
>                         struct cifs_ntsd *pnntsd, int pacllen, int aclfla=
g);
> +extern int SMB2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
> +                      u64 persistent_fid, u64 volatile_fid,
> +                      struct smb2_file_full_ea_info *buf, int len);
>  extern int SMB2_set_compression(const unsigned int xid, struct cifs_tcon=
 *tcon,
>                                 u64 persistent_fid, u64 volatile_fid);
>  extern int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *t=
con,
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index de50e749ff05..52f975d848a0 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -84,7 +84,7 @@ static int cifs_xattr_set(const struct xattr_handler *h=
andler,
>                 if (pTcon->ses->server->ops->set_EA)
>                         rc =3D pTcon->ses->server->ops->set_EA(xid, pTcon=
,
>                                 full_path, name, value, (__u16)size,
> -                               cifs_sb->local_nls, cifs_remap(cifs_sb));
> +                               cifs_sb->local_nls, cifs_sb);
>                 break;
>
>         case XATTR_CIFS_ACL: {
> --
> 2.13.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
