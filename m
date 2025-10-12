Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C632D4811;
	Sun, 12 Oct 2025 15:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282034; cv=none; b=qEfpqlAs/oJpKWMKtwAh+hrritT5fKR4d4kXMkD3yHWoM487fGSiHfNM1g85i3XrEihvSrBBNt325CBrgbufbHQCqLDEW4zLBZCYk5HVXDmlxFDcFCwjuNWbTIqHYIXYyh3mr1fpWcdwymu/034rpOCs33S0sM+Ah5yzaNSvGJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282034; c=relaxed/simple;
	bh=KmGhgnmR0m6tPFO5dxwalQMc+FUg7axJAvjjwY79eSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoRAamhhssHrz1B/aCRJUfQVJb2ZeD/hqDHYMWkxncqkZix3tYdlPRO7y+QzRj5iW8sPbSHUaxXUoSRjVJ/VJ6Y71aweibmLpjTpwI0bY4WU2h3iEQIyT8InJ8kGrU8oq874Lf14dQJXvYsvUefA8o1AxvDNunnz2jPVPcnbM5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281843tb4056b14
X-QQ-Originating-IP: O8NCsxpoFbbNOGB2VfxrgACmU0PDhpsTdR75H9SUsMM=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 8342795331192969578
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
Subject: [PATCH 17/22] smb: move FILE_SYSTEM_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:09:10 +0800
Message-ID: <7482C656B44F9D07+20251012150915.2992220-18-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
References: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: NUQYy/ZVsQW1A7zrq5uyCMga5OkFMn41YGDA90r8Ik9ywGcBkyeweDYu
	iJmfWUEq8mTnoeogyJ5YggAFhS3RbtToyoAYV8jvsWzVncGS2TXTuinitwop6G/c1TGJ7zI
	n4LM+lBrtcyv3wOcaVfoKKOX8shxRn2HzENpgvFlrrsszg31QS/geNEUtsnzjxYdc18M5Od
	TIUwAu5ZGkXpMJikhGJ/u4uDMVjOLNKhG9CsOHXmx6Ltw29ncHIUhiE84nXCVRQ5QsuVbBD
	CdkqKe3AcZ0F+I2ThNvUYMaXHlQ6mF9wPmVIJx/uep+v0VHwg1fxBq5sJCDilQ7SNaOpdUe
	VjOcF8+0c8unbbv1xL2drTQMKGLLPOjD8tJ7swOKok8q7F3uPhRNDRZn87wBUpQiWlFpq7W
	myG+9uBNlFaH9j8bY3Nf+P8L0DeIoYb4st0nAxGL0L/uuh+DaUSWf7nuhhpX+FfcQb8UcHM
	vBlXFkCF7P13vAeRBZgXN+yS5BYai4cBbm6J4G1AhNYBLDB2mWoDv9MLZCtd6fGTL3Ee74P
	IoCOuzNRkdKG+ic3SuAeB34i+sI6v/TcB/kOW8cJuEPrlZiQum8pGos+IO5n9Gxk+DOF0EW
	hq5PNs5njp164EKv+wNbhwc5+X6WB5EzP0IxKRemanUYv4DKnJJhPCgxfOwBXDqcLIJ7Y/w
	ac971m07SBNX4/CPVynA1xLXKRQRDypmJtO7BvOs8eMYSI/gJJC/USLd8Pol6gnAQANAWbq
	0j+hMs3weNnVQ9vAYKYJlPzCjhdHHkGEwZHTxLLP4+ZK4JGVQodmDHxHYwAPWykc2fc86HZ
	x0wHc6u15JTn3rjP9hVwYPvRJoPGgwl9z0WDU9QLTEJu/biOMU70SvSmiFGRYr8F3tKZuta
	ZlZIe6ONY50wW1i7xgzaVwd62BFr4PZZOCLJCf5z8ruyRBQDj00ZTyujjNjYcY6oUu3yW5z
	P1rwk1Fo3OoodXSj+xiBYyQoVplXnBZjbfCafjfrSAZgPsiUpwzHkL1d4FXocoXGnMYoPTC
	Nlrp7a73sDZ1EQl0HJVbIINT2+jdlov2JzXLkEl8sSruuexDOWpb46u/5gah8=
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct filesystem_info" to "FILE_SYSTEM_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 7 -------
 fs/smb/common/cifspdu.h    | 8 ++++++++
 fs/smb/server/smb2pdu.c    | 4 ++--
 fs/smb/server/smb_common.h | 7 -------
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 17255d7a4615..889be409146c 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1819,13 +1819,6 @@ struct aliasInfo92 {
 	int shareNameOffset;
 } __attribute__((packed));
 
-typedef struct {
-	__le64 TotalAllocationUnits;
-	__le64 FreeAllocationUnits;
-	__le32 SectorsPerAllocationUnit;
-	__le32 BytesPerSector;
-} __attribute__((packed)) FILE_SYSTEM_INFO;	/* size info, level 0x103 */
-
 typedef struct {
 	__le32 fsid;
 	__le32 SectorsPerAllocationUnit;
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index 055c6577b4e9..548d621ec233 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -321,6 +321,14 @@ typedef struct server_negotiate_rsp {
 	__le16 ByteCount;
 } __attribute__((packed)) SERVER_NEGOTIATE_RSP;
 
+/* See MS-CIFS 2.2.8.2.4 */
+typedef struct {
+	__le64 TotalAllocationUnits;
+	__le64 FreeAllocationUnits;
+	__le32 SectorsPerAllocationUnit;
+	__le32 BytesPerSector;
+} __attribute__((packed)) FILE_SYSTEM_INFO;	/* size info, level 0x103 */
+
 /* See MS-CIFS 2.2.8.2.5 */
 typedef struct {
 	__le32 DeviceType;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 41167e7cca77..2ad46a11e7ef 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5539,9 +5539,9 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	case FS_SIZE_INFORMATION:
 	{
-		struct filesystem_info *info;
+		FILE_SYSTEM_INFO *info;
 
-		info = (struct filesystem_info *)(rsp->Buffer);
+		info = (FILE_SYSTEM_INFO *)(rsp->Buffer);
 		info->TotalAllocationUnits = cpu_to_le64(stfs.f_blocks);
 		info->FreeAllocationUnits = cpu_to_le64(stfs.f_bfree);
 		info->SectorsPerAllocationUnit = cpu_to_le32(1);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 86d18a8badff..d6351b0ee62a 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -64,13 +64,6 @@ struct filesystem_vol_info {
 	__le16 VolumeLabel[];
 } __packed;
 
-struct filesystem_info {
-	__le64 TotalAllocationUnits;
-	__le64 FreeAllocationUnits;
-	__le32 SectorsPerAllocationUnit;
-	__le32 BytesPerSector;
-} __packed;     /* size info, level 0x103 */
-
 #define EXTENDED_INFO_MAGIC 0x43667364	/* Cfsd */
 #define STRING_LENGTH 28
 
-- 
2.43.0

