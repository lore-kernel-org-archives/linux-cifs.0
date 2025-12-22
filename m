Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2E734B190
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442679; cv=none; b=IM/NIdPcMcidFSI5eeFziRtf7C1hWMCw17GSmETWW+tgR8OrBJ0Cj1ecMNL7JSq9QgM2AGbcOyFz1MYUE4wQhDWjdn5UsRqvRkyacrjzkHGy6GFZnGqCMUM5HvcODowPA5NV206EWWLC2LeADY0yowpSXS3GcEhmTsOlzLPl6NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442679; c=relaxed/simple;
	bh=jaJ5Kb+s3DYkT6rX0Vxfn5kHYyhfDtvwkMOZKu4Trbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEQNehqvGccH2SsBcyQ9PwDJpQNS1FcZYfPYukUFnzR4Ce/s1YyhMxrH2uLzC0pHtQDOpXKYLSNDrYi6RW8vtqa2Y5rWnShLVm1jtXFYoynBjdrgVeW3eDRI8a6kahyNi2F/U0ZKhhHWG2AxKMwNpGERn4s86LiUre46iS7vmRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MzIFPrbL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MzIFPrbL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9m+PVjJvk9dS4cyyO8MGb648iBmJWns2y99mYWcomQ8=;
	b=MzIFPrbL1+W7cZKBhii4zIamU3XQEsNAHFFtAeD6h2KevUjCeFi5JlR4AbRjtaDWVa2amJ
	Zvc7FMqSVMFQU9SCeNnUuJfnY0cAijczX13N6Wd0bkIDQF0AQyGEas2U2Qq9KdWItSqYnF
	o2wz0LtYsSnO+x4h/SbQ9rQuMquktMI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-sea2g35aMqeYKr9nFTpfrw-1; Mon,
 22 Dec 2025 17:31:15 -0500
X-MC-Unique: sea2g35aMqeYKr9nFTpfrw-1
X-Mimecast-MFC-AGG-ID: sea2g35aMqeYKr9nFTpfrw_1766442674
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D43EA1800451;
	Mon, 22 Dec 2025 22:31:13 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 206A21800669;
	Mon, 22 Dec 2025 22:31:11 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 20/37] cifs: SMB1 split: Create smb1proto.h for SMB1 declarations
Date: Mon, 22 Dec 2025 22:29:45 +0000
Message-ID: <20251222223006.1075635-21-dhowells@redhat.com>
In-Reply-To: <20251222223006.1075635-1-dhowells@redhat.com>
References: <20251222223006.1075635-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/cifsglob.h  |  2 --
 fs/smb/client/cifsproto.h | 11 +----------
 fs/smb/client/smb1proto.h | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 12 deletions(-)
 create mode 100644 fs/smb/client/smb1proto.h

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index b0fefdd4f624..7001004ee106 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2120,8 +2120,6 @@ extern mempool_t cifs_io_subrequest_pool;
 
 /* Operations for different SMB versions */
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-extern struct smb_version_operations smb1_operations;
-extern struct smb_version_values smb1_values;
 extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 75a474f9e99a..6454c5847724 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -14,6 +14,7 @@
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
+#include "smb1proto.h"
 
 struct statfs;
 struct smb_rqst;
@@ -404,16 +405,6 @@ int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
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
 int CIFSSMBUnixSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			   const struct cifs_unix_set_info_args *args, u16 fid,
 			   u32 pid_of_opener);
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
new file mode 100644
index 000000000000..0088edbcc73f
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
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
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

