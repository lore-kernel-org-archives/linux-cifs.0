From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [SMB3] Send durable handle v2 contexts when use of
 persistent handles required
Date: Sun, 4 Oct 2015 00:03:23 -0500
Message-ID: <CAH2r5msFv=mbnOkaUpnt6GxFBqymzt5fpFMBCMM9jiTwnD-vpw@mail.gmail.com>
References: <1443723435-32484-1-git-send-email-smfrench@gmail.com> <CAKywueTcLJ0__8mSaD5LGG6rVp2PiNnJhC0br1NcyHc6rTQrwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTcLJ0__8mSaD5LGG6rVp2PiNnJhC0br1NcyHc6rTQrwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Updated and resent the 4 patch series onto linux-cifs and also pushed
to cifs-2.6.git experimental branch.

I don't know if channel sequence number in the SMB3 request would also
need to be incremented on disconnect though (the documentation is
confusing on that in MS-SMB2) in the case where we only have one
channel.

Also wondering if I should add a mount option for resilient handles to
allow us to force better reliability of connections to non-clustered
servers (and presumably could work even to Windows 8 and 8.1 and
Windows 10 servers) when the application would prefer that (to the
less strict guarantees of durable handles)

On Sat, Oct 3, 2015 at 2:41 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2015-10-01 21:17 GMT+03:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
>> ---
>>  fs/cifs/cifsglob.h |   1 +
>>  fs/cifs/smb2pdu.c  | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  fs/cifs/smb2pdu.h  |  30 ++++++++++++++
>>  3 files changed, 144 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 51353bb..ec31a03 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -1022,6 +1022,7 @@ struct cifs_fid {
>>         __u64 persistent_fid;   /* persist file id for smb2 */
>>         __u64 volatile_fid;     /* volatile file id for smb2 */
>>         __u8 lease_key[SMB2_LEASE_KEY_SIZE];    /* lease key for smb2 */
>> +       __u8 create_guid[16];
>>  #endif
>>         struct cifs_pending_open *pending_open;
>>         unsigned int epoch;
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index c744b57..6b899bf 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -1100,6 +1100,68 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
>>         return buf;
>>  }
>>
>> +static struct create_durable_v2 *
>> +create_durable_v2_buf(struct cifs_fid *pfid)
>> +{
>> +       struct create_durable_v2 *buf;
>> +
>> +       buf = kzalloc(sizeof(struct create_durable), GFP_KERNEL);
>> +       if (!buf)
>> +               return NULL;
>> +
>> +       buf->ccontext.DataOffset = cpu_to_le16(offsetof
>> +                                       (struct create_durable_v2, dcontext));
>> +       buf->ccontext.DataLength = cpu_to_le32(sizeof(struct durable_context_v2));
>> +       buf->ccontext.NameOffset = cpu_to_le16(offsetof
>> +                               (struct create_durable_v2, Name));
>> +       buf->ccontext.NameLength = cpu_to_le16(4);
>> +
>> +       buf->dcontext.Timeout = 0; /* Should this be configurable by workload */
>> +       buf->dcontext.Flags = cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT);
>> +       get_random_bytes(buf->dcontext.CreateGuid, 16);
>> +       memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 16);
>> +
>> +       /* SMB2_CREATE_DURABLE_HANDLE_REQUEST is "DH2Q" */
>> +       buf->Name[0] = 'D';
>> +       buf->Name[1] = 'H';
>> +       buf->Name[2] = '2';
>> +       buf->Name[3] = 'Q';
>> +       return buf;
>> +}
>> +
>> +static struct create_durable_handle_reconnect_v2 *
>> +create_reconnect_durable_v2_buf(struct cifs_fid *fid)
>> +{
>> +       struct create_durable_handle_reconnect_v2 *buf;
>> +
>> +       buf = kzalloc(sizeof(struct create_durable_handle_reconnect_v2),
>> +                       GFP_KERNEL);
>> +       if (!buf)
>> +               return NULL;
>> +
>> +       buf->ccontext.DataOffset =
>> +               cpu_to_le16(offsetof(struct create_durable_handle_reconnect_v2,
>> +                                    dcontext));
>> +       buf->ccontext.DataLength =
>> +               cpu_to_le32(sizeof(struct durable_reconnect_context_v2));
>> +       buf->ccontext.NameOffset =
>> +               cpu_to_le16(offsetof(struct create_durable_handle_reconnect_v2,
>> +                           Name));
>> +       buf->ccontext.NameLength = cpu_to_le16(4);
>> +
>> +       buf->dcontext.Fid.PersistentFileId = fid->persistent_fid;
>> +       buf->dcontext.Fid.VolatileFileId = fid->volatile_fid;
>> +       buf->dcontext.Flags = cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT);
>> +       memcpy(buf->dcontext.CreateGuid, fid->create_guid, 16);
>> +
>> +       /* SMB2_CREATE_DURABLE_HANDLE_RECONNECT_V2 is "DH2C" */
>> +       buf->Name[0] = 'D';
>> +       buf->Name[1] = 'H';
>> +       buf->Name[2] = '2';
>> +       buf->Name[3] = 'C';
>> +       return buf;
>> +}
>> +
>>  static __u8
>>  parse_lease_state(struct TCP_Server_Info *server, struct smb2_create_rsp *rsp,
>>                   unsigned int *epoch)
>> @@ -1174,6 +1236,48 @@ add_durable_context(struct kvec *iov, unsigned int *num_iovec,
>>         return 0;
>>  }
>>
>> +static int
>> +add_durable_v2_context(struct kvec *iov, unsigned int *num_iovec,
>> +                   struct cifs_open_parms *oparms)
>> +{
>> +       struct smb2_create_req *req = iov[0].iov_base;
>> +       unsigned int num = *num_iovec;
>> +
>> +       iov[num].iov_base = create_durable_v2_buf(oparms->fid);
>> +       if (iov[num].iov_base == NULL)
>> +               return -ENOMEM;
>> +       iov[num].iov_len = sizeof(struct create_durable_v2);
>> +       if (!req->CreateContextsOffset)
>> +               req->CreateContextsOffset =
>> +                       cpu_to_le32(sizeof(struct smb2_create_req) - 4 +
>> +                                                               iov[1].iov_len);
>> +       le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_durable_v2));
>> +       inc_rfc1001_len(&req->hdr, sizeof(struct create_durable_v2));
>> +       *num_iovec = num + 1;
>> +       return 0;
>> +}
>> +
>> +static int
>> +add_durable_reconnect_v2_context(struct kvec *iov, unsigned int *num_iovec,
>> +                   struct cifs_open_parms *oparms)
>> +{
>> +       struct smb2_create_req *req = iov[0].iov_base;
>> +       unsigned int num = *num_iovec;
>> +
>> +       iov[num].iov_base = create_reconnect_durable_v2_buf(oparms->fid);
>> +       if (iov[num].iov_base == NULL)
>> +               return -ENOMEM;
>> +       iov[num].iov_len = sizeof(struct create_durable_handle_reconnect_v2);
>> +       if (!req->CreateContextsOffset)
>> +               req->CreateContextsOffset =
>> +                       cpu_to_le32(sizeof(struct smb2_create_req) - 4 +
>> +                                                               iov[1].iov_len);
>> +       le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_durable_handle_reconnect_v2));
>> +       inc_rfc1001_len(&req->hdr, sizeof(struct create_durable_handle_reconnect_v2));
>> +       *num_iovec = num + 1;
>> +       return 0;
>> +}
>> +
>>  int
>>  SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>>           __u8 *oplock, struct smb2_file_all_info *buf,
>> @@ -1272,7 +1376,15 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>>                         ccontext->Next =
>>                                 cpu_to_le32(server->vals->create_lease_size);
>>                 }
>> -               rc = add_durable_context(iov, &num_iovecs, oparms);
>> +               if (tcon->use_persistent) {
>> +                       if (oparms->reconnect)
>> +                               rc = add_durable_reconnect_v2_context(iov,
>> +                                                       &num_iovecs, oparms);
>> +                       else
>> +                               rc = add_durable_v2_context(iov, &num_iovecs,
>> +                                                       oparms);
>> +               } else
>> +                       rc = add_durable_context(iov, &num_iovecs, oparms);
>
> I think it will be better to incapsulate this if statements into
> add_durable_context() function to leave SMB2_open() code more generic.
>
>>                 if (rc) {
>>                         cifs_small_buf_release(req);
>>                         kfree(copy_path);
>> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
>> index b26da75..a939526 100644
>> --- a/fs/cifs/smb2pdu.h
>> +++ b/fs/cifs/smb2pdu.h
>> @@ -590,6 +590,36 @@ struct create_durable {
>>         } Data;
>>  } __packed;
>>
>> +/* Flags */
>> +#define SMB2_DHANDLE_FLAG_PERSISTENT   0x00000002
>> +struct durable_context_v2 {
>> +       __le32 Timeout;
>> +       __le32 Flags;
>> +       __u64 Reserved;
>> +       __u8 CreateGuid[16];
>> +} __packed;
>> +
>> +struct create_durable_v2 {
>> +       struct create_context ccontext;
>> +       __u8   Name[8];
>> +       struct durable_context_v2 dcontext;
>> +} __packed;
>> +
>> +struct durable_reconnect_context_v2 {
>> +       struct {
>> +               __u64 PersistentFileId;
>> +               __u64 VolatileFileId;
>> +       } Fid;
>> +       __u8 CreateGuid[16];
>> +       __le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
>> +} __packed;
>> +
>> +struct create_durable_handle_reconnect_v2 {
>> +       struct create_context ccontext;
>> +       __u8   Name[8];
>> +       struct durable_reconnect_context_v2 dcontext;
>> +} __packed;
>> +
>>  #define COPY_CHUNK_RES_KEY_SIZE        24
>>  struct resume_key_req {
>>         char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Other than the note above the patch looks good.
>
> --
> Best regards,
> Pavel Shilovsky.



-- 
Thanks,

Steve
