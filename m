Return-Path: <SRS0=IbS0=V6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405D4C433FF
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Aug 2019 00:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07FEE2083B
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Aug 2019 00:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="XJobggZ5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388459AbfHBAiI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Aug 2019 20:38:08 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39839 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfHBAiI (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 1 Aug 2019 20:38:08 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4607YS10mXz9sBF;
        Fri,  2 Aug 2019 10:38:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1564706284;
        bh=JIiX2SDsIiJ0ZidVaj3bi2N9QTRTYubHyhF24hu4qDc=;
        h=Date:From:To:Cc:Subject:From;
        b=XJobggZ5lPRTbEk+Pex4FGyV/H8rBEhVkjJG23NPqb41L35Hmwh6eBhxGqaMiVM5J
         0aHoshn3CEybX0LqWyg/ogQJWoJnNRSjhwDwqMvu4W2TZ0UVcINKwRCxb2sbRU5a82
         Z8KSqafgQRTE7OcJx4VRhvGAluY5MDZjAGjuv/FgkZPf1svvxMC3QRBpgy6hxBluLy
         KVm+nj7q/9+mLkpKmjw2xPrcdG/YSlEjv7MBwWuPHjEIJlmdm7FaJp2RMn82GLcD1i
         JCuov68fsaFxmBLnuPfUH+e5U4fDq4648J8MBLo7tt2fX4XsdHFdnV+iY4EG+wlQHB
         3H+Sgm1wiszSg==
Date:   Fri, 2 Aug 2019 10:38:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jonathan Corbet <corbet@lwn.net>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: linux-next: manual merge of the jc_docs tree with the cifs tree
Message-ID: <20190802103803.7dfb5659@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+_A.jVrzZnM3rsLwx//nrgT";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/+_A.jVrzZnM3rsLwx//nrgT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the jc_docs tree got a conflict in:

  Documentation/admin-guide/cifs/todo.rst

between commit:

  46c8a6b4c39e ("smb3: update TODO list of missing features")

from the cifs tree and commit:

  f139291c7130 ("docs: fs: cifs: convert to ReST and add to admin-guide boo=
k")

from the jc_docs tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc Documentation/admin-guide/cifs/todo.rst
index edbbccda1942,95f18e8c9b8a..000000000000
--- a/Documentation/admin-guide/cifs/todo.rst
+++ b/Documentation/admin-guide/cifs/todo.rst
@@@ -13,52 -18,49 +18,52 @@@ a) SMB3 (and SMB3.1.1) missing optiona
     - T10 copy offload ie "ODX" (copy chunk, and "Duplicate Extents" ioctl
       currently the only two server side copy mechanisms supported)
 =20
 -b) improved sparse file support
 +b) improved sparse file support (fiemap and SEEK_HOLE are implemented
- but additional features would be supportable by the protocol).
++   but additional features would be supportable by the protocol).
 =20
  c) Directory entry caching relies on a 1 second timer, rather than
- using Directory Leases, currently only the root file handle is cached lon=
ger
+    using Directory Leases, currently only the root file handle is cached =
longer
 =20
  d) quota support (needs minor kernel change since quota calls
- to make it to network filesystems or deviceless filesystems)
+    to make it to network filesystems or deviceless filesystems)
 =20
 -e) Additional use cases where we use "compoounding" (e.g. open/query/close
 -   and open/setinfo/close) to reduce the number of roundtrips, and also
 -   open to reduce redundant opens (using deferred close and reference cou=
nts
 -   more).
 +e) Additional use cases can be optimized to use "compounding"
- (e.g. open/query/close and open/setinfo/close) to reduce the number
- of roundtrips to the server and improve performance. Various cases
- (stat, statfs, create, unlink, mkdir) already have been improved by
- using compounding but more can be done.  In addition we could significant=
ly
- reduce redundant opens by using deferred close (with handle caching lease=
s)
- and better using reference counters on file handles.
++   (e.g. open/query/close and open/setinfo/close) to reduce the number
++   of roundtrips to the server and improve performance. Various cases
++   (stat, statfs, create, unlink, mkdir) already have been improved by
++   using compounding but more can be done.  In addition we could signific=
antly
++   reduce redundant opens by using deferred close (with handle caching le=
ases)
++   and better using reference counters on file handles.
 =20
  f) Finish inotify support so kde and gnome file list windows
- will autorefresh (partially complete by Asser). Needs minor kernel
- vfs change to support removing D_NOTIFY on a file.  =20
+    will autorefresh (partially complete by Asser). Needs minor kernel
+    vfs change to support removing D_NOTIFY on a file.
 =20
  g) Add GUI tool to configure /proc/fs/cifs settings and for display of
- the CIFS statistics (started)
+    the CIFS statistics (started)
 =20
  h) implement support for security and trusted categories of xattrs
- (requires minor protocol extension) to enable better support for SELINUX
+    (requires minor protocol extension) to enable better support for SELIN=
UX
 =20
  i) Add support for tree connect contexts (see MS-SMB2) a new SMB3.1.1 pro=
tocol
     feature (may be especially useful for virtualization).
 =20
  j) Create UID mapping facility so server UIDs can be mapped on a per
- mount or a per server basis to client UIDs or nobody if no mapping
- exists. Also better integration with winbind for resolving SID owners
+    mount or a per server basis to client UIDs or nobody if no mapping
+    exists. Also better integration with winbind for resolving SID owners
 =20
  k) Add tools to take advantage of more smb3 specific ioctls and features
- (passthrough ioctl/fsctl is now implemented in cifs.ko to allow sending
- various SMB3 fsctls and query info and set info calls directly from user =
space)
- Add tools to make setting various non-POSIX metadata attributes easier
- from tools (e.g. extending what was done in smb-info tool).
 -   (passthrough ioctl/fsctl for sending various SMB3 fsctls to the server
 -   is in progress, and a passthrough query_info call is already implement=
ed
 -   in cifs.ko to allow smb3 info levels queries to be sent from userspace)
++   (passthrough ioctl/fsctl is now implemented in cifs.ko to allow sending
++   various SMB3 fsctls and query info and set info calls directly from us=
er space)
++   Add tools to make setting various non-POSIX metadata attributes easier
++   from tools (e.g. extending what was done in smb-info tool).
 =20
  l) encrypted file support
 =20
  m) improved stats gathering tools (perhaps integration with nfsometer?)
- to extend and make easier to use what is currently in /proc/fs/cifs/Stats
+    to extend and make easier to use what is currently in /proc/fs/cifs/St=
ats
 =20
 -n) allow setting more NTFS/SMB3 file attributes remotely (currently limit=
ed to
 -   compressed file attribute via chflags) and improve user space tools for
 -   managing and viewing them.
 +n) Add support for claims based ACLs ("DAC")
 =20
  o) mount helper GUI (to simplify the various configuration options on mou=
nt)
 =20
@@@ -74,22 -76,21 +79,23 @@@ q) Allow mount.cifs to be more verbose=20
  r) updating cifs documentation, and user guide.
 =20
  s) Addressing bugs found by running a broader set of xfstests in standard
- file system xfstest suite.
+    file system xfstest suite.
 =20
  t) split cifs and smb3 support into separate modules so legacy (and less
- secure) CIFS dialect can be disabled in environments that don't need it
- and simplify the code.
+    secure) CIFS dialect can be disabled in environments that don't need it
+    and simplify the code.
 =20
  v) POSIX Extensions for SMB3.1.1 (started, create and mkdir support added
- so far).
+    so far).
 =20
  w) Add support for additional strong encryption types, and additional spn=
ego
- authentication mechanisms (see MS-SMB2)
+    authentication mechanisms (see MS-SMB2)
 =20
 +x) Finish support for SMB3.1.1 compression
 +
- KNOWN BUGS
- =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+ Known Bugs
+ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+=20
  See http://bugzilla.samba.org - search on product "CifsVFS" for
  current bug list.  Also check http://bugzilla.kernel.org (Product =3D Fil=
e System, Component =3D CIFS)
 =20

--Sig_/+_A.jVrzZnM3rsLwx//nrgT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1DhesACgkQAVBC80lX
0Gw0xgf9EmEuxYIBGt1ORw1qJU1oenxQ3ydDPgwtkvgM2Jb+U/m9LnxYsKgkS4lF
mfmzFa9gTGnSmxkRrilqV3/+EwYvbSTKpAkvyxccbXJa0tYMghGm3V6v3rihNXWb
bZduT1gpuToV5tOMy9tsQ6RCeHsaq5nqdtacjHKDltC69IAx3WMvzUoMcUB9yyqQ
WsHwN/LoFJ+Q2g7VDCYn7T8ablJ3ycFaXB14354UYRgKUGw20oU/F89KYI9oXb2W
3fWIER5x6dVtmFjP6JLuDslGN7NDoHwoNQVRMT9K7p9fiCL1cF3ZvOMtKkNaVlYH
iyQJk4MSO4Wei/qnRIk79Mjgq9OpZQ==
=/sns
-----END PGP SIGNATURE-----

--Sig_/+_A.jVrzZnM3rsLwx//nrgT--
