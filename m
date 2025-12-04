Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9918536C5A0
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 18:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764871596; cv=none; b=YgTleBGTc2EdzwvX0YkdDsZIa1D9xsPzuf7Tor7qKKrWobpMfy2LfKzzdDmMAbPOE1sJaewt9pqbz28n/A2iXkrQLpi4wvBo0ngdx8H/Pp4cRb5h1u9+ZR5LK5NUxRsiVRlVD5lNO4cIqO7oSlmN/u4PCEc/ErzWUNa+XV4gJko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764871596; c=relaxed/simple;
	bh=oGGsZ0VBKAMKbSnky2yeeEFMDeaaL9dNDgOC0OThVZw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=noDL6QkdncmD5LrFZGalZJ2eMLaYbSWptd5bi7xIyphcJGUYTPKiUlkm+FHl8QjrThFcCQgu7ZrsutYJCsVSFAMUavQa+9Hi7O/kXTnwVpI7nuFjDh405SA7zj7LfkhOx0bSjBK4zSy5COwZxYaee73BU2L0jRSjd7evr/7QGuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=cx/F7eRA; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="cx/F7eRA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=mf1soghjnKrBnk+Bcbsoqz37jKyxwDBSYzxvQff/Fq0=; b=cx/F7eRAfwfItxEsW4iJxsK8db
	cBI8kINtFICeyVHZTQZ3gIn6INvl4FBsDQQ03CXmOTAWEmiUmfZwdiYd84S4s/lLEw7U3we+a4uwR
	yGAsx5v7kB/9XRjYfmTfEbSc+iiFOjZvB4OeCqHxz8hlli7FOsxpF4CGb7VAUEJ8hhPzrtAKt14Wo
	zixBJR24M1UncnQio4rDAk894TvBL4zvEycCSvQGzZNonfhyktKz1s+j40N7lupDd5YYW5ndaDt2c
	i5Uilg1yFfRqsEjNsIxtOM2nxatVHT2gSY8ZtLHDUbT/ZNbVHQvh7ieTXi2K0D5lftDwBnRzwj6G8
	B+kG7zrw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99)
	id 1vRDik-00000000Dfg-0ZsS;
	Thu, 04 Dec 2025 15:06:26 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Pierguido Lambri <plambri@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 1/3] smb: client: relax session and tcon reconnect attempts
Date: Thu,  4 Dec 2025 15:06:23 -0300
Message-ID: <20251204180626.244415-1-pc@manguebit.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 fs/smb/client/cifsglob.h | 21 +++++++++++++++++++++
 fs/smb/client/connect.c  |  4 ++--
 fs/smb/client/smb2pdu.c  |  6 +++---
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index f9c1f553ffd0..3eca5bfb7030 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -745,6 +745,7 @@ struct TCP_Server_Info {
 	struct session_key session_key;
 	unsigned long lstrp; /* when we got last response from this server */
 	unsigned long neg_start; /* when negotiate started (jiffies) */
+	unsigned long reconn_delay; /* when resched session and tcon reconnect */
 	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
 #define	CIFS_NEGFLAVOR_UNENCAP	1	/* wct == 17, but no ext_sec */
 #define	CIFS_NEGFLAVOR_EXTENDED	2	/* wct == 17, ext_sec bit set */
@@ -2292,4 +2293,24 @@ struct cifs_calc_sig_ctx {
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
index b306ee97a20a..3838dd14d4da 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -425,7 +425,7 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 			spin_unlock(&server->srv_lock);
 			cifs_swn_reset_server_dstaddr(server);
 			cifs_server_unlock(server);
-			mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+			cifs_queue_server_reconn(server);
 		}
 	} while (server->tcpStatus == CifsNeedReconnect);
 
@@ -564,7 +564,7 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 		spin_unlock(&server->srv_lock);
 		cifs_swn_reset_server_dstaddr(server);
 		cifs_server_unlock(server);
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		cifs_queue_server_reconn(server);
 	} while (server->tcpStatus == CifsNeedReconnect);
 
 	dfs_cache_noreq_update_tgthint(ref_path, target_hint);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e26d29d75f9f..0d2940808be6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -493,7 +493,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_unlock(&ses->ses_lock);
 
 	if (smb2_command != SMB2_INTERNAL_CMD)
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		cifs_queue_server_reconn(server);
 
 	atomic_inc(&tconInfoReconnectCount);
 out:
@@ -4312,7 +4312,7 @@ void smb2_reconnect_server(struct work_struct *work)
 done:
 	cifs_dbg(FYI, "Reconnecting tcons and channels finished\n");
 	if (resched)
-		queue_delayed_work(cifsiod_wq, &server->reconnect, 2 * HZ);
+		cifs_requeue_server_reconn(server);
 	mutex_unlock(&pserver->reconnect_mutex);
 
 	/* now we can safely release srv struct */
@@ -4336,7 +4336,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 	    server->ops->need_neg(server)) {
 		spin_unlock(&server->srv_lock);
 		/* No need to send echo on newly established connections */
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		cifs_queue_server_reconn(server);
 		return rc;
 	}
 	spin_unlock(&server->srv_lock);
-- 
2.52.0

