Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A662D4B4B;
	Sun, 12 Oct 2025 15:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282043; cv=none; b=KsoW+ZcrWJgknjEGO3aXtYivCgGPxwf9ccTtvvmFcmYl7BpW8W5crTyyNcmQcyinoUbwZkG7ptRNHIOStT4NWGqxAZDKoqWR0DsRiX/cKRoxWHgsSqF3LQGJg/NpayfcOuoCb+U3MELBL/QtJ2/vhgHbK3ehqzEAOTr/ekAg7pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282043; c=relaxed/simple;
	bh=4Ay36zznrd+WMNPrQQPEHfc0KoAAcKYIuJn8+wlxfOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r12dj4gTdKMTcI3WP6f8ruHr7KNbuYCyRju+swJoaJA86yIy2FDR9f5paozwuQxnfauP5r4aQbdhvqmkaYkGiaImeJzBdmfibckzc1AcKft94QQU7wxDQZnvv/prDalrb+pDjplPeglaYovFKYMASEZTgi2toGssYdRZWSKEcwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281838tc1667413
X-QQ-Originating-IP: KEWc2dv6TUkFtlwgRjM9+G8+sFxO8eTcrlw482yS4wg=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 9307330599300135030
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
Subject: [PATCH 15/22] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:09:08 +0800
Message-ID: <1A32D9B7A1FC95EB+20251012150915.2992220-16-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: MCk7GSmjSGXygIIwCP2q1ixW02VYsZ27Y0jp6+Chy536boC3Et2qQdna
	jF+ID//47ZlqpsqVammmKWv8v75y/7UDrnZdtouknlx7CT0iVPa3tlqtXTwat+h065Ay7UD
	Wf2hZc/dB5EsubI6DrIyIZnMpTLkzG5WwgbQa7afLPHaRFkXs79i8eWBUCpI1OZabDojMk6
	YXo3qpyx+W/krNWrhMCSREJooIZwlW0yAOftexD1BpDFQd5ayp9c1sUnETUHPinGhuEs15f
	7z3xk4z8Tgdo9WLX6LD2V1MVmGG398gSGVI9LlHWjQLBtyR8sipN38Knk3H/zF9+XR0KVHr
	Gi1qv7baMsmsDbjkO484e/R/ehocXKImkrz1e4/zknfVfaBSMGGjWdTdWB+iQTgZoz/7Mk3
	7CiZ8U357L/zHR2bwajNmWIZORm2nBWhadSELbveHqhflUvLQYHUTGbrXuWcn42LJJNAXEo
	4YMunPHRIRSFfZ1swOcqmNJS4t/U/5c3WlKuUdhgAU2+t+T71dxeGna7Eqj7hcd3L7fyDz9
	UEoA5IDbp8xqJPXoeHLoEl1+AnnuceeFQZFXOpIJ1A7e425urcSMNCKVXh0tv2DZlKTtf5o
	tsR4aP8pmemmBZSwVAyBaRb2dCUKuOxiTLG+gQylcGyWjTdFf/cSwjFVTQX5iJunZeD6GKk
	NHfmFUgpqxrjrp9+Qo20fJR5BOWB4EP1yA/0W5TIf5W1yaKw7/PBPsvgfIjkTx1VHuU2Fr/
	QH4grfelpvlPyyxtUcXPpqBFJssGDwJX8GrpCSjbJTWH0f3xukCo6h6T4JRsU7XqqE/4coz
	MYKLdOznoleHLuxMleY4K9DQmqN3Ej8kTh7FG5OW9+ppdD0B8WwLNvnlrmFNeCRTWTkCFwC
	U6fjLwobIxO+Zi3sYvKzCNbgwpkYfpUU9mXLdvZ3+H6m4MUab/z2aRLWHhqhvSOsTz0STwH
	PBFu3Tpx3Molb1cIVk8s7t6QaJBTEBPjFH7TQWFgHQb60068Mp9c1C8yQiRDsoDwHmJSV/W
	zo3i3XTW61Hc0TXaA7sEWl6FFBpNw=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

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

