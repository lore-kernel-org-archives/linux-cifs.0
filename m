Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5913A3E78;
	Wed,  3 Jun 2026 08:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780474565; cv=none; b=IiyTDltCnKBWzPEkxd0Kc2T93AXmnEiKhYdOM/k2NAcZo4wOijix/MmF/aUvIj6LfEeEa++/3qUpWawu2lZtU6DYhkl3kTSuVvDWMoWiPvuEj6pCxICkiadEOWCTXUevtHyt9u7Svl6HtnOWs+jbFr6lwRgUUo6JUvrSGOjNVA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780474565; c=relaxed/simple;
	bh=RI6YeFlGQAU6vP+RRBx8i7uMtfZLp5nlvHZnFb3vAFc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nqGDFYdNvxE2aXYW7hCabCZoZDLzKH7YuQOFrevRYrKrv4HnuDyxIfCBaenG6lVj9807BLPS3jj5ATZHFXUI0CqD7w6JOOZRV8yChQq1agbYBz7gVgt/bFyM3seUaWVqkB6TGuBouknXwuLlW7cRO/0V/DMSDkhi5niZAGAQcPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=BCTz1VQ1; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BCTz1VQ1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=9w
	oouAF0An6oG2I77wAgtnEo0aT0iRBw0iUrbijYQKU=; b=BCTz1VQ10iygThUmhr
	iBoec4z8tor/KhJuEK22qa3krofqBPmUsfwi9YHvFi7wubS+gVQs9TEaS06RKZM0
	yhqM3GxFTyfvx0e87QKa9ZpKNqGv5ejAO6+wmwvHBdgMntMotilvmvuCG8ss5ZxC
	P3kbXcU0zNzjH+r8CCdGhqqNU=
Received: from pek-lpg-core5.wrs.com (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3Mm2N4h9qv_h5BA--.18235S2;
	Wed, 03 Jun 2026 16:15:10 +0800 (CST)
From: Robert Garcia <rob_garcia@163.com>
To: stable@vger.kernel.org,
	Stefan Metzmacher <metze@samba.org>
Cc: Steve French <stfrench@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Pavel Shilovsky <pshilov@microsoft.com>,
	Robert Garcia <rob_garcia@163.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y] smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error path
Date: Wed,  3 Jun 2026 16:15:09 +0800
Message-Id: <20260603081509.2027062-1-rob_garcia@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3Mm2N4h9qv_h5BA--.18235S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar17JFy3Jw4kJr4rtF17Awb_yoW8GF1kpF
	ZI9wn3Kr409r4xCwsrAF18u3sxWF1vv345ur4UWw4xArWFq345JF4Fya1vga1UKFWrKF4f
	XanFgrWrG3WjyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pETa0DUUUUU=
X-CM-SenderInfo: 5uresw5dufxti6rwjhhfrp/xtbDAQ4+qWof4o6+YwAA3c

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit daac51c7032036a0ca5f1aa419ad1b0471d1c6e0 ]

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Robert Garcia <rob_garcia@163.com>
---
 fs/cifs/smbdirect.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 48bd879349fb..c9bda34fd2f5 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1084,8 +1084,10 @@ static int smbd_negotiate(struct smbd_connection *info)
 	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=%llx iov.length=%x iov.lkey=%x\n",
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
2.34.1

