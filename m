Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C762836BD
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155127; cv=none; b=oE6a03UF87+tiUtsvbVNfB2FKRt5d1Arrko2vNsop6TBjphtHwRilX6wcotY18EO8Tb7n0js8fodvWfENRrwBP/Jm2FZbKqKfi/Wy2DvCHoGww2lo7HR31q/8+NrLPJNaW83WWp47NF8wENBXvJyoiyAFoG+BCOiZrs+2uN1JpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155127; c=relaxed/simple;
	bh=mBxSkv9u2d1MbiWaVHRlU4F8WjwD+Wq9OarrM3BDHxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwiKHq5BEWwPvzV/mYI/uaHJ6gtq+t9oAlKCkCQ1Zm32eu3tAmiRrS+oXc2lC3cOEQ6Eq0LZj6Vp+Sx5w2C21QnzH6WwAwLK8BIvsGESttSWNC+lOEe316UwsvFu65OHk0npedPkCB71f8OKVnhPPe7C7FtgkYWWPp3v0jDrGGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=o+L7tL7w; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="o+L7tL7w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=KV1HkgjiZgdGTK+Tvyw+wYdIgNkypxNvc5D6zXWiefc=; b=o+L7tL7w+vSFXg3jh62GQKAJAR
	MIQ48sJXE/KBK/rN+KMilhThRk41SxmOB9mOM6dnp6EGE7K/lsyDPA4cSa0HRcAxfeW1vkbFktnEA
	1Oz6lGVLZv+NOaQFL+FLInaINJ8mzDzD3yetHnPov9InA9Jo8nCDZG1cppwHBEqZa9lXOLOCBeLxT
	C9jZ5gH4GnQOkB2+gkGbS62DPVm3TQJWeazUeejnjPG9GH4dlCDxWW9LEiSwcIZyZaV+84AY3YnIx
	9ZIRDB5l+e09Ge0ce3+llFYvR/3fMVVlMpY6WbxetT77SHQwHb7X31GNrTmYBQGfgEnw27wt80ds0
	thjYRYjlL5KW2nZZP/Ze8R4Up/T9YrKCxO+PdjQQj/qSvFdqvDIjQTkW6BAhlNptJoq/HxTvIfYJo
	Klpf86B+QfDsqLtRrd7Q6/SD+ij5iCv4kIftr+tgESmUzYHycz0xHJs59R2MCwwq5ce5Hxr34toco
	OXs3AbuclbpKWqx9TqUlapxh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeAa-000lGY-33;
	Mon, 25 Aug 2025 20:52:01 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 061/142] smb: client: pass struct smbdirect_socket to smbd_post_recv()
Date: Mon, 25 Aug 2025 22:40:22 +0200
Message-ID: <d14aa1fe7c5bbc8650e439072124eba11cece0b0.1756139607.git.metze@samba.org>
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
 fs/smb/client/smbdirect.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 31b9b398b6e5..e00a70125ca8 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -35,7 +35,7 @@ static struct smbdirect_recv_io *_get_first_reassembly(
 		struct smbdirect_socket *sc);
 
 static int smbd_post_recv(
-		struct smbd_connection *info,
+		struct smbdirect_socket *sc,
 		struct smbdirect_recv_io *response);
 
 static int smbd_post_send_empty(struct smbd_connection *info);
@@ -506,8 +506,6 @@ static void smbd_post_send_credits(struct work_struct *work)
 	struct smbdirect_recv_io *response;
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
-	struct smbd_connection *info =
-		container_of(sc, struct smbd_connection, socket);
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
 		return;
@@ -521,7 +519,7 @@ static void smbd_post_send_credits(struct work_struct *work)
 				break;
 
 			response->first_segment = false;
-			rc = smbd_post_recv(info, response);
+			rc = smbd_post_recv(sc, response);
 			if (rc) {
 				log_rdma_recv(ERR,
 					"post_recv failed rc=%d\n", rc);
@@ -1179,9 +1177,8 @@ static int smbd_post_send_full_iter(struct smbd_connection *info,
  * The interaction is controlled by send/receive credit system
  */
 static int smbd_post_recv(
-		struct smbd_connection *info, struct smbdirect_recv_io *response)
+		struct smbdirect_socket *sc, struct smbdirect_recv_io *response)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_recv_wr recv_wr;
 	int rc = -EIO;
@@ -1226,7 +1223,7 @@ static int smbd_negotiate(struct smbd_connection *info)
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
 
 	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REP;
-	rc = smbd_post_recv(info, response);
+	rc = smbd_post_recv(sc, response);
 	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=0x%llx iov.length=%u iov.lkey=0x%x\n",
 		       rc, response->sge.addr,
 		       response->sge.length, response->sge.lkey);
-- 
2.43.0

