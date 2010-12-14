From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/13] cifs: handle cancelled requests better
Date: Tue, 14 Dec 2010 06:59:35 -0500
Message-ID: <20101214065935.50a0bdf0@tlielax.poochiereds.net>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-9-git-send-email-jlayton@redhat.com>
	<AANLkTinU19tUL-6uwYN64dfE1Rsa+uSiC2fkeBHV+XOS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinU19tUL-6uwYN64dfE1Rsa+uSiC2fkeBHV+XOS-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 14 Dec 2010 10:24:28 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2010/12/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > Currently, when a request is cancelled via signal, we delete the mi=
d
> > immediately. If the request was already transmitted however, the cl=
ient
> > is still likely to receive a response. When it does, it won't recog=
nize
> > it however and will pop a printk.
> >
> > It's also a little dangerous to just delete the mid entry like this=
=2E We
> > may end up reusing that mid. If we do then we could potentially get=
 the
> > response from the first request confused with the later one.
> >
> > Prevent the reuse of mids by marking them as cancelled and keeping =
them
> > on the pending_mid_q list. If the reply comes in, we'll delete it f=
rom
> > the list then. If it never comes, then we'll delete it at reconnect
> > or when cifsd comes down.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =A0fs/cifs/cifsglob.h =A0| =A0 =A02 +-
> > =A0fs/cifs/cifsproto.h | =A0 =A01 +
> > =A0fs/cifs/connect.c =A0 | =A0 44 +++++++++++++++++++++++++++++++++=
++++-------
> > =A0fs/cifs/transport.c | =A0 30 ++++++++++++++++++++++--------
> > =A04 files changed, 61 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index cc43ada..fb75f04 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -621,7 +621,7 @@ static inline void free_dfs_info_array(struct d=
fs_info3_param *param,
> > =A0#define =A0 MID_REQUEST_SUBMITTED 2
> > =A0#define =A0 MID_RESPONSE_RECEIVED 4
> > =A0#define =A0 MID_RETRY_NEEDED =A0 =A0 =A08 /* session closed whil=
e this request out */
> > -#define =A0 MID_NO_RESP_NEEDED 0x10
> > +#define =A0 MID_REQUEST_CANCELLED 0x10 /* discard any reply */
> >
> > =A0/* Types of response buffer returned from SendReceive2 */
> > =A0#define =A0 CIFS_NO_BUFFER =A0 =A0 =A0 =A00 =A0 =A0/* Response b=
uffer not returned */
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index fe77e69..a8fc606 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -61,6 +61,7 @@ extern char *cifs_compose_mount_options(const cha=
r *sb_mountdata,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *fullpath, const struct d=
fs_info3_param *ref,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char **devname);
> > =A0/* extern void renew_parental_timestamps(struct dentry *direntry=
);*/
> > +extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
> > =A0extern int SendReceive(const unsigned int /* xid */ , struct cif=
sSesInfo *,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr * /* =
input */ ,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr * /* =
out */ ,
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 7e20ece..0feb592 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -133,7 +133,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> > =A0{
> > =A0 =A0 =A0 =A0int rc =3D 0;
> > =A0 =A0 =A0 =A0struct list_head *tmp, *tmp2;
> > - =A0 =A0 =A0 struct list_head retry;
> > + =A0 =A0 =A0 struct list_head retry, dispose;
> > =A0 =A0 =A0 =A0struct cifsSesInfo *ses;
> > =A0 =A0 =A0 =A0struct cifsTconInfo *tcon;
> > =A0 =A0 =A0 =A0struct mid_q_entry *mid_entry;
> > @@ -192,14 +192,23 @@ cifs_reconnect(struct TCP_Server_Info *server=
)
> > =A0 =A0 =A0 =A0 */
> > =A0 =A0 =A0 =A0cFYI(1, "%s: moving mids to retry list", __func__);
> > =A0 =A0 =A0 =A0INIT_LIST_HEAD(&retry);
> > + =A0 =A0 =A0 INIT_LIST_HEAD(&dispose);
> > =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> > =A0 =A0 =A0 =A0list_for_each_safe(tmp, tmp2, &server->pending_mid_q=
) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D list_entry(tmp, struct=
 mid_q_entry, qhead);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mid_entry->midState =3D=3D MID_R=
EQUEST_SUBMITTED)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_move(tmp, &retr=
y);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (mid_entry->midState =3D=3D M=
ID_REQUEST_CANCELLED)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_move(tmp, &dispo=
se);
> > =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
> >
> > + =A0 =A0 =A0 /* now walk private dispose list and delete entries *=
/
> > + =A0 =A0 =A0 list_for_each_safe(tmp, tmp2, &dispose) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D list_entry(tmp, struct =
mid_q_entry, qhead);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DeleteMidQEntry(mid_entry);
> > + =A0 =A0 =A0 }
> > +
> > =A0 =A0 =A0 =A0while ((server->tcpStatus !=3D CifsExiting) &&
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 (server->tcpStatus !=3D CifsGood)) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0try_to_freeze();
> > @@ -219,7 +228,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0}
> >
> > - =A0 =A0 =A0 /* now, issue callback for all mids in flight */
> > + =A0 =A0 =A0 /* issue callback for all mids in flight */
> > =A0 =A0 =A0 =A0list_for_each_safe(tmp, tmp2, &retry) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del_init(tmp);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D list_entry(tmp, struct=
 mid_q_entry, qhead);
> > @@ -575,9 +584,13 @@ incomplete_rcv:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_for_each(tmp, &server->pending_=
mid_q) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D list_e=
ntry(tmp, struct mid_q_entry, qhead);
> >
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((mid_entry->mid =3D=
=3D smb_buffer->Mid) &&
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (mid_entry->m=
idState =3D=3D MID_REQUEST_SUBMITTED) &&
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (mid_entry->c=
ommand =3D=3D smb_buffer->Command)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->mid !=3D=
 smb_buffer->Mid)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto =
next_mid;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->comman=
d !=3D smb_buffer->Command)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto =
next_mid;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->midSta=
te =3D=3D MID_REQUEST_CANCELLED)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break=
;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->midSta=
te =3D=3D MID_REQUEST_SUBMITTED) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (=
check2ndT2(smb_buffer,server->maxBuf) > 0) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0/* We have a multipart transact2 resp */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0isMultiRsp =3D true;
> > @@ -623,11 +636,16 @@ multi_t2_fnd:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0serv=
er->lstrp =3D jiffies;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0brea=
k;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > +next_mid:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D NULL;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mid_entry !=3D NULL) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->midSta=
te =3D=3D MID_REQUEST_CANCELLED) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Delet=
eMidQEntry(mid_entry);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 conti=
nue;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->callback(=
mid_entry);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Was previous buf =
put in mpx struct for multi-rsp? */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!isMultiRsp) {
> > @@ -704,6 +722,9 @@ multi_t2_fnd:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&cifs_tcp_ses_lock);
> > =A0 =A0 =A0 =A0} else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mid_q_entry *tmp_mid;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct list_head dispose;
> > +
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* although we can not zero the serv=
er struct pointer yet,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0since there are active requests whic=
h may depnd on them,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mark the corresponding SMB sessions =
as exiting too */
> > @@ -713,17 +734,26 @@ multi_t2_fnd:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ses->status =3D Cifs=
Exiting;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> >
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_LIST_HEAD(&dispose);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each(tmp, &server->pending_m=
id_q) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D list_entry(tmp, struct =
mid_q_entry, qhead);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry_safe(mid_entry, t=
mp_mid,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&server->pending_mid_q, qhead) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mid_entry->midSt=
ate =3D=3D MID_REQUEST_SUBMITTED) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI=
(1, "Clearing Mid 0x%x - issuing callback",
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 mid_entry->mid);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_=
entry->callback(mid_entry);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (mid_entry-=
>midState =3D=3D MID_REQUEST_CANCELLED) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(=
1, "Clearing Mid 0x%x - Cancelled",
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 mid_entry->mid);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_=
move(&mid_entry->qhead, &dispose);
>=20
> Why do we need another list here? It seems to me that we can simply
> delete cancelled mid.
>=20

Nope, we can't. DeleteMidQEntry will try to take the GlobalMid_Lock on
its own, so you can't call it there without deadlocking. You also can't
drop the spinlock and then call DeleteMidQEntry since that might mean
that the list will change in the middle of walking it. We could add a
"DeleteMidQEntry_locked", but dealing with locked and non-locked
variants gets messy.

Moving it to a private dispose list and then walking that list outside
of the lock takes care of those problems. I added the "retry" list in
this function for similar reasons.

> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&cifs_tcp_ses_lock);
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* now delete all of the cancelled mi=
ds */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry_safe(mid_entry, t=
mp_mid, &dispose, qhead)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DeleteMidQEntry(mid_e=
ntry);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* 1/8th of sec is more than enough =
time for them to exit */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0msleep(125);
> > =A0 =A0 =A0 =A0}
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 79647db..97a1170 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -81,7 +81,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, =
struct TCP_Server_Info *server)
> > =A0 =A0 =A0 =A0return temp;
> > =A0}
> >
> > -static void
> > +void
> > =A0DeleteMidQEntry(struct mid_q_entry *midEntry)
> > =A0{
> > =A0#ifdef CONFIG_CIFS_STATS2
> > @@ -480,8 +480,13 @@ SendReceive2(const unsigned int xid, struct ci=
fsSesInfo *ses,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> >
> > =A0 =A0 =A0 =A0rc =3D wait_for_response(ses->server, midQ);
> > - =A0 =A0 =A0 if (rc !=3D 0)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> > + =A0 =A0 =A0 if (rc !=3D 0) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* no longer considered to be "in-fli=
ght" */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->midState =3D MID_REQUEST_CANCEL=
LED;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> > + =A0 =A0 =A0 }
> >
> > =A0 =A0 =A0 =A0rc =3D handle_mid_result(midQ, ses->server);
> > =A0 =A0 =A0 =A0if (rc !=3D 0)
> > @@ -623,8 +628,13 @@ SendReceive(const unsigned int xid, struct cif=
sSesInfo *ses,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> >
> > =A0 =A0 =A0 =A0rc =3D wait_for_response(ses->server, midQ);
> > - =A0 =A0 =A0 if (rc !=3D 0)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> > + =A0 =A0 =A0 if (rc !=3D 0) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* no longer considered to be "in-fli=
ght" */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->midState =3D MID_REQUEST_CANCEL=
LED;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> > + =A0 =A0 =A0 }
> >
> > =A0 =A0 =A0 =A0rc =3D handle_mid_result(midQ, ses->server);
> > =A0 =A0 =A0 =A0if (rc !=3D 0)
> > @@ -842,10 +852,14 @@ SendReceiveBlockingLock(const unsigned int xi=
d, struct cifsTconInfo *tcon,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> >
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wait_for_response(ses->server, mi=
dQ) =3D=3D 0) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We got the respons=
e - restart system call. */
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rstart =3D 1;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_for_response(ses->server,=
 midQ);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->midState =3D MI=
D_REQUEST_CANCELLED;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We got the response - restart syst=
em call. */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rstart =3D 1;
> > =A0 =A0 =A0 =A0}
> >
> > =A0 =A0 =A0 =A0rc =3D handle_mid_result(midQ, ses->server);
> > --
> > 1.7.3.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
