Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DEB22AE65;
	Sun,  1 Mar 2026 01:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329573; cv=none; b=KjcFU6BIeAOeK4gUAyOkXA9GUrjl73lxp50p8oshJWGFb1qoyp2SrMZwBklN1p6yQT66cKfMMAQog6cT4yWXJZsQCGMxKoq0lrNMVQW/OLllH2YHEM5vcIZ6pAHUrf1NhkskFFJfpxh7jHnVuaicdt7NwVTwVJIQWKJLwTnut+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329573; c=relaxed/simple;
	bh=ftzj8GHh7m8E+Gc/Njg6CANRxmFUpbpLPuL1d49KtLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gaHdffzy7cb/2ub9gphpJMNaVzTGWsH3jDdaVBuwRHvSQL+osqvifDzj8HXXnuU3YSGN7FF3uE7j3cHNfyB8/jl7fpZseljh5tFQZ/sR26Y5nctzB0mv2pLhmwPcf3R2EpzSDwGwxLuUNw7BRJ5VljADf5f9y9lG5teV/hXiPeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgHmuFkP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgHmuFkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C492DC19421;
	Sun,  1 Mar 2026 01:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329573;
	bh=ftzj8GHh7m8E+Gc/Njg6CANRxmFUpbpLPuL1d49KtLY=;
	h=From:To:Cc:Subject:Date:From;
	b=FgHmuFkPbhau2aaTTP3jPbWhCinc9sY/vpEnBviLq1mLZUpjVs0y1B/TZG9dngkNy
	 kR+kxSi3mviV/eGxk9dXaJA6iRS/W76/Jo/3Yxrqu8jFtMfWQ2Ie/TVF/DdyBnFgdA
	 g+qPk3UtwwYvcztteroJChReh8RbnXxLA/SOoGkjNSeQV37S4fjC1ls9nPgHm7gxkn
	 05PlUeMDI5sHO8uxO6LeYj2Cdb7nmtz+b9Kd8tULbW2YV6z7fXl+CA7bsABJu84G2Z
	 PwJvPbznYqTYb2HQ8zEL3524ZN0ODlAD57SeW+dQsm0hZr2Nw3Sr2MaGkoMNXbuQkG
	 fF8CJJShOSOJg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	metze@samba.org
Cc: Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: FAILED: Patch "smb: client: port and use the wait_for_credits logic used by server" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:46:10 -0500
Message-ID: <20260301014610.1709037-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From bb848d205f7ac0141af52a5acb6dd116d9b71177 Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:53 +0100
Subject: [PATCH] smb: client: port and use the wait_for_credits logic used by
 server

This simplifies the logic and prepares the use of
smbdirect_send_batch in order to make sure
all messages in a multi fragment send are grouped
together.

We'll add the smbdirect_send_batch processin
in a later patch.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 70 ++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index cfbe8ce0db422..405931ce3978f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1137,6 +1137,44 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 	return rc;
 }
 
+static int wait_for_credits(struct smbdirect_socket *sc,
+			    wait_queue_head_t *waitq, atomic_t *total_credits,
+			    int needed)
+{
+	int ret;
+
+	do {
+		if (atomic_sub_return(needed, total_credits) >= 0)
+			return 0;
+
+		atomic_add(needed, total_credits);
+		ret = wait_event_interruptible(*waitq,
+					       atomic_read(total_credits) >= needed ||
+					       sc->status != SMBDIRECT_SOCKET_CONNECTED);
+
+		if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+			return -ENOTCONN;
+		else if (ret < 0)
+			return ret;
+	} while (true);
+}
+
+static int wait_for_send_lcredit(struct smbdirect_socket *sc)
+{
+	return wait_for_credits(sc,
+				&sc->send_io.lcredits.wait_queue,
+				&sc->send_io.lcredits.count,
+				1);
+}
+
+static int wait_for_send_credits(struct smbdirect_socket *sc)
+{
+	return wait_for_credits(sc,
+				&sc->send_io.credits.wait_queue,
+				&sc->send_io.credits.count,
+				1);
+}
+
 static int smbd_post_send_iter(struct smbdirect_socket *sc,
 			       struct iov_iter *iter,
 			       int *_remaining_data_length)
@@ -1149,41 +1187,19 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	struct smbdirect_data_transfer *packet;
 	int new_credits = 0;
 
-wait_lcredit:
-	/* Wait for local send credits */
-	rc = wait_event_interruptible(sc->send_io.lcredits.wait_queue,
-		atomic_read(&sc->send_io.lcredits.count) > 0 ||
-		sc->status != SMBDIRECT_SOCKET_CONNECTED);
-	if (rc)
-		goto err_wait_lcredit;
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-		log_outgoing(ERR, "disconnected not sending on wait_credit\n");
+	rc = wait_for_send_lcredit(sc);
+	if (rc) {
+		log_outgoing(ERR, "disconnected not sending on wait_lcredit\n");
 		rc = -EAGAIN;
 		goto err_wait_lcredit;
 	}
-	if (unlikely(atomic_dec_return(&sc->send_io.lcredits.count) < 0)) {
-		atomic_inc(&sc->send_io.lcredits.count);
-		goto wait_lcredit;
-	}
 
-wait_credit:
-	/* Wait for send credits. A SMBD packet needs one credit */
-	rc = wait_event_interruptible(sc->send_io.credits.wait_queue,
-		atomic_read(&sc->send_io.credits.count) > 0 ||
-		sc->status != SMBDIRECT_SOCKET_CONNECTED);
-	if (rc)
-		goto err_wait_credit;
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+	rc = wait_for_send_credits(sc);
+	if (rc) {
 		log_outgoing(ERR, "disconnected not sending on wait_credit\n");
 		rc = -EAGAIN;
 		goto err_wait_credit;
 	}
-	if (unlikely(atomic_dec_return(&sc->send_io.credits.count) < 0)) {
-		atomic_inc(&sc->send_io.credits.count);
-		goto wait_credit;
-	}
 
 	request = mempool_alloc(sc->send_io.mem.pool, GFP_KERNEL);
 	if (!request) {
-- 
2.51.0




