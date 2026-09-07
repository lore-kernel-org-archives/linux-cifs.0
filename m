Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6655930D411;
	Mon,  7 Sep 2026 21:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788816995; cv=none; b=Aa3izsGhpCDPNNB8n1JnOobXu6J5RdJ8VrNzHcpR6GlQcst5OYom2tcfPbPy9VfmMIUeEalQA5lQ8i81mn1ZKLNAjvVQKUfanYuGwcVT6kjbRP9iLVUXNXqlEJ+Wv6uvkeeuIgkizJI7U08kwzAMx9C3x9mVXiDU1EXqExgtQzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788816995; c=relaxed/simple;
	bh=5+vC74QR1Av6hjACDiihQTh3/3UlkBbRUh4zn8TsRe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lM5CfPlN9o3vuI/ePry1JmfU72O67dw14/aq5ZafP5ODMudokswg6sDirNqoZMZbhu4RW3pELwR+J9rzZd7UWEZ58VPi61qHB8OEi03oYMepT3D8X5X2LtuJ/YG4WaLe6lQwEbv+1/zFNPFBASzvpbMrAd5f1C1n0VA1Nbnf3iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jE1Hbffu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jE1Hbffu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2611F00A3D;
	Mon,  7 Sep 2026 21:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788816994;
	bh=V5kciItnnCi0FVjT65TtqIBFxLWaVrZ8Hq2CrAbcWtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jE1HbffupZi0jxC2mSy17R0qqqEKjJibz2czYD0qH1x6Dusm27fuW80uNViuBPyGd
	 3u2Py3qxFEgI/KbQzLGSkGqY6QCTxxgexaoZjZJ3EPboYPI7wkcS/caGCymnnCvlFS
	 2lVwaTZ4thFbz4XjxrIKMm5PaS+3f3hTsVyRUynRAeplW0sK4YRiavxKX1PhpiaUjI
	 53nCl7HSe3C6HYYOuNsLsyjwrM6jTIRXqGhhmImY9hOzbGi6Sfy5kIM6mSXcsoxWGv
	 WnxkqIhrAmlPo73ZcXM19t2Vqm/i7+3iaa+Y9Lx6K9/KzmqItWz6mLm5g78hChOsHT
	 rFnKWMKUhM2PQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6.y 2/4] cifs: SMB1 split: Create smb1proto.h for SMB1 declarations
Date: Mon,  7 Sep 2026 17:36:28 -0400
Message-ID: <20260907213630.573772-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907213630.573772-1-sashal@kernel.org>
References: <2026090336-riverboat-makeover-fe69@gregkh>
 <20260907213630.573772-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 86c666506ea2c42649879eeac7f29e7bedef2f23 ]

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 65deb1835934 ("smb: client: reject a tree connect response whose byte count is too small")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h  |  2 --
 fs/smb/client/cifsproto.h | 11 +----------
 fs/smb/client/smb1proto.h | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 12 deletions(-)
 create mode 100644 fs/smb/client/smb1proto.h

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a4e0618c58efc..6c4f31fec2141 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2098,8 +2098,6 @@ extern mempool_t *cifs_mid_poolp;
 
 /* Operations for different SMB versions */
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-extern struct smb_version_operations smb1_operations;
-extern struct smb_version_values smb1_values;
 extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
 #endif /* CIFS_ALLOW_INSECURE_LEGACY */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 1f37bc2923fb8..c7f8650cf2498 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
+#include "smb1proto.h"
 
 struct statfs;
 struct smb_rqst;
@@ -423,16 +424,6 @@ extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
 			      struct cifsFileInfo *cfile, __u64 size,
 			      bool set_allocation);
 
-struct cifs_unix_set_info_args {
-	__u64	ctime;
-	__u64	atime;
-	__u64	mtime;
-	__u64	mode;
-	kuid_t	uid;
-	kgid_t	gid;
-	dev_t	device;
-};
-
 extern int CIFSSMBUnixSetFileInfo(const unsigned int xid,
 				  struct cifs_tcon *tcon,
 				  const struct cifs_unix_set_info_args *args,
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
new file mode 100644
index 0000000000000..a73213f6a2aa1
--- /dev/null
+++ b/fs/smb/client/smb1proto.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ *
+ *   Copyright (c) International Business Machines  Corp., 2002,2008
+ *   Author(s): Steve French (sfrench@us.ibm.com)
+ *
+ */
+#ifndef _SMB1PROTO_H
+#define _SMB1PROTO_H
+
+struct cifs_unix_set_info_args {
+	__u64	ctime;
+	__u64	atime;
+	__u64	mtime;
+	__u64	mode;
+	kuid_t	uid;
+	kgid_t	gid;
+	dev_t	device;
+};
+
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
+
+/*
+ * cifssmb.c
+ */
+
+/*
+ * smb1ops.c
+ */
+extern struct smb_version_operations smb1_operations;
+extern struct smb_version_values smb1_values;
+
+/*
+ * smb1transport.c
+ */
+
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+#endif /* _SMB1PROTO_H */
-- 
2.53.0

