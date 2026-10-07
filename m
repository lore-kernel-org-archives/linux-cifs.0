Received: from cvsmtppost36.nm.naver.com (cvsmtppost36.nm.naver.com [114.111.35.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC9A3FC5D0
	for <linux-cifs@vger.kernel.org>; Wed,  7 Oct 2026 06:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791354660; cv=none; b=RBTjliumFrUtGN4uHQxpGirpHfPbKe9T4ua4RQQd6/nReQB3TCbAeFc/xOWuDyZOK2DtkbyuhG847Il19VKJSK5V7QVlC354kXpc5hZ3p55/2Jvzq9Psn1xujPxNGVtHnBr/82/nt5BBgll8v55P/xeEk++s+Pm4kiP1FcLOhg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791354660; c=relaxed/simple;
	bh=T4i73L7GmIUaZ/gPHNRG79AoL8uAkrOpDu+Y+uFKZ7o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=siObYjn7hxsWwSfeadXX98iUD1GUgk03gHvedIkiOcSybvSAbjmQX3hTsDESUdRAUSWaYrAp7CvByfoQ7+j/dcUMUTrqhLEBCXpgnfcS6VOMV69ut2GpAOsrgDjkHnOhqVJkfF+5cskS0geN63AD3qZiBhVpG/GG838YhVEWmog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=d5kAA9Of; arc=none smtp.client-ip=114.111.35.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="d5kAA9Of"
Received: from cvsendbo019.nm ([10.112.22.34])
  by cvsmtppost36.nm.naver.com with ESMTP id LXGrfePoTyKp601lbdjL8g
  for <linux-cifs@vger.kernel.org>;
  Wed, 07 Oct 2026 06:30:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791354650; bh=T4i73L7GmIUaZ/gPHNRG79AoL8uAkrOpDu+Y+uFKZ7o=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=d5kAA9Of3Q9rZlO+s1xA6QCz6eMhZjkjz1m+6RPl+mZwgH6MyIUfssEDyYGmHwDRk
	 pQvKy6Olu2r2KwLEbvwmEiM1GANg3WHf2aSIcIQP6ALrUJQiR5TFckm+JKXZJ/9va4
	 3iJnrkOre/sAWrzUpHFavBpjwhL25meWBHS9iRq0HQx0KGn5OUxqrePM64Epnaf1yC
	 hdrWpyPdWT+ZYq9Vc3Ppr+0On1noUAmiIt8M+wNHz12TW5CJPYF3YFSaBBBnXX5HrU
	 4X2+JeNBuun6gzdpGfU6POVNB7JqqU8ycKebBZIf1jrSaQNOwdPrS48O/3AGMlpETi
	 KxYvljoPAggtw==
X-Session-ID: 0m0KPmO1SfCfAee-BA4MXQ
X-Works-Send-Opt: OlewpzGdjHmdKHFOMr39Ko3YKHmqjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: XwbZKqulFqJZ+HmmFxUZ+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp007.nm.naver.com with ESMTP id 0m0KPmO1SfCfAee-BA4MXQ
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Wed, 07 Oct 2026 06:30:50 -0000
From: Sung Byeongchan <tjdqudcks0424@naver.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: hold TCP session for async decrypt work
Date: Wed,  7 Oct 2026 15:30:46 +0900
Message-ID: <20261007063046.26260-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Large encrypted reads may be queued to the global decrypt workqueue.  The
work item stores a TCP_Server_Info pointer, but does not hold a server
reference while queued.

If a multichannel mount is concurrently reconfigured to remove a secondary
channel, the final reference can be dropped and the demultiplex thread can
free the server before smb2_decrypt_offload() runs.  KASAN then reports a
use-after-free when the worker accesses server state.

Take a TCP session reference before queueing the work and release it after
the worker has finished using the server.

This was found by source review with AI assistance and reproduced twice
with encrypted 4 MiB reads while removing a secondary channel.  The fixed
kernel completed the same workload without a sanitizer report, and the
ordinary encrypted multichannel read control remained functional.

Fixes: 35cf94a39728 ("smb3: allow parallelizing decryption of reads")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
---
 fs/smb/client/smb2ops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 583ab4c4d7738..941e6163a58a0 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5305,6 +5305,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 free_pages:
 	netfs_free_folioq_buffer(dw->buffer);
 	cifs_small_buf_release(dw->buf);
+	cifs_put_tcp_session(dw->server, false);
 	kfree(dw);
 }
 
@@ -5384,6 +5385,9 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 		dw->buf = server->smallbuf;
 		server->smallbuf = (char *)cifs_small_buf_get();
 
+		spin_lock(&cifs_tcp_ses_lock);
+		server->srv_count++;
+		spin_unlock(&cifs_tcp_ses_lock);
 		queue_work(decrypt_wq, &dw->decrypt);
 		*num_mids = 0; /* worker thread takes care of finding mid */
 		return -1;
-- 
2.43.0

