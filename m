Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF73B2D4B6C;
	Sun, 12 Oct 2025 15:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282047; cv=none; b=HasbsWJ0m45vBy2j8A01aip4whpscVjhLRLFk/pnCcdfb/Sjl6uGOvFmQJZ5htD3Uuvx+Lyl3NjOTo5S7hfB64eZuo7RfxN2qxEf2bvEL/pOnGP7JJHeCcQ26rP3nsO1msL45hd4bVnR59oY4On0VTZFZHQ4fmtVWxMQdWaKrHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282047; c=relaxed/simple;
	bh=9HFwudJ35eQC7DM+YM0J+EEops91L9kfN+PkBQyF7N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpCvoSwuojPd7Nl6dmmhvXPxAJbPfIRtb2tzGfuPGfWyvhpWCs3V/MQ6+8gP1KgPBmGr43q8T66XJj38fLbdqncAwu0fRcvwUtqtCKImnKpi7AluV37EvB8rSaT/fLNY7m6AheoK1WVqLGQeI2Hkz5G+VyOToHCi+vUYMenf+6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281841t1456560c
X-QQ-Originating-IP: KWWEKHvh3INoHrkRN7Xbbd04bPoigvjL67e5N74yYvs=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:40 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 17825794169884080643
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
Subject: [PATCH 16/22] smb: move FILE_SYSTEM_DEVICE_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:09:09 +0800
Message-ID: <035562D7E81C9CF9+20251012150915.2992220-17-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: OSjQccS6YHkH5cVH8UiOkk5eaaIB8sSr8eQ16Yp064PBGVX1bqF+gCOa
	nwc4PjXtq8sXt8QWhBbAykxSldZg/XtKRWDrOaSZQk/f8twW5+nnKULBtI+tNaWOJmcQRFg
	BCTrWIHIfKNm7U5Cui/TF1CuQ4MjdLprSdznJ5aW8/1EGqaaIr5UgBAILwOL/eZaM7BNGZ1
	0/e7P7MCC12tKh6whb3IVciKZKMJCCzTkmILfCI/NGSVLgL/hBp4x3jriT5BEIhXNSQcbCH
	HfbQfFJ4GpO/3KG6O9pqc9QhvtDPxHjCcKSUNMItMsHXW4jEsak1L11dk3XKqbn3RUi37oU
	yfWSSgczdIRSRIg3fB+vQP7AnOGYWqx3C9tNcMWmzNQm/aI2LW8ZXWO3dtQRPnqvhHT5eO9
	yBOCfEEK7Z3FfIn2yl8Jw0bO076SQnA79ShDztegDXFmzA9rUeJoG8zUKvsmKzEyls/5kzr
	VLBSQjaLYRvdOgmXaU3c2czS9AOUroiELPbCG4YeANBTJO/77h2ndMt1AjVf8YHFsmnnQld
	N+I2KwC6ROQJKwDomE0uLIpgvN79nxITGc/JFk5732mXBPOVNV4QrT/l6CoSgCWb+L/53wx
	hrzUBXbG8+w/IGpabIpt1UOvoG1UeqzeZwx13tt7NVXB1UabCJTSJD7JZ6iw4Cv/U+uu+IG
	OUAeXbEUIjGHKYrmJbRIP6kKga3LLErNrYI0aVB5pPuSObDS91nbFJ2lRENyKYGIpYuRFKA
	O9co2c7sUo03xkYfS11DhRjOjFPk1lG0X+rznBBMK55q2Uq8iA08IAaxYnyPv9LEa4sE3pU
	B/ZwMMUQT659Y5Q/qCxS4QUc1KtTy7RDmrOxeyuyPiu8eVUtxdo+OWrrwnx7QArbzsHpJhb
	VtoSzPeLEMohoSyUfcRZ6v62E8rafH048HFirr2/Y19NfENaoq2273YdB3fOafLiPOvFjbb
	kSur4BvRQ8d9OpPA/zAFwABdGfszhX1V6NaLoMOR6m4b2pHy6AMFBNuwYvVhK24Qdo559dz
	b8lBTtGJJZh5qeernrLqitEtL4+eM=
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct filesystem_device_info" to "FILE_SYSTEM_DEVICE_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 5 -----
 fs/smb/common/cifspdu.h    | 6 ++++++
 fs/smb/server/smb2pdu.c    | 4 ++--
 fs/smb/server/smb_common.h | 5 -----
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index a6f7e168961e..17255d7a4615 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1929,11 +1929,6 @@ typedef struct {
 #define FILE_PORTABLE_DEVICE			0x00004000
 #define FILE_DEVICE_ALLOW_APPCONTAINER_TRAVERSAL 0x00020000
 
-typedef struct {
-	__le32 DeviceType;
-	__le32 DeviceCharacteristics;
-} __attribute__((packed)) FILE_SYSTEM_DEVICE_INFO; /* device info level 0x104 */
-
 /* minimum includes first three fields, and empty FS Name */
 #define MIN_FS_ATTR_INFO_SIZE 12
 
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index 560900617be7..055c6577b4e9 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -321,6 +321,12 @@ typedef struct server_negotiate_rsp {
 	__le16 ByteCount;
 } __attribute__((packed)) SERVER_NEGOTIATE_RSP;
 
+/* See MS-CIFS 2.2.8.2.5 */
+typedef struct {
+	__le32 DeviceType;
+	__le32 DeviceCharacteristics;
+} __attribute__((packed)) FILE_SYSTEM_DEVICE_INFO; /* device info level 0x104 */
+
 /* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
 #define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
 #define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a05b04799c0d..41167e7cca77 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5469,9 +5469,9 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	switch (fsinfoclass) {
 	case FS_DEVICE_INFORMATION:
 	{
-		struct filesystem_device_info *info;
+		FILE_SYSTEM_DEVICE_INFO *info;
 
-		info = (struct filesystem_device_info *)rsp->Buffer;
+		info = (FILE_SYSTEM_DEVICE_INFO *)rsp->Buffer;
 
 		info->DeviceType = cpu_to_le32(FILE_DEVICE_DISK);
 		info->DeviceCharacteristics =
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 016ec93e6df4..86d18a8badff 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -56,11 +56,6 @@
 		FILE_EXECUTE | FILE_DELETE_CHILD | \
 		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
 
-struct filesystem_device_info {
-	__le32 DeviceType;
-	__le32 DeviceCharacteristics;
-} __packed; /* device info level 0x104 */
-
 struct filesystem_vol_info {
 	__le64 VolumeCreationTime;
 	__le32 SerialNumber;
-- 
2.43.0

