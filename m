Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A93C34164F;
	Tue, 26 Aug 2025 13:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215149; cv=none; b=go69KQI97ng0U/prQV5KfYZtGWRS9YZ+OJsYgzx/08emnt9dfN88n2e5gZo3sDGS6kPQSeBVr3d6DZfe8Cx0VhYI5KNf5cWc8EVXXwfU898Uxiy7y4m52JpHMfBDS63MptRlwpRKVba431q1a30eu+R3hycdTrjIe+2KC5KXR8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215149; c=relaxed/simple;
	bh=B85FnzwlsKW4OQyMgU5haPlcbhzak0Xr80UdtwWKDZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFlgn0rLUxegpNonC5+b/LglbRlog8BiVIYbAfYS+8gNFK4KVQkCrOt8/QcVHT7nd5CFHxLIMIGQmnNjmCXUMGb0JraZ0X1xHRtLNa0x7JfN2HkpJLIJZDH8WjAh/BoxkhXHHAZQsJubkzRcvv34qsL/mnt0CfAxAyi5mODYRb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzDcjFN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzDcjFN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D270DC4CEF1;
	Tue, 26 Aug 2025 13:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215149;
	bh=B85FnzwlsKW4OQyMgU5haPlcbhzak0Xr80UdtwWKDZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzDcjFN0YkbyfhpY7jKR2SMhDFEYbZojQxTwjTCh9Mjh6ohdiLT52Zgu03iwS2oYx
	 IRyMXuaYBoCJS8DhNsnhVto8/jqQcQarSfHqFQxaR34bjYqsywtfiRnxSgRnGHmaLh
	 WIW9xSbfs83KtuKQlZScLKw4ZlNm9g46ZUdoUeFo=
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
Subject: [PATCH 6.1 405/482] smb: server: split ksmbd_rdma_stop_listening() out of ksmbd_rdma_destroy()
Date: Tue, 26 Aug 2025 13:10:58 +0200
Message-ID: <20250826110940.834059257@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 09e1e7771592..92d8a0d898eb 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -436,7 +436,8 @@ void ksmbd_conn_transport_destroy(void)
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
index 7d59ed6e1383..3006d76d8059 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2188,7 +2188,7 @@ int ksmbd_rdma_init(void)
 	return 0;
 }
 
-void ksmbd_rdma_destroy(void)
+void ksmbd_rdma_stop_listening(void)
 {
 	if (!smb_direct_listener.cm_id)
 		return;
@@ -2197,7 +2197,10 @@ void ksmbd_rdma_destroy(void)
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



