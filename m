Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFE4549B1F8;
	Tue,  1 Sep 2026 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788286918; cv=none; b=iAqV1QeXfjz81e+15JGidU7zjjK3LMmupZFqUkqMJJdwPqtM1c7a2jSnzCLTFkLscwmTL3ydP3zPXQBki35mXc+rf2z/7+o2yr+lR9d+zL3swGKE8MjwpI85o9F0M3EjSaX79daEP6cFpnxns4GZopFeXuvixswiTFxDPNcVjKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788286918; c=relaxed/simple;
	bh=qcbqwjo8PQ6HOaFe+HESTBjYFEM7Qgci90O8hxG6YPo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NVcRlfJs1vzRLhvns68R1D7zI0jStvWIkz6beFFYHXi1xCcMdp7YuLNcBfosB54+sLXaPD1YTmMOICQV2qrli7AESLoeGO1wR1lN1+JhHvr80kPSJPfyUscnnjz6B35Wa5lxf4WpFNxKz43NHu+ACMhPjGTP7Vux6WAx4XW6JnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=pP1dPX9x; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="pP1dPX9x"
Received: from localhost.localdomain (unknown [52.172.102.219])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4993E20B7166;
	Tue,  1 Sep 2026 11:21:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4993E20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788286880;
	bh=j8p0fHYDQhDNXEvnAW4cKjXCyIpdjeOjWC3CDthUOCI=;
	h=From:To:Cc:Subject:Date:From;
	b=pP1dPX9xSEtbkNo1feR0YamEim4twVmOSp3MMncT84klmhFJ361Z+m/HWkY3EZI0C
	 PiDXdO4tSifA4gQibyRa0ilQS5FLI+bMZZJzMKbatsrr4GtEyd0y7Nv75pidixxk36
	 awCu+lfk9Tg5HMLrwcDSM5iODkqAMPKzGnxm85Qk=
From: "Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>
To: linkinjeon@kernel.org,
	smfrench@gmail.com
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	nicholas@carlini.com,
	bahubali.bg@samsung.com,
	kees@kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	AutonomousCodeSecurity@microsoft.com,
	xmei5@asu.edu,
	tgopinath@linux.microsoft.com,
	kys@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>
Subject: [PATCH] ksmbd: fix tree connection use-after-free in smb2_tree_connect()
Date: Tue,  1 Sep 2026 14:21:36 -0400
Message-ID: <20260901182136.13745-1-cenzhang@linux.microsoft.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_tree_conn_connect() publishes a new tree connection in
sess->tree_conns with a single reference and returns its pointer to
smb2_tree_connect(). The handler continues to initialize the object and
build the response after publication. A concurrent session logoff can
erase the connection and drop that reference, freeing the object while
the handler still uses it.

BUG: KASAN: slab-use-after-free in smb2_tree_connect+0xe3d/0xf90
  smb2_tree_connect (fs/smb/server/smb2pdu.c:2872)
  handle_ksmbd_work
  process_one_work
  worker_thread
  kthread

After xa_store() succeeds, take a second reference before releasing
tree_conns_lock. The original reference belongs to the xarray entry and
the second belongs to the creating smb2_tree_connect() handler.

Keep the references balanced in every path:

- On normal exit or an error after publication, smb2_tree_connect()
  drops its creator reference. Error cleanup also calls
  ksmbd_tree_conn_disconnect(), which drops the xarray reference only if
  it removes the exact entry.
- SMB2 TREE_DISCONNECT uses the same helper to remove the entry and drop
  its xarray reference. The request's existing lookup reference remains
  owned by the request and is released by the existing cleanup.
- Session LOGOFF removes each entry and drops its xarray reference. If
  it wins the race, later cleanup sees that the entry is gone and does
  not drop that reference again.

To enforce this ownership, claim the disconnected state and erase the
exact entry atomically under tree_conns_lock. This guarantees one drop
for the xarray reference and one drop by each in-flight user, regardless
of which teardown path wins. If logoff removes the entry before
initialization completes, fail the connect instead of marking the
detached object TREE_CONNECTED.

Fixes: 33b235a6e6eb ("ksmbd: fix race condition between tree conn lookup and disconnect")
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Cc: AutonomousCodeSecurity@microsoft.com
Cc: stable@vger.kernel.org
Signed-off-by: Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
---
 fs/smb/server/mgmt/tree_connect.c |  8 ++++++++
 fs/smb/server/smb2pdu.c           | 28 +++++++++++++---------------
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index 5f63e236267a..dd1db3554cae 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -82,6 +82,8 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 	down_write(&sess->tree_conns_lock);
 	ret = xa_err(xa_store(&sess->tree_conns, tree_conn->id, tree_conn,
 			      KSMBD_DEFAULT_GFP));
+	if (!ret)
+		atomic_inc(&tree_conn->refcount);
 	up_write(&sess->tree_conns_lock);
 	if (ret) {
 		status.ret = -ENOMEM;
@@ -129,6 +131,12 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 			       struct ksmbd_tree_connect *tree_conn)
 {
 	down_write(&sess->tree_conns_lock);
+	if (tree_conn->t_state == TREE_DISCONNECTED ||
+	    xa_load(&sess->tree_conns, tree_conn->id) != tree_conn) {
+		up_write(&sess->tree_conns_lock);
+		return -ENOENT;
+	}
+	tree_conn->t_state = TREE_DISCONNECTED;
 	xa_erase(&sess->tree_conns, tree_conn->id);
 	up_write(&sess->tree_conns_lock);
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 903ffffdd187..e7c965e7b068 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2804,6 +2804,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	struct ksmbd_session *sess = work->sess;
 	char *treename = NULL, *name = NULL;
 	struct ksmbd_tree_conn_status status;
+	struct ksmbd_tree_connect *tree_conn = NULL;
 	struct ksmbd_share_config *share = NULL;
 	int rc = -EINVAL;
 
@@ -2831,6 +2832,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 
 	status = ksmbd_tree_conn_connect(work, name);
 	if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
+		tree_conn = status.tree_conn;
 		rsp->hdr.Id.SyncId.TreeId = cpu_to_le32(status.tree_conn->id);
 		share = status.tree_conn->share_conf;
 
@@ -2874,8 +2876,15 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		status.tree_conn->posix_extensions = true;
 
 	down_write(&sess->tree_conns_lock);
-	status.tree_conn->t_state = TREE_CONNECTED;
+	if (status.tree_conn->t_state == TREE_DISCONNECTED) {
+		status.ret = KSMBD_TREE_CONN_STATUS_ERROR;
+		share = NULL;
+	} else {
+		status.tree_conn->t_state = TREE_CONNECTED;
+	}
 	up_write(&sess->tree_conns_lock);
+	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
+		goto out_err1;
 	rsp->StructureSize = cpu_to_le16(16);
 out_err1:
 	/*
@@ -2902,9 +2911,6 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	rc = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_tree_connect_rsp));
 	if (rc) {
 		if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
-			down_write(&sess->tree_conns_lock);
-			status.tree_conn->t_state = TREE_DISCONNECTED;
-			up_write(&sess->tree_conns_lock);
 			ksmbd_tree_conn_disconnect(sess, status.tree_conn);
 			status.tree_conn = NULL;
 		}
@@ -2945,6 +2951,9 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
 		smb2_set_err_rsp(work);
 
+	if (tree_conn)
+		ksmbd_tree_connect_put(tree_conn);
+
 	return rc;
 }
 
@@ -3048,17 +3057,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 
 	ksmbd_close_tree_conn_fds(work);
 
-	down_write(&sess->tree_conns_lock);
-	if (tcon->t_state == TREE_DISCONNECTED) {
-		up_write(&sess->tree_conns_lock);
-		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
-		err = -ENOENT;
-		goto err_out;
-	}
-
-	tcon->t_state = TREE_DISCONNECTED;
-	up_write(&sess->tree_conns_lock);
-
 	err = ksmbd_tree_conn_disconnect(sess, tcon);
 	if (err) {
 		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;

base-commit: f7e5381fe0e2956317075a6d24aad1f56d6ce382
-- 
2.55.0

