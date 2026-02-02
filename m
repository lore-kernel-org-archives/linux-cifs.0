Received: from n169-111.mail.139.com (n169-111.mail.139.com [120.232.169.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6241E2222B6;
	Mon,  2 Feb 2026 03:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770002274; cv=none; b=bhWtIGBzKSlBUWeD/4AYrpaFvrSmc359x3ZV5XK8A6q5PXBVNkW8G6vD2PlskDlUZXpeoMnDCt+tiu02ZLwhjzUyvjYjz3DNrmTmSHNyh7RBjDTbbD3Ie7jPJB1zYRAYGkxsHYIEY48NMUW48Sv3PaiRLxjZ5psxLHUGn6rawQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770002274; c=relaxed/simple;
	bh=MDzVHM7YROuf++46Vk38xpKbYu6aOucltD4Ht1ZlJPA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pR5VjG5XOl9zUre/yp3rrjBhwSYWEa0PdztlISHUc8TpG4oQ5dt0ZF08fhMGnait/v+kVe12HcrqTK+vENvt72x/DdaDg7jAyLVRkD6lql8XniE9zZSaboR62iaYJR9W0crm2CXNH7OvDjFvk46f0YXI0FtAq4wfVwcH43axLkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=1UZ7UKEs; arc=none smtp.client-ip=120.232.169.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="1UZ7UKEs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=1UZ7UKEsBJ7jBuzBISnwejmv8U3BONhplW9EGsR4Lzt2keA7ZCVhKBtQz9n0LUetDOHl9EekCHbp3
	 tA5YkapFt+FsYPfyOJY/FVA28nOBSVvpL4mBZzPBSVyyZt9IyLCW1sPhMJR4dtNXBcWOBm5JwxoSgo
	 5IQvkWuxJ8FYCbj8=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-10-12088 (RichMail) with SMTP id 2f38698017359d3-019f4;
	Mon, 02 Feb 2026 11:17:11 +0800 (CST)
X-RM-TRANSID:2f38698017359d3-019f4
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	ysk@kzalloc.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	akendo@akendo.eu,
	set_pte_at@outlook.com,
	linux-cifs@vger.kernel.org,
	stfrench@microsoft.com
Subject: [PATCH 6.6.y] ksmbd: Fix race condition in RPC handle list access
Date: Mon,  2 Feb 2026 11:17:39 +0800
Message-Id: <20260202031739.515222-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yunseong Kim <ysk@kzalloc.com>

[ Upstream commit 305853cce379407090a73b38c5de5ba748893aee ]

The 'sess->rpc_handle_list' XArray manages RPC handles within a ksmbd
session. Access to this list is intended to be protected by
'sess->rpc_lock' (an rw_semaphore). However, the locking implementation was
flawed, leading to potential race conditions.

In ksmbd_session_rpc_open(), the code incorrectly acquired only a read lock
before calling xa_store() and xa_erase(). Since these operations modify
the XArray structure, a write lock is required to ensure exclusive access
and prevent data corruption from concurrent modifications.

Furthermore, ksmbd_session_rpc_method() accessed the list using xa_load()
without holding any lock at all. This could lead to reading inconsistent
data or a potential use-after-free if an entry is concurrently removed and
the pointer is dereferenced.

Fix these issues by:
1. Using down_write() and up_write() in ksmbd_session_rpc_open()
   to ensure exclusive access during XArray modification, and ensuring
   the lock is correctly released on error paths.
2. Adding down_read() and up_read() in ksmbd_session_rpc_method()
   to safely protect the lookup.

Fixes: a1f46c99d9ea ("ksmbd: fix use-after-free in ksmbd_session_rpc_open")
Fixes: b685757c7b08 ("ksmbd: Implements sess->rpc_handle_list as xarray")
Cc: stable@vger.kernel.org
Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
---
 fs/smb/server/mgmt/user_session.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 450a9f8ca7c7..5986d6d0a90b 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -104,29 +104,32 @@ int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 	if (!entry)
 		return -ENOMEM;
 
-	down_read(&sess->rpc_lock);
 	entry->method = method;
 	entry->id = id = ksmbd_ipc_id_alloc();
 	if (id < 0)
 		goto free_entry;
+
+	down_write(&sess->rpc_lock);
 	old = xa_store(&sess->rpc_handle_list, id, entry, GFP_KERNEL);
-	if (xa_is_err(old))
+	if (xa_is_err(old)) {
+		up_write(&sess->rpc_lock);
 		goto free_id;
+	}
 
 	resp = ksmbd_rpc_open(sess, id);
-	if (!resp)
-		goto erase_xa;
+	if (!resp) {
+		xa_erase(&sess->rpc_handle_list, entry->id);
+		up_write(&sess->rpc_lock);
+		goto free_id;
+	}
 
-	up_read(&sess->rpc_lock);
+	up_write(&sess->rpc_lock);
 	kvfree(resp);
 	return id;
-erase_xa:
-	xa_erase(&sess->rpc_handle_list, entry->id);
 free_id:
 	ksmbd_rpc_id_free(entry->id);
 free_entry:
 	kfree(entry);
-	up_read(&sess->rpc_lock);
 	return -EINVAL;
 }
 
@@ -144,9 +147,14 @@ void ksmbd_session_rpc_close(struct ksmbd_session *sess, int id)
 int ksmbd_session_rpc_method(struct ksmbd_session *sess, int id)
 {
 	struct ksmbd_session_rpc *entry;
+	int method;
 
+	down_read(&sess->rpc_lock);
 	entry = xa_load(&sess->rpc_handle_list, id);
-	return entry ? entry->method : 0;
+	method = entry ? entry->method : 0;
+	up_read(&sess->rpc_lock);
+
+	return method;
 }
 
 void ksmbd_session_destroy(struct ksmbd_session *sess)
-- 
2.34.1


