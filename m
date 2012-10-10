From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SMB2.02 dialect support
Date: Wed, 10 Oct 2012 09:07:45 +0400
Message-ID: <CAKywueSdcj2wYhrbtptxzfuY3E8F7JnK_yn7NAjpHx5Z5hErqg@mail.gmail.com>
References: <CAH2r5mtTeck3n4PF3Wb5XgwzZSHEtYw1skMj1MTY=+VugH1umA@mail.gmail.com>
	<CAKywueQ=u1TyfHtGNuGoEQtAxX2Ea=GtBT=1bcO_Mmma_g+6iw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQ=u1TyfHtGNuGoEQtAxX2Ea=GtBT=1bcO_Mmma_g+6iw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/10/10 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> 2012/10/10 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> This patch enables optional (via Kconfig, specifying vers=2.0 on
>> mount) support for testing SMB2.02 dialect
>>
>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>> index 2075ddf..461e2f5 100644
>> --- a/fs/cifs/Kconfig
>> +++ b/fs/cifs/Kconfig
>> @@ -172,6 +172,21 @@ config CIFS_SMB2
>>
>>           Unless you are a developer or tester, say N.
>>
>> +config CIFS_SMB20_DIALECT
>> +         bool "Support for original SMB2.0 dialect (EXPERIMENTAL)"
>> +         depends on CIFS && CIFS_SMB2
>> +
>> +         help
>> +           This enables experimental support for the original SMB2.02 dialect.
>> +           This could be helpful for developers testing against the earliest
>> +            SMB2 capable servers such as Windows Vista, Samba Version 3.6
>> +           and Windows 2008.  Without this selection enabled, only the
>> +           more recent SMB2.1 and SMB3 dialects are enabled.  Since SMB2.1
>> +           and SMB3 dialects are better than the original SMB2 dialect for
>> +           more recent servers (such as Windows 2008R2, Windows 7, and Samba 4),
>> +           and earlier servers support the cifs protocol well, unless you are a
>> +           developer or tester, say N.
>> +
>>  config CIFS_FSCACHE
>>           bool "Provide CIFS client caching support"
>>           depends on CIFS=m && FSCACHE || CIFS=y && FSCACHE=y
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index f5af252..3763624 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -178,6 +178,7 @@ struct smb_rqst {
>>
>>  enum smb_version {
>>         Smb_1 = 1,
>> +       Smb_20,
>>         Smb_21,
>>         Smb_30,
>>  };
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 5c670b9..8a17cf2 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -274,6 +274,7 @@ static const match_table_t cifs_cacheflavor_tokens = {
>>
>>  static const match_table_t cifs_smb_version_tokens = {
>>         { Smb_1, SMB1_VERSION_STRING },
>> +       { Smb_20, SMB20_VERSION_STRING},
>>         { Smb_21, SMB21_VERSION_STRING },
>>         { Smb_30, SMB30_VERSION_STRING },
>>  };
>> @@ -1074,6 +1075,11 @@ cifs_parse_smb_version(char *value, struct smb_vol *vol)
>>                 vol->vals = &smb1_values;
>>                 break;
>>  #ifdef CONFIG_CIFS_SMB2
>> +#ifdef CONFIG_CIFS_SMB20_DIALECT
>> +       case Smb_20:
>> +               vol->ops = &smb21_operations; /* currently identical with 2.1 */
>> +               vol->vals = &smb20_values;
>> +#endif /* CIFS_SMB20_DIALECT */
>>         case Smb_21:
>>                 vol->ops = &smb21_operations;
>>                 vol->vals = &smb21_values;
>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>> index 4d9dbe0..3dd47dc 100644
>> --- a/fs/cifs/smb2ops.c
>> +++ b/fs/cifs/smb2ops.c
>> @@ -643,6 +643,25 @@ struct smb_version_operations smb21_operations = {
>>         .new_lease_key = smb2_new_lease_key,
>>  };
>>
>> +#ifdef CONFIG_CIFS_SMB20_DIALECT
>> +struct smb_version_values smb20_values = {
>> +       .version_string = SMB20_VERSION_STRING,
>> +       .protocol_id = SMB20_PROT_ID,
>> +       .req_capabilities = 0, /* MBZ */
>> +       .large_lock_type = 0,
>> +       .exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
>> +       .shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
>> +       .unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
>> +       .header_size = sizeof(struct smb2_hdr),
>> +       .max_header_size = MAX_SMB2_HDR_SIZE,
>> +       .read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
>> +       .lock_cmd = SMB2_LOCK,
>> +       .cap_unix = 0,
>> +       .cap_nt_find = SMB2_NT_FIND,
>> +       .cap_large_files = SMB2_LARGE_FILES,
>> +};
>> +#endif /* CONFIG_CIFS_SMB2_DIALECT */
>> +
>>  struct smb_version_values smb21_values = {
>>         .version_string = SMB21_VERSION_STRING,
>>         .protocol_id = SMB21_PROT_ID,
>>
>> --
>> Thanks,
>>
>> Steve
>
> What's a problem with a non-experimental support of SMB2.0 dialect? In
> this case we don't need to add new Kconfig option.

to be clear: I mean "non-testing" rather than "non-experimental"
(because all SMB2.x related code is experimental now),

-- 
Best regards,
Pavel Shilovsky.
