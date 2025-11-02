Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C886B1DEFE7
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 07:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762068740; cv=none; b=S/NEeW9yZCDgRK1ucyS8M86zU9RlkRh/BF2GmJxsm/uGTkIqUfFrJqVGG9XDEEcDA5eea2+oUx75G92Uy0YuQGTIyOOERJbDlB0moO6xg5A9Ka7zFSuAd+zLX41NYNOsP/znUHwgmksWyi9U022Bb4lXkOO8Wt0+A8Bc7zxJKEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762068740; c=relaxed/simple;
	bh=xWSv1it25Xy4tFCIged1MnqeORJzvNk9fJ9H6RwZpbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UlfGRWVntFiPlmso7ZLfP7j0YUGk7U29KzVVRb+KznUi0PHkboMeRmoe9yB3gKHtU0txtkMGY+YvIHDbtwSUT+2BVbyaVvE1wKQMdNeTXS/d7JDkityVjBr/pA8bX06C7uZflzujSzcEsYK36OqJ9FIKa5SYxukXnYe2HS9s8u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RoAShPJc; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RoAShPJc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762068735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Bbe2mlfUV4MuMFB3diayfmXCwmdcycYZm+yEgSQApfU=;
	b=RoAShPJcpeQ0Fg0vQ+nWFCPhI7zwFJ/lDFojaGFafXztPsxQc6CSD+xEORNuM2xdNSUIHT
	T/Rri0CaZY5G4SzRrzKzuW3SHnGSTagxAr8SOhdb20cdCHgOxJuLqhY+YkLQOjG0Z2c+Nc
	KNmZAgwgGk9X/LUQ9urOGC7BXyVqSQg=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 00/14] smb: move duplicate definitions to common header file
Date: Sun,  2 Nov 2025 15:30:45 +0800
Message-ID: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The following patches from v3 have already been merged into the mainline:

  - 6fced056d2cc smb/server: fix possible memory leak in smb2_read()
  - 379510a815cb smb/server: fix possible refcount leak in smb2_sess_setup()
  - d877470b5991 smb: move some duplicate definitions to common/cifsglob.h

The following patches from v4 have been applied to [the ksmbd-for-next-next branch](https://git.samba.org/?p=ksmbd.git;a=shortlog;h=refs/heads/ksmbd-for-next-next):

  - smb: move resume_key_ioctl_rsp to common/smb2pdu.h
  - smb: move copychunk definitions to common/smb2pdu.h
  - smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
  - smb: move SMB1_PROTO_NUMBER to common/smbglob.h
  - smb: move get_rfc1002_len() to common/smbglob.h
  - smb: move smb_version_values to common/smbglob.h
  - smb: rename common/cifsglob.h to common/smbglob.h

In order to maintain the code more easily, move some duplicate definitions
to common header file.

Add some MS documentation references for macro and struct definitions.

I will test these code changes with smbtorure and xfstests as soon as possible.

By cleaning the common definitions for client and server, I've become more
familiar with the MS documentation, which I believe will be very useful for
developing SMB features soon. 

v4->v5:
  - The following modifications were made according to Namjae's and Steve's suggestions.
  - Create patch #01 #02 #08.
  - Patch #07: move struct smb_hdr to common/smb2pdu.h, do not move SET_FILE_READ_RIGHTS and SET_FILE_WRITE_RIGHTS.
  - Patch #09 ~ #12: move definitions to common/fscc.h
  - Patch #10: include all changes that only rename structures in this patch.
  - Patch #11 #12: some cleanups.

v4: https://lore.kernel.org/all/20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev/

ChenXiaoSong (13):
  smb/client: fix CAP_BULK_TRANSFER value
  smb: move MAX_CIFS_SMALL_BUFFER_SIZE to common/smbglob.h
  smb: move create_durable_req_v2 to common/smb2pdu.h
  smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h
  smb: move create_durable_rsp_v2 to common/smb2pdu.h
  smb/server: remove create_durable_reconn_req
  smb: move SMB_NEGOTIATE_REQ to common/smb2pdu.h
  smb: move list of FileSystemAttributes to common/fscc.h
  smb: move some duplicate struct definitions to common/fscc.h
  smb: move FILE_SYSTEM_SIZE_INFO to common/fscc.h
  smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/fscc.h
  smb: do some cleanups
  smb: fix some warnings reported by scripts/checkpatch.pl

ZhangGuoDong (1):
  smb: move some duplicate definitions to common/smb2pdu.h

 fs/smb/client/cifsglob.h   |   1 +
 fs/smb/client/cifspdu.h    | 593 +++++++++++--------------------------
 fs/smb/client/cifssmb.c    |  12 +-
 fs/smb/client/connect.c    |   4 +-
 fs/smb/client/inode.c      |   4 +-
 fs/smb/client/ntlmssp.h    |   8 +-
 fs/smb/client/readdir.c    |  12 +-
 fs/smb/client/reparse.h    |   8 +-
 fs/smb/client/rfc1002pdu.h |   8 +-
 fs/smb/client/smb1ops.c    |   2 +-
 fs/smb/client/smb2inode.c  |   2 +-
 fs/smb/client/smb2pdu.c    |  16 +-
 fs/smb/client/smb2pdu.h    |  69 -----
 fs/smb/common/fscc.h       | 179 +++++++++++
 fs/smb/common/smb2pdu.h    | 221 +++++++++++++-
 fs/smb/common/smbacl.h     |   8 +-
 fs/smb/common/smbglob.h    |   4 +
 fs/smb/server/oplock.c     |   8 +-
 fs/smb/server/smb2ops.c    |   6 +-
 fs/smb/server/smb2pdu.c    | 116 ++++----
 fs/smb/server/smb2pdu.h    |  68 -----
 fs/smb/server/smb_common.h | 237 +--------------
 fs/smb/server/vfs.c        |   2 +-
 23 files changed, 682 insertions(+), 906 deletions(-)
 create mode 100644 fs/smb/common/fscc.h

-- 
2.43.0

