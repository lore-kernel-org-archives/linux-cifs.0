Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A06628751B
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155888; cv=none; b=LrK9mbctDGbCjyEuuvpTvZONU/IO+4JlCJuUTjR1ggOivbniqvN3baITDrhyi9R9EeHAuHD/MfRCoEFOqgAK9ow0atqP41F0DIVDPg6TFlsRoxC5ODOl9Qbk+7ALpLCjkLePp+LjJx1eE6oiUrUIO7nigrCvCQQWaTfS4AVz7wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155888; c=relaxed/simple;
	bh=JcGw+Mz4IGZMCsu0yLlp+9GQhC680U5LbKQm4XCp+Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUv4VVqZ2AuptFFVySF/cLdfk0iWAvgbIKpTZTixK2xiYx6bvu9Qc5EKXIip8GrdpQqDBrdq2LgWHk6raXCefjKt7lyFKc9Y53nPdtjzZXH3ZtkKup3wahGFoOtaLoq67LWTvy6UmYz7G4+BbzwxVXwYwGrR1AXaXSHMIuKpqVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=aHVZSIsS; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="aHVZSIsS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=QexmNMLtnlGcc9C4ck7Aqqf2yrsrvnd0shGljvLndPo=; b=aHVZSIsSuxoSAARHnx4TOj4ukF
	NPTv5RuaM+oPcFL7/TJZuHJhY9bYGm0H2YQqIownwo9Sh7TjuBrCoQtfLSbD1wNPzrNhhb2LgiJ5M
	yiVJSIoFvDYBckdw4t+Eg+WOp3A34H9qvxN2Ti5bXiGxicTKgOKN3Excr/ZvxJp0JQd7PeMOPvJxd
	+qjSEizS7dKU4gvAMqRp7K/n7MsbM33vuqzcRbevQb+4iPoaKb7VBxQcfHxIEGMNs+BiUfFYTkINK
	TAmE6m4jBW4L6o66BLUQgbMG8+EVd5ZniHgCMUUFk/iZ0s1E93nTJ9TpWnIfqBFKlp8iKtSO5g1Lh
	WbV7VXPs791UIT99WQXOYoRalRZ2O5C8TViWqA7/sXs6SP2kJT7H4/2XZtpgnovl5FcbxQkIMteaj
	HXpPKRt3y4c7yX29Pe7wc88OdXdjuV2/rVoTAN4Gu+E9lLDOGKJ+fItSrqwNb8lV1O9RyqJ2kiP18
	EOZcf1uJM9SSJd0HkEmH9qfM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeMs-000nno-13;
	Mon, 25 Aug 2025 21:04:42 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 137/142] smb: server: pass struct smbdirect_socket to manage_keep_alive_before_sending()
Date: Mon, 25 Aug 2025 22:41:38 +0200
Message-ID: <5b574c6912b0de66687a06077ea41803ba632814.1756139608.git.metze@samba.org>
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

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 8a57da09091c..600c541a919b 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -860,9 +860,8 @@ static int manage_credits_prior_sending(struct smbdirect_socket *sc)
 	return new_credits;
 }
 
-static int manage_keep_alive_before_sending(struct smb_direct_transport *t)
+static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 
 	if (sc->idle.keepalive == SMBDIRECT_KEEPALIVE_PENDING) {
@@ -1017,7 +1016,7 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 	packet->credits_granted = cpu_to_le16(manage_credits_prior_sending(sc));
 
 	packet->flags = 0;
-	if (manage_keep_alive_before_sending(t))
+	if (manage_keep_alive_before_sending(sc))
 		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
 
 	packet->reserved = 0;
-- 
2.43.0

