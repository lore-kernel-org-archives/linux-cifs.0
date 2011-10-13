From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 07/16] cifs: turn read_from_socket into a wrapper around
 a vectorized version
Date: Thu, 13 Oct 2011 08:21:59 -0400
Message-ID: <20111013082159.73da6a16@barsoom.rdu.redhat.com>
References: <1314616624-5362-1-git-send-email-jlayton@redhat.com>
	<1314616624-5362-8-git-send-email-jlayton@redhat.com>
	<CAKywueQvupyRrQTN7JsSpO9zzUO=O7S4RUV3aPaiaakTJjjRAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQvupyRrQTN7JsSpO9zzUO=O7S4RUV3aPaiaakTJjjRAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 13 Oct 2011 13:20:18 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/8/29 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > Eventually we'll want to allow cifsd to read data directly into the
> > pagecache. In order to do that we'll need a routine that can take a
> > kvec array and pass that directly to kernel_recvmsg.
> >
> > Unfortunately though, the kernel's recvmsg routines modify the kvec
> > array that gets passed in, so we need to use a copy of the kvec arr=
ay
> > and refresh that copy on each pass through the loop.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/connect.c | =C2=A0 72 +++++++++++++++++++++++++++++++=
++++++++++++++++-----
> > =C2=A01 files changed, 65 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index e6da201..08c6b0e 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -375,14 +375,58 @@ server_unresponsive(struct TCP_Server_Info *s=
erver)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> > =C2=A0}
> >
> > +/*
> > + * kvec_array_setup - clone a kvec array, and advance into it
> > + * @new: =C2=A0 =C2=A0 =C2=A0 pointer to memory for cloned array
> > + * @iov: =C2=A0 =C2=A0 =C2=A0 pointer to original array
> > + * @nr_segs: =C2=A0 number of members in original array
> > + * @bytes: =C2=A0 =C2=A0 number of bytes to advance into the clone=
d array
> > + *
> > + * This function will copy the array provided in iov to a section =
of memory
> > + * and advance the specified number of bytes into the new array. I=
t returns
> > + * the number of segments in the new array. "new" must be at least=
 as big as
> > + * the original iov array.
> > + */
> > +static unsigned int
> > +kvec_array_init(struct kvec *new, struct kvec *iov, unsigned int n=
r_segs,
>=20
> I think it should be kvec_array_setup as it said in the description a=
bove.
>=20

Good catch...

Unless there is an objection, I'll also fix this in a follow-on patch
to the series.

> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t bytes)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 size_t base =3D 0;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 while (bytes || !iov->iov_len) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int copy =3D min=
(bytes, iov->iov_len);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bytes -=3D copy;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 base +=3D copy;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (iov->iov_len=
 =3D=3D base) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 iov++;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 nr_segs--;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 base =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 memcpy(new, iov, sizeof(*iov) * nr_segs);
> > + =C2=A0 =C2=A0 =C2=A0 new->iov_base +=3D base;
> > + =C2=A0 =C2=A0 =C2=A0 new->iov_len -=3D base;
> > + =C2=A0 =C2=A0 =C2=A0 return nr_segs;
> > +}
> > +
> > =C2=A0static int
> > -read_from_socket(struct TCP_Server_Info *server, char *buf,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned i=
nt to_read)
> > +readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov=
_orig,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned =
int nr_segs, unsigned int to_read)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int length =3D 0;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int total_read;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int segs;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct msghdr smb_msg;
> > - =C2=A0 =C2=A0 =C2=A0 struct kvec iov;
> > + =C2=A0 =C2=A0 =C2=A0 struct kvec *iov;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* FIXME: allocation here may cause dea=
dlocks under memory pressure.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Switch this to use a fixed, per-sock=
et buffer.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 iov =3D kmalloc(sizeof(*iov_orig) * nr_segs,=
 GFP_KERNEL);
> > + =C2=A0 =C2=A0 =C2=A0 if (!iov)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0smb_msg.msg_control =3D NULL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0smb_msg.msg_controllen =3D 0;
> > @@ -393,10 +437,11 @@ read_from_socket(struct TCP_Server_Info *serv=
er, char *buf,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iov.iov_base =3D=
 buf + total_read;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iov.iov_len =3D =
to_read;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 length =3D kerne=
l_recvmsg(server->ssocket, &smb_msg, &iov, 1,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 to_r=
ead, 0);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 segs =3D kvec_ar=
ray_init(iov, iov_orig, nr_segs, total_read);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 length =3D kerne=
l_recvmsg(server->ssocket, &smb_msg,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iov,=
 segs, to_read, 0);
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (server->=
tcpStatus =3D=3D CifsExiting) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0total_read =3D -ESHUTDOWN;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> > @@ -423,9 +468,22 @@ read_from_socket(struct TCP_Server_Info *serve=
r, char *buf,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > + =C2=A0 =C2=A0 =C2=A0 kfree(iov);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return total_read;
> > =C2=A0}
> >
> > +static int
> > +read_from_socket(struct TCP_Server_Info *server, char *buf,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned i=
nt to_read)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 struct kvec iov;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 iov.iov_base =3D buf;
> > + =C2=A0 =C2=A0 =C2=A0 iov.iov_len =3D to_read;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 return readv_from_socket(server, &iov, 1, to=
_read);
> > +}
> > +
> > =C2=A0static bool
> > =C2=A0check_rfc1002_header(struct TCP_Server_Info *server, char *bu=
f)
> > =C2=A0{
> > --
> > 1.7.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
>=20
>=20
>=20
> --=20
> Best regards,
> Pavel Shilovsky.


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
