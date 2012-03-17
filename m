From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 01/11] CIFS: Respect negotiated MaxMpxCount
Date: Sat, 17 Mar 2012 18:53:53 +0400
Message-ID: <CAKywueTDsGhcHiGM_uX6V0dnY3m_W4kD2qcb+JWRq=UVnBnvPw@mail.gmail.com>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-2-git-send-email-piastry@etersoft.ru>
	<20120317071201.7f28683b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120317071201.7f28683b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

17 =CD=C1=D2=D4=C1 2012=9A=C7. 15:12 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> On Fri, 16 Mar 2012 18:09:24 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Some servers sets this value less than 50 that was hardcoded and
>> we lost the connection if when we exceed this limit. Fix this by
>> respecting this value - not sending more than the server allows.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =9Afs/cifs/cifsfs.c =9A =9A| =9A =9A8 ++++----
>> =9Afs/cifs/cifsglob.h =9A| =9A 10 +++-------
>> =9Afs/cifs/cifssmb.c =9A | =9A =9A9 +++++++--
>> =9Afs/cifs/connect.c =9A | =9A 11 ++++-------
>> =9Afs/cifs/dir.c =9A =9A =9A | =9A =9A6 ++++--
>> =9Afs/cifs/file.c =9A =9A =9A| =9A =9A4 ++--
>> =9Afs/cifs/transport.c | =9A =9A4 ++--
>> =9A7 files changed, 26 insertions(+), 26 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index b1fd382..6ee1cb4 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -76,7 +76,7 @@ MODULE_PARM_DESC(cifs_min_small, "Small network bu=
ffers in pool. Default: 30 "
>> =9Aunsigned int cifs_max_pending =3D CIFS_MAX_REQ;
>> =9Amodule_param(cifs_max_pending, int, 0444);
>> =9AMODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to serv=
er. "
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A"De=
fault: 50 Range: 2 to 256");
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A"De=
fault: 32767 Range: 2 to 32767.");
>> =9Aunsigned short echo_retries =3D 5;
>> =9Amodule_param(echo_retries, ushort, 0644);
>> =9AMODULE_PARM_DESC(echo_retries, "Number of echo attempts before gi=
ving up and "
>> @@ -1116,9 +1116,9 @@ init_cifs(void)
>> =9A =9A =9A if (cifs_max_pending < 2) {
>> =9A =9A =9A =9A =9A =9A =9A cifs_max_pending =3D 2;
>> =9A =9A =9A =9A =9A =9A =9A cFYI(1, "cifs_max_pending set to min of =
2");
>> - =9A =9A } else if (cifs_max_pending > 256) {
>> - =9A =9A =9A =9A =9A =9A cifs_max_pending =3D 256;
>> - =9A =9A =9A =9A =9A =9A cFYI(1, "cifs_max_pending set to max of 25=
6");
>> + =9A =9A } else if (cifs_max_pending > CIFS_MAX_REQ) {
>> + =9A =9A =9A =9A =9A =9A cifs_max_pending =3D CIFS_MAX_REQ;
>> + =9A =9A =9A =9A =9A =9A cFYI(1, "cifs_max_pending set to max of %u=
", CIFS_MAX_REQ);
>> =9A =9A =9A }
>>
>> =9A =9A =9A rc =3D cifs_fscache_register();
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 76e7d8b..d47d20a 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -55,14 +55,9 @@
>>
>> =9A/*
>> =9A * MAX_REQ is the maximum number of requests that WE will send
>> - * on one socket concurrently. It also matches the most common
>> - * value of max multiplex returned by servers. =9AWe may
>> - * eventually want to use the negotiated value (in case
>> - * future servers can handle more) when we are more confident that
>> - * we will not have problems oveloading the socket with pending
>> - * write data.
>> + * on one socket concurrently.
>> =9A */
>> -#define CIFS_MAX_REQ 50
>> +#define CIFS_MAX_REQ 32767
>>
>> =9A#define RFC1001_NAME_LEN 15
>> =9A#define RFC1001_NAME_LEN_WITH_NULL (RFC1001_NAME_LEN + 1)
>> @@ -263,6 +258,7 @@ struct TCP_Server_Info {
>> =9A =9A =9A bool session_estab; /* mark when very first sess is esta=
blished */
>> =9A =9A =9A u16 dialect; /* dialect index that server chose */
>> =9A =9A =9A enum securityEnum secType;
>> + =9A =9A bool oplocks:1; /* enable oplocks */
>> =9A =9A =9A unsigned int maxReq; =9A =9A/* Clients should submit no =
more */
>> =9A =9A =9A /* than maxReq distinct unanswered SMBs to the server wh=
en using =9A*/
>> =9A =9A =9A /* multiplexed reads or writes */
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 8b7794c..cd66b76 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -458,7 +458,10 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_=
ses *ses)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A goto neg_err_exit;
>> =9A =9A =9A =9A =9A =9A =9A }
>> =9A =9A =9A =9A =9A =9A =9A server->sec_mode =3D (__u8)le16_to_cpu(r=
sp->SecurityMode);
>> - =9A =9A =9A =9A =9A =9A server->maxReq =3D le16_to_cpu(rsp->MaxMpx=
Count);
>> + =9A =9A =9A =9A =9A =9A server->maxReq =3D min_t(unsigned int,
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9Ale16_to_cpu(rsp->MaxMpxCount),
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9Acifs_max_pending);
>> + =9A =9A =9A =9A =9A =9A server->oplocks =3D server->maxReq > 1 ? e=
nable_oplocks : false;
>> =9A =9A =9A =9A =9A =9A =9A server->maxBuf =3D le16_to_cpu(rsp->MaxB=
ufSize);
>> =9A =9A =9A =9A =9A =9A =9A server->max_vcs =3D le16_to_cpu(rsp->Max=
NumberVcs);
>> =9A =9A =9A =9A =9A =9A =9A /* even though we do not use raw we migh=
t as well set this
>> @@ -564,7 +567,9 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_s=
es *ses)
>>
>> =9A =9A =9A /* one byte, so no need to convert this or EncryptionKey=
Len from
>> =9A =9A =9A =9A =9Alittle endian */
>> - =9A =9A server->maxReq =3D le16_to_cpu(pSMBr->MaxMpxCount);
>> + =9A =9A server->maxReq =3D min_t(unsigned int, le16_to_cpu(pSMBr->=
MaxMpxCount),
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9Acifs_max_pe=
nding);
>> + =9A =9A server->oplocks =3D server->maxReq > 1 ? enable_oplocks : =
false;
>> =9A =9A =9A /* probably no need to store and check maxvcs */
>> =9A =9A =9A server->maxBuf =3D le32_to_cpu(pSMBr->MaxBufferSize);
>> =9A =9A =9A server->max_rw =3D le32_to_cpu(pSMBr->MaxRawSize);
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 602f77c..03f71fb 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -642,14 +642,10 @@ static void clean_demultiplex_info(struct TCP_=
Server_Info *server)
>> =9A =9A =9A spin_unlock(&GlobalMid_Lock);
>> =9A =9A =9A wake_up_all(&server->response_q);
>>
>> - =9A =9A /*
>> - =9A =9A =9A* Check if we have blocked requests that need to free. =
Note that
>> - =9A =9A =9A* cifs_max_pending is normally 50, but can be set at mo=
dule install
>> - =9A =9A =9A* time to as little as two.
>> - =9A =9A =9A*/
>> + =9A =9A /* Check if we have blocked requests that need to free. */
>> =9A =9A =9A spin_lock(&GlobalMid_Lock);
>> - =9A =9A if (atomic_read(&server->inFlight) >=3D cifs_max_pending)
>> - =9A =9A =9A =9A =9A =9A atomic_set(&server->inFlight, cifs_max_pen=
ding - 1);
>> + =9A =9A if (atomic_read(&server->inFlight) >=3D server->maxReq)
>> + =9A =9A =9A =9A =9A =9A atomic_set(&server->inFlight, server->maxR=
eq - 1);
>> =9A =9A =9A /*
>> =9A =9A =9A =9A* We do not want to set the max_pending too low or we=
 could end up
>> =9A =9A =9A =9A* with the counter going negative.
>> @@ -1910,6 +1906,7 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
fo)
>> =9A =9A =9A tcp_ses->noautotune =3D volume_info->noautotune;
>> =9A =9A =9A tcp_ses->tcp_nodelay =3D volume_info->sockopt_tcp_nodela=
y;
>> =9A =9A =9A atomic_set(&tcp_ses->inFlight, 0);
>> + =9A =9A tcp_ses->maxReq =3D 1; /* enough to send negotiate request=
 */
>> =9A =9A =9A init_waitqueue_head(&tcp_ses->response_q);
>> =9A =9A =9A init_waitqueue_head(&tcp_ses->request_q);
>> =9A =9A =9A INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
>> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
>> index bc7e244..d172c8e 100644
>> --- a/fs/cifs/dir.c
>> +++ b/fs/cifs/dir.c
>> @@ -171,7 +171,7 @@ cifs_create(struct inode *inode, struct dentry *=
direntry, umode_t mode,
>> =9A =9A =9A }
>> =9A =9A =9A tcon =3D tlink_tcon(tlink);
>>
>> - =9A =9A if (enable_oplocks)
>> + =9A =9A if (tcon->ses->server->oplocks)
>> =9A =9A =9A =9A =9A =9A =9A oplock =3D REQ_OPLOCK;
>>
>> =9A =9A =9A if (nd)
>> @@ -492,7 +492,7 @@ cifs_lookup(struct inode *parent_dir_inode, stru=
ct dentry *direntry,
>> =9A{
>> =9A =9A =9A int xid;
>> =9A =9A =9A int rc =3D 0; /* to get around spurious gcc warning, set=
 to zero here */
>> - =9A =9A __u32 oplock =3D enable_oplocks ? REQ_OPLOCK : 0;
>> + =9A =9A __u32 oplock;
>> =9A =9A =9A __u16 fileHandle =3D 0;
>> =9A =9A =9A bool posix_open =3D false;
>> =9A =9A =9A struct cifs_sb_info *cifs_sb;
>> @@ -518,6 +518,8 @@ cifs_lookup(struct inode *parent_dir_inode, stru=
ct dentry *direntry,
>> =9A =9A =9A }
>> =9A =9A =9A pTcon =3D tlink_tcon(tlink);
>>
>> + =9A =9A oplock =3D pTcon->ses->server->oplocks ? REQ_OPLOCK : 0;
>> +
>> =9A =9A =9A /*
>> =9A =9A =9A =9A* Don't allow the separator character in a path compo=
nent.
>> =9A =9A =9A =9A* The VFS will not allow "/", but "\" is allowed by p=
osix.
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 5e64748..4aa6080 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -380,7 +380,7 @@ int cifs_open(struct inode *inode, struct file *=
file)
>> =9A =9A =9A cFYI(1, "inode =3D 0x%p file flags are 0x%x for %s",
>> =9A =9A =9A =9A =9A =9A =9A =9Ainode, file->f_flags, full_path);
>>
>> - =9A =9A if (enable_oplocks)
>> + =9A =9A if (tcon->ses->server->oplocks)
>> =9A =9A =9A =9A =9A =9A =9A oplock =3D REQ_OPLOCK;
>> =9A =9A =9A else
>> =9A =9A =9A =9A =9A =9A =9A oplock =3D 0;
>> @@ -505,7 +505,7 @@ static int cifs_reopen_file(struct cifsFileInfo =
*pCifsFile, bool can_flush)
>> =9A =9A =9A cFYI(1, "inode =3D 0x%p file flags 0x%x for %s",
>> =9A =9A =9A =9A =9A =9A =9A =9Ainode, pCifsFile->f_flags, full_path)=
;
>>
>> - =9A =9A if (enable_oplocks)
>> + =9A =9A if (tcon->ses->server->oplocks)
>> =9A =9A =9A =9A =9A =9A =9A oplock =3D REQ_OPLOCK;
>> =9A =9A =9A else
>> =9A =9A =9A =9A =9A =9A =9A oplock =3D 0;
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 0cc9584..99a27cf 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -265,12 +265,12 @@ static int wait_for_free_request(struct TCP_Se=
rver_Info *server,
>>
>> =9A =9A =9A spin_lock(&GlobalMid_Lock);
>> =9A =9A =9A while (1) {
>> - =9A =9A =9A =9A =9A =9A if (atomic_read(&server->inFlight) >=3D ci=
fs_max_pending) {
>> + =9A =9A =9A =9A =9A =9A if (atomic_read(&server->inFlight) >=3D se=
rver->maxReq) {
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A spin_unlock(&GlobalMid_L=
ock);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_num_waiters_inc(ser=
ver);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A wait_event(server->reque=
st_q,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9Aa=
tomic_read(&server->inFlight)
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
< cifs_max_pending);
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
< server->maxReq);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_num_waiters_dec(ser=
ver);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A spin_lock(&GlobalMid_Loc=
k);
>> =9A =9A =9A =9A =9A =9A =9A } else {
>
> Sorry, I probably should have made my earlier comment against this
> email. If there are regressions from this series, they are likely goi=
ng
> to be quite difficult to track down. We need to ensure that we do thi=
s
> in a way that makes that possible.
>
> Introducing a behavior change like this at the beginning of the serie=
s
> is probably a mistake. You'll have no reasonable way to bisect down
> regressions, so you won't know if a problem is due to the change to a
> credit-based model or due to changing the client to respect the maxmp=
x.
>
> Instead of doing this, we should instead reorganize the code around a
> credit based model first, while attempting to mimic the existing
> behavior as closely as possible. Once that framework is in place, the=
n
> change the behavior and start respecting the maxmpx.
>
> If you do that, then someone can reasonably bisect between those two
> changes and we can determine the source of a regression.
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This was done to push this patch to 3.3 and stable tree as well.
That's why it is in the start of series.

If we decide not to push it for now, I agree that this patch should be
in the modified version (according to changes from other patches) at
the end of the series.

Steve, your thoughts?

--=20
Best regards,
Pavel Shilovsky.
