Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777C95103F;
	Sun, 29 Sep 2024 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727635864; cv=none; b=Euq+8N0Ga3azkMM6dpMTS2tqBxtCrlSjEvWUMRoLr8QBppMtB46IGJmf4R+S5778NWGyzGNC071YdEjM/M/E1mHIalAndtFVafq3KoiyuHmIB5v+e4Icy5oTv40wW7NhMHTKU7RUUt9koZGHkyPJW5AxbJtUqFDXtiI4j5Ki/io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727635864; c=relaxed/simple;
	bh=4pJIvy7H7+SGTbNvEz+/K+2Ko+IMfiFbhdkT5vo0E54=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=OmVPEJgfswbY4Jlm9JLuP+mU1klwCG5ct4K78KqPFz3EbluS4yKXPKLKj6Z9jmvXzFmjP3A3hzhDWpf11v8bJ3GWEnnxwsuHceiBQTsaCfZRfRW/HlACs9tp9dLvSlgIra93p5Lrw8G2DBeoHceOb4OBO6J/sHZU8fmTS0lntMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TVU1iWMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TVU1iWMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005F0C4CED1;
	Sun, 29 Sep 2024 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727635864;
	bh=4pJIvy7H7+SGTbNvEz+/K+2Ko+IMfiFbhdkT5vo0E54=;
	h=From:To:Cc:Subject:Date:From;
	b=TVU1iWMll+VD7b4P4xMErr/lwMiuwBigVpBFZcmkUBUIhMKp2Rw8nURrvY50T+Z13
	 XvtuxN4VcajJxenr3hR+4MN/+W2NIjb12weHfwNQ3QsgwDR5UUTek0UZS3Gi6p65jj
	 R09zSjZnxKDbg44O8XfZAE7tP5elCw0onqPMHAYQMtOxnm28o1aVo+ID8Z2o9AA2ek
	 2LL3oMu1tcoDO47avx8bhrXtPhGF4bllvNkF4sxO+vhHMJHFRclFAH2jTy0qfO40H4
	 w7v1V1OULzeY7b/TUqiUCu+3EmhpkObokixEvPmcgBsMpmq/TxQhWYaraBW7CeaSYs
	 HxaaEOSc26XVg==
Received: by pali.im (Postfix)
	id CC793872; Sun, 29 Sep 2024 20:50:56 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] cifs: Improve support for native SMB symlinks
Date: Sun, 29 Sep 2024 20:50:46 +0200
Message-Id: <20240929185053.10554-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series improves interoperability of native SMB symlinks
(stored in IO_REPARSE_TAG_SYMLINK reparse point) between Linux SMB
client and Windows SMB server storage (NTFS).

Fixed test cases by this patch series are:

Fixes parsing of symlinks relative to the top of the export which can be
created on Windows by:

  mklink symlink \relative\path\from\export


Fixes parsing of symlinks in absolute form which can be created on
Windows by:

  mklink symlink C:\absolute\path


Fixes creating of symlinks pointing to directory. So Linux commands:

  mkdir dir
  ln -s dir symlink1
  ln -s another_dir/ symlink2

creates a symlink which would be now understood also by Windows as
symlinks to directories.


Fixes creating of symlinks pointing to current or parent directory.
So following commands create valid symlink understood by Windows:

  ln -s . symlink_cur
  ln -s .. symlink_parent


Fixes creating of absolute symlinks. Absolute symlinks on Windows are
quite complicated due to nature of DOS/Win32 path form used by Windows
applications and NT path form in which are symlink paths stored. Also
complication is that NT object paths have different hierarchy than POSIX
paths generally. Required information about NT object hierarchy used in
native absolute symlinks are in comments in the last patch from this
series.

To resolve mentioned problems I chosse way which is used by WSL, its
-t drvfs has mount option -o symlinkroot= which specify Linux path there
should point absolute windows drive letter symlinks. This could make
-t cifs mounts in WSL2 more compatible with symlinks coming from local
NTFS disks mounted by -t drvfs.

I'm not sure how good are these changes, but I think that they improve
compatibility of symlinks between Linux and Windows systems. Maybe there
is some better solution how to handle some of those issues?


Pali Rohár (7):
  cifs: Rename smb2_get_reparse_inode to smb2_create_reparse_inode
  cifs: Improve creating native symlinks pointing to directory
  cifs: Fix creating native symlinks pointing to current or parent
    directory
  cifs: Fix parsing native symlinks relative to the export
  cifs: Fix parsing native symlinks directory/file type
  cifs: Validate content of native symlink
  cifs: Fix creating and resolving absolute NT-style symlinks

 fs/smb/client/cifs_unicode.c |  17 +-
 fs/smb/client/cifsglob.h     |   1 +
 fs/smb/client/cifsproto.h    |   1 +
 fs/smb/client/fs_context.c   |  22 ++
 fs/smb/client/fs_context.h   |   2 +
 fs/smb/client/inode.c        |   1 +
 fs/smb/client/reparse.c      | 513 ++++++++++++++++++++++++++++++++---
 fs/smb/client/reparse.h      |   4 +-
 fs/smb/client/smb1ops.c      |   3 +-
 fs/smb/client/smb2file.c     |  67 ++++-
 fs/smb/client/smb2inode.c    |  15 +-
 fs/smb/client/smb2proto.h    |  13 +-
 12 files changed, 602 insertions(+), 57 deletions(-)

-- 
2.20.1

