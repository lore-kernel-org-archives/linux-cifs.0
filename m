Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBF12874E6
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744886; cv=none; b=XhW8f+PUbmMxNZsEAJJgb0+zukMBbz3wISlA5QN0eXNE0wXBa8G99JsQj25a2MDAwVx113JYEjQZavvJJZsYmYx6dT3Ux9j6magALdnjFooYXKUnac65aNGCJ+1Dl2RmBhk0RTPccH95UowmPJrufYOQvoUBIy8zpzQsCzbx10w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744886; c=relaxed/simple;
	bh=5cny+e1GMhaTHKGGqVdJR9qDbxIar6N3Fl582Yyn6xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9P1PORNsVZHIPTYu49ZcYm2xN/0d1c6J1TuzdjSx+D+6hcmfsBQA1XxpdvrGibaTlkJooStbnTuANBoelPS25H0XFYUo+HgFptoZdG/dLOSyjgvP7VZlqE9WrAekGLk+O4ph/TiQCUw1YI+8b2aDUFJ/rMi7FMZgxoubiv/GMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=vZb2Xh9a; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="vZb2Xh9a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=sMZ7fW9DbAWU81y4mz49GLom1R+WSFHnSMvDkKcbId4=; b=vZb2Xh9aZWUcqCYzkitHjgLtIZ
	G6v7BHoF2uDE8YayjCgT/7GA8yrk2dw/uWMd+8DwsN5NXRuoW0LZgf+O+jaQCD/wWCxLqXBpjdVLe
	i2LcxNW0If/B5EqHnOxNwvitWRAlsvDBJ2dpAon+QeJ56mSnO0ubZtSp4mGUmYOcTK2o6egvIrTuM
	UeDRPsbImhEZrh2YClPB2flNKNdVJuTZJlLvWgoGwp4Jgx/jZ/A2tCYMEWuciMNdeNWd5P/M9yPVx
	v7J4bpRlZq+sGxSqoyXyIGLUe6Alzr6+Nh49X9YWuk8aSI1HcAvN56dETYWI9Kib+/0cQXqORQ5fy
	Ec2K9Y7I4ctS/pBHLkCMmx2JkFnlp43s/iRl3U38AV2o7taDZ0rJebqFr87V1MWHPpZ1QHdalvAd9
	6ZyyuwV6rrDQtuX6CoXKlqCLFtq1MYH72Dl7gPnKrG1HwuNNwYLsBmeQwQ3GRuWVdgxnqwO89dXir
	mgCP+57NP/Rj8bYFLSWf/9kX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6K2-00Bd6U-2A;
	Wed, 29 Oct 2025 13:34:43 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 122/127] smb: server: let smb_direct_post_send_data() return data_length
Date: Wed, 29 Oct 2025 14:21:40 +0100
Message-ID: <68de896993e35b062dbe77bc86d4d56a2143f791.1761742839.git.metze@samba.org>
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

This make it easier moving to common code shared with the client.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 8a5183426bbb..070c386dd2ea 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -746,7 +746,7 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	ret = post_sendmsg(sc, send_ctx, msg);
 	if (ret)
 		goto err;
-	return 0;
+	return data_length;
 err:
 	smbdirect_connection_free_send_io(msg);
 alloc_failed:
@@ -798,7 +798,7 @@ static int smb_direct_send_iter(struct smbdirect_socket *sc,
 						&send_ctx,
 						iter,
 						iov_iter_count(iter));
-		if (unlikely(ret)) {
+		if (unlikely(ret < 0)) {
 			error = ret;
 			break;
 		}
-- 
2.43.0

