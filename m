Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27C5B163;
	Sat, 18 Jan 2025 12:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737203820; cv=none; b=r3o9pl5qqh0E4d49cjW+q2FhqHOx0zCKF4xSK5M8qw4nsdp7+2tnk4JNPymhCQ84awzYWCJMhzzGs0cuHu0YVhdCgC53yuh02WS+TejCzEj0XyJ5bWxkAJ+2z1SFPZocEtTgIOy10ODZ5SVEJtLcAb/Ik31zyft7rlLysy2uCpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737203820; c=relaxed/simple;
	bh=2p8N7zVJpJbpvwpJNu+D93MGL+67RWSoKw3NYE9qN3A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VgKbEEGqGV4LqzPQrOoByDOkHTcrz9oCbfPXF5uGUeg9Du9Yb2SbZwv+6XWdpsQ7QXOmsfVgUHyGrRKdrJ718SaTEwgGA5Xpb3vsaGG5wPDh1P9IZ/lBUlMqRjF60Uj0H3rG0sJtsR49zjrF28hDPuFa7EQ+F6b7C6NsEvCZIMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bM67sbeB; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bM67sbeB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=rYmO8
	lSL5r4tjj0SeOb4LfUzVITNkAetlNiciusfXeA=; b=bM67sbeBlwCq5z22jHtR0
	G9BNCdPVQ4Ly1Ng3K1IC6wb69ADfhNBAHEqMh5jgimEKfY0SUW0enreMOZ2Zp6kl
	es2vpSHf27toFdXBlap2/tN1dbCcntreVJZbIhblJdUtCWUzQymZx38PrkOvunPd
	ZCDMP4CzpEqrAe1UP0zrLQ=
Received: from hello.company.local (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCHyO0yoItnQ3YDEw--.35704S2;
	Sat, 18 Jan 2025 20:36:03 +0800 (CST)
From: Liang Jie <buaajxlj@163.com>
To: sfrench@samba.org,
	tom@talpey.com
Cc: pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	fanggeng@lixiang.com,
	yangchen11@lixiang.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Liang Jie <liangjie@lixiang.com>
Subject: [PATCH v2] smb: client: correctly handle ErrorContextData as a flexible array
Date: Sat, 18 Jan 2025 20:35:28 +0800
Message-Id: <20250118123528.3342182-1-buaajxlj@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgCHyO0yoItnQ3YDEw--.35704S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFWUJw13uw1rAw4xJF15CFg_yoW5Xr15pF
	1UGas8Cr15J3W7Zw4DJa40vwn8tryUtFn5KrWDt34ruFZ8Gr1v9F92y39I9ryj9aykXw40
	kr4j9FWvvayqyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbkuxUUUUU=
X-CM-SenderInfo: pexdtyx0omqiywtou0bp/xtbBzwjYIGeLmwQ-BgAAs1

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
Suggested-by: Tom Talpey <tom@talpey.com>
---

Changes in v2:
- Add the __counted_by_le attribute to reference the ErrorDataLength protocol field.
- Link to v1: https://lore.kernel.org/all/20250116072948.682402-1-buaajxlj@163.com/

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
index 076d9e83e1a0..3c09a58dfd07 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -79,7 +79,7 @@ struct smb2_symlink_err_rsp {
 struct smb2_error_context_rsp {
 	__le32 ErrorDataLength;
 	__le32 ErrorId;
-	__u8  ErrorContextData; /* ErrorDataLength long array */
+	__u8  ErrorContextData[] __counted_by_le(ErrorDataLength);
 } __packed;
 
 /* ErrorId values */
-- 
2.25.1

