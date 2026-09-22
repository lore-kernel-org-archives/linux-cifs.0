Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99306541E5E;
	Tue, 22 Sep 2026 12:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790079552; cv=none; b=fFkXf/u31uJ366Y0hPXDMhSnn5kMzzT+v0vuiaVwqr6X5fhwmnHRNxVZo4yiheSC2v5FfPV+A8nrW+l2Dbgb2zKJgoQI0X9KyY/SjLdeEz04jj0rYbcSYKfNZqWJRu+Gfz32aQ4j7g550n/2tjaO+TdAIgichGHGmu1BYuasuNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790079552; c=relaxed/simple;
	bh=vrNSAD0zEYyjfJk03+WsZR8WvK/X5v4FTCoyjX/HhHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lk0jRIjp1wmOsXssRgMNpW+VKLhz7EFbWnfLy7s6vddU9/dfrBdjG0DbDabghW1ERwbXEV8bhb2xmWWxgZ4mqAJiTf+Bsh4AIxwvghLj0z12yVhOhgeexgdCJro4APv89tTylZ0j3xYyrMabsfaa/Tiit9i9OppdBYagVrAlEsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+fTsZuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+fTsZuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0C81F0089F;
	Tue, 22 Sep 2026 12:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790079551;
	bh=sqSNUoFYVQFnhYlC2sjuNpB8Pn6nj7ytmhctuSitdjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+fTsZuY84AhcM5D68JC/QR6LwxnY9jSNUH+S+Xig/In/YtmlYSN/Sro3PUZp5w+B
	 VW3toJj9yuK1JsaZlCzoVI7IgCTbr6A33q33RC8Y2rX8Ji4YMJFS9DtrXFb5gAOxvs
	 zNhf46kYB3tGEahcGb3+5G3Vzjh9JPX7TJuFImxIrtTbAEs8Rebjf6jgioWjAUFtHU
	 dYr3Jrh85xijGr1QGNXOlKzWdv9P1LJa0RkZrfHy/dvUFA2zSaOur8xb+U3XjTUef6
	 zFH5MmWEjMq+yDCdUfDf2fdDeBSPLkvIoQK6Ri0WFQDyLyJa8IushCcBOMLYu6TJ3I
	 M9qwvJQe1Hftg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y 1/2] cifs: Fix specification of function pointers
Date: Tue, 22 Sep 2026 08:19:06 -0400
Message-ID: <20260922121907.2213071-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026092222-rubbing-overplay-5a22@gregkh>
References: <2026092222-rubbing-overplay-5a22@gregkh>
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
Stable-dep-of: c60ae98c5aa6 ("9p: Fix v9fs_issue_write() to update i_size and remote_i_size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h  | 12 ++++++------
 fs/smb/client/cifsproto.h |  8 ++++----
 fs/smb/client/transport.c |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3f9c03828cd4f..1734ae9bf318e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1619,7 +1619,7 @@ static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
  * Returns zero on a successful receive, or an error. The receive state in
  * the TCP_Server_Info will also be updated.
  */
-typedef int (mid_receive_t)(struct TCP_Server_Info *server,
+typedef int (*mid_receive_t)(struct TCP_Server_Info *server,
 			    struct mid_q_entry *mid);
 
 /*
@@ -1630,13 +1630,13 @@ typedef int (mid_receive_t)(struct TCP_Server_Info *server,
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
@@ -1654,9 +1654,9 @@ struct mid_q_entry {
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
index d2d004764a708..e2a7d55a2502d 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -96,10 +96,10 @@ extern int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
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
index c3940d3ecd5f3..14dacf2967146 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -792,8 +792,8 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
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

