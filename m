Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136664BC016;
	Wed, 30 Sep 2026 23:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790811997; cv=none; b=JpjVDCbf3WTuFhJBtplQkBI8ApznVkcEbBVbY7pfJ2UyQJ6wm7XrsB/N0rnF7saJgSd7H8n5u279sGpukO8tXwJ3rcg158rt3NHBzNMHJe37OpinWtu0KsmDccvhYSdaOJZ3Z6ubv/CGC2oGK/e79/nvEgUiaq9hn/9A+wrK7pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790811997; c=relaxed/simple;
	bh=FJDme9+3XAphmFFJ85wr2xkkAYIzosZR5lnCtfby0Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgJVLZ25TRkWuPhEGcJtMMk51l0SOOiq0NFDjhBP1Q72rxsKTuRdbwcHV8HpOz2xQeaBLy9DoBmOsYfDeVNy+K50oRIHYibdk3XgLUOxyu50iyjLiYRhzgUbDMv1UhT58Sr3xmhEUegkoWx4W2PIcWrvAqF9C8AgF2MuyDrQLyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cy9JxP1/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cy9JxP1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C0D1F000FF;
	Wed, 30 Sep 2026 23:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790811995;
	bh=m1irFLlbBFScDZJuBJ1KPN/EPZu1+6Lsd6h3OCM3F+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cy9JxP1/kbGH1zk2ON3lgCT5GcfkSLXS7mKE0K69VtvzWw9F1WhNnZNbNSS+MMNNA
	 wfJBah6rgr2QvkVNr31GRHWhLmM5phT2OlXN+H0f4L7aSV73brnCedqnCH5MpIlmTB
	 bC4I+R+jqOnKtbOuv9ds9F2R4OOzG0ZyuwgfUwif2/1AtvW6c/mhMtl0Uo2HS/IKDa
	 Crr7UwO9teerAlQUKT/B1Dj1FMPSkcQ6Ltk6jhZPlyHKmT4kluRPUYgu7AgrbuoTr5
	 CIIga0FVie/U7m85Rrs6Mtdv8HbPkD9+tBvuK1NI0b+4CYNyvudHpeM/LPFV3MexOl
	 XAi05yp5IbZ0A==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10.y 1/3] cifs: Fix specification of function pointers
Date: Wed, 30 Sep 2026 19:46:29 -0400
Message-ID: <20260930234631.1192065-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026092901-extending-vineyard-ce48@gregkh>
References: <2026092901-extending-vineyard-ce48@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 6a86a4cc281a5cfceda7af60ea6fa506b3db7430 ]

Change the mid_receive_t, mid_callback_t and mid_handle_t function pointers
to have the pointer marker in the typedef.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 8f6f8a48399f ("smb: client: delete compound mids on send failure before unlock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h  | 12 ++++++------
 fs/cifs/cifsproto.h |  8 ++++----
 fs/cifs/transport.c |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d0905aa0b04cd..b61e9f2efc176 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1569,7 +1569,7 @@ static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
  * Returns zero on a successful receive, or an error. The receive state in
  * the TCP_Server_Info will also be updated.
  */
-typedef int (mid_receive_t)(struct TCP_Server_Info *server,
+typedef int (*mid_receive_t)(struct TCP_Server_Info *server,
 			    struct mid_q_entry *mid);
 
 /*
@@ -1580,13 +1580,13 @@ typedef int (mid_receive_t)(struct TCP_Server_Info *server,
  * - it will be called by cifsd, with no locks held
  * - the mid will be removed from any lists
  */
-typedef void (mid_callback_t)(struct mid_q_entry *mid);
+typedef void (*mid_callback_t)(struct mid_q_entry *mid);
 
 /*
  * This is the protopyte for mid handle function. This is called once the mid
  * has been recognized after decryption of the message.
  */
-typedef int (mid_handle_t)(struct TCP_Server_Info *server,
+typedef int (*mid_handle_t)(struct TCP_Server_Info *server,
 			    struct mid_q_entry *mid);
 
 /* one of these for every pending CIFS request to the server */
@@ -1604,9 +1604,9 @@ struct mid_q_entry {
 	unsigned long when_sent; /* time when smb send finished */
 	unsigned long when_received; /* when demux complete (taken off wire) */
 #endif
-	mid_receive_t *receive; /* call receive callback */
-	mid_callback_t *callback; /* call completion callback */
-	mid_handle_t *handle; /* call handle mid callback */
+	mid_receive_t receive;	/* call receive callback */
+	mid_callback_t callback; /* call completion callback */
+	mid_handle_t handle;	/* call handle mid callback */
 	void *callback_data;	  /* general purpose pointer for callback */
 	struct task_struct *creator;
 	void *resp_buf;		/* pointer to received SMB header */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index d43e8c331df95..ba58a9f569d7c 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -92,10 +92,10 @@ extern int cifs_handle_standard(struct TCP_Server_Info *server,
 extern bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
 extern int cifs_discard_remaining_data(struct TCP_Server_Info *server);
 extern int cifs_call_async(struct TCP_Server_Info *server,
-			struct smb_rqst *rqst,
-			mid_receive_t *receive, mid_callback_t *callback,
-			mid_handle_t *handle, void *cbdata, const int flags,
-			const struct cifs_credits *exist_credits);
+			   struct smb_rqst *rqst,
+			   mid_receive_t receive, mid_callback_t callback,
+			   mid_handle_t handle, void *cbdata, const int flags,
+			   const struct cifs_credits *exist_credits);
 extern struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses);
 extern int cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			  struct TCP_Server_Info *server,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 9b0fa5fd965a2..6a6772ded4b8c 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -771,8 +771,8 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
  */
 int
 cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
-		mid_receive_t *receive, mid_callback_t *callback,
-		mid_handle_t *handle, void *cbdata, const int flags,
+		mid_receive_t receive, mid_callback_t callback,
+		mid_handle_t handle, void *cbdata, const int flags,
 		const struct cifs_credits *exist_credits)
 {
 	int rc;
-- 
2.53.0

