From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH][CIFS] SMB2/SMB3 Copy offload support (refcopy) finishup
Date: Sat, 16 Nov 2013 18:09:41 -0600
Message-ID: <CAH2r5mugD_X-Z-CnOvLWjX2K1upYs8HzME48kYow1V7fvPAQWA@mail.gmail.com>
References: <CAH2r5muLwHY_e8QJP5N4veyqem4mQ9rOJC87nOeHYVyvFmWLsw@mail.gmail.com>
	<20131116195053.3d7872c4@linux-y6zt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131116195053.3d7872c4-YPm9Da2z600mLA1+wDPeuw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

sending updated patch to include your feedback

On Sat, Nov 16, 2013 at 12:50 PM, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org> wrote:
> On Sat, 16 Nov 2013 01:14:19 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>>  fs/cifs/smb2ops.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++-------
>>  fs/cifs/smb2pdu.c |  2 +-
>>  2 files changed, 79 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>> index 11dde4b..7a21447 100644
>> --- a/fs/cifs/smb2ops.c
>> +++ b/fs/cifs/smb2ops.c
>> @@ -532,7 +532,10 @@ smb2_clone_range(const unsigned int xid,
>>       int rc;
>>       unsigned int ret_data_len;
>>       struct copychunk_ioctl *pcchunk;
>> -     char *retbuf = NULL;
>> +     struct copychunk_ioctl_rsp *retbuf = NULL;
>> +     struct cifs_tcon *tcon;
>> +     int chunks_copied = 0;
>> +     bool chunk_sizes_updated = false;
>>
>>       pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
>>
>> @@ -552,22 +555,86 @@ smb2_clone_range(const unsigned int xid,
>
> The SMB2_request_res_key() error path above here should be fixed to free
> pcchunk.
>
>>       /* For now array only one chunk long, will make more flexible later */
>>       pcchunk->ChunkCount = __constant_cpu_to_le32(1);
>>       pcchunk->Reserved = 0;
>> -     pcchunk->SourceOffset = cpu_to_le64(src_off);
>> -     pcchunk->TargetOffset = cpu_to_le64(dest_off);
>> -     pcchunk->Length = cpu_to_le32(len);
>>       pcchunk->Reserved2 = 0;
>>
>> +     tcon = tlink_tcon(trgtfile->tlink);
>> +
>> +     while (len > 0) {
>> +             pcchunk->SourceOffset = cpu_to_le64(src_off);
>> +             pcchunk->TargetOffset = cpu_to_le64(dest_off);
>> +             pcchunk->Length =
>> +                     cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk));
>> +
>>       /* Request that server copy to target from src file identified by key */
>
> Comment should be indented here too.
>
>> -     rc = SMB2_ioctl(xid, tlink_tcon(trgtfile->tlink),
>> -                     trgtfile->fid.persistent_fid,
>> +             rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
>>                       trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
>>                       true /* is_fsctl */, (char *)pcchunk,
>> -                     sizeof(struct copychunk_ioctl), &retbuf, &ret_data_len);
>> -
>> -     /* BB need to special case rc = EINVAL to alter chunk size */
>> -
>> -     cifs_dbg(FYI, "rc %d data length out %d\n", rc, ret_data_len);
>> +                     sizeof(struct copychunk_ioctl), (char **)&retbuf,
>> +                     &ret_data_len);
>> +             if (rc == 0) {
>> +                     if (ret_data_len != sizeof(struct copychunk_ioctl_rsp))
>> +                             goto cchunk_out;
>> +                     if (retbuf->TotalBytesWritten == 0) {
>> +                             cifs_dbg(FYI, "no bytes copied\n");
>> +                             goto cchunk_out;
>> +                     }
>
> These two error cases should set rc non-zero, it may not be the last
> copy-chunk for this clone.
> ...
>
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -1214,7 +1214,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>>       rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
>>       rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
>>
>> -     if (rc != 0) {
>> +     if ((rc != 0) && (rc != -EINVAL)) {
>
> This should probably be FSCTL_SRV_COPYCHUNK[_WRITE] specific. See MS-SMB2
>   3.3.4.4   Sending an Error Response
>   When the server is responding with a failure to any command sent by the
>   client, the response message MUST be constructed as described here. An
>   error code other than one of the following indicates a failure:
>   ...
>
>   STATUS_INVALID_PARAMETER in an FSCTL_SRV_COPYCHUNK or
>   FSCTL_SRV_COPYCHUNK_WRITE response, when returning an
>   SRV_COPYCHUNK_RESPONSE as described in section 3.3.5.15.6.2.
>
>
>>               if (tcon)
>>                       cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
>>               goto ioctl_exit;
>
> Cheers, David



-- 
Thanks,

Steve
