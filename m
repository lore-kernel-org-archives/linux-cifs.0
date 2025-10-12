Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.65.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437AE2EBB9A;
	Sun, 12 Oct 2025 15:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.155.65.254
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282705; cv=none; b=O2UxXjTA0Y38Fk3FgX6KkbDQnt8YUIoVQJ/M5Rwi+58nSFsh1iCkeU3Z6OFrIjpCwcMPccQqgjraHiZbq2gh6ORpjku6r4I00Koo8gFOiWE2KLdKRgGmwicJTjiiNT5Aa+LPELSXzjkGV7rXAHPq+yl+FK0Wc69rBGfbyloUzbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282705; c=relaxed/simple;
	bh=4Ay36zznrd+WMNPrQQPEHfc0KoAAcKYIuJn8+wlxfOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EN5+ELqcL88yrDM2Q9/lrnlJRb2ROWz9VT1Cy8zN0GKMzSeRylZUduuliMO3JPYcXOxLRZf5Do4274PdD5nYg32WmGc+re0qs7O8irm6kTiGFZ26SAKXNMoQONkn8GMd1QLnZBGVR0In8wOg1d67rSSZlJt+QzIJX+2maN+GpqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.155.65.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282616t65fb01d0
X-QQ-Originating-IP: craT+gktskjlX4W6oNrSIMH9LfKfxbsfyeX4W+4ChXY=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:35 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 430482582075245592
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
Subject: [PATCH RESEND 15/22] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:22:40 +0800
Message-ID: <1FA889978A6A0569+20251012152247.2992573-16-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: N0HiiCrR8++BtNyYp2YHEa5LEBJ4+qP+QBp0tDnevNXt/buLReluTems
	lQDXgT4uakFesOhL8ziJkXEndumZ6P9JdLNF5zAqFxb/A+4BDR0caSsHHqX4N7d9uFCQ/sW
	5Gz4rTDeKBYZr4Z8O+GSDZNCAPNvSOJ5GpsROBZDA2H2YEj7Q4tT3lBRdfr73SH/n7+XsAM
	FP5CUtDvG/o5ffDXays0O1lnRLVG8od9FmvOhPmuC956DFQvnfimAcJhfY6W0lBigfY3q8o
	iOdX009zfUExLb9J7bLheFzgxm9Q4ir+I0KO6amic9anjHMsyrVDHW8UUbE+/hsDol04e30
	i2fU37TTAfvyvUiQt3iYfhWMXmE4yn1v7oEF2r8BiCQGq1DJho6cu5WM40Yn3xrSvGFQmdW
	N0AQZslyPEOZLQqKsUgBnMbn73Uz6gO7/Fwuq54WQnAgGaMC3Bzv54hrF4AKDn0kxQ6COwy
	Jt7lFpElmZzHgyhNQeRu6PDMAJkjaQxMuI4Rxb42A/fqMlnOFfeOkKulyimijssptrbvzbh
	gz6xawVcPam8PlgLAcc9SpS1GSCOh0ttvE8upQyVQHJqOPbg6uXZ9NqBHGw3t5ift/IJcyO
	LR9LkO9QTyX5DBIKvQdA+6mKELPVkeixysmnGE6IcFRSti8JUEC34UDCxSK8xl9jaGoDv3y
	pyQVJ3twVcLCxNafWsoxImO490ghPJCLeRCFqTlac7/KC5r+95vMDwLKGhM+EvkI4wCquJT
	v8fP6LD9wsr+U1SAFXiDJZZmrt2is6JSlWfuBsbAorQg4hzfz4XImREFKIwomxvBUTtP9Fu
	LQOcAuegIjMGsplla5seCBwzFQ0F4/PKr56+/NufCQZz7nU647ne2rtLCqHn6C7E78DLqPY
	mbVOkAy0sdrqT6B26lM2QQYnoUuN6DumtIBnuehJ3Hfw/qZhVU047Og7f8Iar0olORONWtd
	/FFb0NTJokh+kvGIS5IQyI+f7YUSgvYJ/Bv3h4+J/Ny40fVNXQ9qfvULufrEl0k3okfTcJU
	hBAZMZHAmRVY5xnbflcXNqIlpqh37Go5MrjaNPB5sNBU4Vn3/IGZAP2NQkZFs/VP5FSFWnj
	YPzCE/FY0uFdqnYAUPkW7MUODUAq9lorg7MJ8CZ3sQtyG6CdwgKHeo=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct filesystem_attribute_info" to "FILE_SYSTEM_ATTRIBUTE_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 7 -------
 fs/smb/common/cifspdu.h    | 8 ++++++++
 fs/smb/server/smb2pdu.c    | 6 +++---
 fs/smb/server/smb_common.h | 7 -------
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 07eb821654e1..a6f7e168961e 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1937,13 +1937,6 @@ typedef struct {
 /* minimum includes first three fields, and empty FS Name */
 #define MIN_FS_ATTR_INFO_SIZE 12
 
-typedef struct {
-	__le32 Attributes;
-	__le32 MaxPathNameComponentLength;
-	__le32 FileSystemNameLen;
-	char FileSystemName[52]; /* do not have to save this - get subset? */
-} __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;
-
 /******************************************************************************/
 /* QueryFileInfo/QueryPathinfo (also for SetPath/SetFile) data buffer formats */
 /******************************************************************************/
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index 1109c20f7bf8..560900617be7 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -348,4 +348,12 @@ typedef struct server_negotiate_rsp {
 #define FILE_CASE_PRESERVED_NAMES	0x00000002
 #define FILE_CASE_SENSITIVE_SEARCH	0x00000001
 
+/* See FS-FSCC 2.5.1 */
+typedef struct {
+	__le32 Attributes;
+	__le32 MaxPathNameComponentLength;
+	__le32 FileSystemNameLen;
+	__le16 FileSystemName[]; /* do not have to save this - get subset? */
+} __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;
+
 #endif /* _COMMON_CIFSPDU_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a46d4ddade9e..a05b04799c0d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5485,10 +5485,10 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	case FS_ATTRIBUTE_INFORMATION:
 	{
-		struct filesystem_attribute_info *info;
+		FILE_SYSTEM_ATTRIBUTE_INFO *info;
 		size_t sz;
 
-		info = (struct filesystem_attribute_info *)rsp->Buffer;
+		info = (FILE_SYSTEM_ATTRIBUTE_INFO *)rsp->Buffer;
 		info->Attributes = cpu_to_le32(FILE_SUPPORTS_OBJECT_IDS |
 					       FILE_PERSISTENT_ACLS |
 					       FILE_UNICODE_ON_DISK |
@@ -5507,7 +5507,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 					"NTFS", PATH_MAX, conn->local_nls, 0);
 		len = len * 2;
 		info->FileSystemNameLen = cpu_to_le32(len);
-		sz = sizeof(struct filesystem_attribute_info) + len;
+		sz = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO) + len;
 		rsp->OutputBufferLength = cpu_to_le32(sz);
 		break;
 	}
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index a5dd656c36f1..016ec93e6df4 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -56,13 +56,6 @@
 		FILE_EXECUTE | FILE_DELETE_CHILD | \
 		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
 
-struct filesystem_attribute_info {
-	__le32 Attributes;
-	__le32 MaxPathNameComponentLength;
-	__le32 FileSystemNameLen;
-	__le16 FileSystemName[]; /* do not have to save this - get subset? */
-} __packed;
-
 struct filesystem_device_info {
 	__le32 DeviceType;
 	__le32 DeviceCharacteristics;
-- 
2.43.0

