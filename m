Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409AB275AFD
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744853; cv=none; b=u/wySH7FOzbHQq0g7gQhbUb7bWAhMJDwiPJSzSmPfOUPrSfXHNOH1XbhmYTAkxNpjv/FM9HmBZNa+FX4QooMOMtlsEeGLM8Tx4GjWLvcmuKQevb1q+2KGHfFSE42PUQJjSh0hE3H4ZLkl6Y31HAmKkBah4o470IFt2cmVSOtuGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744853; c=relaxed/simple;
	bh=z52FR3r5pz9jD3CIvnpgIb+DqL2rZH9uyL3axiHVKpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Al2PYBDcP54qbUa8JTH0Jb/0o5uuqbjXgBIP8mFl1Ubk0AIvkCTgsSi0XWhj+sJOUyVXLaiQ5zeu7F4qyenMIlEfPsxQln86Xy8VrLWkA2RK6BPdVJXjCt8KUWWZCxiPSD42RH+ZERoNRrS5+uCSFVoXeQxQEJZJ2FfTcjBQ1VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ce5Eyugm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ce5Eyugm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=4fO5qq0qL1cRiJe7BkTrCJ/qDmRr+WCqwpsq0YtDbsk=; b=ce5Eyugm1BmPQnI2OJOltoHTXu
	rUNLLTFCXmbaCrNofWdrpSommRlLGuupoT9unGIiwRclCxyBNpxlUDZXW5ygAVWablb14aL19wUMA
	ObwUaWoITu9mLtfEOH8XNXfzCdjLYDrw+dK8r8CuGubUuHrcMg1AWBFSnwHLq3bwRnHv9UwbGgbz9
	XeBCE2g+G9ZThMH1Va3DHLdO8EYDdtfTiwqHB154CLx08JsqI1KMkeN6zEpSn9Ijuz2846Ao1zNQg
	kdQrD/DuZhCAoZRvW4b43ga92KwPHPOFvngG5C+w5YiAW6LAm+JY9NDzELTqyX0eKArPQ+0M+Y32A
	9vm3WrTq1Gd21nkQpm2gNj8Dbd/zfKCzZnlI+KlLCSZ9SJKwGjID+n7nfQG8PokM/7Z4VFpOyglrr
	HdLYsOb22FDraWy57OLjl1IvlVr9DcHqQoZzetaM80sUtMRq7hi8aKSaVGsFNPspOJgDRVPs0MIf1
	YeZlf5ZrDHokba7oSMqEsVWe;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6JU-00Bd1B-06;
	Wed, 29 Oct 2025 13:34:08 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 116/127] smb: server: make use of smbdirect_connection_grant_recv_credits()
Date: Wed, 29 Oct 2025 14:21:34 +0100
Message-ID: <bcdf211d9dba43a54b97a85f1f622d762e5e7977.1761742839.git.metze@samba.org>
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

This is already used by the client too and will
help to share more common code.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index d64896a2a1d1..55757c66cd44 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -492,25 +492,6 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 	return ret;
 }
 
-static int manage_credits_prior_sending(struct smbdirect_socket *sc)
-{
-	int new_credits;
-
-	if (atomic_read(&sc->recv_io.credits.count) >= sc->recv_io.credits.target)
-		return 0;
-
-	new_credits = atomic_read(&sc->recv_io.posted.count);
-	if (new_credits == 0)
-		return 0;
-
-	new_credits -= atomic_read(&sc->recv_io.credits.count);
-	if (new_credits <= 0)
-		return 0;
-
-	atomic_add(new_credits, &sc->recv_io.credits.count);
-	return new_credits;
-}
-
 static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -648,6 +629,7 @@ static int smb_direct_create_header(struct smbdirect_socket *sc,
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_send_io *sendmsg;
 	struct smbdirect_data_transfer *packet;
+	u16 new_credits = 0;
 	int header_length;
 	int ret;
 
@@ -658,7 +640,8 @@ static int smb_direct_create_header(struct smbdirect_socket *sc,
 	/* Fill in the packet header */
 	packet = (struct smbdirect_data_transfer *)sendmsg->packet;
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
-	packet->credits_granted = cpu_to_le16(manage_credits_prior_sending(sc));
+	new_credits = smbdirect_connection_grant_recv_credits(sc);
+	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
 	if (manage_keep_alive_before_sending(sc))
@@ -1064,7 +1047,7 @@ static int smb_direct_send_negotiate_response(struct smbdirect_socket *sc,
 		resp->reserved = 0;
 		resp->credits_requested =
 				cpu_to_le16(sp->send_credit_target);
-		resp->credits_granted = cpu_to_le16(manage_credits_prior_sending(sc));
+		resp->credits_granted = cpu_to_le16(smbdirect_connection_grant_recv_credits(sc));
 		resp->max_readwrite_size = cpu_to_le32(sp->max_read_write_size);
 		resp->preferred_send_size = cpu_to_le32(sp->max_send_size);
 		resp->max_receive_size = cpu_to_le32(sp->max_recv_size);
-- 
2.43.0

