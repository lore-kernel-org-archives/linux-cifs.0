Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67FF299929
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 11:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788003529; cv=none; b=RRjy1+qhil7CNXmaUVt7T/PTdHg8SiSBd4xeg7s6SgQod/JMdKSTOiIJAZtmiCbhtrqVlxjmvNpEW4Uf8kJZvKUWwQ8//776KYIz57uNxl7Rex4AOwCiHBziNMr3lEzjUW04Q5OIehU7OO4vqNbtNyWCvWec4WllinJdm1O37sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788003529; c=relaxed/simple;
	bh=wkVf6FcCQe7uQ51rUD2Vqedu2ziy9CNtQnhC7lFs4Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LuWpq/COBhvrOWHugnzDE8VNJRS3G4BAXeUbdJXphbrk4sZgz2uwli/jVsLsGqv+euNZNRjhbjQ4QnuKdhWG2KdWDPpnnGkUWt0z0cgq5MoCieLAl4gLAVDffLdgrTjYcv+2NRf+Davl7EiD7yHFwa/srakVZrzG0sdIyTo7oNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d+CK10kq; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d+CK10kq"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so17553985e9.1
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 04:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788003526; x=1788608326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xfNkiNSXms4b7S4NCuOwfo4nRXBgOTl0/DOqP5BUcpQ=;
        b=d+CK10kq6YFLhno5MFRj3M93ozx29XXWg9KJKTcl8vQ7gaB+R/NB5hsEZIneu1cXWV
         pQgt2OKtBLmJZVr5K4BbW+yUu37srn5JsWyCvfPhFWMa+eIln4e2JD8q488sBjNeFwCn
         CmyVxLkGC6EsBlJkhMw7P0Jh+MX4+xobFzppb47JC5KyW5KqD7dkh0hTnWw4SEUy1Xus
         JtEhyNwWTSAHLy0decrRojEaM8vj/U3yFjAgtQWNaKM0iXBr4vWyeO8bgmtVImBXaK1G
         b+mlkjXrQP3UKUW692fwzcE7+Xqt3PqgwQ18ggRjIckU0PAuO2zxPirHwrAzdar0uCy8
         SuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788003526; x=1788608326;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xfNkiNSXms4b7S4NCuOwfo4nRXBgOTl0/DOqP5BUcpQ=;
        b=SpYkve/vDXiJYmYe88bT4QbWctyIimiVJyZEqvkhdfaOWAx9zctcsOmUd0hUDdEXpq
         ULygTt+xPEsE8e9dmO3eVjaH7ekqovP1WShZqrk8sq+U+nwwj67IC7zt6EgN9qp7gGHd
         5z8XVMZWbBJKZ2VfmIdDZW6O5BOs+f2dvSz/t5bvCj1CB4nCCyJptSM/yc0zO3fZ90Lb
         dGLKe8gBo5fXkMQH9wlysXAMtChGqAKAaxouA8SDXhEHFRGd690SDCdgtajKj6hoxr6u
         h/pqN03qiA1yvmGcqy2Hk/z5VK4evLmHn27AGowUQMQj5aHZiXoM7dgU4To7kTpFfitz
         khCg==
X-Gm-Message-State: AFuF++mhS8UV+GNIqSgK/ccIULiHhYVxl5/q89KVPP+ltp3IQtxRLQ1t
	PFD612uzkG04xOlcs9tUArJkDiFEIOOsQyUVrEa5Y7go81ZaDhZksHezMSXHJpJG
X-Gm-Gg: AR+sD10Vz1Jujru87R6ELGiMxNIfkjh0Qx6G6SxKWIE44dN8YKr5lFUzxk87mqllFM8
	GPMS6sGBi5Sow1TNRY9nEpGiwrDBL/gpKtCLF/Amdrpl1A1ZF/+scNUz4hfeVUXgAm/Ik8EJP/q
	deipoSaxkanRPIRfR343tW4AhkpgBw5ZAjmbWM/S9VEhIXN3VoPNDqaA9/JQi6w/8n4xvY0ktcS
	cBpdwv/ZkMHkFNUxSN42sICvxRBMjdVG7533U6GWWiZmq3wulHNsAECBhiv54b0XGbDtKJWZnb2
	Lxv8wCQNDIdmAuMkE+Tv56+PP4H+bc79sifbG+xQ0qnNB7fx2tnvE4VM0QIh7E1AyKxlgoSkoEh
	bFbs9j2RkhkKVkP0XdFlDKYLTggLE5TqNN8R5zcKllGhWf4RezO50BGg2UY6zrLPCMvAuXVgK7G
	ZjB1YjeKbqlm+XWHgOKr+6gl+XbJ3Cu5KPBnbwKrVsDeWORmgpPVXRI4ZXM9kgNGNvyyxRQeMPr
	M7jU5E=
X-Received: by 2002:a05:600c:34d2:b0:49c:cbad:1c44 with SMTP id 5b1f17b1804b1-49ccbad1cf1mr77289975e9.6.1788003525435;
        Sat, 29 Aug 2026 04:38:45 -0700 (PDT)
Received: from SurHub.localdomain ([196.188.112.230])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9267c369sm88905995e9.3.2026.08.29.04.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 04:38:44 -0700 (PDT)
From: Abdifatah Suruur <suruurism@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com
Subject: [PATCH] ksmbd: fix use-after-free in oplock break notification
Date: Sat, 29 Aug 2026 14:38:41 +0300
Message-ID: <20260829113841.26772-1-suruurism@gmail.com>
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

