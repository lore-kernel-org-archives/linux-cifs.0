From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 10/11] CIFS: Expand CurrentMid field
Date: Mon, 19 Mar 2012 15:48:44 -0500
Message-ID: <CAH2r5mujZook3O2Ojvu+vjx5Y5uYuormbtbDW69iOLEf1XVQgg@mail.gmail.com>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-11-git-send-email-piastry@etersoft.ru>
	<20120319162410.42b95f13@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120319162410.42b95f13-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Mar 19, 2012 at 3:24 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 16 Mar 2012 18:09:33 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> While in CIFS/SMB we have 16 bit mid, in SMB2 it is 64 bit.
>> Convert the existing field to 64 bit and mask off higher bits
>> for CIFS/SMB.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h =A0| =A0 =A02 +-
>> =A0fs/cifs/cifsproto.h | =A0 =A02 +-
>> =A0fs/cifs/misc.c =A0 =A0 =A0| =A0 84 ++++++++++++++++++++++++++++--=
---------------------
>> =A03 files changed, 48 insertions(+), 40 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index a403398..b213458 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -282,7 +282,7 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0v=
cnumbers */
>> =A0 =A0 =A0 int capabilities; /* allow selective disabling of caps b=
y smb sess */
>> =A0 =A0 =A0 int timeAdj; =A0/* Adjust for difference in server time =
zone in sec */
>> - =A0 =A0 __u16 CurrentMid; =A0 =A0 =A0 =A0 /* multiplex id - rotati=
ng counter */
>> + =A0 =A0 __u64 CurrentMid; =A0 =A0 =A0 =A0 /* multiplex id - rotati=
ng counter */
>
> It occurs to me that a simpler way to do this might be to turn this
> into a union with a u16 and u64 field. This works just as well though=
=2E..
>
>> =A0 =A0 =A0 char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, nt=
lmv2 etc */
>> =A0 =A0 =A0 /* 16th byte of RFC1001 workstation name is always null =
*/
>> =A0 =A0 =A0 char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL=
];
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index db38a40..8958721 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -115,7 +115,7 @@ extern int small_smb_init_no_tc(const int smb_cm=
d, const int wct,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 void **r=
equest_buf);
>> =A0extern int CIFS_SessSetup(unsigned int xid, struct cifs_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct =
nls_table *nls_cp);
>> -extern __u16 GetNextMid(struct TCP_Server_Info *server);
>> +extern __u64 GetNextMid(struct TCP_Server_Info *server);
>> =A0extern struct timespec cifs_NTtimeToUnix(__le64 utc_nanoseconds_s=
ince_1601);
>> =A0extern u64 cifs_UnixTimeToNT(struct timespec);
>> =A0extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_t=
ime,
>> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
>> index 88459d0..0b743b7 100644
>> --- a/fs/cifs/misc.c
>> +++ b/fs/cifs/misc.c
>> @@ -213,54 +213,61 @@ cifs_small_buf_release(void *buf_to_free)
>> =A0}
>>
>> =A0/*
>> - =A0 =A0 Find a free multiplex id (SMB mid). Otherwise there could =
be
>> - =A0 =A0 mid collisions which might cause problems, demultiplexing =
the
>> - =A0 =A0 wrong response to this request. Multiplex ids could collid=
e if
>> - =A0 =A0 one of a series requests takes much longer than the others=
, or
>> - =A0 =A0 if a very large number of long lived requests (byte range
>> - =A0 =A0 locks or FindNotify requests) are pending. =A0No more than
>> - =A0 =A0 64K-1 requests can be outstanding at one time. =A0If no
>> - =A0 =A0 mids are available, return zero. =A0A future optimization
>> - =A0 =A0 could make the combination of mids and uid the key we use
>> - =A0 =A0 to demultiplex on (rather than mid alone).
>> - =A0 =A0 In addition to the above check, the cifs demultiplex
>> - =A0 =A0 code already used the command code as a secondary
>> - =A0 =A0 check of the frame and if signing is negotiated the
>> - =A0 =A0 response would be discarded if the mid were the same
>> - =A0 =A0 but the signature was wrong. =A0Since the mid is not put i=
n the
>> - =A0 =A0 pending queue until later (when it is about to be dispatch=
ed)
>> - =A0 =A0 we do have to limit the number of outstanding requests
>> - =A0 =A0 to somewhat less than 64K-1 although it is hard to imagine
>> - =A0 =A0 so many threads being in the vfs at one time.
>> -*/
>> -__u16 GetNextMid(struct TCP_Server_Info *server)
>> + * Find a free multiplex id (SMB mid). Otherwise there could be
>> + * mid collisions which might cause problems, demultiplexing the
>> + * wrong response to this request. Multiplex ids could collide if
>> + * one of a series requests takes much longer than the others, or
>> + * if a very large number of long lived requests (byte range
>> + * locks or FindNotify requests) are pending. No more than
>> + * 64K-1 requests can be outstanding at one time. If no
>> + * mids are available, return zero. A future optimization
>> + * could make the combination of mids and uid the key we use
>> + * to demultiplex on (rather than mid alone).
>> + * In addition to the above check, the cifs demultiplex
>> + * code already used the command code as a secondary
>> + * check of the frame and if signing is negotiated the
>> + * response would be discarded if the mid were the same
>> + * but the signature was wrong. Since the mid is not put in the
>> + * pending queue until later (when it is about to be dispatched)
>> + * we do have to limit the number of outstanding requests
>> + * to somewhat less than 64K-1 although it is hard to imagine
>> + * so many threads being in the vfs at one time.
>> + */
>> +__u64 GetNextMid(struct TCP_Server_Info *server)
>> =A0{
>> - =A0 =A0 __u16 mid =3D 0;
>> - =A0 =A0 __u16 last_mid;
>> + =A0 =A0 __u64 mid =3D 0;
>> + =A0 =A0 __u16 last_mid, cur_mid;
>> =A0 =A0 =A0 bool collision;
>>
>> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> - =A0 =A0 last_mid =3D server->CurrentMid; /* we do not want to loop=
 forever */
>> - =A0 =A0 server->CurrentMid++;
>> - =A0 =A0 /* This nested loop looks more expensive than it is.
>> - =A0 =A0 In practice the list of pending requests is short,
>> - =A0 =A0 fewer than 50, and the mids are likely to be unique
>> - =A0 =A0 on the first pass through the loop unless some request
>> - =A0 =A0 takes longer than the 64 thousand requests before it
>> - =A0 =A0 (and it would also have to have been a request that
>> - =A0 =A0 =A0did not time out) */
>> - =A0 =A0 while (server->CurrentMid !=3D last_mid) {
>> +
>> + =A0 =A0 /* mid is 16 bit only for CIFS/SMB */
>> + =A0 =A0 cur_mid =3D (__u16)((server->CurrentMid) & 0xffff);
>> + =A0 =A0 /* we do not want to loop forever */
>> + =A0 =A0 last_mid =3D cur_mid;
>> + =A0 =A0 cur_mid++;
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* This nested loop looks more expensive than it is.
>> + =A0 =A0 =A0* In practice the list of pending requests is short,
>> + =A0 =A0 =A0* fewer than 50, and the mids are likely to be unique
>> + =A0 =A0 =A0* on the first pass through the loop unless some reques=
t
>> + =A0 =A0 =A0* takes longer than the 64 thousand requests before it
>> + =A0 =A0 =A0* (and it would also have to have been a request that
>> + =A0 =A0 =A0* did not time out).
>> + =A0 =A0 =A0*/
>> + =A0 =A0 while (cur_mid !=3D last_mid) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mid_q_entry *mid_entry;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int num_mids;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 collision =3D false;
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (server->CurrentMid =3D=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->CurrentMid++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (cur_mid =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur_mid++;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_mids =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry(mid_entry, &server->=
pending_mid_q, qhead) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++num_mids;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->mid =3D=3D =
server->CurrentMid &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->mid =3D=3D =
cur_mid &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->midSt=
ate =3D=3D MID_REQUEST_SUBMITTED) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This =
mid is in use, try a different one */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 collisio=
n =3D true;
>> @@ -282,10 +289,11 @@ __u16 GetNextMid(struct TCP_Server_Info *serve=
r)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->tcpStatus =3D Ci=
fsNeedReconnect;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!collision) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid =3D server->CurrentMid=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid =3D (__u64)cur_mid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->CurrentMid =3D mid=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 server->CurrentMid++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cur_mid++;
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> =A0 =A0 =A0 return mid;
>
> Not directly related to this patch, but should we move all of these m=
id
> operations under the req_lock instead of the GlobalMid_Lock? The glob=
al
> spinlock is a bottleneck and all of the structures involved should be
> per-server anyway.
>
> Anyway, I think this looks ok
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The idea of a union for these two key fields is worth thinking about
more - any more opinions from others on this?

--=20
Thanks,

Steve
