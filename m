From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] smb2: Enforce sec= mount option
Date: Thu, 2 Mar 2017 17:29:20 -0600
Message-ID: <CAH2r5mtGJN3evZzDnn3hpbiSxqWzmnJvJnAUR7CXBLe8sAfEww@mail.gmail.com>
References: <20170118100557.19668-1-sprabhu@redhat.com> <1485351402.2736.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485351402.2736.2.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Wed, Jan 25, 2017 at 7:36 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2017-01-18 at 15:35 +0530, Sachin Prabhu wrote:
>> If the security type specified using a mount option is not supported,
>> the SMB2 session setup code changes the security type to RawNTLMSSP. We
>> should instead fail the mount and return an error.
>>
>> The patch changes the code for SMB2 to make it similar to the code used
>> for SMB1. Like in SMB1, we now use the global security flags to select
>> the security method to be used when no security method is specified and
>> to return an error when the requested auth method is not available.
>>
>> For SMB2, we also use ntlmv2 as a synonym for nltmssp.
>>
>> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/cifsglob.h  |  3 +++
>>  fs/cifs/cifsproto.h |  2 ++
>>  fs/cifs/connect.c   |  3 ++-
>>  fs/cifs/sess.c      |  4 ++--
>>  fs/cifs/smb1ops.c   |  1 +
>>  fs/cifs/smb2ops.c   |  4 ++++
>>  fs/cifs/smb2pdu.c   | 37 +++++++++++++++++++++++++++++++++----
>>  fs/cifs/smb2proto.h |  2 ++
>>  8 files changed, 49 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 7ea8a33..417af3f 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -433,6 +433,9 @@ struct smb_version_operations {
>>       bool (*dir_needs_close)(struct cifsFileInfo *);
>>       long (*fallocate)(struct file *, struct cifs_tcon *, int, loff_t,
>>                         loff_t);
>> +     enum securityEnum (*select_sectype)(struct TCP_Server_Info *,
>> +                         enum securityEnum);
>> +
>>  };
>>
>>  struct smb_version_values {
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index c7b3c84..88da716 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -519,4 +519,6 @@ int cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>>  int __cifs_calc_signature(struct smb_rqst *rqst,
>>                       struct TCP_Server_Info *server, char *signature,
>>                       struct shash_desc *shash);
>> +enum securityEnum cifs_select_sectype(struct TCP_Server_Info *,
>> +                                     enum securityEnum);
>>  #endif                       /* _CIFSPROTO_H */
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 35ae49e..327a6cb 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -2057,7 +2057,8 @@ match_security(struct TCP_Server_Info *server, struct smb_vol *vol)
>>        * that was specified, or "Unspecified" if that sectype was not
>>        * compatible with the given NEGOTIATE request.
>>        */
>> -     if (select_sectype(server, vol->sectype) == Unspecified)
>> +     if (server->ops->select_sectype(server, vol->sectype)
>> +          == Unspecified)
>>               return false;
>>
>>       /*
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 538d9b5..55c337d 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -500,7 +500,7 @@ int build_ntlmssp_auth_blob(unsigned char **pbuffer,
>>  }
>>
>>  enum securityEnum
>> -select_sectype(struct TCP_Server_Info *server, enum securityEnum requested)
>> +cifs_select_sectype(struct TCP_Server_Info *server, enum securityEnum requested)
>>  {
>>       switch (server->negflavor) {
>>       case CIFS_NEGFLAVOR_EXTENDED:
>> @@ -1390,7 +1390,7 @@ static int select_sec(struct cifs_ses *ses, struct sess_data *sess_data)
>>  {
>>       int type;
>>
>> -     type = select_sectype(ses->server, ses->sectype);
>> +     type = cifs_select_sectype(ses->server, ses->sectype);
>>       cifs_dbg(FYI, "sess setup type %d\n", type);
>>       if (type == Unspecified) {
>>               cifs_dbg(VFS,
>> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
>> index fc537c2..1399671 100644
>> --- a/fs/cifs/smb1ops.c
>> +++ b/fs/cifs/smb1ops.c
>> @@ -1087,6 +1087,7 @@ struct smb_version_operations smb1_operations = {
>>       .is_read_op = cifs_is_read_op,
>>       .wp_retry_size = cifs_wp_retry_size,
>>       .dir_needs_close = cifs_dir_needs_close,
>> +     .select_sectype = cifs_select_sectype,
>>  #ifdef CONFIG_CIFS_XATTR
>>       .query_all_EAs = CIFSSMBQAllEAs,
>>       .set_EA = CIFSSMBSetEA,
>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>> index 5d456eb..8d9fda2 100644
>> --- a/fs/cifs/smb2ops.c
>> +++ b/fs/cifs/smb2ops.c
>> @@ -1623,6 +1623,7 @@ struct smb_version_operations smb20_operations = {
>>       .clone_range = smb2_clone_range,
>>       .wp_retry_size = smb2_wp_retry_size,
>>       .dir_needs_close = smb2_dir_needs_close,
>> +     .select_sectype = smb2_select_sectype,
>>  };
>>
>>  struct smb_version_operations smb21_operations = {
>> @@ -1704,6 +1705,7 @@ struct smb_version_operations smb21_operations = {
>>       .wp_retry_size = smb2_wp_retry_size,
>>       .dir_needs_close = smb2_dir_needs_close,
>>       .enum_snapshots = smb3_enum_snapshots,
>> +     .select_sectype = smb2_select_sectype,
>>  };
>>
>>  struct smb_version_operations smb30_operations = {
>> @@ -1791,6 +1793,7 @@ struct smb_version_operations smb30_operations = {
>>       .dir_needs_close = smb2_dir_needs_close,
>>       .fallocate = smb3_fallocate,
>>       .enum_snapshots = smb3_enum_snapshots,
>> +     .select_sectype = smb2_select_sectype,
>>  };
>>
>>  #ifdef CONFIG_CIFS_SMB311
>> @@ -1879,6 +1882,7 @@ struct smb_version_operations smb311_operations = {
>>       .dir_needs_close = smb2_dir_needs_close,
>>       .fallocate = smb3_fallocate,
>>       .enum_snapshots = smb3_enum_snapshots,
>> +     .select_sectype = smb2_select_sectype,
>>  };
>>  #endif /* CIFS_SMB311 */
>>
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index 8745722..316045a 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -596,6 +596,28 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>>       return -EIO;
>>  }
>>
>> +enum securityEnum
>> +smb2_select_sectype(struct TCP_Server_Info *server, enum securityEnum requested)
>> +{
>> +     switch (requested) {
>> +     case Kerberos:
>> +     case RawNTLMSSP:
>> +             return requested;
>> +     case NTLMv2:
>> +             return RawNTLMSSP;
>> +     case Unspecified:
>> +             if (server->sec_ntlmssp &&
>> +                     (global_secflags & CIFSSEC_MAY_NTLMSSP))
>> +                     return RawNTLMSSP;
>> +             if ((server->sec_kerberos || server->sec_mskerberos) &&
>> +                     (global_secflags & CIFSSEC_MAY_KRB5))
>> +                     return Kerberos;
>> +             /* Fallthrough */
>> +     default:
>> +             return Unspecified;
>> +     }
>> +}
>> +
>>  struct SMB2_sess_data {
>>       unsigned int xid;
>>       struct cifs_ses *ses;
>> @@ -958,10 +980,17 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
>>  static int
>>  SMB2_select_sec(struct cifs_ses *ses, struct SMB2_sess_data *sess_data)
>>  {
>> -     if (ses->sectype != Kerberos && ses->sectype != RawNTLMSSP)
>> -             ses->sectype = RawNTLMSSP;
>> +     int type;
>> +
>> +     type = smb2_select_sectype(ses->server, ses->sectype);
>> +     cifs_dbg(FYI, "sess setup type %d\n", type);
>> +     if (type == Unspecified) {
>> +             cifs_dbg(VFS,
>> +                     "Unable to select appropriate authentication method!");
>> +             return -EINVAL;
>> +     }
>>
>> -     switch (ses->sectype) {
>> +     switch (type) {
>>       case Kerberos:
>>               sess_data->func = SMB2_auth_kerberos;
>>               break;
>> @@ -969,7 +998,7 @@ SMB2_select_sec(struct cifs_ses *ses, struct SMB2_sess_data *sess_data)
>>               sess_data->func = SMB2_sess_auth_rawntlmssp_negotiate;
>>               break;
>>       default:
>> -             cifs_dbg(VFS, "secType %d not supported!\n", ses->sectype);
>> +             cifs_dbg(VFS, "secType %d not supported!\n", type);
>>               return -EOPNOTSUPP;
>>       }
>>
>> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
>> index f2d511a..2f0a5a2 100644
>> --- a/fs/cifs/smb2proto.h
>> +++ b/fs/cifs/smb2proto.h
>> @@ -175,4 +175,6 @@ extern int SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
>>                           __u8 *lease_key, const __le32 lease_state);
>>  extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);
>>
>> +extern enum securityEnum smb2_select_sectype(struct TCP_Server_Info *,
>> +                                     enum securityEnum);
>>  #endif                       /* _SMB2PROTO_H */
>
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
