Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D741928688E
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155243; cv=none; b=s9Vq0+v4mF005keowLWH1GMXBkUrtgjjPFRDbI13RlvucEWofX9KybYFkHNghlyGYfeRvwh2Dq/jMXPCrjLVe5fGLTfpSANarHaZt7DYIXptpsX2cGcwvWaQZrU37N/RzMgsj0WlIAuNnuopLbejUFQX/M0BOxXad+Q/dhPXiW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155243; c=relaxed/simple;
	bh=c7j5hc1kwTPJ8iX45Umd//nN73M0sxCurnQYnuFu7g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzBUYpiJcJr6M3DhqhHc7JvVEfCBCPnBLfvGWZM5iL7j0ufNf/RYWe+Hg5cyYIwDGgXC+xMPu/EqRdi875Coyf6UzfF8cfMWFEcUWPxv7w2fHpzqQsaEnVTcRvt+FrzDDzMmYQp/fq0QyXblA9lcXjcL/X+T+nYQfZeUiXYu10I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=KR750XXd; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="KR750XXd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=lU2BRT2wsLHZ3vXzRBI9o9DmdnoSuGTY6fGDF4CPwnw=; b=KR750XXdbvpJMr2wWq7Oa114qh
	sUAc3oGvX+QlJOUV1ZbCeQy0pDENkb0xWFD0GeCnm7sY+8HVAkYFZgev+wVla7h1mu2s83piJv1GA
	f6sKVwDBMuiMypVwjFyb/RRHXm7EDafIeBrg5MUfHDnH3QklmYD6POh9rpcsB+YGxzHR5sArA9Kcu
	B9WuCJqb5Z5ClcjenfqwoN6R18DdBJEYUyFWycuTqR7dr/fwWwGakXZcPPK9RK/wgfFguUK3e2NLB
	V/HThbVIl5yJINPgd9K0GLQSua5P3oPq8m1TzsbBkXUYqDPINMxnUS3mrLW7DvJBDFvM8sqYMusSb
	f1hUUFgv96e05WrhAVB5dy8lJZ75LSF7IgfxfLl0HjE8A4tpem2HvSQOJLZoUiKWZTVaJ2HJ0OvEx
	ids/lbboFy3UHB0oCACYJ03ym1D2Cu8m+wygW0rz2DEd0+sMnIYsi3JMPI+FXDydGOFJdT5ir8Yig
	kvP5MOZ0LUQldH98IQSkaueq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeCT-000leE-2x;
	Mon, 25 Aug 2025 20:53:58 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 073/142] smb: client: pass struct smbdirect_socket to smbd_negotiate()
Date: Mon, 25 Aug 2025 22:40:34 +0200
Message-ID: <cb8d7ffbb4a9f01169890f63c86a6ad065a806f3.1756139607.git.metze@samba.org>
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
 fs/smb/client/smbdirect.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index e5219b9c0c8a..04f86fde11fe 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1202,9 +1202,8 @@ static int smbd_post_recv(
 }
 
 /* Perform SMBD negotiate according to [MS-SMBD] 3.1.5.2 */
-static int smbd_negotiate(struct smbd_connection *info)
+static int smbd_negotiate(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int rc;
 	struct smbdirect_recv_io *response = get_receive_buffer(sc);
@@ -1815,7 +1814,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 	INIT_WORK(&sc->recv_io.posted.refill_work, smbd_post_send_credits);
 
-	rc = smbd_negotiate(info);
+	rc = smbd_negotiate(sc);
 	if (rc) {
 		log_rdma_event(ERR, "smbd_negotiate rc=%d\n", rc);
 		goto negotiation_failed;
-- 
2.43.0

