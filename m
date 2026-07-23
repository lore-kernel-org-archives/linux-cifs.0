Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4D9233134
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 03:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776673; cv=none; b=M7j+kBjoKwx6PXYDz8rl4VW5N4X6dmdcf5WPpgvqrI3s/rZG7Dgy7qoV39wRUjQThAH+RADC8aAwsCJMTH1LZQIqTCfJXwGdDiPU1JAP4uJaIRTql8jX8wF1xIsDeKj9tUjXn0UEuDo5Pw4C6wWkwabFJIeV9/uOUCeBu0nTs8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776673; c=relaxed/simple;
	bh=sBH+oiiDfXCFtgfGasv9rGav57f/aVa48GRGXU/uqUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Im2hB+nng22NQ2yL6TgjDdmtJJGI8lbx/c8fW9YznXU2+W75AICYdUXgf6coxYMpi16p0Bo/JzzdZGyNYwS40KkwInk+t6h2QgXC3wiCvRsgbmvbvz8rXd1mTZCLXbps4NBnnNfUkQEGgUON9uRVvZ/huYbLZ9tuy9V7/EFEt7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=QmdMc8wZ; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="QmdMc8wZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784776668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NC7qRYw1oktL0ftggdw2C7pFXzIBg3y7je2Q3oWItiM=;
	b=QmdMc8wZSK7Ih4clwZZ1CRCsH5Kf/22Ml+zgpht3JRnYsLqAcD9FbDdKfmB1/+iGliljup
	2EMdTxUjyyZRvYK2M+SrVvoFwu/sG+7i5y5p2qjCrcAX7OnXTIpitVeFjoRkHc1NXH/M0U
	aMsQswretcy4mzyEhXj8y6o88aW02wcXyc3s/ncFUM3S/bhGnku5VhDB9V7u3Z1bvdmv7J
	5eD0ShS83/jCHVIXvYM2kqE4xtjLnDk4rAuk+1b50P4xzjLJidBbzyzgLkD/l7neAAwECv
	Wk16oHlEp+jyIiL5qt5xmnhbG41ZWFL3suG9JU/l7Ga5oPJRG6gkV5uP9WeBwg==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH 02/11] smb/server: validate notify requests
Date: Thu, 23 Jul 2026 03:16:30 +0000
Message-ID: <20260723031644.312866-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
References: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Validate the file ID, directory type, access rights and output buffer
length before handling a change notify request.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/Makefile  |   2 +-
 fs/smb/server/notify.c  | 108 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/notify.h  |  22 ++++++++
 fs/smb/server/smb2pdu.c |  12 +++--
 4 files changed, 138 insertions(+), 6 deletions(-)
 create mode 100644 fs/smb/server/notify.c
 create mode 100644 fs/smb/server/notify.h

diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index a3e9306055e8..51d8972a0942 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -9,7 +9,7 @@ ksmbd-y :=	unicode.o auth.o vfs.o vfs_cache.o server.o ndr.o \
 		mgmt/ksmbd_ida.o mgmt/user_config.o mgmt/share_config.o \
 		mgmt/tree_connect.o mgmt/user_session.o smb_common.o \
 		transport_tcp.o transport_ipc.o smbacl.o smb2pdu.o \
-		smb2ops.o smb2misc.o ksmbd_spnego_negtokeninit.asn1.o \
+		smb2ops.o smb2misc.o notify.o ksmbd_spnego_negtokeninit.asn1.o \
 		ksmbd_spnego_negtokentarg.asn1.o asn1.o compress.o
 
 $(obj)/asn1.o: $(obj)/ksmbd_spnego_negtokeninit.asn1.h $(obj)/ksmbd_spnego_negtokentarg.asn1.h
diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
new file mode 100644
index 000000000000..ad812fde5879
--- /dev/null
+++ b/fs/smb/server/notify.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *
+ *   SMB2 CHANGE_NOTIFY
+ *
+ *   Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
+ *   Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
+ *
+ */
+
+#include "glob.h"
+#include "../common/smb2status.h"
+#include "connection.h"
+#include "ksmbd_work.h"
+#include "notify.h"
+#include "smb_common.h"
+#include "smb2pdu.h"
+#include "vfs_cache.h"
+
+static struct ksmbd_file *
+ksmbd_notify_validate_req(struct ksmbd_work *work,
+			  struct smb2_change_notify_req *req,
+			  struct smb2_change_notify_rsp *rsp)
+{
+	struct ksmbd_file *fp;
+	int err;
+
+	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId,
+				  req->PersistentFileId);
+	if (!fp) {
+		pr_err("Invalid file id for notify, fid %llu:%llu\n",
+		       le64_to_cpu(req->PersistentFileId),
+		       le64_to_cpu(req->VolatileFileId));
+		rsp->hdr.Status = STATUS_FILE_CLOSED;
+		return ERR_PTR(-ENOENT);
+	}
+
+	ksmbd_debug(NOTIFY,
+		    "fid %llu:%llu, handle notify request, filter 0x%x, flags 0x%x\n",
+		    fp->persistent_id, fp->volatile_id,
+		    le32_to_cpu(req->CompletionFilter), le16_to_cpu(req->Flags));
+
+	if (!S_ISDIR(file_inode(fp->filp)->i_mode)) {
+		pr_err("Notify file id is not a directory, fid %llu:%llu\n",
+		       fp->persistent_id, fp->volatile_id);
+		rsp->hdr.Status = STATUS_NOT_A_DIRECTORY;
+		err = -ENOTDIR;
+		goto err_put_fp;
+	}
+
+	if (!(fp->daccess & FILE_LIST_DIRECTORY_LE)) {
+		pr_err("No permission to monitor directory, fid %llu:%llu\n",
+		       fp->persistent_id, fp->volatile_id);
+		rsp->hdr.Status = STATUS_ACCESS_DENIED;
+		err = -EACCES;
+		goto err_put_fp;
+	}
+
+	if (le32_to_cpu(req->OutputBufferLength) >
+	    work->conn->vals->max_trans_size) {
+		pr_err("Notify output buffer length %u exceeds maximum %u\n",
+		       le32_to_cpu(req->OutputBufferLength),
+		       work->conn->vals->max_trans_size);
+		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		err = -EINVAL;
+		goto err_put_fp;
+	}
+
+	return fp;
+
+err_put_fp:
+	ksmbd_fd_put(work, fp);
+	return ERR_PTR(err);
+}
+
+/**
+ * ksmbd_handle_notify() - handle an SMB2 change notify request
+ * @work: smb work containing notify command buffer
+ * @req: SMB2 change notify request
+ * @rsp: SMB2 change notify response
+ *
+ * Return: 0 on success, otherwise error
+ */
+int ksmbd_handle_notify(struct ksmbd_work *work,
+			struct smb2_change_notify_req *req,
+			struct smb2_change_notify_rsp *rsp)
+{
+	struct ksmbd_file *fp = NULL;
+	int err = 0;
+
+	fp = ksmbd_notify_validate_req(work, req, rsp);
+	if (IS_ERR(fp)) {
+		err = PTR_ERR(fp);
+		goto out;
+	}
+
+	ksmbd_fd_put(work, fp);
+	rsp->hdr.Status = STATUS_NOT_IMPLEMENTED;
+	err = -EOPNOTSUPP;
+
+out:
+	if (err)
+		pr_err("Failed to handle notify request: %d, status: 0x%x\n",
+		       err, le32_to_cpu(rsp->hdr.Status));
+	if (rsp->hdr.Status != STATUS_SUCCESS)
+		smb2_set_err_rsp(work);
+	return err;
+}
diff --git a/fs/smb/server/notify.h b/fs/smb/server/notify.h
new file mode 100644
index 000000000000..3118ad09c841
--- /dev/null
+++ b/fs/smb/server/notify.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *
+ *   SMB2 CHANGE_NOTIFY
+ *
+ *   Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
+ *   Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
+ *
+ */
+
+#ifndef __SMB_SERVER_NOTIFY_H__
+#define __SMB_SERVER_NOTIFY_H__
+
+struct ksmbd_work;
+struct smb2_change_notify_req;
+struct smb2_change_notify_rsp;
+
+int ksmbd_handle_notify(struct ksmbd_work *work,
+			struct smb2_change_notify_req *req,
+			struct smb2_change_notify_rsp *rsp);
+
+#endif /* __SMB_SERVER_NOTIFY_H__ */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0680222a8da4..fe1b6c9f71c5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -29,6 +29,7 @@
 #include "vfs.h"
 #include "vfs_cache.h"
 #include "misc.h"
+#include "notify.h"
 
 #include "server.h"
 #include "smb_common.h"
@@ -10860,22 +10861,23 @@ int smb2_notify(struct ksmbd_work *work)
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
 
-	ksmbd_debug(SMB, "Received smb2 notify\n");
+	ksmbd_debug(NOTIFY, "Received smb2 notify\n");
 
 	WORK_BUFFERS(work, req, rsp);
 
-	if (smb2_compound_has_failed(work, &rsp->hdr))
+	if (smb2_compound_has_failed(work, &rsp->hdr)) {
+		pr_err("Failed compound notify request\n");
 		return -EACCES;
+	}
 
 	if (work->next_smb2_rcv_hdr_off && req->hdr.NextCommand) {
+		pr_err("Notify request is not the last compound command\n");
 		rsp->hdr.Status = STATUS_INTERNAL_ERROR;
 		smb2_set_err_rsp(work);
 		return -EIO;
 	}
 
-	smb2_set_err_rsp(work);
-	rsp->hdr.Status = STATUS_NOT_IMPLEMENTED;
-	return -EOPNOTSUPP;
+	return ksmbd_handle_notify(work, req, rsp);
 }
 
 /**
-- 
2.54.0

