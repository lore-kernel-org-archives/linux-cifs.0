Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AB7283FCB
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155107; cv=none; b=pfVKs7FZWr+tXmgDpWvd+vEPUyP/fKUlPUEAQ0t/052DdO8cPdcIbMZvPpASiHFTaT3Ep7HPoImurQR2QpIWBO154FwU28QpqaD0EcNT5zGaYwu7Z/mGYbxTRQJBUSnsO1+dT6N/A9AscLmatCd5gWpmfUnHJOZ5Dweg3qsoXPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155107; c=relaxed/simple;
	bh=j7Y+/YmO/hHX660w+T0MhArrRQv+syTgmJbC/vMGKuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPJXHSO1jV3Fm6DTlno3jda9HjdzrLA6hgtasQT9+/uBpra7fJgHxjMdi9eUL/i6+XenZTwZIdQL5BiVcNdFESlbG0Q7U7ScRxv7xy86/moygFmjoAVfIcLuWSiIJYNKVOiyAsoeP3QM9X4agoa006ZUV47+KJiABEWD5ZZnsro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=zg/Qw+YH; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="zg/Qw+YH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nXX0xsh6etPOf9jHyYpLrCiNVXCPykH9CMGvPAJCVTo=; b=zg/Qw+YH9B0egyhK14mf5YGQoi
	kXvThLhbatQlLHHR9my8Hu6sP8lPQ+bzU3wB40849uSSuiWj7vcY44VDJKXYPPX9Or7HKWvCXNr0+
	v2V/N0+sKBNZwM0ocPU+y+KQ74JjAGuQnXirRbnO9uvNCwYFHO2Vq1r34JD52Aegj5vsDK2sQAEai
	Pgbogs1o1/xuLUmtTRQkePCopFUA382dz1cVn8Q34SnqZAioKADuDuf7OdyoIYOjtBKEAKvn/PDSb
	qI0dqjUWLMoHMTMOOEuoa3CNS0AGz66Nx7ZtePptN7WHKydePfphHpck8kfcRg0QyqwMXCcENpebR
	N/fPDw1WBsaJcR+msm212pVNHM1tJvtKICtCffJXr3daSubc36gFoBznN7+fRmTQFyuayuS2dM0eo
	9Q7q+2IQNdR/MdIG7EpsohcbzPR5pfFvXrj5F8DOzn0WXO+hdfC3PY7rntjuIvymNbv9bJkkdKaz/
	rOoU2vuj0RbdOsHgdKz3lk9q;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeAH-000lCC-1R;
	Mon, 25 Aug 2025 20:51:42 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 059/142] smb: client: pass struct smbdirect_socket to {allocate,destroy}_mr_list()
Date: Mon, 25 Aug 2025 22:40:20 +0200
Message-ID: <435f17a96f74c91918be670c38b87c1f2f37cac1.1756139607.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 0f68c35bef2a..4db70c2c369a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -40,8 +40,8 @@ static int smbd_post_recv(
 
 static int smbd_post_send_empty(struct smbd_connection *info);
 
-static void destroy_mr_list(struct smbd_connection *info);
-static int allocate_mr_list(struct smbd_connection *info);
+static void destroy_mr_list(struct smbdirect_socket *sc);
+static int allocate_mr_list(struct smbdirect_socket *sc);
 
 struct smb_extract_to_rdma {
 	struct ib_sge		*sge;
@@ -1518,7 +1518,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 		msleep(1000);
 		cifs_server_lock(server);
 	}
-	destroy_mr_list(info);
+	destroy_mr_list(sc);
 
 	ib_free_cq(sc->ib.send_cq);
 	ib_free_cq(sc->ib.recv_cq);
@@ -1843,7 +1843,7 @@ static struct smbd_connection *_smbd_get_connection(
 		goto negotiation_failed;
 	}
 
-	rc = allocate_mr_list(info);
+	rc = allocate_mr_list(sc);
 	if (rc) {
 		log_rdma_mr(ERR, "memory registration allocation failed\n");
 		goto allocate_mr_failed;
@@ -2225,9 +2225,8 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 	}
 }
 
-static void destroy_mr_list(struct smbd_connection *info)
+static void destroy_mr_list(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_mr_io *mr, *tmp;
 
 	disable_work_sync(&sc->mr_io.recovery_work);
@@ -2248,9 +2247,8 @@ static void destroy_mr_list(struct smbd_connection *info)
  * Recovery is done in smbd_mr_recovery_work. The content of list entry changes
  * as MRs are used and recovered for I/O, but the list links will not change
  */
-static int allocate_mr_list(struct smbd_connection *info)
+static int allocate_mr_list(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int i;
 	struct smbdirect_mr_io *smbdirect_mr, *tmp;
-- 
2.43.0

