Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B8843E484;
	Tue,  8 Sep 2026 12:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870009; cv=none; b=pXvJyqmJxzxyBw68/RvOs0uXum+Fnh/3T+L2EcQAK1jDJR4XUDDKuBPQFCuwylMhyVGALv2U/4ucz4PHDSS7dfeXG63+xk6Q1YniXwEJZS3P0/fUgZ4yZSrVjAyI+1DQ0c0C0zzjBht9iYB8eX9IP/g0U6TcqkYS+cL2bPG+q7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870009; c=relaxed/simple;
	bh=hdJUekzK3kPk4CLUTMphYuHEIA25YLEi6hHFybm2DUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp7AXhrJonMCC8sx3931WV+0xXkRpzAeY4/kWlF0qRRYh5YEJDaLbBy6bHB5kv4l6mULYlpHmv3JhPZKlF1EgQQiL8O4XlCGjXgBOw0eTd1HmYK2Xk+Z6ABN5qOtNcQKlV87esQG/kE8o4hPG3VVO+8IcLZoYbqaMXP/gwVB0ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBD81F00AC4;
	Tue,  8 Sep 2026 12:20:01 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10.y 1/3] cifs: Remove the server pointer from smb_message
Date: Tue,  8 Sep 2026 08:19:58 -0400
Message-ID: <20260908122000.2049341-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090305-henchman-snipping-25aa@gregkh>
References: <2026090305-henchman-snipping-25aa@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 87fba18abbb8433a47045c785f2edc027e4d2bc5 ]

Remove the server pointer from smb_message and instead pass it down to all
the things that access it.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com> (RDMA, smbdirect)
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>

[ sashal: Reduced backport -- upstream 87fba18abbb84 touches 12 file(s), this
  backport carries 5. Not backported here:
  fs/smb/client/cifsfs.c
  fs/smb/client/cifsglob.h
  fs/smb/client/cifsproto.h
  fs/smb/client/cifssmb.c
  fs/smb/client/cifstransport.c
  fs/smb/client/connect.c
  fs/smb/client/netmisc.c
  fs/smb/client/smb1ops.c
  ... and 4 more
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 730d0bb19507 ("smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsproto.h |  3 ++-
 fs/cifs/cifssmb.c   |  4 ++--
 fs/cifs/connect.c   |  5 +++--
 fs/cifs/smb1ops.c   |  2 +-
 fs/cifs/smb2ops.c   | 14 +++++++-------
 5 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index d43e8c331df95..f99cc6f0c5d9c 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -227,7 +227,8 @@ extern unsigned int setup_authusers_ACE(struct cifs_ace *pace);
 extern unsigned int setup_special_mode_ACE(struct cifs_ace *pace, __u64 nmode);
 extern unsigned int setup_special_user_owner_ACE(struct cifs_ace *pace);
 
-extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
+extern void dequeue_mid(struct TCP_Server_Info *server,
+			struct mid_q_entry *mid, bool malformed);
 extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 			         unsigned int to_read);
 extern ssize_t cifs_discard_from_socket(struct TCP_Server_Info *server,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 67ff1669cab2a..94d08d439cb47 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1470,7 +1470,7 @@ __cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	int length;
 
 	length = cifs_discard_remaining_data(server);
-	dequeue_mid(mid, malformed);
+	dequeue_mid(server, mid, malformed);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
 	return length;
@@ -1609,7 +1609,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	if (server->total_read < buflen)
 		return cifs_readv_discard(server, mid);
 
-	dequeue_mid(mid, false);
+	dequeue_mid(server, mid, false);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
 	return length;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a95b9d2318fa2..6f5d42fac9644 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -822,7 +822,8 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 }
 
 void
-dequeue_mid(struct mid_q_entry *mid, bool malformed)
+dequeue_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid,
+	    bool malformed)
 {
 #ifdef CONFIG_CIFS_STATS2
 	mid->when_received = jiffies;
@@ -877,7 +878,7 @@ handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		else
 			server->smallbuf = NULL;
 	}
-	dequeue_mid(mid, malformed);
+	dequeue_mid(server, mid, malformed);
 }
 
 static void clean_demultiplex_info(struct TCP_Server_Info *server)
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 80287c26cfac0..f4247e9536a9d 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -391,7 +391,7 @@ cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 			return true;
 		/* All parts received or packet is malformed. */
 		mid->multiEnd = true;
-		dequeue_mid(mid, malformed);
+		dequeue_mid(server, mid, malformed);
 		return true;
 	}
 	if (!server->large_buf) {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 51f8ea0c89065..cb4253b621d3b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4662,7 +4662,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		if (is_offloaded)
 			mid->mid_state = MID_RESPONSE_RECEIVED;
 		else
-			dequeue_mid(mid, false);
+			dequeue_mid(server, mid, false);
 		return 0;
 	}
 
@@ -4689,7 +4689,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		if (is_offloaded)
 			mid->mid_state = MID_RESPONSE_MALFORMED;
 		else
-			dequeue_mid(mid, rdata->result);
+			dequeue_mid(server, mid, rdata->result);
 		return 0;
 	}
 
@@ -4708,7 +4708,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(mid, rdata->result);
+				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
 
@@ -4718,7 +4718,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(mid, rdata->result);
+				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
 
@@ -4728,7 +4728,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(mid, rdata->result);
+				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
 
@@ -4746,7 +4746,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		if (is_offloaded)
 			mid->mid_state = MID_RESPONSE_MALFORMED;
 		else
-			dequeue_mid(mid, rdata->result);
+			dequeue_mid(server, mid, rdata->result);
 		return 0;
 	}
 
@@ -4760,7 +4760,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	if (is_offloaded)
 		mid->mid_state = MID_RESPONSE_RECEIVED;
 	else
-		dequeue_mid(mid, false);
+		dequeue_mid(server, mid, false);
 	return length;
 }
 
-- 
2.53.0

