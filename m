From: Thomas Hadig <thomas.hadig-O4KOoiensp/QT0dZR+AlfA@public.gmane.org>
Subject: Issue with CIFS mounting of DFS ROOT mount when redirecting from
 one domain controller to the next
Date: Mon, 19 Mar 2012 18:21:28 -0400
Message-ID: <7B8A1CD01838314387266CEE4CEB05600A136B3AD0@EX-002.mail.navisite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I am using the CIFS module from Linux kernel 3.2.9.

We have the following setup:

In DNS,=A0 domain.net resolves to our secondary AD server=A0=A0 ad2.dom=
ain.net
Our primary domain controller is ad1.domain.net and has a DFS redirecti=
on set up from \\ad1\share\Users to \\files\share\Users.=20

When mounting =A0=A0=A0\\domain.net\share\Users=A0 I get an error.

I traced this down to the cifs_mount function in fs/cifs/connect.c. In =
there, rc is set to 0 at the beginning but never reset.
In short, adding an rc=3D0; line after the label try_mount_again: fixes=
 the issue.

Detailed information:
- Connecting to \\domain.net\share\Users =A0connects to ad2 with a SMB_=
COM_NEGOTIATE, SMB_COM_SESSION_SETUP_ANDX, and SMB_COM_TREE_CONNECT_AND=
X.
- SMB_COM_TREE_CONNECT_ANDX fails with STATUS_BAD_NETWORK_NAME causing =
rc to be non-zero and jumping to remote_path_check:
- It connects to ad2's IPC$ share and retrieves the DFS_REFERRAL which =
leads to \\ad1\share and jumps to try_mount_again:
- It closes the samba session to ad2.
- Now, it connects to ad1 with SMB_COM_NEGOTIATE, SMB_COM_SESSION_SETUP=
_ANDX, and SMB_COM_TREE_CONNECT_ANDX.
- This time, it succeeds and continues with SMB_COM_TRANSACTION2/ TRANS=
2_QUERY_FS_INFORMATION/SMB_QUERY_FS_DEVICE_INFO and SMB_QUERY_FS_ATTRIB=
UTE_INFO.
- It comes to:
=A0=A0=A0=A0=A0=A0=A0 /* check if a whole path is not remote */
=A0=A0=A0=A0=A0=A0=A0 if (!rc && tcon) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* build_path_to_root wor=
ks only when we have a valid tcon */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 where rc is still non-zer=
o and, thus, does NOT check again for a DFS_REFERRAL.
- I closes the samba session to ad1 and exists with the -6 mount error =
from the initial tree connect.

The correct behavior would be to reset rc to 0 when connecting to a dif=
ferent samba session.


Patch info:

=A0=A0=A0=A0=A0=A0=A0 rc =3D bdi_setup_and_register(&cifs_sb->bdi, "cif=
s", BDI_CAP_MAP_COPY);
=A0=A0=A0=A0=A0=A0=A0 if (rc)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return rc;

#ifdef CONFIG_CIFS_DFS_UPCALL
try_mount_again:
=A0=A0=A0=A0=A0=A0=A0 /* cleanup activities if we're chasing a referral=
 */
=A0=A0=A0=A0=A0=A0=A0 if (referral_walks_count) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (tcon)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 c=
ifs_put_tcon(tcon);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else if (pSesInfo)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0c=
ifs_put_smb_ses(pSesInfo);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0FreeXid(xid);
=A0=A0=A0=A0=A0=A0=A0 }
#endif
=A0=A0=A0=A0=A0=A0=A0 tcon =3D NULL;
=A0=A0=A0=A0=A0=A0=A0 pSesInfo =3D NULL;
=A0=A0=A0=A0=A0=A0=A0 srvTcp =3D NULL;
=A0=A0=A0=A0=A0=A0=A0 full_path =3D NULL;
=A0=A0=A0=A0=A0=A0=A0 tlink =3D NULL;
+=A0=A0=A0=A0=A0=A0=A0 rc=3D0;

=A0=A0=A0=A0=A0=A0=A0 xid =3D GetXid();

=A0=A0=A0=A0=A0=A0=A0 /* get a reference to a tcp session */
=A0=A0=A0=A0=A0=A0=A0 srvTcp =3D cifs_get_tcp_session(volume_info);
=A0=A0=A0=A0=A0=A0=A0 if (IS_ERR(srvTcp)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D PTR_ERR(srvTcp);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bdi_destroy(&cifs_sb->bdi=
);
=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
=A0=A0=A0=A0=A0=A0=A0 }



Thanks
Thomas
