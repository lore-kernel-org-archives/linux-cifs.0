Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A223532AADC
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093591; cv=none; b=jmVNl2reJ6ZjHjwW+6D3M9BOpME8gu7uCHZONCT9z739octJ29jqxg34nzFKIvLfZ7c6jADM/sZ9Cn6SiQKsTxzAMstHtZ5R+wmsFDVuvOThSQYae+wAxVKmsti8nkmz6LQ9b8Oom2uVmf03i4Da1W3q/meHNSKR1dBebUfTIUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093591; c=relaxed/simple;
	bh=DUL3627l2z9jg49CLEseO2AfqXSwTb3jtzL49BG8S6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cO5kZwOFeT5z3ZaTZX4mfkdxcKXVm4UBAxrR9eKKyEucRoARIkkz+6d0YkyLXhLghRc8uJ5eWaJhzhqyOxWCyml/el1Q4qrNn4WCMVjSbKZS+hK6MYOj0o1kp6d60nU6YnSoWmfi7MmBsZx4XFgznzm7+Rt5x7kHlOM132+pI18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nN2zMW7i; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nN2zMW7i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=PTIkaK4R1fwbk1Dbpkhq6l3vtvHNIvp16W4tkyHP4Aw=; b=nN2zMW7isAONuyr7AqQKno3PVJ
	QrogCrAvT+iA9Lkt+kyFAMrcR+EhRQaqJ4JHZwvtBtbhteTr7g3Utx3tQCfyX2BWdgSdLadi2sL3P
	ypJf1b7VgWjs/vK2B2Iq1nGanJ8eHyaJyXilJu8IpmzC54jHe6l0ZB59BBlovg8EgCg0L/yKCVNnK
	l6f2D3M6Hvm8qTKSjF2aIvHQk9msfv4naFJfc6nUXEidqFCnmMYT8tJi+lk6/t6FH/k+fsdMVJu+o
	gHGcy8qQIdOyGtLflTeI9PdDO4LjVRej3fb40gy+ll9B0cCi+L+Anyba5+mh9VbUYodrf4NhRCcmh
	WgcpUeRAZ9D7O5ro6nMcciVP3PbQNTEV5VQE93TPAQa6nLH+V3gXhrifjVCJ3zLvmu2sbhmrvmti0
	OGOJpzQ66L8BNNKjyguRay/dPONykPAl7M6j4+VI6gQAKoILSAZf1trxZyOwFblJKMPSK23jKTJ+8
	/A9Fb0Vlgk5LTXYFjlCwnCcd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxKL-00Fcy7-0g;
	Tue, 25 Nov 2025 17:59:45 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 031/145] smb: smbdirect: split out smbdirect_connection_recv_io_refill()
Date: Tue, 25 Nov 2025 18:54:37 +0100
Message-ID: <55deb09e9d8fd31ac7fa0993b2ec41213434f9c9.1764091285.git.metze@samba.org>
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

This will allow us to refill the recv queue in a sync way
after negotiation.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 36 +++++++++++++------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index f260d50a561b..5c604b6bc853 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -683,16 +683,13 @@ static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 	return ret;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
-static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
+static int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
 	int missing;
 	int posted = 0;
 
 	if (unlikely(sc->first_error))
-		return;
+		return sc->first_error;
 
 	/*
 	 * Find out how much smbdirect_recv_io buffers we should post.
@@ -738,7 +735,7 @@ static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 				"smbdirect_connection_post_recv_io failed rc=%d (%s)\n",
 				ret, errname(ret));
 			smbdirect_connection_put_recv_io(recv_io);
-			return;
+			return ret;
 		}
 
 		atomic_inc(&sc->recv_io.posted.count);
@@ -747,7 +744,7 @@ static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 
 	/* If nothing was posted we're done */
 	if (posted == 0)
-		return;
+		return 0;
 
 	/*
 	 * If we posted at least one smbdirect_recv_io buffer,
@@ -768,11 +765,28 @@ static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 	 * grant the credit anyway.
 	 */
 	if (missing == 1 && sc->recv_io.credits.target != 1)
-		return;
+		return 0;
 
-	smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
-		"schedule send of an empty message\n");
-	queue_work(sc->workqueue, &sc->idle.immediate_work);
+	return posted;
+}
+
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
+	int posted;
+
+	posted = smbdirect_connection_recv_io_refill(sc);
+	if (unlikely(posted < 0)) {
+		smbdirect_socket_schedule_cleanup(sc, posted);
+		return;
+	}
+	if (posted > 0) {
+		smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
+			"schedule send of an empty message\n");
+		queue_work(sc->workqueue, &sc->idle.immediate_work);
+	}
 }
 
 static bool smbdirect_map_sges_single_page(struct smbdirect_map_sges *state,
-- 
2.43.0

