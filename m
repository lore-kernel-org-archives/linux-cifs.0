From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] libmount: Special handling of root comparison for cifs in mnt_table_is_fs_mounted()
Date: Fri, 02 Sep 2016 20:58:08 +0200
Message-ID: <mpsbn06ruwv.fsf@suse.com>
References: <91d465d3-4f5b-6270-a6c5-38bd94695731@suse.cz> <5eb96b3e-d463-bf11-49de-f614247d6b29@suse.cz> <20160805192234.2c9d5b7d@aaptelpc> <7c2181d1-c7b5-df04-0640-ec23f5d78eab@suse.cz> <c4f10081-4525-4ac0-0e6b-b364c7268200@suse.cz> <eec8f575-eab2-34bb-882a-11fb8c33d9c0@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==-=-=";
        micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: util-linux <util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Stanislav Brabec <sbrabec-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <eec8f575-eab2-34bb-882a-11fb8c33d9c0-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi Stanislav,

I've looked more into it and I found some issues with the patch:

Stanislav Brabec <sbrabec-AlSwsSmVLrQ@public.gmane.org> writes:
> +	while ((c =3D *subpath++))
                      ^^^ subpath is always post-incremented
> +	{
> +		if (c =3D=3D '/') {
> +			if (!last_is_slash) {
> +				component_no++;
> +				if (component_no =3D=3D 3)
> +					break;
                                         ^^^ when we break subpath
                                             actually 1 past the /
> +			}
> +			last_is_slash =3D true;
> +		} else
> +			last_is_slash =3D false;
> +	}
> +	if (component_no =3D=3D 3) {
> +		int subpath_len =3D strlen(subpath);
> +		if (strncmp(root, subpath, subpath_len)) {
                             ^^^  ^^^ hence why here
with //localhost/share/dir in fstab we never get here
p root    =3D> $1 =3D 0x7f28aa9977d0 "/dir"
p subpath =3D> $2 =3D 0x7f28aa9979a2 "dir"

> +			if (*(root + subpath_len + 1) =3D=3D 0)
> +				return "/";
> +			return root + subpath_len + 1;
> +		}
> +	}
> +	DBG(FS, ul_debugobj(fs, "cifs: leading part of root \"%s\" does
> not equal to mounted source subdir \"%s\"; should not happen", root,
> src));
^^^ this message gets printed with //localhost/share //localhost/share/=20

That being said, I could not make your patch fail i.e. make mount -a
mount the fs twice. So I'm not sure what happens there... I thought I
would give it a try.

I'm attaching a simpler patch that makes uses of streq_paths() in
lib/strutils.c (Note: streq_paths() and next_path_segment() have to be
backported for older versions of util-linux).


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=0001-libmount-src-tab.c-fix-mount-a-for-cifs.patch
Content-Transfer-Encoding: quoted-printable

From=20a29acba1a7c71cdbfc1cc98f2905bfaf19b97a29 Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Date: Thu, 1 Sep 2016 13:57:42 +0200
Subject: [PATCH] libmount/src/tab.c: fix mount -a for cifs

when mounting a cifs share, the src is actually an UNC path which can in
in several forms:

simple:            //host/share, //host/share/
including subpath: //host/share/sub/path

to check if the cifs fs is mounted we have to extract the subpath and
compare *that* to the root.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
=2D--
 libmount/src/tab.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/libmount/src/tab.c b/libmount/src/tab.c
index 341e5e3..9c49ec8 100644
=2D-- a/libmount/src/tab.c
+++ b/libmount/src/tab.c
@@ -1329,6 +1329,20 @@ err:
 }
 #endif /* HAVE_BTRFS_SUPPORT */
=20
+static const char *get_cifs_unc_subdir_path (const char *unc)
+{
+	/*
+	 *  1 or more slash:     %*[/]
+	 *  1 or more non-slash: %*[^/]
+	 *  number of byte read: %n
+	 */
+	int share_end =3D 0;
+	int r =3D sscanf(unc, "%*[/]%*[^/]%*[/]%*[^/]%n", &share_end);
+	if (r =3D=3D EOF || share_end =3D=3D 0)
+		return NULL;
+	return unc + share_end;
+}
+
 /*
  * tb: /proc/self/mountinfo
  * fs: filesystem
@@ -1563,9 +1577,16 @@ int mnt_table_is_fs_mounted(struct libmnt_table *tb,=
 struct libmnt_fs *fstab_fs)
 		}
=20
 		if (root) {
=2D			const char *r =3D mnt_fs_get_root(fs);
=2D			if (!r || strcmp(r, root) !=3D 0)
=2D				continue;
+			if (strcmp(mnt_fs_get_fstype(fs), "cifs") =3D=3D 0) {
+				const char *unc_subdir =3D get_cifs_unc_subdir_path(src);
+				const char *path_on_fs =3D mnt_fs_get_root(fs);
+				if (!unc_subdir || !path_on_fs || !streq_paths(unc_subdir, path_on_fs))
+					continue;
+			} else {
+				const char *r =3D mnt_fs_get_root(fs);
+				if (!r || strcmp(r, root) !=3D 0)
+					continue;
+			}
 		}
=20
 		/*
=2D-=20
2.1.4


--=-=-=--

--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXycvDAAoJEDIGO5Hchq/89cIP/iHerZYOHIWbQdYb+4ssBvQ3
jhNamnjJNaOpParnE4vGp13AwOwRrBB9S+CENi1IPF6rrqWirfN/iZH97LmFtHNY
FMXuvCaw9i34nzyRPXT7HqLWKG74m67M+O7uBlPT6kZdNUdzK8CyxUAdLDIZ1hH1
o78yMpmUGXKi5CqSA9nSkhkbSmcj5q2fcEq3g4eG1XkcjWEmcGZLcTlnfgjWl+JN
Kqpbv4nKkKzhknXmLRaIN9iDjkDOWGf1nIzsGilYFPgj5e7pciPXNBGlDgaJoaQQ
TpoNzptv25DQAZIjyxOeaJ22o8wEVJLERzS0KWqwcaxfDXP6kt/PkyOl/YrPgOd7
FEbN6G15Bqo5ejvc79ayO+Q4EWUDtMxyqUO99t2ay8bpkddYn+JZnvi5Pz1IlORB
TPXtnHAiHvVL+RIkD+jWp9oPBvymmKwwYq+cG85nUkEVp4MjpXEFQYYhz8xnQGMu
uxyGmXatpckrvFIc59CS3a0i7LWy+ZHl0iDZW/0JxX1wBsib2s2B3XUyOVG5u3ZU
NiYXrs3qTWgx6Gp5Uf/D/ni1FoerI+aNkNJECJ0oIM7ZxMISeAETRyoG+uvf5lDM
SZHGnqXXfYJzVDiuzEpRCNfJOHzaAk6ZVG6uluiWIKESYoScBzX42Mx0PsJ2gs1s
kZlzMVDjJmn0vKUeOdM/
=PjeF
-----END PGP SIGNATURE-----
--==-=-=--
