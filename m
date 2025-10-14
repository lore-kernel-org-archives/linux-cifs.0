Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D442B2BEC21;
	Tue, 14 Oct 2025 07:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760426458; cv=none; b=OMXACccVzgZBFvXH8DNCGP8og+192e26jPa6d2cOFLm5p+KFUCUcjF4XhLXa+8bG2VLEMSeN9f9rRSo70RZ+0vH5Mh/+iWu4VQpIRhWltehSywmFLnYAUnNyivp28erXvj+6xI3fskt1yxizw85O/fXv553gBoMLNUL2PqIuFJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760426458; c=relaxed/simple;
	bh=EClqgr+PIiS8JGnK9mOJA6g8pUPc8kDxBTwiv6Unmeo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FELgEV1tMvuOGU9XbLuwCZTspL+wpX8Gy8DVGfkXmWytUio3hLX3s0exN1nQB/SMf90515bhYWNb1Mfx2q2hI0A57z/h+qqs0W9p2QgnmTFpizN9GQkSXFplvbHsEiUvlLHosgEQm6IlETOoc4h+dAAnHutcT6zti55xFmZJ86A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SoDmxlIV; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SoDmxlIV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760426453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vqobPTRi1bCmKig5Ni0AmKxkbU8cvFJ5W3bsJ2JJ2f8=;
	b=SoDmxlIVPrGT97UniEcbzUYnX9f8WcXXHSZVUvV4bWH83jGI3dN1iujILQtrIPJeXmPpRs
	+m1eOJ6/MAqlSD9pWQgdvB5zXei6AdMqt5tLU3AaoVRAImKKzTb/ao4o5yf2mjl2LtPWPH
	C1BW3bvPv1Dugbw+G1R/TWCM0TvCuiw=
From: chenxiaosong.chenxiaosong@linux.dev
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	christophe.jaillet@wanadoo.fr,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 00/22] smb: fix some bugs, move duplicate definitions to common header file
Date: Tue, 14 Oct 2025 15:18:55 +0800
Message-ID: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Emails from previous address were often not received (went to the spam
folder or other reasons), and the cover letter wasn't linked to the
patches. So yesterday I requested chenxiaosong.chenxiaosong@linux.dev
account and have now sent v3.

Fix some bugs of smb server.

In order to maintain the code more easily, move some duplicate definitions
to common header file.

Add some MS documentation references for macro and struct definitions.

v2->v3:
  - Update patch #06: use "Suggested-by:" instead of "Reviewed-by:"

v1->v2:
  - Update patch #06 according to Christophe JAILLET's suggestions: https://lore.kernel.org/all/d03c64d2-46c0-42d8-8f88-28669e921c95@wanadoo.fr/

v2:
  - cover-letter: https://lore.kernel.org/all/40F04A8E2145E761+20251012161749.2994033-1-chenxiaosong@chenxiaosong.com/
  - patches: https://lore.kernel.org/all/47508024F79AE36C+20251012161749.2994033-2-chenxiaosong@chenxiaosong.com/

v1:
  - cover-letter: https://lore.kernel.org/all/76A15C078023E21F+20251012150915.2992220-1-chenxiaosong@chenxiaosong.com/
  - patches: https://lore.kernel.org/all/029014EF18C9D322+20251012150915.2992220-2-chenxiaosong@chenxiaosong.com/
  - RESEND cover-letter: https://lore.kernel.org/all/37DF3D711BAD3621+20251012152247.2992573-1-chenxiaosong@chenxiaosong.com/
  - RESEND patches: https://lore.kernel.org/all/9836A3F274B62345+20251012152247.2992573-2-chenxiaosong@chenxiaosong.com/

ZhangGuoDong (10):
  smb/server: fix possible memory leak in smb2_read()
  smb/server: fix possible refcount leak in smb2_sess_setup()
  smb: move some duplicate definitions to common/cifsglob.h
  smb: move smb_version_values to common/cifsglob.h
  smb: move get_rfc1002_len() to common/cifsglob.h
  smb: move SMB1_PROTO_NUMBER to common/cifsglob.h
  smb: move some duplicate definitions to common/smb2pdu.h
  smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
  smb: move copychunk definitions to common/smb2pdu.h
  smb: move resume_key_ioctl_rsp to common/smb2pdu.h

ChenXiaoSong (12):
  smb: move smb2_file_network_open_info to common/smb2pdu.h
  smb: move some duplicate definitions to common/cifspdu.h
  smb: move file access permission bits definitions to common/cifspdu.h
  smb: move SMB frame definitions to common/cifspdu.h
  smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/cifspdu.h
  smb: move FILE_SYSTEM_DEVICE_INFO to common/cifspdu.h
  smb: move FILE_SYSTEM_INFO to common/cifspdu.h
  smb: move FILE_DIRECTORY_INFO to common/cifspdu.h
  smb: move FILE_FULL_DIRECTORY_INFO to common/cifspdu.h
  smb: move FILE_BOTH_DIRECTORY_INFO to common/cifspdu.h
  smb: move SEARCH_ID_FULL_DIR_INFO to common/cifspdu.h
  smb: move FILE_SYSTEM_POSIX_INFO to common/cifspdu.h

 fs/smb/client/cifsacl.c       |   4 +-
 fs/smb/client/cifsglob.h      |  47 +---
 fs/smb/client/cifspdu.h       | 436 +-------------------------------
 fs/smb/client/cifssmb.c       |  10 +-
 fs/smb/client/cifstransport.c |   8 +-
 fs/smb/client/connect.c       |   2 +-
 fs/smb/client/misc.c          |   2 +-
 fs/smb/client/smb2ops.c       |  18 +-
 fs/smb/client/smb2pdu.h       |  80 +-----
 fs/smb/common/cifsglob.h      |  68 +++++
 fs/smb/common/cifspdu.h       | 464 ++++++++++++++++++++++++++++++++++
 fs/smb/common/smb2pdu.h       |  98 ++++++-
 fs/smb/server/smb2misc.c      |   2 +-
 fs/smb/server/smb2ops.c       |  32 +--
 fs/smb/server/smb2pdu.c       | 114 +++++----
 fs/smb/server/smb2pdu.h       |  67 -----
 fs/smb/server/smb_common.c    |  10 +-
 fs/smb/server/smb_common.h    | 304 +---------------------
 fs/smb/server/smbacl.c        |   2 +-
 fs/smb/server/vfs.c           |   2 +-
 20 files changed, 735 insertions(+), 1035 deletions(-)
 create mode 100644 fs/smb/common/cifsglob.h
 create mode 100644 fs/smb/common/cifspdu.h

-- 
2.43.0

