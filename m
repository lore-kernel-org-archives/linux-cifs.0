From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: fix oops while traversing open file list (try #2)
Date: Fri, 18 May 2012 08:29:56 -0400
Message-ID: <20120518082956.44ec8785@corrin.poochiereds.net>
References: <1337188413-28947-1-git-send-email-shirishpargaonkar@gmail.com>
	<20120516135548.2acb454a@tlielax.poochiereds.net>
	<CADT32eJ1VuL52DLnc=SuNjiSEzwMHXOtM4VJXfYZrmTSUoDQYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJ1VuL52DLnc=SuNjiSEzwMHXOtM4VJXfYZrmTSUoDQYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 May 2012 15:41:24 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

[...]

> >
> > Hmm...now that I think about this, do we really want to move this t=
o
> > the end of the list here? If this turns out to be reclaimable we wi=
ll
> > have moved it to the end of the list, and then it will be the *last=
*
> > one found on the next pass into this function.
>=20
> yes, but we need to keep this element on the list while reclaimation
> is going on.  If we keep where it is and reclaim fails, we may oops
> for we are not sure if the next element is still intact (that is the =
reason
> of the oops in the first place) since we will continue down the list
> looking for another file handle.
>=20

No, because once you drop the spinlock to do the reclaim you have to
start walking the list from the head again.

> >
> >> =C2=A0 =C2=A0 =C2=A0 spin_unlock(&cifs_file_list_lock);
> >> +
> >> + =C2=A0 =C2=A0 if (inv_file) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_reopen_fil=
e(inv_file, false);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return inv_file;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 spin_lock(&cifs_file_list_lock);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cifsFileInfo_put(inv_file);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Here's where=
 I have to rescind my Ack -- sorry :(
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0This is goin=
g to deadlock -- the first thing
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0that cifsFil=
eInfo_put() does is lock the
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_file_li=
st_lock.
>=20
> Agree.  Thanks. I think reversing the order of the calls
> spin_lock() and cifsFileInfo_put(), should take care of that.
>=20

Yes, that should be fine.

> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0It seems to =
me that moving the file to the end of the
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list here wo=
uld make more sense. IOW, we should only do
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0that if it t=
urned out not to be reclaimable. Right?
>=20
> But the problem would remain.  We are reclaiming without lock
> so we have to consider the possibility that reclaim could fail, so
> list move could fail if the next element has become stale/invalid.
>=20

No -- if the reclaim fails, you go to refind_writable and start
walking the list all over again from the head. Once you drop the
spinlock you *must* do that regardless of whether you moved this entry
or not. You don't know if other threads have modified it while you no
longer hold the lock.

The idea with moving this to the end is that you want to avoid picking
the same FID over and over again in the event that it's unreclaimable,
while there are others that could be reclaimed. There's no need to do
that however if the file is able to be reclaimed.

> >
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ++refind;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto refind_writable;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >> +
> >> =C2=A0 =C2=A0 =C2=A0 return NULL;
> >> =C2=A0}
> >>

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
