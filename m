Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E60D1CAA7D;
	Tue, 10 Feb 2026 14:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770732745; cv=none; b=BFs7Y/P1thtlpZY1YVFk2TjKx3iB37rRIP2zU3obWCTuKC+NQjOYnWFQxDCdKzHWJiusgu21dOBD+JNRSnUrFA4vNiFH7JUZvwmH1n93nkCZ0BQ5Jqk82V1v9+Mv33LBwECHIdUEEijPClMipcVIfURKMXYj5SFFNEQg2CJydOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770732745; c=relaxed/simple;
	bh=wJj0MQ31kzyA4d66mGVJoEAuoD4w9Rwh3HxHLDxZC20=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YbBa6dGRS+cx5+t6PYlS5+GlL3Zq9zUWreXG7m3RbfVlPY2tNxKvz2Z4u673gJ+n5McIv1UMtWOSwFsP7cfgRB17ZI9NCttEZKoaQk6KVpBZb0fJqla53AYmKaJTW096s+wuI9NOOqUE3FpzE6uyYHpoZW0QPwj2J0zwog05AmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQm38ks1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQm38ks1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553C0C116C6;
	Tue, 10 Feb 2026 14:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770732745;
	bh=wJj0MQ31kzyA4d66mGVJoEAuoD4w9Rwh3HxHLDxZC20=;
	h=From:To:Cc:Subject:Date:From;
	b=hQm38ks1bnFheH1XAS9wLlRN6N3gAtN+gkrc/aey/X7dRDVFSYiPgPX4TJgVb6BDS
	 I3BnSJJg14PBYsAWj0ipSciRFPm+9CKbI+XU5bGV+KrAIvra7hVzCADnGpcO0X5pl6
	 S994JyF016ODzysrBkbp5/3B+v9onXuxAFGv8c+BGhHjBO7qDoLDtlUcnl67rSGFRA
	 KYgPbgn9Qa9YmnVxR9m9sQAZagkeW9/kmAkQlxpGqXwQvJe5FyLU2+3kaPA3W6gc1A
	 OhOkzrmQyi8pyDaEFRV/qaLEPo3AtHD3lGXFC/EQXmnL0OfELo86i9h0kzw2zcKkyE
	 2ZkNd7TvBzWLg==
From: Arnd Bergmann <arnd@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sang-Soo Lee <constant.lee@samsung.com>,
	Bahubali B Gumaji <bahubali.bg@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: fix non-IPv6 build
Date: Tue, 10 Feb 2026 15:12:05 +0100
Message-Id: <20260210141219.1573869-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The newly added procfs code fails to build when CONFIG_IPv6 is disabled:

fs/smb/server/connection.c: In function 'proc_show_clients':
fs/smb/server/connection.c:47:58: error: 'struct ksmbd_conn' has no member named 'inet6_addr'; did you mean 'inet_addr'?
   47 |                         seq_printf(m, "%-20pI6c", &conn->inet6_addr);
      |                                                          ^~~~~~~~~~
      |                                                          inet_addr
make[7]: *** [scripts/Makefile.build:279: fs/smb/server/connection.o] Error 1
fs/smb/server/mgmt/user_session.c: In function 'show_proc_sessions':
fs/smb/server/mgmt/user_session.c:215:65: error: 'struct ksmbd_conn' has no member named 'inet6_addr'; did you mean 'inet_addr'?
  215 |                         seq_printf(m, " %-40pI6c", &chan->conn->inet6_addr);
      |                                                                 ^~~~~~~~~~
      |                                                                 inet_addr

Rearrange the condition to allow adding a simple preprocessor conditional.

Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring and statistics")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Alternatively, the corresponding check in the ksmbd_conn could be removed,
which would waste a few bytes per connection but avoid the #ifdef.
---
 fs/smb/server/connection.c        | 8 +++++---
 fs/smb/server/mgmt/user_session.c | 8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index f0bd244e7d55..e7e3e77006b1 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -41,10 +41,12 @@ static int proc_show_clients(struct seq_file *m, void *v)
 		jiffies_to_timespec64(jiffies - conn->last_active, &t);
 		ktime_get_real_ts64(&now);
 		t = timespec64_sub(now, t);
-		if (conn->inet_addr)
-			seq_printf(m, "%-20pI4", &conn->inet_addr);
-		else
+#if IS_ENABLED(CONFIG_IPV6)
+		if (!conn->inet_addr)
 			seq_printf(m, "%-20pI6c", &conn->inet6_addr);
+		else
+#endif
+			seq_printf(m, "%-20pI4", &conn->inet_addr);
 		seq_printf(m, "   0x%-10x %-10u %-12d %-10d %ptT\n",
 			   conn->dialect,
 			   conn->total_credits,
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 68b3e0cb54d3..47ce759c231e 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -209,10 +209,12 @@ static int show_proc_sessions(struct seq_file *m, void *v)
 		down_read(&chan->conn->session_lock);
 		ksmbd_user_session_get(session);
 
-		if (chan->conn->inet_addr)
-			seq_printf(m, " %-40pI4", &chan->conn->inet_addr);
-		else
+#if IS_ENABLED(CONFIG_IPV6)
+		if (!chan->conn->inet_addr)
 			seq_printf(m, " %-40pI6c", &chan->conn->inet6_addr);
+		else
+#endif
+			seq_printf(m, " %-40pI4", &chan->conn->inet_addr);
 		seq_printf(m, " %-15s %-10llu %-10s\n",
 			   session_user_name(session),
 			   session->id,
-- 
2.39.5

