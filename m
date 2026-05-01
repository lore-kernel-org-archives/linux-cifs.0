Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3625336D9F1
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 22:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777675920; cv=none; b=OOyv1FMwYKgGpcQp5vR3cQYEIDbewsnn01RkV3F0aOv5f8ctOmRhOgtjdnLSf107zK1B6qGwaDq+64oKESruUKyyGQvn70kyb3nwI/fW8+MepPVIC+lgajW6T97I8hio/FYCSqJKrBboXCrkiy7tqZboJWpxaetMj4d5S2NLL6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777675920; c=relaxed/simple;
	bh=FJP6RLOefwTF8JWnGy5sNvBTTBntXVJzRuLhtI0f/H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqiXUmBfeuEOWiD5VL3zTkOk5u1F2M8/uB5gndq+P67MDWQbYHMigkj/xa8OtxN3mzq+9qvXYhI5q1Sq31QgV0NU1pILUedrOXgLl4t55/GRQRsnyOOxh/ErQj5pmfRfMJPlr55VFgCajPbAJGKfRnydhRw83AnomTyc17ejCp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VEKCZymA; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VEKCZymA"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43d75312379so1939095f8f.1
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 15:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777675918; x=1778280718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fIwxaX7mlPOok/JTlWqcYtodZX36XvL0iKcCG4pk4DA=;
        b=VEKCZymAk3VwNKxBEfQNJ3iMRuk35EMzmshfU6R2v2UyDS3ydveuDn0LZBMHb0+lBL
         Ysskw4dn0RNUj6UyZ6WxxX6wTENZVGtrL4MzodXQefdrsuvGakKOCh1zac2nth8z8eee
         nm0AoFkaixvCynmFiB4rlWUg+q3Snq2cTT+4WZX126nD4ljLUQLJ7hdX4Ee9+4XzS5hl
         34thIYEOHnWNTXgDJEvOBDzT2WMcSFGOWxTRqeZDhTVU/k1LHa+XIvT8s17Dcov/Ap4S
         t3kdmIMYrMp+1PeDrB0olRHXQDaqio1skD201LUjhp7nLBFYxCy2zEEi/ETpCBXkR0dw
         DAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777675918; x=1778280718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fIwxaX7mlPOok/JTlWqcYtodZX36XvL0iKcCG4pk4DA=;
        b=rssYc61gySg25uzodZlsANDMOeRBih+0uqgF/WLk6xEji23OhZBmZggjpqNEx11UpG
         pT/6a3PjVXlfVr/lyCHT/QZNTg+48Tvt7wBDbfekJrjgnzigo2rjTuzi1WQoTU9F5JcF
         HDQ1RI7iVfMk3RTWwDBX4J0/VqY6lBwtwoovjI5ddbwEpl3BWjrY5NuPNK25AqqCnFx2
         +rR1CYMKSpMhW9ES2C+KWMtvf3nKX3EE4YzdpXMG0a6RReCBIerNaX8zdFRK9S1tNoQR
         Y7ILxbPR1YkzMXGnePbKXWJYYndEAQTF5vqUOw/4DXXEAoDz9J8iaW+WpKeWK8VHBjz2
         hmSw==
X-Forwarded-Encrypted: i=1; AFNElJ/jNkFsgDqdJ3+nThDij41zaAeqOPGidg/zxj49a3o+8lrLr0ddcwT+XwlaxTpziOzKxLYBKEX/QSrN@vger.kernel.org
X-Gm-Message-State: AOJu0YxWzScyh/hluRZZdGsamuBCOwWTnYAs5XyrPvKnTm8pPv8nl9Ce
	HJq7Ekdjv2+0AkA096ZbSZ5qS98UJjVczQ3BDvOFvByMfiB6ypILhTPy
X-Gm-Gg: AeBDietjR7l+BTYRdO1pFJgg/GCEmlYAYdLXGDj/Ytm4XSTQFbAX2g8C4I8cFafAMbL
	n3NpEUi9eHzxX2ueoMp5GEvwBspZxVpoqIJP6qdKGdssRZynu1q9YybWgKBqhnp0RhCL7aaSIcU
	C1QMz6nPpCC+brTWOWSQ5jBo1k+U0vxF1ll/cqpUgtXo3zMOHVY+ALtZI/DYuGUsOVDj/8PkSZm
	5bYagr0evxqNjmNkUvvZt2/Jr4IOJm4eu8r9796Q2yYSI+5Cwp5Aj/3S2m97cbUjzuTCfUEdpKr
	Wom4qZAb9UEY84JjKVGExxu6dDniURzFJD+47HKSq+JjhpXfSNCuV4w5v30fPCGKUtYFWRpCF6p
	Qti42ZCtmuRzG3GRvKWUsBzNQosjkwbmWpg/tJEvEXAQrwk6zFcfnQ4vuax4N8f5HQsVgzjt0yJ
	Ac3duuLVlcrHVwIL9g/rkXB+6yBcGLu5TyvEWj4qx8aiZkQc0AAjOCX7dLdk+hm8MukCgzdDHxa
	o1xNi0+xn65W76KF+TgQxBmwQ==
X-Received: by 2002:a5d:648d:0:b0:43f:e571:184d with SMTP id ffacd0b85a97d-44951508317mr9228565f8f.28.1777675917540;
        Fri, 01 May 2026 15:51:57 -0700 (PDT)
Received: from localhost.localdomain ([77.124.36.154])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a98b76fd0sm8040341f8f.35.2026.05.01.15.51.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 01 May 2026 15:51:57 -0700 (PDT)
From: Kai Aizen <kai.aizen.dev@gmail.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH 5.15.y] ksmbd: add chann_lock to protect ksmbd_chann_list xarray
Date: Sat,  2 May 2026 01:51:52 +0300
Message-ID: <20260501225152.90136-3-kai.aizen.dev@gmail.com>
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

Backport notes for linux-5.15.y:
  - 5.15 still uses fs/ksmbd/ paths (the smb client/server consolidation
    landed in 6.1).
  - struct ksmbd_session does not yet have rpc_lock; init_rwsem for
    chann_lock is added directly after the refcnt initialisation.
  - Function bodies for free_channel_list, ksmbd_chann_del,
    lookup_chann_list, and the two xa_store sites in
    ntlm_authenticate / krb5_authenticate are byte-identical to
    mainline at the time of the fix.

CVE: CVE-2026-23226
Cc: stable@vger.kernel.org # 5.15.y
Reported-by: Igor Stepansky <igor.stepansky@orca.security>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[backport for linux-5.15.y, verified 2026-05-01]
---
 fs/ksmbd/mgmt/user_session.c |  5 +++++
 fs/ksmbd/mgmt/user_session.h |  1 +
 fs/ksmbd/smb2pdu.c           | 12 +++++++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
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
@@ -201,7 +203,9 @@ static int ksmbd_chann_del(struct ksmbd_conn *conn, struct ksmbd_session *sess)
 {
 	struct channel *chann;

+	down_write(&sess->chann_lock);
 	chann = xa_erase(&sess->ksmbd_chann_list, (long)conn);
+	up_write(&sess->chann_lock);
 	if (!chann)
 		return -ENOENT;

@@ -395,6 +399,7 @@ static struct ksmbd_session *__session_create(int protocol)
 	sess->sequence_number = 1;
 	rwlock_init(&sess->tree_conns_lock);
 	atomic_set(&sess->refcnt, 1);
+	init_rwsem(&sess->chann_lock);

 	ret = __init_smb2_session(sess);
 	if (ret)
diff --git a/fs/ksmbd/mgmt/user_session.h b/fs/ksmbd/mgmt/user_session.h
--- a/fs/ksmbd/mgmt/user_session.h
+++ b/fs/ksmbd/mgmt/user_session.h
@@ -48,6 +48,7 @@ struct ksmbd_session {
 	char				sess_key[CIFS_KEY_SIZE];

 	struct hlist_node		hlist;
+	struct rw_semaphore		chann_lock;
 	struct xarray			ksmbd_chann_list;
 	struct xarray			tree_conns;
 	struct ida			tree_conn_ida;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -78,7 +78,13 @@ static inline bool check_session_id(struct ksmbd_conn *conn, u64 id)

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
@@ -1570,7 +1576,9 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;

 			chann->conn = conn;
+			down_write(&sess->chann_lock);
 			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, GFP_KERNEL);
+			up_write(&sess->chann_lock);
 		}
 	}

@@ -1667,7 +1675,9 @@ static int krb5_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;

 			chann->conn = conn;
+			down_write(&sess->chann_lock);
 			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, GFP_KERNEL);
+			up_write(&sess->chann_lock);
 		}
 	}

--
2.43.0

