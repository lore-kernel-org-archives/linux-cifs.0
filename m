From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 10/11] CIFS: Expand CurrentMid field
Date: Tue, 20 Mar 2012 11:37:27 +0400
Message-ID: <CAKywueTpa6Hmz7oQ=8S1ViRU9ky7wqhKN+f=eaWrJY1457X86w@mail.gmail.com>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-11-git-send-email-piastry@etersoft.ru>
	<20120319162410.42b95f13@redhat.com>
	<CAH2r5mujZook3O2Ojvu+vjx5Y5uYuormbtbDW69iOLEf1XVQgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mujZook3O2Ojvu+vjx5Y5uYuormbtbDW69iOLEf1XVQgg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

20 =CD=C1=D2=D4=C1 2012=9A=C7. 0:48 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> On Mon, Mar 19, 2012 at 3:24 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On Fri, 16 Mar 2012 18:09:33 +0300
>> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>
>>> While in CIFS/SMB we have 16 bit mid, in SMB2 it is 64 bit.
>>> Convert the existing field to 64 bit and mask off higher bits
>>> for CIFS/SMB.
>>>
>>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>>> ---
>>> =9Afs/cifs/cifsglob.h =9A| =9A =9A2 +-
>>> =9Afs/cifs/cifsproto.h | =9A =9A2 +-
>>> =9Afs/cifs/misc.c =9A =9A =9A| =9A 84 ++++++++++++++++++++++++++++-=
----------------------
>>> =9A3 files changed, 48 insertions(+), 40 deletions(-)
>>>
>>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>>> index a403398..b213458 100644
>>> --- a/fs/cifs/cifsglob.h
>>> +++ b/fs/cifs/cifsglob.h
>>> @@ -282,7 +282,7 @@ struct TCP_Server_Info {
>>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
vcnumbers */
>>> =9A =9A =9A int capabilities; /* allow selective disabling of caps =
by smb sess */
>>> =9A =9A =9A int timeAdj; =9A/* Adjust for difference in server time=
 zone in sec */
>>> - =9A =9A __u16 CurrentMid; =9A =9A =9A =9A /* multiplex id - rotat=
ing counter */
>>> + =9A =9A __u64 CurrentMid; =9A =9A =9A =9A /* multiplex id - rotat=
ing counter */
>>
>> It occurs to me that a simpler way to do this might be to turn this
>> into a union with a u16 and u64 field. This works just as well thoug=
h...
>>
>>> =9A =9A =9A char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, n=
tlmv2 etc */
>>> =9A =9A =9A /* 16th byte of RFC1001 workstation name is always null=
 */
>>> =9A =9A =9A char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NUL=
L];
>>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>>> index db38a40..8958721 100644
>>> --- a/fs/cifs/cifsproto.h
>>> +++ b/fs/cifs/cifsproto.h
>>> @@ -115,7 +115,7 @@ extern int small_smb_init_no_tc(const int smb_c=
md, const int wct,
>>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A void **=
request_buf);
>>> =9Aextern int CIFS_SessSetup(unsigned int xid, struct cifs_ses *ses=
,
>>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9Aconst struct=
 nls_table *nls_cp);
>>> -extern __u16 GetNextMid(struct TCP_Server_Info *server);
>>> +extern __u64 GetNextMid(struct TCP_Server_Info *server);
>>> =9Aextern struct timespec cifs_NTtimeToUnix(__le64 utc_nanoseconds_=
since_1601);
>>> =9Aextern u64 cifs_UnixTimeToNT(struct timespec);
>>> =9Aextern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_=
time,
>>> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
>>> index 88459d0..0b743b7 100644
>>> --- a/fs/cifs/misc.c
>>> +++ b/fs/cifs/misc.c
>>> @@ -213,54 +213,61 @@ cifs_small_buf_release(void *buf_to_free)
>>> =9A}
>>>
>>> =9A/*
>>> - =9A =9A Find a free multiplex id (SMB mid). Otherwise there could=
 be
>>> - =9A =9A mid collisions which might cause problems, demultiplexing=
 the
>>> - =9A =9A wrong response to this request. Multiplex ids could colli=
de if
>>> - =9A =9A one of a series requests takes much longer than the other=
s, or
>>> - =9A =9A if a very large number of long lived requests (byte range
>>> - =9A =9A locks or FindNotify requests) are pending. =9ANo more tha=
n
>>> - =9A =9A 64K-1 requests can be outstanding at one time. =9AIf no
>>> - =9A =9A mids are available, return zero. =9AA future optimization
>>> - =9A =9A could make the combination of mids and uid the key we use
>>> - =9A =9A to demultiplex on (rather than mid alone).
>>> - =9A =9A In addition to the above check, the cifs demultiplex
>>> - =9A =9A code already used the command code as a secondary
>>> - =9A =9A check of the frame and if signing is negotiated the
>>> - =9A =9A response would be discarded if the mid were the same
>>> - =9A =9A but the signature was wrong. =9ASince the mid is not put =
in the
>>> - =9A =9A pending queue until later (when it is about to be dispatc=
hed)
>>> - =9A =9A we do have to limit the number of outstanding requests
>>> - =9A =9A to somewhat less than 64K-1 although it is hard to imagin=
e
>>> - =9A =9A so many threads being in the vfs at one time.
>>> -*/
>>> -__u16 GetNextMid(struct TCP_Server_Info *server)
>>> + * Find a free multiplex id (SMB mid). Otherwise there could be
>>> + * mid collisions which might cause problems, demultiplexing the
>>> + * wrong response to this request. Multiplex ids could collide if
>>> + * one of a series requests takes much longer than the others, or
>>> + * if a very large number of long lived requests (byte range
>>> + * locks or FindNotify requests) are pending. No more than
>>> + * 64K-1 requests can be outstanding at one time. If no
>>> + * mids are available, return zero. A future optimization
>>> + * could make the combination of mids and uid the key we use
>>> + * to demultiplex on (rather than mid alone).
>>> + * In addition to the above check, the cifs demultiplex
>>> + * code already used the command code as a secondary
>>> + * check of the frame and if signing is negotiated the
>>> + * response would be discarded if the mid were the same
>>> + * but the signature was wrong. Since the mid is not put in the
>>> + * pending queue until later (when it is about to be dispatched)
>>> + * we do have to limit the number of outstanding requests
>>> + * to somewhat less than 64K-1 although it is hard to imagine
>>> + * so many threads being in the vfs at one time.
>>> + */
>>> +__u64 GetNextMid(struct TCP_Server_Info *server)
>>> =9A{
>>> - =9A =9A __u16 mid =3D 0;
>>> - =9A =9A __u16 last_mid;
>>> + =9A =9A __u64 mid =3D 0;
>>> + =9A =9A __u16 last_mid, cur_mid;
>>> =9A =9A =9A bool collision;
>>>
>>> =9A =9A =9A spin_lock(&GlobalMid_Lock);
>>> - =9A =9A last_mid =3D server->CurrentMid; /* we do not want to loo=
p forever */
>>> - =9A =9A server->CurrentMid++;
>>> - =9A =9A /* This nested loop looks more expensive than it is.
>>> - =9A =9A In practice the list of pending requests is short,
>>> - =9A =9A fewer than 50, and the mids are likely to be unique
>>> - =9A =9A on the first pass through the loop unless some request
>>> - =9A =9A takes longer than the 64 thousand requests before it
>>> - =9A =9A (and it would also have to have been a request that
>>> - =9A =9A =9Adid not time out) */
>>> - =9A =9A while (server->CurrentMid !=3D last_mid) {
>>> +
>>> + =9A =9A /* mid is 16 bit only for CIFS/SMB */
>>> + =9A =9A cur_mid =3D (__u16)((server->CurrentMid) & 0xffff);
>>> + =9A =9A /* we do not want to loop forever */
>>> + =9A =9A last_mid =3D cur_mid;
>>> + =9A =9A cur_mid++;
>>> +
>>> + =9A =9A /*
>>> + =9A =9A =9A* This nested loop looks more expensive than it is.
>>> + =9A =9A =9A* In practice the list of pending requests is short,
>>> + =9A =9A =9A* fewer than 50, and the mids are likely to be unique
>>> + =9A =9A =9A* on the first pass through the loop unless some reque=
st
>>> + =9A =9A =9A* takes longer than the 64 thousand requests before it
>>> + =9A =9A =9A* (and it would also have to have been a request that
>>> + =9A =9A =9A* did not time out).
>>> + =9A =9A =9A*/
>>> + =9A =9A while (cur_mid !=3D last_mid) {
>>> =9A =9A =9A =9A =9A =9A =9A struct mid_q_entry *mid_entry;
>>> =9A =9A =9A =9A =9A =9A =9A unsigned int num_mids;
>>>
>>> =9A =9A =9A =9A =9A =9A =9A collision =3D false;
>>> - =9A =9A =9A =9A =9A =9A if (server->CurrentMid =3D=3D 0)
>>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A server->CurrentMid++;
>>> + =9A =9A =9A =9A =9A =9A if (cur_mid =3D=3D 0)
>>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cur_mid++;
>>>
>>> =9A =9A =9A =9A =9A =9A =9A num_mids =3D 0;
>>> =9A =9A =9A =9A =9A =9A =9A list_for_each_entry(mid_entry, &server-=
>pending_mid_q, qhead) {
>>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A ++num_mids;
>>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (mid_entry->mid =3D=3D=
 server->CurrentMid &&
>>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (mid_entry->mid =3D=3D=
 cur_mid &&
>>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A mid_entry->midS=
tate =3D=3D MID_REQUEST_SUBMITTED) {
>>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A /* This=
 mid is in use, try a different one */
>>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A collisi=
on =3D true;
>>> @@ -282,10 +289,11 @@ __u16 GetNextMid(struct TCP_Server_Info *serv=
er)
>>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A server->tcpStatus =3D C=
ifsNeedReconnect;
>>>
>>> =9A =9A =9A =9A =9A =9A =9A if (!collision) {
>>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A mid =3D server->CurrentMi=
d;
>>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A mid =3D (__u64)cur_mid;
>>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A server->CurrentMid =3D mi=
d;
>>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A break;
>>> =9A =9A =9A =9A =9A =9A =9A }
>>> - =9A =9A =9A =9A =9A =9A server->CurrentMid++;
>>> + =9A =9A =9A =9A =9A =9A cur_mid++;
>>> =9A =9A =9A }
>>> =9A =9A =9A spin_unlock(&GlobalMid_Lock);
>>> =9A =9A =9A return mid;
>>
>> Not directly related to this patch, but should we move all of these =
mid
>> operations under the req_lock instead of the GlobalMid_Lock? The glo=
bal
>> spinlock is a bottleneck and all of the structures involved should b=
e
>> per-server anyway.
>>
>> Anyway, I think this looks ok
>>
>> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> The idea of a union for these two key fields is worth thinking about
> more - any more opinions from others on this?
>

I think our main goal is to make to code is cleaner as possible. If we
change this to a union we can't use the same codepath for both
protocols - more protocol specific code - harder to understand, fix
bugs, etc.


--=20
Best regards,
Pavel Shilovsky.
