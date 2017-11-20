From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix NULL deref in SMB2_read
Date: Mon, 20 Nov 2017 17:19:44 -0600
Message-ID: <CAH2r5mv4tt9o4hDGr=mhv44z7cYLDnTGacWDhZQt+7+U6uSTRg@mail.gmail.com>
References: <20171120223633.16117-1-lsahlber@redhat.com> <CAKywueS8zm74iEVCosJwZhk=UyXogiFJQTYQGuSDnkGVVdDunA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueS8zm74iEVCosJwZhk=UyXogiFJQTYQGuSDnkGVVdDunA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git for-next

added cc:stable

On Mon, Nov 20, 2017 at 4:52 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2017-11-20 14:36 GMT-08:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/smb2pdu.c | 30 +++++++++++++++---------------
>>  1 file changed, 15 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index f92b39bbb929..a555d2b39b30 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -2649,27 +2649,27 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
>>         cifs_small_buf_release(req);
>>
>>         rsp = (struct smb2_read_rsp *)rsp_iov.iov_base;
>> -       shdr = get_sync_hdr(rsp);
>>
>> -       if (shdr->Status == STATUS_END_OF_FILE) {
>> +       if (rc) {
>> +               if (rc != -ENODATA) {
>> +                       cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
>> +                       cifs_dbg(VFS, "Send error in read = %d\n", rc);
>> +               }
>>                 free_rsp_buf(resp_buftype, rsp_iov.iov_base);
>> -               return 0;
>> +               return rc == -ENODATA ? 0 : rc;
>>         }
>>
>> -       if (rc) {
>> -               cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
>> -               cifs_dbg(VFS, "Send error in read = %d\n", rc);
>> -       } else {
>> -               *nbytes = le32_to_cpu(rsp->DataLength);
>> -               if ((*nbytes > CIFS_MAX_MSGSIZE) ||
>> -                   (*nbytes > io_parms->length)) {
>> -                       cifs_dbg(FYI, "bad length %d for count %d\n",
>> -                                *nbytes, io_parms->length);
>> -                       rc = -EIO;
>> -                       *nbytes = 0;
>> -               }
>> +       *nbytes = le32_to_cpu(rsp->DataLength);
>> +       if ((*nbytes > CIFS_MAX_MSGSIZE) ||
>> +           (*nbytes > io_parms->length)) {
>> +               cifs_dbg(FYI, "bad length %d for count %d\n",
>> +                        *nbytes, io_parms->length);
>> +               rc = -EIO;
>> +               *nbytes = 0;
>>         }
>>
>> +       shdr = get_sync_hdr(rsp);
>> +
>>         if (*buf) {
>>                 memcpy(*buf, (char *)shdr + rsp->DataOffset, *nbytes);
>>                 free_rsp_buf(resp_buftype, rsp_iov.iov_base);
>> --
>> 2.13.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> Stable candidate?
>
> --
> Best regards,
> Pavel Shilovsky



-- 
Thanks,

Steve
