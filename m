Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795665936;
	b=VxGD2uVQ7pIFQEBCfrh1PXFQFSYfN8fWYCHfEUcMFPjwnQ8vlwFJBrEBl609qdrrII3a
	 bH+Dbzi7dW7zwWStTPGhONb2geDn5G0w8i50uMm8DZWXDf3PpTTaGxBPaXhCClTK8yrjl
	 vg5fz+nl0uobiT4+YVXkdZ3B3eAa+S7nQ7z8iOjkKsFN8Z8I/uYujFylEhYnJjoBCNyby
	 2CC9zJ+mG+Kyoqn+jV9f6vJSYysI8Bwpl10YmqE+EO4VEMsAYSElr3zHIrPojpHW63lyY
	 d/sZUaz1UhyXZAgRpfxpZ0nxhLErW3aQSV/x2GgIAgkqah7X1PgrpQM8DGjLGk71b5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795665936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=cvQCaI6DLp3nrfq1EAHHKdvVYhrCqljBmhBLwjVMnwk=;
	b=d4zmLqVLVkCFPbB2q5gBXham4uJIas4uGyg1x5upK2nOQY4N5FMF9RmeYb4t/4fr9Zai
	 azW3Bj91zywTPauq2VhdX1bOVSoLZrkplsE321Th/+TfEyRfyWoytjdiDz+Z6r5nGxIdM
	 nU+kZ2kd5uclfsgomx7L0qqMqrIoOrvNX31UTaF1hQ49Qe1Sz9ktfWnNF9unXBIYxcvcq
	 QSb6qJ39DU1Ea9CYoN50VMVIHpMhzBOrk46jFjixeHm94SAidCoL6D274kjDygdUSETTE
	 SN57P2KUCcLb5I0w8wll0RKf2CrDDNPx6AcF1u0/cfhedv5W2aSFntBha2h+bP+W39g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E6jePzmX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A20606A326;
	Thu, 26 Nov 2026 04:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E6jePzmX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A151F000C0;
	Thu, 26 Nov 2026 04:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795665936;
	bh=cvQCaI6DLp3nrfq1EAHHKdvVYhrCqljBmhBLwjVMnwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6jePzmXab5lSP+CINNeOFAMmcdN5ckgsrLuaLlwhkwJcGNHpWaMNCfT+GO5tYRtZ
	 DB4kvnTVF4E9PviQLxxpqAvhhLVoqgcFtSQyuMWRJojpsJJCktvGTRJH8V6xYOwgiF
	 KNjO1ZqcZ68Ke01QHcbD+T2RHO23nWfA4eZXM79uXwFW0EJrLHLRi5qStINbZabgng
	 2mMsvDwAjpvImGhvox4KKRq0cCvHedjnlNqtdNIobkN0bkmfgEb88unGdZ/Jg/sQ4D
	 lqpccI84stSHcQL1cQiM/LS32TNsr/4Em1grWFXw5RfcaVCWjqZC57RhNVoHWTr/ug
	 ECmqZnjZBQTlQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Pierguido Lambri <plambri@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18.y 1/2] smb: client: relax session and tcon reconnect attempts
Date: Wed, 25 Nov 2026 23:05:33 -0500
Message-ID: <20261126040504.1872414-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026112544-groin-automatic-abac@gregkh>
References: <2026112544-groin-automatic-abac@gregkh>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 855982a52ff7d188188f0ecf86c2ce95957202c6 ]

When the client re-establishes connection to the server, it will queue
a worker thread that will attempt to reconnect sessions and tcons on
every two seconds, which is kinda overkill as it is a very common
scenario when having expired passwords or KRB5 TGT tickets, or deleted
shares.

Use an exponential backoff strategy to handle session/tcon reconnect
attempts in the worker thread to prevent the client from overloading
the system when it is very unlikely to re-establish any session/tcon
soon while client is idle.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Pierguido Lambri <plambri@redhat.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: f02d249e9756 ("smb: client: hold server ref while queueing reconnect work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h | 21 +++++++++++++++++++++
 fs/smb/client/connect.c  |  4 ++--
 fs/smb/client/smb2pdu.c  |  6 +++---
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index ea6533d057acf..68d664e3415ee 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -747,6 +747,7 @@ struct TCP_Server_Info {
 	struct session_key session_key;
 	unsigned long lstrp; /* when we got last response from this server */
 	unsigned long neg_start; /* when negotiate started (jiffies) */
+	unsigned long reconn_delay; /* when resched session and tcon reconnect */
 	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
 #define	CIFS_NEGFLAVOR_UNENCAP	1	/* wct == 17, but no ext_sec */
 #define	CIFS_NEGFLAVOR_EXTENDED	2	/* wct == 17, ext_sec bit set */
@@ -2398,4 +2399,24 @@ struct cifs_calc_sig_ctx {
 	struct shash_desc *shash;
 };
 
+#define CIFS_RECONN_DELAY_SECS	30
+#define CIFS_MAX_RECONN_DELAY	(4 * CIFS_RECONN_DELAY_SECS)
+
+static inline void cifs_queue_server_reconn(struct TCP_Server_Info *server)
+{
+	if (!delayed_work_pending(&server->reconnect)) {
+		WRITE_ONCE(server->reconn_delay, 0);
+		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+	}
+}
+
+static inline void cifs_requeue_server_reconn(struct TCP_Server_Info *server)
+{
+	unsigned long delay = READ_ONCE(server->reconn_delay);
+
+	delay = umin(delay + CIFS_RECONN_DELAY_SECS, CIFS_MAX_RECONN_DELAY);
+	WRITE_ONCE(server->reconn_delay, delay);
+	queue_delayed_work(cifsiod_wq, &server->reconnect, delay * HZ);
+}
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 4864fe6b19e30..caad568c6daed 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -431,7 +431,7 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 			spin_unlock(&server->srv_lock);
 			cifs_swn_reset_server_dstaddr(server);
 			cifs_server_unlock(server);
-			mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+			cifs_queue_server_reconn(server);
 		}
 	} while (server->tcpStatus == CifsNeedReconnect);
 
@@ -570,7 +570,7 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 		spin_unlock(&server->srv_lock);
 		cifs_swn_reset_server_dstaddr(server);
 		cifs_server_unlock(server);
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		cifs_queue_server_reconn(server);
 	} while (server->tcpStatus == CifsNeedReconnect);
 
 	dfs_cache_noreq_update_tgthint(ref_path, target_hint);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 7b95493b94642..01e582967df47 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -464,7 +464,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_unlock(&ses->ses_lock);
 
 	if (smb2_command != SMB2_INTERNAL_CMD)
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		cifs_queue_server_reconn(server);
 
 	atomic_inc(&tconInfoReconnectCount);
 out:
@@ -4342,7 +4342,7 @@ void smb2_reconnect_server(struct work_struct *work)
 done:
 	cifs_dbg(FYI, "Reconnecting tcons and channels finished\n");
 	if (resched)
-		queue_delayed_work(cifsiod_wq, &server->reconnect, 2 * HZ);
+		cifs_requeue_server_reconn(server);
 	mutex_unlock(&pserver->reconnect_mutex);
 
 	/* now we can safely release srv struct */
@@ -4366,7 +4366,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 	    server->ops->need_neg(server)) {
 		spin_unlock(&server->srv_lock);
 		/* No need to send echo on newly established connections */
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		cifs_queue_server_reconn(server);
 		return rc;
 	}
 	spin_unlock(&server->srv_lock);
-- 
2.53.0

