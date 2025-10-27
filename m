Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDDD20C001
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 07:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549326; cv=none; b=eDECu9BhTUD6pLgeZBwHvqONyuaaS+ACQ80hS7Mv+MoY7m8BCn/QbV5uhF6I30H619zyuvGTQKyH/AtD3b0YoyO58EwqRse3dVhbdTOxPC82/sL8IpJfLx9LerbvDRlSoPUgdZL/SA/nNMtNj46yXGrTrgmD7pd3cBEhcV8r+Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549326; c=relaxed/simple;
	bh=zIRWibiZhPUpnVTkKvhhJN+GeSuM0gPtRAhRqpNWexI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GF+SDcQHad9mvjumM9eCmp5KiK/AYgWYStTMh2XDoRD7YKmlCrHS6rjEXGvf71tmv5J06cawueV5aiVFrdJLwd/dTSfE+zOqsumLPQkdNtq/pHLmHsl8aaqyaJwVfxiLJd7rxtpKTuz3deYqW4e9jxhY87wzdWw4acvmtJc0bZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Omy00Pdr; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Omy00Pdr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ch2Fe9q4Y/Ie+8Paoofms/GElrp+76BJQ26slsFp9P0=;
	b=Omy00Pdrfs8b8uTwx0buxe5qjgVO3sAThTaLt3nSook8tYaO7cDXbX3v4lEX6A35mPBax0
	O/8JUhwXzKpCPdiGhdBZ+XCrf4YiKGoTojxSnWandlEVVs6uZfNt77qWN9FfJtq2uTQjEp
	J2TN0S8YjKzbMhCG1oxktbxxE/GIKxA=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 01/24] smb: rename common/cifsglob.h to common/smbglob.h
Date: Mon, 27 Oct 2025 15:12:53 +0800
Message-ID: <20251027071316.3468472-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

"cifs" is a legacy name, rename it to "smbglob.h" according to
Namjae's suggestions.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/cifsglob.h                | 2 +-
 fs/smb/common/{cifsglob.h => smbglob.h} | 6 +++---
 fs/smb/server/smb_common.h              | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)
 rename fs/smb/common/{cifsglob.h => smbglob.h} (89%)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 203e2aaa3c25..8fd9aa7e2009 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -24,7 +24,7 @@
 #include "cifsacl.h"
 #include <crypto/internal/hash.h>
 #include <uapi/linux/cifs/cifs_mount.h>
-#include "../common/cifsglob.h"
+#include "../common/smbglob.h"
 #include "../common/smb2pdu.h"
 #include "smb2pdu.h"
 #include <linux/filelock.h>
diff --git a/fs/smb/common/cifsglob.h b/fs/smb/common/smbglob.h
similarity index 89%
rename from fs/smb/common/cifsglob.h
rename to fs/smb/common/smbglob.h
index 00fd215e3eb5..c51d227977c4 100644
--- a/fs/smb/common/cifsglob.h
+++ b/fs/smb/common/smbglob.h
@@ -6,8 +6,8 @@
  *              Jeremy Allison (jra@samba.org)
  *
  */
-#ifndef _COMMON_CIFS_GLOB_H
-#define _COMMON_CIFS_GLOB_H
+#ifndef _COMMON_SMB_GLOB_H
+#define _COMMON_SMB_GLOB_H
 
 static inline void inc_rfc1001_len(void *buf, int count)
 {
@@ -27,4 +27,4 @@ static inline void inc_rfc1001_len(void *buf, int count)
 
 #define CIFS_DEFAULT_IOSIZE (1024 * 1024)
 
-#endif	/* _COMMON_CIFS_GLOB_H */
+#endif	/* _COMMON_SMB_GLOB_H */
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 863716207a0d..910b9c3bd244 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -10,7 +10,7 @@
 
 #include "glob.h"
 #include "nterr.h"
-#include "../common/cifsglob.h"
+#include "../common/smbglob.h"
 #include "../common/smb2pdu.h"
 #include "smb2pdu.h"
 
-- 
2.43.0

