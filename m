Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549AA23F40D;
	Mon,  7 Sep 2026 22:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788821159; cv=none; b=svR/pgRhLAliTPQ2oyCIpzVQ+QAwMx7re1h0d5/45H7Bw/OpCW01xtPcLN81U1iAtT6mLe4DWUgKs3S8obevFhBuEjEAOMNSoJsIKPKpAvuhnGsOExGV8eUN/q0P14aZMHzDEB1O7L6gpdSt4aPVU0G+0Sdh0KF6vzQ0weyAXTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788821159; c=relaxed/simple;
	bh=To6O7+9s6WuJkH3K2xcsbC/xSZF+hPmAI9Yj/DgVdXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLOAi7Z57bemAjE0fWha4VIF0FAX6zWmz5EsOjh+jHFtwdCSbSTe9WqjoqJXEFulp+zlQSu+SmhT4wmNLgSLyT+rin6lFI8IBNgig5qqkHyJJoHoczxrsySyliepwGnNb/cSbIx1UF6Eqg2CBxY38KE4Bk5J2POJW4b/Ta8pLxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBb70cVO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBb70cVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0F51F00A3A;
	Mon,  7 Sep 2026 22:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788821157;
	bh=asBK7FBZsUqayKX20rCC4/+fVUpQUaAsV6GRxgmH5bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBb70cVOBMjwutsuQLASxMFqQFKFhGp2mcbXOKfAArkk053fZ/T88m2sEES960j22
	 CVhf1qAu5080bEwrPYnWmMMe6kCv9KTl/rM7BuRNLp2zbGAby2v31696g5VGZDBp5N
	 yG0xgPoX/6ASqxEnWmezxkh5O3zb8YnnGQcuSD0d7OyHqifTWAIfjAM3EtSkv6a6Hb
	 e2IXwLZ/4lA0LMSbzOxx8DuBjEKYXtNsWQyl1hsieBzSvSdjn4/3Gp2TsFWQYxFCQ8
	 iIrKq0ySKkqMQP+5dx095bWMiBIbDp86mvfpOIkVzz8vADIW78qE0Nb7Te0YlD3rYN
	 4ogbN+U7zVf9A==
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
Subject: [PATCH 6.1.y 1/4] cifs: Remove the server pointer from smb_message
Date: Mon,  7 Sep 2026 18:45:52 -0400
Message-ID: <20260907224555.689206-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090304-drowsily-unread-e280@gregkh>
References: <2026090304-drowsily-unread-e280@gregkh>
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
index 7c9785973f496..ee5ed556d91f9 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -31,4 +31,4 @@ cifs-$(CONFIG_CIFS_SMB_DIRECT) += smbdirect.o
 
 cifs-$(CONFIG_CIFS_ROOT) += cifsroot.o
 
-cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1ops.o cifssmb.o
+cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1transport.o cifssmb.o
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 8cfa504e6bd83..e23a3dcf96af4 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -257,7 +257,8 @@ extern unsigned int setup_authusers_ACE(struct cifs_ace *pace);
 extern unsigned int setup_special_mode_ACE(struct cifs_ace *pace, __u64 nmode);
 extern unsigned int setup_special_user_owner_ACE(struct cifs_ace *pace);
 
-extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
+extern void dequeue_mid(struct TCP_Server_Info *server,
+			struct mid_q_entry *mid, bool malformed);
 extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 			         unsigned int to_read);
 extern ssize_t cifs_discard_from_socket(struct TCP_Server_Info *server,
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 096e69c591722..0bdd19854902b 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -892,12 +892,13 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
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
@@ -907,12 +908,12 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
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
 
@@ -948,7 +949,7 @@ handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
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
index 1489b9d21b609..a27206cb1fc89 100644
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
index 2b38e8e7efd4e..b6334bf047e4b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4881,7 +4881,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		if (is_offloaded)
 			mid->mid_state = MID_RESPONSE_RECEIVED;
 		else
-			dequeue_mid(mid, false);
+			dequeue_mid(server, mid, false);
 		return 0;
 	}
 
@@ -4908,7 +4908,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		if (is_offloaded)
 			mid->mid_state = MID_RESPONSE_MALFORMED;
 		else
-			dequeue_mid(mid, rdata->result);
+			dequeue_mid(server, mid, rdata->result);
 		return 0;
 	}
 
@@ -4927,7 +4927,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(mid, rdata->result);
+				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
 
@@ -4937,7 +4937,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(mid, rdata->result);
+				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
 
@@ -4947,7 +4947,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(mid, rdata->result);
+				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
 
@@ -4965,7 +4965,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		if (is_offloaded)
 			mid->mid_state = MID_RESPONSE_MALFORMED;
 		else
-			dequeue_mid(mid, rdata->result);
+			dequeue_mid(server, mid, rdata->result);
 		return 0;
 	}
 
@@ -4979,7 +4979,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	if (is_offloaded)
 		mid->mid_state = MID_RESPONSE_RECEIVED;
 	else
-		dequeue_mid(mid, false);
+		dequeue_mid(server, mid, false);
 	return length;
 }
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index b72d12a24056c..506f1e38bb2d7 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1710,7 +1710,7 @@ __cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	int length;
 
 	length = cifs_discard_remaining_data(server);
-	dequeue_mid(mid, malformed);
+	dequeue_mid(server, mid, malformed);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
 	return length;
@@ -1848,7 +1848,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	if (server->total_read < buflen)
 		return cifs_readv_discard(server, mid);
 
-	dequeue_mid(mid, false);
+	dequeue_mid(server, mid, false);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
 	return length;
-- 
2.53.0

