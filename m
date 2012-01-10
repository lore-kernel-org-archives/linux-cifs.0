From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: allow admins to specify an alternate krb5.conf
 file
Date: Tue, 10 Jan 2012 14:16:26 -0500
Message-ID: <20120110141626.6545c293@tlielax.poochiereds.net>
References: <1326220007-527-1-git-send-email-jlayton@samba.org>
	<CADT32eJ_Md78_eZ_zyox55GOy=2dsRjZXs-QAVELZD9eGAUQXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, myllynen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJ_Md78_eZ_zyox55GOy=2dsRjZXs-QAVELZD9eGAUQXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 10 Jan 2012 13:04:53 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Jan 10, 2012 at 12:26 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
> > This was actually requested by the Red Hat QA group, who sometimes =
work
> > with multiple krb5.conf files when testing.
> >
> > Requested-by: Marko Myllynen <myllynen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> > =C2=A0cifs.upcall.8.in | =C2=A0 =C2=A08 +++++++-
> > =C2=A0cifs.upcall.c =C2=A0 =C2=A0| =C2=A0 13 ++++++++++---
> > =C2=A02 files changed, 17 insertions(+), 4 deletions(-)
> >
> > diff --git a/cifs.upcall.8.in b/cifs.upcall.8.in
> > index 0d79a99..3ae0562 100644
> > --- a/cifs.upcall.8.in
> > +++ b/cifs.upcall.8.in
> > @@ -22,7 +22,7 @@
> > =C2=A0cifs.upcall \- Userspace upcall helper for Common Internet Fi=
le System (CIFS)
> > =C2=A0.SH "SYNOPSIS"
> > =C2=A0.HP \w'\ 'u
> > -cifs\&.upcall [\-\-trust\-dns|\-t] [\-\-version|\-v] [\-\-legacy\-=
uid|\-l] {keyid}
> > +cifs\&.upcall [\-\-trust\-dns|\-t] [\-\-version|\-v] [\-\-legacy\-=
uid|\-l] [--krb5conf=3D/path/to/krb5.conf|-k /path/to/...] {keyid}
> > =C2=A0.SH "DESCRIPTION"
> > =C2=A0.PP
> > =C2=A0This tool is part of the cifs-utils suite\&.
> > @@ -38,6 +38,12 @@ for a particular key type\&. While it can be run=
 directly from the command\-line
> > =C2=A0This option is deprecated and is currently ignored\&.
> > =C2=A0.RE
> > =C2=A0.PP
> > +\--krb5conf=3D/path/to/krb5.conf|-k /path/to/krb5.conf
> > +.RS 4
> > +This option allows administrators to set an alternate location for=
 the
> > +krb5.conf file that cifs.upcall will use.
> > +.RE
> > +.PP
> > =C2=A0\-\-trust\-dns|\-t
> > =C2=A0.RS 4
> > =C2=A0With krb5 upcalls, the name used as the host portion of the s=
ervice principal defaults to the hostname portion of the UNC\&. This op=
tion allows the upcall program to reverse resolve the network address o=
f the server in order to get the hostname\&.
> > diff --git a/cifs.upcall.c b/cifs.upcall.c
> > index f560d21..0d222cb 100644
> > --- a/cifs.upcall.c
> > +++ b/cifs.upcall.c
> > @@ -759,12 +759,13 @@ lowercase_string(char *c)
> >
> > =C2=A0static void usage(void)
> > =C2=A0{
> > - =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, "Usage: %s [-t] [-v] [-l] ke=
y_serial\n", prog);
> > + =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, "Usage: %s [-k /path/to/krb5=
=2Econf] [-t] [-v] [-l] key_serial\n", prog);
> > =C2=A0}
> >
> > =C2=A0const struct option long_options[] =3D {
> > - =C2=A0 =C2=A0 =C2=A0 {"trust-dns", 0, NULL, 't'},
> > + =C2=A0 =C2=A0 =C2=A0 {"krb5conf", 1, NULL, 'k'},
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{"legacy-uid", 0, NULL, 'l'},
> > + =C2=A0 =C2=A0 =C2=A0 {"trust-dns", 0, NULL, 't'},
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{"version", 0, NULL, 'v'},
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0{NULL, 0, NULL, 0}
> > =C2=A0};
> > @@ -792,7 +793,7 @@ int main(const int argc, char *const argv[])
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0openlog(prog, 0, LOG_DAEMON);
> >
> > - =C2=A0 =C2=A0 =C2=A0 while ((c =3D getopt_long(argc, argv, "cltv"=
, long_options, NULL)) !=3D -1) {
> > + =C2=A0 =C2=A0 =C2=A0 while ((c =3D getopt_long(argc, argv, "ck:lt=
v", long_options, NULL)) !=3D -1) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (c) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'c':
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* legacy option -- skip it */
> > @@ -800,6 +801,12 @@ int main(const int argc, char *const argv[])
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 't':
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0try_dns++;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'k':
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (setenv("KRB5_CONFIG", optarg, 1) !=3D 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "unable to set $=
KRB5_CONFIG: %d", errno);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'l':
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0legacy_uid++;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
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
> Who does getenv on KRB5_CONFIG?
>=20

The krb5 libraries.

> Also, is the name of the environment variable as KRB5_CONFIG, decided=
?
> It is a common name, perhaps we can change it to something like
> CIFS_KRB5_CONFIG (and mention it in the manpage) to make it
> cifs (upcall) specific?

It's a well-known environment variable that affects what krb5.conf the
krb5 libs will use. What would be the point of changing the name?

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
