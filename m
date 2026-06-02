Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2A331F98D
	for <linux-cifs@vger.kernel.org>; Tue,  2 Jun 2026 00:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780361868; cv=none; b=Xqi2MbKf+krlCWKea41JzILJq7JDt/JKXGBLrlXkmaUflqYUbS0a10X4VzS7xJDtM299T0IKxnuosqa7seJwuZl4G0RUGkhXGR+yv8pT3yV4RAde143/hRkToACf0KTeShHGql++6la/4QTNNZLCyv57QXSVqQY5wxM+/T34UFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780361868; c=relaxed/simple;
	bh=8dOzYtDhU17Y9aqUIAk3lssg6AUbmv6OzcAHvyNbPMs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YiKQOwAD/EncrkdP7OIdsz46IF6vZ2K4dGyRgRf9JqvUriXzQL+xzYvnwRq5Ctr69vHyAcBLSVhAX/HQNEetNAwQXFo7yNxFUB3CpuLUBvMYbRRt6+qlkJdVFepc2XTYGarNkIY6JxupbZ7aO4TOXrIHOzsOsQjl13cLiLhwq/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O3u6CoKB; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3u6CoKB"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-137dd523634so3044454c88.1
        for <linux-cifs@vger.kernel.org>; Mon, 01 Jun 2026 17:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780361866; x=1780966666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DXR6yUNY2xTRwtTa1l0H+ifyduTbQtbKZWSjUq1qTZM=;
        b=O3u6CoKBPlzgOr0eCjBllqdBi7APlhQ2VXPBXDHxwHnbILodSfYQnq7JzXFLPY3nTP
         euDSNM+EVGxDAogx+7DZJk6hIJZSNQp3ZS6OscJ6TCNBVBFuzHo0Gley2C/QUSQGoNoH
         A4VBf/D8r7AwxJVSlbIK1cCyy1Xfwf1OSlASqeofhwSctKN8a2A6IodgGi8uzq5lklN2
         ZHMxuf8dz08RC4rZLN537yTGGCmA2HsArxm7OL3cWU9eTvyAZ6ZxoMx4ttkB2qbCB0BQ
         wth4wNOXvOzWTnZebmMmaYUG+QRu18O4uklV+02Zr911NK8l30w9iwktKSfZ9sDXR85p
         4eFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780361866; x=1780966666;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXR6yUNY2xTRwtTa1l0H+ifyduTbQtbKZWSjUq1qTZM=;
        b=XV1nskBQulGocBw3mioXmUKJhRcVbR+FGxpSLjUlcOP9XoT5hoJEHxYc/IuACEgpL0
         3ut5j97z/WRrhEqkWKncnYq2BCBFfXUnGLtk/Fzr4nqUY9QayacM74WNMc2S6oaYW+fa
         x8dyjGCfgw0K3k9C5mp2aX4LosOerNu6iwdLtWVBKslKn9b/S0mikGmrkfo1VtwpwuGK
         JHl/qiaWA6RJny4HiEWb/zMJ4JyyCNCdqfKmn3nVszZsWGRmXYaGwWb5gj1ZRdOvuZJA
         uSYmnYM5XL6x7uro/x2H71atUuBYv+WE04Q94Cc9FeJcx58sa9ogcB5+ApcEXV+ji5qz
         NWKA==
X-Forwarded-Encrypted: i=1; AFNElJ/WXzhHClRU4J7BR6OVceWd8l3JWzr2Fb6iu/JpjA3gU1sTInBmGth657DLtS5X9TOVelueO5gT0L7N@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1YZB2TiyLg6M/RSKmCDCuP9VWz5Oed1kq6uVaI412SnqpDz+2
	jM2xiRJgCYqc52T8FDxeZ7vaLxrRlLlFoE64fRfqqFTK+HA2xWnFcayX
X-Gm-Gg: Acq92OEdUkqt6FQucnuTfGBrpM8KuSjTGiFYOUWi/eoeCnLUp4hczWiBEkutEyXInHp
	q1Z3xjvJBtDDdw/r91asOqhwIuXbLnes9klMO3ZA0SPdQTaYiEoXyce8OPGeRcNg4S4WuaXVD93
	YKUXxhbA2CXPSlLic7VyLY+FAf/mUEG/usAlDnE2GEof+EA8gHJFRjCd3R/70qIPPSReNiMiO6U
	owlicSBtJ7ELveey/kIO6XVDbp0bo9riOrZI0pAlxM6UhbgMyEbrzh4tu9u1BfeoEoO3PxZCtn6
	gKRZM5dH3uSDSafxW/WB/xl5M70MWbwPYbd+aEtpUOuVTxx7zBElFG342qt3kc7aonehISj+4TL
	inJ5yNvJGM3aBmplmzXC66PtBE3pT2gBF1cWSakj+cC7Hx0hdg0YosEbQRKV9OvJGdmNC9/Udik
	hdERVqfJAOwFmfVsgoDTRnf635Y4/Afs4=
X-Received: by 2002:a05:7022:117:b0:135:3ed5:5e38 with SMTP id a92af1059eb24-137d4028f39mr5708982c88.27.1780361865398;
        Mon, 01 Jun 2026 17:57:45 -0700 (PDT)
Received: from FredPC ([2600:381:b903:348a:53c:a9ca:4ab3:9c1b])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137dc179940sm6135319c88.5.2026.06.01.17.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 17:57:45 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
X-Google-Original-From: Fredric Cover <FredTheDude@proton.me>
To: sfrench@samba.org
Cc: ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH RFC] smb: client: fix races in cifsd thread creation
Date: Mon,  1 Jun 2026 17:55:10 -0700
Message-ID: <20260602005512.126883-1-FredTheDude@proton.me>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

The cifsd demultiplex thread can run and access tcp_ses before the parent
thread has finished populating tcp_ses, which the worker thread accesses
locklessly.

Also, the kthread_run macro may start the thread before returning the
thread pointer. Because the pointer is part of the structure that the
thread can access, if the kernel is preempted after the thread is spawned,
but before the thread pointer is populated and the thread attempts to exit,
it will sleep, waiting for a SIGKILL signal.

Fix this by moving creation of the thread to after all of tcp_ses'es
fields are populated, and spawning the thread last, using a split
kthread_create/wake_up_process logic.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
Please note that I am fairly new to kernel development, and this patch
may have major flaws that I overlooked. Also, although I wrote the code,
Google's Gemini found the bug in the first place.

---
 fs/smb/client/connect.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dcde25da468d..3452e54c9a18 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1871,14 +1871,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	 * this will succeed. No need for try_module_get().
 	 */
 	__module_get(THIS_MODULE);
-	tcp_ses->tsk = kthread_run(cifs_demultiplex_thread,
-				  tcp_ses, "cifsd");
-	if (IS_ERR(tcp_ses->tsk)) {
-		rc = PTR_ERR(tcp_ses->tsk);
-		cifs_dbg(VFS, "error %d create cifsd thread\n", rc);
-		module_put(THIS_MODULE);
-		goto out_err_crypto_release;
-	}
 	tcp_ses->min_offload = ctx->min_offload;
 	tcp_ses->retrans = ctx->retrans;
 	/*
@@ -1886,9 +1878,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	 * to the struct since the kernel thread not created yet
 	 * no need to spinlock this update of tcpStatus
 	 */
-	spin_lock(&tcp_ses->srv_lock);
 	tcp_ses->tcpStatus = CifsNeedNegotiate;
-	spin_unlock(&tcp_ses->srv_lock);
 
 	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
 		tcp_ses->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
@@ -1897,7 +1887,16 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 
 	tcp_ses->nr_targets = 1;
 	tcp_ses->ignore_signature = ctx->ignore_signature;
-	/* thread spawned, put it on the list */
+
+	tcp_ses->tsk = kthread_create(cifs_demultiplex_thread,
+				  tcp_ses, "cifsd");
+	if (IS_ERR(tcp_ses->tsk)) {
+		rc = PTR_ERR(tcp_ses->tsk);
+		cifs_dbg(VFS, "error %d create cifsd thread\n", rc);
+		module_put(THIS_MODULE);
+		goto out_err_crypto_release;
+	}
+	/* thread created, put it on the list */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcp_ses->tcp_ses_list, &cifs_tcp_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
@@ -1905,6 +1904,12 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	/* queue echo request delayed work */
 	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
 
+	/*
+	 * Use split create/wake logic to ensure that tcp_ses is fully populated
+	 * and tcp_ses->tsk is valid
+	 */
+	wake_up_process(tcp_ses->tsk);
+
 	return tcp_ses;
 
 out_err_crypto_release:
-- 
2.53.0

