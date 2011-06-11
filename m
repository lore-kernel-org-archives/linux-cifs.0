From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [OOPS] 3.0-rc1 cifs
Date: Sat, 11 Jun 2011 07:41:13 -0400
Message-ID: <20110611074113.5a05f919@tlielax.poochiereds.net>
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
	<20110609183045.01f6f9fc@tlielax.poochiereds.net>
	<BANLkTimPqmkNJMaJE2_C5zD8ESFOEM3=hg@mail.gmail.com>
	<Pine.LNX.4.64.1106100243370.2168@sarijopen.student.utwente.nl>
	<20110610073702.061bc014@corrin.poochiereds.net>
	<BANLkTinqT0AXx9STWEzrw-yASTid5rb1Fg@mail.gmail.com>
	<4DF20A97.8010405@suse.de>
	<BANLkTimAauVsqX1JZucG1cg3-MAtqCrZFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
To: Connor Hansen <cmdkhh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimAauVsqX1JZucG1cg3-MAtqCrZFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 10 Jun 2011 05:49:46 -0700
Connor Hansen <cmdkhh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Jun 10, 2011 at 5:14 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org=
> wrote:
> > On 06/10/2011 05:33 PM, Connor Hansen wrote:
> >> On Fri, Jun 10, 2011 at 4:37 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> >>> On Fri, 10 Jun 2011 02:57:21 +0200 (CEST)
> >>> =C2=A0Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org> wrote:
> >>>
> >>>>
> >>>> <snip>
> >>>>> call in get_dfs_path()
> >>>>> rc =3D CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
> >>>>>
> >>>>> function header for CIFSTCon
> >>>>> int =C2=A0CIFSTCon(unsigned int xid, struct cifs_ses *ses,
> >>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *tree, struct cifs=
_tcon *tcon,
> >>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct nls_table *nls_c=
odepage)
> >>>>>
> >>>>> get_dfs_path() is passing struct cifs_tcon *tcon as NULL
> >>>>>
> >>>>> from config: =C2=A0CONFIG_CIFS_WEAK_PW_HASH=3Dy
> >>>>>
> >>>>> in CIFSTCon
> >>>>>
> >>>>> #ifdef CONFIG_CIFS_WEAK_PW_HASH
> >>>>> 3222 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if=
 ((global_secflags & CIFSSEC_MAY_LANMAN) &&
> >>>>> 3223 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 (ses->server->secType =3D=3D LANMAN))
> >>>>> 3224 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 calc_lanman_hash(tcon->password,
> >>>>> ses->server->cryptkey,
> >>>>>
> >>>>> in calc_lanman_hash tcon is dereferenced(tcon->password) withou=
t being
> >>>>> checked if null
> >>>>>
> >>>>> 3225 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ses->server->sec_mode &
> >>>>> 3226 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 SECMODE_PW_ENCRYPT ?
> >>>>> true : false,
> >>>>> 3227 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0bcc_ptr);
> >>>>> 3228 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 el=
se
> >>>>> 3229 #endif /* CIFS_WEAK_PW_HASH */
> >>>>>
> >>>>> Connor
> >>>>
> >>>>
> >>>> Ave all
> >>>>
> >>>> I recompiled =C2=A0kernel 3.0-rc1 (hadn't enabled CONFIG_DEBUG_I=
NFO=3Dy) and put
> >>>> the oops (with the new adresses) through gdb per instruction of =
Jeff. And
> >>>> Connor was spot on!
> >>>>
> >>>> <qoute oops>
> >>>> BUG: unable to handle kernel NULL pointer dereference at 0000000=
0000000a0
> >>>> IP: [<ffffffffa041e286>] CIFSTCon+0xf6/0x4d0 [cifs]
> >>>> </qoute oops>
> >>>>
> >>>> <qoute gdb>
> >>>> This GDB was configured as "x86_64-linux-gnu".
> >>>> For bug reporting instructions, please see:
> >>>> <http://www.gnu.org/software/gdb/bugs/>...
> >>>> Reading symbols from
> >>>> /lib/modules/3.0.0-rc1-debug/kernel/fs/cifs/cifs.ko...done.
> >>>> (gdb) list *(CIFSTCon+0xf6)
> >>>> 0xc2b6 is in CIFSTCon (fs/cifs/connect.c:3230).
> >>>> 3225 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 ses->server->sec_mode &
> >>>> 3226 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SECMODE_PW_ENCRYPT ?
> >>>> true : false,
> >>>> 3227 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 bcc_ptr);
> >>>> 3228 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0else
> >>>> 3229 =C2=A0 =C2=A0#endif /* CIFS_WEAK_PW_HASH */
> >>>> 3230 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0rc =3D SMBNTencrypt(tcon->password,
> >>>> ses->server->cryptkey,
> >>>> 3231 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0bcc_ptr);
> >>>> 3232
> >>>> 3233 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0bcc_ptr +=3D CIFS_AUTH_RESP_SIZE;
> >>>> 3234 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (ses->capabilities & CAP_UNICODE) {
> >>>> (gdb)
> >>>> </qoute gdb>
> >>>>
> >>>
> >>> (cc'ing Sean F. since I suspect this regression is due to his cha=
nges)
> >>>
> >>> Thanks for the analysis, Martijn and Connor...
> >>>
> >>> What sort of server are you mounting here? It looks like it's usi=
ng
> >>> share-level security, so it's either very old or is a samba serve=
r
> >>> configured that way.
> >>>
> >>> I suspect that commit c1508ca236 is the culprit. With that, we ca=
ll
> >>> into expand_dfs_referral on every mount attempt. Previously we on=
ly
> >>> called into there when we got back =C2=A0an EREMOTE error and tha=
t would
> >>> have been unlikely on a share-level security connection.
> >>>
> >>> I think there are several possible solutions, but since Sean was =
in
> >>> here most recently I'd like to have his opinion.
> >>
> >> I don't know enough about cifs but this call in fs/cifs/connect.c
> >>
> >> 2268: rc =3D CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage)=
;
> >>
> >> will always result in a null pointer derefence as CIFSTCon uses th=
e
> >> cifs_tcon struct for passwords without verification
> >
> > Yes, I too was hovering around this code path today and it doesn't =
look
> > correct. Specifically, the call from cifs_dfs_path to CIFSTCon with
> > cifs_tcon as NULL seems wrong. I tried to do dig history a bit with=
 `git
> > blame`, but couldn't figure out the commit that introduced this.
> >
> >
> > --
> > Suresh Jayaraman
> >
>=20
> git annotate fs/cifs/connect.c
> 1da177e4        (Linus Torvalds 2005-04-16 15:20:36 -0700       2268)
>          rc =3D CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage)=
;
>=20
> this was valid at the time to simply get the rc, and the code was che=
cked
>  if ((rc =3D=3D 0) && (tcon !=3D NULL)) {   //  first use of tcon in
> CIFSTCon back then.....
>=20
>=20
> after a loooooong look, i found the patch which changed it
>=20
> 00e485b0
> commit 00e485b0198ea4f509341373f1d9adb0a5977a2f
> Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Fri Dec 5 20:41:21 2008 -0500
>=20
>     cifs: store password in tcon
>=20
>     cifs: store password in tcon
>=20
>     Each tcon has its own password for share-level security. Store it=
 in
>     the tcon and wipe it clean and free it when freeing the tcon. Whe=
n
>     doing the tree connect with share-level security, use the tcon pa=
ssword
>     instead of the session password.
>=20
>     Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>=20

Yep, mea culpa. This patch should fix it. Martin, can you test it?
Anyone else have comments?

Thanks...

-----------------------[snip]--------------------

[PATCH] cifs: correctly handle NULL tcon pointer in CIFSTCon

Long ago (in commit 00e485b0), I added some code to handle share-level
passwords in CIFSTCon. That code ignored the fact that it's legit to
pass in a NULL tcon pointer when connecting to the IPC$ share on the
server.

This wasn't really a problem until recently as we only called CIFSTCon
this way when the server returned -EREMOTE. With the introduction of
commit c1508ca2 however, it gets called this way on every mount, causin=
g
an oops when share-level security is in effect.

=46ix this by simply treating a NULL tcon pointer as if user-level
security were in effect. I'm not aware of any servers that protect the
IPC$ share with a specific password anyway. Also, add a comment to the
top of CIFSTCon to ensure that we don't make the same mistake again.

Reported-by: Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7b6cad2..fa5a5d7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3174,6 +3174,10 @@ out:
 	return rc;
 }
=20
+/*
+ * Issue a TREE_CONNECT request. Note that for IPC$ shares, that the t=
con
+ * pointer may be NULL.
+ */
 int
 CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 	 const char *tree, struct cifs_tcon *tcon,
@@ -3208,7 +3212,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 	pSMB->AndXCommand =3D 0xFF;
 	pSMB->Flags =3D cpu_to_le16(TCON_EXTENDED_SECINFO);
 	bcc_ptr =3D &pSMB->Password[0];
-	if ((ses->server->sec_mode) & SECMODE_USER) {
+	if (!tcon || (ses->server->sec_mode & SECMODE_USER)) {
 		pSMB->PasswordLength =3D cpu_to_le16(1);	/* minimum */
 		*bcc_ptr =3D 0; /* password is null byte */
 		bcc_ptr++;              /* skip password */
--=20
1.7.5.2
