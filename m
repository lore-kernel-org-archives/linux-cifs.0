Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F9C36E483
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 22:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777675918; cv=none; b=Wp9/FwYDqDdu9ayGC/uLBsZxz6UPDTacuEEQrGrSzrtrQwPa2Iv32cEu2BEDLo1wYSBHMCcDvV+e0KVyln3u1Is4yJM0JGLeARqHPGGaeU3A9KFjZ5ZoAPENvRuxY3oJTaOCqcrv4FIlN3TboMNuVcTJ8vmzh8uVO4uUjCKti2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777675918; c=relaxed/simple;
	bh=tnJHWk4nf2mYfKUuV5x/4sxYrJMv68q5OStwMd5/TRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Famsu4E3efwzaUFSj5apENDMFrm0WvIaECgE9jNxHrIxwgFEOBgAIuyItvgg7mvaiYyDFpnslXKFTXBY7yXeSZgnmtF+5qnCMV0Xx1krHDQIkPpiAxwuuc/i7I9GdfC8xXawQ4Y0JLMwqVSizjbKd6G8TJwDBJtbZHJ8yAMTtgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AVcdqueX; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVcdqueX"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43d734223e4so1378761f8f.0
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 15:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777675915; x=1778280715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J1+oq8yG/702XyhqprRUDciM6mgbO37f+hUJLoyTzWw=;
        b=AVcdqueXQRRyEptaEhBGt2KYkYPjwDLjylWfJ8GJj9H6p6z+y7n/mA0qSpgzRlX7/F
         XaeLHQ7r3sjvXRA20/Hkb1Ji7RdIqvii47c72B+NUuYfGSfmMgxZ0h3NuYRRDn56zprM
         qRLGbnEq08Sjcv0He0hxqcm6ofgXx8xQQyI/BBT06pKMkeMrlwNWEzxokZhvoWzoBWhX
         N/ApV4ioT2qWGwyK0gdiHxD4EPfin5WLLiCjewWAokR9tHLiTKJvnnqn50kRZkFD0gHg
         KUcr5jwpyd4s0OSVF8lGLxNFFhZVFgTmCqiI7GLoahpQqYj0e3Prl7Pthd5WDmNk1Swd
         Frzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777675915; x=1778280715;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1+oq8yG/702XyhqprRUDciM6mgbO37f+hUJLoyTzWw=;
        b=PnsJrkxi4ZRfLyQsZ6X5eoX+CLMsbKhNl9B9JTTxf9+C4eKKGdTFJ6puxzwWfSY0j4
         uXTtAzgie3S/nQqsD0xLGWf3WIaqoJBhR2NXFm7aRxpJe7tg4abKcRizSeuRu90PiKti
         WDyQ96fK/wnKM+q9LBh28K7+DYzd28O5M5Ie90jFKqF+l9YBw39IVdgs0vYMRfRezeBp
         k6z4VmhfhoW83TkcfcJBllZx3tk2kWrkhzNf9pDZ8diBzRIAVxK4Qo7ws9MR6eUDIsU5
         ohi5crV4y3A30R/ma6WkcFB4Ik/bhBYkqoewdp8SUvoWzDk9GjQOaFLax2d67zyrasjH
         rj8w==
X-Forwarded-Encrypted: i=1; AFNElJ/QEKe2g9lJc2ilpWCpFAGkepiMB+mfPPjE76XF2IgaeypT1Lj2v6unUaTEhLR8gCyRrrjU2bwUGecz@vger.kernel.org
X-Gm-Message-State: AOJu0YxjnLBZNwfqBgkt0zTI80LlML++XHgPKL1C4CH2UWX1OQ7hriVS
	uN2p7ndrzDXjNfJ3ymAFUG2TOhrzYWIcv+WZ5JB0n8QYfBR3IkS79GfCcPRpzLkh
X-Gm-Gg: AeBDiesZG+PoHFd4vgtf40oLJTo4S16DbhjT9cch00G6lFwLnz8ORwHUWfm9cWqmoQm
	x2IEaTye4oiOiVTXrbd6ABECyZpV5WneTJo/nQrGpqIsddDp9bzVYyKG/O3BuntL1xTr1T5Ld1A
	PLK/rkssIPqZZYVYVoylL4yjatBFDoWO/VqFDahOG8gp5GOX04BM4okWocTS1MVteSKLhKqgczm
	I3Vs0Jsf6IHYu7dz7i8cceuR5Qesl2HPWKyd/8Q8oNLWHn4umBXX97rLYPnZ1i4t3Mu9YENjTfn
	XpKRTZkaQxd2t1UZd6gmtJE2Mmv+QD0Yc85mc+mZ+IjvpSesS1UG28Cx4/A8K6ZHb1vIDT7ne4o
	x4zfDWAqs7+Rr6AbpTT9VXX02HmnvzAFl2LolWKsLlFsmbDRLf8n0ZKJRZiVxkJ3Oz9ottekYFy
	GcEAj5HX2MPBhZHetF+Foor+d6pPpYyaoVkQ6l7o8GCTKHXwMm9Z5nmAkknQfo24hklENc0hK4v
	hY7RUKL+0qVL1j/lNTH29/wSpGYhDGZKcNV
X-Received: by 2002:a05:6000:2103:b0:43e:ab40:28d with SMTP id ffacd0b85a97d-4494dc52adbmr8406170f8f.2.1777675915356;
        Fri, 01 May 2026 15:51:55 -0700 (PDT)
Received: from localhost.localdomain ([77.124.36.154])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a98b76fd0sm8040341f8f.35.2026.05.01.15.51.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 01 May 2026 15:51:55 -0700 (PDT)
From: Kai Aizen <kai.aizen.dev@gmail.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH 6.6.y] ksmbd: add chann_lock to protect ksmbd_chann_list xarray
Date: Sat,  2 May 2026 01:51:50 +0300
Message-ID: <20260501225152.90136-1-kai.aizen.dev@gmail.com>
X-Mailer: git-send-email 2.53.0
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

Backport notes for linux-6.6.y:
  - File paths and surrounding context are identical to mainline at the
    time of the fix.  The xa_store call sites in
    ntlm_authenticate / krb5_authenticate use the older form
    `xa_store(..., GFP_KERNEL)` rather than the newer
    `old = xa_store(..., KSMBD_DEFAULT_GFP)`; the lock-wrap is
    structurally identical.

CVE: CVE-2026-23226
Cc: stable@vger.kernel.org # 6.6.y
Reported-by: Igor Stepansky <igor.stepansky@orca.security>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[backport for linux-6.6.y, verified 2026-05-01]
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

@@ -451,6 +455,7 @@ static struct ksmbd_session *__session_create(int protocol)
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
@@ -80,7 +80,13 @@ static inline bool check_session_id(struct ksmbd_conn *conn, u64 id)

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
@@ -1559,7 +1565,9 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;

 			chann->conn = conn;
+			down_write(&sess->chann_lock);
 			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, GFP_KERNEL);
+			up_write(&sess->chann_lock);
 		}
 	}

@@ -1652,7 +1660,9 @@ static int krb5_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;

 			chann->conn = conn;
+			down_write(&sess->chann_lock);
 			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, GFP_KERNEL);
+			up_write(&sess->chann_lock);
 		}
 	}

--
2.43.0

