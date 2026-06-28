Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B745A1632DD
	for <linux-cifs@vger.kernel.org>; Sun, 28 Jun 2026 07:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782632599; cv=none; b=QQ3U2L6OxxyRdD9fvZGynNRRcdKxcxL0+uwajP4eq2IUUeVu+vSAjFnnaSfWUowbiXaPDUrv0YUcyw1tgyw3pOeowa5KVvzHOxhFyfwxRXJWSQsZCAncct18qwG/dHJ8JkblOihGjzatKFFKPuUCkcz9omLPaGShZL8WM6QR1W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782632599; c=relaxed/simple;
	bh=i5CgBVtWKAWoD38X4fXX+bQ6nqvrE/YZp5mGApIHbTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m5uJbzjRHl2iNCxmNVEkpfPxq8cEAdm7fIQx2KX0wqlLOTAoC32HDK4zKX6re8oNwM798ZqUDB7pJ8lEfT06+iFmpo7tG2bLraAHNCoWf94aBDTxhJYzcZ7gr7nK7RWzs257U6SOr4LJZNf0PckbT2RslTgueAkTWu9uLhi1aWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=ZyuThpLu; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="ZyuThpLu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782632584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pjGABgNPVjaNKjIE/S3mwWMX6HndcGe2takmIDDRUzA=;
	b=ZyuThpLuNqgAcuQDt3qUH+ynLTZzD0lalWT52nA0/eMM36j551Ml/cUaHYqDGKW/wwRyhF
	PBI++QxX1UCu+rnPmVLxvG6QxPy3vhdRL/r0MkBUbNZGzu3SC/FFTd8bpE62SDx8LaYKaM
	DPL/MY34rBhkpZ22py+nScIctHN9zLKfassMdau0GHi7xRS+j+oQx7hHzsBoATlQZ/YMcC
	6Jcs9HET3nuJlv7ubzkT6ry6Wv8fZttCEw60Ing0w9MqwGUTrirAeAFvvwBkqebdguH51a
	cRo3C8NLVj+bS/UpXqCmQlwPpB+M6gzfkerCPKhztNNs0g1YuDIxnajN1c4k5g==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] smb/server: do not require delete access for non-replacing links
Date: Sun, 28 Jun 2026 07:42:43 +0000
Message-ID: <20260628074243.629589-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. server: systemctl start ksmbd
  2. client: mount -t cifs //${server_ip}/export /mnt
  3. client: touch /mnt/file; ln /mnt/file /mnt/hardlink
  4. client err log: ln: failed to create hard link 'hardlink' => 'file': Permission denied
  5. server err log: ksmbd: no right to delete : 0x80

Fixes: 13f3942f2bf4 ("ksmbd: add per-handle permission check to FILE_LINK_INFORMATION")
Cc: stable@vger.kernel.org
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 727ba86ede36..097f51fc7ed6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6921,16 +6921,18 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	}
 	case FILE_LINK_INFORMATION:
 	{
-		if (!(fp->daccess & FILE_DELETE_LE)) {
-			pr_err("no right to delete : 0x%x\n", fp->daccess);
-			return -EACCES;
-		}
+		struct smb2_file_link_info *file_info;
 
 		if (buf_len < sizeof(struct smb2_file_link_info))
 			return -EMSGSIZE;
 
-		return smb2_create_link(work, work->tcon->share_conf,
-					(struct smb2_file_link_info *)buffer,
+		file_info = (struct smb2_file_link_info *)buffer;
+		if (file_info->ReplaceIfExists && !(fp->daccess & FILE_DELETE_LE)) {
+			pr_err("no right to delete : 0x%x\n", fp->daccess);
+			return -EACCES;
+		}
+
+		return smb2_create_link(work, work->tcon->share_conf, file_info,
 					buf_len, fp->filp,
 					work->conn->local_nls);
 	}
-- 
2.54.0

