Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AFF27B359
	for <linux-cifs@vger.kernel.org>; Sat,  6 Dec 2025 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765034409; cv=none; b=jRiVLntheiAeIrgjV0GxkHgdWLP4VRg3PF7PG7NZ+mplzWD7lxqP2qRk0XMH6N/QvKOBfvlzmd3DbiYIxMJNniJKEuIJauhCWOlIzDDwG6kOkkSgFOYUnkc6xO6OzM279MFerxvskB3rJTzmo/AVQtRka1ftPkJ+/FYEuYh0r5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765034409; c=relaxed/simple;
	bh=j3TQkQqNjc21JofRmx5Cs1kYMv81xgaBLuCylqL/OV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRMUnwOCvX/quk3Wqcjh08GKG6BFL2z/VkJvIk/stkztHAfnG0iGJBKOxEDPvSpFcpOR8fm1aWSAp6s6Q8lOozSVg3utjyARsD1c0eV/+4QX/44eRJ0DrauV6sPY726n9YuFTPJ3gVrIbp/EEBJRS10LxkceERBJqu+qLC5f+Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NdirdaEf; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NdirdaEf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765034405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LhTKXZUsKs6yApgm9M0oyCa/GcapnLfnpclZk/b8UoI=;
	b=NdirdaEf9vUZ4EOMpIn2wYO9jQRKeE+l+r+3mwfVhPHtlTfSQ40SX6YseBOWZ4cFfauRXc
	iyty6/0VT/1bMN2yPvc/c7u/NydUfsxWtZks2bJQb9fHnMu3O6GEVT9nd/WhKJNm1uVhef
	WWyWnoDg8NU1lDgKeunpNLAoGqYasS0=
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
Subject: [PATCH v4 10/10] smb/server: rename include guard in smb_common.h
Date: Sat,  6 Dec 2025 23:18:26 +0800
Message-ID: <20251206151826.2932970-11-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
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

