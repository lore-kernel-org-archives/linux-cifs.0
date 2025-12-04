Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E744199931
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 05:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764824404; cv=none; b=D7hiEilmJTDlcukcw1Qqu0I1y2mrWQdOELWY9KZC9HMLe487EnPhXNDuNuO3U5KyDQc8+2DbaYYrUN2Rp/+ixd4JTN8qu27lV6QJqaXheh5cBGlROQttP43Sk3Egk2jSvntdc9lt3fuQbR6in3xBuQtkFrZo3SqiJmCWiFin3DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764824404; c=relaxed/simple;
	bh=kIB9E0S4MLXrqcQMCK41YTJVE8Ih+JwGuHTZBMonWCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcGpZZ6KD7JsOHHfENKbFiK5p2T7uRvL36cVHnRT8h+x9rgk3ZfIu6Bc1/nUpsjdxigzcT14j1WHIeckjocBGcRqkq7trME5hli/jOFkAucbdx5x9HWR1emIQ+WXPAMCgB8zaD2hP3E951wGOsSi/E3rRzebx6PWp3KId9Hb4cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e+Pcjfi5; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e+Pcjfi5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764824400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e9cc8Nr2lduaK+xF7eBStk2AhlwQzHHel2LcG+oQ/q0=;
	b=e+Pcjfi5V7Id4QXL7bPTpctQWL64AXxqG1CnqyjJJ8MnqP5w5eG2ZMhCjszMutwIBbgjG6
	/jAFko6VBYb0EnZVhCMEBCHlDGoB33AYl+18wFwxp6+DTpnTrkfph2gzWdiDK3HglXXsG6
	ifu9QOnTSn7tabtDWm7AbbUfAvQQrRU=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 08/10] smb/server: rename include guard in smb_common.h
Date: Thu,  4 Dec 2025 12:58:16 +0800
Message-ID: <20251204045818.2590727-9-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

To avoid conflicts with the include guard in the soon-to-be-created
common/common.h header.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb_common.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index ae4dac515b6c..8cea25c01d81 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -3,8 +3,8 @@
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
  */
 
-#ifndef __SMB_COMMON_H__
-#define __SMB_COMMON_H__
+#ifndef __SMB_SERVER_COMMON_H__
+#define __SMB_SERVER_COMMON_H__
 
 #include <linux/kernel.h>
 
@@ -196,4 +196,4 @@ unsigned int ksmbd_server_side_copy_max_chunk_size(void);
 unsigned int ksmbd_server_side_copy_max_total_size(void);
 bool is_asterisk(char *p);
 __le32 smb_map_generic_desired_access(__le32 daccess);
-#endif /* __SMB_COMMON_H__ */
+#endif /* __SMB_SERVER_COMMON_H__ */
-- 
2.43.0

