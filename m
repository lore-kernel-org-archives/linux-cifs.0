Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5677E2D63FF
	for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 20:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758227803; cv=none; b=NNRfajy3Sd1mJhZ3iGkzIeA5n2oJj0NqJza6zdEFGhD5tgk217f6c3j7shnQDcSoezzTvVh+sVMw5KmtbEjGHGXLmBOyTvN0AWW40pWs3kmOD/2F2Pk3tNfcFtzC0As7tb+BMMerJQThzz9SZh05i+RSnssMOlxoPEHTIUZr5B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758227803; c=relaxed/simple;
	bh=TSdaRln+T2tMTo7y+h8rFasDb05tB02xbsFLL8MJJlk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kdA/XAaJTVgZZqIepEuwlwQACloMeE90Of11bwpTHDVmxOnTgszlj6dVJ4BIBe0LYdOjxruudpeBbZrZDWhZDGvFU1JI/38BxUUcVziNQ3vazD7ViDONttSWyG3CWVFRk/HBv/OzeF6kRgi5fitkDQFuqjkLL2LcngDlUR5Iyi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=E1fF4Ly7; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="E1fF4Ly7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Ywm9q/Q8tEjjpzE6rv35qhNDMxqqhYr7kn0Jp3aYSYM=; b=E1fF4Ly7ZoLhxpzKUH12dKjvCM
	kqQaWjMqrxAEXwbPrQLsLl5zWNGn3lfbb/E5+8ow3IopRw2vOBv+h9DmG6Qwxc5bbMREj0p/5DbQz
	YP1hQ97iqAudtTkiK1dSx6V52tk35C4p3idHRGyE9lm/jcguRfsRtWkXbAcciJ58BzLkTv5QKnlSO
	viOyYXn0JLi20PTH7YPjjo6o3OGCAsvVRgvDVuBA95Mcgl7F2ucsSJKgG1j69EqwqG4PZBOBXbqwq
	z0Ej8DqER/O27tFl84NLsNOrU8C69y/LL+y8yorawP5jOEmm/IuMUF9YoysSSlSoYboSsKMXMuxfU
	nGU2uI7d4ndrGgTbUAv1GeBpiC9ZYpfrnMLbZQDKLC6ALmYIYIE1wVGSwZGcy5KE9PFgYtrKGxO+Y
	I79UtwUxREtKLPgJJnPrdGVsV2gEKG7A7vjN5rU/B+131NhHC0ReQ50o31+ey37RivN8PWxBZNS8V
	4Vvj2ZfCoz3VKCdAUWRQQDyb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uzLMs-004okF-0T;
	Thu, 18 Sep 2025 20:36:38 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error path
Date: Thu, 18 Sep 2025 22:36:30 +0200
Message-ID: <20250918203630.1390057-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During tests of another unrelated patch I was able to trigger this
error: Objects remaining on __kmem_cache_shutdown()

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 001224d31e0c..6480945c2459 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1189,8 +1189,10 @@ static int smbd_negotiate(struct smbd_connection *info)
 	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=0x%llx iov.length=%u iov.lkey=0x%x\n",
 		       rc, response->sge.addr,
 		       response->sge.length, response->sge.lkey);
-	if (rc)
+	if (rc) {
+		put_receive_buffer(info, response);
 		return rc;
+	}
 
 	init_completion(&info->negotiate_completion);
 	info->negotiate_done = false;
-- 
2.43.0

