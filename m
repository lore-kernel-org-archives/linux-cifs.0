Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55CF287265
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 14:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765463636; cv=none; b=N/QtTcJRKztCNLWZYfrz8LzrSEFzS/l+Du8XImDK2rgOw8s+4MubFf9rO3Tx4NkUIBVsJC0k0OFKLaPoy9vNOM5L+21C8vtS/J6VuepvH/9KMpvLKSxa00kuAnodZEHNrLHYTtnSppoXI9sPnW6eaOSkD/mwoHo35uY+thoBYLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765463636; c=relaxed/simple;
	bh=yGPmt/+YvWB9coDTSHyTT85HV6q9q/qX4Zxqrv27aRY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mFWzukZWlC6MIrx6z/vD17/monknUDmXdsYv3nklnWpwy69wdpDSh3u1+T38PioTmXD3i0vmrZgSnT4httj707g4Q9AbYKolimZKsnqTV1P6A1Gc8kZf+do5+clyriiT44HhousDJ+MOlXbnuHweI6edP+bRoeVV1a0vlK+hV9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WrR3tZbG; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WrR3tZbG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765463622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xY0GXibXh1F7Uc91EciVPJnmpG/K7n1fef3r9YJZeiM=;
	b=WrR3tZbGQcr0fNTKP7YqLwY79MjJ7WH8nfXXzNk2D/qcLgKBULhvtWl+3kYP4eUmgc+5mX
	qugRLCP7c3Hj/4XbHHk4n4e/gJFjASP9aYL3DZ97ngGzQDTld78rFqZtmZ/ocmmoQAUhl9
	86f404rLM2k4TabEWOxW35wdMCHSL4o=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 0/7] smb: move duplicate definitions into common header file, part 2
Date: Thu, 11 Dec 2025 22:32:21 +0800
Message-ID: <20251211143228.172470-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

For more detailed information about the patches to be reviewed, please see the link:
https://chenxiaosong.com/en/smb-patch.html

This is a continuous effort to move duplicated definitions in both client
and server into common header files, which makes the code easier to maintain.

The previous work is here:
part 1: https://lore.kernel.org/linux-cifs/20251117112838.473051-1-chenxiaosong.chenxiaosong@linux.dev/

v1: https://lore.kernel.org/all/20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev/
The following patches from v1 have already been merged into cifs-2.6.git for-next and ksmbd.git ksmbd-for-next:
  - smb/server: add comment to FileSystemName of FileFsAttributeInformation
  - smb/client: remove DeviceType Flags and Device Characteristics definitions
  - smb: move file_notify_information to common/fscc.h
  - smb: move SMB2 Notify Action Flags into common/smb2pdu.h
  - smb: move notify completion filter flags into common/smb2pdu.h
  - smb: add documentation references for smb2 change notify definitions

The following patches from this version(v2) have already been merged into cifs-2.6.git for-next:
  - smb: move some SMB1 definitions into common/smb1pdu.h
  - smb: move File Attributes definitions into common/fscc.h
  - smb: update struct duplicate_extents_to_file_ex

v1->v2:
  - Patch #0001: update FILE_ATTRIBUTE_MASK value
  - Patch #0002: `__u64 StructureSize` -> `__le64 StructureSize`
  - Patch #0003: conflicts have been resolved

ChenXiaoSong (2):
  smb: move File Attributes definitions into common/fscc.h
  smb: update struct duplicate_extents_to_file_ex

ZhangGuoDong (5):
  smb: move some SMB1 definitions into common/smb1pdu.h
  smb: move smb3_fs_vol_info into common/fscc.h
  smb: move some definitions from common/smb2pdu.h into common/fscc.h
  smb: introduce struct create_posix_ctxt_rsp
  smb: introduce struct file_posix_info

 fs/smb/client/cifspdu.h    |   2 +-
 fs/smb/client/inode.c      |  22 +-
 fs/smb/client/readdir.c    |  28 +--
 fs/smb/client/reparse.h    |   4 +-
 fs/smb/client/smb2pdu.c    |   9 +-
 fs/smb/client/smb2pdu.h    |  21 +-
 fs/smb/common/fscc.h       | 415 ++++++++++++++++++++++++++++++++++-
 fs/smb/common/smb1pdu.h    |  56 +++++
 fs/smb/common/smb2pdu.h    | 432 ++-----------------------------------
 fs/smb/common/smbglob.h    |   2 -
 fs/smb/server/oplock.c     |   8 +-
 fs/smb/server/smb2pdu.c    |  84 ++++----
 fs/smb/server/smb2pdu.h    |  27 +--
 fs/smb/server/smb_common.h |   9 +-
 14 files changed, 572 insertions(+), 547 deletions(-)
 create mode 100644 fs/smb/common/smb1pdu.h

-- 
2.43.0

