Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1220C52E064;
	Wed, 30 Sep 2026 17:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790385; cv=none; b=hdYqFTVlFbSYSVlgMQPY4NEmQ8ZlW7thYDc1s/hfyh9Blw/jWYn3b27CFkwBVwlxA+Am40H8e8C5qnW1UJRY/pAPfR0FwDVAmW67bsGBWSMDmdVu/rX/V7F8/Db/cOTOt/5noD4p/1+2qFgATDeobTfytkg6b6wj1f4t3t1R1LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790385; c=relaxed/simple;
	bh=lRJcrOYZVLbBToNKZc6ORhBI9MPVyguvRTKcbI5ukwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp/9Teu7f9j6s0nX54KfKBMxYo9b2xLgQZ3mwhmbePeKvEJOhdNJHSsnFObQUr2s0jYLOzOKjGseybUHgn1UVabU8dMAVEPPWWGGTWrWFNfF/6eRZVBAL2oOMbi3dPEw01Jwqa+nkG1NZXuFlEBfKigEm/mkc0q61cyn8wHqyx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHIZWgtB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHIZWgtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C84B1F00898;
	Wed, 30 Sep 2026 17:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790383;
	bh=tNyg/M+rX8N5idx16IZapLLCm9mwMdtty/seKHtFqcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHIZWgtBwJFOCvQuf0I86DWCseIsfMRv8Ib3T1SIw3g7wpWem6UhNVmBDbJckoi4I
	 0Jfp8VKLM6mKLwe/iBKDOdDdnqgCnUp003ZsSypUs6J7153psaHXXqamF2g8uYLN1g
	 hRfNhzoO7cPZMTiAjiir9cavgAfkLSPUXpSiEAdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 783/877] cifs: Fix specification of function pointers
Date: Wed, 30 Sep 2026 17:28:14 +0200
Message-ID: <20260930152431.611883162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsglob.h  |   12 ++++++------
 fs/smb/client/cifsproto.h |    8 ++++----
 fs/smb/client/transport.c |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1619,7 +1619,7 @@ static inline void cifs_stats_bytes_read
  * Returns zero on a successful receive, or an error. The receive state in
  * the TCP_Server_Info will also be updated.
  */
-typedef int (mid_receive_t)(struct TCP_Server_Info *server,
+typedef int (*mid_receive_t)(struct TCP_Server_Info *server,
 			    struct mid_q_entry *mid);
 
 /*
@@ -1630,13 +1630,13 @@ typedef int (mid_receive_t)(struct TCP_S
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
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -96,10 +96,10 @@ extern int cifs_ipaddr_cmp(struct sockad
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
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -792,8 +792,8 @@ cifs_setup_async_request(struct TCP_Serv
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


