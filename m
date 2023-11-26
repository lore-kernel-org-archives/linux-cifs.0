Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ggQMZmFz"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE361AF
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 18:55:31 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bMgFyOLkyfb80xl55nfRJhZVsQqxdeL7O63vXgfou00=;
	b=ggQMZmFzKnsgVJR2EsEBsSlO4ig69OZHWtKZnmSWFHtGMVuYObvw6twAFJdEHZ2R3TvMdq
	KXTDnZdYW1CyDYgiD8oTfCW0R14QHcFzQkQIsNtlhWUW851obJezVjl8TZL0z1qu9Enujb
	tq+CPsulLRb5Xz0GthjXsW3DT0doeT6RBu92DP0t/UIIl3JKN1G2EDdYpa32NLGztPylex
	EszrY4i4s9kWIVOV+Ru/ldKCp7YZcloUS1bWzLGysGScaUDScDlyyX0dJkzLjiVY8MFqWE
	MOvgeuTtAr1EHhbBTfFpIxJ3uAXdvZ01eW9B/RQ7DpHlXUgL/Ob1TErLrDGwdQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700967330; a=rsa-sha256;
	cv=none;
	b=COqp3OapEeyVU2FixPaAkFI+kJFIhKYT7SHkVR2WCLlDa8uh8pBggZr33lHWQoZCXtlFpq
	l6BYxz8nvVFgAQQpYmGf9EBz6dLvZRlOyIJx0bcjffX15FIOhepMOlfj+mk84B7giy6CT0
	J+EyAgyC0SiEY1g5T04Ia8L9POzbl90bTS3TrwZGXI1RApzRl3prKiivHvmKbMfRlU07M/
	GZqve6UcEuS2tlC78BELP2ptZLBEo/YHAdcGJDPFm343M5+e5T0bN7WlaKlD00Wjw+ueb5
	BLAP+3LW0LkgKUacSkDsBkw7fSoc+1wO+eKVLrtVysFWF0I8qmzOr6vGS2lbQg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967330; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=bMgFyOLkyfb80xl55nfRJhZVsQqxdeL7O63vXgfou00=;
	b=K1pCXjcrRAr3okcAFSxecUpH8bPVo9zFGXKrc/p+U14mqjpkY918W4mIXF+wwbbFAWi54o
	C8twzKZjNYDQIje+wjtNl8Ky5S0jB3QLn1+79uHi0Fqf9xLcsYAp98kaGRZ1U6VnwWLQLq
	0dv7YIpLPjeXni0iVdEZJAX800CwUH3BXbkK0EHm96NRiKsy0Mg4TGfza+AZxBK8Bl8U/N
	6hU7Hlmf5XJla+Se9SxaOcbifefyBnHHYH26e0/pC8CQiwbF0SMD57WIijaiEP4JfMAjjK
	VcriMck5leP6cMT90LkpYU+z3ZfKNucukzsGYK3Nl1ZVL6Nr8sE21KrhbvkmqA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v2 0/9] reparse points work
Date: Sat, 25 Nov 2023 23:55:01 -0300
Message-ID: <20231126025510.28147-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Steve,

This series contains reparse point fixes and improvements for SMB2+:

- Add support for creating character/block devices, sockets and fifos
  via NFS reparse points by default.

- Add support for creating SMB symlinks via IO_REPARSE_TAG_SYMLINK
  reparse points.

- smb2_compound_op()

  * allow up to MAX_COMPOUND(5) commands in a single compound request
  * introduce SMB2_OP_{GET,SET}_REPARSE commands

- Optimisations for dentry revalidation and read/write of reparse
  points by reducing number of roundtrips.

- Fix renaming and hardlinking of reparse points

For people who pass 'mfsymlinks' and 'sfu' mount options, the
implementation is expected to avoid creating reparse points at all.

Volker Lendecke had suggested trying to create both SMB symlink and
mfsymlink in a single compound request but this series doesn't have
it.  It could be implemented later.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
Changes in v2:
- Fix missing mode bits for SMB symlinks (reported by Steve)
- Fix uninitialised var warnings (reported by kernel test robot)
- Add dentry reval optimisation for SMB3 POSIX query info as well

---
Paulo Alcantara (9):
  smb: client: extend smb2_compound_op() to accept more commands
  smb: client: allow creating special files via reparse points
  smb: client: allow creating symlinks via reparse points
  smb: client: optimise reparse point querying
  smb: client: fix renaming of reparse points
  smb: client: fix hardlinking of reparse points
  smb: client: cleanup smb2_query_reparse_point()
  smb: client: optimise dentry revalidation for reparse points
  smb: client: fix missing mode bits for SMB symlinks

 fs/smb/client/cifsglob.h  |   47 +-
 fs/smb/client/cifsproto.h |   30 +-
 fs/smb/client/cifssmb.c   |   17 +-
 fs/smb/client/dir.c       |    7 +-
 fs/smb/client/file.c      |   10 +-
 fs/smb/client/inode.c     |   98 ++--
 fs/smb/client/link.c      |   29 +-
 fs/smb/client/smb2glob.h  |   26 +-
 fs/smb/client/smb2inode.c | 1054 ++++++++++++++++++++++---------------
 fs/smb/client/smb2ops.c   |  297 ++++++-----
 fs/smb/client/smb2proto.h |   29 +-
 fs/smb/client/trace.h     |    7 +-
 12 files changed, 997 insertions(+), 654 deletions(-)

-- 
2.43.0

