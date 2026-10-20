Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792525610;
	b=ZHMrZxzacqvzy+7FHpwePIPNIKDjZHiAh0ONc98pQhQ0eeFD0eRIorYmTM3cUT4i3sBF
	 5vLjXqt1OJkgPXxweyCyat5WRHXpJj72V3XlCMjUPIRQ372VDTIyBHFZzx+5r5bvZnqXZ
	 tPSEded1wOqUuG5lNn0NlsaboKtqtOD6CYQ0KNyH0fKEum6Pmg0OJE5ChO5eeVnFzxFwE
	 AwimM28bUGn1UbPjZl4xxnIXKE+xgaVlDj/q5pfIlZARKQ0AK3bg6D8ZPb6oXR3JcdMnA
	 OhihGhYQhG2ZbQLg3s6wrbKKlx+FE4XflfY/6Vc3Py46nEMybLEOG0JWh2uQ97mX4wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792525610;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=MI932JhN9VjF8TOw8SdZ8dlhBRrLcdkNw1TnQRwc3sA=;
	b=N9xbnZquRtCnGRxxXOMv+THpwN9KtFrWVEYrSMf21iRr/f8OpVR1v4KFqOUYFGQGwkWs
	 de1sDMj143xlLmDZj2qhRygkNUT/36KKEkXwxNKD8gahSpanV6ThsNXUojwzTKlhnusvW
	 FHCZnM5muiSpniXhfyTHSDzeI45FWbNzt0DWWk33unqhBd5escVcf3RHVh7smzfbdxXeE
	 vge/8srHEfqmQnxvYKHquYgNv8t38kpUaFVcumA1+QWfqqS0kbWZEOtiOWWFQ5lRBnOr+
	 W1QWntQiTOEuvNNn0sxJP+tT91cAK0i0eErIgs57dgmWJNEKVplvi81bnwc+XHEllQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rwuIBfj5;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68D1606A319
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 19:46:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C68D1606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rwuIBfj5
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a1635f7c89so34077255e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 12:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792525608; x=1793130408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MI932JhN9VjF8TOw8SdZ8dlhBRrLcdkNw1TnQRwc3sA=;
        b=rwuIBfj5mUiKMocU+JToXt/pDIiChRqGOQ+F4oXsC3iFr189twyYEJAhBbUhWVpPHA
         KiKhtpl6UyQfFzLhR/r5Bi2LbQisNKsMsIhBQoIX771+Vo0Hjurmo3GAgpZKCCQwAlUH
         6CXGA1eNg9RXzEFQAdX+8RQEkLVl1sxJvKqvp/v46jpSeOKAZMQvMvi0xEAFF8jeEbOF
         wqCfeBujyTkzq51tRWXtPWIImEPCiqC2XpGawrObGcadv3oy1AGMgUx8y09HUc3kCj5+
         Z40dTXkXQn6H2Qanb6Ly1N6rslxbS5wTefNMwPdJ/Q/PfQUyFxk70HugxZxFEqmg+Bp3
         nNAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792525608; x=1793130408;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MI932JhN9VjF8TOw8SdZ8dlhBRrLcdkNw1TnQRwc3sA=;
        b=x8sP6iBGAfPGeAh5TNrlMVz1JSjgjBVRybxfRTzj/2/Ky1RV+coQ7cqZM+YkQy5pZ7
         d9tlpjIuc4CDBsHR6hzbHV9ERZXAktj3vSoOXfIZQ6U/coCkOhSVYOmzmZfLdXArBYT2
         to41JYSJbZOe/+VaM9IF4ICbrLvPTf4iivAqJYGf2GNJGvSSKQ4LSPNnDgj+tY+BziAQ
         7GngKb9Yiwfsi1Rzo8EEkKMRdsweCo/Bd+LI2B/YnQv/KZMrIfyFkQc0jEgZM90XaDcc
         zmSd15xkljiVuU6svbR0q+nmePr2kEzrwZ6OrzJKPe1S0jVcoAna6Txct/gjk2EQT+Kg
         D90A==
X-Gm-Message-State: AFq9FYIJEW1Myq9kVgFWzIHYikPpsnUXpGlha+AYT+uJFpH52b9HEJ7o
	Gs2qB6P2mC6THhvbYChJzf+j34UZqD8jl0DOVVJCdHKg3fClVIWpV7Om
X-Gm-Gg: AYBFou0am6rYiQy+MDhCH5JxlLidRptaoMYWzsCqVFUx1vYfIYtC9X+jtI2VFi8RnHf
	K9sxk/HVHiNciNQVhm8RUOHXV/IZ7P/xyhWcEPgEVOjYP00cz++SzS/n86CWS1C0P3ABRPdjKwu
	a5Hllv6qhtr0dXOYtBO58jawCCFJnyRkQNuznaQ8dh+/0UoE00EblJh2HkQHk/zpBDuJjAqHKMI
	JNRBGAP6ZVOyjsvacjdTW/KCsCoPH0p4dsnYXCk50LmAT0xWIIOhB97DASgjeRzT4xzTNHtk1QJ
	8lJQ+XCoOl+9ZjefZflHnq7Oegv+QdwPCyTxiKGvZlokSCYZxTe+97oh8YSLId0ou0kaJT1GIa8
	GbYsE0F3noXK7l/xRcZSYLqUoEdp7zs3oOXhKBWgtt0oTfT+4j6nkfRRyQ2HPxvnpKG9PQtMZei
	5LDRgVC3C/Z6j6nUqD42H/vJgCnrRl4POI27PIofutvB9q1JwDSzmZilqKgIQ5BRmzldkqz1ilV
	puqES4HXXEmyg==
X-Received: by 2002:a05:600c:698d:b0:4a1:d767:ba33 with SMTP id 5b1f17b1804b1-4a1d767ba47mr250613885e9.12.1792525607958;
        Tue, 20 Oct 2026 12:46:47 -0700 (PDT)
Received: from linux.tail9b532d.ts.net ([194.9.6.210])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fc1b227dsm9914185e9.6.2026.10.20.12.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 12:46:47 -0700 (PDT)
From: Eduard Zateev <hackerowskiy@gmail.com>
To: pc@manguebit.org,
	linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	Eduard Zateev <hackerowskiy@gmail.com>,
	syzbot+5c3ed2a0de3270efc921@syzkaller.appspotmail.com,
	syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com
Subject: [PATCH] smb: client: hold server info until cifsd exits
Date: Tue, 20 Oct 2026 21:45:45 +0200
Message-ID: <20261020194545.3254790-1-hackerowskiy@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The last session reference can be dropped while the cifsd demultiplex
thread is still running clean_demultiplex_info(). That thread frees
TCP_Server_Info there, racing with cifs_put_tcp_session() as it releases
the server crypto state. syzbot reported a KASAN use-after-free in
cifs_crypto_secmech_release().

Keep an object reference for the cifsd thread. Defer final crypto,
session-key, network namespace, string, and structure cleanup until both
the last session reference and the thread reference are dropped. Drop the
thread reference after clean_demultiplex_info() has finished using the
server.

Build-tested with ARCH=arm64 and W=1 for
fs/smb/client/connect.o. The KASAN reproducer was not run on the patched
kernel.

Fixes: a5c3e1c725af ("Revert \"cifs: No need to send SIGKILL to demux_thread during umount\"")
Reported-by: syzbot+5c3ed2a0de3270efc921@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5c3ed2a0de3270efc921
Reported-by: syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=c2ec61adfbcb24e5ec20
Assisted-by: LLM OpenAI Codex
Signed-off-by: Eduard Zateev <hackerowskiy@gmail.com>
---
 fs/smb/client/cifsglob.h |  2 ++
 fs/smb/client/connect.c  | 35 +++++++++++++++++++++++------------
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 5c5b76a9e9f..4d241b12991 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -16,6 +16,7 @@
 #include <linux/scatterlist.h>
 #include <linux/mm.h>
 #include <linux/mempool.h>
+#include <linux/refcount.h>
 #include <linux/workqueue.h>
 #include <linux/utsname.h>
 #include <linux/sched/mm.h>
@@ -679,6 +680,7 @@ struct TCP_Server_Info {
 	spinlock_t srv_lock;  /* protect anything here that is not protected */
 	__u64 conn_id; /* connection identifier (useful for debugging) */
 	int srv_count; /* reference counter */
+	refcount_t refcount; /* object refs, including the cifsd thread */
 	int rfc1001_sessinit; /* whether to estasblish netbios session */
 	bool with_rfc1001; /* if netbios session is used */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 28e1ddeb618..58a55d53683 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1062,6 +1062,19 @@ cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required)
 	return 0;
 }
 
+static void cifs_tcp_server_put(struct TCP_Server_Info *server)
+{
+	if (!refcount_dec_and_test(&server->refcount))
+		return;
+
+	cifs_crypto_secmech_release(server);
+	kfree_sensitive(server->session_key.response);
+	put_net(cifs_net_ns(server));
+	kfree(server->leaf_fullpath);
+	kfree(server->hostname);
+	kfree_sensitive(server);
+}
+
 static noinline_for_stack void
 clean_demultiplex_info(struct TCP_Server_Info *server)
 {
@@ -1147,14 +1160,12 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		 */
 	}
 
-	put_net(cifs_net_ns(server));
-	kfree(server->leaf_fullpath);
-	kfree(server->hostname);
-	kfree_sensitive(server);
-
 	length = atomic_dec_return(&tcpSesAllocCount);
 	if (length > 0)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
+
+	/* The cifsd thread may race the last session reference being dropped. */
+	cifs_tcp_server_put(server);
 }
 
 static int
@@ -1729,7 +1740,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	else
 		cancel_delayed_work_sync(&server->reconnect);
 
-	/* For secondary channels, we pick up ref-count on the primary server */
+	/* For secondary channels, drop the reference on the primary server. */
 	if (SERVER_IS_CHAN(server))
 		cifs_put_tcp_session(server->primary_server, from_reconnect);
 
@@ -1737,15 +1748,11 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&server->srv_lock);
 
-	cifs_crypto_secmech_release(server);
-
-	kfree_sensitive(server->session_key.response);
-	server->session_key.response = NULL;
-	server->session_key.len = 0;
-
 	task = xchg(&server->tsk, NULL);
 	if (task)
 		send_sig(SIGKILL, task, 1);
+
+	cifs_tcp_server_put(server);
 }
 
 struct TCP_Server_Info *
@@ -1767,6 +1774,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 		rc = -ENOMEM;
 		goto out_err;
 	}
+	refcount_set(&tcp_ses->refcount, 1);
 
 	tcp_ses->hostname = kstrdup(ctx->server_hostname, GFP_KERNEL);
 	if (!tcp_ses->hostname) {
@@ -1897,9 +1905,12 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	tcp_ses->nr_targets = 1;
 	tcp_ses->ignore_signature = ctx->ignore_signature;
 
+	/* Keep the server alive until the demultiplex thread has exited. */
+	refcount_inc(&tcp_ses->refcount);
 	tcp_ses->tsk = kthread_create(cifs_demultiplex_thread,
 				  tcp_ses, "cifsd");
 	if (IS_ERR(tcp_ses->tsk)) {
+		refcount_dec(&tcp_ses->refcount);
 		rc = PTR_ERR(tcp_ses->tsk);
 		cifs_dbg(VFS, "error %d create cifsd thread\n", rc);
 		module_put(THIS_MODULE);
