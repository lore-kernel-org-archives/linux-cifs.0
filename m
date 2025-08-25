Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B17828688E
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155144; cv=none; b=TJ8ETGDsSUuQr6Y3cMDkUL0T79sxi+IQh5Bi604W/JohojR+26693h3zOWxx/tsEHZSi24WJIcNv6sN8QCGF5n9BUDfkO+Nutq+pRXt0RXKyXoYIkeIUPbXk1qHsj2dALsZusQ3owleX5tgNfH+VGKtp/NswTFTYrHt6ASjfNmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155144; c=relaxed/simple;
	bh=ZUtdfINheXE8tyfFR2HR4eNjGXDteBb5uNo0Efq4bZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7lnjP/dOLd1/UoKitkY8FRZEeH7GyQj9IysXu2jUBWBrs4YwnMwUqw78fu7rXkLzlKxR7rZhJzYjU85I/8XJ0LVkIAI6etMzzABV9tT7Dif2jzA5BDt5B3n4j6t5pX8PxH8dxzUCwI1C7JpPmzXe7vDnrGmmkGTuVAZyKNQAPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MFXa8hk6; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MFXa8hk6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=+1PvEAXB1OcAjywS4RUFc4FKgORPF3OYnxND+tEuJSE=; b=MFXa8hk6uibXA+7oxTtapRp6bh
	VzJBauGA+IyTaqQ2Ak7FYrMr5TF0QEyDo9EVQjDmIS530HZ9VQ9TJ+E9PFGQV0oym2ubQW3rASGek
	acTORq9rrTC55ygE7R9wC6UgY5X4yMTEJlwGJyrpZsBWkn/+7tJEnRH3ktHTusPaZqc3ZYUEkPHKa
	jXL4uWov98DU4nKowEFVtYbNCYtq0GEcEbVu12wWskG7YJjWWh72FqtIPk6xXnxDU3txlQsb/jXsK
	4C+lmD1o4/dfBHFDwubSONkKA7snJAOwTpsbG5znlJhJG+4Tzdznn0yx+H+A1vL4lbTlLLc2f8aqb
	zXpRyNwo346G/5/zPUl9qaVEvC+6VQ00ihyPH2oj1w8i8aNoE/Pz3ESANob5W9oLTlW8gafgnA5x7
	4HZ3OO/8IPCGVqyGzvfF6KCi5QrXhe2jrj5GQWqu2pxUlKAy3ibwcmKywpCDtN0xUtsGh2Gbdan6/
	Ib8zcs4xy89yXiKan8syxan3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeAu-000lK4-0K;
	Mon, 25 Aug 2025 20:52:20 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 063/142] smb: client: pass struct smbdirect_socket to smbd_post_send()
Date: Mon, 25 Aug 2025 22:40:24 +0200
Message-ID: <a0b3ab48a8ccdd8ae68ef080002753cfdbc6b19d.1756139607.git.metze@samba.org>
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
index 148ba5449b66..552eb3d29dfc 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -957,10 +957,9 @@ static int manage_keep_alive_before_sending(struct smbd_connection *info)
 }
 
 /* Post the send request */
-static int smbd_post_send(struct smbd_connection *info,
+static int smbd_post_send(struct smbdirect_socket *sc,
 		struct smbdirect_send_io *request)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct ib_send_wr send_wr;
 	int rc, i;
 
@@ -1107,7 +1106,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
 
 	atomic_inc(&sc->send_io.pending.count);
-	rc = smbd_post_send(info, request);
+	rc = smbd_post_send(sc, request);
 	if (!rc)
 		return 0;
 
-- 
2.43.0

