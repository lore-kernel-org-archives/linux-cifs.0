Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050DC28F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155917; cv=none; b=hlSAcMg5dVhpPzqeQ54J7c7EPcuy3hyYyqeEb/cLOxRw9mW3LD/2moaglhUfkwkwUo7LMlIc2aJYYQ0gcRiQCWtW/42IlawMXPLkEuInkFDOa5tjomGpuAD+bj2zASVFmMZvajY0ZV3vzG2PJxPA/vY2TVN3uNehzMEiZcwZZGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155917; c=relaxed/simple;
	bh=kBBg76IbZJlkj33SiwVeEYAQno+OTYuzQIkKqyks+Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka8CYe7WhFkCRSxeJU+2HWpLLK2KrpRiY1sPytCEOsmrxNMbLQFYFLXzwEJbNXR2anegvbgRnSp6Kn7NGy+vUnpQQrPhFQjAu32Piol4ZtXPVcbKCt+s7nP1HuoY63cHMiyBPFodii38FzapaAeSguEe5vE09PTZ6rhlAGlQ1P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=O0hNVgu0; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="O0hNVgu0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ZvZ9nYGC0Z7vo2Ez/qv/mhp8FFPaQPquVU1UHY94L4c=; b=O0hNVgu0sobCpeM0ShLVrAHHic
	x85D1nbTy+yGMIui+n/MuAnlMfs9YYiqwpP+LqhocwTWj8QX+nf4WFBDG6xxWeVJ2hHsb2y2ExEDd
	FfembwCvP6aWMYjvfVt4IUCfSdbh4bfNQGUUwft8a+0BTAqgbZjNXdMFVCGLtj6BZ1bvsnCB7dTlP
	8pgymlS6pVgBZCY4l3jn8tA/3/8/LSMsEdAhuc7aO+EuYzoS1TGGYYJ/Hzgr5tXcpsZA+MBmkVcRP
	8iuEDO0lye764uhRG1SjPQZXB7nkd+EvIoP9IwT33j+wT/y4WpvMb54bYLr4IfqLq2gVF+mzU8HNL
	YKDMzIF/69sAq95GLFWJwhYI1KZYgqT/80Vg2/WLM866IQMEr3sqXQ8FyJWsWdlPzYo58cbYASEqQ
	etWFJRP7L2ODj11Ja8LBjLCYnim4yhunLBzBaO/QDexjEiIl6Vsi1s1a3LTvJD1pQzXv3fGbzsHI3
	m2CdQAcQZFFC7xwHvhWFENEN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeNK-000ntB-1Z;
	Mon, 25 Aug 2025 21:05:10 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 140/142] smb: server: pass struct smbdirect_socket to smb_direct_post_send_data()
Date: Mon, 25 Aug 2025 22:41:41 +0200
Message-ID: <d7ee120110dbd9a2830808babdb2468299f0ed54.1756139608.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to move function to the common code
in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 289325640a04..7f7c31326226 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -135,7 +135,7 @@ static inline int get_buf_page_count(void *buf, int size)
 
 static void smb_direct_destroy_pools(struct smbdirect_socket *sc);
 static void smb_direct_post_recv_credits(struct work_struct *work);
-static int smb_direct_post_send_data(struct smb_direct_transport *t,
+static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 				     struct smbdirect_send_batch *send_ctx,
 				     struct kvec *iov, int niov,
 				     int remaining_data_length);
@@ -269,13 +269,11 @@ static void smb_direct_send_immediate_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, idle.immediate_work);
-	struct smb_direct_transport *t =
-		container_of(sc, struct smb_direct_transport, socket);
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return;
 
-	smb_direct_post_send_data(t, NULL, NULL, 0, 0);
+	smb_direct_post_send_data(sc, NULL, NULL, 0, 0);
 }
 
 static void smb_direct_idle_connection_timer(struct work_struct *work)
@@ -1142,12 +1140,11 @@ static int post_sendmsg(struct smbdirect_socket *sc,
 	return smb_direct_post_send(sc, &msg->wr);
 }
 
-static int smb_direct_post_send_data(struct smb_direct_transport *t,
+static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 				     struct smbdirect_send_batch *send_ctx,
 				     struct kvec *iov, int niov,
 				     int remaining_data_length)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	int i, j, ret;
 	struct smbdirect_send_io *msg;
 	int data_length;
@@ -1241,7 +1238,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 			if (i > start) {
 				remaining_data_length -=
 					(buflen - iov[i].iov_len);
-				ret = smb_direct_post_send_data(st, &send_ctx,
+				ret = smb_direct_post_send_data(sc, &send_ctx,
 								&iov[start], i - start,
 								remaining_data_length);
 				if (ret)
@@ -1259,7 +1256,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 						min_t(int, max_iov_size,
 						      buflen - max_iov_size * j);
 					remaining_data_length -= vec.iov_len;
-					ret = smb_direct_post_send_data(st, &send_ctx, &vec, 1,
+					ret = smb_direct_post_send_data(sc, &send_ctx, &vec, 1,
 									remaining_data_length);
 					if (ret)
 						goto done;
@@ -1275,7 +1272,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 			if (i == niovs) {
 				/* send out all remaining vecs */
 				remaining_data_length -= buflen;
-				ret = smb_direct_post_send_data(st, &send_ctx,
+				ret = smb_direct_post_send_data(sc, &send_ctx,
 								&iov[start], i - start,
 								remaining_data_length);
 				if (ret)
-- 
2.43.0

