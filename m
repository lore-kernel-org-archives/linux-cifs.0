Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C96E2288E3;
	Sat,  6 Dec 2025 14:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765029777; cv=none; b=sBKhg0QD5C+urD/kco+RmnpE9RcSyIsRqqFUxL9IjAo5v/NmvnOIopzG62U08jrOZoOi5bBaNW3KyAcdtdA/ApqYzCeZg2mTxDQDeFE447SqHxvl0cbtUCsK+sdJXNjfxzRxUXVbL1YgpecmyG8Fg7/+BwV1iLTvr3HrhiHBUsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765029777; c=relaxed/simple;
	bh=FQeuqPZ9ZuYejyixETsTXE9N5BCqnipWuGOsKpQT8/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q6is65XVBIjGoZdUwpYi60IPkf5VxcF3kKqtBlV/ptgx3hkZvjHjSjWmBzZh6dWMu8clnS46eYbDSCnFT2vvZpd6P85JaqpUJr/ZYCznWHkOXSW/zZyrPhjbGUhXMoTin5e1LTKT0HwczarWtrcQuOSnmkHa+KKj4AO1FA7aC+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tq1NrON2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tq1NrON2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CA7C4CEF5;
	Sat,  6 Dec 2025 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765029776;
	bh=FQeuqPZ9ZuYejyixETsTXE9N5BCqnipWuGOsKpQT8/s=;
	h=From:To:Cc:Subject:Date:From;
	b=Tq1NrON2BZP0O0neJ54/wZ0R6J73Ah1ADobrL070YVk57oH2OdTL3FoU7BF1RyEi2
	 BtsCWZCT3pf+LRen+JVNfCt6Co/Xa9h9iizCa6c3GoSL211xE4+w1JLU84N6sib3f5
	 vOsP30z99qVodDXN+iEOad5TDNoEnQllRvgyx1jGR4DVXWpFZ2RtdBUqryEtPvSMuH
	 Qo9wPQOpUPB9AqxABRXBKg0mxquPuHgkQvcENr4LDBQ1v3iGCknWeFjtzBx2bVWsGb
	 6q2axIdiyNUQ4GjhtJSw/ardcNhJShQVl+Yg2p/xbSOU0JNp15hAWVrwDTb0es00gz
	 etUcfIp9rMjjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency
Date: Sat,  6 Dec 2025 09:02:06 -0500
Message-ID: <20251206140252.645973-1-sashal@kernel.org>
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
index a2830ec67e782..dba29881debdc 100644
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

