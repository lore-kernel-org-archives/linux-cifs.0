Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795CC2ECD05;
	Sun, 12 Oct 2025 16:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760286048; cv=none; b=jPFkEwlcBovYgARqfqSCKoPaeKLBg4e6GFjwHHcNewGoTawV6ILZ6Pb+y/3g3K0iN5/BrskDPlcYuZJ8EbfBMVagwKQ/CYRAe/uJIqbY+6Kd2lvPuIadWAzYMqK9IAXATiGfedmn2dFpUjNiSlRuC3s940B+RVtHwYz4CtvULOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760286048; c=relaxed/simple;
	bh=4Ay36zznrd+WMNPrQQPEHfc0KoAAcKYIuJn8+wlxfOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7Id8sJuEu8KhZ8+5j1eHHO1EJmIXNX74IJ5DTB9qtyPXsVye2paK3yaxbvVAQCG26YIqz7S/FzoS3iJ5+Zc0OFxDKuTRNcQJxfs0xTEcIbviWLrQkO3k4lTID5oTXSJt2MvoQ/g4Gj7PBCF5n7t5CAu24mmbJjdiv9fDUGCcIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285925t29840cf3
X-QQ-Originating-IP: NKFaBcoD/K1c9anJnQW9k70N2J2NscFG9Y1a/wL/CxQ=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:44 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 9191251187041815914
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
Subject: [PATCH v2 15/22] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/cifspdu.h
Date: Mon, 13 Oct 2025 00:17:42 +0800
Message-ID: <EE3FC07AAF8ADDF9+20251012161749.2994033-16-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: MoZqUia8aYdxbbpKak/ejKTz9keoY9GcaKI+lvlOND1Q+xY4czaTwMNw
	Ym3DwLdNAYUeVRbEb+O7cqBbE+Brark6A25e2gUoYEXnKDTPjnSRvwJtWTJh0lFL8KSU6RT
	A2UJZ3wUTM3kjSW2heS+15XH+Z9OxtxJ07AhDp6JOs8LgrgMbAuVb8UQz/hs0N+QMyrzdGW
	erdcOCWDi3aFg1gaT2BlxtcajPdMCabycKaLn00C1XMntcH6420K4/EssNYsj43A8IijWyD
	lV8/syxovZuq/tTZp0x8gCDiinxASxRto4Hu0K/Az+b19zmI0a9bb7It2Cjcm/5kWW9LVd3
	Swh7seVMPf35fKZIEUP1yn5/cDMqfoBI2nVMdiYZ7mb+FLRUN/Y31wH7AeYliF+C7WrVp/m
	LrMqKXxIGIH1QhJMByTG0k1s+QdGGl7et9lmmK9liyREwg1/II1XybNKBBMDiJdTuLD+7Pd
	vmIojQBztwIVZRmzswTgA/W4BB/Qtpv9XnhKdKzv6GYn1pDHQVVhTmnCpa2K7SMfV/EFMvR
	UMAlwzQp3PwXZPRF3hMRcWO1rCW1c0gIccvkYCeb65QachQq1PitcEgGeeY6/NJfMAZHaKm
	vMwb1cYKWeOnaLIQWOxOcyeZtOSSp1JlPY9QGtJrVSUsCbVy0aji4Tqsu+nh1yQ9XlClrbP
	feClbeC3B1hf0wK+z2IB3mTAOiz+7NrhyB6yE0rwwLJMvZzczJMuxpefCZYjUeDAhIYuxYF
	d3nFqS5F63Ppo0DxJ8gMlWeQGC+M5O9PGS/Ob4MTue77NvM/ucHkrHQ+XggOz04X5quUhgW
	+FPoTWMRCg++vWSkcpDexpxx2A+lG77iM04kokOX7sLKLnFFw/tFsgUAu2pmz2+nhIdzWWs
	iouy1ifNOPHtQ6nOLyNoQSnqB2zEW4RzOIpa/PGnCzevOHpSlKqSxFXXpCV4aGyLrRgO1fq
	6en42HI5edbsIBkrp5deHe1sHBw8XxqbDGMnqQ5s5wjQXfAYAmlhF50sxl+QGdIZroVDTNl
	Lr38ZJEsTb9m6TWouqlnK0W86LauLctvonGpnsX9MizWeDAKr/4ejJDoptXoRcxZ2Mdfvqp
	A2xTipdtImi
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
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

