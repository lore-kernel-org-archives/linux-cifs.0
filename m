From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix return code when failing to rename a file onto
 a directory
Date: Mon, 20 Nov 2017 15:17:41 -0600
Message-ID: <CAH2r5mspS0NuCboutJgk-P0V_ODO=6h8iuYfWGy=X=-R9Qz+Tg@mail.gmail.com>
References: <20171120052549.17909-1-lsahlber@redhat.com> <CAN05THT53nWN7w161L6CVc0ZjwFbBC+1zcO++z4DdXzQoh=CqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN05THT53nWN7w161L6CVc0ZjwFbBC+1zcO++z4DdXzQoh=CqQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

ok - makes sense - sounds like a great argument to focus on
compounding this one special case as an experiment to see how we will
do it more generally.

On Mon, Nov 20, 2017 at 3:09 PM, ronnie sahlberg
<ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hmm,
>
> Steve, disregard and drop this patch.
>
>
> We can do this much better once we have compounding support.
>
>
> On Mon, Nov 20, 2017 at 3:25 PM, Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> Cifs servers return ACCESS_DENIED when trying to rename onto a non-empty
>> directory. This is different from xfstest where we expect this to return
>> -EEXIST instead.
>>
>> This makes us pass xfstest  generic/245
>>
>> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/smb2inode.c |  7 +++++--
>>  fs/cifs/smb2pdu.c   | 10 +++++++++-
>>  fs/cifs/smb2proto.h |  2 +-
>>  3 files changed, 15 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
>> index 1238cd3552f9..6ada981f1f83 100644
>> --- a/fs/cifs/smb2inode.c
>> +++ b/fs/cifs/smb2inode.c
>> @@ -48,6 +48,7 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
>>         __u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
>>         struct cifs_open_parms oparms;
>>         struct cifs_fid fid;
>> +       struct smb2_file_all_info all_info;
>>
>>         utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
>>         if (!utf16_path)
>> @@ -60,7 +61,7 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
>>         oparms.fid = &fid;
>>         oparms.reconnect = false;
>>
>> -       rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
>> +       rc = SMB2_open(xid, &oparms, utf16_path, &oplock, &all_info, NULL);
>>         if (rc) {
>>                 kfree(utf16_path);
>>                 return rc;
>> @@ -86,7 +87,9 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
>>                 break;
>>         case SMB2_OP_RENAME:
>>                 tmprc = SMB2_rename(xid, tcon, fid.persistent_fid,
>> -                                   fid.volatile_fid, (__le16 *)data);
>> +                                   fid.volatile_fid, (__le16 *)data,
>> +                                   le32_to_cpu(all_info.Attributes) &
>> +                                   FILE_ATTRIBUTE_DIRECTORY);
>>                 break;
>>         case SMB2_OP_HARDLINK:
>>                 tmprc = SMB2_set_hardlink(xid, tcon, fid.persistent_fid,
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index 553d574940b9..56c71a58d971 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -3139,7 +3139,8 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
>>
>>  int
>>  SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
>> -           u64 persistent_fid, u64 volatile_fid, __le16 *target_file)
>> +           u64 persistent_fid, u64 volatile_fid, __le16 *target_file,
>> +           bool is_dir)
>>  {
>>         struct smb2_file_rename_info info;
>>         void **data;
>> @@ -3165,6 +3166,13 @@ SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
>>         rc = send_set_info(xid, tcon, persistent_fid, volatile_fid,
>>                 current->tgid, FILE_RENAME_INFORMATION, SMB2_O_INFO_FILE,
>>                 0, 2, data, size);
>> +       /* SMB2 servers responds with ACCESS_DENIED when trying to rename
>> +        * and replace onto a non-empty directory. Check for this and remap
>> +        * to EEXIST.
>> +        */
>> +       if (rc == -EACCES && is_dir)
>> +               rc = -EEXIST;
>> +
>>         kfree(data);
>>         return rc;
>>  }
>> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
>> index e9ab5227e7a8..69fa9a39c7fa 100644
>> --- a/fs/cifs/smb2proto.h
>> +++ b/fs/cifs/smb2proto.h
>> @@ -158,7 +158,7 @@ extern int SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
>>                                 struct cifs_search_info *srch_inf);
>>  extern int SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
>>                        u64 persistent_fid, u64 volatile_fid,
>> -                      __le16 *target_file);
>> +                      __le16 *target_file, bool is_dir);
>>  extern int SMB2_rmdir(const unsigned int xid, struct cifs_tcon *tcon,
>>                       u64 persistent_fid, u64 volatile_fid);
>>  extern int SMB2_set_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
>> --
>> 2.13.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
