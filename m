From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3 08/15] cifscreds: make username parameter optional
Date: Wed, 11 Jan 2012 13:48:25 -0500
Message-ID: <20120111134825.6a3dee8e@tlielax.poochiereds.net>
References: <1325873687-11229-1-git-send-email-jlayton@samba.org>
	<1325873687-11229-9-git-send-email-jlayton@samba.org>
	<CADT32eJAfBUozLzhobOpWq62hygwi1mfB76ZzWBfy7tKdVzhGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJAfBUozLzhobOpWq62hygwi1mfB76ZzWBfy7tKdVzhGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 11 Jan 2012 12:22:30 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Jan 6, 2012 at 12:14 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > ...and use getopt_long to get it. If someone doesn't specify the us=
ername,
> > use getusername() to get it.
> >
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> > =C2=A0cifscreds.c | =C2=A0 39 ++++++++++++++++++++++++++++---------=
--
> > =C2=A01 files changed, 28 insertions(+), 11 deletions(-)
> >
> > diff --git a/cifscreds.c b/cifscreds.c
> > index 79ab426..f45497a 100644
> > --- a/cifscreds.c
> > +++ b/cifscreds.c
> > @@ -27,8 +27,10 @@
> > =C2=A0#include <string.h>
> > =C2=A0#include <ctype.h>
> > =C2=A0#include <keyutils.h>
> > +#include <getopt.h>
> > =C2=A0#include "mount.h"
> > =C2=A0#include "resolve_host.h"
> > +#include "util.h"
> >
> > =C2=A0#define THIS_PROGRAM_NAME "cifscreds"
> >
> > @@ -49,8 +51,8 @@
> > =C2=A0#define DEST_KEYRING KEY_SPEC_USER_KEYRING
> >
> > =C2=A0struct cmdarg {
> > - =C2=A0 =C2=A0 =C2=A0 char =C2=A0 =C2=A0*host;
> > - =C2=A0 =C2=A0 =C2=A0 char =C2=A0 =C2=A0*user;
> > + =C2=A0 =C2=A0 =C2=A0 char =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
*host;
> > + =C2=A0 =C2=A0 =C2=A0 char =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
*user;
> > =C2=A0};
> >
> > =C2=A0struct command {
> > @@ -67,13 +69,18 @@ static int cifscreds_update(struct cmdarg *arg)=
;
> > =C2=A0const char *thisprogram;
> >
> > =C2=A0struct command commands[] =3D {
> > - =C2=A0 =C2=A0 =C2=A0 { cifscreds_add, =C2=A0 =C2=A0 =C2=A0 =C2=A0=
"add", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"<host> <user>" },
> > - =C2=A0 =C2=A0 =C2=A0 { cifscreds_clear, =C2=A0 =C2=A0 =C2=A0"clea=
r", =C2=A0 =C2=A0 =C2=A0 =C2=A0"<host> <user>" },
> > + =C2=A0 =C2=A0 =C2=A0 { cifscreds_add, =C2=A0 =C2=A0 =C2=A0 =C2=A0=
"add", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"[-u username] <host>" },
> > + =C2=A0 =C2=A0 =C2=A0 { cifscreds_clear, =C2=A0 =C2=A0 =C2=A0"clea=
r", =C2=A0 =C2=A0 =C2=A0 =C2=A0"[-u username] <host>" },
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{ cifscreds_clearall, =C2=A0 "clearall",=
 =C2=A0 =C2=A0 "" },
> > - =C2=A0 =C2=A0 =C2=A0 { cifscreds_update, =C2=A0 =C2=A0 "update", =
=C2=A0 =C2=A0 =C2=A0 "<host> <user>" },
> > + =C2=A0 =C2=A0 =C2=A0 { cifscreds_update, =C2=A0 =C2=A0 "update", =
=C2=A0 =C2=A0 =C2=A0 "[-u username] <host>" },
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{ NULL, "", NULL }
> > =C2=A0};
> >
> > +struct option longopts[] =3D {
> > + =C2=A0 =C2=A0 =C2=A0 {"username", 1, NULL, 'u'},
> > + =C2=A0 =C2=A0 =C2=A0 {NULL, 0, NULL, 0}
> > +};
> > +
> > =C2=A0/* display usage information */
> > =C2=A0static int
> > =C2=A0usage(void)
> > @@ -499,12 +506,22 @@ int main(int argc, char **argv)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc =3D=3D 1)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return usage=
();
> >
> > + =C2=A0 =C2=A0 =C2=A0 while((n =3D getopt_long(argc, argv, "u:", l=
ongopts, NULL)) !=3D -1) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (n) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'u':
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 arg.user =3D optarg;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 default:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return usage();
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* find the best fit command */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0best =3D NULL;
> > - =C2=A0 =C2=A0 =C2=A0 n =3D strnlen(argv[1], MAX_COMMAND_SIZE);
> > + =C2=A0 =C2=A0 =C2=A0 n =3D strnlen(argv[optind], MAX_COMMAND_SIZE=
);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0for (cmd =3D commands; cmd->action; cmd+=
+) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (memcmp(cmd->=
name, argv[1], n) !=3D 0)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (memcmp(cmd->=
name, argv[optind], n) !=3D 0)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0continue;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cmd->nam=
e[n] =3D=3D 0) {
> > @@ -527,12 +544,12 @@ int main(int argc, char **argv)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return EXIT_=
=46AILURE;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 /* first argument should be host */
> > + =C2=A0 =C2=A0 =C2=A0 /* second argument should be host */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc >=3D 3)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 arg.host =3D arg=
v[2];
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 arg.host =3D arg=
v[optind + 1];
> >
> > - =C2=A0 =C2=A0 =C2=A0 if (argc >=3D 4)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 arg.user =3D arg=
v[3];
> > + =C2=A0 =C2=A0 =C2=A0 if (arg.user =3D=3D NULL)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 arg.user =3D get=
username(getuid());
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return best->action(&arg);
> > =C2=A0}
> > --
> > 1.7.7.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>=20
> Just a thought, can user specify only one hostname and would hostname
> be always the last argument for cifscreds_* commands?
>=20
> I was thinking whtether an user might want to manipulate keys for
> multiple servers in one command!

Not a bad idea at all.

I don't see anything that would preclude that. I suppose we could take
multiple host or domain arguments, and set keys for all of them. I'd
probably not do that in this patchset since I'm already making a lot of
changes here, but it wouldn't be too hard to do.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
