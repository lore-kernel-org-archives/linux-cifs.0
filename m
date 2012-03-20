From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Issue with CIFS mounting of DFS ROOT mount when redirecting
 from one domain controller to the next
Date: Tue, 20 Mar 2012 06:43:38 -0400
Message-ID: <20120320064338.0632ee61@tlielax.poochiereds.net>
References: <7B8A1CD01838314387266CEE4CEB05600A136B3AD0@EX-002.mail.navisite.com>
	<20120320063826.78a89b3d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Thomas Hadig <thomas.hadig-O4KOoiensp/QT0dZR+AlfA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120320063826.78a89b3d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 20 Mar 2012 06:38:26 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, 19 Mar 2012 18:21:28 -0400
> Thomas Hadig <thomas.hadig-O4KOoiensp/QT0dZR+AlfA@public.gmane.org> wrote:
>=20
> > Hi,
> >=20
> > I am using the CIFS module from Linux kernel 3.2.9.
> >=20
> > We have the following setup:
> >=20
> > In DNS,=C2=A0 domain.net resolves to our secondary AD server=C2=A0=C2=
=A0 ad2.domain.net
> > Our primary domain controller is ad1.domain.net and has a DFS redir=
ection set up from \\ad1\share\Users to \\files\share\Users.=20
> >=20
> > When mounting =C2=A0=C2=A0=C2=A0\\domain.net\share\Users=C2=A0 I ge=
t an error.
> >=20
> > I traced this down to the cifs_mount function in fs/cifs/connect.c.=
 In there, rc is set to 0 at the beginning but never reset.
> > In short, adding an rc=3D0; line after the label try_mount_again: f=
ixes the issue.
> >=20
> > Detailed information:
> > - Connecting to \\domain.net\share\Users =C2=A0connects to ad2 with=
 a SMB_COM_NEGOTIATE, SMB_COM_SESSION_SETUP_ANDX, and SMB_COM_TREE_CONN=
ECT_ANDX.
> > - SMB_COM_TREE_CONNECT_ANDX fails with STATUS_BAD_NETWORK_NAME caus=
ing rc to be non-zero and jumping to remote_path_check:
> > - It connects to ad2's IPC$ share and retrieves the DFS_REFERRAL wh=
ich leads to \\ad1\share and jumps to try_mount_again:
> > - It closes the samba session to ad2.
> > - Now, it connects to ad1 with SMB_COM_NEGOTIATE, SMB_COM_SESSION_S=
ETUP_ANDX, and SMB_COM_TREE_CONNECT_ANDX.
> > - This time, it succeeds and continues with SMB_COM_TRANSACTION2/ T=
RANS2_QUERY_FS_INFORMATION/SMB_QUERY_FS_DEVICE_INFO and SMB_QUERY_FS_AT=
TRIBUTE_INFO.
> > - It comes to:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* check if a whole path=
 is not remote */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!rc && tcon) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 /* build_path_to_root works only when we have a v=
alid tcon */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 where rc is still non-zero and, thus, does NOT ch=
eck again for a DFS_REFERRAL.
> > - I closes the samba session to ad1 and exists with the -6 mount er=
ror from the initial tree connect.
> >=20
> > The correct behavior would be to reset rc to 0 when connecting to a=
 different samba session.
> >=20
> >=20
> > Patch info:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D bdi_setup_and_reg=
ister(&cifs_sb->bdi, "cifs", BDI_CAP_MAP_COPY);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rc)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return rc;
> >=20
> > #ifdef CONFIG_CIFS_DFS_UPCALL
> > try_mount_again:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* cleanup activities if=
 we're chasing a referral */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (referral_walks_count=
) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 if (tcon)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c=
ifs_put_tcon(tcon);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 else if (pSesInfo)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0c=
ifs_put_smb_ses(pSesInfo);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0FreeXid(xid);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > #endif
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tcon =3D NULL;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pSesInfo =3D NULL;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 srvTcp =3D NULL;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 full_path =3D NULL;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tlink =3D NULL;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc=3D0;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xid =3D GetXid();
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* get a reference to a =
tcp session */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 srvTcp =3D cifs_get_tcp_=
session(volume_info);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(srvTcp)) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 rc =3D PTR_ERR(srvTcp);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 bdi_destroy(&cifs_sb->bdi);
> > =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto out;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >=20
> >=20
> >=20
> > Thanks
> > Thomas
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> Nice analysis. That looks correct to me too...
>=20
> Care to spin up a patch with a description and signed-off-by line? Yo=
u
> can add my Reviewed-by if so...
>=20

=46WIW, this looks like a regression that was introduced in commit
724d9f1c. That patch should be appropriate for stable as well. When you
add that line, you should also be able to get rid of the initialization
of rc in the declaration too.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
