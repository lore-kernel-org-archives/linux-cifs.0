Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1419526A83;
	Mon,  7 Sep 2026 20:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811225; cv=none; b=YgQ/3tcxTkddkieMtD9+y17U4DObif0ihAKYvci0Haiuq3KQWi8tLnxqhIUrTDvCQ6fqUG7BEHEQ8aVmRKYT+mJvunS1uynOIFdYf4+qhWxVrtCEB+ae0zQmiCz0J30wF5gCQXxAMohYSyblL7W7KXTgx93PJJ4qM8i52Duypw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811225; c=relaxed/simple;
	bh=tbUzkAYiYH0rLwE4BzsOOHZejC/5GsvU139wZhR7+S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxq+1yzOyOA/qyt5sraqRrd9x53Q+fQjaNgSn+6olV9ieVpcd7kYoCjIUJOk0G9avI7gAzBtAEO7qUMgDtNWR1QjR4NMbeF3OlLehN+lvP5smkguDA6PR7FjRWlPhLzpg+LF+WwFTvooMW8DRfVvWtYgeWBRrkEzyuPqU5NZb2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMN2sEDZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMN2sEDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8072F1F00A3E;
	Mon,  7 Sep 2026 20:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788811223;
	bh=LT9PIEG9rEjUhJObKdjLdYZXQvfXjA3gqdING8qZQCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMN2sEDZhxVOgMnCCFatpi5YfqWLSbyWz3GSJQ8uVdJrfPFaMH6XCf53xrMwzXFLm
	 vx+PWH+pBvyBh3qiQ+ICjlz2ObTMe5/EJAa97T36ZffqIm4IEBZmubdaW8qkT69ahB
	 QCim9hbZc3V4jcGtOqMDvYSIPG2wX8c2KIfvcZlUyslDwOutERiBJocAlYLmiSu0/T
	 U5YyyYSlbpnOxJDHRjz4wuAK2tD3sKRN0MSaHAMDSLxoO+DYp/+dF/p4OdGKuo0YB7
	 nyPzLH/43dIo/lX7/Xi0B4u0PuazovYrSEGuDWTuVXufb6SKRp3y4S8+t/42lhUuHt
	 hQWD4/6Sjgdig==
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
Subject: [PATCH 6.6.y 3/4] cifs: SMB1 split: Create smb1proto.h for SMB1 declarations
Date: Mon,  7 Sep 2026 16:00:17 -0400
Message-ID: <20260907200018.326904-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907200018.326904-1-sashal@kernel.org>
References: <2026090303-fiddling-giant-6389@gregkh>
 <20260907200018.326904-1-sashal@kernel.org>
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
index 36f5010d3787d..9f0a6eaa9b4e3 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
+#include "smb1proto.h"
 
 struct statfs;
 struct smb_rqst;
@@ -424,16 +425,6 @@ extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
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

