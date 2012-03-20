From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 10/11] CIFS: Expand CurrentMid field
Date: Tue, 20 Mar 2012 06:28:43 -0400
Message-ID: <20120320062843.1cd218ed@tlielax.poochiereds.net>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-11-git-send-email-piastry@etersoft.ru>
	<20120319162410.42b95f13@redhat.com>
	<CAH2r5mujZook3O2Ojvu+vjx5Y5uYuormbtbDW69iOLEf1XVQgg@mail.gmail.com>
	<CAKywueTpa6Hmz7oQ=8S1ViRU9ky7wqhKN+f=eaWrJY1457X86w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTpa6Hmz7oQ=8S1ViRU9ky7wqhKN+f=eaWrJY1457X86w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 20 Mar 2012 11:37:27 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 20 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2012=C2=A0=D0=B3. 0:48 =D0=BF=D0=BE=
=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Steve Fren=
ch <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> > On Mon, Mar 19, 2012 at 3:24 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
> >> On Fri, 16 Mar 2012 18:09:33 +0300
> >> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >>
> >>> While in CIFS/SMB we have 16 bit mid, in SMB2 it is 64 bit.
> >>> Convert the existing field to 64 bit and mask off higher bits
> >>> for CIFS/SMB.
> >>>
> >>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >>> ---
> >>> =C2=A0fs/cifs/cifsglob.h =C2=A0| =C2=A0 =C2=A02 +-
> >>> =C2=A0fs/cifs/cifsproto.h | =C2=A0 =C2=A02 +-
> >>> =C2=A0fs/cifs/misc.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 84 ++++++++++++=
++++++++++++++++-----------------------
> >>> =C2=A03 files changed, 48 insertions(+), 40 deletions(-)
> >>>
> >>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >>> index a403398..b213458 100644
> >>> --- a/fs/cifs/cifsglob.h
> >>> +++ b/fs/cifs/cifsglob.h
> >>> @@ -282,7 +282,7 @@ struct TCP_Server_Info {
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vcnumbers */
> >>> =C2=A0 =C2=A0 =C2=A0 int capabilities; /* allow selective disabli=
ng of caps by smb sess */
> >>> =C2=A0 =C2=A0 =C2=A0 int timeAdj; =C2=A0/* Adjust for difference =
in server time zone in sec */
> >>> - =C2=A0 =C2=A0 __u16 CurrentMid; =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* =
multiplex id - rotating counter */
> >>> + =C2=A0 =C2=A0 __u64 CurrentMid; =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* =
multiplex id - rotating counter */
> >>
> >> It occurs to me that a simpler way to do this might be to turn thi=
s
> >> into a union with a u16 and u64 field. This works just as well tho=
ugh...
> >>
> >>> =C2=A0 =C2=A0 =C2=A0 char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used=
 by ntlm, ntlmv2 etc */
> >>> =C2=A0 =C2=A0 =C2=A0 /* 16th byte of RFC1001 workstation name is =
always null */
> >>> =C2=A0 =C2=A0 =C2=A0 char workstation_RFC1001_name[RFC1001_NAME_L=
EN_WITH_NULL];
> >>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >>> index db38a40..8958721 100644
> >>> --- a/fs/cifs/cifsproto.h
> >>> +++ b/fs/cifs/cifsproto.h
> >>> @@ -115,7 +115,7 @@ extern int small_smb_init_no_tc(const int smb=
_cmd, const int wct,
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void **request_buf);
> >>> =C2=A0extern int CIFS_SessSetup(unsigned int xid, struct cifs_ses=
 *ses,
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct nls_table *nls_cp);
> >>> -extern __u16 GetNextMid(struct TCP_Server_Info *server);
> >>> +extern __u64 GetNextMid(struct TCP_Server_Info *server);
> >>> =C2=A0extern struct timespec cifs_NTtimeToUnix(__le64 utc_nanosec=
onds_since_1601);
> >>> =C2=A0extern u64 cifs_UnixTimeToNT(struct timespec);
> >>> =C2=A0extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le1=
6 le_time,
> >>> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> >>> index 88459d0..0b743b7 100644
> >>> --- a/fs/cifs/misc.c
> >>> +++ b/fs/cifs/misc.c
> >>> @@ -213,54 +213,61 @@ cifs_small_buf_release(void *buf_to_free)
> >>> =C2=A0}
> >>>
> >>> =C2=A0/*
> >>> - =C2=A0 =C2=A0 Find a free multiplex id (SMB mid). Otherwise the=
re could be
> >>> - =C2=A0 =C2=A0 mid collisions which might cause problems, demult=
iplexing the
> >>> - =C2=A0 =C2=A0 wrong response to this request. Multiplex ids cou=
ld collide if
> >>> - =C2=A0 =C2=A0 one of a series requests takes much longer than t=
he others, or
> >>> - =C2=A0 =C2=A0 if a very large number of long lived requests (by=
te range
> >>> - =C2=A0 =C2=A0 locks or FindNotify requests) are pending. =C2=A0=
No more than
> >>> - =C2=A0 =C2=A0 64K-1 requests can be outstanding at one time. =C2=
=A0If no
> >>> - =C2=A0 =C2=A0 mids are available, return zero. =C2=A0A future o=
ptimization
> >>> - =C2=A0 =C2=A0 could make the combination of mids and uid the ke=
y we use
> >>> - =C2=A0 =C2=A0 to demultiplex on (rather than mid alone).
> >>> - =C2=A0 =C2=A0 In addition to the above check, the cifs demultip=
lex
> >>> - =C2=A0 =C2=A0 code already used the command code as a secondary
> >>> - =C2=A0 =C2=A0 check of the frame and if signing is negotiated t=
he
> >>> - =C2=A0 =C2=A0 response would be discarded if the mid were the s=
ame
> >>> - =C2=A0 =C2=A0 but the signature was wrong. =C2=A0Since the mid =
is not put in the
> >>> - =C2=A0 =C2=A0 pending queue until later (when it is about to be=
 dispatched)
> >>> - =C2=A0 =C2=A0 we do have to limit the number of outstanding req=
uests
> >>> - =C2=A0 =C2=A0 to somewhat less than 64K-1 although it is hard t=
o imagine
> >>> - =C2=A0 =C2=A0 so many threads being in the vfs at one time.
> >>> -*/
> >>> -__u16 GetNextMid(struct TCP_Server_Info *server)
> >>> + * Find a free multiplex id (SMB mid). Otherwise there could be
> >>> + * mid collisions which might cause problems, demultiplexing the
> >>> + * wrong response to this request. Multiplex ids could collide i=
f
> >>> + * one of a series requests takes much longer than the others, o=
r
> >>> + * if a very large number of long lived requests (byte range
> >>> + * locks or FindNotify requests) are pending. No more than
> >>> + * 64K-1 requests can be outstanding at one time. If no
> >>> + * mids are available, return zero. A future optimization
> >>> + * could make the combination of mids and uid the key we use
> >>> + * to demultiplex on (rather than mid alone).
> >>> + * In addition to the above check, the cifs demultiplex
> >>> + * code already used the command code as a secondary
> >>> + * check of the frame and if signing is negotiated the
> >>> + * response would be discarded if the mid were the same
> >>> + * but the signature was wrong. Since the mid is not put in the
> >>> + * pending queue until later (when it is about to be dispatched)
> >>> + * we do have to limit the number of outstanding requests
> >>> + * to somewhat less than 64K-1 although it is hard to imagine
> >>> + * so many threads being in the vfs at one time.
> >>> + */
> >>> +__u64 GetNextMid(struct TCP_Server_Info *server)
> >>> =C2=A0{
> >>> - =C2=A0 =C2=A0 __u16 mid =3D 0;
> >>> - =C2=A0 =C2=A0 __u16 last_mid;
> >>> + =C2=A0 =C2=A0 __u64 mid =3D 0;
> >>> + =C2=A0 =C2=A0 __u16 last_mid, cur_mid;
> >>> =C2=A0 =C2=A0 =C2=A0 bool collision;
> >>>
> >>> =C2=A0 =C2=A0 =C2=A0 spin_lock(&GlobalMid_Lock);
> >>> - =C2=A0 =C2=A0 last_mid =3D server->CurrentMid; /* we do not wan=
t to loop forever */
> >>> - =C2=A0 =C2=A0 server->CurrentMid++;
> >>> - =C2=A0 =C2=A0 /* This nested loop looks more expensive than it =
is.
> >>> - =C2=A0 =C2=A0 In practice the list of pending requests is short=
,
> >>> - =C2=A0 =C2=A0 fewer than 50, and the mids are likely to be uniq=
ue
> >>> - =C2=A0 =C2=A0 on the first pass through the loop unless some re=
quest
> >>> - =C2=A0 =C2=A0 takes longer than the 64 thousand requests before=
 it
> >>> - =C2=A0 =C2=A0 (and it would also have to have been a request th=
at
> >>> - =C2=A0 =C2=A0 =C2=A0did not time out) */
> >>> - =C2=A0 =C2=A0 while (server->CurrentMid !=3D last_mid) {
> >>> +
> >>> + =C2=A0 =C2=A0 /* mid is 16 bit only for CIFS/SMB */
> >>> + =C2=A0 =C2=A0 cur_mid =3D (__u16)((server->CurrentMid) & 0xffff=
);
> >>> + =C2=A0 =C2=A0 /* we do not want to loop forever */
> >>> + =C2=A0 =C2=A0 last_mid =3D cur_mid;
> >>> + =C2=A0 =C2=A0 cur_mid++;
> >>> +
> >>> + =C2=A0 =C2=A0 /*
> >>> + =C2=A0 =C2=A0 =C2=A0* This nested loop looks more expensive tha=
n it is.
> >>> + =C2=A0 =C2=A0 =C2=A0* In practice the list of pending requests =
is short,
> >>> + =C2=A0 =C2=A0 =C2=A0* fewer than 50, and the mids are likely to=
 be unique
> >>> + =C2=A0 =C2=A0 =C2=A0* on the first pass through the loop unless=
 some request
> >>> + =C2=A0 =C2=A0 =C2=A0* takes longer than the 64 thousand request=
s before it
> >>> + =C2=A0 =C2=A0 =C2=A0* (and it would also have to have been a re=
quest that
> >>> + =C2=A0 =C2=A0 =C2=A0* did not time out).
> >>> + =C2=A0 =C2=A0 =C2=A0*/
> >>> + =C2=A0 =C2=A0 while (cur_mid !=3D last_mid) {
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct mid_q_ent=
ry *mid_entry;
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int num=
_mids;
> >>>
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 collision =3D fa=
lse;
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (server->CurrentMi=
d =3D=3D 0)
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 server->CurrentMid++;
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cur_mid =3D=3D 0)
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 cur_mid++;
> >>>
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 num_mids =3D 0;
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_en=
try(mid_entry, &server->pending_mid_q, qhead) {
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ++num_mids;
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (mid_entry->mid =3D=3D server->CurrentMid &&
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (mid_entry->mid =3D=3D cur_mid &&
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 mid_entry->midState =3D=3D MID_REQUEST_SUBMITT=
ED) {
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* This mid is in use, try a dif=
ferent one */
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 collision =3D true;
> >>> @@ -282,10 +289,11 @@ __u16 GetNextMid(struct TCP_Server_Info *se=
rver)
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 server->tcpStatus =3D CifsNeedReconnect;
> >>>
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!collision) =
{
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 mid =3D server->CurrentMid;
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 mid =3D (__u64)cur_mid;
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 server->CurrentMid =3D mid;
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 server->CurrentMid++;
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cur_mid++;
> >>> =C2=A0 =C2=A0 =C2=A0 }
> >>> =C2=A0 =C2=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >>> =C2=A0 =C2=A0 =C2=A0 return mid;
> >>
> >> Not directly related to this patch, but should we move all of thes=
e mid
> >> operations under the req_lock instead of the GlobalMid_Lock? The g=
lobal
> >> spinlock is a bottleneck and all of the structures involved should=
 be
> >> per-server anyway.
> >>
> >> Anyway, I think this looks ok
> >>
> >> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> > The idea of a union for these two key fields is worth thinking abou=
t
> > more - any more opinions from others on this?
> >
>=20
> I think our main goal is to make to code is cleaner as possible. If w=
e
> change this to a union we can't use the same codepath for both
> protocols - more protocol specific code - harder to understand, fix
> bugs, etc.
>=20
>=20

You're going to need some bit of separate code in order to deal with
the differences in field width in things like the MID. The question is
how to abstract that code out. It's probably cleaner to do so with an
ops struct of some sort rather than sprinkling "if (server->is_smb2)"
all over the code.

Once you design the code around that sort of idea, then using a union
may be cleaner, but you'll have to make that judgment as you proceed...

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
