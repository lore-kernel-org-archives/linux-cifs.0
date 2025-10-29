Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8D83314BC
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744502; cv=none; b=u2u0ilRWqa1V2NKmDCaoak0AKjJsql9N96GuPF+aChA/5vjdQYtNp/55qc7E/ocJ80BjAdLb/sSib7rqDixv1jQTM1kQ2fWuZdEh2v3v/QGCVqa/4/zCJ5MOllBM7u1gasx+Zw/XYO/t700+jF9CsrVR8qJhAp18HHSsUHGFr+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744502; c=relaxed/simple;
	bh=SQkmRkfmC3QZJs44Or8arsnZQkuEkJp265APg240h9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gB5BqOSS0PrC18nokFvrlSGTEdwn8Gw8+tFAe42cQQyvnI93UYD3e45CUBuT792Y1EDgkCn8lKQZuSZ7GmaLSj/vcKPwcRt4502FOL+kWFTbmWNfSXgN9CrRWJ+XFDqQMp1uVxUDbKQMYfdTCN7e0CeqX7aGXn6KlZIR8ymGTuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3BCF+Qe0; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3BCF+Qe0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=uVDVs9P3LlRAqEn6fgRwtXdI1/hMX8L0Yb+OP0uZzV0=; b=3BCF+Qe0k0a67oFKScMROkZVoq
	wZlGjajHE9THpfuDwv6UMsdnABsgkCr/qkJzH+9z6COMecy2q1nJ9Jv4Lw7Az4AOmyzhEYsRLEe0x
	Noec2/4ZQsYJtpMWIijs253QpDlDSSBBQEKgnQgsKWVVfFtYNP0dXVIIaTLWDN7tizwa6F5EDxmYZ
	opQQ+plU32Yc1lCQMhVsBB5Mn66d+E8LFo67x5xPhrKsUCmHPZD/9JDV0OnfOmh4BTYfXLlLa0NW/
	/az2ucjeswzywNvrs6k4IK5CejdBx7RrzgrvP54RA+hk5z2sFqoFHXehRbSbpfPWw9a62H9jioFby
	rQJxIsjfezjehwzOWoFGxRjG7Uf8s3wsWq3ZjFVIu++OtmHSENs5kJm4Nk2f+HKNRa3IKWh4MgI5h
	g5zvRS4XpOHwisG19Z8fji4GmWTCjbTsR+grkiQMskPV2xPY1r2L8JYQ13W5D1tYVzPocgWXx3dIS
	f4McNmhrbqyK9r0ZVhYY9uQ4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Dq-00Bc4b-0E;
	Wed, 29 Oct 2025 13:28:18 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 059/127] smb: client: make use of smbdirect_connection_wake_up_all()
Date: Wed, 29 Oct 2025 14:20:37 +0100
Message-ID: <ce6994d4e7d84bff8cf139c64ba6f023f70d5851.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
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
index 08192d69617b..c6f2bb5fc262 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -213,22 +213,6 @@ do {									\
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
@@ -285,7 +269,7 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	 * Wake up all waiters in all wait queues
 	 * in order to notice the broken connection.
 	 */
-	smbd_disconnect_wake_up_all(sc);
+	smbdirect_connection_wake_up_all(sc);
 }
 
 static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
@@ -347,7 +331,7 @@ static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 	 * Wake up all waiters in all wait queues
 	 * in order to notice the broken connection.
 	 */
-	smbd_disconnect_wake_up_all(sc);
+	smbdirect_connection_wake_up_all(sc);
 
 	queue_work(sc->workqueue, &sc->disconnect_work);
 }
@@ -1655,7 +1639,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	 * Most likely this was already called via
 	 * smbd_disconnect_rdma_work(), but call it again...
 	 */
-	smbd_disconnect_wake_up_all(sc);
+	smbdirect_connection_wake_up_all(sc);
 
 	log_rdma_event(INFO, "cancelling recv_io.posted.refill_work\n");
 	disable_work_sync(&sc->recv_io.posted.refill_work);
-- 
2.43.0

