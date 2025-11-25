Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B2327510E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094733; cv=none; b=Xbr0y3pEcPhY/Oi8Cils+iDjhPkdbXE8RikNhqnUB/lvRIROoPkWXL3SjqDm+2hFZ5FnzCBF5Vm6fMn5dNi0itltcnweDPKe46x+8lopmzV1vgSdgmhWYlySclFfbOu2lKeFwXenGj7oJ5iHPRS5kwNN43ZZNO4KdmFssHCLXxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094733; c=relaxed/simple;
	bh=LImuI3SoSmZ+TWOnZXp8F+l4qsUt43Yub4ey6bhMhZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wc696kC0aHoZvIz3etTnsxIyeGa19kyaAOKic0G0X8/KSynp5KVtJ5PUxkaBS444AypzR4hi+Nddf+0Bfon+BEf+M0znHEtbvbS/mNUWIVaA235Y+q7ZlT+voG5Zjw5KcrAMO112Qk+gOBoWVArpleZS9ZcvnMxT/l4vFR3j688=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=c3BgVc4f; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="c3BgVc4f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=NvZExtzgyh791gvhqc5ygnP14QEe5smsq+iq93yu1No=; b=c3BgVc4fLKAAd52uHcpafKArkq
	mVRbk2BfndEWAnq1t9Xkwg7nT7Nntg14+bX5ti6VYp8Iy9rXLU+4ylrXpGJiTETrHNQaLJ3l1/dQw
	gC/iwab7EoPBNIEpALqHVz2hVHXMyi3kEXjOKLeZ4pnVn2TAMavGJzoCQpXflV8VraiF+bysmUWB+
	yuxIBO6WTmckcH34dxuxSqWgP3KDqmm8SYCtZOoKwbMyvhRFyEtCcib9OCOwwgblVFyYGfdET2MYy
	n/dZpLGtjjyqtvFp0VgBjADWUs/trHMhruwfYDnaBWrwrUs6SPpohP9FrK68jYPqM1wvfaGYZQRoa
	xzDrqHULwWXoknRIaNKbL1isJV1NUZjslDECdwzy6Yyu3tgI4nVQVvwhuAovGG5NKvmSje87oa7cn
	yqLD9oNspKfwEb1ODoKdyhmEfWCzzfzE48qrS/XxfENTGHtdcba00dIhAIP5hmDMDryO9ek1JdlBV
	x7903YWkvPuGgp7g8W/VQ1Zi;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxUq-00FeFk-2L;
	Tue, 25 Nov 2025 18:10:36 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 099/145] smb: server: make use of smbdirect_socket_wake_up_all()
Date: Tue, 25 Nov 2025 18:55:45 +0100
Message-ID: <117694f6f28878cc8e48d3043edcca8812fa20e9.1764091285.git.metze@samba.org>
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

This is a superset of smb_direct_disconnect_wake_up_all() and
calling wake_up_all(&sc->mr_io.ready.wait_queue); and
wake_up_all(&sc->mr_io.cleanup.wait_queue); in addition
should not matter as it's not used on the server anyway.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 52cc756aa088..d61c95eca0ee 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -285,20 +285,6 @@ static struct smbdirect_recv_io *get_first_reassembly(struct smbdirect_socket *s
 		return NULL;
 }
 
-static void smb_direct_disconnect_wake_up_all(struct smbdirect_socket *sc)
-{
-	/*
-	 * Wake up all waiters in all wait queues
-	 * in order to notice the broken connection.
-	 */
-	wake_up_all(&sc->status_wait);
-	wake_up_all(&sc->send_io.lcredits.wait_queue);
-	wake_up_all(&sc->send_io.credits.wait_queue);
-	wake_up_all(&sc->send_io.pending.zero_wait_queue);
-	wake_up_all(&sc->recv_io.reassembly.wait_queue);
-	wake_up_all(&sc->rw_io.credits.wait_queue);
-}
-
 static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
@@ -354,7 +340,7 @@ static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 	 * Wake up all waiters in all wait queues
 	 * in order to notice the broken connection.
 	 */
-	smb_direct_disconnect_wake_up_all(sc);
+	smbdirect_socket_wake_up_all(sc);
 }
 
 static void
@@ -419,7 +405,7 @@ smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
 	 * Wake up all waiters in all wait queues
 	 * in order to notice the broken connection.
 	 */
-	smb_direct_disconnect_wake_up_all(sc);
+	smbdirect_socket_wake_up_all(sc);
 
 	queue_work(sc->workqueue, &sc->disconnect_work);
 }
@@ -545,7 +531,7 @@ static void free_transport(struct smb_direct_transport *t)
 	 * Most likely this was already called via
 	 * smb_direct_disconnect_rdma_work(), but call it again...
 	 */
-	smb_direct_disconnect_wake_up_all(sc);
+	smbdirect_socket_wake_up_all(sc);
 
 	disable_work_sync(&sc->recv_io.posted.refill_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
-- 
2.43.0

