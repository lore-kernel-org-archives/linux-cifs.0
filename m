Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C88F2F1FD6
	for <linux-cifs@vger.kernel.org>; Sun, 12 Oct 2025 19:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760296261; cv=none; b=KORjsoEeja8wX5P+mTWPUmUhYnnwbxxtZiuqfsm+BbNoYss+P+tS7FxjL8dYgQk+0gLk9nrNDHdbQT/rhf/meCbOsE8eLPn6vAqiQ6UlcT81t/bGiM9qiqkkM0HQHHUxtcCql84Ut69DxS4IEdC0ltucaN3b0Ax+YzWs38KVS60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760296261; c=relaxed/simple;
	bh=VFqkl4xTq/PtjhnJdshUU7U2Si2jqsenkT1OgkQyGP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LE6f4vG3ViTjBniswrjReFPIHJTTYUn2NvIWuBgpCc8r3RSAti121AXPNMXueKA6jyPIOcA5eFjjqtiwTipjMR0Esql+ls0AEwMYDHyKkv6y9WI0CUt4csXyDViUouADsxQgMlU7jkLZdBNTeO3T8A0GeGpUY2PtaTlX2/KP6PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Ks/iFauu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Ks/iFauu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=EczH4a/lE4mr5DCu0Qj5rfn+wCdiHyux9zcbz5iTCjQ=; b=Ks/iFauuZhHCEEPhD7ZLk4ctyl
	ReNdcZbBP+8oQX8pnvKlJTtBe7FfVnATQQQVUoJ73I3QtvQqUHEitnYkSttZwskYOsO1xhIhbAbCV
	TWCi3f9s59NjMxXUw4ta3kW1GpCjbubiRmQDvVrsT42NehMyrN86nKMsQbqWZLyNORaPMWlJrf7bA
	dazCWtLM3cJKqXKSL+PzjR0AdsfhuJLy+h6w6pw069OYnK5oH1FOY/r5/vXRmKNg3/4mEueU4Sh1K
	qn24i6l0rS5GIVjD6GFeDjnnwkTo8OKZsEeOuJIgL/XX4zrzHZIu4SxlWoqXAJcWp9jWvDvEIaFtR
	Aij/SZM2sj0ASBiqTwcTxXzsSnznlPhwPp6x4xQHp6I3Lu7l7uIfwr7yEIjBHc5q4psNV81hXMu4J
	1pftxPK7R/QsB2CVfuxgxE+yG6j+B4wKaa8QxGwgPNmZE7zzlvS9L1O07+Cg6JXQQxfPtiR29wqyQ
	K+KrA0npQO17dLxNo+hAXAkz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v81T5-008nzt-1e;
	Sun, 12 Oct 2025 19:10:55 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 02/10] smb: client: change smbd_deregister_mr() to return void
Date: Sun, 12 Oct 2025 21:10:22 +0200
Message-ID: <bbb80797eba59ed159bb60525edd601b0de448a2.1760295528.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1760295528.git.metze@samba.org>
References: <cover.1760295528.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No callers checks the return value and this makes further
changes easier.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 4 +---
 fs/smb/client/smbdirect.h | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 316f398c70f4..a20aa2ddf57d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2612,7 +2612,7 @@ static void local_inv_done(struct ib_cq *cq, struct ib_wc *wc)
  * and we have to locally invalidate the buffer to prevent data is being
  * modified by remote peer after upper layer consumes it
  */
-int smbd_deregister_mr(struct smbdirect_mr_io *smbdirect_mr)
+void smbd_deregister_mr(struct smbdirect_mr_io *smbdirect_mr)
 {
 	struct ib_send_wr *wr;
 	struct smbdirect_socket *sc = smbdirect_mr->socket;
@@ -2662,8 +2662,6 @@ int smbd_deregister_mr(struct smbdirect_mr_io *smbdirect_mr)
 done:
 	if (atomic_dec_and_test(&sc->mr_io.used.count))
 		wake_up(&sc->mr_io.cleanup.wait_queue);
-
-	return rc;
 }
 
 static bool smb_set_sge(struct smb_extract_to_rdma *rdma,
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index d67ac5ddaff4..577d37dbeb8a 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -60,7 +60,7 @@ int smbd_send(struct TCP_Server_Info *server,
 struct smbdirect_mr_io *smbd_register_mr(
 	struct smbd_connection *info, struct iov_iter *iter,
 	bool writing, bool need_invalidate);
-int smbd_deregister_mr(struct smbdirect_mr_io *mr);
+void smbd_deregister_mr(struct smbdirect_mr_io *mr);
 
 #else
 #define cifs_rdma_enabled(server)	0
-- 
2.43.0

