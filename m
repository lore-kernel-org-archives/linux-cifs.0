Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD4D2EA48F
	for <linux-cifs@vger.kernel.org>; Tue,  7 Apr 2026 14:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775573248; cv=none; b=Zo4xR9vmk2TJRM+mu3qGGLoXqAfSHEuq9Nsq170p068WP6qZeiIs776EJpNdXoD09noAVcfhLvUfA3M7dkl2eQA7YXoQYi9QLIaQeaf0Cqnp47VyHp/chCzlxPW8timACpM4kLn8AfpNKv0vQBtIz/mOtTQluXRgsu+ig3i67TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775573248; c=relaxed/simple;
	bh=CrwMUloToJ3c9Pkfe8jLFlvt6GE63J6mLanySCop9qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXxa2se1EIlEMhc+gOnpTmaqYXk6q//wSXW5EjQIBAFEEqi9H9shtQ+Tdiwr/Im1spp/1CBCSXXwEEhB6hajE1eyDioh+rAxkndH9WDITppR/Esvnp/dQhkA1E5Vze8Fd1iWXsC1bAKnugKjiriIxpvSlXfLMTc2aiJTctmwkDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ZhixYXjT; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZhixYXjT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=zekklSUDzJym1GfQf+o36pxNte8IK8yarYqm9s6KeV8=; b=ZhixYXjTPrhYbxe7T5q1VkKrlQ
	VCZdjxOv1myy3vel5F0w7x3+8nA9U2RFwSZRHdqOmYs3tIe5+q/EU+x+pLGqlw6qrcKNwrdNvHIfh
	Q03V1opDzJjrIWfow42QzBkRHFrUF1M1Yx/jBYRycnirlmELpnhOlh3BiKJBkp2TCgYfvgrYYamEo
	hyM/N0ph5ANdAbxWNPun/wkqqmDKEAecUKogEpuTWPs2bvTw4sHnqr/s7THPQ4EV3bbaPLoNxxB15
	xJ+rqQFmFI5GZYTw+9n74X3WdDm0pb5q51vaxvzw7AEyOEHiNCxwvR9YZlIjZQdX2Y0hy/aObuCO+
	YKEjXjatDkwhQVf+fV5uhdm6WkAmXihLjlGG0mRz6xqZuc2WdRJm7t5FWmLGkwjppr+srw1sDyDbG
	KZ/WBwY3Loh/6Wc5JohIYcG5ZeZ4ibupUyFwoEkqzx6vcjoonXVnV3JwvSNm+oBS3yFQauwMFN+iO
	gUZvuYqLqRsSswAsbTvhLz2m;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wA7i6-00000007WPL-1ja1;
	Tue, 07 Apr 2026 14:47:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 3/8] smb: smbdirect: fix the logic in smbdirect_socket_destroy_sync() without an error
Date: Tue,  7 Apr 2026 16:46:29 +0200
Message-ID: <40c6cfe1b94a769eaae3c0f2327469efc8051edf.1775571957.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1775571957.git.metze@samba.org>
References: <cover.1775571957.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If smbdirect_socket_destroy_sync() and sc->first_error was not set
we should set -ESHUTDOWN, that's a better condition
doing it only implicitly with the
sc->status < SMBDIRECT_SOCKET_DISCONNECTING check.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.c | 28 ++++++++++++++++------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 4003753bea26..9153e1dbf53d 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -600,13 +600,20 @@ void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc)
 	 */
 	WARN_ON_ONCE(in_interrupt());
 
-	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
-		"cancelling and disable disconnect_work\n");
-	disable_work_sync(&sc->disconnect_work);
+	/*
+	 * First we try to disable the work
+	 * without disable_work_sync() in a
+	 * non blocking way, if it's already
+	 * running it will be handles by
+	 * disable_work_sync() below.
+	 *
+	 * Here we just want to make sure queue_work() in
+	 * smbdirect_socket_schedule_cleanup_lvl()
+	 * is a no-op.
+	 */
+	disable_work(&sc->disconnect_work);
 
-	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
-		"destroying rdma session\n");
-	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING) {
+	if (!sc->first_error)
 		/*
 		 * SMBDIRECT_LOG_INFO is enough here
 		 * as this is the typical case where
@@ -615,8 +622,15 @@ void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc)
 		smbdirect_socket_schedule_cleanup_lvl(sc,
 						      SMBDIRECT_LOG_INFO,
 						      -ESHUTDOWN);
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"cancelling and disable disconnect_work\n");
+	disable_work_sync(&sc->disconnect_work);
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"destroying rdma session\n");
+	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
 		smbdirect_socket_cleanup_work(&sc->disconnect_work);
-	}
 	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED) {
 		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
 			"wait for transport being disconnected\n");
-- 
2.43.0

