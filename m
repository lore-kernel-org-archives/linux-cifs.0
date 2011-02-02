From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions
Date: Wed, 2 Feb 2011 11:00:47 -0500
Message-ID: <20110202110047.4a3e2b26@corrin.poochiereds.net>
References: <1295995034-8771-1-git-send-email-shirishpargaonkar@gmail.com>
	<AANLkTim9EEC7P8z1xNB176N+R++N7OSBE4GKAbtzg795@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim9EEC7P8z1xNB176N+R++N7OSBE4GKAbtzg795-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2 Feb 2011 09:40:36 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> +
> > +static void
> > +id_rb_insert(struct rb_root *root, struct cifs_sid_id *new_sididpt=
r,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long id)
> > +{
> > + =A0 =A0 =A0 int rc;
> > + =A0 =A0 =A0 struct rb_node **new =3D &(root->rb_node), *parent =3D=
 NULL;
> > + =A0 =A0 =A0 struct cifs_sid_id *sididptr;
> > +
> > + =A0 =A0 =A0 while (*new) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sididptr =3D rb_entry(*new, struct ci=
fs_sid_id, rbnode);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 parent =3D *new;
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D compare_sids(&sididptr->sid, &=
new_sididptr->sid);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new =3D &((*new)->rb_=
left);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc > 0)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new =3D &((*new)->rb_=
right);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(new_sididptr);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>=20
> Jeff, this change is not sufficient to avoid the race in id_rb_insert=
()?
> If compare_sids returns 0, that means the node/mapping already exists
> i.e. the first racing thread grabbed the lock and inserted the mappin=
g,
> so the second racing thread discovers that and returns without insert=
ing
> that node?  All of this happening within spin lock?
>=20

Ahh ok, I missed that -- perhaps some comments in the id_rb_insert
function would be helpful? It seems a little odd to just make it a
no-op in that case, but if you're certain that the idmapping will never
change then I suppose it will work.

That said, I'm still not fond of this scheme. Why do you feel it's
better to make both threads do an upcall in this situation instead of
sticking an entry in the tree and having the second thread block until
construction is complete?

Bear in mind that keys upcalls are _expensive_. It's basically a
fork-and-exec every time. Minimizing the number of upcalls seems
like it ought to be a design goal here particularly since this is
likely to happen quite a lot...

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
