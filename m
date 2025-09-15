Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0CB2D7DE2
	for <linux-cifs@vger.kernel.org>; Mon, 15 Sep 2025 22:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757976282; cv=none; b=mMSq/o8f7Zp+HGsACbujb3Bi9VQHC7WwLatGs/jGWOhdTi3zyYaJ0bTysCvAZEULG17yF8asqWbcsvL9KljXhpUW13EgHEXPw096n5UBdf+8NOcc+xzTY/UuChbtcL2RzqgAJ4Z24SmSQ7aHLNLALMq3YombjPlqB5DpnmlKnrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757976282; c=relaxed/simple;
	bh=FoDhXKL27FrqFbdKgo4qvaWBWJzf83x/wDOeD8TZ98k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZHRo4wYp0bVhlzmM+rNOKdnl01PKRrXFbAjkZzFNJqfy+rosuIPPkE7kMP5Diq2X76Pg7xgBE+FeASQ1fjPBzLslzAaw0cUbo0I9DCTtAe2+cIeFvtZ5QtkYlQWZ1hhAzCh7BJ2Fjem0Os6/u3HlqNJOCnuF+5KK7ALA5lJqF7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-26495aa4967so3880455ad.2
        for <linux-cifs@vger.kernel.org>; Mon, 15 Sep 2025 15:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757976281; x=1758581081;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n4h6TvvGvdfthwq8yZuD7RXg5Y5KodTn8R97NT7K6NI=;
        b=MZdsL82WibtQLZmLNsfCgVq6ArHRqqeYQ4UA6wHAM1/G0jJoSmA6t5tcQEc3pMhiRJ
         Je/Qf4IMrKhqW6YpNuj3p1W8WnFeTbjiY+dISamw4eoBM85sj2Zu7wo0iav8gLzQZKbD
         43U9HXP8ewk7DxxdsyFZGWsjfjbRn+OMgF8Mf8jplCFRkOQ1GGrWZOtmu2YZhkWkFR5C
         jgZm0B4uFqEpCz7O9iaXWHctYmAwBQD9G6OqWo6u0GtXBwFov9SXaphXzucJ8m3SRCpI
         NERF4tMHi5HvVdKPhI4VKGNtfIe7+ix5YOPt3dDi+AzEWCBLRMNzhkqT0ZlkuTuCEK5r
         Ao5w==
X-Forwarded-Encrypted: i=1; AJvYcCXZDnT33wEr08H2qdR4gUpNdUxdluxVmBKzhsFdUP5ckmIVY0AZJyqFW41nCs7wOrJgHoOWH9EoTSFF@vger.kernel.org
X-Gm-Message-State: AOJu0YwDFj8WqPwhlXZ1YXtROAte6kH6pi6iPbavqpVK8ySzviZkrcbU
	cT3cuJz9sZdiZ4YW8L7u82AwUSNaJnzqUEMtzd20m5uC9goMKxeEodvv
X-Gm-Gg: ASbGncuqt6rCqWmrRI6ZJc0sA0wD3VYZKWgMCPAyYyl4uuR4wAPcpZW4bJoNJYcHGar
	bfU94bnwtbPYO3pS+lF0oVAG7+p8A0ZoqTFliavRNOGAC+bdpwsq493mYOY3+cH2+Yd+MzjLuWB
	AEQCLnimu52F7l1jcJY3XkjEV27iKhAJVGQgullQka9A7LJ3dkfl9VPOIjolxc5kPbKu6WbPDio
	bPL6vlh+p0nqpJSxJ3pLRWbpPWTKDjfHI1BbflfUVF0kc5iTM7SXqAXG2RFo3JsJEMReai9hs4d
	seGFN59nOC4L5CoFTM2B0kVTM74gFCpGtSqMfiFgEJ4mhu8HBvYX80XlB8GfJb1mHC7xo6k8jFg
	P14vGWYY6eSICGbrj0e9MVWohvSRnCej4skS0/W6D2ZgD+WywK/kX8jetrVIs1ZJ9SgcxSeChwI
	D50IqMz3Yjyw==
X-Google-Smtp-Source: AGHT+IHVxjXZpD31bCIVHV7+Q1p6w2ZxDlVfrTJXcV+ZPNp+MWwHnfZ/vC/wORtLF/jAvuHJqOJ52g==
X-Received: by 2002:a17:902:ec85:b0:267:bd8d:1b6 with SMTP id d9443c01a7336-267bd8d09c0mr10685795ad.6.1757976280635;
        Mon, 15 Sep 2025 15:44:40 -0700 (PDT)
Received: from localhost ([218.152.98.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c36cc53a1sm142718715ad.2.2025.09.15.15.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 15:44:40 -0700 (PDT)
From: Yunseong Kim <ysk@kzalloc.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Norbert Szetei <norbert@doyensec.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dawei Li <set_pte_at@outlook.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org (open list),
	Yunseong Kim <ysk@kzalloc.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: Fix race condition in RPC handle list access
Date: Mon, 15 Sep 2025 22:44:09 +0000
Message-ID: <20250915224408.1132493-2-ysk@kzalloc.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 fs/smb/server/mgmt/user_session.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 9dec4c2940bc..b36d0676dbe5 100644
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
 	old = xa_store(&sess->rpc_handle_list, id, entry, KSMBD_DEFAULT_GFP);
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
2.51.0

