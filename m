Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7852329AB1D
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 04:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771992735; cv=none; b=Pwv60nYfCCGZHhX4E+t4IKPuT/vJeh3NTXPTKfftuEwqgcm442XxnTIZdVqQ82PeND+z5Nrkl9bzYgSMpEFyvC+pEhb6vZ5kRgCiL6Z8cxKSz4U5AyfOD16GSW5U7ct4LZQJvczANl8yOm7dtrYbBpxe6zBhII1R0Ad8oZs3aGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771992735; c=relaxed/simple;
	bh=LlADQypREByTp5cT/ELb3tJ1Xmr0Kc3Dm/Ub89+9YMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WARgT6rX/k3cLmcM6AzmfgM0EY++TyMovipZ/G6yLPhfkuqRXwof8DtOU6AtLYNf0qMbCAND/5GkdggkdqZ8PmA55wi/9vnam8Yt52obXZNIT6rflEUIvjViu1K/fhYtyQX+RjCnPAnCrHqcOqH59rr1nt9wvZfPCgDWXK0NepI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tfgIsgL9; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tfgIsgL9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771992732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9GoG0+8g0p0QO8IWM77hg+ZpvSzNNw2Hk6K/fX6vCD0=;
	b=tfgIsgL9YYRnXlWJIb6XOH53v/AHbEmDKjfXWsZJEZoqd2QAYfcGDldDgDuX30Hx0PA/Jg
	C2BEWKtoGDzns4wnIBC7t4H2snhRPLEjQIwLGSCIMvtZllofVMQFJoHG5CTXUkJPMzu20w
	3rGWbHH4hXGoHp0b1n4D4jJx7yjD+AI=
From: zhang.guodong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 4/5] smb: update some doc references
Date: Wed, 25 Feb 2026 04:10:59 +0000
Message-ID: <20260225041100.707468-5-zhang.guodong@linux.dev>
In-Reply-To: <20260225041100.707468-1-zhang.guodong@linux.dev>
References: <20260225041100.707468-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

To make it easier to locate the documentation during development.

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2pdu.h | 7 +++++--
 fs/smb/server/smb2pdu.h | 5 ++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 78bb99f29d38..30d70097fe2f 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -224,7 +224,7 @@ struct smb2_file_reparse_point_info {
 	__le32 Tag;
 } __packed;
 
-/* See MS-FSCC 2.4.21 */
+/* See MS-FSCC 2.4.26 */
 struct smb2_file_id_information {
 	__le64	VolumeSerialNumber;
 	__u64  PersistentFileId; /* opaque endianness */
@@ -251,7 +251,10 @@ struct smb2_file_id_extd_directory_info {
 
 extern char smb2_padding[7];
 
-/* equivalent of the contents of SMB3.1.1 POSIX open context response */
+/*
+ * See POSIX-SMB2 2.2.14.2.16
+ * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb3_posix_extensions.md
+ */
 struct create_posix_rsp {
 	u32 nlink;
 	u32 reparse_tag;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 9b3c4c9acb11..e7cf573e59f0 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -83,7 +83,10 @@ struct create_durable_rsp {
 	} Data;
 } __packed;
 
-/* equivalent of the contents of SMB3.1.1 POSIX open context response */
+/*
+ * See POSIX-SMB2 2.2.14.2.16
+ * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb3_posix_extensions.md
+ */
 struct create_posix_rsp {
 	struct create_context_hdr ccontext;
 	__u8    Name[16];
-- 
2.53.0

