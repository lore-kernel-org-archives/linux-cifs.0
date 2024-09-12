Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBACB1A2625;
	Thu, 12 Sep 2024 12:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726142761; cv=none; b=UJTGAR7BZj9NhTfP2d/Kbkyui1ZjduDSPfkEWG3yAivYyI/+hyS2CbJ45tZXgZp3NYNfFV5BJ6xknDF1D4ADjToJzZepycfhWPZfe+3DI74zCH5DGiI66+8VA1VJ5oC/hj+HvtncmzhXtUMdAmaF76duVJIb9cs1E4yLxOeReB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726142761; c=relaxed/simple;
	bh=9A1yrLsGcrTDe13xvxQFibx6YzFnxkW2P1PU9DwTHUs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=UlSt9lzkloy+nYlERSeAuif9c9s0jweG8aFxPjT4fNyLvfLiR/rc/qmHgtPQpmToszpaMpJxk9jC8e/p0ygCFeqxy2pYiVsY5FUEPUH5c3fGsS5qFc7dcRPqezmPqUjuWd4SmT55YONLcViCy1+a0DtTHrCMURhAj5cVBtTFDwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uIFhHWmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uIFhHWmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3109AC4CEC3;
	Thu, 12 Sep 2024 12:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726142760;
	bh=9A1yrLsGcrTDe13xvxQFibx6YzFnxkW2P1PU9DwTHUs=;
	h=From:To:Cc:Subject:Date:From;
	b=uIFhHWmA/VCUTakByO0JX1EA9zn+f52piF2OtLn0ZoJwx8FMDV5q8jLpY5IEUe6Yo
	 Kn4J82+o11lLN653peuAmrUfLf8RZxLN3xhbXK1QmN7oTaFwpzoYYUMf340VsahCsC
	 AkXYH8jxfoAK9C0EP6X743mj1fnqFkBzkjPMYv4WOLYtElweXtLlbGc8AbdC1RbrX1
	 9T1+wkyXjnpCUX4kmukC1tCQBd89kF4ofP0WXV+YHJMnfvvymivdwsyxtBkOUOj/mT
	 +EaHbbvfmy/esZnhXvXP7mLmTEis7/jNkbVUreE9VzymgtaF91jO67hKa5xoTjQBBZ
	 5S88j0AuJ3Ydg==
Received: by pali.im (Postfix)
	id D3EBC5E9; Thu, 12 Sep 2024 14:05:54 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] cifs: Improve client SFU support for special files
Date: Thu, 12 Sep 2024 14:05:41 +0200
Message-Id: <20240912120548.15877-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series implement full support for SFU-style of special files
(fifo, socket, block, char, symlink) and makes client cifs's -o sfu
mount option to be fully compatible with SFU.

Before this patch series, kernel cifs client was able to:
* create new char and block devices in SFU-style, and detect them
* detect existing SFU fifo, but no create/mkfifo SFU functionality
* detect symlink SFU symlink, but no readlink() functionality and
  neither no create SFU symlink functionality

And it was able to create some SFU-incompatible sockets and fifos (when
-o sfu was specified) which were not recognized by neither original MS
SFU implementation and neither by others.

This patch series implements missing functionality, which is:
* detect existing SFU sockets
* create new SFU sockets
* create new SFU fifos
* create new SFU symlink
* readlink() support for existing SFU symlinks

In following pragraphs are some details about these SFU special files
which usage on Linux has to be activated by -o sfu mount option.

SFU-style fifo is empty file with system attribute set. This format is
used by old Microsoft POSIX subsystem and later also by OpenNT/Interix
subsystem (which replaced Microsoft POSIX subsystem and is part of
Microsoft SFU). OpenNT is previous name of Interix versions 1.x/2.x.
Microsoft POSIX subsystem is available since the first Windows NT
version 3.1, and it was replaced by Interix since Windows XP. Interix
continue to use this format up to the its last released version for
Windows 8 / Server 2012 (part of Subsystem for UNIX-based Applications).
Hence these SFU-style fifos are for very long time unified and widely
supported.

SFU-style socket is file which has system attribute set and file content
is one zero byte.

SFU-style symlink is file which has system attribute set and file content
is buffer "IntxLNK\1" (8th byte is 0x01) followed by the target location
encoded in little endian UCS-2/UTF-16. There is no trailing nul.

SFU-style char or block device is file which has system attribute set
and file content is buffer "IntxBLK\0" or "IntxCHR\0" (8th byte is 0x00)
followed by major and minor numbers encoded in twos 64-bit little endian.

Format of SFU-style sockets, symlinks, char and block devices was
introduced in Interix 3.0 subsystem, as part of the Microsoft SFU 3.0
and is used also by all later versions, up to the Windows 8 / Server 2012
(part of Subsystem for UNIX-based Applications) where it was deprecated.
Previous OpenNT/Interix versions had no support for UNIX domain sockets
(and socket files), symlinks or possibility to create character or block
devices (but they had block/char devices in-memory, returned by stat()).

Microsoft NFS server up to the version included in Windows Server 2008 R2
also uses this SFU-style format of special files when storing them on
local filesystem. Later Microsoft NFS server versions (starting in
Windows Server 2012) use new NFS reparse format, which Interix subsystem
(included in SFU or SUA) does not understand.

Even SFU-style of special files is old format, it has one big advantage,
this format does not require any support on SMB/CIFS server of special
files, as everything is stored only in the file content. The only
requirement from server is support for system attribute. So this allows
to store special files also on FAT filesystem.

This patch series makes cifs -o sfu mount option compatible with
SFU-style of special files, and so compatible with the latest SFU/SUA.

Note that -o sfu is by default turned off, so these changes should have
no effect on default cifs mounts.

Manually tested with MS SFU 3.5 (for Windows XP) and MS SUA 6.2 (latest
released version of Interix) that interop works correctly, special files
created by POSIX/Interix application can be recognized by Linux cifs
client (exported over MS SMB) with these patches (and vice-versa setup,
created by Linux cifs client and recognized in POSIX/Interix subsystem).

Manually tested that old Linux 4.19 cifs client version can recognize
SFU-style of special files created by Linux cifs client this patch
series (except socket, which is unsupported in this Linux cifs version).

Patch series is based on the latest upstream tag v6.11-rc7.

Pali Rohár (7):
  cifs: Fix recognizing SFU symlinks
  cifs: Add support for reading SFU symlink location
  cifs: Put explicit zero byte into SFU block/char types
  cifs: Show debug message when SFU Fifo type was detected
  cifs: Recognize SFU socket type
  cifs: Fix creating of SFU fifo and socket special files
  cifs: Add support for creating SFU symlinks

 fs/smb/client/cifspdu.h    |  6 ---
 fs/smb/client/cifsproto.h  |  4 ++
 fs/smb/client/cifssmb.c    |  8 ++--
 fs/smb/client/fs_context.c | 13 ++++---
 fs/smb/client/inode.c      | 42 ++++++++++++++++++--
 fs/smb/client/link.c       |  3 ++
 fs/smb/client/smb1ops.c    |  2 +-
 fs/smb/client/smb2ops.c    | 78 ++++++++++++++++++++++++++++----------
 8 files changed, 117 insertions(+), 39 deletions(-)

-- 
2.20.1

