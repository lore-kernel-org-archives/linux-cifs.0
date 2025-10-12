Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F71D2EB5D2;
	Sun, 12 Oct 2025 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282627; cv=none; b=r+GBqpCuzJyFGnuJPy7yAWWhZTiSxDJq2eWjQ+2f9UDQgVl79LcJXcB4tBKzlEeNmKBSNSmyQylcSUOrHhVLvbPFxZEEU10VjKLhVlyhY6bwuxFqZGxZBfrs3m0uEjzLSFvV/PB1Htdrg866cokJ/Nk6W+YWJ5PHYgg8a94ggH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282627; c=relaxed/simple;
	bh=toPJUQGQckanKBCiL2gAj47zyAZroYxByxfffvtJJ3A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LhtcvaTMQCCBiY+uUI7AQ5CRiDVX8icciHQIktuuAkCt/5qgWJiNa/VwSqqzcZEYEz8cPpsgw12qZluU8oYtCr5Jeuw8zHtYSorkuw71zBWw/PObRYcEMsrO0/UcxmdAWMK0G7xaB2xZjrKj/tthESVQxheYvPd7tA8jtA5KRho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282586tc09eb66a
X-QQ-Originating-IP: d2JULAKAjSninA7UxkxImQJTuYOgw+Fke9da5lH6Z3Y=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:04 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 1914263532796748959
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
Subject: [PATCH RESEND 00/22] smb: fix some bugs, move duplicate definitions to common header file
Date: Sun, 12 Oct 2025 23:22:25 +0800
Message-ID: <37DF3D711BAD3621+20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: MStYT69pzOQBmuflDuNHKezD8fCnSABEZkARfRnmPROxVe2Dxp+dqEC6
	s+2ak+xb0en9cyixnNCsfhoSX/8nqUj4mOZ3P4oR5hHD299tLpKz4rvKOFOFLsGQc6s1btG
	VC1AK/a6VWTMKrsyfbKzyU4GUKpOte0viVDFgOtS76iGQjykBAnr0sh8Mxqa8mxHeIJ8gtV
	dkbF938wtoV7JLxHdaJUOsw+KNfvviLu4/QPvHw0BY3OCqTuJ+piZk6yykKGYby7pC/dwmz
	K1Q9ySYBoNenScMo78SEywnknizrakeg+nZqyNbA8o+IF6xFMXcCpnfYy/nYqWBv/jwQCEv
	BFC8ridmk5cYT0wSXMymkbIBD3SGZ4j+YlkTazxApYYxDDmZrTp1+pYAr47t8oU0albteer
	9LlwlmwoF1gIZYf7N7ZI2B+D58/ZcFp0t7iJYM0X+yOkcBSlS8MKWelDKwjo3mxuzuSQbGP
	SO3eBMaA1SzN3wDZ/WIEAbrNsmJbRZ2xDWmVoykG8zRDipkWGa4Yq6ajF+b2PHIb/XrYp+z
	dF9Cpsdr5XDLSRJS+whW/0OeSmxH13nUTKhOzp6uNXgLWH7sS2yA8FKewtzQhLQP31KgUxU
	otSMnL6vVuxQeIrWpTe/WW2V6icVvS4+Tt7yL8pLZZC/4io8r6WQtfFT1XrUjXbndsYei/1
	Y8jk8P2isZ1NQjhsr8/9pehbhNs3qMXNCppoxbfTNpHOIQalRsjA0JPCLTzkVtwp62aMi7V
	U16HvdsaJeScRfJAGBcT/vt0dYkMtnWmxia7U0Q0I0PBHhwDv4ujP941S8wTM2aTIVP1Uau
	6NZuZJ2FBkEShVtii1mmOw9vCPGXLiURiMtWN07lkebsGAP8Rcw0T9Dzw+zPqAS93OgN1Hd
	FxKBhqMb5hd+EL6EKrIaYGtgAR3lHmNajAjt/DOZhKa/Qn8ZK6TwJQRoZ453t+hG2ByN3ky
	UOvk4BBVkh6WROhgnhseeHfX5cTK5Ku+P7SUg3WDSPQqQRFwUtTchj19zKwpWGvjmgPR2PR
	QbBqw+HhGT88usS3zYqCUVJgJoE7BIiRO3kcBam5NON/K+sLR3cUmmcAekhHg4YMRvz9RH0
	g==
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
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

