From: "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [PATCH v2 0/5] cifs-utils: plugin interface for SID to UID/GID
	mapping
Date: Tue, 18 Dec 2012 15:45:17 +0100
Message-ID: <50D0817D.5040508@samba.org>
References: <1355839848-24118-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig9715756DAE9E21DB7F66A251"
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1355839848-24118-1-git-send-email-jlayton@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9715756DAE9E21DB7F66A251
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

I didn't look at the whole patchset in detail, but I think
such a new API should support IDMAP_BOTH, which means that
a sid can resolve into a uid and a gid at the same time.

This is very important as it allows groups to own files
e.g. BUILTIN\Administrators is likely to be the owner of a lot
of files. And it's the only way to support the 'sIDHistory' for users.

metze

> This is the second official posting for the plugin interface. Major
> changes since the last set are:
>=20
> 1/ There's a header file now that plugin implementers are expected to u=
se
>=20
> 2/ New manpage for idmapwb.so and cleanups to the existing manpages to
>    discuss plugin configuration
>=20
> 3/ Better handling for the plugin_errmsg variable. A pointer to the
>    pointer is passed into the init_plugin routine, which allows the
>    setting of it in the context.
>=20
> With this, I think I'm pretty close to something mergeable, but
> comments and review are still appreciated.
>=20
> Jeff Layton (5):
>   cifs-utils: struct cifs_sid definition to new cifsidmap.h header
>   cifs-utils: new plugin architecture for ID mapping code
>   cifs-utils: convert setcifsacl to use the plugin interface
>   cifs-utils: convert cifs.idmap to use plugin interface
>   cifs-utils: add a manpage for idmapwb
>=20
>  Makefile.am                     |  37 ++++--
>  cifs.idmap.8.in                 |  22 ++--
>  cifs.idmap.c                    |  93 +++++++--------
>  cifsacl.h                       |  12 +-
>  cifsidmap.h                     | 161 ++++++++++++++++++++++++++
>  configure.ac                    |  10 ++
>  getcifsacl.1 =3D> getcifsacl.1.in |   5 +-
>  getcifsacl.c                    |  98 +++++++---------
>  idmap_plugin.c                  | 160 ++++++++++++++++++++++++++
>  idmap_plugin.h                  |  61 ++++++++++
>  idmapwb.8.in                    | 148 ++++++++++++++++++++++++
>  idmapwb.c                       | 242 ++++++++++++++++++++++++++++++++=
++++++++
>  idmapwb.pod                     |  26 +++++
>  setcifsacl.1 =3D> setcifsacl.1.in |   6 +-
>  setcifsacl.c                    |  70 +++---------
>  15 files changed, 952 insertions(+), 199 deletions(-)
>  create mode 100644 cifsidmap.h
>  rename getcifsacl.1 =3D> getcifsacl.1.in (87%)
>  create mode 100644 idmap_plugin.c
>  create mode 100644 idmap_plugin.h
>  create mode 100644 idmapwb.8.in
>  create mode 100644 idmapwb.c
>  create mode 100644 idmapwb.pod
>  rename setcifsacl.1 =3D> setcifsacl.1.in (91%)
>=20


--------------enig9715756DAE9E21DB7F66A251
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlDQgYEACgkQm70gjA5TCD8bkQCgn4Xg1J7cFUlxaHBvoukxP4M9
kD4AoIq0FBuOeSB3ztMIUF4ski/iWVNy
=Z5e2
-----END PGP SIGNATURE-----

--------------enig9715756DAE9E21DB7F66A251--
