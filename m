Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040CC29CB48
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501822; cv=none; b=UV8FlcuhA3T/6aq71GALyXHR6YO/BGkX1UvuTE5Yal1ytGWncNMqikF+1761U8L9N5kZ63X2YhYzpm0l+vnWbcjbok/sr5SY7xF7ApmiaFhnXC2pk/XHR439FGq77gKfC55+LuObQIZyo004RZfIlt7uzGb4kNqFT0Dwf3qypSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501822; c=relaxed/simple;
	bh=1otCKvRc0lttDnbqhESXQcs31xGi+89OmFJIxynfu0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVm25pMIf3k9ES40MEF6TE9PUT7ZF+tXG5Ho8LL8p1WP+yTjnRe34Hqyqy4/xquOPhcr5ci6baEnrOtadKmjyTuZAMFv7gvBEhv2QGdwT9VIWTypZLbfIJQVq+cao3SuPxMSXBrUw/SzZ8V3Oru/38Nguz/4SUFMDyiceotoKhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=arDByWan; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="arDByWan"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=pNm6YCD26g+5a8cfwPiXSQbw6NjKF3azrhMMXQFPv14=; b=arDByWanDn17VOu9Kx0sQT+orT
	PjJZ6+170+MhS+81bdGNZ8xdfVEMAP3njlbtqPaJmao0lfv4VqlcSvI0x7UHqSW4PgqOyfQ6ZMNQI
	apt8ihK4MiK/x1upF96lsh4ha5xiUBvpVIhYnmMiEky/3rS2acUbSLhFgEDCW8lKBU99hRDfT5UaH
	lfUUsL4ng4fNihko1g4jLMyKnJW3Tcb/6r4d+JyJVUSF+F7amwdy2HbOsTi2GtjFoCD+JmPLo/L+e
	2sGQGugzmwyDkaIAzKNaqh1gQB/U6v7kRJXZvLhOXG1M/XFluHpV2FAeGgIY6jjphKM6915gZT4x4
	i0BZQtAqYbv4R5jUzEwOyY0tVSVdGzypvchONJfsAySC2J2FP0mlpaj9EzQbdsAUWd3V9BITvUAi2
	SuHxKz9a2as6xaBkaxWlRa/fe4mOb+4iy6fwaYcieIxzwen3awBCqoR3635mETrdRw0E1g26S8zIS
	PxOMKz1k0Gz2YZOKKg3TcWem;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uji4P-001OZG-10;
	Wed, 06 Aug 2025 17:36:57 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 06/18] smb: smbdirect: add smbdirect_socket.{send,recv}_io.mem.{cache,pool}
Date: Wed,  6 Aug 2025 19:35:52 +0200
Message-ID: <dbfc561167f09c006e80c55b5e20c242723403c7.1754501401.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754501401.git.metze@samba.org>
References: <cover.1754501401.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be the common location memory caches and pools.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 4660c05c358f..3c4a8d627aa3 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -39,6 +39,20 @@ struct smbdirect_socket {
 
 	struct smbdirect_socket_parameters parameters;
 
+	/*
+	 * The state for posted send buffers
+	 */
+	struct {
+		/*
+		 * Memory pools for preallocating
+		 * smbdirect_send_io buffers
+		 */
+		struct {
+			struct kmem_cache	*cache;
+			mempool_t		*pool;
+		} mem;
+	} send_io;
+
 	/*
 	 * The state for posted receive buffers
 	 */
@@ -52,6 +66,15 @@ struct smbdirect_socket {
 			SMBDIRECT_EXPECT_DATA_TRANSFER = 3,
 		} expected;
 
+		/*
+		 * Memory pools for preallocating
+		 * smbdirect_recv_io buffers
+		 */
+		struct {
+			struct kmem_cache	*cache;
+			mempool_t		*pool;
+		} mem;
+
 		/*
 		 * The list of free smbdirect_recv_io
 		 * structures
-- 
2.43.0

