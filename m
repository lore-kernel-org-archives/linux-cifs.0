Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D213502D4A;
	Wed, 30 Sep 2026 21:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804551; cv=none; b=obi7oXGsoi5pfO9jDGhbluSvs/oodalc2z9lBajh7jN7Jl8geaWDw8sfrL6sjrWlowEZZbyoJtDdWMVRMwChU1lRVWOPc98FgXV+Y1biBcdJEZ9fsZgKTvNT9rFWjkpgHQKbGOsq0dSK+8alPHsHWkO7otH2LzVB9TSX6Nb5wL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804551; c=relaxed/simple;
	bh=aGMgxQPcL+0hh6QJlN5804oXJax6z2VFnRLl4tSmuEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIdhDU4mxtQVGsE4iqhh4nkufxi8K8EhpIl9iw5OG6GTOFZfh/P2AzfwE4n4acKc+YzV4aDmX4iLF+snOH3rfWCy2R17JWIvry4tFTkD4NndLaIiUUoHiOTh2BFYZNJBfzfH4E3oRTGNo1xwqWx7BgnsrzVPDjUZg9Vm2tZwHqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q3VK3rId; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q3VK3rId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1381F000FF;
	Wed, 30 Sep 2026 21:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804550;
	bh=VTD5ooBhlbkcZMaV3t/m1ZONzVpYyqNeWvY3G7FY8Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q3VK3rIdIxxJqtVcImy3yOtjdE/4bpuKG7LZ5XW1ybS5j5V6ATlUGiaqfDDJSaxRu
	 P9bYFqaOIWB3ZjnM2e+ohcfyVZmZVlS/Cd16g0wP4IaZWoNJiv9+kxhH/5Ls8lZrFg
	 I3wK3emP1Zzi9vgGn96/4CtYRsP29yUZYHjE4WCob7QFD7DUfgxVJeEPGHl3DX1R8G
	 rZqLZIDH3p0qpcoW8GggOlL5l8Y0hMdVBgNAjNbYllzImJvlUQdh3vZKHN+ZeydkDL
	 L0gKRk7Q2Vj6JVs3RDV6YCBZdSCMrl+GhjOVesWAyPR/wwSnvEnStxiJlxC5NehtgO
	 GpBzaP9d+VXbQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15.y 1/3] cifs: Fix specification of function pointers
Date: Wed, 30 Sep 2026 17:42:25 -0400
Message-ID: <20260930214227.3484209-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026092900-threefold-unblessed-1235@gregkh>
References: <2026092900-threefold-unblessed-1235@gregkh>
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
index 9b08020634f19..616305a32e34a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1515,7 +1515,7 @@ static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
  * Returns zero on a successful receive, or an error. The receive state in
  * the TCP_Server_Info will also be updated.
  */
-typedef int (mid_receive_t)(struct TCP_Server_Info *server,
+typedef int (*mid_receive_t)(struct TCP_Server_Info *server,
 			    struct mid_q_entry *mid);
 
 /*
@@ -1526,13 +1526,13 @@ typedef int (mid_receive_t)(struct TCP_Server_Info *server,
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
@@ -1550,9 +1550,9 @@ struct mid_q_entry {
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
index 5cfe41b2fe4ae..8525d47f09494 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -92,10 +92,10 @@ extern int smb3_parse_opt(const char *options, const char *key, char **val);
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
index 65a225a9c6cf8..d30183fac942e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -800,8 +800,8 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
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

