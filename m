Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128AF233D85
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154696; cv=none; b=pW2yrCNPthrhHt6sUbKEupAubfloqCpSXsj8FAaaoiNLW+s8libfLIM7cJCcQr9QbjY3FIizBdozADTFXj9McJ2E0YNYTdykAKeakqNpjSrsUp8M+s100HSgXi6pQGgwDHquGzG9czoK6/PIV4zt8WZz29carb9H1bNgVNdK10U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154696; c=relaxed/simple;
	bh=x7VHUhLBue9eZixWGj1hcXd6+f3EYgVY+dand+v1Zg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvMGlvKjqDI9wY3+cydKK3U+lSapuKEjrPferY2gsIodY5AToFa9daB04wNYt0nqMZoi1OsNe3hiokwBKeqfMiXNp7S4HGlXAbZ3M3RLL5W9vvzg9OWum6qJFA82OOCKx7x6rKFLuNX2iFIVG2LHHzZ3UpZpr3RECZcaHUy8QcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=I4OVhvIF; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="I4OVhvIF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=5BqCYUrpiEon8qgR8F8WUh1vay5qHy1gvlrxclPA6dY=; b=I4OVhvIFsaE8cvohAWGYIUsrvN
	UD6x+68Pp9iwoCI73qpSt2zuL8NaP4LHM4IOm2LTJwuxVqUBCYbGiJxa9LOjCT3ioFGELNSSd8XT7
	NzDrAn7SvUyu4PpC+c5cpRjqXFuCDZMfKMDeukZR7KSUJ9dJk7MNfbrQlJ3zxyhdl+253mdbWmw/Y
	7C0dOOLtZkfNYTeRM6KRrO9uVEBbR+F0aUF1XTY2xxcFufRv7XZO3oRnxyhtPRDqV3Hnph1yHCVtf
	Rej7lhDi17lhLVkeSl+Zu5vw79mj/DeDC965JH4/kCH8R/ZRu1Di/d2c56+ycQyNHFlDcoIZp1eKz
	V3+p01YH6V0obLhX27w1suM+8bBMr2OYa0DyaSVksW8Y2OQKks0qFdMbLvEMPcCnCIEVAdaaTLyM0
	Us+4UK+lw9QKL1W0/qQpuK+T9V7wz+2YiBe8V46PhhAf3PqMX1P1nRG7wxmwn4KqHk1PncgLqJ3KU
	WT8lR4p3KRaHgSohAcUogGqC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe3f-000jkP-36;
	Mon, 25 Aug 2025 20:44:52 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 018/142] smb: smbdirect: introduce smbdirect_socket.mr_io.*
Date: Mon, 25 Aug 2025 22:39:39 +0200
Message-ID: <5d6750d0fc47f974e356beb43f43d7cd7dc62e6f.1756139607.git.metze@samba.org>
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

This will be used by the client and will allow us to move to
common code...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 588501a0a706..350ccb362718 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -176,6 +176,44 @@ struct smbdirect_socket {
 		} reassembly;
 	} recv_io;
 
+	/*
+	 * The state for Memory registrations on the client
+	 */
+	struct {
+		enum ib_mr_type type;
+
+		/*
+		 * The list of free smbdirect_mr_io
+		 * structures
+		 */
+		struct {
+			struct list_head list;
+			spinlock_t lock;
+		} all;
+
+		/*
+		 * The number of available MRs ready for memory registration
+		 */
+		struct {
+			atomic_t count;
+			wait_queue_head_t wait_queue;
+		} ready;
+
+		/*
+		 * The number of used MRs
+		 */
+		struct {
+			atomic_t count;
+		} used;
+
+		struct work_struct recovery_work;
+
+		/* Used by transport to wait until all MRs are returned */
+		struct {
+			wait_queue_head_t wait_queue;
+		} cleanup;
+	} mr_io;
+
 	/*
 	 * The state for RDMA read/write requests on the server
 	 */
@@ -236,6 +274,13 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 
 	atomic_set(&sc->rw_io.credits.count, 0);
 	init_waitqueue_head(&sc->rw_io.credits.wait_queue);
+
+	spin_lock_init(&sc->mr_io.all.lock);
+	INIT_LIST_HEAD(&sc->mr_io.all.list);
+	atomic_set(&sc->mr_io.ready.count, 0);
+	init_waitqueue_head(&sc->mr_io.ready.wait_queue);
+	atomic_set(&sc->mr_io.used.count, 0);
+	init_waitqueue_head(&sc->mr_io.cleanup.wait_queue);
 }
 
 struct smbdirect_send_io {
-- 
2.43.0

