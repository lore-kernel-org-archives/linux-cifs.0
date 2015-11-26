From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v1] cifs: make shares unaccessible at root level
 mountable
Date: Thu, 26 Nov 2015 14:09:15 +0100
Message-ID: <20151126140915.11349031@aaptelpc>
References: <20151105154836.1851c30c@aaptelpc>
	<CADT32eJ_uLj4_sEhWc+O=xjOMMfNhGGH9XhiJmdDQyrL6Dzp3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/GNaNxdfCrQofjsNbmxuuQHA"; protocol="application/pgp-signature"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJ_uLj4_sEhWc+O=xjOMMfNhGGH9XhiJmdDQyrL6Dzp3A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/GNaNxdfCrQofjsNbmxuuQHA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Nov 2015 23:20:09 -0600 Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I do not understand why you need to entertain error ENOENT on an
> intermediate path.

In cifs_get_root() @ fs/cifs/cifsfs.c when one of the intermediary path
component access is restricted I get a NULL direntry->d_inode. Which is
translated to ENOENT.

		struct inode *dir =3D d_inode(dentry);
		struct dentry *child;

		if (!dir) {
			dput(dentry);
			dentry =3D ERR_PTR(-ENOENT);
			break;
		}


> I still do not understand why noserverino is in picture. Only the
> disconnected root dentry
> has an inode generated with an id by the cifs client.  Once this
> disconnected root denty
> gets spliced, the inode is filled with correct inode (fileid)
> available from the server
> (since that intermediate path is now accessible hence splicable).
> You have fileid/inode available for all eligible/accessible file
> objects under the disconnected
> root entry.

Again, the only function that adds disconneted roots
to the linked list in the superblock is cifs_alloc_rdelem() which is
*only called* with noserverino. This is from your patch.

% grep -R cifs_alloc_rdelem fs/cifs/*.c
fs/cifs/cifsfs.c-}
fs/cifs/cifsfs.c-
fs/cifs/cifsfs.c-struct cifs_rdelem *
fs/cifs/cifsfs.c:cifs_alloc_rdelem(char *full_path, struct dentry *rdentry,
fs/cifs/cifsfs.c-                               struct inode *rdinode)
fs/cifs/cifsfs.c-{
fs/cifs/cifsfs.c-       struct cifs_rdelem *rdelem;
--
fs/cifs/cifsfs.c-               if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_=
SERVER_INUM)) {
fs/cifs/cifsfs.c-
fs/cifs/cifsfs.c-                       rdelem =3D
fs/cifs/cifsfs.c:                               cifs_alloc_rdelem(fpath, de=
ntry, rinode);
fs/cifs/cifsfs.c-                       if (IS_ERR(rdelem))
fs/cifs/cifsfs.c-                               goto rdelem_ret;
fs/cifs/cifsfs.c-                       spin_lock(&cifs_sb->rtdislock);

To properly build a path from a child dentry of a disconnected root you nee=
d to know the path of the disconnected root and use it as a prefix. This pr=
efix is only stored in the rdelem struct which is only used with noserverin=
o. See above.

My patch was able to fix several SUSE customers problems and people contact=
ed me off-list to tell me it also fixed his problem. I cannot reproduce the=
 issue you're describing.

We can talk on irc if you want, I'm aaptel on freenode.

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--Sig_/GNaNxdfCrQofjsNbmxuuQHA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJWVwR8AAoJEDIGO5Hchq/8NcYP/0qgiNtNV7lgne3QvCBuj46T
85qU7f3laBhoe9PBx4abanUWUgoL1WAQodLXryfKTKqQWRww7+cD7MTCbszTIQiv
5EZLNOWAo1DuRqMG7OyC1Kp+DqpUytlvI/8+KPc8Lb94lRXsu+lr5/EeCE5iT7FY
QgmSD6pDRSrqzt7BN7d73FMIQsEawi9qwuo1B5J4pTfu53ErMNnUhBjrAVujgIta
dCS0uA2nL0gNr9k7gLB/zdfCzx1tV6n+8Cfi2pigy9ejAOsQn23uqqBwaM7ZYk1r
StPa/ZzOw0+4iqak6ZVnFb1aB2yCQ/6W+qMAcxc6pTIuAE0/7yrGRym4zaiP96EO
wG73vsGPLK+izKRrfyMOsV2eWMUx7/2wlG80b6AE/Lby+qVRfw0lWu/cpe1oPXo0
8u8BilJJvqSvRZbTsbY9dBEXzkI0HuyppkS1vxuIxh8eblmSdX0vQRki5okZDrXZ
VKsysS9r05jfyO6e9e3014ZvOvzs3l/Vlwhs/6l4WR2KGVeEhO4TGpdyWyGSBiEu
ptrUlvJS6xHEJD3Fy9EeGJXFNBCNeYYmWAVuoLs0QmrI8OMy3tjWZ/hMfDKZ3U60
omIXd7FcrkQ6wmoF5El+GtzQ38uqJsDhKijvg8p/pUl0zNNnpyZpI0nlyUayHlZf
wlqkflORHcwp7busefi6
=KWJY
-----END PGP SIGNATURE-----

--Sig_/GNaNxdfCrQofjsNbmxuuQHA--
