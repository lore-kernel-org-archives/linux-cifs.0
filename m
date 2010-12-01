From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: replace some hardcoded values with preprocessor
 constants
Date: Wed, 1 Dec 2010 10:07:48 -0500
Message-ID: <20101201100748.507bd4ce@tlielax.poochiereds.net>
References: <20101201092731.7aeded31@tlielax.poochiereds.net>
	<1291214985-31607-1-git-send-email-jlayton@redhat.com>
	<AANLkTi=ntwuoeEoBk5RfEFbu_3M4EaRu=wSqAhR1RcEc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=ntwuoeEoBk5RfEFbu_3M4EaRu=wSqAhR1RcEc-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 1 Dec 2010 09:03:32 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Dec 1, 2010 at 8:49 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > A number of places that deal with RFC1001/1002 negotiations have ba=
re
> > "15" or "16" values. Replace them with RFC_1001_NAME_LEN and
> > RFC_1001_NAME_LEN_WITH_NULL.
> >
> > The patch also cleans up some checkpatch warnings for code surround=
ing
> > the changes. This should apply cleanly on top of the patch to remov=
e
> > Local_System_Name.
> >
> > Reported-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =A0fs/cifs/connect.c | =A0 37 +++++++++++++++++++------------------
> > =A01 files changed, 19 insertions(+), 18 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 5d48e09..a96324b 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -64,8 +64,8 @@ struct smb_vol {
> > =A0 =A0 =A0 =A0char *UNC;
> > =A0 =A0 =A0 =A0char *UNCip;
> > =A0 =A0 =A0 =A0char *iocharset; =A0/* local code page for mapping t=
o and from Unicode */
> > - =A0 =A0 =A0 char source_rfc1001_name[16]; /* netbios name of clie=
nt */
> > - =A0 =A0 =A0 char target_rfc1001_name[16]; /* netbios name of serv=
er for Win9x/ME */
> > + =A0 =A0 =A0 char source_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL];=
 /* clnt nb name */
> > + =A0 =A0 =A0 char target_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL];=
 /* srvr nb name */
> > =A0 =A0 =A0 =A0uid_t cred_uid;
> > =A0 =A0 =A0 =A0uid_t linux_uid;
> > =A0 =A0 =A0 =A0gid_t linux_gid;
> > @@ -816,11 +816,11 @@ cifs_parse_mount_options(char *options, const=
 char *devname,
> > =A0 =A0 =A0 =A0 * informational, only used for servers that do not =
support
> > =A0 =A0 =A0 =A0 * port 445 and it can be overridden at mount time
> > =A0 =A0 =A0 =A0 */
> > - =A0 =A0 =A0 memset(vol->source_rfc1001_name, 0x20, 15);
> > - =A0 =A0 =A0 for (i =3D 0; i < strnlen(nodename, 15); i++)
> > + =A0 =A0 =A0 memset(vol->source_rfc1001_name, 0x20, RFC1001_NAME_L=
EN);
> > + =A0 =A0 =A0 for (i =3D 0; i < strnlen(nodename, RFC1001_NAME_LEN)=
; i++)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->source_rfc1001_name[i] =3D toup=
per(nodename[i]);
> >
> > - =A0 =A0 =A0 vol->source_rfc1001_name[15] =3D 0;
> > + =A0 =A0 =A0 vol->source_rfc1001_name[RFC1001_NAME_LEN] =3D 0;
> > =A0 =A0 =A0 =A0/* null target name indicates to use *SMBSERVR defau=
lt called name
> > =A0 =A0 =A0 =A0 =A0 if we end up sending RFC1001 session initialize=
 */
> > =A0 =A0 =A0 =A0vol->target_rfc1001_name[0] =3D 0;
> > @@ -1165,22 +1165,22 @@ cifs_parse_mount_options(char *options, con=
st char *devname,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!value || !*valu=
e || (*value =3D=3D ' ')) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI=
(1, "invalid (empty) netbiosname");
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memse=
t(vol->source_rfc1001_name, 0x20, 15);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (=
i =3D 0; i < 15; i++) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB=
 are there cases in which a comma can be
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 valid=
 in this workstation netbios name (and need
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 speci=
al handling)? */
> > -
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We=
 do not uppercase netbiosname for user */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memse=
t(vol->source_rfc1001_name, 0x20,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 RFC1001_NAME_LEN);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =
=46IXME: are there cases in which a comma can
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =
be valid in workstation netbios name (and
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =
need special handling)?
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (=
i =3D 0; i < RFC1001_NAME_LEN; i++) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 /* don't ucase netbiosname for user */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0if (value[i] =3D=3D 0)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 else
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 vol->source_rfc1001_name[i] =3D
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 value[i];
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 vol->source_rfc1001_name[i] =3D value[i];
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* T=
he string has 16th byte zero still from
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set =
at top of the function =A0*/
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((=
i =3D=3D 15) && (value[i] !=3D 0))
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i=
 =3D=3D RFC1001_NAME_LEN && value[i] !=3D 0)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0printk(KERN_WARNING "CIFS: netbiosname"
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0" longer than 15 truncated.\n");
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > @@ -1190,7 +1190,8 @@ cifs_parse_mount_options(char *options, const=
 char *devname,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI=
(1, "empty server netbiosname specified");
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* l=
ast byte, type, is 0x20 for servr type */
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memse=
t(vol->target_rfc1001_name, 0x20, 16);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memse=
t(vol->target_rfc1001_name, 0x20,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 RFC1001_NAME_LEN_WITH_NULL);
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for =
(i =3D 0; i < 15; i++) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* B=
B are there cases in which a comma can be
> > @@ -1207,7 +1208,7 @@ cifs_parse_mount_options(char *options, const=
 char *devname,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* T=
he string has 16th byte zero still from
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 set at top of the function =A0*/
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((=
i =3D=3D 15) && (value[i] !=3D 0))
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i=
 =3D=3D RFC1001_NAME_LEN && value[i] !=3D 0)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0printk(KERN_WARNING "CIFS: server net"
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0"biosname longer than 15 truncated.\n");
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > --
> > 1.7.3.2
> >
> >
>=20
> Jeff, I do not see where RFC1001_NAME_LEN_WITH_NULL and RFC1000_NAME_=
LEN
> are defined.

In cifsglob.h...

There's a tool for this sort of thing called "cscope":

    http://cscope.sourceforge.net/

Cheers,
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
