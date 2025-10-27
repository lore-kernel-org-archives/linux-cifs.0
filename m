Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B9A4A32;
	Mon, 27 Oct 2025 07:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549325; cv=none; b=cKtBXDPYRjOt+q3/IPr3EnBFHt9r5xPcc11C4OoV56brI5Z274lOWeZxt+MS1BcKwoWYveZSnPubTW6sFZo0Z2xCKdIfr7ShlICXx5+4Dbq3yabIOzmFq/2JTyIIAHt2MP5c3kwu6qGHgCSe5B0a0WAJjre51kktZHrERluH5Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549325; c=relaxed/simple;
	bh=Pe+CdUNq7xPhOHBLPZEjDbQCc3DQanoxkFozOCx35eU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hBL+eGlhwbXzAydwcf5Th1fYFU7sxpinXRYXanC2mqL879T33YvUkFYqYipFZfCTSVikGIsbYEkxnCZRWdMoSEIKTU8hH9HEmoe/goM+rhsszbDX/W/d5pReHyguOlpx351VMktumLYZopoY/BXU7RoxaP9VDmHOKipMZ83ANAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PaFD+1zb; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PaFD+1zb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=T9e1nf1/1euwPJDsBGHv64szmanH5wpqLiBTycBujNY=;
	b=PaFD+1zbWYTkjb8PjRH1oqkbaB2saVyKjQ0mJJN/f6vlZbrfQKi4c9UQ2SEHsQraZp9+5o
	8HtpE4xX3og/x82rGRe2BGZnW47cTuqOdbXj3q+Yhf+GInBkZbEJ7i8FeeBIjTkpyHoax0
	N8XB3K00RRhs4GPrhgZR9mmQs6ueEmo=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 00/24] smb: move duplicate definitions to common header file
Date: Mon, 27 Oct 2025 15:12:52 +0800
Message-ID: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
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

  - smb/server: fix possible memory leak in smb2_read(): https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6fced056d2cc8d01b326e6fcfabaacb9850b71a4
  - smb/server: fix possible refcount leak in smb2_sess_setup(): https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=379510a815cb2e64eb0a379cb62295d6ade65df0
  - smb: move some duplicate definitions to common/cifsglob.h: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d877470b59910b5c50383d634dda3782386bba51

In order to maintain the code more easily, move some duplicate definitions
to common header file.

Add some MS documentation references for macro and struct definitions.

v3->v4:
  - The following modifications were made according to Namjae's suggestions.
  - Create patch #01, rename it to "smbglob.h".
  - Patch #02 #03 #04: move definitions to common/smbglob.h instead of common/cifsglob.h.
  - Patch #05: do not move "BAD_PROT".
  - Patch #05 ~ #15: move definitions to common/smb1pdu.h instead of common/cifspdu.h.
  - Create #16 ~ #19: move some durable handle structures to common/smb2pdu.h.
  - Fix warnings from script checkpatch.pl: WARNING: Prefer __packed over __attribute__((packed)).
  - Update some commit message descriptions.

v3: https://lore.kernel.org/all/20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev/

ChenXiaoSong (16):
  smb: move some duplicate definitions to common/smb1pdu.h
  smb: move file access permission bits definitions to common/smb1pdu.h
  smb: move SMB frame definitions to common/smb1pdu.h
  smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/smb1pdu.h
  smb: move FILE_SYSTEM_DEVICE_INFO to common/smb1pdu.h
  smb: move FILE_SYSTEM_INFO to common/smb1pdu.h
  smb: move FILE_DIRECTORY_INFO to common/smb1pdu.h
  smb: move FILE_FULL_DIRECTORY_INFO to common/smb1pdu.h
  smb: move FILE_BOTH_DIRECTORY_INFO to common/smb1pdu.h
  smb: move SEARCH_ID_FULL_DIR_INFO to common/smb1pdu.h
  smb: move FILE_SYSTEM_POSIX_INFO to common/smb1pdu.h
  smb: move create_durable_req_v2 to common/smb2pdu.h
  smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h
  smb: move create_durable_rsp_v2 to common/smb2pdu.h
  smb/server: remove create_durable_reconn_req
  smb: move smb2_file_network_open_info to common/smb2pdu.h

ZhangGuoDong (8):
  smb: rename common/cifsglob.h to common/smbglob.h
  smb: move smb_version_values to common/smbglob.h
  smb: move get_rfc1002_len() to common/smbglob.h
  smb: move SMB1_PROTO_NUMBER to common/smbglob.h
  smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
  smb: move copychunk definitions to common/smb2pdu.h
  smb: move resume_key_ioctl_rsp to common/smb2pdu.h
  smb: move some duplicate definitions to common/smb2pdu.h

 fs/smb/client/cifsacl.c       |   4 +-
 fs/smb/client/cifsglob.h      |  30 +--
 fs/smb/client/cifspdu.h       | 435 +-------------------------------
 fs/smb/client/cifssmb.c       |  10 +-
 fs/smb/client/cifstransport.c |   8 +-
 fs/smb/client/connect.c       |   2 +-
 fs/smb/client/misc.c          |   2 +-
 fs/smb/client/smb2ops.c       |  18 +-
 fs/smb/client/smb2pdu.c       |  14 +-
 fs/smb/client/smb2pdu.h       | 112 ---------
 fs/smb/common/cifsglob.h      |  30 ---
 fs/smb/common/smb1pdu.h       | 462 ++++++++++++++++++++++++++++++++++
 fs/smb/common/smb2pdu.h       | 144 ++++++++++-
 fs/smb/common/smbglob.h       |  68 +++++
 fs/smb/server/oplock.c        |   8 +-
 fs/smb/server/smb2misc.c      |   2 +-
 fs/smb/server/smb2ops.c       |  38 +--
 fs/smb/server/smb2pdu.c       | 136 +++++-----
 fs/smb/server/smb2pdu.h       | 107 --------
 fs/smb/server/smb_common.c    |  10 +-
 fs/smb/server/smb_common.h    | 291 +--------------------
 fs/smb/server/smbacl.c        |   2 +-
 fs/smb/server/vfs.c           |   2 +-
 23 files changed, 800 insertions(+), 1135 deletions(-)
 delete mode 100644 fs/smb/common/cifsglob.h
 create mode 100644 fs/smb/common/smb1pdu.h
 create mode 100644 fs/smb/common/smbglob.h

-- 
2.43.0

