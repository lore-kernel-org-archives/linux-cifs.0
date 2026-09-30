Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C55D51DE1B;
	Wed, 30 Sep 2026 17:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789654; cv=none; b=IYxzVgRoND3M2rczVwflUoz6a/20Zs3/mfuUUrJK9SHctndGTRfqVSBYKy41ja1wMOXoCXY6CCnzNru7/Y+tC6iQr+wOjOUnHAiQzKwScEA8w/Ej8hOimFWYEnXboaqz01gtoWtC6DgVRjiWkG5wKeR9g3DqszZ8F8EUMuvZTI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789654; c=relaxed/simple;
	bh=tSun6CEga66uu4c5qR7C6gyzIPJzp12kCZqLRTku4kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqB02Fjrwy6mYBsaM++yQIhjOWzjZO1JOKYVD93TdpHnqv7QQMLUeedNjhM5k+GEQ2KVpTF84ZPgepFHnaa54w7Yv21OVVuSJTRKXDyAz84W6vHB04EwQboZzlzCbX/05rZwdAXvoIEcBnI6Wkdiw6wVp8eclVCbYvhjd6fxBC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFRC0V9o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFRC0V9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A45B1F0089A;
	Wed, 30 Sep 2026 17:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790789652;
	bh=0kke2jjjpfTjOajAHDwyfsWeVx21CXeMIbgHAdZrMmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFRC0V9oVMeN0MJhjGz0q7L4QE1I3i1HA+yAQH4T1DRQ3gsb6AWWeYJnJ6BYS5Lqw
	 bNvz+4uLvbjAoWpu11FEQCljqwWgpQ5SjIVA6uP3hOu7Dx2SZvmapuEGf3UqIt6pDW
	 gT52gQpXmuNCZMUjyepSy+AUEPnMGueTYtVcSk2qRI7nrfDhOQXiGRQYCmWZPvx5lm
	 YUAgtJzd1Ftzq+DavdMWzrQ/yc2H1CczM8f7I8WQxHBz8e2piWTn4nt3GxbVdVQca5
	 cePbDHQJUm0I/fVh2zMoG28GSEy/Wg5G6E2WYh9U3k8eoXRZ+cHWtTh9Vy2dAuXMVw
	 1QrdBRHv81gYA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18.y 2/3] cifs: Fix specification of function pointers
Date: Wed, 30 Sep 2026 13:34:08 -0400
Message-ID: <20260930173409.3642584-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930173409.3642584-1-sashal@kernel.org>
References: <2026092926-hedging-absolve-77a2@gregkh>
 <20260930173409.3642584-1-sashal@kernel.org>
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
 fs/smb/client/cifsglob.h  | 12 ++++++------
 fs/smb/client/cifsproto.h |  8 ++++----
 fs/smb/client/transport.c |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 1837f4820bd67..ae67ff3743fe2 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1663,7 +1663,7 @@ static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
  * Returns zero on a successful receive, or an error. The receive state in
  * the TCP_Server_Info will also be updated.
  */
-typedef int (mid_receive_t)(struct TCP_Server_Info *server,
+typedef int (*mid_receive_t)(struct TCP_Server_Info *server,
 			    struct mid_q_entry *mid);
 
 /*
@@ -1674,13 +1674,13 @@ typedef int (mid_receive_t)(struct TCP_Server_Info *server,
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
@@ -1698,9 +1698,9 @@ struct mid_q_entry {
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
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index bde609041433d..e4386c109a7bd 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -97,10 +97,10 @@ extern int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
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
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 0d55714116a4b..4fedc4a845435 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -659,8 +659,8 @@ int wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
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

