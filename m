Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4225318152
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093992; cv=none; b=g8JojwfipbdJhtDwv+NvdXiNAsnbrPPIOEANE5jEcVJayrPEt+boPDeb+tB7S5Dn1gjBTG08GkXQMFYfxl7FWdWLplMfK7PTtFY06aNzLgywPtyjD/UtDv23/SLr5sswQR287+yCjDD6uP40MEx9+sTES+WGMEj5nGd2aR4e0xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093992; c=relaxed/simple;
	bh=5e+4tUlL4pmYVAOvhYAt0cXbnpyqNo094PP+KU44FLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1wpy+f9d8fVqAoSWEMVTTUkgnHWCzPP9Gk/Fo+BzGpgvQaL9XFtHQJwXOWb3rjjsrjES9MwsXYdMCUJXA8ildhI9hqYmqWa4puTbiv+rpWL6VRDtE2IU5kEznYiJIXeL3k39KMV+aHoMpAo2e/SWJuRvbaoMlL6juw7vlwpWdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PnayvQKU; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PnayvQKU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nhvs8Ks+L5+0PWdzhox0gnpQcTmxDYOw68mg+HkYe2Q=; b=PnayvQKUuJHsVAzPeEMwlgoTig
	mKGuFvYelfhaiNyKNAUsfSjWsSJAIkzqTGkvfBiYa3zwTBy5Kl+YdSf+Ua+LQrVygB0GUuxRdHgQS
	5GmJK9L6bqaNTuEQQ/sCWYpJjy3qVD0crVr0AY3rAcVZpGSa7eAtrcNz3BxlROrtPHecI95lTf6c/
	rFlQ0sqzxZWzAHcBOMPsi5BU17I3mLoGO3nZftKZC2CROMkFVkSBHsQOP4g1zkARqpL4RoTXDhKx/
	OpCfzXoZdCU7pInQpgAMMjGvdxCJtkAChQk46KytDGAjni0Ctyp93QF2HhJWBFoMcb0O0m7kk76ev
	GZFx8YcAa39izr6MXHhOxEXQkhRShAr7vvgi7MT5S+W6DiadhPzXGjGdHC7Xi2YKNTVxQXaXw54z6
	eRGe3N2rgCykn625g+8Bzr9VG//3GYKuXTWDUQYvIBSAS5E2V5BVh1VorOiew599tlsL8iPrCFnI2
	/VcMn375O0kyddTxZ3VeGh9i;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxNo-00Fdba-0Z;
	Tue, 25 Nov 2025 18:03:20 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 063/145] smb: client: make use of smbdirect_socket_wake_up_all()
Date: Tue, 25 Nov 2025 18:55:09 +0100
Message-ID: <db1ab14841d3d7d108074d16054983bd3e0c6872.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a superset of smbd_disconnect_wake_up_all() and
calling wake_up_all(&sc->rw_io.credits.wait_queue); in addition
should not matter as it's not used on the client anyway.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 3d3b6fa65781..4dae3d1eb93e 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -216,22 +216,6 @@ do {									\
 #define log_rdma_mr(level, fmt, args...) \
 		log_rdma(level, LOG_RDMA_MR, fmt, ##args)
 
-static void smbd_disconnect_wake_up_all(struct smbdirect_socket *sc)
-{
-	/*
-	 * Wake up all waiters in all wait queues
-	 * in order to notice the broken connection.
-	 */
-	wake_up_all(&sc->status_wait);
-	wake_up_all(&sc->send_io.lcredits.wait_queue);
-	wake_up_all(&sc->send_io.credits.wait_queue);
-	wake_up_all(&sc->send_io.pending.dec_wait_queue);
-	wake_up_all(&sc->send_io.pending.zero_wait_queue);
-	wake_up_all(&sc->recv_io.reassembly.wait_queue);
-	wake_up_all(&sc->mr_io.ready.wait_queue);
-	wake_up_all(&sc->mr_io.cleanup.wait_queue);
-}
-
 static void smbd_disconnect_rdma_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
@@ -288,7 +272,7 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	 * Wake up all waiters in all wait queues
 	 * in order to notice the broken connection.
 	 */
-	smbd_disconnect_wake_up_all(sc);
+	smbdirect_socket_wake_up_all(sc);
 }
 
 static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
@@ -353,7 +337,7 @@ static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 	 * Wake up all waiters in all wait queues
 	 * in order to notice the broken connection.
 	 */
-	smbd_disconnect_wake_up_all(sc);
+	smbdirect_socket_wake_up_all(sc);
 
 	queue_work(sc->workqueue, &sc->disconnect_work);
 }
@@ -1662,7 +1646,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	 * Most likely this was already called via
 	 * smbd_disconnect_rdma_work(), but call it again...
 	 */
-	smbd_disconnect_wake_up_all(sc);
+	smbdirect_socket_wake_up_all(sc);
 
 	log_rdma_event(INFO, "cancelling recv_io.posted.refill_work\n");
 	disable_work_sync(&sc->recv_io.posted.refill_work);
-- 
2.43.0

