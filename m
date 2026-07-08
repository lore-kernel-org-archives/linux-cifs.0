Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3791F1932
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 02:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783479412; cv=none; b=rpesbshXQj1SX/jaD5WQmK+RlW8aChg+AuDHowlJxpl2F/1QTN6FVbQwACv0MWEI6z1r9/4SU1Xwz3sltS6smh6WZsV0S9/Y98JHiUYQLcSTcwGue46FW7wBxSlu8pXV/EWaiQGwajTky6hc3sAODDaKBHso2rLeaU95e05abkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783479412; c=relaxed/simple;
	bh=CNIukMpdTiNLSTiMXhB3A6zW8Z9imnOMb3ke4GZKv3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gal0cOrB9HUbU5ESknjDynd3Hj5uXTOWUtu1ohTsvy6EUlwFU8SSh1jPfazKqy0sZJS/wWmNVAk3PExuivFlgtK93HV6CovIE4kYJmgOJYMOhU5SHAP6ejjVx6AdFqKON9edJqpxeNWG5U/XKGIHsehJLmY7Z6+eCJo2Eue5LVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=fYODPGv8; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="fYODPGv8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783479406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6AqPxQ77GdGUucieCCzehT4pPvbtClam9tGtyspQ3TQ=;
	b=fYODPGv8es/ZuZIMtEhku7RCWMKtE14ISri7K6RZg+EsdR3oPsoN8kwxuTke/jvL4ofvW1
	v530CaY83VfmnkcxzDpoyx8TjAWB79af+QlgFqDKEwI2gOMDXO2OMqg37uSy/rLN04BeLr
	7rff6IA+dhpQhijYsl0j1Bltj6y4eq2Myx5b2jGxcZhkekFkpuH6yevxQpifJKn6GZvYWg
	ETbeGGbk2oysmxsRgEbhUGlq2dWteXjK8p7iMs4LHV4NeC4EmH8DBQyr1DiTu2uejZzzk4
	NHM0hMRCO1/KJZ1TTlTWCrSF1IE+bijD0LGREMb7hgG9IVtorZvrUEyVuLaPxA==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 2/3] smb/server: introduce struct ksmbd_transport_write
Date: Wed,  8 Jul 2026 02:56:14 +0000
Message-ID: <20260708025615.145390-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260708025615.145390-1-chenxiaosong@chenxiaosong.com>
References: <20260708025615.145390-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Put the arguments of ksmbd_transport_ops ->writev() into a struct. This makes the
function call shorter and easier to read.

Add __ksmbd_conn_write() for the common write code. A later patch will use
it for another write helper.

No functional change.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/connection.c     | 22 ++++++++++++++++------
 fs/smb/server/connection.h     | 13 ++++++++++---
 fs/smb/server/transport_rdma.c |  9 +++++----
 fs/smb/server/transport_tcp.c  | 13 +++++++------
 4 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index dee8e4aced99..d5b35087556e 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -350,7 +350,8 @@ int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id)
 	return 0;
 }
 
-int ksmbd_conn_write(struct ksmbd_work *work)
+static int __ksmbd_conn_write(struct ksmbd_work *work,
+			      struct ksmbd_transport_write *write)
 {
 	struct ksmbd_conn *conn = work->conn;
 	int sent;
@@ -366,12 +367,14 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 	if (!work->iov_idx)
 		return -EINVAL;
 
+	write->iov = work->iov;
+	write->iov_cnt = work->iov_cnt;
+	write->size = get_rfc1002_len(work->iov[0].iov_base) + 4;
+	write->need_invalidate_rkey = work->need_invalidate_rkey;
+	write->remote_key = work->remote_key;
+
 	ksmbd_conn_lock(conn);
-	sent = conn->transport->ops->writev(conn->transport, work->iov,
-			work->iov_cnt,
-			get_rfc1002_len(work->iov[0].iov_base) + 4,
-			work->need_invalidate_rkey,
-			work->remote_key);
+	sent = conn->transport->ops->writev(conn->transport, write);
 	ksmbd_conn_unlock(conn);
 
 	if (sent < 0) {
@@ -382,6 +385,13 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 	return 0;
 }
 
+int ksmbd_conn_write(struct ksmbd_work *work)
+{
+	struct ksmbd_transport_write write = {};
+
+	return __ksmbd_conn_write(work, &write);
+}
+
 int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
 			 void *buf, unsigned int buflen,
 			 struct smbdirect_buffer_descriptor_v1 *desc,
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index ec75633b7da0..62df151ca554 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -132,14 +132,21 @@ struct ksmbd_conn_ops {
 	int	(*terminate_fn)(struct ksmbd_conn *conn);
 };
 
+struct ksmbd_transport_write {
+	struct kvec	*iov;
+	int		iov_cnt;
+	int		size;
+	bool		need_invalidate_rkey;
+	unsigned int	remote_key;
+};
+
 struct ksmbd_transport_ops {
 	void (*disconnect)(struct ksmbd_transport *t);
 	void (*shutdown)(struct ksmbd_transport *t);
 	int (*read)(struct ksmbd_transport *t, char *buf,
 		    unsigned int size, int max_retries);
-	int (*writev)(struct ksmbd_transport *t, struct kvec *iovs, int niov,
-		      int size, bool need_invalidate_rkey,
-		      unsigned int remote_key);
+	int (*writev)(struct ksmbd_transport *t,
+		      const struct ksmbd_transport_write *write);
 	int (*rdma_read)(struct ksmbd_transport *t,
 			 void *buf, unsigned int len,
 			 struct smbdirect_buffer_descriptor_v1 *desc,
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index b6d63ff8a8a3..b2a882421823 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -239,17 +239,18 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 }
 
 static int smb_direct_writev(struct ksmbd_transport *t,
-			     struct kvec *iov, int niovs, int buflen,
-			     bool need_invalidate, unsigned int remote_key)
+			     const struct ksmbd_transport_write *write)
 {
 	struct smb_direct_transport *st = SMBD_TRANS(t);
 	struct smbdirect_socket *sc = st->socket;
 	struct iov_iter iter;
 
-	iov_iter_kvec(&iter, ITER_SOURCE, iov, niovs, buflen);
+	iov_iter_kvec(&iter, ITER_SOURCE, write->iov, write->iov_cnt,
+		      write->size);
 
 	return smbdirect_connection_send_iter(sc, &iter, 0,
-					      need_invalidate, remote_key);
+					      write->need_invalidate_rkey,
+					      write->remote_key);
 }
 
 static int smb_direct_rdma_write(struct ksmbd_transport *t,
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 13b711ea575d..448f24d44b6b 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -417,14 +417,15 @@ static int ksmbd_tcp_read(struct ksmbd_transport *t, char *buf,
 	return ksmbd_tcp_readv(TCP_TRANS(t), &iov, 1, to_read, max_retries);
 }
 
-static int ksmbd_tcp_writev(struct ksmbd_transport *t, struct kvec *iov,
-			    int nvecs, int size, bool need_invalidate,
-			    unsigned int remote_key)
-
+static int ksmbd_tcp_writev(struct ksmbd_transport *t,
+			    const struct ksmbd_transport_write *write)
 {
-	struct msghdr smb_msg = {.msg_flags = MSG_NOSIGNAL};
+	struct msghdr smb_msg = {
+		.msg_flags = MSG_NOSIGNAL,
+	};
 
-	return kernel_sendmsg(TCP_TRANS(t)->sock, &smb_msg, iov, nvecs, size);
+	return kernel_sendmsg(TCP_TRANS(t)->sock, &smb_msg, write->iov,
+			      write->iov_cnt, write->size);
 }
 
 static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
-- 
2.54.0

