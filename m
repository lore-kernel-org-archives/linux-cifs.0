From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 02/53] CIFS: Allow SMB2 statistics to be tracked
Date: Sat, 29 Oct 2011 23:44:53 +0400
Message-ID: <CAKywueQwBwR-HZtv6gQv32kt4+2qycS7vq5KDLiE3xw3_9=wPA@mail.gmail.com>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-3-git-send-email-piastry@etersoft.ru>
	<20111029004814.41340503@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111029004814.41340503-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/29 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
=2E..
>> + =A0 =A0 union {
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_writes;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_reads;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_flushes;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_oplock_brks;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_opens;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_closes;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_deletes;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_mkdirs;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_posixopens;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_posixmkdirs;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_rmdirs;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_renames;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_t2renames;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_ffirst;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_fnext;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_fclose;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_hardlinks;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_symlinks;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_locks;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_acl_get;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t num_acl_set;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } cifs_stats;
>> +#ifdef CONFIG_CIFS_SMB2
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t smb2_com_sent[NUM=
BER_OF_SMB2_COMMANDS];
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_t smb2_com_fail[NUM=
BER_OF_SMB2_COMMANDS];
>> + =A0 =A0 =A0 =A0 =A0 =A0 } smb2_stats;
>
> Is it really necessary to do this with atomics? Those can have
> significant performance impact (TLB flushes, and we don't seem to nee=
d the
> guarantees that they provide for simple counters like this. Perhaps
> these should be switched to per-cpu variables or just plain ints?

I am not sure I understand your idea to make it as int. What's about
concurrency?

>
>> +#endif /* CONFIG CIFS_SMB2 */
>> + =A0 =A0 } stats;
>> =A0#ifdef CONFIG_CIFS_STATS2
>> =A0 =A0 =A0 unsigned long long time_writes;
>> =A0 =A0 =A0 unsigned long long time_reads;
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index ea7b813..4e11051 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -867,7 +867,7 @@ PsxDelete:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Posix delete returned %d", rc);
>> =A0 =A0 =A0 cifs_buf_release(pSMB);
>>
>> - =A0 =A0 cifs_stats_inc(&tcon->num_deletes);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_deletes);
>>
>> =A0 =A0 =A0 if (rc =3D=3D -EAGAIN)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto PsxDelete;
>> @@ -909,7 +909,7 @@ DelFileRetry:
>> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(name_len + 1);
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_deletes);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_deletes);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error in RMFile =3D %d", rc);
>>
>> @@ -953,7 +953,7 @@ RmDirRetry:
>> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(name_len + 1);
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_rmdirs);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_rmdirs);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error in RMDir =3D %d", rc);
>>
>> @@ -996,7 +996,7 @@ MkDirRetry:
>> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(name_len + 1);
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_mkdirs);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_mkdirs);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error in Mkdir =3D %d", rc);
>>
>> @@ -1118,9 +1118,9 @@ psx_create_err:
>> =A0 =A0 =A0 cifs_buf_release(pSMB);
>>
>> =A0 =A0 =A0 if (posix_flags & SMB_O_DIRECTORY)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->num_posixmkdirs);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num=
_posixmkdirs);
>> =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->num_posixopens);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num=
_posixopens);
>>
>> =A0 =A0 =A0 if (rc =3D=3D -EAGAIN)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto PsxCreat;
>> @@ -1241,7 +1241,7 @@ OldOpenRetry:
>> =A0 =A0 =A0 /* long_op set to 1 to allow for oplock break timeouts *=
/
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *)pSMBr,=
 &bytes_returned, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_opens);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_opens);
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error in Open =3D %d", rc);
>> =A0 =A0 =A0 } else {
>> @@ -1354,7 +1354,7 @@ openRetry:
>> =A0 =A0 =A0 /* long_op set to 1 to allow for oplock break timeouts *=
/
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *)pSMBr,=
 &bytes_returned, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_opens);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_opens);
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error in Open =3D %d", rc);
>> =A0 =A0 =A0 } else {
>> @@ -1728,7 +1728,7 @@ cifs_async_readv(struct cifs_readdata *rdata)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata, false)=
;
>>
>> =A0 =A0 =A0 if (rc =3D=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->num_reads);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num=
_reads);
>>
>> =A0 =A0 =A0 cifs_small_buf_release(smb);
>> =A0 =A0 =A0 return rc;
>> @@ -1796,7 +1796,7 @@ CIFSSMBRead(const int xid, struct cifs_io_parm=
s *io_parms, unsigned int *nbytes,
>> =A0 =A0 =A0 iov[0].iov_len =3D be32_to_cpu(pSMB->hdr.smb_buf_length)=
 + 4;
>> =A0 =A0 =A0 rc =3D SendReceive2(xid, tcon->ses, iov, 1 /* num iovecs=
 */,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&resp_buf_type, CIFS_=
LOG_ERROR);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_reads);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
>> =A0 =A0 =A0 pSMBr =3D (READ_RSP *)iov[0].iov_base;
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Send error in read =3D %d", r=
c);
>> @@ -1948,7 +1948,7 @@ CIFSSMBWrite(const int xid, struct cifs_io_par=
ms *io_parms,
>>
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, long_op);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_writes);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in write =3D %d", rc=
);
>> =A0 =A0 =A0 } else {
>> @@ -2197,7 +2197,7 @@ cifs_async_writev(struct cifs_writedata *wdata=
)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL, cifs_wr=
itev_callback, wdata, false);
>>
>> =A0 =A0 =A0 if (rc =3D=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->num_writes);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num=
_writes);
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kref_put(&wdata->refcount, cifs_writedat=
a_release);
>>
>> @@ -2287,7 +2287,7 @@ CIFSSMBWrite2(const int xid, struct cifs_io_pa=
rms *io_parms,
>>
>> =A0 =A0 =A0 rc =3D SendReceive2(xid, tcon->ses, iov, n_vec + 1, &res=
p_buf_type,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 long_op);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_writes);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error Write2 =3D %d", rc);
>> =A0 =A0 =A0 } else if (resp_buf_type =3D=3D 0) {
>> @@ -2353,7 +2353,7 @@ int cifs_lockv(const int xid, struct cifs_tcon=
 *tcon, const __u16 netfid,
>> =A0 =A0 =A0 iov[1].iov_base =3D (char *)buf;
>> =A0 =A0 =A0 iov[1].iov_len =3D (num_unlock + num_lock) * sizeof(LOCK=
ING_ANDX_RANGE);
>>
>> - =A0 =A0 cifs_stats_inc(&tcon->num_locks);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
>> =A0 =A0 =A0 rc =3D SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_ty=
pe, CIFS_NO_RESP);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in cifs_lockv =3D %d=
", rc);
>> @@ -2422,7 +2422,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *t=
con,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 timeout);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* SMB buffer freed by function above */
>> =A0 =A0 =A0 }
>> - =A0 =A0 cifs_stats_inc(&tcon->num_locks);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in Lock =3D %d", rc)=
;
>>
>> @@ -2587,7 +2587,7 @@ CIFSSMBClose(const int xid, struct cifs_tcon *=
tcon, int smb_file_id)
>> =A0 =A0 =A0 pSMB->LastWriteTime =3D 0xFFFFFFFF;
>> =A0 =A0 =A0 pSMB->ByteCount =3D 0;
>> =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_closes);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_closes);
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D -EINTR) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* EINTR is expected whe=
n user ctl-c to kill app */
>> @@ -2616,7 +2616,7 @@ CIFSSMBFlush(const int xid, struct cifs_tcon *=
tcon, int smb_file_id)
>> =A0 =A0 =A0 pSMB->FileID =3D (__u16) smb_file_id;
>> =A0 =A0 =A0 pSMB->ByteCount =3D 0;
>> =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_flushes);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_flushes);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Send error in Flush =3D %d", =
rc);
>>
>> @@ -2679,7 +2679,7 @@ renameRetry:
>>
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_renames);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_renames);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in rename =3D %d", r=
c);
>>
>> @@ -2758,7 +2758,7 @@ int CIFSSMBRenameOpenFile(const int xid, struc=
t cifs_tcon *pTcon,
>> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
>> =A0 =A0 =A0 rc =3D SendReceive(xid, pTcon->ses, (struct smb_hdr *) p=
SMB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
>> - =A0 =A0 cifs_stats_inc(&pTcon->num_t2renames);
>> + =A0 =A0 cifs_stats_inc(&pTcon->stats.cifs_stats.num_t2renames);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in Rename (by file h=
andle) =3D %d", rc);
>>
>> @@ -2915,7 +2915,7 @@ createSymLinkRetry:
>> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_symlinks);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_symlinks);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in SetPathInfo creat=
e symlink =3D %d", rc);
>>
>> @@ -3001,7 +3001,7 @@ createHardLinkRetry:
>> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_hardlinks);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_hardlinks);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in SetPathInfo (hard=
 link) =3D %d", rc);
>>
>> @@ -3073,7 +3073,7 @@ winCreateHardLinkRetry:
>>
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_hardlinks);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_hardlinks);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in hard link (NT ren=
ame) =3D %d", rc);
>>
>> @@ -3490,7 +3490,7 @@ queryAclRetry:
>>
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_acl_get);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_acl_get);
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in Query POSIX ACL =3D=
 %d", rc);
>> =A0 =A0 =A0 } else {
>> @@ -3801,7 +3801,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifs_t=
con *tcon, __u16 fid,
>>
>> =A0 =A0 =A0 rc =3D SendReceive2(xid, tcon->ses, iov, 1 /* num iovec =
*/, &buf_type,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_acl_get);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_acl_get);
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QuerySecDesc =3D =
%d", rc);
>> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode respon=
se */
>> @@ -4405,7 +4405,7 @@ findFirstRetry:
>>
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_ffirst);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_ffirst);
>>
>> =A0 =A0 =A0 if (rc) {/* BB add logic to retry regular search if Unix=
 search
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rejected unexpectedly by=
 server */
>> @@ -4532,7 +4532,7 @@ int CIFSFindNext(const int xid, struct cifs_tc=
on *tcon,
>>
>> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pS=
MB,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr=
, &bytes_returned, 0);
>> - =A0 =A0 cifs_stats_inc(&tcon->num_fnext);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_fnext);
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D -EBADF) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psrch_inf->endOfSearch =3D=
 true;
>> @@ -4623,7 +4623,7 @@ CIFSFindClose(const int xid, struct cifs_tcon =
*tcon,
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Send error in FindClose =3D %=
d", rc);
>>
>> - =A0 =A0 cifs_stats_inc(&tcon->num_fclose);
>> + =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_stats.num_fclose);
>>
>> =A0 =A0 =A0 /* Since session is dead, search handle closed on server=
 already */
>> =A0 =A0 =A0 if (rc =3D=3D -EAGAIN)
>> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
>> index 703ef5c..1934575 100644
>> --- a/fs/cifs/misc.c
>> +++ b/fs/cifs/misc.c
>> @@ -571,7 +571,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struc=
t TCP_Server_Info *srv)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tcon->tid !=3D buf->=
Tid)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue=
;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->num_=
oplock_brks);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->stat=
s.cifs_stats.num_oplock_brks);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_file_lis=
t_lock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each(tmp2, &tco=
n->openFileList) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 netfile =
=3D list_entry(tmp2, struct cifsFileInfo,
>
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
Pavel Shilovsky.
