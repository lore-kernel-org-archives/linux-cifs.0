Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DCD2ED17C;
	Sun, 12 Oct 2025 15:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.154.54.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282702; cv=none; b=nO98+Q2UWGaK+nvtuEesCixaquQ/E8oW0qybQu2pj0RBjlJDS7MeABofCpQpnYOZgyE1U0/PiVEiAv5IQyT1o/aOh6MCR3TaL7ydUUBtd/KDuyCMHlODskpiNPPPYK+dRtnA0eqldsK67WPe6bb7cuVPaUSnfonnpkzdyjMARPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282702; c=relaxed/simple;
	bh=9HFwudJ35eQC7DM+YM0J+EEops91L9kfN+PkBQyF7N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAS4LfJov2Yk3oleK5VZY7xP2GxI4oz7u3AVLkl8ilxf/ba7sGgZJXLyhW0Hy7kzZnKqu9OlEIQcdn6mHnDuSTb7vcSeRl4QGictPPk4a2ztnrgcGPxUXOd0I3bWgiQlob2TGzyQhrTb7o1yVhvZcXa7GAHYP8a1aEw2vPTsnAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.154.54.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282618t83dc7f48
X-QQ-Originating-IP: swB4UBzIQbi/jrfS/n4KxBlHtydB5Q+y0YyGPuS5flw=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 11084623537245727206
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
Subject: [PATCH RESEND 16/22] smb: move FILE_SYSTEM_DEVICE_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:22:41 +0800
Message-ID: <7D44C66B3B7BCF29+20251012152247.2992573-17-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: NngiXi9REd8/5qaz1mPQlnLym0JBM9HU2HxFCpf/AkA9TQ/jMVUaxjTQ
	GRhYqIRxDC3PsVg9S9KtjtCxbNkzvKC9EXqzvBJkXoTX2bSHNESmPfCp+4/Ct5B7ZHTZbec
	HN4VVmLPQ4EnYL4WOEx+AiuEX/cSZ7DeivkDupqYV3z8VJWk+DXZkmmj0fW3EB+rml0cm9d
	0NpZ1n6Elrr0J5XD0dWHhlT0Ac9QN9L/cFhxjcktys7mRNKc4FoWOTByU2sUIVlDk1WOm1V
	nYFJcqRiYPCJ8WXcWMsQFaE4WNHNVZWXOP6wdCuwsh9oduQON19LsBIpduI6F1OstHNBizb
	GdCYzfuqha1ONaoX2xDgpAblI1Mnk7ZnVYKRtlv24qhUBOKPMW+fO8ikhZQknRgDXt4u3GE
	YF4aMpEAZ8t8IzUoiRpLop6kuqpX4OzJ0GMSOa3KE76II8wNw2Diaqyl+W4Mfhx9ixLvSFX
	0A3LjyIDOojlG+Ep0xAaA+EsGdSg0k/ACU/uoa9Abzv30HfxEu125oVHJYBsGONYckn8AmH
	1v2IAm4UJ3sb7Y0q14vw0SLyKR2GjUCF5rkLbzAVlBUC5LNr8gSHd8KqNXDcMeL979i+UnN
	NGDfLrUmunDZXMKJ5KZMpTK1H7Ir/LpHrrvXo01EacFp1Er0OlqBhulmC1J4x5pfmI3tT3P
	m2yruPoy+4BINonpMUoPxp2Uw36CURwyQcg4or2cz1KOszLwGAf+Ejx90tZZpS70c6Kl4w8
	38BVikQ0p1kt1rcyVSvN6lMMntB+x6qS+K255WSege2c1sW0LR4iHGqEa2gGvQB3xvMXbSY
	TGdt/PD2Ds95Dh74ZJTDIW3TJXyUqxUzwlleQMx9D4UNfuCnadlR8pizChIUbu+ZDckHrIG
	bZUg+8fywSYrzDN/DO/Q/ZUgHDjHHXKlYYnG1Afak8/jdsdJJWUL2blrWqw98VUUQjvpSg4
	yL6GGMZzB5n4kWLR6B1Q3/6zJRaq05mL9UucvbdPMFuWwS0Low8dVygImk9Z2yP0gsojfyM
	NPqDgKpJY6IkTnT723Qo7RBzus+yBKCFhixERW+JEvxIaoo1FSVFGcIn8dbyYOpYseEOrFz
	3rgusIH2d2RFt1evizhTR5ow5TIfuq25w==
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

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

