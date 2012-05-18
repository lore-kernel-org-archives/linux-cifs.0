From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: fix oops while traversing open file list (try #2)
Date: Fri, 18 May 2012 12:25:04 -0400
Message-ID: <20120518122504.295c58a0@corrin.poochiereds.net>
References: <1337188413-28947-1-git-send-email-shirishpargaonkar@gmail.com>
	<20120516135548.2acb454a@tlielax.poochiereds.net>
	<CADT32eJ1VuL52DLnc=SuNjiSEzwMHXOtM4VJXfYZrmTSUoDQYA@mail.gmail.com>
	<20120518082956.44ec8785@corrin.poochiereds.net>
	<CADT32eLFpHkerpiW_WGv_DqetOn5SuFBDo+WVe0dhziXf-3r1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLFpHkerpiW_WGv_DqetOn5SuFBDo+WVe0dhziXf-3r1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 18 May 2012 11:14:38 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, May 18, 2012 at 7:29 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Wed, 16 May 2012 15:41:24 -0500
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > [...]
> >
> >> >
> >> > Hmm...now that I think about this, do we really want to move thi=
s to
> >> > the end of the list here? If this turns out to be reclaimable we=
 will
> >> > have moved it to the end of the list, and then it will be the *l=
ast*
> >> > one found on the next pass into this function.
> >>
> >> yes, but we need to keep this element on the list while reclaimati=
on
> >> is going on. =C2=A0If we keep where it is and reclaim fails, we ma=
y oops
> >> for we are not sure if the next element is still intact (that is t=
he reason
> >> of the oops in the first place) since we will continue down the li=
st
> >> looking for another file handle.
> >>
> >
> > No, because once you drop the spinlock to do the reclaim you have t=
o
> > start walking the list from the head again.
> >
> >> >
> >> >> =C2=A0 =C2=A0 =C2=A0 spin_unlock(&cifs_file_list_lock);
> >> >> +
> >> >> + =C2=A0 =C2=A0 if (inv_file) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_reopen_=
file(inv_file, false);
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc)
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return inv_file;
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 spin_lock(&cifs_file_list_lock);
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cifsFileInfo_put(inv_file);
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Here's wh=
ere I have to rescind my Ack -- sorry :(
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0This is g=
oing to deadlock -- the first thing
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0that cifs=
=46ileInfo_put() does is lock the
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_file=
_list_lock.
> >>
> >> Agree. =C2=A0Thanks. I think reversing the order of the calls
> >> spin_lock() and cifsFileInfo_put(), should take care of that.
> >>
> >
> > Yes, that should be fine.
> >
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0It seems =
to me that moving the file to the end of the
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list here=
 would make more sense. IOW, we should only do
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0that if i=
t turned out not to be reclaimable. Right?
> >>
> >> But the problem would remain. =C2=A0We are reclaiming without lock
> >> so we have to consider the possibility that reclaim could fail, so
> >> list move could fail if the next element has become stale/invalid.
> >>
> >
> > No -- if the reclaim fails, you go to refind_writable and start
> > walking the list all over again from the head. Once you drop the
> > spinlock you *must* do that regardless of whether you moved this en=
try
> > or not. You don't know if other threads have modified it while you =
no
> > longer hold the lock.
> >
> > The idea with moving this to the end is that you want to avoid pick=
ing
> > the same FID over and over again in the event that it's unreclaimab=
le,
> > while there are others that could be reclaimed. There's no need to =
do
> > that however if the file is able to be reclaimed.
>=20
> Jeff, not clear yet.  What I am trying to say is, if the reclaim fail=
s,
> then, we can't reliably move the element to the end of the list
> since its links are not reliable after dropping the lock.
> So we do not know if the reclaim will succeedor fail, if it fails,
> we can't be sure that move will not oops and so we do not take
> a chance and move it before attempting reclaim.
>=20

The list links will be reliable as long as you hold a reference to the
file. So, you just need to make sure you move it to the end of the list
before you do the cifsFileInfo_put.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
