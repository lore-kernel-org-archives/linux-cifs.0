From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mounts to Windows XP server do have problems with async write due
 to inFlight > 10
Date: Sat, 25 Jun 2011 14:21:16 -0500
Message-ID: <BANLkTinkMJ0Oi_ASMC7f_DsKv_Bo1u5etw@mail.gmail.com>
References: <BANLkTikwtWrQxUD=B4eQedXq9JPy+Ojf0w@mail.gmail.com>
	<BANLkTimp+GQiM8HoXNginYy7kYPhVZiXDQ@mail.gmail.com>
	<20110625062733.75df0f26@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110625062733.75df0f26-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Potential problem writing large files (with the async write support
which kicks off
more smbs in parallel)  to systems which set an artificially low limit =
on maxmpx
(not to the usual 50, but to e.g. 10 as some WindowsXP does) and enforc=
e
the limit strictly by killing the session or throwing away the request.

The patch below did seem to help, but when setting wsize to 8K or 4K
I still did run into a problem, although
seemed to be better - so need to debug whether it is an "off by one"
problem where server (as Chris Hertel suggested) might be setting the
limit on number of writes in parallel to one less than the mpxcount
rather than mpxcount (when oplock enabled on the server) or perhaps whe=
ther
we just have too many async write requests blocked and hit some sort
of memory issue or corruption.

On Sat, Jun 25, 2011 at 5:27 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 24 Jun 2011 20:45:08 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> This seems to be close to what we would want but am not done testing=
/debugging:
>>
>
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 1a9fe7f..1957f5d 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -453,6 +453,11 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_=
ses *ses)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->sec_mode =3D (__u8)le16_to_cpu(r=
sp->SecurityMode);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->maxReq =3D le16_to_cpu(rsp->MaxM=
pxCount);
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* maxReq must be at least 2, almost all s=
ervers set to 50,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0some old non-MS servers set incorre=
ctly so set to default
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(otherwise oplock break e.g. would =
fail */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (server->maxReq < 2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->maxReq =3D CIFS_MA=
X_REQ; /* 50 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^
> Would it be better to set this to the minimum (2 or 3), and possibly
> warn on the first mount?

since the "normal" number used by almost all Windows (and even OS/2)
is 50, and was the value we have been using for many years, by default,
I thought that defaulting to the "normal" limit on an illegal value (wh=
ich
means we don't change behavior) is safer.

>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->maxBuf =3D min((__u32)le16_to_cp=
u(rsp->MaxBufSize),
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (__u32)C=
IFSMaxBufSize + MAX_CIFS_HDR_SIZE);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->max_vcs =3D le16_to_cpu(rsp->Max=
NumberVcs);
>> @@ -560,6 +565,11 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_=
ses *ses)
>> =A0 =A0 =A0 /* one byte, so no need to convert this or EncryptionKey=
Len from
>> =A0 =A0 =A0 =A0 =A0little endian */
>> =A0 =A0 =A0 server->maxReq =3D le16_to_cpu(pSMBr->MaxMpxCount);
>> + =A0 =A0 /* maxReq must be at least 2, almost all servers set to 50=
,
>> + =A0 =A0 =A0 =A0some old non-MS servers set incorrectly so set to d=
efault
>> + =A0 =A0 =A0 =A0(otherwise oplock break e.g. would fail */
>> + =A0 =A0 if (server->maxReq < 2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->maxReq =3D CIFS_MAX_REQ; /* 50 */
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ditto.
>
>> =A0 =A0 =A0 /* probably no need to store and check maxvcs */
>> =A0 =A0 =A0 server->maxBuf =3D min(le32_to_cpu(pSMBr->MaxBufferSize)=
,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (__u32) CIFSMaxBufSize +=
 MAX_CIFS_HDR_SIZE);
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index c761935..3f8cf63 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -95,7 +95,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> =A0 =A0 =A0 server->maxBuf =3D 0;
>>
>> - =A0 =A0 cFYI(1, "Reconnecting tcp session");
>> + =A0 =A0 cERROR(1, "Reconnecting tcp session in flight %d",
>
> =A0 =A0 =A0 =A0^^^^^^^^^^^
> I don't think this ought to be a cERROR.

Right - that was just a debug statement I threw in there to
try to figure out what Windows XP was doing to our sessions
(that line will stay a cFYI)

>> atomic_read(&server->inFlight)); =A0/* BB FIXME */
>>
>> =A0 =A0 =A0 /* before reconnecting the tcp session, mark the smb ses=
sion (uid)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 and the tid bad so they are not used unt=
il reconnected */
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 147aa22..11c6585 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -264,7 +264,12 @@ static int wait_for_free_request(struct
>> TCP_Server_Info *server,
>>
>> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> =A0 =A0 =A0 while (1) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&server->inFlight) >=3D ci=
fs_max_pending) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* We must check that don't exceed maxReq =
but on SMB Negotiate
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0it is not initted yet (maxReq must =
be at least two) */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((atomic_read(&server->inFlight) >=3D c=
ifs_max_pending) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((atomic_read(&server->inFlight) >=
=3D server->maxReq) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (server->maxReq > 1))) {
>
> Why continue to have a cifs_max_pending limit if you're going to
> respect maxReq? This should be a per-socket limit only, IMO...

Your point makes sense - and the memory usage of these structures
isn't that great - but it does give us additional control (to shrink
maxmpx if the server exhibits performance problems or perhaps even
if the client exhibits memory limits when many, many mounts each
with lots of pending requests).   My main reason for not wanting
to touch the cifs_max_pending (and thus not yet removing
the module_param) is to keep the patch smaller, and not change
external interfaces this close to release.

>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0#ifdef CONFIG_CIFS_STATS2
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&server->num_=
waiters);
>>
>> On Fri, Jun 24, 2011 at 7:22 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>> > Should be fairly easy to fix to honor a "reasonable" mpx value (ie
>> > over 3 but under 50) - to avoid the problems to WindowsXP caused b=
y
>> > async write kicking off more than 10 writes in parallel and exceed=
ing
>> > maxMpx (the server kills the session


--=20
Thanks,

Steve
