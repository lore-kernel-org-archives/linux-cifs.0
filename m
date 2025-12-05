Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E5C338F25
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 13:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764941239; cv=none; b=E30Tv7jpQJnVYNFGWWkuGQsyXehHUs/6PaAwMRX7XTRgkerMxXSRllIXWsHclecikWgpvwqKFZ1qrQQPga8KqQ+xktl0A87hNdW/kY5CbBC3nRnkCUvsNOV/jrTtFBoGmzNcUGNv5lwZr5tyJLlgUhw+pxQOwyfwuxIlwNI1qYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764941239; c=relaxed/simple;
	bh=j3TQkQqNjc21JofRmx5Cs1kYMv81xgaBLuCylqL/OV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfZ0LNuxgNkJeg94VmoJDqtlr/1Z6nivDHv1hLwbnKlsuePCCjV8JjL9BmeezcQFaq5W8MNYPWztUTjyZDGweNeqNvx/FRWyPDa+qtAPwpA0bWUDmazdHwzoWUjyGBF65UC/CgqCZXU4Yjfeswcr/yEvLTrXjqOyEk3YkeG3nxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ATRl4cC4; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ATRl4cC4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764941231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LhTKXZUsKs6yApgm9M0oyCa/GcapnLfnpclZk/b8UoI=;
	b=ATRl4cC44cUGBt0cfZYYCv+ZR3VVzLnLE/7+jIs9w6x/PafwbRWJxwerm7BC9bBzfIaqFt
	ECWvffa2bgNidszJ84cAJgr/+lZwobQyJI4hoBthIqLy7NoxNQnGzQM8kp7+yNTdB/lRKk
	Blc2bvVrhyQMyGXtVmYCenkY5fHcon4=
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
Subject: [PATCH v3 9/9] smb/server: rename include guard in smb_common.h
Date: Fri,  5 Dec 2025 21:25:35 +0800
Message-ID: <20251205132536.2703110-10-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251205132536.2703110-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251205132536.2703110-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Make the include guard more descriptive to avoid conflicts with include
guards that may be used in the future.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb_common.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index f47ce4a6719c..302c82480799 100644
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

