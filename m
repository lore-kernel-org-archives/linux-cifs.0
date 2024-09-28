Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C97F13634C;
	Sat, 28 Sep 2024 22:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727560847; cv=none; b=HHM6hNV/RJhg/f2WN1DuFxygKVHbxYaLVM7DVuf+EFoImr92HmPs9s8VPVDmcfs6h2yVsjRpcyaQYFNDfREyr96rPM2aTxFH+mBOXNtj0NMQ8yGB9iWnPBzMu3eF8FTPo+0cTb9nzv7nKiABc8mG+BNXpuyPwdkT2USdNv5hpbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727560847; c=relaxed/simple;
	bh=6f3kI3vNO51W5i9xFDRwBw82aXmacIP+owbTmgFQn8U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=K7cP4QaNhztUMocqQ7dBusIQcJG3uMk36EGChqqHyAqXpukwLZ6XTcZkKV9sDBEwWcJ2AtZasMXhwF+AJmREPs6YTxJv56HahWd8qR6njcF7xqo2mhCdeZsBeFLyF7eztnHBav4//KBQXJ0ZlJ7ubal1U7GmcT9LEM4iCJpvt5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pUSGyJgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pUSGyJgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1ACC4CEC3;
	Sat, 28 Sep 2024 22:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727560847;
	bh=6f3kI3vNO51W5i9xFDRwBw82aXmacIP+owbTmgFQn8U=;
	h=From:To:Cc:Subject:Date:From;
	b=pUSGyJgdCK5vpBLi8OQLR6jEWSmX5Iw24VOUc8pB1ApEPkBZRFESK8DFVBrTqumUV
	 /MB3dl5kB3HpHKu8rfxGLfLgMzVmnPO3o/jGqpjQaRbxU8LEyWaVmJeQU/e+4m5Cl7
	 4GileOS5OTUQnfw6y8zbLGXavXF6p57/xyuAtxruM3r35BI1drSWDdckBogCgZEAxY
	 RiR7+66vREsf/BpmGKjaU0V7ummHttlC1ozB/qJafOvOq+yK5v30IrBBWzm4FzxFYq
	 eZjm08qkXPO5iG/UN7PldLcI/BASpLA46yLMHckMMWruzqjMX5Ra1Bs3z3NCbRx3d5
	 VM1TBG0GrbMjQ==
Received: by pali.im (Postfix)
	id 3ABE0651; Sun, 29 Sep 2024 00:00:40 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] cifs: Fix support for NFS-style reparse points
Date: Sat, 28 Sep 2024 23:59:40 +0200
Message-Id: <20240928215948.4494-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For NFS-style reparse points in the current Linux SMB client I found few
buffer overflows and then incompatibility issues related to char/block
devices and symlinks. In this patch series I'm addressing these issues.
I also located commits which introduced these issues, I put them into
Fixes lines of commit messages.

Test cases against Windows server which exports one directory over both
SMB and NFS protocols. On Linux is mounted that directory to /mnt/nfs
and /mnt/smb via different protocols.

  mknod /mnt/nfs/char c 1 3
  stat /mnt/smb/char
  mknod /mnt/nfs/block b 8 0
  stat /mnt/smb/block
  ln -s abc\\abc /mnt/nfs/symlink
  stat /mnt/smb/symlink
  ls -l /mnt/smb

ls -l or stat over SMB should show the same information about char, block
and symlink as over NFS. And vice-versa.

Please look and check the buffer overflow issue as these buffer lengths
are always nightmares to handle correctly.

Pali Rohár (8):
  smb: Update comments about some reparse point tags
  cifs: Remove intermediate object of failed create reparse call
  cifs: Fix parsing NFS-style char/block devices
  cifs: Fix creating NFS-style char/block devices
  cifs: Fix buffer overflow when parsing NFS reparse points
  cifs: Do not convert delimiter when parsing NFS-style symlinks
  cifs: Validate content of NFS reparse point buffer
  cifs: Rename posix to nfs in parse_reparse_posix() and
    reparse_posix_data

 fs/smb/client/cifsglob.h  |  2 +-
 fs/smb/client/cifspdu.h   |  2 +-
 fs/smb/client/reparse.c   | 53 +++++++++++++++++++++++++++++++--------
 fs/smb/client/reparse.h   | 12 ++++++---
 fs/smb/client/smb2inode.c | 21 ++++++++++++++--
 fs/smb/common/smb2pdu.h   |  2 +-
 fs/smb/common/smbfsctl.h  |  7 +++---
 7 files changed, 77 insertions(+), 22 deletions(-)

-- 
2.20.1

