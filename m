Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD7A331A63
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095576; cv=none; b=eHSjBZ7lpKw6l366pDdMt8PQOTb+F/hPpYH+Lm46t4MFBt9SlvH6GrqUMcgT+8EKIF7b1Q3nP8VDqcTJRh2aet4nAmz88VbZ4IN1po+yR27PIrj3t6TpkgdBvV/gIxHjE4kll9K+f1suROxmIrIVgmRnR6XUQcW2kwD5CkJhun4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095576; c=relaxed/simple;
	bh=6PScrn48J1JIJeC0dpZY4l9i7qrauPcvVmXtNm+F7ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITrwsEfras4tDgYarT2wK+EuHDhfq7LYrAaTcrQVU6V9WjmZ2+n2j2yrk2NkNyHxM1joCw4hxaC9D2gyUo/36zNVci4SVtRJPu9aFgIJ1BM89NHJ6dLpu4iEn4opl+5CE1EloXCpWrCohloDNA9xlQAujwq1OzMpEsyPEauQ1Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=HLIUcsoY; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="HLIUcsoY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=W+IAS/M++2SUukq5MCo9uXhik4htSU8p4LSIQJET+ZA=; b=HLIUcsoYkUPbnYVT+WRMllN8MU
	w5+j++7h/px2nyHMYZWjjAeku4go6SXmdi/HH7ZFwBi+9y/3QlKU+6H7dI92A+ZKRxIeFFiUK7i0R
	3q9eCrGVaPvClEbOSP53SMjUYWb2Ze9IG+7482Cm6Lik7zHS26AXCMW8WYZQ/82dBDUifKjGdmKDd
	4Od92xIc9GB5/RygCrde9+dZyIKO4PkzeiRmwtpWs2Qc8psGU3gltRCoc1gxYElv6TZmL53lfJBu8
	aQ7MGsr6HVXT4dkAc3fH6WgFIknws9LGD20UTquiMDGBcCL0JmdaVyVRcNQ2vUkBeNOQT8T4clrCN
	YMTQXfrvbm48FSkBkwAVR8pJQsPvf/YH1eE5hRGtN0PSCH5ZlKRy/3H4WjFYVKAOCcqgbM4bv69o7
	wITJfeZFRZl+cCUBRlBRPy3vzQUGHyZQ9YEx5/6kBuUXjqFDiuOGPEB4Zo32s0jQd5GMcUltGXPKu
	jJhf9xZSXHnX6fVRH+E5GCYI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxmn-00Fftf-2J;
	Tue, 25 Nov 2025 18:29:10 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 137/145] smb: smbdirect: introduce global workqueues
Date: Tue, 25 Nov 2025 18:56:23 +0100
Message-ID: <0f0acfb64b66899ca68dc98fd3a2f4eb1fc91253.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These will be used in future and callers should no
longer use smbdirect_socket_set_custom_workqueue().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_internal.h |  9 +++
 fs/smb/common/smbdirect/smbdirect_main.c     | 76 +++++++++++++++++++-
 fs/smb/common/smbdirect/smbdirect_socket.h   |  9 ++-
 3 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index eecc8f6b197b..4cb5c8f07e8c 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -19,6 +19,15 @@
 
 struct smbdirect_module_state {
 	struct mutex mutex;
+
+	struct {
+		struct workqueue_struct *accept;
+		struct workqueue_struct *connect;
+		struct workqueue_struct *idle;
+		struct workqueue_struct *refill;
+		struct workqueue_struct *immediate;
+		struct workqueue_struct *cleanup;
+	} workqueues;
 };
 
 extern struct smbdirect_module_state smbdirect_globals;
diff --git a/fs/smb/common/smbdirect/smbdirect_main.c b/fs/smb/common/smbdirect/smbdirect_main.c
index c61ae8d7f4f0..12436e73b51e 100644
--- a/fs/smb/common/smbdirect/smbdirect_main.c
+++ b/fs/smb/common/smbdirect/smbdirect_main.c
@@ -12,14 +12,81 @@ struct smbdirect_module_state smbdirect_globals = {
 
 static __init int smbdirect_module_init(void)
 {
+	int ret = -ENOMEM;
+
 	pr_notice("subsystem loading...\n");
 	mutex_lock(&smbdirect_globals.mutex);
 
-	/* TODO... */
+	smbdirect_globals.workqueues.accept = alloc_workqueue("smbdirect-accept",
+							      WQ_SYSFS |
+							      WQ_PERCPU |
+							      WQ_POWER_EFFICIENT,
+							      0);
+	if (smbdirect_globals.workqueues.accept == NULL)
+		goto alloc_accept_wq_failed;
+
+	smbdirect_globals.workqueues.connect = alloc_workqueue("smbdirect-connect",
+							       WQ_SYSFS |
+							       WQ_PERCPU |
+							       WQ_POWER_EFFICIENT,
+							       0);
+	if (smbdirect_globals.workqueues.connect == NULL)
+		goto alloc_connect_wq_failed;
+
+	smbdirect_globals.workqueues.idle = alloc_workqueue("smbdirect-idle",
+							    WQ_SYSFS |
+							    WQ_PERCPU |
+							    WQ_POWER_EFFICIENT,
+							    0);
+	if (smbdirect_globals.workqueues.idle == NULL)
+		goto alloc_idle_wq_failed;
+
+	smbdirect_globals.workqueues.refill = alloc_workqueue("smbdirect-refill",
+							      WQ_HIGHPRI |
+							      WQ_SYSFS |
+							      WQ_PERCPU |
+							      WQ_POWER_EFFICIENT,
+							      0);
+	if (smbdirect_globals.workqueues.refill == NULL)
+		goto alloc_refill_wq_failed;
+
+	smbdirect_globals.workqueues.immediate = alloc_workqueue("smbdirect-immediate",
+								 WQ_HIGHPRI |
+								 WQ_SYSFS |
+								 WQ_PERCPU |
+								 WQ_POWER_EFFICIENT,
+								 0);
+	if (smbdirect_globals.workqueues.immediate == NULL)
+		goto alloc_immediate_wq_failed;
+
+	smbdirect_globals.workqueues.cleanup = alloc_workqueue("smbdirect-cleanup",
+							       WQ_MEM_RECLAIM |
+							       WQ_HIGHPRI |
+							       WQ_SYSFS |
+							       WQ_PERCPU |
+							       WQ_POWER_EFFICIENT,
+							       0);
+	if (smbdirect_globals.workqueues.cleanup == NULL)
+		goto alloc_cleanup_wq_failed;
 
 	mutex_unlock(&smbdirect_globals.mutex);
 	pr_notice("subsystem loaded\n");
 	return 0;
+
+alloc_cleanup_wq_failed:
+	destroy_workqueue(smbdirect_globals.workqueues.immediate);
+alloc_immediate_wq_failed:
+	destroy_workqueue(smbdirect_globals.workqueues.refill);
+alloc_refill_wq_failed:
+	destroy_workqueue(smbdirect_globals.workqueues.idle);
+alloc_idle_wq_failed:
+	destroy_workqueue(smbdirect_globals.workqueues.connect);
+alloc_connect_wq_failed:
+	destroy_workqueue(smbdirect_globals.workqueues.accept);
+alloc_accept_wq_failed:
+	mutex_unlock(&smbdirect_globals.mutex);
+	pr_crit("failed to loaded: %d (%s)\n", ret, errname(ret));
+	return ret;
 }
 
 static __exit void smbdirect_module_exit(void)
@@ -27,7 +94,12 @@ static __exit void smbdirect_module_exit(void)
 	pr_notice("subsystem unloading...\n");
 	mutex_lock(&smbdirect_globals.mutex);
 
-	/* TODO... */
+	destroy_workqueue(smbdirect_globals.workqueues.accept);
+	destroy_workqueue(smbdirect_globals.workqueues.connect);
+	destroy_workqueue(smbdirect_globals.workqueues.idle);
+	destroy_workqueue(smbdirect_globals.workqueues.refill);
+	destroy_workqueue(smbdirect_globals.workqueues.immediate);
+	destroy_workqueue(smbdirect_globals.workqueues.cleanup);
 
 	mutex_unlock(&smbdirect_globals.mutex);
 	pr_notice("subsystem unloaded\n");
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index b3769be07df0..beb318463a68 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -108,8 +108,6 @@ struct smbdirect_socket {
 	/*
 	 * This points to the workqueues to
 	 * be used for this socket.
-	 * It can be per socket (on the client)
-	 * or point to a global workqueue (on the server)
 	 */
 	struct {
 		struct workqueue_struct *accept;
@@ -520,6 +518,13 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 
 	init_waitqueue_head(&sc->status_wait);
 
+	sc->workqueues.accept = smbdirect_globals.workqueues.accept;
+	sc->workqueues.connect = smbdirect_globals.workqueues.connect;
+	sc->workqueues.idle = smbdirect_globals.workqueues.idle;
+	sc->workqueues.refill = smbdirect_globals.workqueues.refill;
+	sc->workqueues.immediate = smbdirect_globals.workqueues.immediate;
+	sc->workqueues.cleanup = smbdirect_globals.workqueues.cleanup;
+
 	INIT_WORK(&sc->disconnect_work, __smbdirect_socket_disabled_work);
 	disable_work_sync(&sc->disconnect_work);
 
-- 
2.43.0

