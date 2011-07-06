From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: last patches for 3.0
Date: Wed, 6 Jul 2011 13:14:10 -0500
Message-ID: <CAH2r5msT7rTAzN8XJOwYYTAqkJmiJqu_XMEh+M0u=NprOFVA5w@mail.gmail.com>
References: <CAH2r5mshrJRCLc-UsY0CGT_Y5Hsfh1-mUmrqH9o9V3FbSBNqwA@mail.gmail.com>
	<20110706135012.18dda5b1@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110706135012.18dda5b1-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I agree that a mount option to override maxmpx would be useful
(and preferable to the existing module param - a default value overrida=
ble
at insmod time is harder than at mount time) - especially useful to Sam=
ba
server which IIRC can handle more than 50 simultaneous requests
but does not advertise this support in its negotiate response.


On Wed, Jul 6, 2011 at 12:50 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 6 Jul 2011 12:35:27 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> I have reviewed/merged two of Jeffs 4 recent patches (still reviewin=
g
>> the last two)
>>
>> On the problem with WindowsXP mounts limiting the number of
>> simultaneous requests and timing out when large numbers are sent in
>> parallel (especially when doing large numbers of small writes at one
>> time) - I am running ok with this patch and did discuss briefly with
>> Jeff. =A0I would rather not do a more invasive patch (if possible) -
>> this leaves the behavior as is except for servers which specify an m=
px
>> under 50 which is reasonable (ie at least 2) - otherwise it should
>> work identically, and it seems to fix the XP problem.
>>
>> commit a30b9327eb4543d45ffb79ebbcabe251eb6a3b9c
>> Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>> Date: =A0 Fri Jul 1 12:47:23 2011 -0500
>>
>> =A0 =A0 [CIFS] Limit simultaneous requests to older servers which se=
t maxmpx low
>>
>> =A0 =A0 WindowsXP (at least some service packs) sets the maximum num=
ber of
>> simultaneous
>> =A0 =A0 requests to 10 which is smaller than most servers (almost al=
l set
>> =A0 =A0 the limit at 50) and the cifs client set it to, and when
>> =A0 =A0 about 30 requests or so are in flight, requests to WindowsXP=
 servers can
>> =A0 =A0 time out, especially with the new cifs async write code
>> =A0 =A0 which frequently dispatches larger numbers of requests in pa=
rallel
>> =A0 =A0 than in previous versions of cifs.
>>
>> =A0 =A0 Limit the number of simultaneous requests to what the server
>> =A0 =A0 sets unless server reports an implausible number (must be a =
minimum of 2
>> =A0 =A0 to allow for a request and oplock break).
>>
>> =A0 =A0 Signed-off-by: Steve French <smfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>>
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
>> =A0 =A0 =A0 /* probably no need to store and check maxvcs */
>> =A0 =A0 =A0 server->maxBuf =3D min(le32_to_cpu(pSMBr->MaxBufferSize)=
,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (__u32) CIFSMaxBufSize +=
 MAX_CIFS_HDR_SIZE);
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 147aa22..e2bd2a9 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -264,7 +264,13 @@ static int wait_for_free_request(struct
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* Could also check if oplock enabled but =
how could turn off? */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((atomic_read(&server->inFlight) >=3D c=
ifs_max_pending) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((atomic_read(&server->inFlight) +=
 1 >=3D server->maxReq) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (server->maxReq > 1))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0#ifdef CONFIG_CIFS_STATS2
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&server->num_=
waiters);
>>
>
> I'm ok with this hack as an interim thing. Long term I think it would
> make more sense to fail the mount when the server sends us a bogus
> value here, and allow the admin to override that value via some other
> means -- maybe a mount option or something.
>
> FWIW, MS-CIFS says this:
>
> -----------------------[snip]------------------------
>
> MaxMpxCount (2 bytes): The maximum number of outstanding SMB operatio=
ns
> that the server supports. This value includes existing OpLocks, the
> NT_TRANSACT_NOTIFY_CHANGE subcommand, and any other commands that are
> pending on the server. If the negotiated MaxMpxCount is 0x0001, then
> OpLock support MUST be disabled for this session. The MaxMpxCount MUS=
T
> be greater than 0x0000. This parameter has no specific relationship t=
o
> the SMB_COM_READ_MPX and SMB_COM_WRITE_MPX commands.
>
> -----------------------[snip]------------------------
>
> I think we ought to try and follow the letter of the spec here, thoug=
h
> I'm unclear on what they mean by "existing Oplocks" -- do they mean
> we're supposed to hold one of these slots in reserve for every oplock
> we hold? That could be ugly. In any case, as far as 3.0 goes...
>
> Meh-I-guess-its-better-than-nothing-by: Jeff Layton <jlayton@redhat.c=
om>
>



--=20
Thanks,

Steve
