Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD412EC0B7;
	Sun, 12 Oct 2025 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282647; cv=none; b=IZuyJuXbNGB8HSZ+0P88Voiks4OOoBMujEznpqZZGpkubtDYT3WN8XxLd4X82650XIyLLNAWoho0R6T9ChbL9OlbcxETsPsQOF0K/4K2CBfjUHdBCCIIb1WrowB3ELWoCLRE0WjBqEuweyrDdGFGDTAPtYfqG/a4/MKa84U83WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282647; c=relaxed/simple;
	bh=kV6Tt6gzqKXi9CitHgRtyQsuEujD+nsj1u8QElwcN2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHV1vJQaDU8g4J3FG7IYuM2Ty4gfa8EujOH/SYZkAiYjrloSO3f6L1iGwUQ/boLyWI7OHl8v+I/26ggUE05qoVAXUNXd7Jmg3WiQXJbS27GOq/Nz6XtrTXHfTOkngJe/+HTuERMvnfzBGJFF+eUOA6Jl6xisVIh+i4mGJPCF8aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282599t0ce4df99
X-QQ-Originating-IP: olbg9GUkYJ13Apvi9YjvnPdAJR39vuNa+1wqhxwa5n0=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 10096801929206056955
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
Subject: [PATCH RESEND 06/22] smb: move SMB1_PROTO_NUMBER to common/cifsglob.h
Date: Sun, 12 Oct 2025 23:22:31 +0800
Message-ID: <BDA4AA331718B982+20251012152247.2992573-7-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
References: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: N1XPkwwy1iMW79+htjH2Uo6VPBv8ihUl9l/e1wsatF2k8m2u9V1ZBHWM
	H8rjGXRN+oLW80L1x3PYDOZcNQE4zvQB/QB8sAA+IiR/9xksVZVvRAUWE9H4nGrOM87hy0R
	gV7xdwFJ1IEGUZwxgIKIoWayAn7/bscY5HpHzZA1o4Z/31UmThTd8Rao5GzM3hHA3SI9r7m
	Nmlhcifg+tJiha05Y6gcGbgk6DHNxdS0wYu70RuBNXUgU3ywOWSnCVM2HaOTJ/Bwudi5sxD
	aRfHSIHkBDuE6wISllUoIlVfO1lW/garB0qoMMLGfmyV9m6mPAxl/lrYs+GdvccFKcWtH6U
	PR4LMLgquxWTOBHVUedGChMRlyJWnxeBTT08r8WLokBW20+tEF/eDU4Q/Ll9a2W0OB20K8d
	QvdZaxZedbUUcpEMXkcD4waGBzeoYlGSKefPWRd4yKmU2cZc8Z6/hVUGGFuBimCopdP9Ufe
	pIILw/l+zO79l6bC176VhCZMOVWB3l5/P6Ct8iD3UWWfTuaUhkAbbAzwpfCH7eXDapFZewk
	PbOKIGJlUbyFKdcnM2NSexCyqYPO3rXdbmb9Jw2/UOwgNoMy6SzZ4YgMChXAXpXWqni3ssr
	Ue39qWA4zVMXnYmIqf9Rm0p0MH4g+Yln0bxXaRVTODX6/XHlA57ezwajnkzm2OVoa/9tsk+
	S5cahKNGxI/Me/LItfsJTKYQwEyjcE0PTywttDvBjYSf2bM7bjyMxoNQBlElvvTXb3eEvkC
	rzU0C/duysGRgCGNtvmy/GesSDdzZEwR75F09A/DC/GmrgUHIe8Evq2JmkkTxFwDGKvdFiG
	hUfuHGVwKSmmThI9gaauG5bkF7+1zidYlhUP+bjGhWVrp7fLaX31uhWlSFroukRIl/adxUq
	a2qR1BG4wAWToINBQueGd6lPB0CENmgp4SdCsC+vKDr6QLTpbC2DcXvZh3fnYQi0KICD9bY
	iEmcn51WX9XXBURpBeJc6TmXRGBeBDXiTnMDSx2IEdxtNTnQDJuOFsjX6Z2dP0rQX4Tbsjg
	Ynq/LuI1qrIhMRfU1iO/SHkGxIs8JxA1o6SS4DWDZcJHr+XV9UbGJdm7FpyoYWbuH6GMfye
	Q==
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Replace the constant of client with SMB1_PROTO_NUMBER, then move the
macro definition from server/smb_common.h to common/cifsglob.h, maybe
the server will use this macro definition in the future.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/misc.c       | 2 +-
 fs/smb/common/cifsglob.h   | 2 ++
 fs/smb/server/smb_common.h | 1 -
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index dda6dece802a..15be9d8738ab 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -318,7 +318,7 @@ static int
 check_smb_hdr(struct smb_hdr *smb)
 {
 	/* does it have the right SMB "signature" ? */
-	if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff)) {
+	if (*(__le32 *) smb->Protocol != cpu_to_le32(SMB1_PROTO_NUMBER)) {
 		cifs_dbg(VFS, "Bad protocol string signature header 0x%x\n",
 			 *(unsigned int *)smb->Protocol);
 		return 1;
diff --git a/fs/smb/common/cifsglob.h b/fs/smb/common/cifsglob.h
index 371160fec1cd..5928d35c7f30 100644
--- a/fs/smb/common/cifsglob.h
+++ b/fs/smb/common/cifsglob.h
@@ -9,6 +9,8 @@
 #ifndef _COMMON_CIFS_GLOB_H
 #define _COMMON_CIFS_GLOB_H
 
+#define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
+
 struct smb_version_values {
 	char		*version_string;
 	__u16		protocol_id;
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 9c0db206624b..6d427dbed5fd 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -151,7 +151,6 @@
 		FILE_EXECUTE | FILE_DELETE_CHILD | \
 		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
 
-#define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
 #define SMB_COM_NEGOTIATE		0x72
 #define SMB1_CLIENT_GUID_SIZE		(16)
 
-- 
2.43.0

