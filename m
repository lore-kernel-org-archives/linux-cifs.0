Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752CA385D7C;
	Mon,  7 Sep 2026 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811222; cv=none; b=uJT7EPeM3hMOq9Ej5ZRrSDkL6ye0TjzPG4zo0hILwb3qUMl7Fy77a2WkevbnNKZcBsqDDjv59sdWZCbcvd+tHLdoRJN6k12sseOJ8DwPhANu+mYRF8QVMf0uMvm6uQWVz5pOw9p1+47Mc56VnCKJra/U8yrDgZs4/TN/OeD7sJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811222; c=relaxed/simple;
	bh=zZzMHMpHdJGULgrShhZhMcNvjZeNL2vkyBgYf5dvSfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqqEOrSTt1MY6OARzYFSDG59CugvsOSNEE1MtoySclrm4NOH/h5fJVAAMywMqU3L9YptMUuIQZlpgrj8XFoaYSOKkJf/bZI8tIi6Cqs/u790XuQvGvDEl/WUrC9d0FUP0/KzUy7EjngWqFg3pBysysvNJsj0euXacLIs+ltkMHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hJjy5P6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJjy5P6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA731F00A3A;
	Mon,  7 Sep 2026 20:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788811221;
	bh=F3qgb8x1U49ZWrSngkK781KK8VfF4NSqLywyGCgbcW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJjy5P6jCSn18omVjKKoFEFqVyT6y9XsW2mAiOtlSq8i2dezZfXHnWebSa70fny8M
	 IZaNauaCx7PVUohsILiPpRpPpDRmoGCc3L3qvj5YfbQWfW9shHRW36QjCvuCrQ+zKG
	 COoviEmNrHmyfNNVDNfI4fhJ+91PR8XSzhk+JAjEOH/PchycD5gh18JNNJfEeb1vcW
	 ojngW3knQ6orhb38jbh4hYowJ2T0my6TY/+tbCNfO4u+MHLkybc2T3mn1E+0HZnSyA
	 ymu3R/JYHabuwZUqpn+26bug79pZOChXWa+ArE/m94DzNa/r3bpv9tAmSLBOMOS8vh
	 KunFUlDMfXADA==
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
Subject: [PATCH 6.6.y 1/4] cifs: Remove the server pointer from smb_message
Date: Mon,  7 Sep 2026 16:00:15 -0400
Message-ID: <20260907200018.326904-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090303-fiddling-giant-6389@gregkh>
References: <2026090303-fiddling-giant-6389@gregkh>
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
  backport carries 6. Not backported here:
  fs/smb/client/cifsfs.c
  fs/smb/client/cifsglob.h
  fs/smb/client/cifssmb.c
  fs/smb/client/cifstransport.c
  fs/smb/client/netmisc.c
  fs/smb/client/smb1ops.c
  fs/smb/client/smb2pdu.c
  fs/smb/client/smb2transport.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 730d0bb19507 ("smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/Makefile                       |  2 +-
 fs/smb/client/cifsproto.h                    |  3 ++-
 fs/smb/client/connect.c                      | 11 ++++++-----
 fs/smb/client/{smb1ops.c => smb1transport.c} |  2 +-
 fs/smb/client/smb2ops.c                      | 14 +++++++-------
 fs/smb/client/transport.c                    |  4 ++--
 6 files changed, 19 insertions(+), 17 deletions(-)
 rename fs/smb/client/{smb1ops.c => smb1transport.c} (99%)

diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index e11985f2460b2..3c2af1fa9fa24 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -32,4 +32,4 @@ cifs-$(CONFIG_CIFS_SMB_DIRECT) += smbdirect.o
 
 cifs-$(CONFIG_CIFS_ROOT) += cifsroot.o
 
-cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1ops.o cifssmb.o
+cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1transport.o cifssmb.o
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 1f37bc2923fb8..36f5010d3787d 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -253,7 +253,8 @@ extern unsigned int setup_special_mode_ACE(struct smb_ace *pace,
 					   __u64 nmode);
 extern unsigned int setup_special_user_owner_ACE(struct smb_ace *pace);
 
-extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
+extern void dequeue_mid(struct TCP_Server_Info *server,
+			struct mid_q_entry *mid, bool malformed);
 extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 			         unsigned int to_read);
 extern ssize_t cifs_discard_from_socket(struct TCP_Server_Info *server,
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 68a000956d957..46a48e81a3847 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -882,12 +882,13 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 }
 
 void
-dequeue_mid(struct mid_q_entry *mid, bool malformed)
+dequeue_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid,
+	    bool malformed)
 {
 #ifdef CONFIG_CIFS_STATS2
 	mid->when_received = jiffies;
 #endif
-	spin_lock(&mid->server->mid_lock);
+	spin_lock(&server->mid_lock);
 	if (!malformed)
 		mid->mid_state = MID_RESPONSE_RECEIVED;
 	else
@@ -897,12 +898,12 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 	 * function has finished processing it is a bug.
 	 */
 	if (mid->mid_flags & MID_DELETED) {
-		spin_unlock(&mid->server->mid_lock);
+		spin_unlock(&server->mid_lock);
 		pr_warn_once("trying to dequeue a deleted mid\n");
 	} else {
 		list_del_init(&mid->qhead);
 		mid->mid_flags |= MID_DELETED;
-		spin_unlock(&mid->server->mid_lock);
+		spin_unlock(&server->mid_lock);
 	}
 }
 
@@ -938,7 +939,7 @@ handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		else
 			server->smallbuf = NULL;
 	}
-	dequeue_mid(mid, malformed);
+	dequeue_mid(server, mid, malformed);
 }
 
 int
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1transport.c
similarity index 99%
rename from fs/smb/client/smb1ops.c
rename to fs/smb/client/smb1transport.c
index c80b291a14a57..824604cb0e468 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1transport.c
@@ -398,7 +398,7 @@ cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 			return true;
 		/* All parts received or packet is malformed. */
 		mid->multiEnd = true;
-		dequeue_mid(mid, malformed);
+		dequeue_mid(server, mid, malformed);
 		return true;
 	}
 	if (!server->large_buf) {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 8a15694c1bbb5..b86457fdc08a1 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4627,7 +4627,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		if (is_offloaded)
 			mid->mid_state = MID_RESPONSE_RECEIVED;
 		else
-			dequeue_mid(mid, false);
+			dequeue_mid(server, mid, false);
 		return 0;
 	}
 
@@ -4654,7 +4654,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		if (is_offloaded)
 			mid->mid_state = MID_RESPONSE_MALFORMED;
 		else
-			dequeue_mid(mid, rdata->result);
+			dequeue_mid(server, mid, rdata->result);
 		return 0;
 	}
 
@@ -4673,7 +4673,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(mid, rdata->result);
+				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
 
@@ -4683,7 +4683,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(mid, rdata->result);
+				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
 
@@ -4694,7 +4694,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(mid, rdata->result);
+				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
 		rdata->got_bytes = pages_len;
@@ -4714,14 +4714,14 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		if (is_offloaded)
 			mid->mid_state = MID_RESPONSE_MALFORMED;
 		else
-			dequeue_mid(mid, rdata->result);
+			dequeue_mid(server, mid, rdata->result);
 		return 0;
 	}
 
 	if (is_offloaded)
 		mid->mid_state = MID_RESPONSE_RECEIVED;
 	else
-		dequeue_mid(mid, false);
+		dequeue_mid(server, mid, false);
 	return 0;
 }
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index a47242a0f5c6d..6a1de5973ea05 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1690,7 +1690,7 @@ __cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	int length;
 
 	length = cifs_discard_remaining_data(server);
-	dequeue_mid(mid, malformed);
+	dequeue_mid(server, mid, malformed);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
 	return length;
@@ -1833,7 +1833,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	if (server->total_read < buflen)
 		return cifs_readv_discard(server, mid);
 
-	dequeue_mid(mid, false);
+	dequeue_mid(server, mid, false);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
 	return length;
-- 
2.53.0

