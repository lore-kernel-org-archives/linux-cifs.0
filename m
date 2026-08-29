Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA2934F259
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 11:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788003564; cv=none; b=AEs6bZg+ZlQY4zANC7/gV56CFNDVRE/kHBSdRfn2R1OrKUNWA4Um2eH+OhaB94OEg01vCaNAy3vK+oiGzrwWL8+3/Zje+7rD7DNv8LIukDYUR9KzBPBTNVSEKkcKFZ37VoRvLaGdj0Jp+ecNDeF9XYPCTvjCQnIJBsW9wCO9pQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788003564; c=relaxed/simple;
	bh=wkVf6FcCQe7uQ51rUD2Vqedu2ziy9CNtQnhC7lFs4Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y/rl/K/RUt+Ox1UN4M3fnAQHEO96pAiEZhA8Munb6g/er4i/POjpZohbIkRL2stwhK+TIEmIH89CvK5kYne+pTisDPwo/vWkgCqDEbj7UU43LDm3aSjEyxPtv88FXeAojaqEVdMMI9tXeYroGiTS32sA8BpJ6afzErtJbjW0Tac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fbJtuZWQ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fbJtuZWQ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso18464625e9.0
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 04:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788003561; x=1788608361; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xfNkiNSXms4b7S4NCuOwfo4nRXBgOTl0/DOqP5BUcpQ=;
        b=fbJtuZWQvh7ZmzJxIjxygpugCVIhR8uvnN6eFzHIK6O1JloMUSDFacL7GPhaxLBtWD
         1yyfaW9XhofCr7H+G/5KXKl/Jnq4Dv43PNoMA54xfUcL1yKsFNSt6EYkBZ3oMwjqJFW1
         DWtx3BhEPJH/HDE6LjXDzFC06pxEeijxj+ptGlE9yomkCLEQzJpDGPWllL2/Z10K/RVe
         S5+0y1tDAGKe6FbbzWU0XhsP+Z2xiDTLcwNetCh2E+MRcaVOxTzRHk8RH1iXk+hrscwy
         OpVwHSuovNpEHs8HBliuu7MLiQO63+bxxZyrDyK/mU2a6WGVp4MI6/ApgcHSvORycvFK
         4HDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788003561; x=1788608361;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xfNkiNSXms4b7S4NCuOwfo4nRXBgOTl0/DOqP5BUcpQ=;
        b=MdOJ3maX+47X/Jk3RTAhxr7NDjt3FASSmSG8BHLJ1NqHhfI37xb6cnQFAte1mKeT+b
         ueneUMoOB6zfrHY0AyfSeOaoK1bjhGkyOok660oUhBaU80F7NWH3YNrj8oStlV6nZH6B
         GZbkcUQg7NLMg7VubYzMFsF13FPehQSsIqPWlX23sHPh56X3UAdzhIwnCNx/NrOiET0n
         00C789OhSCqrD2kfrgJq0tzK5gghFTEteY8qlWjISE7VUDsXFKKhNZxyMhk6gJOv6F5g
         xctKmy0BYm10ntq58Dn1OhdVq3AleBN/TqZWyJpZl+mywubSWemUOlbESOgbn4dDM7pf
         UMRQ==
X-Gm-Message-State: AFuF++ndGTAlQabppOY+UvIzKSuUi0BqjEv6NR1ruiMLyWvE9bP4XzNz
	3kxYjpiUkVMbqdCtMgTze93cMc9gYYpMw+QbA6b6c6nKJdPaEJ3Ld3Za1DcCxQQO
X-Gm-Gg: AR+sD12QNAoo/8ol5j/8JqhkQIJApZOLJ50E9W4JZntf9VC//3n3Org0YdKjKyLwruC
	D0obrD2xWTmpLzNGKereCtPeoSbSX+NhYK/qDUQ7XAVWogwmYWvHPX1V1rk7KQ6dI4I985iuNfF
	pFXa6e5XabfyDinwTSo+bPIEL5Pyti0Glt53INRe0FmAWxUZ6TzdLQcWUesHzrCs44DbXdIqbSm
	QU7JmMrRn9jfF7UiwJlg3bc+tNk9cgtXXEpJM/RvtShcPUolUw8O4f+thXyD0dj8Dt8ofOBd1XM
	WefTCeXHUDCTYL0kUi1zAwG+9YlgfSRUoyvKakJlNwWv375nKZHcTIfYEZkRatJN8iiTPztUmER
	2wBBnuAFpymuQMUCX4huuEO7QcuLTb6LrvSvE5MeZ+aEERTI7bM/Zz1GWx7ENa37U94FSP0Cn2d
	4Q1zSQYTFrOivSYgOLYeV83dVaHU7q7jqN53VVGAnIIRL96hRK3NUdp+M7LPB2gs9S1FEV
X-Received: by 2002:a05:600c:699b:b0:49b:e22:4ee4 with SMTP id 5b1f17b1804b1-49cca2fee49mr75604335e9.4.1788003560590;
        Sat, 29 Aug 2026 04:39:20 -0700 (PDT)
Received: from SurHub.localdomain ([196.188.112.230])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b91c52fdbsm100542215e9.0.2026.08.29.04.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 04:39:20 -0700 (PDT)
From: Abdifatah Suruur <suruurism@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com
Subject: [PATCH v2] ksmbd: fix use-after-free in oplock break notification
Date: Sat, 29 Aug 2026 14:39:17 +0300
Message-ID: <20260829113917.26882-1-suruurism@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_oplock_break_noti() reads opinfo->conn without any lock and
dereferences it after two allocations which may sleep.  When the
durable handle owning the oplock is disconnected, session_fd_check()
clears opinfo->conn and drops its conn reference under ci->m_lock, and
the last ksmbd_conn_put() frees the connection.  A break triggered by
another connection that races with the teardown can then resurrect the
freed connection: ksmbd_conn_get() is a plain atomic_inc, and the
queued break work later dereferences the stale conn via
ksmbd_conn_write(), a use-after-free reachable by any authenticated
client holding a durable batch oplock.

Give the oplock_info its own reference on the inode (o_ci) so the
notification path can take ci->m_lock without dereferencing
opinfo->o_fp, which is not pinned by the oplock_info reference and may
be freed by a concurrent close.  Select and pin the connection under
ci->m_lock, the same lock session_fd_check() uses to clear
opinfo->conn, so a concurrent teardown either loses the race to the
clear or keeps the connection alive until the notification work
releases it.  Transfer the reference to the work item and release it
on allocation failures.

Fixes: b003086d7696 ("ksmbd: fix NULL-deref of opinfo->conn in oplock/lease break notifiers")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
---
v2:
- The oplock_info now holds a reference on the inode (o_ci), taken
  when the oplock is granted and released when the oplock_info is
  freed, so smb2_oplock_break_conn_get() no longer dereferences
  opinfo->o_fp, which a concurrent close may free (review from Namjae
  Jeon).
---
 fs/smb/server/oplock.c    | 38 +++++++++++++++++++++++++++++++++++---
 fs/smb/server/oplock.h    |  1 +
 fs/smb/server/vfs_cache.h |  6 ++++++
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 58af0fddf39f2..fcd1210de980c 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -9,6 +9,7 @@
 
 #include "glob.h"
 #include "oplock.h"
+#include "vfs_cache.h"
 
 #include "smb_common.h"
 #include "../common/smb2status.h"
@@ -236,6 +237,8 @@ static void __free_opinfo(struct oplock_info *opinfo)
 {
 	if (opinfo->is_lease)
 		free_lease(opinfo);
+	if (opinfo->o_ci)
+		ksmbd_inode_put(opinfo->o_ci);
 	ksmbd_conn_put(opinfo->conn);
 	kfree(opinfo);
 }
@@ -924,6 +927,30 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 	ksmbd_conn_put(conn);
 }
 
+/*
+ * Select and pin the connection used for an oplock break before doing any
+ * allocations which may sleep.  opinfo->conn is cleared under ci->m_lock by
+ * session_fd_check() when the durable handle owning the oplock is
+ * disconnected, and the last ksmbd_conn_put() frees the connection.  The
+ * oplock_info holds its own reference on the inode (o_ci, taken when the
+ * oplock was granted), so the lock is always reachable here without
+ * dereferencing opinfo->o_fp, which a concurrent close may free.
+ */
+static struct ksmbd_conn *smb2_oplock_break_conn_get(struct oplock_info *opinfo)
+{
+	struct ksmbd_conn *conn;
+
+	down_read(&opinfo->o_ci->m_lock);
+	conn = READ_ONCE(opinfo->conn);
+	if (conn && !ksmbd_conn_releasing(conn))
+		conn = ksmbd_conn_get(conn);
+	else
+		conn = NULL;
+	up_read(&opinfo->o_ci->m_lock);
+
+	return conn;
+}
+
 /**
  * smb2_oplock_break_noti() - send smb2 exclusive/batch to level2 oplock
  *		break command from server to client
@@ -938,17 +965,20 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 	int ret = 0;
 	struct ksmbd_work *work;
 
-	conn = READ_ONCE(opinfo->conn);
+	conn = smb2_oplock_break_conn_get(opinfo);
 	if (!conn)
 		return ksmbd_invalidate_durable_fd(opinfo->fid);
 
 	work = ksmbd_alloc_work_struct();
-	if (!work)
+	if (!work) {
+		ksmbd_conn_put(conn);
 		return -ENOMEM;
+	}
 
 	br_info = kmalloc_obj(struct oplock_break_info, KSMBD_DEFAULT_GFP);
 	if (!br_info) {
 		ksmbd_free_work_struct(work);
+		ksmbd_conn_put(conn);
 		return -ENOMEM;
 	}
 
@@ -957,7 +987,8 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 	br_info->open_trunc = opinfo->open_trunc;
 
 	work->request_buf = (char *)br_info;
-	work->conn = ksmbd_conn_get(conn);
+	/* Transfer the reference acquired by smb2_oplock_break_conn_get(). */
+	work->conn = conn;
 	work->sess = opinfo->sess;
 
 	ksmbd_conn_r_count_inc(conn);
@@ -1724,6 +1755,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	 * lease_table first.
 	 */
 	opinfo->o_fp = fp;
+	opinfo->o_ci = ksmbd_inode_ref(fp->f_ci);
 	if (new_lease) {
 		new_lb = alloc_lease_table(opinfo);
 		if (!new_lb) {
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index b08d21758e07a..3e9e63514896d 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -64,6 +64,7 @@ struct oplock_info {
 	struct ksmbd_session	*sess;
 	struct ksmbd_work	*work;
 	struct ksmbd_file	*o_fp;
+	struct ksmbd_inode	*o_ci;	/* inode ref held while the oplock lives */
 	int                     level;
 	int                     op_state;
 	spinlock_t		state_lock;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 502efb16f05fc..14d3111eb7334 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -206,6 +206,12 @@ struct ksmbd_file *ksmbd_file_get(struct ksmbd_file *fp);
 void ksmbd_fd_put(struct ksmbd_work *work, struct ksmbd_file *fp);
 struct ksmbd_inode *ksmbd_inode_lookup_lock(struct dentry *d);
 void ksmbd_inode_put(struct ksmbd_inode *ci);
+
+static inline struct ksmbd_inode *ksmbd_inode_ref(struct ksmbd_inode *ci)
+{
+	atomic_inc(&ci->m_count);
+	return ci;
+}
 bool ksmbd_close_disconnected_durable_delete_on_close(struct dentry *dentry);
 struct ksmbd_file *ksmbd_lookup_global_fd(unsigned long long id);
 struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
-- 
2.53.0

