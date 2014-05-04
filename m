From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 1/1] FS/CIFS: remove obsolete __constant
Date: Sun, 4 May 2014 18:52:43 -0400
Message-ID: <CAOhYWNJ5JRt9KH-Z3K_zBW2axs5c5KJQYXb8_vYLQTEdr=ZeEg@mail.gmail.com>
References: <20140503221539.e4857ef93d6c875bbded5938@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	akpm <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140503221539.e4857ef93d6c875bbded5938-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, May 3, 2014 at 4:15 PM, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org> wrote:
> Replacing all __constant_foo to foo()
> except in smb2status.h (1700 lines to update).
>
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Signed-off-by: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c  |  2 +-
>  fs/cifs/cifssmb.c  | 20 ++++++++++----------
>  fs/cifs/sess.c     |  2 +-
>  fs/cifs/smb2misc.c | 38 +++++++++++++++++++-------------------
>  fs/cifs/smb2ops.c  |  2 +-
>  fs/cifs/smb2pdu.c  |  2 +-
>  fs/cifs/smb2pdu.h  | 28 ++++++++++++++--------------
>  7 files changed, 47 insertions(+), 47 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 7ff866d..54ac0e8 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -38,7 +38,7 @@ static const struct cifs_sid sid_everyone = {
>         1, 1, {0, 0, 0, 0, 0, 1}, {0} };
>  /* security id for Authenticated Users system group */
>  static const struct cifs_sid sid_authusers = {
> -       1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(11)} };
> +       1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11)} };


Does the build still work on BE arches with this? I know at one point
the above wouldn't compile on those
arches. See commit 536abdb0802f, for an explanation.


>  /* group users */
>  static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 6ce4e09..c3dc52e 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -2430,14 +2430,14 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
>                 }
>                 parm_data = (struct cifs_posix_lock *)
>                         ((char *)&pSMBr->hdr.Protocol + data_offset);
> -               if (parm_data->lock_type == __constant_cpu_to_le16(CIFS_UNLCK))
> +               if (parm_data->lock_type == cpu_to_le16(CIFS_UNLCK))
>                         pLockData->fl_type = F_UNLCK;
>                 else {
>                         if (parm_data->lock_type ==
> -                                       __constant_cpu_to_le16(CIFS_RDLCK))
> +                                       cpu_to_le16(CIFS_RDLCK))
>                                 pLockData->fl_type = F_RDLCK;
>                         else if (parm_data->lock_type ==
> -                                       __constant_cpu_to_le16(CIFS_WRLCK))
> +                                       cpu_to_le16(CIFS_WRLCK))
>                                 pLockData->fl_type = F_WRLCK;
>
>                         pLockData->fl_start = le64_to_cpu(parm_data->start);
> @@ -3232,25 +3232,25 @@ CIFSSMB_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
>         pSMB->compression_state = cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
>
>         pSMB->TotalParameterCount = 0;
> -       pSMB->TotalDataCount = __constant_cpu_to_le32(2);
> +       pSMB->TotalDataCount = cpu_to_le32(2);
>         pSMB->MaxParameterCount = 0;
>         pSMB->MaxDataCount = 0;
>         pSMB->MaxSetupCount = 4;
>         pSMB->Reserved = 0;
>         pSMB->ParameterOffset = 0;
> -       pSMB->DataCount = __constant_cpu_to_le32(2);
> +       pSMB->DataCount = cpu_to_le32(2);
>         pSMB->DataOffset =
>                 cpu_to_le32(offsetof(struct smb_com_transaction_compr_ioctl_req,
>                                 compression_state) - 4);  /* 84 */
>         pSMB->SetupCount = 4;
> -       pSMB->SubCommand = __constant_cpu_to_le16(NT_TRANSACT_IOCTL);
> +       pSMB->SubCommand = cpu_to_le16(NT_TRANSACT_IOCTL);
>         pSMB->ParameterCount = 0;
> -       pSMB->FunctionCode = __constant_cpu_to_le32(FSCTL_SET_COMPRESSION);
> +       pSMB->FunctionCode = cpu_to_le32(FSCTL_SET_COMPRESSION);
>         pSMB->IsFsctl = 1; /* FSCTL */
>         pSMB->IsRootFlag = 0;
>         pSMB->Fid = fid; /* file handle always le */
>         /* 3 byte pad, followed by 2 byte compress state */
> -       pSMB->ByteCount = __constant_cpu_to_le16(5);
> +       pSMB->ByteCount = cpu_to_le16(5);
>         inc_rfc1001_len(pSMB, 5);
>
>         rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> @@ -3386,10 +3386,10 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
>         cifs_acl->version = cpu_to_le16(1);
>         if (acl_type == ACL_TYPE_ACCESS) {
>                 cifs_acl->access_entry_count = cpu_to_le16(count);
> -               cifs_acl->default_entry_count = __constant_cpu_to_le16(0xFFFF);
> +               cifs_acl->default_entry_count = cpu_to_le16(0xFFFF);
>         } else if (acl_type == ACL_TYPE_DEFAULT) {
>                 cifs_acl->default_entry_count = cpu_to_le16(count);
> -               cifs_acl->access_entry_count = __constant_cpu_to_le16(0xFFFF);
> +               cifs_acl->access_entry_count = cpu_to_le16(0xFFFF);
>         } else {
>                 cifs_dbg(FYI, "unknown ACL type %d\n", acl_type);
>                 return 0;
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index e87387d..27e6175 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -46,7 +46,7 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *ses, SESSION_SETUP_ANDX *pSMB)
>                                         CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4,
>                                         USHRT_MAX));
>         pSMB->req.MaxMpxCount = cpu_to_le16(ses->server->maxReq);
> -       pSMB->req.VcNumber = __constant_cpu_to_le16(1);
> +       pSMB->req.VcNumber = cpu_to_le16(1);
>
>         /* Now no need to set SMBFLG_CASELESS or obsolete CANONICAL PATH */
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index b8021fd..36867bd 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -67,27 +67,27 @@ check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
>   *  indexed by command in host byte order
>   */
>  static const __le16 smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
> -       /* SMB2_NEGOTIATE */ __constant_cpu_to_le16(65),
> -       /* SMB2_SESSION_SETUP */ __constant_cpu_to_le16(9),
> -       /* SMB2_LOGOFF */ __constant_cpu_to_le16(4),
> -       /* SMB2_TREE_CONNECT */ __constant_cpu_to_le16(16),
> -       /* SMB2_TREE_DISCONNECT */ __constant_cpu_to_le16(4),
> -       /* SMB2_CREATE */ __constant_cpu_to_le16(89),
> -       /* SMB2_CLOSE */ __constant_cpu_to_le16(60),
> -       /* SMB2_FLUSH */ __constant_cpu_to_le16(4),
> -       /* SMB2_READ */ __constant_cpu_to_le16(17),
> -       /* SMB2_WRITE */ __constant_cpu_to_le16(17),
> -       /* SMB2_LOCK */ __constant_cpu_to_le16(4),
> -       /* SMB2_IOCTL */ __constant_cpu_to_le16(49),
> +       /* SMB2_NEGOTIATE */ cpu_to_le16(65),
> +       /* SMB2_SESSION_SETUP */ cpu_to_le16(9),
> +       /* SMB2_LOGOFF */ cpu_to_le16(4),
> +       /* SMB2_TREE_CONNECT */ cpu_to_le16(16),
> +       /* SMB2_TREE_DISCONNECT */ cpu_to_le16(4),
> +       /* SMB2_CREATE */ cpu_to_le16(89),
> +       /* SMB2_CLOSE */ cpu_to_le16(60),
> +       /* SMB2_FLUSH */ cpu_to_le16(4),
> +       /* SMB2_READ */ cpu_to_le16(17),
> +       /* SMB2_WRITE */ cpu_to_le16(17),
> +       /* SMB2_LOCK */ cpu_to_le16(4),
> +       /* SMB2_IOCTL */ cpu_to_le16(49),
>         /* BB CHECK this ... not listed in documentation */
> -       /* SMB2_CANCEL */ __constant_cpu_to_le16(0),
> -       /* SMB2_ECHO */ __constant_cpu_to_le16(4),
> -       /* SMB2_QUERY_DIRECTORY */ __constant_cpu_to_le16(9),
> -       /* SMB2_CHANGE_NOTIFY */ __constant_cpu_to_le16(9),
> -       /* SMB2_QUERY_INFO */ __constant_cpu_to_le16(9),
> -       /* SMB2_SET_INFO */ __constant_cpu_to_le16(2),
> +       /* SMB2_CANCEL */ cpu_to_le16(0),
> +       /* SMB2_ECHO */ cpu_to_le16(4),
> +       /* SMB2_QUERY_DIRECTORY */ cpu_to_le16(9),
> +       /* SMB2_CHANGE_NOTIFY */ cpu_to_le16(9),
> +       /* SMB2_QUERY_INFO */ cpu_to_le16(9),
> +       /* SMB2_SET_INFO */ cpu_to_le16(2),
>         /* BB FIXME can also be 44 for lease break */
> -       /* SMB2_OPLOCK_BREAK */ __constant_cpu_to_le16(24)
> +       /* SMB2_OPLOCK_BREAK */ cpu_to_le16(24)
>  };
>
>  int
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 35ddc3e..c58d7fc 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -547,7 +547,7 @@ smb2_clone_range(const unsigned int xid,
>                 goto cchunk_out;
>
>         /* For now array only one chunk long, will make more flexible later */
> -       pcchunk->ChunkCount = __constant_cpu_to_le32(1);
> +       pcchunk->ChunkCount = cpu_to_le32(1);
>         pcchunk->Reserved = 0;
>         pcchunk->Reserved2 = 0;
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 3802f8c..a6115cd 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1356,7 +1356,7 @@ SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
>         char *ret_data = NULL;
>
>         fsctl_input.CompressionState =
> -                       __constant_cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
> +                       cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
>
>         rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
>                         FSCTL_SET_COMPRESSION, true /* is_fsctl */,
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index 2022c54..934ac16 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -85,7 +85,7 @@
>  /* BB FIXME - analyze following length BB */
>  #define MAX_SMB2_HDR_SIZE 0x78 /* 4 len + 64 hdr + (2*24 wct) + 2 bct + 2 pad */
>
> -#define SMB2_PROTO_NUMBER __constant_cpu_to_le32(0x424d53fe)
> +#define SMB2_PROTO_NUMBER cpu_to_le32(0x424d53fe)
>
>  /*
>   * SMB2 Header Definition
> @@ -96,7 +96,7 @@
>   *
>   */
>
> -#define SMB2_HEADER_STRUCTURE_SIZE __constant_cpu_to_le16(64)
> +#define SMB2_HEADER_STRUCTURE_SIZE cpu_to_le16(64)
>
>  struct smb2_hdr {
>         __be32 smb2_buf_length; /* big endian on wire */
> @@ -137,16 +137,16 @@ struct smb2_transform_hdr {
>  } __packed;
>
>  /* Encryption Algorithms */
> -#define SMB2_ENCRYPTION_AES128_CCM     __constant_cpu_to_le16(0x0001)
> +#define SMB2_ENCRYPTION_AES128_CCM     cpu_to_le16(0x0001)
>
>  /*
>   *     SMB2 flag definitions
>   */
> -#define SMB2_FLAGS_SERVER_TO_REDIR     __constant_cpu_to_le32(0x00000001)
> -#define SMB2_FLAGS_ASYNC_COMMAND       __constant_cpu_to_le32(0x00000002)
> -#define SMB2_FLAGS_RELATED_OPERATIONS  __constant_cpu_to_le32(0x00000004)
> -#define SMB2_FLAGS_SIGNED              __constant_cpu_to_le32(0x00000008)
> -#define SMB2_FLAGS_DFS_OPERATIONS      __constant_cpu_to_le32(0x10000000)
> +#define SMB2_FLAGS_SERVER_TO_REDIR     cpu_to_le32(0x00000001)
> +#define SMB2_FLAGS_ASYNC_COMMAND       cpu_to_le32(0x00000002)
> +#define SMB2_FLAGS_RELATED_OPERATIONS  cpu_to_le32(0x00000004)
> +#define SMB2_FLAGS_SIGNED              cpu_to_le32(0x00000008)
> +#define SMB2_FLAGS_DFS_OPERATIONS      cpu_to_le32(0x10000000)
>
>  /*
>   *     Definitions for SMB2 Protocol Data Units (network frames)
> @@ -157,7 +157,7 @@ struct smb2_transform_hdr {
>   *
>   */
>
> -#define SMB2_ERROR_STRUCTURE_SIZE2 __constant_cpu_to_le16(9)
> +#define SMB2_ERROR_STRUCTURE_SIZE2 cpu_to_le16(9)
>
>  struct smb2_err_rsp {
>         struct smb2_hdr hdr;
> @@ -498,12 +498,12 @@ struct create_context {
>  #define SMB2_LEASE_HANDLE_CACHING_HE   0x02
>  #define SMB2_LEASE_WRITE_CACHING_HE    0x04
>
> -#define SMB2_LEASE_NONE                        __constant_cpu_to_le32(0x00)
> -#define SMB2_LEASE_READ_CACHING                __constant_cpu_to_le32(0x01)
> -#define SMB2_LEASE_HANDLE_CACHING      __constant_cpu_to_le32(0x02)
> -#define SMB2_LEASE_WRITE_CACHING       __constant_cpu_to_le32(0x04)
> +#define SMB2_LEASE_NONE                        cpu_to_le32(0x00)
> +#define SMB2_LEASE_READ_CACHING                cpu_to_le32(0x01)
> +#define SMB2_LEASE_HANDLE_CACHING      cpu_to_le32(0x02)
> +#define SMB2_LEASE_WRITE_CACHING       cpu_to_le32(0x04)
>
> -#define SMB2_LEASE_FLAG_BREAK_IN_PROGRESS __constant_cpu_to_le32(0x02)
> +#define SMB2_LEASE_FLAG_BREAK_IN_PROGRESS cpu_to_le32(0x02)
>
>  #define SMB2_LEASE_KEY_SIZE 16
>
> --
> 1.8.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
