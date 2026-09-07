Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBCB23F40D;
	Mon,  7 Sep 2026 22:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788821161; cv=none; b=guWwbchULdcs3ChGH5x/dol35ysFkaI86loGkI4nzkW3WKXzN2Cy2S0EjlxAMCzw1m0BrZWQTFSAi6eu0Gt9Gtn6FEnrNL1UFkEIIO+VegkZGDOunznXOV5yjPLEH1BlyLWwy70KlBm+QLHkKJmN5fFJdQOE29kdyv3OYnYGJPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788821161; c=relaxed/simple;
	bh=gtV9Nyjmrk9ydqJG33uKzpompBhM7l+XKcaNiY8lhWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooDCw/MWcW7VgeWpwhx8lDZda1k+E4Gy4EE75n4yVmzLDquvvCi/RtDd6LS8yi5q+hZCLqLxU4QZaxDflKsdMINQkYZ8dHvqNyHavY7KC8x7sZZy8ivxKggLJMEaBH0fNJRt4t2lspz1qo0MSDHadRQGyjDkgOhPyUQyKqxpKFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLBFxS1L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLBFxS1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF931F00A3F;
	Mon,  7 Sep 2026 22:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788821160;
	bh=ZBPsCT2Or/dRnqEl2wIHAlku6m2ElWW26OcNY7hxQvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLBFxS1LK7Y++aOGBRAXvlNSgJ5ZgqsM3ZSbn6c6i7crbps2qMQcSsZacbr3UFC+G
	 kVZ6PdaDLkcDQMyRKzuE/C5K5GkcT9wwqq+FmZmfuikBIwWY3f/TgTaMCYSITsPYrF
	 MMPnYuWMqpwybi/Sc03XQr+H8u/Q/scKU9W5bhzd3X7xwKChFc50FJpcNfePOS0a3s
	 wUTfHUroSVc6qeqqP+4B3LhBTDVTb23UgzW+SPxsojYJqrYLpU3EsQ7m0FCtz3WbK2
	 6Qi9R+HjLQuIcG9sipF+nOPzGuSczx4DN+q5aKbgFJ8LYOHoyRCFDhgaWafLtih74c
	 hSz4SoVHyxxww==
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
Subject: [PATCH 6.1.y 3/4] cifs: SMB1 split: Create smb1proto.h for SMB1 declarations
Date: Mon,  7 Sep 2026 18:45:54 -0400
Message-ID: <20260907224555.689206-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907224555.689206-1-sashal@kernel.org>
References: <2026090304-drowsily-unread-e280@gregkh>
 <20260907224555.689206-1-sashal@kernel.org>
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
Stable-dep-of: 730d0bb19507 ("smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h      |  2 --
 fs/smb/client/cifsproto.h     | 11 +---------
 fs/smb/client/smb1proto.h     | 40 +++++++++++++++++++++++++++++++++++
 fs/smb/client/smb1transport.c |  2 +-
 4 files changed, 42 insertions(+), 13 deletions(-)
 create mode 100644 fs/smb/client/smb1proto.h

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a5e9f79c10f90..8717f85328cf1 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1995,8 +1995,6 @@ extern mempool_t *cifs_mid_poolp;
 
 /* Operations for different SMB versions */
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-extern struct smb_version_operations smb1_operations;
-extern struct smb_version_values smb1_values;
 extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
 #endif /* CIFS_ALLOW_INSECURE_LEGACY */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index e23a3dcf96af4..ee5c5dda06942 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -12,6 +12,7 @@
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
+#include "smb1proto.h"
 
 struct statfs;
 struct smb_rqst;
@@ -416,16 +417,6 @@ extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
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
index 0000000000000..8dfc6976ceba1
--- /dev/null
+++ b/fs/smb/client/smb1proto.h
@@ -0,0 +1,40 @@
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
+bool cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+		       char *buf, int malformed);
+
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+#endif /* _SMB1PROTO_H */
diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index a27206cb1fc89..b79256be7380d 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -382,7 +382,7 @@ cifs_downgrade_oplock(struct TCP_Server_Info *server,
 	cifs_set_oplock_level(cinode, oplock);
 }
 
-static bool
+bool
 cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		  char *buf, int malformed)
 {
-- 
2.53.0

