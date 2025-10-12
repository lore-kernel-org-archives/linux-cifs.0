Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.65.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8006C2ECD31;
	Sun, 12 Oct 2025 15:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.155.65.254
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282697; cv=none; b=ZOGwjnWei9W/Zfc750pa675XxXvCz/NhbevqEYs14A09puWMGf4PSMhR0I5JvVlI2Q27yNQns+QFRNm6twtTAFdMqdG0IAnXrnVOgaoaJxJfJrerYjjFsbKstQYrtInDVeQlQjrm34qIvnK2OEbQP/hTjC8gbzUv/z84NRN7LUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282697; c=relaxed/simple;
	bh=KmGhgnmR0m6tPFO5dxwalQMc+FUg7axJAvjjwY79eSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+qf1hDd4yLOYwZltqMeCfdUXx1v+Ey5fUSaN00NxdD0cCHltIzAkPx4BE8nVUTLcmTpoQDoENfKGAlBKklsm1eAyVKgFeG9K4yzrF1BKaK/NltmPs05AunxrtBtfMgdPLme/F+ZStpIHsewh3ue2g+q5yC+9VfM1YAd9ys00Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.155.65.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282620te2ef787a
X-QQ-Originating-IP: mB9Tvz+B3H4nh9qgrBkKnb/H0zB73bySp1qG/F9K42A=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:39 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 569916743627832152
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
Subject: [PATCH RESEND 17/22] smb: move FILE_SYSTEM_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:22:42 +0800
Message-ID: <D413FFAC570F9528+20251012152247.2992573-18-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: N1J2wcMArduWMf6o7EmVDmgNjxFH7i4q6PGIDR8XfdwMBuU3GHa0Cj9I
	KLvDxQiYRhABfz72pxIjQBxW8LaVl4cwY8ssiuTXj2/TwgFFMy77Y+0I09FdIL1Y4Ewzu3T
	Pzg3XWcd1DE3fC8YW+sCoMggSpllFu6UwkY/J3HJopP2EQhnKlu7lw4lwMfgZnQNXR7W6NH
	DOmYGAje8ogmUoYP81zedCbEr1pHtdbK2JWZ43EzCKUESkq1cQqFEPHFK1oeoIh9qg2on29
	GEIdf6ZYBTab3KLheHD9h8MEbGd8iE4xf1CIOSAeUvTqMQvk0MWc569srCf23Vbt78p+pdN
	5XgQq4DH0r3lo92ObplzMC2lXoufxH04hdYCGcx/7s8EGGgDllYOrtbuHdNmH9tSeaPx9SB
	o89dDvqMJaQSo0qUwriQ/Z4Om5my1wdnUo7zEc2y/w21+bgo3dT8Vs74+6QizNLNANoWzYd
	N0WgAO+X8DE0iyUVdT2w7WSEgCYubt59SV9MY3DL7UBtbCtcF6LAXjCFmSs7MkZ+/xNNDTU
	kXPHGJviLenGhvjTFehvr5f/BmEpflOrWgeTpo8NHOXs7uV2l+R2oz5TiLussuX9svMaSMO
	SmgMzHcpgeKA2hPVGbzGPD/eGSMIVbJl7oszwUTi2NW5mvH0CI8RX5TXt+G8cJAydZcjXyz
	umATHVsNC8yJuKBK/VV4tX3pLGmEbkZOlELt6Lm5fEJ+4XatD9wYNrhrBTeMsW6SfAXi1ib
	OW1PW6XETXBzqW4YoDXN67z0+zeneZkRY/2HJYK8yMh7tCPoRizt1jI5h+LsYrFrW5UFQoU
	ESHqfB4zYooAYcuKt5fCH+CcYXvdgZmDTltzHd6gEf6Knoc0tjwYajzObFtpI2fvB3T0Js7
	K3kbz2iC1AoBN38abx+85Jf2mX8GrZK9jiSj8TPwjGuLtKrtvA1VDULSogxGBJ16EFypBb8
	HCKHOCSiuNE7fUB7ikjGi0UN/ppSYCs/iUtn9zVlv5mRz6UaUhJ5+ssm7tBS4tm9ksBVcbv
	FkQ9MBzjoZyvvmYS4w/2UZgUlhsyaeDsjc00cz5bv63nySxwKDmttqpiVkh8OCAnKxp96GI
	nJgDmgwsyUDIb/YzzLwfFjRYf8Zhm7SbQZ9LgzD8HCbVVVRy22o678XpKOOnkEcMg==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

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

