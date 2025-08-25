Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF3E143C61
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155172; cv=none; b=nOvO6YK5yUd6fSEgYOkoTmLi0q3+JMTSAZqHT1R9nI5AjCnLxBGZJATbiqrReC8hfUS1a9hlU7B0FlvCNxtM3S/cbskYhbXfma4SfdbqmLvnYaZw5eyi22OY3ISEu81phlTnWSO/ENk2+FBF8Z+X36lN60QKY4Mpml8SF9VEEsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155172; c=relaxed/simple;
	bh=E4AX7T5EpRJEsrMJeMFq+AXb7X1dB0KGXn0EinQKkiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWBy9R5uwr7RtT1Pj/QLmXXHivSezjDQRzzQqMBMzvECQQCVnclpCnDySCBWJQtqsPxdX5qBYCrkKJXJu5AprL5mfEM34RyUByFemi0Zqp7UucGjATpJmibydxx5lSnk/FDgbY33jgfjU2ikUUn4tyPUd6jztWVsDce6MtaJawY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nAQXHIaN; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nAQXHIaN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=tMx5Ah+SuJ38Wcv2vHqUr6QFUs4jhB41lsRYxeWB10A=; b=nAQXHIaNEQd74PwyDKdgi4tHpp
	flHCCdVFWRvJaZHA7dzCWOrZOgGv1oryPOOWqxm73zbme5my6RvY9dNfxRjOryBCPY3I2Tz6gmwDi
	BiI1lPAiYC2hGovz7BW770St4QdCPsFj98ExruujyJ9E4dgOXlGonSJ4nwru+xQbqmRq/936MgG3C
	fluksIxEhK9nbgXRkhD/V9jct3ShERN33swn6Y2lfSoW8KyPt0GRk9ermTN2KEjS89PvuJDz/HpTS
	cqD1tiyBlk5MjzlKwwN4jCr8VXplSPTD+liTZIhlbnkqWUnppV3l0tHKX1G4fFoxpcpfrhyuzBJju
	e6Rv0QQy52djfw39Khxlot7B9J9E2IJZn+MKdrhJupkExmC0YEca08rYU+UIS3ru83leF1fZhOpXJ
	ikwyq9pOuRWI/6o47ZCwsyfbcQCNjuYDgp83BIj0LocMR8igSZMl5C75Njj2V4mRoTkONbDTe3Dgo
	XUKgHODrgzL5RgExYxrwSMda;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeBM-000lR1-0r;
	Mon, 25 Aug 2025 20:52:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 066/142] smb: client: pass struct smbdirect_socket to smbd_post_send_empty()
Date: Mon, 25 Aug 2025 22:40:27 +0200
Message-ID: <f35d07ab7d5d622b3ce13767a466b0f9b96d6bb0.1756139607.git.metze@samba.org>
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
 fs/smb/client/smbdirect.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 40d0233f41df..b9ea58e8db46 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -38,7 +38,7 @@ static int smbd_post_recv(
 		struct smbdirect_socket *sc,
 		struct smbdirect_recv_io *response);
 
-static int smbd_post_send_empty(struct smbd_connection *info);
+static int smbd_post_send_empty(struct smbdirect_socket *sc);
 
 static void destroy_mr_list(struct smbdirect_socket *sc);
 static int allocate_mr_list(struct smbdirect_socket *sc);
@@ -1137,9 +1137,8 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
  * Empty message is used to extend credits to peer to for keep live
  * while there is no upper layer payload to send at the time
  */
-static int smbd_post_send_empty(struct smbd_connection *info)
+static int smbd_post_send_empty(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	int remaining_data_length = 0;
 
 	sc->statistics.send_empty++;
@@ -1390,14 +1389,12 @@ static void send_immediate_empty_message(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, idle.immediate_work);
-	struct smbd_connection *info =
-		container_of(sc, struct smbd_connection, socket);
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return;
 
 	log_keep_alive(INFO, "send an empty message\n");
-	smbd_post_send_empty(info);
+	smbd_post_send_empty(sc);
 }
 
 /* Implement idle connection timer [MS-SMBD] 3.1.6.2 */
-- 
2.43.0

