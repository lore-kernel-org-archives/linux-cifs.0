Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA2E480DD2
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 18:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791226065; cv=none; b=Bb75pmS0UAl+eQ46Ec7U4GCzzLHKUBI5WEKuDOMM/A6/eY8eHk6AOZZW/4kG/IAPNzpZAhVdPLJW5CVAtIYHtRjGrrV2gGmXUQx3zSwMuygSwjDKqhzzaOMY+gdjMfEy9EGXmRpaXy6MrP3BE+E2Y9g59j9+2zyRZIYqZ2ZkPs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791226065; c=relaxed/simple;
	bh=dRwphR3Cq9wD0IXl6UAH4ifJA9Sxu/cvbt/kuRtbr1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8xC+SgcOXIi8Vc+eWLSKlRVXVcuxC/wBzbARq5cgBMWjYqjsyfYNbcEvxCtB26tbPofhjfxQuG9pdFWI+rHkH+40hxpzCCWRD8PRWGaS2e0syxd3cn/t2+HkFIVHpqbAvvzLURfD15QB/VdDF7GoT0xyjpB7cKEeGlD7pgmS3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=HG+KofDR; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="HG+KofDR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=cguMAxo41hQAswKQToUirDlXVuUuWTyiYxcwc6FcacI=; b=HG+KofDRdQlXzMzl+UP9WPDgYP
	YVefeBMe+95kygNFRmh4SjnFCtJ4JDHHXp4G0xDILh1Hi4ZvGG1kFxkhlRZ8PxOdwW1fZLnxagKAv
	UYq1gVLRkyjtf+R3Z1A80VZIBsC5zPU1RgVmuvijED+uOB0Krf8hz9QURCj5VQFMRUKTtNgaSs64y
	CCw76fkuMIdlvhRHeCsdLz7Xm5xfheA20ncdOqc/gEFzG5aX8ZsaW5oyc5dgeLOiEGgBmxHzun696
	fzZMErBQVEMhjCj+Encu1gELi6EyxvYOgz/1+XeyQVvzWqnZHTkJDEise8Wl4OYEZcZKjCF6tuAvn
	OPLvtivi935B3hm2pVnOROAz+F9jTdG9x/3yDwY6gVGzcmo7doS7mr4Qdycg8KH7AAiS1EMHO0ZTn
	1ruTgk+M1kU096j8YFjLl6u+aUomNiTdNar6lfA8Tpfwha86XR/gyFsTsFUnJx7ggSk7rJpzZIIvx
	N52aU6ggK6K6HzTxJ5AnBn3F;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDniu-00000005fBR-2irP;
	Mon, 05 Oct 2026 18:47:40 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 5/5] smb: client: don't use server->smbd_conn without a reference or lock
Date: Mon,  5 Oct 2026 20:47:00 +0200
Message-ID: <a59684df49588a2b6411421e8099fe6ae76279de.1791225453.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791225453.git.metze@samba.org>
References: <cover.1791225453.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smbd_get_parameters(), smbd_register_mr() and smbd_debug_proc_show()
used server->smbd_conn without any locking, while
cifs_abort_connection() can destroy it via smbd_destroy() at any
time, which frees the smbd_connection and releases the smbdirect
socket.

smbd_register_mr() now uses the new smbd_get_socket() and
smbd_put_socket(), which take and drop a reference on the socket of
server->smbd_conn under server->srv_lock via smbdirect_socket_get()
and smbdirect_socket_put(). Once the connection is destroyed, the
socket is no longer connected, so
smbdirect_connection_register_mr_io() fails gracefully. A registered
mr has its own reference counting.

smbd_debug_proc_show() is called with cifs_tcp_ses_lock held, so it
holds server->srv_lock instead, which prevents server->smbd_conn from
being destroyed.

smbd_get_parameters() returned a pointer into the socket, which can't
be kept valid for the callers. Now it copies the parameters into the
new server->smbd_params under server->srv_lock and returns a pointer
to that. If there's no connection (anymore), server->smbd_params is
set to zeros. This also fixes a possible NULL pointer dereference in
smb2_negotiate_wsize() and smb2_negotiate_rsize(), which called
smbd_get_parameters(server->smbd_conn) without checking
server->smbd_conn, e.g. during a reconnect.

smbd_send() is called under cifs_server_lock(), so it uses
smbdirect_socket_get_current_parameters() directly.

Fixes: b8aef8c8808c ("smb: client: make use of smbdirect_socket_create_kern()/smbdirect_socket_release()")
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifsglob.h  | 12 +++++
 fs/smb/client/smbdirect.c | 94 +++++++++++++++++++++++++++++++++------
 2 files changed, 93 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 79e4e84f8985..c3efbc3d1f2a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -30,6 +30,9 @@
 #include "smb2pdu.h"
 #include "smb1pdu.h"
 #include <linux/filelock.h>
+#ifdef CONFIG_CIFS_SMB_DIRECT
+#include <linux/smbdirect.h>
+#endif
 
 #define SMB_PATH_MAX 260
 #define CIFS_PORT 445
@@ -761,6 +764,15 @@ struct TCP_Server_Info {
 	bool	rdma;
 	/* point to the SMBD connection if RDMA is used instead of socket */
 	struct smbd_connection *smbd_conn;
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	/*
+	 * A copy of the current smbdirect socket parameters,
+	 * updated by smbd_get_parameters(). smbd_conn and
+	 * its socket can be destroyed at any time, so callers
+	 * can't get a pointer into it.
+	 */
+	struct smbdirect_socket_parameters smbd_params;
+#endif
 	struct delayed_work	echo; /* echo ping workqueue job */
 	char	*smallbuf;	/* pointer to current "small" buffer */
 	char	*bigbuf;	/* pointer to current "big" buffer */
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 942763789335..e59bf9a48ea0 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -361,17 +361,61 @@ static struct smbd_connection *_smbd_get_connection(
 	return NULL;
 }
 
-const struct smbdirect_socket_parameters *smbd_get_parameters(struct TCP_Server_Info *server)
+/*
+ * server->smbd_conn can be destroyed by cifs_abort_connection()
+ * at any time, so we take a reference on its socket while we use
+ * it. server->smbd_conn is changed under server->srv_lock,
+ * see smbd_set_connection() and smbd_destroy().
+ *
+ * Once the connection is destroyed, the socket is no longer
+ * connected, so the smbdirect functions fail gracefully.
+ *
+ * smbd_put_socket() may free the socket, so this
+ * can only be used in process context.
+ */
+static struct smbdirect_socket *smbd_get_socket(struct TCP_Server_Info *server)
 {
-	struct smbd_connection *conn = server->smbd_conn;
+	struct smbdirect_socket *sc = NULL;
 
-	if (unlikely(!conn->socket)) {
-		static const struct smbdirect_socket_parameters zero_params;
-
-		return &zero_params;
+	spin_lock(&server->srv_lock);
+	if (server->smbd_conn && server->smbd_conn->socket) {
+		sc = server->smbd_conn->socket;
+		smbdirect_socket_get(sc);
 	}
+	spin_unlock(&server->srv_lock);
 
-	return smbdirect_socket_get_current_parameters(conn->socket);
+	return sc;
+}
+
+static void smbd_put_socket(struct smbdirect_socket *sc)
+{
+	if (sc)
+		smbdirect_socket_put(sc);
+}
+
+/*
+ * We can't return a pointer into the socket, as it may
+ * be destroyed at any time, so we copy the parameters
+ * into server->smbd_params and return a pointer to that.
+ *
+ * The copy is done under server->srv_lock, which also
+ * prevents server->smbd_conn from being destroyed,
+ * see smbd_destroy().
+ *
+ * If there's no connection (anymore), we fill server->smbd_params
+ * with zeros.
+ */
+const struct smbdirect_socket_parameters *smbd_get_parameters(struct TCP_Server_Info *server)
+{
+	spin_lock(&server->srv_lock);
+	if (server->smbd_conn && server->smbd_conn->socket)
+		server->smbd_params =
+			*smbdirect_socket_get_current_parameters(server->smbd_conn->socket);
+	else
+		memset(&server->smbd_params, 0, sizeof(server->smbd_params));
+	spin_unlock(&server->srv_lock);
+
+	return &server->smbd_params;
 }
 
 struct smbd_connection *smbd_get_connection(
@@ -392,6 +436,9 @@ struct smbd_connection *smbd_get_connection(
 	if (!ret)
 		return NULL;
 
+	/*
+	 * ret is not published in server->smbd_conn yet
+	 */
 	sp = smbdirect_socket_get_current_parameters(ret->socket);
 
 	server->rdma_readwrite_threshold =
@@ -437,7 +484,13 @@ int smbd_send(struct TCP_Server_Info *server,
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc = info->socket;
-	const struct smbdirect_socket_parameters *sp = smbd_get_parameters(server);
+	/*
+	 * We're called under cifs_server_lock(), so
+	 * server->smbd_conn can't be destroyed while
+	 * we use it.
+	 */
+	const struct smbdirect_socket_parameters *sp =
+		smbdirect_socket_get_current_parameters(sc);
 	struct smb_rqst *rqst;
 	struct iov_iter iter;
 	struct smbdirect_send_batch_storage bstorage;
@@ -541,13 +594,19 @@ struct smbdirect_mr_io *smbd_register_mr(struct TCP_Server_Info *server,
 				 struct iov_iter *iter,
 				 bool writing, bool need_invalidate)
 {
-	struct smbd_connection *info = server->smbd_conn;
-	struct smbdirect_socket *sc = info->socket;
+	struct smbdirect_socket *sc = smbd_get_socket(server);
+	struct smbdirect_mr_io *mr = NULL;
 
-	if (!smbdirect_connection_is_connected(sc))
-		return NULL;
+	/*
+	 * The mr has its own reference counting
+	 * and doesn't need the socket reference
+	 * once registered.
+	 */
+	if (sc && smbdirect_connection_is_connected(sc))
+		mr = smbdirect_connection_register_mr_io(sc, iter, writing, need_invalidate);
+	smbd_put_socket(sc);
 
-	return smbdirect_connection_register_mr_io(sc, iter, writing, need_invalidate);
+	return mr;
 }
 
 void smbd_mr_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
@@ -572,7 +631,15 @@ void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m)
 	if (!server->rdma)
 		return;
 
+	/*
+	 * We're called with cifs_tcp_ses_lock held, so we
+	 * can't use smbd_get_socket(), but holding
+	 * server->srv_lock prevents server->smbd_conn
+	 * from being destroyed, see smbd_destroy().
+	 */
+	spin_lock(&server->srv_lock);
 	if (!server->smbd_conn) {
+		spin_unlock(&server->srv_lock);
 		seq_puts(m, "\nSMBDirect transport not available");
 		return;
 	}
@@ -580,6 +647,7 @@ void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m)
 	smbdirect_connection_legacy_debug_proc_show(server->smbd_conn->socket,
 						    server->rdma_readwrite_threshold,
 						    m);
+	spin_unlock(&server->srv_lock);
 }
 
 MODULE_IMPORT_NS("SMBDIRECT");
-- 
2.43.0

