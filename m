From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/7] cifs: don't call mid_q_entry->callback under the
 Global_MidLock
Date: Fri, 20 May 2011 14:57:58 -0400
Message-ID: <20110520145758.6efc2dbc@corrin.poochiereds.net>
References: <1305836578-26333-1-git-send-email-jlayton@redhat.com>
	<1305836578-26333-4-git-send-email-jlayton@redhat.com>
	<BANLkTimzEy+GxOjiC3yhjUD2ynoiRDRkag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimzEy+GxOjiC3yhjUD2ynoiRDRkag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 May 2011 13:32:10 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, May 19, 2011 at 3:22 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > Holding the spinlock while we call this function means that it can'=
t
> > sleep, which really limits what it can do. Taking it out from under
> > the spinlock also means less contention for this global lock.
> >
> > Change the semantics such that the Global_MidLock is not held when
> > the callback is called. To do this requires that we take extra care
> > not to have sync_mid_result remove the mid from the list when the
> > mid is in a state where that has already happened. This prevents
> > list corruption when the mid is sitting on a private list for
> > reconnect or when cifsd is coming down.
> >
> > Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifsglob.h =C2=A0| =C2=A0 =C2=A06 +++---
> > =C2=A0fs/cifs/connect.c =C2=A0 | =C2=A0 30 ++++++++++++++++++++++++=
------
> > =C2=A0fs/cifs/transport.c | =C2=A0 23 ++++++++---------------
> > =C2=A03 files changed, 35 insertions(+), 24 deletions(-)
> >

[...]

> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* mark submitted MIDs for retry and iss=
ue callback */
> > - =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: issuing mid callbacks", __func_=
_);
> > + =C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&retry_list);
> > + =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: moving mids to private list", _=
_func__);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&GlobalMid_Lock);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_safe(tmp, tmp2, &server->p=
ending_mid_q) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mid_entry =3D=
 list_entry(tmp, struct mid_q_entry, qhead);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mid_entr=
y->midState =3D=3D MID_REQUEST_SUBMITTED)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0mid_entry->midState =3D MID_RETRY_NEEDED;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_move(&mid_e=
ntry->qhead, &retry_list);
> > + =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: moving mids to private list", _=
_func__);
>=20
> Does this comment repeat here?
>=20

Oops, yes. I'll plan to fix it. If there are no other problems with the
patch, it might be easiest to commit this as-is and I'll do another
patch to fix it. Otherwise, I can respin if Steve prefers.

> > + =C2=A0 =C2=A0 =C2=A0 list_for_each_safe(tmp, tmp2, &retry_list) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mid_entry =3D li=
st_entry(tmp, struct mid_q_entry, qhead);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_del_ini=
t(&mid_entry->qhead);
>=20
> And if we called list_move on this entry earlier, does this entry exi=
st
> on the qhead list anymore i.e. did not list_move that care of list_de=
l part?
>=20

list_move moves it from the pending_mid_q to the retry_list.
list_del_init removes it from the list and then makes the list_head
point to itself (i.e. turns it into an empty list).

We have to do the initial list_move with the spinlock held since anothe=
r
thread could be modifying the pending_mid_q. After they all get moved
to the retry list, we can walk that list without holding the spinlock
since it's private.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
