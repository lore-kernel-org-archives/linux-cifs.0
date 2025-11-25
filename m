Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D68632BF32
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093530; cv=none; b=uNDBF7N5ILK11AHL3X8rLJGpF1JSqmL0no5e0PbqAXoiUigoSNkdIrIdVozTtKLaSxYPFPIF23gy6f1D7WvJBiTjwob1kzs/S3TiRdvqV5h5PtAq/J/e0dY8+jcBWXCTMYmspciMFOVJFUAqEAC9hWtdjjrik/STwRbAIxplZUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093530; c=relaxed/simple;
	bh=+mY06DdkuYqcPF2+p8G5Y/yjj7sE7wzD92qC4oltiG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuMNpE6auAd540pE3tNvkBPwvn9VTwqzivPxi5i6MZPfHFCmQs/cn9R/As4yeYzt3yhewDa5bc2wk4zklfeYZvcgeIIphsFbX01ruMadNBf3IJqRIfBpr/j8nL9jdiOA5Xm16nGj5VID3M5d2j9A08mufst7/sqIXzHWIYmeSbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tmb/b9pC; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tmb/b9pC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=/nmrFopcBFu/CiIRR8O6DD/+7yBidxHrwdPAAiVXnuU=; b=tmb/b9pCooSxYzbdHbp0PgJSWs
	ZYSVw0UdeggjuMH78ZSAxOQO1+d69XvT+BFQHUIyfqXNTjjpbU4RqQSFPmWdiajdnasAS7FBrg84K
	uKLqm/e2E5BuK5xOQqCJiHQv3bbtcglNUuhFrOfHC22CiZhVNpr412yIU+AiBtNxVXMc0Ns1H2iVG
	gQkziWAWC2L2KJHLRpQzlzLL5UDsGnd3/ioPNaFAuI542LIrqdMXecctuQLajiZYAFQrYGXo+mNAT
	0i4g9l1lQIg2j6zYMZm8Trekq8f8POSSK+BE0fSRrmbpsMZH8v8BSPaE1c9+C3kGdlwied+ssjTdp
	TRmEuDz+r3dDEQsP5GI02LNyMDZwG4ZE9LuUmMlDIREqdbJnOccKIs8u/z5kOxb+JfiEBWntCPc6n
	0jq9tMjXUaPGRhbeawb4+goB1+dPlq+6FsSdenqzt9Zz127REYKcXda15lZoz8ojnjqxM9JpKDRsP
	mtbO8L2DbQErHJu5IY6I7xGa;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxJN-00Fcnz-2y;
	Tue, 25 Nov 2025 17:58:46 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 021/145] smb: smbdirect: introduce smbdirect_socket.{send,recv}_io.mem.gfp_mask
Date: Tue, 25 Nov 2025 18:54:27 +0100
Message-ID: <78c571cb638f0e308a06e1c4d8eba55ebbeccf93.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
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
index f56f2b037a69..5564cf9d999f 100644
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
@@ -481,6 +483,8 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_DELAYED_WORK(&sc->idle.timer_work, __smbdirect_socket_disabled_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
 
+	sc->send_io.mem.gfp_mask = GFP_KERNEL;
+
 	atomic_set(&sc->send_io.lcredits.count, 0);
 	init_waitqueue_head(&sc->send_io.lcredits.wait_queue);
 
@@ -491,6 +495,8 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	init_waitqueue_head(&sc->send_io.pending.dec_wait_queue);
 	init_waitqueue_head(&sc->send_io.pending.zero_wait_queue);
 
+	sc->recv_io.mem.gfp_mask = GFP_KERNEL;
+
 	INIT_LIST_HEAD(&sc->recv_io.free.list);
 	spin_lock_init(&sc->recv_io.free.lock);
 
-- 
2.43.0

