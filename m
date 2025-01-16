Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80E411917D9;
	Thu, 16 Jan 2025 07:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737012662; cv=none; b=VlYUeSjiuC6+bV7gFiczAqonRNGDl+jk2ZJzexsBpZmogSqFuqIJNQ1QxSpKZmDx64uYwUbj1uDPTY5ypAEA5trvKG3FjRXMOWQ9fwq/nS05WeKYINKfQX/CQqAIxLgSdE3MLgq44X8EbAeWmt64TFASap2iFKBGfeU9hlz0c5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737012662; c=relaxed/simple;
	bh=2foV365dOs0wvCCxpVUodnhXch7VO+bxauBQywxjT3s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GAWBPiqSjuvlFyIA0x+6iMyN5PvE4GmS+b6OJz/BB5VO5eNQZK21NjapH87EO2q9cBiTOQVVS5bmv/zkmY3dTKH3oZdHM8/zW5NxNgu2AXYm2k5TGe/QXe1efiuStpDwe1IG+P7C76OToz7T8+ky/x3UAvMMJ/iPZq9YIeZX6wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bXkD5qj7; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bXkD5qj7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=OU6Gz
	Oh7BfbTBz/dxmL0nVb2JnVCPuVlnBmTuyc4o+c=; b=bXkD5qj7C2t/62xHS7qkW
	6SsjXA56EOeLgcAENtlRto77jhTmJkgeeC3nc7rNtUumIAQj2m9GFGUk3EEWHTVG
	ZOo5BKkhyWbBo/6DktoJtewLaZcrMHNr+in4adkwo7HUci2jIP7vJxO32jat1YvF
	ER3pJa8Zie3VECgxoJSiEU=
Received: from hello.company.local (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDHDkZ7tYhnjMUQGQ--.48254S2;
	Thu, 16 Jan 2025 15:30:05 +0800 (CST)
From: Liang Jie <buaajxlj@163.com>
To: sfrench@samba.org
Cc: pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Liang Jie <liangjie@lixiang.com>
Subject: [PATCH] smb: client: correctly handle ErrorContextData as a flexible array
Date: Thu, 16 Jan 2025 15:29:48 +0800
Message-Id: <20250116072948.682402-1-buaajxlj@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHDkZ7tYhnjMUQGQ--.48254S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF47Kw4UJw13AF13KFWrAFb_yoW8Kw4xpF
	18G3Z8Cr15J3W7Zw1DJa40qw15try0yFn5KrWjq3yruFy5Gr1q9Fn2y39I9ryj9FWkXw40
	kr4j9FyvvFWqyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbUUUUUUUU=
X-CM-SenderInfo: pexdtyx0omqiywtou0bp/1tbioAbWIGeIq5CapgABs5

From: Liang Jie <liangjie@lixiang.com>

The `smb2_symlink_err_rsp` structure was previously defined with
`ErrorContextData` as a single `__u8` byte. However, the `ErrorContextData`
field is intended to be a variable-length array based on `ErrorDataLength`.
This mismatch leads to incorrect pointer arithmetic and potential memory
access issues when processing error contexts.

Updates the `ErrorContextData` field to be a flexible array
(`__u8 ErrorContextData[]`). Additionally, it modifies the corresponding
casts in the `symlink_data()` function to properly handle the flexible
array, ensuring correct memory calculations and data handling.

These changes improve the robustness of SMB2 symlink error processing.

Signed-off-by: Liang Jie <liangjie@lixiang.com>
---
 fs/smb/client/smb2file.c | 4 ++--
 fs/smb/client/smb2pdu.h  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index e836bc2193dd..9ec44eab8dbc 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -42,14 +42,14 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 		end = (struct smb2_error_context_rsp *)((u8 *)err + iov->iov_len);
 		do {
 			if (le32_to_cpu(p->ErrorId) == SMB2_ERROR_ID_DEFAULT) {
-				sym = (struct smb2_symlink_err_rsp *)&p->ErrorContextData;
+				sym = (struct smb2_symlink_err_rsp *)p->ErrorContextData;
 				break;
 			}
 			cifs_dbg(FYI, "%s: skipping unhandled error context: 0x%x\n",
 				 __func__, le32_to_cpu(p->ErrorId));
 
 			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
-			p = (struct smb2_error_context_rsp *)((u8 *)&p->ErrorContextData + len);
+			p = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
 		} while (p < end);
 	} else if (le32_to_cpu(err->ByteCount) >= sizeof(*sym) &&
 		   iov->iov_len >= SMB2_SYMLINK_STRUCT_SIZE) {
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 076d9e83e1a0..ba2696352634 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -79,7 +79,7 @@ struct smb2_symlink_err_rsp {
 struct smb2_error_context_rsp {
 	__le32 ErrorDataLength;
 	__le32 ErrorId;
-	__u8  ErrorContextData; /* ErrorDataLength long array */
+	__u8  ErrorContextData[]; /* ErrorDataLength long array */
 } __packed;
 
 /* ErrorId values */
-- 
2.25.1

