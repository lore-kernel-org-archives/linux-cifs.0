Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A2BEEB3;
	Wed,  9 Apr 2025 09:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.143.211.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744189504; cv=none; b=ouzTkZobbLhpaFc+EcwS1W6qv7IDHOtAizxLywMzZvJqqMVZCsK3h8B+AeraNl4t9VzI0ruVMIfWaFsor73/O6xxz+DNC+/TEmH8bWxVc24OidqCjwmUW5dXz/kICSN7eO5PZU40csj5f2N4ahwAZZP139nswSSAUmZJWg38zQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744189504; c=relaxed/simple;
	bh=LfGGWscpWjpk4r75z8rb8VP4CkBkJKW3KI5JnogjoTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OsVwwHCKvXQ/TnD86mDzeRkSl9tVkZ1FdJLtn6xMph6NEIqCP36UMw+CWTa92wdZ5RumN7PgvLcyhX9MmFrlsuEW3ys8QqyJl5YzZsdCSGInZEPoYgL12o8sLu0mc3+kjHV7SqgAPAJzHG0hCAKgzK5HjJyRGi5FgDz7D+RZXh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru; spf=pass smtp.mailfrom=swemel.ru; dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b=lgUUBH8u; arc=none smtp.client-ip=95.143.211.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=swemel.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b="lgUUBH8u"
From: Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1744189490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Cw1uRMQ6Z/5Pev4RbNkDZSZZOleAQKkhNDYJmq+et6g=;
	b=lgUUBH8uQyshbvMPtnEnd1CSqfRRyQykjLy8dLLkHmYJPwDbrUUMNxPF0B+F7FHZ+L+pdT
	vK4i/tH4bclai6zbSsUQ8RDksUVRXzhQR1AZXDuhRH7CAU+ZgckkuxXjvys7s+wk5cbPYR
	vbWkFvsxOKl+j7jaj3D5ueg7frUE2+0=
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: Prevent integer overflow in calculation of deadtime
Date: Wed,  9 Apr 2025 12:04:49 +0300
Message-ID: <20250409090450.7952-1-arefev@swemel.ru>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The user can set any value for 'deadtime'. This affects the arithmetic
expression 'req->deadtime * SMB_ECHO_INTERVAL', which is subject to
overflow. The added check makes the server behavior more predictable.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
---
 fs/smb/server/transport_ipc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 3f185ae60dc5..2a3e2b0ce557 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -310,7 +310,11 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 	server_conf.signing = req->signing;
 	server_conf.tcp_port = req->tcp_port;
 	server_conf.ipc_timeout = req->ipc_timeout * HZ;
-	server_conf.deadtime = req->deadtime * SMB_ECHO_INTERVAL;
+	if (check_mul_overflow(req->deadtime, SMB_ECHO_INTERVAL,
+					&server_conf.deadtime)) {
+		ret = -EINVAL;
+		goto out;
+	}
 	server_conf.share_fake_fscaps = req->share_fake_fscaps;
 	ksmbd_init_domain(req->sub_auth);
 
@@ -337,6 +341,7 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 	server_conf.bind_interfaces_only = req->bind_interfaces_only;
 	ret |= ksmbd_tcp_set_interfaces(KSMBD_STARTUP_CONFIG_INTERFACES(req),
 					req->ifc_list_sz);
+out:
 	if (ret) {
 		pr_err("Server configuration error: %s %s %s\n",
 		       req->netbios_name, req->server_string,
-- 
2.43.0

