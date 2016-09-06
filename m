From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Fix regression which breaks DFS mounting
Date: Tue, 06 Sep 2016 20:29:58 +0200
Message-ID: <mps1t0wswyh.fsf@suse.com>
References: <1473164554-8062-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha1; protocol="application/pgp-signature"
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473164554-8062-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


This is not enough to fix DFS. I believe we also need [1] to handle DFS
links to subdirs.

I have SERVER_A with a DFS link to //SERVER_B/sub/dir.
cifs_are_all_path_accessible() and cifs_get_root() walk along the path
components and do queries on them. But they are not skipping the initial
host + share name on the UNC resulting in failed queries:

  CLIENT_A_____ -> SERVER_B____ SMB Trans2 Request,
      QUERY_PATH_INFO, Query File All Info, Path: //SERVER_B____
  SERVER_B____ -> CLIENT_A_____ SMB Trans2 Response,
      QUERY_PATH_INFO, Error: STATUS_OBJECT_NAME_NOT_FOUND

The QUERY_PATH_INFO request here is using the first path component which
is not a file path but an incomplete UNC path.

That path is made by cifs_build_path_to_root() which only makes a full
UNC path when in a DFS. It is not necessary on the servers I've tested
(cf [1]).

Therefore the fix is to not make a full UNC path in
cifs_build_path_to_root() or to add a flag to its parameters to decide
whether to prefix the host+share or not. I've sent patches for both
solution on the thread [1] (look at all the messages of the thread).

1: http://marc.info/?i=3D20160801143204.7377b5a4@aaptelpc

=2D-=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXzwsnAAoJEDIGO5Hchq/8QjsP+wbTTi4Bpw/h7xRCHAmjw5jx
7A2a6+PXDbhFTU/2RR8KfIz/29iLAcJFgdMCmwi/ZAEfq/lX66PZc2qK5BtxG2ln
aRuQ1/jRwHIDcC/WeBoBE3bCVJcueDcnTj89TIZBbv9VI/DycVS82F1pm7qS/wz5
sI0Hu8nsQnt05Fk8VCoo2Rt/pWzsEK8pYUBh1l+6YclPUk4FVw1CbdNaUrzJrKpA
P0th0LiRRGR2IDkoCrmf7dSVZaot20ewhWo0nEXTdLJ9p1xjM8hw66zLHzJUe65v
cRlCB8GWJPiip5/aZmBIeQKLsJUEv80a6EyoXZ5CG1O0HGqdjqBAFNzq1MjZwANK
CQ8J+CdadgyQITSE+6VT/UyFbD8vRLtnbSqaoiOhaNgOOq9NHKJA1l16I+ZpN+wV
SYYJqV1GWwZf9Q7DprnYVDOLsHZoQqqqGtIRbeBGX0r6BgEX8Gj6ZU50Fectjgtk
LrMtM1wBntmF2UaE9z23fvdnTBTQSxdFtZliec6u3LmdfPkYYwnYpew1CSyvEqSi
LPkcxzlb5n2Pnzo6Dl8CSz7YowVDYn5zv9oAgw1i5F6Hmgv9WdsGdB7QsjxgiyQc
/9WMWggRQQ7UMvGrQSj+i+SKHv8ODU3ycy1cgvggIlglQLiYaQr8CcvyNuK2kGTt
6D6xSYQckF/CmEktSgaB
=J0nj
-----END PGP SIGNATURE-----
--=-=-=--
