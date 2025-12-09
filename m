Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9C81A9B46;
	Tue,  9 Dec 2025 00:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239394; cv=none; b=GSsZtHpPvLtcBS6lq4IV0BtCa5wtyJQSprrnPz/oPks2xgOvGZoYfRiztczWUqKGQpFNKIweKbM71l5a/JtvKhWv//3DinTRzM6xtWhdQEVgSeI3ey1v0665KMN5TObBbzoVxHEsIMXlZzEOPBritcN0aQLbtiqu9VcUC/0QEGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239394; c=relaxed/simple;
	bh=duboxOz7hHbTFe/CWc9JU1WdubW0HH7RwlH9bHCtJII=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aOzFsGDNdrLa+2Fiyvtc/AQxj+vViRJeHDJ/A651MFZNtm2S0caoCZG6Mcci6BQd4P8k/N3a1fNAWKY+YPA4UfCK23Fbb7jkC73hcXxQqfT75xmlv+ixJ0lGg6FXEPHFlODkd4sWwcEeg0lkcBb0zRJhDRVzUQNGhEYZkwFqiiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYNu3JV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYNu3JV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE88C4CEF1;
	Tue,  9 Dec 2025 00:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239394;
	bh=duboxOz7hHbTFe/CWc9JU1WdubW0HH7RwlH9bHCtJII=;
	h=From:To:Cc:Subject:Date:From;
	b=DYNu3JV4di9GUNwcfgILuSTptk59XsFY6Qzu5dxZkzt+oN9QMtaTnEqXVcuj0nsZM
	 TFyXW53C++MiHVQpFFbYDLWqROAYQuPU3SPE4ahX3fG0LkxFIxo2gH3+sS/8NL3b7I
	 gWB9ir0vVdLL5L1IX4V4U/OoeLkdNDr+nAc1CVAf1dyqDE7NPVATlsJquh1MHnBdcD
	 aJJy7uiB10Vvb2KeIcXlUjyZxyBllwqThNBuVFm9ohc4Kjue6DthqYXDhIQ9bKbzmV
	 7MWvLmHA1gYXkYaZjeKXp0MDF1ZL9D45f9/0VxrUeqmqtV3DIsqhWfBUJX6gMVGvby
	 rilLOIiMbEGtA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency
Date: Mon,  8 Dec 2025 19:14:53 -0500
Message-ID: <20251209001610.611575-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit b39a1833cc4a2755b02603eec3a71a85e9dff926 ]

Under high concurrency, A tree-connection object (tcon) is freed on
a disconnect path while another path still holds a reference and later
executes *_put()/write on it.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### 3. CLASSIFICATION

This is a **security/stability bug fix**:
- **Use-after-free (UAF)** is a serious memory safety issue
- ksmbd is **network-facing code** (SMB server) - security-sensitive
- Can lead to kernel crashes, data corruption, or potential remote
  exploitation

### 4. SCOPE AND RISK ASSESSMENT

**Size**: ~30 lines changed across 3 files
**Files affected**:
- `fs/smb/server/mgmt/tree_connect.c` - core reference counting logic
- `fs/smb/server/mgmt/tree_connect.h` - struct definition
- `fs/smb/server/smb2pdu.c` - disconnect path

**Technical mechanism of the bug**:

The previous fix (commit 33b235a6e6ebe) introduced a waitqueue-based
refcount mechanism:
1. `ksmbd_tree_conn_disconnect()` would decrement refcount, wait for it
   to hit 0, then always call `kfree()`
2. `ksmbd_tree_connect_put()` would decrement refcount and wake up
   waiters

**The race condition**:
- Thread A: In disconnect, waits for refcount to hit 0, then runs more
  code before `kfree()`
- Thread B: Drops last reference via `_put()`, refcount hits 0
- Thread A: Wakes up, but Thread B might still be executing code that
  accesses `tcon`
- Thread A: Frees `tcon`
- Thread B: UAF when accessing `tcon` after `_put()` returns

**The fix**: Changes to standard "kref-style" reference counting:
- Whoever drops refcount to 0 immediately calls `kfree()`
- No window between refcount hitting 0 and free
- Removes the buggy waitqueue mechanism entirely

**Risk**: LOW
- The new pattern (free on last put) is the standard kernel pattern
  (kref)
- Simpler code is easier to verify correct
- Self-contained within tree_connect subsystem

### 5. USER IMPACT

- **Affected users**: Anyone running ksmbd (kernel SMB server)
- **Trigger**: High concurrency - realistic for file servers
- **Severity**: HIGH - kernel crash or potential security exploitation
- **Real-world occurrence**: Two Reported-by tags confirm users hit this

### 6. STABILITY INDICATORS

- Signed-off by ksmbd maintainer (Namjae Jeon) and CIFS/SMB maintainer
  (Steve French)
- Two independent reporters indicate real bug
- The buggy code was introduced in commit 33b235a6e6ebe (v6.6-rc1)

### 7. DEPENDENCY CHECK

- The fix is self-contained
- Depends only on commit 33b235a6e6ebe being present (which introduced
  the bug)
- Affects: v6.6 and all later versions
- Should apply cleanly - only 2 minor unrelated commits to
  tree_connect.c since the buggy commit

### Summary

| Criterion | Assessment |
|-----------|------------|
| Fixes real bug | ✅ UAF in network-facing code |
| Security impact | ✅ High - potential remote exploitation |
| Small and contained | ✅ ~30 lines, 3 files, single subsystem |
| No new features | ✅ Pure bug fix |
| User-reported | ✅ Two Reported-by tags |
| Clean backport | ✅ Self-contained fix |

This commit fixes a use-after-free vulnerability in ksmbd, the in-kernel
SMB server. The bug exists in the reference counting mechanism for tree
connections and can be triggered under concurrent access - a realistic
scenario for network file servers. UAF bugs in network-facing kernel
code are serious security issues. The fix is small, uses a well-
established kernel pattern (kref-style refcounting), and is self-
contained. It should be backported to all stable kernels containing
commit 33b235a6e6ebe (v6.6+).

**YES**

 fs/smb/server/mgmt/tree_connect.c | 18 ++++--------------
 fs/smb/server/mgmt/tree_connect.h |  1 -
 fs/smb/server/smb2pdu.c           |  3 ---
 3 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index ecfc575086712..d3483d9c757c7 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -78,7 +78,6 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 	tree_conn->t_state = TREE_NEW;
 	status.tree_conn = tree_conn;
 	atomic_set(&tree_conn->refcount, 1);
-	init_waitqueue_head(&tree_conn->refcount_q);
 
 	ret = xa_err(xa_store(&sess->tree_conns, tree_conn->id, tree_conn,
 			      KSMBD_DEFAULT_GFP));
@@ -100,14 +99,8 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 
 void ksmbd_tree_connect_put(struct ksmbd_tree_connect *tcon)
 {
-	/*
-	 * Checking waitqueue to releasing tree connect on
-	 * tree disconnect. waitqueue_active is safe because it
-	 * uses atomic operation for condition.
-	 */
-	if (!atomic_dec_return(&tcon->refcount) &&
-	    waitqueue_active(&tcon->refcount_q))
-		wake_up(&tcon->refcount_q);
+	if (atomic_dec_and_test(&tcon->refcount))
+		kfree(tcon);
 }
 
 int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
@@ -119,14 +112,11 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 	xa_erase(&sess->tree_conns, tree_conn->id);
 	write_unlock(&sess->tree_conns_lock);
 
-	if (!atomic_dec_and_test(&tree_conn->refcount))
-		wait_event(tree_conn->refcount_q,
-			   atomic_read(&tree_conn->refcount) == 0);
-
 	ret = ksmbd_ipc_tree_disconnect_request(sess->id, tree_conn->id);
 	ksmbd_release_tree_conn_id(sess, tree_conn->id);
 	ksmbd_share_config_put(tree_conn->share_conf);
-	kfree(tree_conn);
+	if (atomic_dec_and_test(&tree_conn->refcount))
+		kfree(tree_conn);
 	return ret;
 }
 
diff --git a/fs/smb/server/mgmt/tree_connect.h b/fs/smb/server/mgmt/tree_connect.h
index a42cdd0510411..f0023d86716f2 100644
--- a/fs/smb/server/mgmt/tree_connect.h
+++ b/fs/smb/server/mgmt/tree_connect.h
@@ -33,7 +33,6 @@ struct ksmbd_tree_connect {
 	int				maximal_access;
 	bool				posix_extensions;
 	atomic_t			refcount;
-	wait_queue_head_t		refcount_q;
 	unsigned int			t_state;
 };
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 447e76da44409..aae42d2abf7bc 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2200,7 +2200,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	WARN_ON_ONCE(atomic_dec_and_test(&tcon->refcount));
 	tcon->t_state = TREE_DISCONNECTED;
 	write_unlock(&sess->tree_conns_lock);
 
@@ -2210,8 +2209,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	work->tcon = NULL;
-
 	rsp->StructureSize = cpu_to_le16(4);
 	err = ksmbd_iov_pin_rsp(work, rsp,
 				sizeof(struct smb2_tree_disconnect_rsp));
-- 
2.51.0

