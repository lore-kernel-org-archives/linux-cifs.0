From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Respect negotiated MaxMpxCount
Date: Tue, 20 Mar 2012 09:52:08 -0500
Message-ID: <CAH2r5msK5W0Gp7QGe2U9U89_eXKrxaJO-8aiftKUmDfNS14_Ag@mail.gmail.com>
References: <1332237309-9586-1-git-send-email-piastry@etersoft.ru>
	<20120320063517.2de289cd@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120320063517.2de289cd-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I like this better than my earlier patch.

I will try this in my test environment, but I don't have a Windows
Vista system or VM configured at the moment.  Anyone have a WIndows
Vista system to try this patch against?  In particular large
sequential file copy (cp of file 500MB or larger) to server with
maxmpx 10 and maxworkitems at default value in the WIndows Vista
registry.

On Tue, Mar 20, 2012 at 5:35 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 20 Mar 2012 12:55:09 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Some servers sets this value less than 50 that was hardcoded and
>> we lost the connection if when we exceed this limit. Fix this by
>> respecting this value - not sending more than the server allows.
>>
>> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 =A08 ++++----
>> =A0fs/cifs/cifsglob.h =A0| =A0 10 +++-------
>> =A0fs/cifs/cifssmb.c =A0 | =A0 =A09 +++++++--
>> =A0fs/cifs/connect.c =A0 | =A0 11 ++++-------
>> =A0fs/cifs/dir.c =A0 =A0 =A0 | =A0 =A06 ++++--
>> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 =A04 ++--
>> =A0fs/cifs/transport.c | =A0 =A04 ++--
>> =A07 files changed, 26 insertions(+), 26 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index b1fd382..6ee1cb4 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -76,7 +76,7 @@ MODULE_PARM_DESC(cifs_min_small, "Small network bu=
ffers in pool. Default: 30 "
>> =A0unsigned int cifs_max_pending =3D CIFS_MAX_REQ;
>> =A0module_param(cifs_max_pending, int, 0444);
>> =A0MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to serv=
er. "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"De=
fault: 50 Range: 2 to 256");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"De=
fault: 32767 Range: 2 to 32767.");
>> =A0unsigned short echo_retries =3D 5;
>> =A0module_param(echo_retries, ushort, 0644);
>> =A0MODULE_PARM_DESC(echo_retries, "Number of echo attempts before gi=
ving up and "
>> @@ -1116,9 +1116,9 @@ init_cifs(void)
>> =A0 =A0 =A0 if (cifs_max_pending < 2) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_max_pending =3D 2;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "cifs_max_pending set to min of =
2");
>> - =A0 =A0 } else if (cifs_max_pending > 256) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_max_pending =3D 256;
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "cifs_max_pending set to max of 25=
6");
>> + =A0 =A0 } else if (cifs_max_pending > CIFS_MAX_REQ) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_max_pending =3D CIFS_MAX_REQ;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "cifs_max_pending set to max of %u=
", CIFS_MAX_REQ);
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 rc =3D cifs_fscache_register();
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 76e7d8b..d47d20a 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -55,14 +55,9 @@
>>
>> =A0/*
>> =A0 * MAX_REQ is the maximum number of requests that WE will send
>> - * on one socket concurrently. It also matches the most common
>> - * value of max multiplex returned by servers. =A0We may
>> - * eventually want to use the negotiated value (in case
>> - * future servers can handle more) when we are more confident that
>> - * we will not have problems oveloading the socket with pending
>> - * write data.
>> + * on one socket concurrently.
>> =A0 */
>> -#define CIFS_MAX_REQ 50
>> +#define CIFS_MAX_REQ 32767
>>
>> =A0#define RFC1001_NAME_LEN 15
>> =A0#define RFC1001_NAME_LEN_WITH_NULL (RFC1001_NAME_LEN + 1)
>> @@ -263,6 +258,7 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 bool session_estab; /* mark when very first sess is esta=
blished */
>> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose */
>> =A0 =A0 =A0 enum securityEnum secType;
>> + =A0 =A0 bool oplocks:1; /* enable oplocks */
>> =A0 =A0 =A0 unsigned int maxReq; =A0 =A0/* Clients should submit no =
more */
>> =A0 =A0 =A0 /* than maxReq distinct unanswered SMBs to the server wh=
en using =A0*/
>> =A0 =A0 =A0 /* multiplexed reads or writes */
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 8b7794c..cd66b76 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -458,7 +458,10 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_=
ses *ses)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto neg_err_exit;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->sec_mode =3D (__u8)le16_to_cpu(r=
sp->SecurityMode);
>> - =A0 =A0 =A0 =A0 =A0 =A0 server->maxReq =3D le16_to_cpu(rsp->MaxMpx=
Count);
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->maxReq =3D min_t(unsigned int,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0le16_to_cpu(rsp->MaxMpxCount),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0cifs_max_pending);
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->oplocks =3D server->maxReq > 1 ? e=
nable_oplocks : false;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->maxBuf =3D le16_to_cpu(rsp->MaxB=
ufSize);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->max_vcs =3D le16_to_cpu(rsp->Max=
NumberVcs);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* even though we do not use raw we migh=
t as well set this
>> @@ -564,7 +567,9 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_s=
es *ses)
>>
>> =A0 =A0 =A0 /* one byte, so no need to convert this or EncryptionKey=
Len from
>> =A0 =A0 =A0 =A0 =A0little endian */
>> - =A0 =A0 server->maxReq =3D le16_to_cpu(pSMBr->MaxMpxCount);
>> + =A0 =A0 server->maxReq =3D min_t(unsigned int, le16_to_cpu(pSMBr->=
MaxMpxCount),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_max_pe=
nding);
>> + =A0 =A0 server->oplocks =3D server->maxReq > 1 ? enable_oplocks : =
false;
>> =A0 =A0 =A0 /* probably no need to store and check maxvcs */
>> =A0 =A0 =A0 server->maxBuf =3D le32_to_cpu(pSMBr->MaxBufferSize);
>> =A0 =A0 =A0 server->max_rw =3D le32_to_cpu(pSMBr->MaxRawSize);
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 602f77c..03f71fb 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -642,14 +642,10 @@ static void clean_demultiplex_info(struct TCP_=
Server_Info *server)
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> =A0 =A0 =A0 wake_up_all(&server->response_q);
>>
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* Check if we have blocked requests that need to free. =
Note that
>> - =A0 =A0 =A0* cifs_max_pending is normally 50, but can be set at mo=
dule install
>> - =A0 =A0 =A0* time to as little as two.
>> - =A0 =A0 =A0*/
>> + =A0 =A0 /* Check if we have blocked requests that need to free. */
>> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> - =A0 =A0 if (atomic_read(&server->inFlight) >=3D cifs_max_pending)
>> - =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&server->inFlight, cifs_max_pen=
ding - 1);
>> + =A0 =A0 if (atomic_read(&server->inFlight) >=3D server->maxReq)
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&server->inFlight, server->maxR=
eq - 1);
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* We do not want to set the max_pending too low or we=
 could end up
>> =A0 =A0 =A0 =A0* with the counter going negative.
>> @@ -1910,6 +1906,7 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
fo)
>> =A0 =A0 =A0 tcp_ses->noautotune =3D volume_info->noautotune;
>> =A0 =A0 =A0 tcp_ses->tcp_nodelay =3D volume_info->sockopt_tcp_nodela=
y;
>> =A0 =A0 =A0 atomic_set(&tcp_ses->inFlight, 0);
>> + =A0 =A0 tcp_ses->maxReq =3D 1; /* enough to send negotiate request=
 */
>> =A0 =A0 =A0 init_waitqueue_head(&tcp_ses->response_q);
>> =A0 =A0 =A0 init_waitqueue_head(&tcp_ses->request_q);
>> =A0 =A0 =A0 INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
>> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
>> index bc7e244..d172c8e 100644
>> --- a/fs/cifs/dir.c
>> +++ b/fs/cifs/dir.c
>> @@ -171,7 +171,7 @@ cifs_create(struct inode *inode, struct dentry *=
direntry, umode_t mode,
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 tcon =3D tlink_tcon(tlink);
>>
>> - =A0 =A0 if (enable_oplocks)
>> + =A0 =A0 if (tcon->ses->server->oplocks)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 oplock =3D REQ_OPLOCK;
>>
>> =A0 =A0 =A0 if (nd)
>> @@ -492,7 +492,7 @@ cifs_lookup(struct inode *parent_dir_inode, stru=
ct dentry *direntry,
>> =A0{
>> =A0 =A0 =A0 int xid;
>> =A0 =A0 =A0 int rc =3D 0; /* to get around spurious gcc warning, set=
 to zero here */
>> - =A0 =A0 __u32 oplock =3D enable_oplocks ? REQ_OPLOCK : 0;
>> + =A0 =A0 __u32 oplock;
>> =A0 =A0 =A0 __u16 fileHandle =3D 0;
>> =A0 =A0 =A0 bool posix_open =3D false;
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
>> @@ -518,6 +518,8 @@ cifs_lookup(struct inode *parent_dir_inode, stru=
ct dentry *direntry,
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 pTcon =3D tlink_tcon(tlink);
>>
>> + =A0 =A0 oplock =3D pTcon->ses->server->oplocks ? REQ_OPLOCK : 0;
>> +
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* Don't allow the separator character in a path compo=
nent.
>> =A0 =A0 =A0 =A0* The VFS will not allow "/", but "\" is allowed by p=
osix.
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 8e02dbd..159fcc5 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -380,7 +380,7 @@ int cifs_open(struct inode *inode, struct file *=
file)
>> =A0 =A0 =A0 cFYI(1, "inode =3D 0x%p file flags are 0x%x for %s",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode, file->f_flags, full_path);
>>
>> - =A0 =A0 if (enable_oplocks)
>> + =A0 =A0 if (tcon->ses->server->oplocks)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 oplock =3D REQ_OPLOCK;
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 oplock =3D 0;
>> @@ -505,7 +505,7 @@ static int cifs_reopen_file(struct cifsFileInfo =
*pCifsFile, bool can_flush)
>> =A0 =A0 =A0 cFYI(1, "inode =3D 0x%p file flags 0x%x for %s",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode, pCifsFile->f_flags, full_path)=
;
>>
>> - =A0 =A0 if (enable_oplocks)
>> + =A0 =A0 if (tcon->ses->server->oplocks)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 oplock =3D REQ_OPLOCK;
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 oplock =3D 0;
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 0cc9584..99a27cf 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -265,12 +265,12 @@ static int wait_for_free_request(struct TCP_Se=
rver_Info *server,
>>
>> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> =A0 =A0 =A0 while (1) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&server->inFlight) >=3D ci=
fs_max_pending) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&server->inFlight) >=3D se=
rver->maxReq) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_num_waiters_inc(ser=
ver);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_event(server->reque=
st_q,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0a=
tomic_read(&server->inFlight)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
< cifs_max_pending);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
< server->maxReq);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_num_waiters_dec(ser=
ver);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Loc=
k);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>
> Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
