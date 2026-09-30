Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B5D3CA481;
	Wed, 30 Sep 2026 18:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794211; cv=none; b=QOW17hr4z0kRay6rkjEUY2LsGFPsacqNRbCZUkkrbmzChUzO/SZyajyTFZJhf3fuuyqYI9lfM2RgqAnFada9fZi2AJ56T1Ww3SG6RFTy4sCKgWrq6GE1TtJXg1uw1E9Dbuzo7nNyyIYtZWl+iUt1A8lQyj+hBRvelDDCiZ53r9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794211; c=relaxed/simple;
	bh=kMSYG2TRN9dAoSD5zyjvp+YUyBTiXW5oUfawUAP/IAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTSU1U1q63TTCVzaWRxtsLydhgHFHX6r1BQex1PUQrmg+mt3tWXkeuh7wIomZK43BXhVyuyuCKw8TjsirZcIzv2fuuwMCOhq0SLc3IntzA5mftSlnk5SitpKb4JxZMmZiUDnZReQyUg9E5qdkp5ldOyGgUBYdaKfbiu6oKtOHC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kV421aLU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kV421aLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB99C1F00899;
	Wed, 30 Sep 2026 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790794210;
	bh=J5HX2VYhnq/u5nV6H2e0oAaZZuxVHhPL73VXbSHJ6ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kV421aLU6vdnDaVnbmrpYDKHvzqBXWdpaBJfgcbhGakwxoPJ657qw1KPAUrM+RHKW
	 JyU4uHwpIA32Elrmwu3ywDz//4v+2DLIa8jhOCm3304NAhBbKXydjpwmmsIpZed9UR
	 TnEd1pPXbI0a/PNu3GCmJ/8MN9VNWMcXgkbARuifeL8KvLcoNJiCVf7t8YlkXMMpsg
	 sBowO7kA7udz5cKAiNbLpWL6rLMhfMcGM2FxEjIDrBQ1v6E/0L4AfOS+XxF8fP8vBr
	 7tdDP97Wk6522NBuq+1eZNYBXQWtV2bmEuukpclqo87uz/l4v921CMK5MoyIlbEkPf
	 iAXCSzO+AZnFg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y 2/3] cifs: Fix specification of function pointers
Date: Wed, 30 Sep 2026 14:50:05 -0400
Message-ID: <20260930185006.338236-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930185006.338236-1-sashal@kernel.org>
References: <2026092926-stopwatch-rumbling-2993@gregkh>
 <20260930185006.338236-1-sashal@kernel.org>
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
index 11fdaf9029539..72d608af772d0 100644
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
index 5c72c8eb94182..f3eb7c6b641d1 100644
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

