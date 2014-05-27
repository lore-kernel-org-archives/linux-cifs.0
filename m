From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] CIFS: Fix memory leaks in SMB2_open
Date: Tue, 27 May 2014 05:28:22 -0500
Message-ID: <CAH2r5mteh=MZ1S_-jBKYz9KcWg5tKOM=F3X9Q3Tm9cH0NzgxKw@mail.gmail.com>
References: <1400935322-5157-1-git-send-email-pshilovsky@samba.org> <CADT32eJUyb=e5Bk78StKXb==hkM02xbgSjS6e3u_Ko1zd-wcsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pavel Shilovsky <pshilovsky@samba.org>,
	linux-cifs <linux-cifs@vger.kernel.org>, stable@vger.kernel.org
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CADT32eJUyb=e5Bk78StKXb==hkM02xbgSjS6e3u_Ko1zd-wcsg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, May 26, 2014 at 10:54 PM, Shirish Pargaonkar
<shirishpargaonkar@gmail.com> wrote:
> Looks correct.
>
> Reviewed-by: Shirish Pargaonkar <spargaonkar@suse.com>
>
> On Sat, May 24, 2014 at 7:42 AM, Pavel Shilovsky <pshilovsky@samba.org> wrote:
>> Cc: <stable@vger.kernel.org> # v3.12+
>> Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
>> ---
>>  fs/cifs/smb2pdu.c |    7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index b0037b6..b0b260d 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -1097,6 +1097,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>>         int rc = 0;
>>         unsigned int num_iovecs = 2;
>>         __u32 file_attributes = 0;
>> +       char *dhc_buf = NULL, *lc_buf = NULL;
>>
>>         cifs_dbg(FYI, "create/open\n");
>>
>> @@ -1163,6 +1164,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>>                         kfree(copy_path);
>>                         return rc;
>>                 }
>> +               lc_buf = iov[num_iovecs-1].iov_base;
>>         }
>>
>>         if (*oplock == SMB2_OPLOCK_LEVEL_BATCH) {
>> @@ -1177,9 +1179,10 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>>                 if (rc) {
>>                         cifs_small_buf_release(req);
>>                         kfree(copy_path);
>> -                       kfree(iov[num_iovecs-1].iov_base);
>> +                       kfree(lc_buf);
>>                         return rc;
>>                 }
>> +               dhc_buf = iov[num_iovecs-1].iov_base;
>>         }
>>
>>         rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
>> @@ -1211,6 +1214,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>>                 *oplock = rsp->OplockLevel;
>>  creat_exit:
>>         kfree(copy_path);
>> +       kfree(lc_buf);
>> +       kfree(dhc_buf);
>>         free_rsp_buf(resp_buftype, rsp);
>>         return rc;
>>  }
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
