Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED25186E2D
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 16:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754671739; cv=none; b=d1xeabh2Q9rc3sLyD/TU/N7oFnOhgXXbM5g14PRBOJUtEI0JMRn+8+JKSKRdi4YNOoytnNpUUgNUnnuDu3uyxpL5raaYdGANhfapqShopecseNF8HqpaF66ARVC+saAHUV710jdXQBf53ZDh9liIB1Ny6JBFvCa1/H5uzPmLZaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754671739; c=relaxed/simple;
	bh=TC2cxJS61b8A+sLkxmnO+m1bToXpf9eb9LRIGNyaFJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tv8t9egk4XLeq8Mp0N4kVrxnCFEWUJcBYuxUWNbUN4zBZGyZHYVl3gLoY0p56iuigucsIBJNTUYrkFNNDnrEFB/WWrYkJ59T+oJLnoCiggbCl/ovJd13cSZopP9Sykpfrs14NK4YObj0UEP4Hf7sjHQNveWyVwJN3P1UGW/EiHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=kGsfk126; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="kGsfk126"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=3MlWgIdLEQfQmaxyqfnyRmrKZkH2WPRIvD5K3EFHb5Y=; b=kGsfk126Y1TdkkM62Q1ONKJgrV
	cKahnKRyYKADh4DzIEi2AkWOJnGfwNMgl/iKMtCPcqwqdy6Eb+mHOBWigT2GbDVz7YfmhzT5vkzUW
	n8wYs6Q12BL3bBrVmCa7XjcYTxMG3a873LsCaAy8HswL/f7jzjKlHbnK0qwJFAia1yyDEVpbs++BD
	ddvY5E1gqpfAlZTiUk0X0by5QAc1cuxHs78N3NcbcMeH2qxrbqmZG333GavVsAMvjky2TDPLDl/0N
	47LaqoSB/I9WqtF8wVGAjsjSTYj9yI6VkS/U/nHdrQHEkk/8L58GRzv5m2gQTaplLzA1F1DJnqNjD
	yJ9NSbF9kDyH55yjzGGouaA+EXiCquTNcO0PxNReOtfDDOKDhq4SSAf8GaJ+Z6Q0zdbvmRjULVW+6
	ZHSdTNECf0YAVQoialXLOOUM3kRGg8k+DWQzKNmqyPCJuw4R49kaMoIPo5bae3ULZaIclnX4r7bmi
	TuDp5RPLBokqR9hsjN59kv1u;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukQH0-001qPV-2C;
	Fri, 08 Aug 2025 16:48:54 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v3 4/9] smb: client: only use a single wait_queue to monitor smbdirect connection status
Date: Fri,  8 Aug 2025 18:48:12 +0200
Message-ID: <bf633821410229f532f1fd9e8ac6e9fae0201851.1754671444.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754671444.git.metze@samba.org>
References: <cover.1754671444.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no need for separate conn_wait and disconn_wait queues.

This will simplify the move to common code, the server code
already a single wait_queue for this.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 17 ++++++++---------
 fs/smb/client/smbdirect.h |  3 +--
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c819cc6dcc4f..c628e91c328b 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -205,7 +205,7 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_ESTABLISHED:
 		log_rdma_event(INFO, "connected event=%s\n", event_name);
 		sc->status = SMBDIRECT_SOCKET_CONNECTED;
-		wake_up_interruptible(&info->conn_wait);
+		wake_up_interruptible(&info->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_CONNECT_ERROR:
@@ -213,7 +213,7 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_REJECTED:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		wake_up_interruptible(&info->conn_wait);
+		wake_up_interruptible(&info->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
@@ -222,12 +222,12 @@ static int smbd_conn_upcall(
 		if (sc->status == SMBDIRECT_SOCKET_NEGOTIATE_FAILED) {
 			log_rdma_event(ERR, "event=%s during negotiation\n", event_name);
 			sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-			wake_up(&info->conn_wait);
+			wake_up(&info->status_wait);
 			break;
 		}
 
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		wake_up_interruptible(&info->disconn_wait);
+		wake_up_interruptible(&info->status_wait);
 		wake_up_interruptible(&sc->recv_io.reassembly.wait_queue);
 		wake_up_interruptible_all(&info->wait_send_queue);
 		break;
@@ -1325,7 +1325,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 		rdma_disconnect(sc->rdma.cm_id);
 		log_rdma_event(INFO, "wait for transport being disconnected\n");
 		wait_event_interruptible(
-			info->disconn_wait,
+			info->status_wait,
 			sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	}
 
@@ -1650,8 +1650,7 @@ static struct smbd_connection *_smbd_get_connection(
 	log_rdma_event(INFO, "connecting to IP %pI4 port %d\n",
 		&addr_in->sin_addr, port);
 
-	init_waitqueue_head(&info->conn_wait);
-	init_waitqueue_head(&info->disconn_wait);
+	init_waitqueue_head(&info->status_wait);
 	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
 	rc = rdma_connect(sc->rdma.cm_id, &conn_param);
 	if (rc) {
@@ -1660,7 +1659,7 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	wait_event_interruptible_timeout(
-		info->conn_wait,
+		info->status_wait,
 		sc->status != SMBDIRECT_SOCKET_CONNECTING,
 		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 
@@ -1717,7 +1716,7 @@ static struct smbd_connection *_smbd_get_connection(
 	destroy_caches_and_workqueue(info);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
 	rdma_disconnect(sc->rdma.cm_id);
-	wait_event(info->conn_wait,
+	wait_event(info->status_wait,
 		sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 
 allocate_cache_failed:
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 0d4d45428c85..e45aa9ddd71d 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -47,8 +47,7 @@ struct smbd_connection {
 
 	int ri_rc;
 	struct completion ri_done;
-	wait_queue_head_t conn_wait;
-	wait_queue_head_t disconn_wait;
+	wait_queue_head_t status_wait;
 
 	struct completion negotiate_completion;
 	bool negotiate_done;
-- 
2.43.0

