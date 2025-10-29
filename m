Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC76A230996
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744265; cv=none; b=qLkqwCIVWIvk3umlyyYdLv+7IJZrO/eKf+0r3wEDOj+I8eQLsg2w4LjAS2ZQ5Qvg4bK8hwiVVf3dC0CHb0PkWCZUGtedRdjPA3v6bBJRRZD0qLdeZaNlYZMpp7POIG5PvpxUfRs8Ax2lR3qOK+3X3bnkIRHSND0VJGP87+as6tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744265; c=relaxed/simple;
	bh=a31B9SQy7UgO3wO+tl63iJXsbufoqUpEeyB5oqVu/C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDu7suVW3L5IwqWvXwQ8y7fxfZayn5SzJ05ZncPfegkUKn8Wgufu1FFW7RHFD0rKdwZRvU3L4rjMsUKjfDaECjtcMsibfQ2gJ/71TXhwmsZSZjDq7XkAjQUidItFkRx1i3YwqfxSXlPGUjPAsjTkFcGBUURsZVNNJpfhqxaZ6ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=KWVwjW2P; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="KWVwjW2P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=K22/MaNUFQMtuynkcFYrSuOsdhjg8smb1dCQfW679i4=; b=KWVwjW2P7QPGYdndXczp7YOH4T
	dHGhmV4PyNiJo29YyXteZnqqyYgg+VCIy9lVDjHXD0RfNNkfIxC5MFsmLXp+f2oUK2Yod/UDULjT8
	kMTStFyoRGKDn4FHdr9jCDuvJ4Uti271N/Hm/QRRkEnGiVMJVYBEMbR7S/kjHXAynIK+UG/siOsd7
	p/yHq+I71GCtsoeCUIHTu0/d866p6bzwm+1Kr77wjaygs3AN7YaKga3TvQc1OOcM5+2sVFzsrkogq
	JXiHwEuUXnRo0FOBhTtnd5X+tUJWCL1e5bokxO3b862QbrUEfVczWmcODWrF+joyMC5X3Kw3O2YRc
	kkA7Q+k0d1wvdxMcJpzKE551WTwezDopUAYZ4r2KqUcokCkdHJN/MkjH2gPSXTWu68YPMAVFys81F
	XfaI45LU0wb3YipcJ6kUuNgeHKkV8uIfD99y/0QPNmpP1DJTg4w6M5xfmLeoziGQD9PAdkMBeN171
	ShfYJMbpayXBj+eGbwj9npXe;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE69y-00BbTS-0n;
	Wed, 29 Oct 2025 13:24:18 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 018/127] smb: smbdirect: introduce smbdirect_socket.{send,recv}_io.mem.gfp_mask
Date: Wed, 29 Oct 2025 14:19:56 +0100
Message-ID: <07585615abd50502f1ef6a21d2dac4c04f6026a6.1761742839.git.metze@samba.org>
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

This will allow common code to be split out while still using the
gfp_mask currently used.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 65b21b65596f..a25bf92cfff7 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -150,8 +150,9 @@ struct smbdirect_socket {
 		 * smbdirect_send_io buffers
 		 */
 		struct {
-			struct kmem_cache	*cache;
-			mempool_t		*pool;
+			struct kmem_cache *cache;
+			mempool_t *pool;
+			gfp_t gfp_mask;
 		} mem;
 
 		/*
@@ -204,8 +205,9 @@ struct smbdirect_socket {
 		 * smbdirect_recv_io buffers
 		 */
 		struct {
-			struct kmem_cache	*cache;
-			mempool_t		*pool;
+			struct kmem_cache *cache;
+			mempool_t *pool;
+			gfp_t gfp_mask;
 		} mem;
 
 		/*
@@ -479,6 +481,8 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_DELAYED_WORK(&sc->idle.timer_work, __smbdirect_socket_disabled_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
 
+	sc->send_io.mem.gfp_mask = GFP_KERNEL;
+
 	atomic_set(&sc->send_io.lcredits.count, 0);
 	init_waitqueue_head(&sc->send_io.lcredits.wait_queue);
 
@@ -489,6 +493,8 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	init_waitqueue_head(&sc->send_io.pending.dec_wait_queue);
 	init_waitqueue_head(&sc->send_io.pending.zero_wait_queue);
 
+	sc->recv_io.mem.gfp_mask = GFP_KERNEL;
+
 	INIT_LIST_HEAD(&sc->recv_io.free.list);
 	spin_lock_init(&sc->recv_io.free.lock);
 
-- 
2.43.0

