Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13A434CFD9
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744246; cv=none; b=YkbdsNquO3rzEXhsFQJPYGYp11lOIFeIdwRdKdQ7mOsW4k0jBadjqeFqKFLkyqwiQbf5jWOPxQePIPFVmGLOyJczk7boR9NK9shpLrDlb1Ras3ZDtQmcdqf62iPHRl6yq4jJ8JriD6JrApPnJRwyDOXMXh2fjYwCbezFO+X7XJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744246; c=relaxed/simple;
	bh=azVjYsXEuZjGAPsWZVoYVz/ULX089C37zqpRqOcOwMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsIc/dtfh6BIgtIq8+gB4ZczEWwkyN4fmMCKZ5thI+cP3F161ZdKoaN0+tIJmg9XfLL1BeDubc8qB04NsBNE/f7vnNiWtSPdmUSKwGelBtMceJsJ/7Y3e+zTlZR19OUlCsOdcIQo7NpVncOJcDRjTHnhN13ohS6JKkJuE4EKMcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MS8Z1Md3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MS8Z1Md3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=L/eSe2pakCtQVKwuwbPyB7UyuaI0+Ick39K6Bq0JRKY=; b=MS8Z1Md3+39mjmru1CEYTlo/jh
	8tqj6R5zWMD5Ol1zVv2dr4FQprC4AIvxcxhbNq8wYwSJeah16lJKoEgCtsV5nP5t5brfffdk9azVI
	VA3YI1TXxHEq9VHPy5rWcR+re9xl+VnKT2SQgjjqgZG8FVfzi4R41tLa0zo2mHCznwPXOB2hgLe0Y
	AJYtc5ajLTYye2kD6B/cRN6WoiGw1QiyF6EPzFv2zDwFAk0zZTZk2ld/WUMNJhBkkQ2aSP7/35JjX
	mwdJv4wR8R24haRNMlIRqwvr4xjvWR7U3fO+N/Rp+dCzgPpvux8UmpkN95L81Qnh8ntFA+15Lwjut
	Oq9SVQLMG4IeuQ1ClO1uhkMK6jQPTXkk1QvPHrV/zcffQuvX56s2QXgRRf4Y+AFeDHMrIjlz7NOjn
	LLYCmoYt0SFAE+FHtWJcXdezT0dZeSbjDIyUJQakFtyGiWHo9yLHImSx02xCIg1p+fYNKbX9ibn2/
	RF1ndkqHjW8L4YciraaBCzx3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE69g-00BbQP-39;
	Wed, 29 Oct 2025 13:24:01 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 015/127] smb: smbdirect: introduce smbdirect_connection_idle_timer_work()
Date: Wed, 29 Oct 2025 14:19:53 +0100
Message-ID: <a372810075445478ad5dd1e538fedf18d3ca1aea.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is basically a copy of idle_connection_timer() in the client
and smb_direct_idle_connection_timer() in the server.
The only difference is that the server does not have logging.

Currently the callers set their own timer function after
smbdirect_socket_prepare_create(), but that will change
in the next steps...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 27f8545ee30d..79be89a3946e 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -9,6 +9,7 @@
 static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
 						     int error);
 static void smbdirect_connection_disconnect_work(struct work_struct *work);
+static void smbdirect_connection_idle_timer_work(struct work_struct *work);
 
 __maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
@@ -29,6 +30,8 @@ static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 	sc->workqueue = workqueue;
 
 	INIT_WORK(&sc->disconnect_work, smbdirect_connection_disconnect_work);
+
+	INIT_DELAYED_WORK(&sc->idle.timer_work, smbdirect_connection_idle_timer_work);
 }
 
 __maybe_unused /* this is temporary while this file is included in orders */
@@ -276,3 +279,34 @@ static void smbdirect_connection_disconnect_work(struct work_struct *work)
 	 */
 	smbdirect_connection_wake_up_all(sc);
 }
+
+static void smbdirect_connection_idle_timer_work(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, idle.timer_work.work);
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+
+	if (sc->idle.keepalive != SMBDIRECT_KEEPALIVE_NONE) {
+		smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_ERR,
+			"%s => timeout sc->idle.keepalive=%s\n",
+			smbdirect_socket_status_string(sc->status),
+			sc->idle.keepalive == SMBDIRECT_KEEPALIVE_SENT ?
+			"SENT" : "PENDING");
+		smbdirect_connection_schedule_disconnect(sc, -ETIMEDOUT);
+		return;
+	}
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+		return;
+
+	/*
+	 * Now use the keepalive timeout (instead of keepalive interval)
+	 * in order to wait for a response
+	 */
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
+	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+			 msecs_to_jiffies(sp->keepalive_timeout_msec));
+	smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
+		"schedule send of empty idle message\n");
+	queue_work(sc->workqueue, &sc->idle.immediate_work);
+}
-- 
2.43.0

