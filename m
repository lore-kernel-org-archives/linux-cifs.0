Received: from mta.al2klimov.de (mta.al2klimov.de [162.55.223.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB193E95A4;
	Wed, 20 May 2026 18:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.55.223.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300288; cv=none; b=j+zSPExLC5c71c4i9nsl+/lNbFvhTWRCal0+ndRP4lyTHtzRfRu4b5QBqIjty3cAtOHHXa+Tb5Xpn8DRimv41b/jerwN6QxkQLjDCqCRVXYhc7loPPPYQAGmVB919RFVtx4OUzEDtRJCI5CrpLFQamRo5FISI9WL20jxwSsXtQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300288; c=relaxed/simple;
	bh=yQ7APpg2N/xjxv7bAsQGeGYMUxHAwofoFVW8SqrAXOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1ljvZbQJpbXYfBEv1xnbH0padT8IV/1QG9V66j489pIS+qBGRVBFyJh9rHh7Sn1SWe+xESEcsriBzL44juzfWUeXGIUuk8P/M7kGUJ/l2PAxsdFO7K+v0OubwYNGVqlyNJrkq7eB6EUiPvLXayUkPfPKC4uIfcUaKGAqEEn7bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=al2klimov.de; spf=pass smtp.mailfrom=al2klimov.de; dkim=pass (2048-bit key) header.d=al2klimov.de header.i=@al2klimov.de header.b=uAMfyZ19; arc=none smtp.client-ip=162.55.223.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=al2klimov.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=al2klimov.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=al2klimov.de header.i=@al2klimov.de header.b="uAMfyZ19"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=default; bh=yQ7APpg2N/xj
	xv7bAsQGeGYMUxHAwofoFVW8SqrAXOI=; h=references:in-reply-to:date:
	subject:cc:to:from; d=al2klimov.de; b=uAMfyZ19xES6CCUHbbTupgap1Ca3ICWv
	UMS20a8S3stCSiFx87Q3YM1j2CpcBQsXs/VAhGhesxU2PPK0/eXWxS1TC/sqtpUjTywcaE
	yBkfJCa9HQFuVGgiUhFGKLtWkGRJ7V/Ph5TZMhCIDGQzfzf1Zs2RGk++F7NEN5p2DF5GKk
	hS2o1MD3/ZW9Kcfe0SWrlx2T6TCH6ZGURfHUw2/Np9X2pB46ZwVC88uZwyVA2fyookSvDY
	owLVCfcbT04krHGenjFVkBXVuL0tA4tHppha+wbJuPv/nOOktGR21mlL58YKHp72W3s+Nb
	5C1BODsvGIHU4a1JM5qsVEkjL3S5Hw==
Received: from cachy-ak (2a02-2455-18e9-e011-4d8a-aad2-c25c-50e5.dyn6.pyur.net [2a02:2455:18e9:e011:4d8a:aad2:c25c:50e5])
	by mta.al2klimov.de (OpenSMTPD) with ESMTPSA id 75beef99 (TLSv1.3:TLS_CHACHA20_POLY1305_SHA256:256:NO);
	Wed, 20 May 2026 18:04:45 +0000 (UTC)
From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
To: Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org (open list:SMBDIRECT (RDMA Stream Transport with Read/Writ...),
	samba-technical@lists.samba.org (moderated list:SMBDIRECT (RDMA Stream Transport with Read/Writ...),
	linux-kernel@vger.kernel.org (open list)
Cc: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] smb: smbdirect: divide, not multiply, milliseconds by 1000
Date: Wed, 20 May 2026 20:03:58 +0200
Message-ID: <20260520180401.539215-2-grandmaster@al2klimov.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520180401.539215-1-grandmaster@al2klimov.de>
References: <20260520180401.539215-1-grandmaster@al2klimov.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unless smbdirect_connection_legacy_debug_proc_show()
wants to debug-log keep_alive_interval as microseconds,
a magnitude higher precision than available by the way,
keepalive_interval_msec should not be multiplied by 1000.

Fixes: a93b68d46e14 ("smb: smbdirect: introduce smbdirect_connection_legacy_debug_proc_show()")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 fs/smb/smbdirect/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/smbdirect/debug.c b/fs/smb/smbdirect/debug.c
index 05ba7c8d165e..3445843445bf 100644
--- a/fs/smb/smbdirect/debug.c
+++ b/fs/smb/smbdirect/debug.c
@@ -40,7 +40,7 @@ void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
 
 	seq_puts(m, "\n");
 	seq_printf(m, "Conn keep_alive_interval: %u ",
-		   sp->keepalive_interval_msec * 1000);
+		   sp->keepalive_interval_msec / 1000);
 	seq_printf(m, "max_readwrite_size: %u rdma_readwrite_threshold: %u",
 		   sp->max_read_write_size,
 		   rdma_readwrite_threshold);
-- 
2.54.0

