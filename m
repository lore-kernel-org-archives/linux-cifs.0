Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7250116F0DE;
	Thu, 22 Aug 2024 08:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315037; cv=none; b=UW/9YO0fNh+N36THcsk8jLmRnBnh/ujjuNKxGkVVQF4g6SKytX/EgZP/dWyGHJMctKWloaev9p4YzflHkntoG7M5+UXlYJKwKO1/p3/RQnDYQPJt0gSrrVBMftxGI0YTwSyEPnpJo7G7u0EUGsH9AswmqaRcgp0vdtVA2o5X9D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315037; c=relaxed/simple;
	bh=1if804qrRdS+to9ZGGnsukdUCjHFCKA77XormtPyRiY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tRBBJTUbIOqZrrYW+Eh0ccwBATsPeLgEeuWJva23q+1ZmLn5LrL5A5yMtvLXS/be7+z2F5hfGN5BOmaOWwgltyTi5rjspAtGQan+U4Nv1sMZL5A5aOvNXqRloL89mWdhKTnRGOpdg3JeQK50pYzDt1Z2ITmvLItRKdoDcYigDw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtp78t1724314902tuf0kbox
X-QQ-Originating-IP: bd5d3hud3bjpDjXycXiCu6lZ8OFE/CntWpVXtkns72Q=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Aug 2024 16:21:39 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 1308903623932186301
From: chenxiaosong@chenxiaosong.com
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com
Cc: chenxiaosong@kylinos.cn,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	chenxiaosong@chenxiaosong.com
Subject: [PATCH v2 00/12] smb: fix some bugs, move duplicate definitions to common header file, and some small cleanups
Date: Thu, 22 Aug 2024 08:20:49 +0000
Message-Id: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Fix some bugs in smb2_open() of smb server.

In order to maintain the code more easily, move some duplicate
definitions to common header file.

Additionally, add some small cleanups to the patchset.

v1->v2:
  - update patch #2 according to Namjae's suggestions.
  - add patch #6~9 to rename 'cifs_ntsd' 'cifs_sid' 'cifs_acl' 'cifs_ace' according to Namjae's suggestions.
  - add patch #12 to explained why the typo 'STATUS_MCA_OCCURED' was not corrected.

v1: https://lore.kernel.org/all/20240820143319.274033-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (12):
  smb/server: fix return value of smb2_open()
  smb/server: fix potential null-ptr-deref of lease_ctx_info in
    smb2_open()
  smb/server: remove useless assignment of 'file_present' in smb2_open()
  smb/client: fix typo: GlobalMid_Sem -> GlobalMid_Lock
  smb/server: update misguided comment of smb2_allocate_rsp_buf()
  smb/client: rename cifs_ntsd to smb_ntsd
  smb/client: rename cifs_sid to smb_sid
  smb/client: rename cifs_acl to smb_acl
  smb/client: rename cifs_ace to smb_ace
  smb: move some duplicate definitions to common/smbacl.h
  smb: move SMB2 Status code to common header file
  smb: add comment to STATUS_MCA_OCCURED

 fs/smb/client/cifsacl.c                |  224 +--
 fs/smb/client/cifsacl.h                |   99 +-
 fs/smb/client/cifsfs.c                 |    6 +-
 fs/smb/client/cifsglob.h               |   22 +-
 fs/smb/client/cifsproto.h              |   18 +-
 fs/smb/client/cifssmb.c                |    6 +-
 fs/smb/client/smb2file.c               |    2 +-
 fs/smb/client/smb2inode.c              |    6 +-
 fs/smb/client/smb2maperror.c           |    2 +-
 fs/smb/client/smb2misc.c               |    2 +-
 fs/smb/client/smb2ops.c                |   16 +-
 fs/smb/client/smb2pdu.c                |   14 +-
 fs/smb/client/smb2pdu.h                |    8 +-
 fs/smb/client/smb2proto.h              |    2 +-
 fs/smb/client/smb2transport.c          |    2 +-
 fs/smb/client/xattr.c                  |    4 +-
 fs/smb/{client => common}/smb2status.h |    6 +
 fs/smb/common/smbacl.h                 |  121 ++
 fs/smb/server/oplock.c                 |    4 +-
 fs/smb/server/server.c                 |    2 +-
 fs/smb/server/smb2misc.c               |    2 +-
 fs/smb/server/smb2pdu.c                |   17 +-
 fs/smb/server/smb_common.c             |    2 +-
 fs/smb/server/smbacl.h                 |  111 +-
 fs/smb/server/smbstatus.h              | 1822 ------------------------
 fs/smb/server/transport_rdma.c         |    2 +-
 26 files changed, 314 insertions(+), 2208 deletions(-)
 rename fs/smb/{client => common}/smb2status.h (99%)
 create mode 100644 fs/smb/common/smbacl.h
 delete mode 100644 fs/smb/server/smbstatus.h

-- 
2.34.1

