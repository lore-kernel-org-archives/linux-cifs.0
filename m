From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Create man pages for cifs.idmap program
Date: Wed, 1 Jun 2011 13:04:29 -0400
Message-ID: <20110601130429.7cb3568d@tlielax.poochiereds.net>
References: <1306453075-30274-1-git-send-email-shirishppargaonkar@gmail.com>
	<20110601085602.7a99a077@tlielax.poochiereds.net>
	<BANLkTinG+5o+DTrD687BCy1zidpu=HXJPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinG+5o+DTrD687BCy1zidpu=HXJPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 1 Jun 2011 11:24:21 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Jun 1, 2011 at 7:56 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Thu, 26 May 2011 18:37:55 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >>
> >> Create man pages for program cifs.idmap
> >> Enable cifs.idmap config option by default.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =C2=A0Makefile.am =C2=A0 =C2=A0 | =C2=A0 =C2=A07 +++++
> >> =C2=A0cifs.idmap.8.in | =C2=A0 79 ++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++
> >> =C2=A0configure.ac =C2=A0 =C2=A0| =C2=A0 =C2=A04 +-
> >> =C2=A03 files changed, 88 insertions(+), 2 deletions(-)
> >> =C2=A0create mode 100644 cifs.idmap.8.in
> >>
> >> diff --git a/Makefile.am b/Makefile.am
> >> index 6046369..9066531 100644
> >> --- a/Makefile.am
> >> +++ b/Makefile.am
> >> @@ -37,4 +37,11 @@ if CONFIG_CIFSIDMAP
> >> =C2=A0sbin_PROGRAMS +=3D cifs.idmap
> >> =C2=A0cifs_idmap_SOURCES =3D cifs.idmap.c
> >> =C2=A0cifs_idmap_LDADD =3D -lkeyutils $(WINB_LDADD)
> >> +man_MANS +=3D cifs.idmap.8
> >> +
> >> +cifs.idmap.8: cifs.idmap.8.in
> >> + =C2=A0 =C2=A0 $(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in=
 > $@-t && mv $@-t $@
> >> +
> >> +clean-local:
> >> + =C2=A0 =C2=A0 rm -f cifs.idmap.8 cifs.idmap.8-t
> >> =C2=A0endif
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^^^^^
> > I don't think you're allowed to have more than clean-local target i=
n
> > the makefile.
>=20
> Fixed it.
>=20
> >
> >> diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
> >> new file mode 100644
> >> index 0000000..9f4680e
> >> --- /dev/null
> >> +++ b/cifs.idmap.8.in
> >> @@ -0,0 +1,79 @@
> >> +'\" t
> >> +.\" =C2=A0 =C2=A0 Title: cifs.idmap
> >> +.\" =C2=A0 =C2=A0Author: [see the "AUTHOR" section]
> >> +.\" Generator: DocBook XSL Stylesheets v1.75.2 <http://docbook.sf=
=2Enet/>
> >> +.\" =C2=A0 =C2=A0 =C2=A0Date: 05/26/2011
> >> +.\" =C2=A0 =C2=A0Manual: System Administration tools
> >> +.\" =C2=A0 =C2=A0Source: cifs-utils 4.0
> >> +.\" =C2=A0Language: English
> >> +.\"
> >> +.TH "CIFS\&.IDMAP" "8" "05/26/2011" "cifs-utils 4\&.0" "System Ad=
ministration tools"
> >> +.\" -------------------------------------------------------------=
----
> >> +.\" * set default formatting
> >> +.\" -------------------------------------------------------------=
----
> >> +.\" disable hyphenation
> >> +.nh
> >> +.\" disable justification (adjust text to left margin only)
> >> +.ad l
> >> +.\" -------------------------------------------------------------=
----
> >> +.\" * MAIN CONTENT STARTS HERE *
> >> +.\" -------------------------------------------------------------=
----
> >> +.SH "NAME"
> >> +cifs.idmap \- Userspace helper for mapping ids for Common Interne=
t File System (CIFS)
> >> +.SH "SYNOPSIS"
> >> +.HP \w'\ 'u
> >> +cifs\&.idmap [\-\-version|\-v] {keyid}
> >> +.SH "DESCRIPTION"
> >> +.PP
> >> +This tool is part of the cifs-utils suite\&.
> >> +.PP
> >> +cifs\&.idmap is a userspace helper program for the linux CIFS cli=
ent filesystem\&. There are a number of activities that the kernel cann=
ot easily do itself\&. This program is a callout program that does thes=
e things for the kernel and then returns the result\&.
> >> +.PP
> >> +cifs\&.idmap is generally intended to be run when the kernel call=
s request\-key(8)
> >> +for a particular key type\&. While it can be run directly from th=
e command\-line, it is not generally intended to be run that way\&.
> >> +.PP
> >> +cifs\&.idmap works in conjuction with winbind facility of Samba s=
uite to map owner and group SIDs to uids and gids respectively. =C2=A0I=
t is best utilized when a mount option of cifsacl is specified when mou=
nting a cifs share, winbind is specified as one of the search entries f=
or passwd and group databases in file /etc/nsswitch.conf, file smb.conf=
 has winbind specific entries, and winbind daemon program is running.
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0^^^^^^^^^^^^^^
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0This is a rather long sentence. Perhaps =
this should be an
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0enumerated or bulleted list of recommend=
ations instead?
> >
>=20
> Working on it.
>=20
> >> It is also strongly recomemended to use mount options of uid and g=
id to specify a default uid and gid to map owner SIDs and group SIDs re=
spectively in case services of winbind facility are unavailable.
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0What happens=
 if I don't do this?
>=20
> If the setup is correct and everything is working (e.g. winbind is ru=
nning),
> the uid and gid of a file on a mapped share would be a winbind-mapped=
uid
> and gid with name at the server (fetched by winbind).  If not, and ui=
d
> and/or gid
> mount options are not specified, the uid and/or gid assgined to a fil=
e on the
> mounted share would be that assigned in cred of the process doing the=
 mount
> of the share?
>=20

Sorry, my point was that this should be documented in the manpage. It
should be very clear as to what happens if those aren't set.

> >
> >> +.SH "OPTIONS"
> >> +.PP
> >> +\-\-version|\-v
> >> +.RS 4
> >> +Print version number and exit\&.
> >> +.RE
> >> +.SH "CONFIGURATION FOR KEYCTL"
> >> +.PP
> >> +cifs\&.idmap is designed to be called from the kernel via the req=
uest\-key callout program\&. This requires that request\-key be told wh=
ere and how to call this program\&. Currently cifs\&.idmap handles a ke=
y type of:
> >> +.PP
> >> +cifs\&.idmap
> >> +.RS 4
> >> +This keytype is for mapping a SID to either an uid or a gid
> >> +.RE
> >> +.PP
> >> +To make this program useful for CIFS, you will need to set up ent=
ry for it in request\-key\&.conf(5)\&. Here is an example of an entry f=
or this key type:
> >> +.sp
> >> +.if n \{\
> >> +.RS 4
> >> +.\}
> >> +.nf
> >> +#OPERATION =C2=A0TYPE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 D C PROG=
RAM ARG1 ARG2\&.\&.\&.
> >> +#=3D=3D=3D=3D=3D=3D=3D=3D=3D =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D =C2=A0=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +create =C2=A0 =C2=A0 =C2=A0cifs\&.idmap =C2=A0 =C2=A0* * @sbindir=
@/cifs\&.idmap %k
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^^^^
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0nit: alignment of the columns is off
> >> +.fi
> >> +.if n \{\
> >> +.RE
> >> +.\}
> >> +.PP
> >> +See
> >> +\fBrequest-key.conf5\fR()
> >> +for more info on each field\&.
> >> +.SH "SEE ALSO"
> >> +.PP
> >> +
> >> +\fBrequest-key.conf\fR(5),
> >> +\fBmount.cifs\fR(8)
> >> +.SH "AUTHOR"
> >> +.PP
> >> +Shirish Pargaonkar wrote the cifs\&.idmap program\&.
> >> +.PP
> >> +The
> >> +Linux CIFS Mailing list
> >> +is the preferred place to ask questions regarding these programs\=
&.
> >> diff --git a/configure.ac b/configure.ac
> >> index 6cac703..d7e21c9 100644
> >> --- a/configure.ac
> >> +++ b/configure.ac
> >> @@ -26,7 +26,7 @@ AC_ARG_ENABLE(cifsidmap,
> >> =C2=A0 =C2=A0 =C2=A0 [AC_HELP_STRING([--enable-cifsidmap],
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [Create cifs.idmap binary @<:@default=3Dno@:>@])],
> >> =C2=A0 =C2=A0 =C2=A0 enable_cifsidmap=3D$enableval,
> >> - =C2=A0 =C2=A0 enable_cifsidmap=3D"no")
> >> + =C2=A0 =C2=A0 enable_cifsidmap=3D"maybe")
> >>
> >> =C2=A0# Checks for programs.
> >> =C2=A0AC_PROG_CC
> >> @@ -152,7 +152,7 @@ LIBS=3D$cu_saved_libs
> >>
> >> =C2=A0AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall"=
 !=3D "no"])
> >> =C2=A0AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" =3D=
 "yes"])
> >> -AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" =3D "y=
es"])
> >> +AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" !=3D "=
no"])
> >>
> >> =C2=A0LIBCAP_NG_PATH
> >>
> >
> > I think you need a bit more in configure.ac to build this by defaul=
t.
>=20
> Right now I can build cifs.idmap without any cifs-idmap related optio=
ns
> to configure. Not sure what is missing.
>=20
>=20
> > You'll also need to fix the check for keyutils.h when $enable_cifsi=
dmap
> > =3D "maybe"
>=20
> I think I was missing else clause, right?

Yes. If keyutils.h isn't present now, then configure with no options
will error out rather than just disabling the cifs.idmap build.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
