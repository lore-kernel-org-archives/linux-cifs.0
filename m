Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCFF184540;
	Tue, 26 Aug 2025 13:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213849; cv=none; b=hdy54hBzYg2UlLmXfMUQhhhYl1bc7ANnwooR/PX50uURnbJR5TyXaWp2o74KaiEPGxblzR5vWft1rR48WcYISEzwILy6Apt826cPNDi6wlhn0BbxMFwknHu8kGvwxjk9t5ty+NqzX0cWq5f51SAUkcqgfJ0cNzqjpHWAAFvRchs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213849; c=relaxed/simple;
	bh=KSB1bBsl3O8s6X3B5qGEPwQ0RzvhBjh8pOnewE1D+ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKqZIXw8mFGatjERjEhlujXdepV53YIctU0BIwosPTSSd1tBjg76I2CIupBYhfD3AkJmBuPLBNonCeRuJtrOyyw5EORtxjm3j143mKF2QcwcOQ7jNYW2X6juIVRE1ZFmi6rBf4olvfyhbfkGIMMlt55tlvSrmxo7WS0R+D1Rh5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjCQNYs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjCQNYs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C573C4CEF1;
	Tue, 26 Aug 2025 13:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213848;
	bh=KSB1bBsl3O8s6X3B5qGEPwQ0RzvhBjh8pOnewE1D+ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjCQNYs/3/8MULJyUSkZEu8ZVEDJoavGiXysnpFet2g1H4uztytWXlDdfCYiELt2d
	 YZa12uY7c41WZ/Tq5dnIUxZI4qox1P2AYS+Psu6glD2OTPtODp9uCJ17dY+uQBB1D5
	 bQwAiNx8clooUe1jPe3QBas4AA7IzAJ2UnKlaCM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 502/587] smb: server: split ksmbd_rdma_stop_listening() out of ksmbd_rdma_destroy()
Date: Tue, 26 Aug 2025 13:10:51 +0200
Message-ID: <20250826111005.755074187@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit bac7b996d42e458a94578f4227795a0d4deef6fa ]

We can't call destroy_workqueue(smb_direct_wq); before stop_sessions()!

Otherwise already existing connections try to use smb_direct_wq as
a NULL pointer.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c     | 3 ++-
 fs/smb/server/transport_rdma.c | 5 ++++-
 fs/smb/server/transport_rdma.h | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 66b20c3d963e..f5ebc200dd73 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -503,7 +503,8 @@ void ksmbd_conn_transport_destroy(void)
 {
 	mutex_lock(&init_lock);
 	ksmbd_tcp_destroy();
-	ksmbd_rdma_destroy();
+	ksmbd_rdma_stop_listening();
 	stop_sessions();
+	ksmbd_rdma_destroy();
 	mutex_unlock(&init_lock);
 }
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 6c3a57bff147..a4ff1167c9a1 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2193,7 +2193,7 @@ int ksmbd_rdma_init(void)
 	return 0;
 }
 
-void ksmbd_rdma_destroy(void)
+void ksmbd_rdma_stop_listening(void)
 {
 	if (!smb_direct_listener.cm_id)
 		return;
@@ -2202,7 +2202,10 @@ void ksmbd_rdma_destroy(void)
 	rdma_destroy_id(smb_direct_listener.cm_id);
 
 	smb_direct_listener.cm_id = NULL;
+}
 
+void ksmbd_rdma_destroy(void)
+{
 	if (smb_direct_wq) {
 		destroy_workqueue(smb_direct_wq);
 		smb_direct_wq = NULL;
diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
index 77aee4e5c9dc..a2291b77488a 100644
--- a/fs/smb/server/transport_rdma.h
+++ b/fs/smb/server/transport_rdma.h
@@ -54,13 +54,15 @@ struct smb_direct_data_transfer {
 
 #ifdef CONFIG_SMB_SERVER_SMBDIRECT
 int ksmbd_rdma_init(void);
+void ksmbd_rdma_stop_listening(void);
 void ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
 void init_smbd_max_io_size(unsigned int sz);
 unsigned int get_smbd_max_read_write_size(void);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
-static inline int ksmbd_rdma_destroy(void) { return 0; }
+static inline void ksmbd_rdma_stop_listening(void) { }
+static inline void ksmbd_rdma_destroy(void) { }
 static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) { return false; }
 static inline void init_smbd_max_io_size(unsigned int sz) { }
 static inline unsigned int get_smbd_max_read_write_size(void) { return 0; }
-- 
2.50.1



