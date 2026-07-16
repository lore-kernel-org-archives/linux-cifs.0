Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5423F789C
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 09:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784195845; cv=none; b=dvDeNdZOxB3+M6+jjni3Af1E9UgARZF+F5qrz4ZupkN0LQlZS91l5NWWCWua1o/rhKAZQToaJhmSvpVheJm8DVfEUJmmsLUd7krqnAKw/G9cZcv7Ep6t1jPOwqm6eKwTjWwsoDzsx0jVPIFscu4/2gleIOqZ0LqAZsLnoD9z1OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784195845; c=relaxed/simple;
	bh=eMymc5rnusUyKX7tdzlSWnZ3kL+wqbtr+2Em1My7mHE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tLfitIc9O6rKZbz3MSF4vdSsUl+RWN05PY2+bgrvpI9cDFAtLyBMg1zmTpsMoQcQUWgIgnCYMweVHOYT0+Hv21ZS08mDVIZurFiHTsWEdXD0nKNL9rkPidevXQ22SWsS/ItlyVac/JGIUB8cJlTz8f0bXb2+/bxxKguF8ybclbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dYxph48L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dYxph48L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1991F00A3D;
	Thu, 16 Jul 2026 09:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784195843;
	bh=2VH/G2ItgiGUmNQrzcGK/+CnvuDOojDFyIm8g/J5ges=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYxph48L0S8BYANqvLVknCCjdjPzH6tLYpm4XDmCQSG6I9it8FRYj+oAmbMzoLlAo
	 RJD1ddRndCFyFvVwA4g0s+paPpoRkzrgF0VNGuKsBwrinMkcLeSsvwPB8PDEbTj1pi
	 l+F7emGPMVz7LAmRjlPUXCTF0fUIJdQkD9rrhkF14eddorw+y2B6iQg4o/rr3uuPAn
	 clXBiwWv8xdmY+G/0brfNKrwh3NrSHLhn3Pjca/tOWOnyzIsEuJnG1uE2w+OznlpZK
	 893pUOf9bmJ7T+BXR6ZRiqu7Jk+CV5HG+/XQvJCuQGlkfa98Y2WNpk1HEEqcFMRIe+
	 aJRDW3bOuIGtA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 4/7] ksmbd: expose connection runtime state in procfs
Date: Thu, 16 Jul 2026 18:57:07 +0900
Message-Id: <20260716095711.6228-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260716095711.6228-1-linkinjeon@kernel.org>
References: <20260716095711.6228-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The clients proc file currently shows only a small subset of the state
needed to diagnose stalled or mis-negotiated connections.

Report the transport, connection state, outstanding and total credits,
session count, lifetime request count, and negotiated signing, encryption,
compression, and POSIX features. Report each connection as a key/value
record rather than a wide fixed-width table.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c | 96 +++++++++++++++++++++++++++++++++-----
 1 file changed, 84 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 47f6d561e150..26e312fb6da8 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -27,33 +27,105 @@ DECLARE_RWSEM(conn_list_lock);
 #ifdef CONFIG_PROC_FS
 static struct proc_dir_entry *proc_clients;
 
+static const char *ksmbd_conn_state_string(struct ksmbd_conn *conn)
+{
+	switch (READ_ONCE(conn->status)) {
+	case KSMBD_SESS_NEW:
+		return "new";
+	case KSMBD_SESS_GOOD:
+		return "good";
+	case KSMBD_SESS_EXITING:
+		return "exiting";
+	case KSMBD_SESS_NEED_RECONNECT:
+		return "reconnect";
+	case KSMBD_SESS_NEED_NEGOTIATE:
+		return "negotiate";
+	case KSMBD_SESS_NEED_SETUP:
+		return "setup";
+	case KSMBD_SESS_RELEASING:
+		return "releasing";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *ksmbd_conn_transport_string(struct ksmbd_conn *conn)
+{
+	if (conn->transport->ops->rdma_read || conn->transport->ops->rdma_write)
+		return "smbdirect";
+	return "tcp";
+}
+
+static void proc_show_conn_feature(struct seq_file *m, bool *separator,
+				   bool enabled, const char *name)
+{
+	if (!enabled)
+		return;
+	seq_printf(m, "%s%s", *separator ? "," : "", name);
+	*separator = true;
+}
+
+static void proc_show_conn_features(struct seq_file *m,
+				    struct ksmbd_conn *conn)
+{
+	bool separator = false;
+
+	proc_show_conn_feature(m, &separator,
+			       conn->sign || conn->signing_negotiated, "sign");
+	proc_show_conn_feature(m, &separator, conn->cipher_type, "encrypt");
+	proc_show_conn_feature(m, &separator,
+			       conn->compress_algorithm != SMB3_COMPRESS_NONE,
+			       "compress");
+	proc_show_conn_feature(m, &separator, conn->posix_ext_supported, "posix");
+	if (!separator)
+		seq_puts(m, "none");
+}
+
 static int proc_show_clients(struct seq_file *m, void *v)
 {
 	struct ksmbd_conn *conn;
 	struct timespec64 now, t;
 	int i;
 
-	seq_printf(m, "#%-40s %-10s %-10s %-12s %-10s %s\n",
-		   "<client>", "<dialect>", "<credits>", "<open files>",
-		   "<requests>", "<last active>");
-
 	down_read(&conn_list_lock);
 	hash_for_each(conn_list, i, conn, hlist) {
+		unsigned int outstanding_credits, total_credits;
+		unsigned long id;
+		void *entry;
+		unsigned int sessions = 0;
+
 		jiffies_to_timespec64(jiffies - conn->last_active, &t);
 		ktime_get_real_ts64(&now);
 		t = timespec64_sub(now, t);
+
+		spin_lock(&conn->credits_lock);
+		outstanding_credits = conn->outstanding_credits;
+		total_credits = conn->total_credits;
+		spin_unlock(&conn->credits_lock);
+
+		rcu_read_lock();
+		xa_for_each(&conn->sessions, id, entry)
+			sessions++;
+		rcu_read_unlock();
 #if IS_ENABLED(CONFIG_IPV6)
 		if (!conn->inet_addr)
-			seq_printf(m, " %-40pI6c", &conn->inet6_addr);
+			seq_printf(m, "client:\t%pI6c\n", &conn->inet6_addr);
 		else
 #endif
-			seq_printf(m, " %-40pI4", &conn->inet_addr);
-		seq_printf(m, " 0x%-8x %-10u %-12d %-10d %ptT\n",
-			   conn->dialect,
-			   conn->total_credits,
-			   atomic_read(&conn->stats.open_files_count),
-			   atomic_read(&conn->req_running),
-			   &t);
+			seq_printf(m, "client:\t%pI4\n", &conn->inet_addr);
+		seq_printf(m, "transport:\t%s\n", ksmbd_conn_transport_string(conn));
+		seq_printf(m, "state:\t%s\n", ksmbd_conn_state_string(conn));
+		seq_printf(m, "dialect:\t0x%04x\n", conn->dialect);
+		seq_printf(m, "credits:\t%u/%u\n", outstanding_credits,
+			   total_credits);
+		seq_printf(m, "sessions:\t%u\n", sessions);
+		seq_printf(m, "open_files:\t%d\n",
+			   atomic_read(&conn->stats.open_files_count));
+		seq_printf(m, "requests:\t%lld\n",
+			   atomic64_read(&conn->stats.request_served));
+		seq_puts(m, "features:\t");
+		proc_show_conn_features(m, conn);
+		seq_printf(m, "\nlast_active:\t%ptT\n\n", &t);
 	}
 	up_read(&conn_list_lock);
 	return 0;
-- 
2.25.1

