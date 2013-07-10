From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/8] CIFS: Respect create_options in smb2_open_file
Date: Wed, 10 Jul 2013 09:45:50 -0500
Message-ID: <CAH2r5mtvpFs8un95EkNWZLptifoExrm1bJ30UbHi-DEb1ENWxw@mail.gmail.com>
References: <1373450401-4135-1-git-send-email-pshilovsky@samba.org>
	<1373450401-4135-3-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373450401-4135-3-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Won't we need the file attributes parm on SMB2 create to pass in on
the call to create symlink (where we have to pass that it is a reparse
point)?

On Wed, Jul 10, 2013 at 4:59 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> and eliminated unused file_attribute parms of SMB2_open.
>
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/smb2file.c  |    2 +-
>  fs/cifs/smb2inode.c |   25 ++++++++++++-------------
>  fs/cifs/smb2ops.c   |    6 +++---
>  fs/cifs/smb2pdu.c   |   10 +++++++---
>  fs/cifs/smb2proto.h |    4 ++--
>  5 files changed, 25 insertions(+), 22 deletions(-)
>
> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> index 5da1b55..46a4299 100644
> --- a/fs/cifs/smb2file.c
> +++ b/fs/cifs/smb2file.c
> @@ -88,7 +88,7 @@ smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
>
>         rc = SMB2_open(xid, tcon, smb2_path, &fid->persistent_fid,
>                        &fid->volatile_fid, desired_access, disposition,
> -                      0, 0, smb2_oplock, smb2_data);
> +                      create_options, smb2_oplock, smb2_data);
>         if (rc)
>                 goto out;
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index fff6dfb..f50eefd 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -41,8 +41,7 @@ static int
>  smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
>                    struct cifs_sb_info *cifs_sb, const char *full_path,
>                    __u32 desired_access, __u32 create_disposition,
> -                  __u32 file_attributes, __u32 create_options,
> -                  void *data, int command)
> +                  __u32 create_options, void *data, int command)
>  {
>         int rc, tmprc = 0;
>         u64 persistent_fid, volatile_fid;
> @@ -54,8 +53,8 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
>                 return -ENOMEM;
>
>         rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
> -                      desired_access, create_disposition, file_attributes,
> -                      create_options, &oplock, NULL);
> +                      desired_access, create_disposition, create_options,
> +                      &oplock, NULL);
>         if (rc) {
>                 kfree(utf16_path);
>                 return rc;
> @@ -129,8 +128,8 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>                 return -ENOMEM;
>
>         rc = smb2_open_op_close(xid, tcon, cifs_sb, full_path,
> -                               FILE_READ_ATTRIBUTES, FILE_OPEN, 0, 0,
> -                               smb2_data, SMB2_OP_QUERY_INFO);
> +                               FILE_READ_ATTRIBUTES, FILE_OPEN, 0, smb2_data,
> +                               SMB2_OP_QUERY_INFO);
>         if (rc)
>                 goto out;
>
> @@ -145,7 +144,7 @@ smb2_mkdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
>            struct cifs_sb_info *cifs_sb)
>  {
>         return smb2_open_op_close(xid, tcon, cifs_sb, name,
> -                                 FILE_WRITE_ATTRIBUTES, FILE_CREATE, 0,
> +                                 FILE_WRITE_ATTRIBUTES, FILE_CREATE,
>                                   CREATE_NOT_FILE, NULL, SMB2_OP_MKDIR);
>  }
>
> @@ -164,7 +163,7 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
>         dosattrs = cifs_i->cifsAttrs | ATTR_READONLY;
>         data.Attributes = cpu_to_le32(dosattrs);
>         tmprc = smb2_open_op_close(xid, tcon, cifs_sb, name,
> -                                  FILE_WRITE_ATTRIBUTES, FILE_CREATE, 0,
> +                                  FILE_WRITE_ATTRIBUTES, FILE_CREATE,
>                                    CREATE_NOT_FILE, &data, SMB2_OP_SET_INFO);
>         if (tmprc == 0)
>                 cifs_i->cifsAttrs = dosattrs;
> @@ -175,7 +174,7 @@ smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
>            struct cifs_sb_info *cifs_sb)
>  {
>         return smb2_open_op_close(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
> -                                 0, CREATE_NOT_FILE | CREATE_DELETE_ON_CLOSE,
> +                                 CREATE_NOT_FILE | CREATE_DELETE_ON_CLOSE,
>                                   NULL, SMB2_OP_DELETE);
>  }
>
> @@ -184,7 +183,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
>             struct cifs_sb_info *cifs_sb)
>  {
>         return smb2_open_op_close(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
> -                                 0, CREATE_DELETE_ON_CLOSE, NULL,
> +                                 CREATE_DELETE_ON_CLOSE, NULL,
>                                   SMB2_OP_DELETE);
>  }
>
> @@ -203,7 +202,7 @@ smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
>         }
>
>         rc = smb2_open_op_close(xid, tcon, cifs_sb, from_name, access,
> -                               FILE_OPEN, 0, 0, smb2_to_name, command);
> +                               FILE_OPEN, 0, smb2_to_name, command);
>  smb2_rename_path:
>         kfree(smb2_to_name);
>         return rc;
> @@ -234,7 +233,7 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
>  {
>         __le64 eof = cpu_to_le64(size);
>         return smb2_open_op_close(xid, tcon, cifs_sb, full_path,
> -                                 FILE_WRITE_DATA, FILE_OPEN, 0, 0, &eof,
> +                                 FILE_WRITE_DATA, FILE_OPEN, 0, &eof,
>                                   SMB2_OP_SET_EOF);
>  }
>
> @@ -250,7 +249,7 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
>         if (IS_ERR(tlink))
>                 return PTR_ERR(tlink);
>         rc = smb2_open_op_close(xid, tlink_tcon(tlink), cifs_sb, full_path,
> -                               FILE_WRITE_ATTRIBUTES, FILE_OPEN, 0, 0, buf,
> +                               FILE_WRITE_ATTRIBUTES, FILE_OPEN, 0, buf,
>                                 SMB2_OP_SET_INFO);
>         cifs_put_tlink(tlink);
>         return rc;
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 92aa87c..85b15e0 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -222,7 +222,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
>                 return -ENOMEM;
>
>         rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
> -                      FILE_READ_ATTRIBUTES, FILE_OPEN, 0, 0, &oplock, NULL);
> +                      FILE_READ_ATTRIBUTES, FILE_OPEN, 0, &oplock, NULL);
>         if (rc) {
>                 kfree(utf16_path);
>                 return rc;
> @@ -450,7 +450,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
>                 return -ENOMEM;
>
>         rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
> -                      FILE_READ_ATTRIBUTES | FILE_READ_DATA, FILE_OPEN, 0, 0,
> +                      FILE_READ_ATTRIBUTES | FILE_READ_DATA, FILE_OPEN, 0,
>                        &oplock, NULL);
>         kfree(utf16_path);
>         if (rc) {
> @@ -533,7 +533,7 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
>         u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
>
>         rc = SMB2_open(xid, tcon, &srch_path, &persistent_fid, &volatile_fid,
> -                      FILE_READ_ATTRIBUTES, FILE_OPEN, 0, 0, &oplock, NULL);
> +                      FILE_READ_ATTRIBUTES, FILE_OPEN, 0, &oplock, NULL);
>         if (rc)
>                 return rc;
>         buf->f_type = SMB2_MAGIC_NUMBER;
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 19fafeb..4c046a5 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -881,8 +881,8 @@ parse_lease_state(struct smb2_create_rsp *rsp)
>  int
>  SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
>           u64 *persistent_fid, u64 *volatile_fid, __u32 desired_access,
> -         __u32 create_disposition, __u32 file_attributes, __u32 create_options,
> -         __u8 *oplock, struct smb2_file_all_info *buf)
> +         __u32 create_disposition, __u32 create_options, __u8 *oplock,
> +         struct smb2_file_all_info *buf)
>  {
>         struct smb2_create_req *req;
>         struct smb2_create_rsp *rsp;
> @@ -895,6 +895,7 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
>         int copy_size;
>         int rc = 0;
>         int num_iovecs = 2;
> +       __u32 file_attributes = 0;
>
>         cifs_dbg(FYI, "create/open\n");
>
> @@ -907,13 +908,16 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
>         if (rc)
>                 return rc;
>
> +       if (create_options & CREATE_OPTION_READONLY)
> +               file_attributes |= ATTR_READONLY;
> +
>         req->ImpersonationLevel = IL_IMPERSONATION;
>         req->DesiredAccess = cpu_to_le32(desired_access);
>         /* File attributes ignored on open (used in create though) */
>         req->FileAttributes = cpu_to_le32(file_attributes);
>         req->ShareAccess = FILE_SHARE_ALL_LE;
>         req->CreateDisposition = cpu_to_le32(create_disposition);
> -       req->CreateOptions = cpu_to_le32(create_options);
> +       req->CreateOptions = cpu_to_le32(create_options & CREATE_OPTIONS_MASK);
>         uni_path_len = (2 * UniStrnlen((wchar_t *)path, PATH_MAX)) + 2;
>         req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req)
>                         - 8 /* pad */ - 4 /* do not count rfc1001 len field */);
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index d4e1eb8..d71a3e2 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -109,8 +109,8 @@ extern int SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon);
>  extern int SMB2_open(const unsigned int xid, struct cifs_tcon *tcon,
>                      __le16 *path, u64 *persistent_fid, u64 *volatile_fid,
>                      __u32 desired_access, __u32 create_disposition,
> -                    __u32 file_attributes, __u32 create_options,
> -                    __u8 *oplock, struct smb2_file_all_info *buf);
> +                    __u32 create_options, __u8 *oplock,
> +                    struct smb2_file_all_info *buf);
>  extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
>                      u64 persistent_fid, u64 volatile_fid, u32 opcode,
>                      bool is_fsctl, char *in_data, u32 indatalen,
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
