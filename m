Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371C037C917
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 22:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777675919; cv=none; b=IVdvzx9u2TJxvfawOSRNwpHIdmen4RlC7Mcl9iwMFGVo5S7X/iSEnt4P0Eg++KEDIbU76U4ELG7f2Objbs5aNqstuOQ3gJSlyc8p8Y9uelRYLP28YHPE8GSrsRlsZLTJZ3ez4yAY5TdDMSAEuEHey4pV6oCkwtRjV+EYFwVH9PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777675919; c=relaxed/simple;
	bh=sj+0TveqgFbria1WecUz8+lNLyXt3YQquh2jnrnlr9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TV2h6lYJTCCqZnICj94PbJnKuWujsroK1xuEBA88uE8F+uxiQ0f+xMpFHqoAQM7O7KKx9mqhW6PtgMakyDyZ8Q5rCoQH6eqPPjZ+4JJFPxOTVuN2CaVrx/5Qtjl9wFtBypMPDwYcSzJJEt57QX704VGc9eE3B24uplq0WeNNiqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BcaDPRqA; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BcaDPRqA"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so37133575e9.2
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 15:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777675917; x=1778280717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gwNDW+V2ZInjYz2679mwWIRItMIlkpJfBjr27qXLa8Y=;
        b=BcaDPRqAJprjabvBPa/5BvjjlFoy/dYedfKc7LRO7Wy3ok0CDJPqvZ7z7Wu97uVRUs
         DUAznbWzZ+VCo6032MIFtSi7ekTkYliIeb7FWGHKr9E8TDyj3XNg3FXE9u44AjFuGURI
         R90PmCWFtTYM5Q3ptKQWxxt9k6TXu0hwfCz3AzvR86mKds+3lCacZXWovfxfOHwLObQ2
         UqjkIO+PYAwFsxcTYWpvkEwKXsJoBAyddscHkVEIWx95+k9vWvw4Oi9ubAa2PYJLAXmd
         1dnowyhq3EztmjmKWm6c9lA3fWNE8Y2OdbjfZHtrFRCAX+7aK/b5wDwsToskcqGavj3j
         w4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777675917; x=1778280717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gwNDW+V2ZInjYz2679mwWIRItMIlkpJfBjr27qXLa8Y=;
        b=FsxY8Isa2AUr0o+8YrCM3/vgF6825J9OEYkZUgQstdA61OOeru8GatfWiQHPZSdOZG
         IiJ7A1vj6HWMOJv+VuxSzzqqiLuQuZaBN9B8IKgc89zG9nZ2l7nXnpvdo0mUjhbm+zID
         c0lzVjisNuggdI3vpoOburga7qLKrEZNB0X9RTlT2YgCaogBb7kVdVlXAOQR+xjQpO3C
         d2Yov2xsrsZ0FWY74QOXG/TW0lZHM9XOM5IP+WnS4QJ3plMcGbE5hBtKSJfTvFsbKIiv
         1sVTl1ltUzBqRglPBY9Z205fD8jUOF0mvFJom9jI9PKXN8DEJIoeeiDhJchWetUaQUBT
         tL1A==
X-Forwarded-Encrypted: i=1; AFNElJ+SQnXfG48/AeIeI68XyW0v9SARtFckK84iffk/QmIWVMd+hXADfMs+kQod/vXzBrHW+0HEW2jKeOBv@vger.kernel.org
X-Gm-Message-State: AOJu0YzXvPJsM5n/Q2+qDoj25nRRoxrO1HRwiF0FDdO9JM0CSGlmufqX
	z9KAgk+YhrOTXAi6v/2auOefmLb6ArusZUTT3qxdUD42At8HpEpDJUZE
X-Gm-Gg: AeBDievjkyILPWsRdAi4YspDkemKK3NdoIe+SlwevPgU30mcoj1reXWXLOsUX/A+Iv2
	dBrnGYZoYQib24umdDCrAz44TGfCtM+S7s+XGt2qucdhJ4FsPvrRwafGRdJqdUonPvLknoYjji8
	nwAQxz0h670/zq+GnifrtLHd8nJtZt01aC14bcjPZ6Xg4Ee4thj3zUCMYhhPplD8DGgFLS5waod
	7TOnvsXx9wT/lnMdrAMzmDw7fUyxjoajrSWnYH7DfJRCIcizaBWsvJHQPcTqFVAi4SBlipmlrxA
	KpnJTy2KcPly/jtyvris5odBBxd+h/RefCN8TNGdjWfeqENtxw3O6fv/jAZIG8UD6PUH94X+D8L
	/F3o2rW4qecc/erGhgR6xSVIhhwXc+TvWdBhVs4sI8lq6yljylMWldztxL/JF7V8W7zH9Dsg8nn
	xnHdzSVwn3oqqIIbnyZId7U/j8qOBPbAqFGdu1k3Vw27ZzyFx8zbYbQhdPMBcxG8lz2OgS1rUxB
	ogjzu5RQ3Giol8Zj+1t0u7SxA==
X-Received: by 2002:a05:6000:40c7:b0:43d:6787:992f with SMTP id ffacd0b85a97d-44bb37c7fabmr1783295f8f.10.1777675916470;
        Fri, 01 May 2026 15:51:56 -0700 (PDT)
Received: from localhost.localdomain ([77.124.36.154])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a98b76fd0sm8040341f8f.35.2026.05.01.15.51.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 01 May 2026 15:51:56 -0700 (PDT)
From: Kai Aizen <kai.aizen.dev@gmail.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH 6.1.y] ksmbd: add chann_lock to protect ksmbd_chann_list xarray
Date: Sat,  2 May 2026 01:51:51 +0300
Message-ID: <20260501225152.90136-2-kai.aizen.dev@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501225152.90136-1-kai.aizen.dev@gmail.com>
References: <20260501225152.90136-1-kai.aizen.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 4f3a06cc57976cafa8c6f716646be6c79a99e485 ]

ksmbd_chann_list xarray lacks synchronization, allowing use-after-free in
multi-channel sessions (between lookup_chann_list() and ksmbd_chann_del).

Adds rw_semaphore chann_lock to struct ksmbd_session and protects
all xa_load/xa_store/xa_erase accesses.

Backport notes for linux-6.1.y:
  - The smb client/server consolidation has already happened by 6.1.y;
    file paths are fs/smb/server/, identical to mainline.
  - The xa_store call sites use the older form
    `xa_store(..., GFP_KERNEL)` with no captured `old`, but the
    surrounding context for the lock-wrap is identical.

CVE: CVE-2026-23226
Cc: stable@vger.kernel.org # 6.1.y
Reported-by: Igor Stepansky <igor.stepansky@orca.security>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[backport for linux-6.1.y, verified 2026-05-01]
---
 fs/smb/server/mgmt/user_session.c |  5 +++++
 fs/smb/server/mgmt/user_session.h |  1 +
 fs/smb/server/smb2pdu.c           | 12 +++++++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -30,12 +30,14 @@ static void free_channel_list(struct ksmbd_session *sess)
 	struct channel *chann;
 	unsigned long index;

+	down_write(&sess->chann_lock);
 	xa_for_each(&sess->ksmbd_chann_list, index, chann) {
 		xa_erase(&sess->ksmbd_chann_list, index);
 		kfree(chann);
 	}

 	xa_destroy(&sess->ksmbd_chann_list);
+	up_write(&sess->chann_lock);
 }

 static void __session_rpc_close(struct ksmbd_session *sess,
@@ -218,7 +220,9 @@ static int ksmbd_chann_del(struct ksmbd_conn *conn, struct ksmbd_session *sess)
 {
 	struct channel *chann;

+	down_write(&sess->chann_lock);
 	chann = xa_erase(&sess->ksmbd_chann_list, (long)conn);
+	up_write(&sess->chann_lock);
 	if (!chann)
 		return -ENOENT;

@@ -417,6 +421,7 @@ static struct ksmbd_session *__session_create(int protocol)
 	rwlock_init(&sess->tree_conns_lock);
 	atomic_set(&sess->refcnt, 2);
 	init_rwsem(&sess->rpc_lock);
+	init_rwsem(&sess->chann_lock);

 	ret = __init_smb2_session(sess);
 	if (ret)
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -48,6 +48,7 @@ struct ksmbd_session {
 	char				sess_key[CIFS_KEY_SIZE];

 	struct hlist_node		hlist;
+	struct rw_semaphore		chann_lock;
 	struct xarray			ksmbd_chann_list;
 	struct xarray			tree_conns;
 	struct ida			tree_conn_ida;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -79,7 +79,13 @@ static inline bool check_session_id(struct ksmbd_conn *conn, u64 id)

 struct channel *lookup_chann_list(struct ksmbd_session *sess, struct ksmbd_conn *conn)
 {
-	return xa_load(&sess->ksmbd_chann_list, (long)conn);
+	struct channel *chann;
+
+	down_read(&sess->chann_lock);
+	chann = xa_load(&sess->ksmbd_chann_list, (long)conn);
+	up_read(&sess->chann_lock);
+
+	return chann;
 }

 /**
@@ -1567,7 +1573,9 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;

 			chann->conn = conn;
+			down_write(&sess->chann_lock);
 			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, GFP_KERNEL);
+			up_write(&sess->chann_lock);
 		}
 	}

@@ -1660,7 +1668,9 @@ static int krb5_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;

 			chann->conn = conn;
+			down_write(&sess->chann_lock);
 			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, GFP_KERNEL);
+			up_write(&sess->chann_lock);
 		}
 	}

--
2.43.0

