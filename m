Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36C526C384
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 01:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242715; cv=none; b=r3ajwLs+FpCVGeOZE/q9ziLGVCdovrBasOa04rTQzaY60L8mtQ8QdjCspSxp6+7f/hU0G3nOa2zTFdAsVmSA25B/cW45An7hAhxXSV8n4wLJKWqkIgYhF3Qguu+639EUvHqDF0iFSv6+YkxCk/G1MpLz+udo43bVc2GoRbjouss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242715; c=relaxed/simple;
	bh=s7VZl24wrvdHOlGNyUf/2ymjzy6HDwB6sniTLqxBdeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyA3qy4Za0qQOoVoLSPSpzJRIumNDcgXDh1XblrbDwbim+bSn2UbuFHHSzmJd1MLsnrj1ZtgTMMXuell0KCgRkXYHjuyktS5qaL+oqvYTp8No99/iCuaL3zvY1DcRjQnuX5704jcRnD1QKfcHqSoMhsUj1VH1QIXJnW1taMxcp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ouczwonw; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ouczwonw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjE8pX5ZoXdQdNPZglHQcPDEH+jxhHyONwZG2h4XXjc=;
	b=ouczwonwQqa91LdnY/vDa9ueLdUXd/Wc4kellO715mf0R2S3jpUif8QsY5j2hkqU0+xWfe
	2N59IQMwmXd1qWi2djTOLnr5a/ysz2rEZYrHRO4fwaJQskZ7i4AVkTP6DDOiTuaykczCYR
	ilMvbztQAKKzmg9z/E5qbHEMsjq4jWo=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 03/13] smb: move SMB2 Notify Action Flags into common/smb2pdu.h
Date: Tue,  9 Dec 2025 09:10:09 +0800
Message-ID: <20251209011020.3270989-4-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Some of these definitions are already in common/smb2pdu.h. Remove the
duplicate client side definitions, and add all SMB2 Notify Action Flags to
common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h | 9 ---------
 fs/smb/common/smb2pdu.h | 2 ++
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 4315a06d296b..8f0547d1fe0e 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1358,15 +1358,6 @@ typedef struct smb_com_transaction_change_notify_rsp {
 	/* __u8 Pad[3]; */
 } __packed TRANSACT_CHANGE_NOTIFY_RSP;
 
-#define FILE_ACTION_ADDED		0x00000001
-#define FILE_ACTION_REMOVED		0x00000002
-#define FILE_ACTION_MODIFIED		0x00000003
-#define FILE_ACTION_RENAMED_OLD_NAME	0x00000004
-#define FILE_ACTION_RENAMED_NEW_NAME	0x00000005
-#define FILE_ACTION_ADDED_STREAM	0x00000006
-#define FILE_ACTION_REMOVED_STREAM	0x00000007
-#define FILE_ACTION_MODIFIED_STREAM	0x00000008
-
 /*
  * response contains array of the following structures
  * See MS-FSCC 2.7.1
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 0565385d735a..ddb0609bc186 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1016,6 +1016,8 @@ struct smb2_set_info_rsp {
 #define FILE_ACTION_REMOVED_STREAM              0x00000007
 #define FILE_ACTION_MODIFIED_STREAM             0x00000008
 #define FILE_ACTION_REMOVED_BY_DELETE           0x00000009
+#define FILE_ACTION_ID_NOT_TUNNELLED            0x0000000A
+#define FILE_ACTION_TUNNELLED_ID_COLLISION      0x0000000B
 
 /* See MS-SMB2 2.2.35 */
 struct smb2_change_notify_req {
-- 
2.43.0

