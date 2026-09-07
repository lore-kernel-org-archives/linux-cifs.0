Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF28D49CF40;
	Mon,  7 Sep 2026 11:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781669; cv=none; b=KuCeqga2Xn3Dg9YucRi7h2dgmIZZB02eNDpwIK+Job9BT5lH09c3dgULs/aog6iTiJcx5S9uiAfAMUswFVBbQCxGdyIhcXXrpW0m3pL9hXSjwS7zS4NUe0FyVNevi5x7rU2Lhx9nM6DpiWXLpq5839XrZj3HGwMDA5ChznpE9+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781669; c=relaxed/simple;
	bh=fhdx8a+uYP5KfkkMxkTauolTOXQ2PIhmGDt4ZGQa24s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHNbmy9zUmfBiFPzHD28NRFCSfpUZHzZ0xx+/Z+3QhR1sROEJT9NRoW5M2lpUEO67DNSA16EFzA3kL0u2mtf02OWvqRAXo5LZpyn35/coh7HJw3uiThkogstWd1va4fSAE6kc17F0qZwTnDK1PbgEkSfAhFs31FkqdnBoM4drh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJo6Hvl1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJo6Hvl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675C51F00A3F;
	Mon,  7 Sep 2026 11:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788781667;
	bh=UyGQofn2iN32bL5+S3jiEZxoLtv1krYTUF1bzxl72GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJo6Hvl1jzj22fl+POjckFlkFvUpzpghzKcZny7I2PncRv9eBySAJqdCcQBtR3c5l
	 vugncoTxWgBsR5AlgqSOU5LrTWH8U+dEhe0dE744XHTLab9agHYpr4B1ac7jDCpCUN
	 geJ0Bxr986T3JshGWIwEzlvRNd8T64Prt3Q2QgypLwtolluxfvz9ai0HLq06x6nuNd
	 QG+30+ZZxEO4hsUhuVi9ICA+BSIB3N/g767K+xW1Y62NioEPLYF25pBrugsYo7kxaF
	 OTv2Y1CRjC+Bb6uEZoBU6yoakxqA7HZryZL1TJ6p1cVna4meKst041TXpRGXpvaMtX
	 TkOo4w5CgPVbg==
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
Subject: [PATCH 6.12.y 3/5] cifs: SMB1 split: Create smb1proto.h for SMB1 declarations
Date: Mon,  7 Sep 2026 07:47:40 -0400
Message-ID: <20260907114742.2872537-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907114742.2872537-1-sashal@kernel.org>
References: <2026090351-popper-penpal-d0a0@gregkh>
 <20260907114742.2872537-1-sashal@kernel.org>
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
Stable-dep-of: b8e5dc4f95e5 ("smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h  |  2 --
 fs/smb/client/cifsproto.h | 11 +----------
 fs/smb/client/smb1proto.h | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 12 deletions(-)
 create mode 100644 fs/smb/client/smb1proto.h

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3f9c03828cd4f..4f30059c08ddc 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2061,8 +2061,6 @@ extern mempool_t cifs_io_subrequest_pool;
 
 /* Operations for different SMB versions */
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-extern struct smb_version_operations smb1_operations;
-extern struct smb_version_values smb1_values;
 extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
 #endif /* CIFS_ALLOW_INSECURE_LEGACY */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index d2d004764a708..79158c0fd303e 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
+#include "smb1proto.h"
 
 struct statfs;
 struct smb_rqst;
@@ -421,16 +422,6 @@ extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
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

