Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FDB25783C;
	Sun, 12 Oct 2025 15:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760281886; cv=none; b=LZVm5Aazxe9afqIyQSinibSEx/KCOsdP5dctgNxeNysX2YuKLZbNXVeBsByE8NcQYn2u/K5WWYUeupXoisKECu5zebaRQxzhIsCibu8AthTGroe9eVIOa4sZiCo0qoP4f9rJchV/8nBzbQxZ53H6exBtB42h+wo6FLoSHaSJAQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760281886; c=relaxed/simple;
	bh=toPJUQGQckanKBCiL2gAj47zyAZroYxByxfffvtJJ3A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S6tDBdwplATI4pgoyMhBbQ6ZSE8gV55YxSb1U7sSFvH/h4WmQaUTaN1F6YGzAdJLGCePRjAY7csG3qwMAhE6/FhcFaAux9btTuHTJ0dM4aQ3lLqyOxBDz9nuyaTjBLRuwQdvczrK3EbziEgjPe/RHIucqlaFevB1gml8TELkZek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281785t43493b85
X-QQ-Originating-IP: D7TbCbcfgwGXY/7iY3QOX8lSAR5REi3HyNLAcQ19+B4=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:09:43 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 15230841216352007273
From: chenxiaosong@chenxiaosong.com
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
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 00/22] smb: fix some bugs, move duplicate definitions to common header file
Date: Sun, 12 Oct 2025 23:08:53 +0800
Message-ID: <76A15C078023E21F+20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: MRY6qckr/MVJXoU2Wg6njFqiq7kHb7oh3aOzo753nk915H0A3VlrchWs
	fs4m6IZcT2ChlwAcqoTClysBXDZszMRmQ7FMJKAatmZw7uspOFf3yJvt+qBvJb5WuVHGf/M
	moP5OrQjerJoqN5XUPjvprEDZaE42pUyZkkykdz6gYv/kUoBJKk+84UvJqzsWdTg8WLf8Sh
	o9ixybyG1E7rDl5UPMuxkFn4bB0Oyz5b5w8YJROigF+MBLuIzV5rJK/yOiQdyG+M00mPkRs
	kQCCmlY9wmLWlSjNoP/l52em9lq3P6DyWCjd/iZA3XWM2errTUnWx4NnWFD0FjcSku8KnjU
	KwwYM+l2EuagRjqiv4LB5EelcpCDSgJ32wC2f3F035pxmffRwgSF/RFQ8T1tcoezpT9jVry
	f2ecY8ag+OYhu1M3m82xTE2iXgER9hA8eHDd7s3mXeZlZ7wVckPYb6GVLpfzH978YMI80P0
	hCR4+M34PaSCUlejEZzAd2ZQekwuNY9OpSBDUxrRkt+oFcmsW4jGEb9DnlERiR/JEyPSjBs
	Lcv+jKNdbnvCdJS8Zenyw/Ogg2HCgI16/SS6ckWpxCBbj+VpUGxPsLjOaM6jux85YUI1BCa
	8c6zNO9x3V+f0/UTx/W/UjfEWOrdW8F+loPH7KcvAViwnLfnBhO+EeyTTJ1tq2XQZpsvMWJ
	fotRzpSn/El7AzbmGFECwzR8Qh1qqmgse11hEAciy/3utrkINvk7pzZ4YlbILbBHOO3oaGS
	EnE2wspTk10OSbvNea/XQm5KjjX/lAW2Dy1BVrYVqSejxJ0oVYVAcoQq69VeKxSHeJEAMwE
	BqooWmwJ0sT6+BL3p3qU5vOSrf2hQZBv4Npq6FREKjSd6tgit2L5TdKaRExtaaMzgiXO3R/
	GlQRbBGpwmT4BH++OA3UYdN3TeaFZBKT8SmeWTbLJfI1b3r1mvHXoXf/KzRX25TX0M9yd5m
	dAnPLKNTsY4UeGhyslSiGSElnMoVafJWPyIQ=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Fix some bugs of smb server.

In order to maintain the code more easily, move some duplicate definitions
to common header file.

Add some MS documentation references for macro and struct definitions.

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

