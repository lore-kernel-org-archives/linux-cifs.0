Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A141720FAA4;
	Sun, 12 Oct 2025 16:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760285935; cv=none; b=N2kx0YODlfZb0oqrjGtvw6w3zMBXv2G1tzwLN8PEH1AewZtCg5BJzW+SC9y5fSghlkW0iNPgI+XwqiXSh2Zb5NHhOIxGbm7qkIwCCDTwrRPgndE/L6pwrrr52Guec54uMjhg2YrjUnaEatAjfhLZxoV8Ztrf5/Cc/m0rR1B2tRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760285935; c=relaxed/simple;
	bh=bhr+qTVya/+V9+BCjxfG4OVqLhjJpgZpWmo1XscXVvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d3FeczARspyWwL1mhErm4DCOIx90XS2BVgCW1qo7K7Pu7MhfBY3lOoDGiDn3DGt4Vcnfs4gh5fIfBvtwLlYiNe0jf/VJ5jLtJD446lf8tzU3AmITQuL1ueMv410tCHhUPE2IhsvsmtZXL/43vCv948CjuMGOAP/kpA88hZ9UB+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285892ta72686ff
X-QQ-Originating-IP: GgNdDl3AGe27E/H08SS1YB4BCbf6F9J4D0iDbewHgOQ=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:10 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 7517991960377754638
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
Subject: [PATCH v2 00/22] smb: fix some bugs, move duplicate definitions to common header file
Date: Mon, 13 Oct 2025 00:17:27 +0800
Message-ID: <40F04A8E2145E761+20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: NSEFX6u+4l+KjVaGc4WUFGVI+QWLboSo2NxHhuN0Q+kkpmZBi9QS1FCM
	yRU8nxlWWEPgLqbobg7MKBtBCsHjM3e8hHZmetfqCzzAFnpmJtCGXmrQ/O+2R5eByfdhWND
	LUsvyMTXELyP9gkIO9LJyEcJNvGbcpL86lx4Ji8OhypALAB9IQE7oThWMaJ7S5bopIixhFw
	P8APpdHC5zkhw4S8SdIMcPNDjwddc0aMijmMuuAWPlIHoHcAYLmxn4x1KEHcl21m6nhrzyh
	obdPUCJDTMW11ajH6MtumOcBUW1YeWtS4Wr2pQ1obsteAS29xTTjtmajjIe7s0IRdrTffSH
	IKbK9WDxzro+ROPxxa/d5ov2/kS0gb1iaDrw6PW43b70PSlDoSA9CTGgVMv0g2RvYVMd6Co
	J8BeEZNWusHbK78flmZcUYqqknLnK09xzSajhpOKIlfQYW61tuxEK5RUt/kf7j3JQJqJetq
	Tl1Il8E+R5TjN7TUG2EctI1LOXLWVg7BJfwObr5HQj1cjQS0GDZqYIdp0mPAsWTEwSmJ+B9
	4Mbq42wTZeeDFle5tEndTeLp5nWXv96udUT3vy+SYv/0HblcV0PfZABXDvJFhlNwM4QcX6c
	cVcttKM1irl2aoBeO49BvxE3uMTkpa9EqoiMwdct49rt16bi8NA4DDu6RwFSIcdZAJtCgZo
	2qfdBk8LZqRfhtKrGoJRzbftdwfcBJGHgs/kzucrhRMnRF6I9iIJ8sudCb705S1CZs/ERu3
	hRoax1upiMJKpNUA2bBKiM3LXgGuEdRmbufySMTrrQsH4Fvo8ClVbbyOqI3e3CWGtSfIoTI
	EQE0o+HmTKByoTijb+Jz8Y1yhEt/DjKmKqn3+S+EkHtuniru98vq5HRZZxRm1CFGoMng5rg
	d/f0AQuWVzAEl9bogMn0dp4AkFkuGbeOt4jfESgATi9kfTnXwO6+pB1VvHrKTTELbRwGsaj
	x4ZwgA1YWsLSOjGAdteJ0ZfzIBDtn0Ram1R2M8prKHoHdHw1hsOY8m5Nu
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Fix some bugs of smb server.

In order to maintain the code more easily, move some duplicate definitions
to common header file.

Add some MS documentation references for macro and struct definitions.

v1->v2:
  - update patch #06 according to Christophe JAILLET's suggestions: https://lore.kernel.org/all/d03c64d2-46c0-42d8-8f88-28669e921c95@wanadoo.fr/

v1:
  - cover-letter: https://lore.kernel.org/all/76A15C078023E21F+20251012150915.2992220-1-chenxiaosong@chenxiaosong.com/
  - patches: https://lore.kernel.org/all/029014EF18C9D322+20251012150915.2992220-2-chenxiaosong@chenxiaosong.com/
  - RESEND cover-letter: https://lore.kernel.org/all/37DF3D711BAD3621+20251012152247.2992573-1-chenxiaosong@chenxiaosong.com/
  - RESEND: patches: https://lore.kernel.org/all/9836A3F274B62345+20251012152247.2992573-2-chenxiaosong@chenxiaosong.com/

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

