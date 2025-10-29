Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC1F263F5E
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744584; cv=none; b=jzRZ0yCr9Z6krXW4EFCW47iljZDWKoH9laRdafGg3H6Njb6DMW5JiM2Bg3Rhy4n4MQAvXw6kpT4pVwnypkBsb3BeEXrc1I9n44Na1ff94YAby+9YWu+mBVEnVlC4vPHDhlMobhfJij00fU9gqkXO7a9k823Oz8RnjPIsO9pTj8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744584; c=relaxed/simple;
	bh=WDDWfSHjOejKYoYI3fa3Z+BsphsjonNWDmpByr8PSlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBc4SI7FNBBJD0i2lWKJ7VzRCOQ4xBzKGpts6VzdUvNAyp1dmooKBefLQoPqrE2PTn5ZD38kv9oiyf23v7qwr6DwFwdY+KBuNs9XoZ9n4DFvWM2l5pid4jTFrOqViCmI8cgdVDOXexWNgKrjHLLQfk5phipcrDzijWEFMUuzHh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=EkqQsy4R; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="EkqQsy4R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=AMLNWWKURVS85TGG02f4PAk+Si3h7n55+l2qCtKWvcE=; b=EkqQsy4RcWC5uVDt68Qt6CpVzw
	vUcd9jmut+gyJj3keyooEipiwBsCa/6LUZjjEjw8IipUchsivdGwIkJ5ovMYMZArwiAFLu1RVafTT
	GTE13d1EosZCIfdSUzEWaAto8oVZwMRbSJugdrwpbABCJd9UP7OB4lcbimV6Y/orTSaLuYt5xLpJ0
	VyDAotKHLWZzDiClMs0EKMz6ZsVrnf26gzaWPehF/sTM0OyRaAWyIjVhk2h9kjs3u36aMMkuXvetw
	pmH/YLtAvOr/2ZE8R8UVBMNBYjnB1+SgllMavPKMCy4O9FBy6SWP8LjIMCHD9WSudKVkdfFZC3ok5
	4f4I01IatozhPtll2KjI3ey1HZXzz6V2UYri+Ms/5cRV0b+AU2TPhQcISPuUlUrPyWyMWAgiFVemo
	wh6YULPgv9YsBgXXuvJAiiwLiQ9VPkDVIxsNi4IBc3H1wKGrADFddavztoF+GZeracBn6qW5u7lDr
	Y/Kk+WhxS7RAhgUEAYX+AGYO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6F9-00BcHX-1Z;
	Wed, 29 Oct 2025 13:29:39 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 073/127] smb: client: initialize recv_io->cqe.done = recv_done just once
Date: Wed, 29 Oct 2025 14:20:51 +0100
Message-ID: <858013eba1c21c5913c21eff68efab9e9b66b94c.1761742839.git.metze@samba.org>
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

smbdirect_recv_io structures are pre-allocated so we can set the
callback function just once.

This will make it easy to move smbd_post_recv() to common code
soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 59ab8489ad9f..60582394ba29 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1079,8 +1079,6 @@ static int smbd_post_recv(
 	response->sge.length = sp->max_recv_size;
 	response->sge.lkey = sc->ib.pd->local_dma_lkey;
 
-	response->cqe.done = recv_done;
-
 	recv_wr.wr_cqe = &response->cqe;
 	recv_wr.next = NULL;
 	recv_wr.sg_list = &response->sge;
@@ -1288,6 +1286,7 @@ static struct smbd_connection *_smbd_get_connection(
 	__be32 ird_ord_hdr[2];
 	char wq_name[80];
 	struct workqueue_struct *workqueue;
+	struct smbdirect_recv_io *recv_io;
 
 	/*
 	 * Create the initial parameters
@@ -1392,6 +1391,9 @@ static struct smbd_connection *_smbd_get_connection(
 		goto allocate_cache_failed;
 	}
 
+	list_for_each_entry(recv_io, &sc->recv_io.free.list, list)
+		recv_io->cqe.done = recv_done;
+
 	INIT_WORK(&sc->idle.immediate_work, send_immediate_empty_message);
 	/*
 	 * start with the negotiate timeout and SMBDIRECT_KEEPALIVE_PENDING
-- 
2.43.0

