From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: cifs unable to access shares with read restricted at root level
 (bso#8950)
Date: Thu, 29 Oct 2015 11:59:21 +0100
Message-ID: <20151029115921.6e9f7c4b@aaptelpc>
References: <20151026131817.3a8a3ded@aaptelpc>
	<CADT32eJgrjigh_ezCAJK-ivO-t_yygPEhgwoHKsE-8EdVxKP+Q@mail.gmail.com>
	<20151027105905.0644daf2@aaptelpc>
	<CADT32eJrSGmKW4ksKMNKS1KAYDcN8UxLGPLfm8+Ag9mCxkNdYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/zhnsztoCXNmH_d0w4SXHLab"; protocol="application/pgp-signature"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJrSGmKW4ksKMNKS1KAYDcN8UxLGPLfm8+Ag9mCxkNdYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/zhnsztoCXNmH_d0w4SXHLab
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Oops, I forgot to CC my last email to the mailing list; re-sending now.

On Tue, 27 Oct 2015 19:43:46 -0500 Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Oct 27, 2015 at 4:59 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> wrote: =20
> > Hi Shirish,
> >
> > On Mon, 26 Oct 2015 22:04:28 -0500 Shirish Pargaonkar
> > <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote: =20
> >> They are stored in a linked list of struct cifs_rdelem off of
> >> superblock where each element of this linked list points to a
> >> disconnected dentry. =20
> >
> > This list is only used use when we mount with noserverino. It
> > doesn't work in both case anyway. =20
>=20
> No, that is not the case. I have tested this against a Windows 2012
> server and did not mount the shares with noserverino option.
> Since we can query info off of disconnected entires, we fill the
> inodes which get filled with correct inode info as dentires get
> spliced. =20

The only function that adds elements to the rdlist is this one, and it
only does so with noserverino. I believe d_obtain_alias() doesn't store
the full path on the share associated with the disconnected entry it create=
s.
The full path is therefore lost and build_path_from_dentry() fails.

static struct dentry *
create_root_dis_dentry(struct super_block *sb, struct inode *rinode,
			char *fpath)
{
	int rc;
	unsigned int xid;
	struct dentry *dentry =3D NULL;
	struct cifs_rdelem *rdelem =3D NULL;
	struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
	struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);

	printk("create_root_dis_dentry %s, rinode %p\n", fpath, rinode);
=09
	xid =3D get_xid();
	if (tcon->unix_ext)
		rc =3D cifs_get_inode_info_unix(&rinode, fpath, sb, xid);
	else
		rc =3D cifs_get_inode_info(&rinode, fpath, NULL, sb, xid, NULL);
	free_xid(xid);
=09
	if ((rc =3D=3D 0) && (rinode !=3D NULL)) {
		dentry =3D d_obtain_alias(rinode);
		if (IS_ERR(dentry)) {
			iput(rinode);
			goto rdelem_ret;
		}

		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {

			rdelem =3D
				cifs_alloc_rdelem(fpath, dentry, rinode);
			if (IS_ERR(rdelem))
				goto rdelem_ret;
			spin_lock(&cifs_sb->rtdislock);
			list_add(&rdelem->rdlist, &cifs_sb->rtdislist);
			spin_unlock(&cifs_sb->rtdislock);
		}
		return dentry;
	}

rdelem_ret:
	return ERR_PTR(-EACCES);
}

=20
> Sorry, missed looking at the link before. yes, the same setup.
> I could never get right seutp for Samba server. =20

I must be missing something because I cannot make your patch work.
We're using the exact same setup.

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--Sig_/zhnsztoCXNmH_d0w4SXHLab
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJWMfwNAAoJEDIGO5Hchq/8F24P/1jTNWZb0xz4x9lcZpxtqg+/
B0mpV7uD9E+kwxXuf3h5lLgoW3XgDupZ/BcSTAfNSUgoFzVzD1bNLfE6QhLUWLwy
yIIQb7TltGzh3Z4obHUtO6E2opNhgg0GAFd7bsvy3hUCDK6vZsKiFZRbtOo4rQR7
Oegij+OA52CNWxCcFt6JhfPx5Ot+NPNXnMDMhR7e10TCge4kUXkcXVEhmvuq1NNg
NrhPJchtOryfLyikKPwfqphmOO0+J6w1Vx1O2oU1kBEle+1Sztt3B00NQ4bErrV5
ALO76Lngsl3iU46jTpxxETzMA75DxNVsLYtFyHcIjNF77WRpHB9Qlv5aPCEX9CFK
zDTHjq5+2lrrabyDLP7hDUkQJRsDHCr4Gk+jURcpoMa6/k/fAC+Hw24ut7U9cmFo
eT4shR1mNwglgmoX6VheqMwRIXI3Z/WZ5h3UXZjZf7mlANYHwQtDuo4usg9mxOLu
/AlHcazjYltTDXrRB0fYSgO55+8Yy0DLSCwrc0L7HtZ0EQi4K0DMPIz0FSxknu4g
2A+YbXxzfTDeb4pjlCjj4Qgt2GkUkLDqDQsd2G8Q1iCnIWhtvMgmydLmWutWsArC
xSfwMgariCcsMxxgeWK/hHXQeQHU+juEBNUEHrC8vGtduDhpGuG3OLfY6ItjCHyS
C9nluqwnzrNdf7zw75Ss
=IaSe
-----END PGP SIGNATURE-----

--Sig_/zhnsztoCXNmH_d0w4SXHLab--
