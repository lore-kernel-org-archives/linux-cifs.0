Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B442349620
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491143; cv=none; b=GUyN9spnvAtewghuj3dB0YnrQWLwQKMvmkyTI3VRJvor0HMBHYkIkIex0r+nXm8qng4EgFyX0zgyqo/ziT9TJtKEuwvHGUVwe/0Lu5jJ/DKugR1Ic0KPVynH2VOQW2nk2DF+H8WdO38t/vbdPA4dL78HWvSwzg57EL9EOgK5E10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491143; c=relaxed/simple;
	bh=bA5gX/sUGntJFkmlGV9jH8EBqWQku1wSPwX5fHA23HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Si+YhgrDRY2jXj35fcUvkmujofiWne+7ydg4rbqaLCogk/GayHSXQgoLMTbPiMH+1PNPBfeMSjWTPZcECtnMekGDXvQdjfOuSrqT7fpQjkPz8EhfGUzTzCDSyBkqERFrzGEBV6joKzTZ07fU05kvY+yejbVq9lmwuw/BamZs3/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=UorEm1fZ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UorEm1fZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=mSJq3XOgl8ROiwl4Uxt+5wyf/Jk7meDwTu5oH/PNPjE=; b=UorEm1fZ/2u3N+97WBHrBWYu4F
	Vz0Lvgt8116VxVw6742B8dH5dA0WBsgE+5hfzV2uiv4nyDLBiz9ZPPG93+4ZEwcV+1zxFAxA6srrI
	YQ8oBAwBROVmnH1lD2b82nhFVYat376ohUWxwtcl6005kPi3dOEbjpjVrtseg4ng15O71bhwleQCq
	NpUZ5o/URRZnERsd/eRKXa8edYfG+GKwMIU+jDgHFUb9ePbJe9s3v3Oz+6H7eYIFKsVRoyZ0dtMpV
	pUGZFX6kY79tlJJLzWNf1F99RjMfHBsRZn4JDomDmHFNImA1Hlusasg//E6IclbmUInDk5EUbIq5o
	bhYToG6LOf9uHSrh8epNr49LULlCawPYNM2TOwnmctjwtWQaBFUOuVWYZ8labn+4ddJbgdyPxAdqX
	J27t9bXag5kJ2jzu/ILvS6ohfqPYdHVIiPjQ8fd7YV4YeQ+TzM5wSRJRjEO5X1KqVwgwlyNboGnDy
	x2mhEA01w03l36txonPE3PRt;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0RsJ-005GMS-0W;
	Sun, 21 Sep 2025 21:45:39 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 02/18] smb: smbdirect: let smbdirect_socket_init() initialize all [delayed_]work_structs as disabled
Date: Sun, 21 Sep 2025 23:44:49 +0200
Message-ID: <a31ccd39feae0a9a40fa863038fa0fac0ab87e8f.1758489989.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This safer to start with and allows common code not care about if the
caller uses these or not. E.g. sc->mr_io.recovery_work is only used
on the client...

Note disable_[delayed_]work_sync() requires a valid function pointer
in INIT_[DELAYED_]WORK(). The non _sync() version don't require it,
but as we need to use the _sync() version on cleanup we better use
it here too, it won't block anyway here...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index b4970d7e42ad..5e25abc02364 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -310,6 +310,14 @@ struct smbdirect_socket {
 	} statistics;
 };
 
+static void __smbdirect_socket_disabled_work(struct work_struct *work)
+{
+	/*
+	 * Should never be called as disable_[delayed_]work_sync() was used.
+	 */
+	WARN_ON_ONCE(1);
+}
+
 static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 {
 	/*
@@ -320,6 +328,14 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 
 	init_waitqueue_head(&sc->status_wait);
 
+	INIT_WORK(&sc->disconnect_work, __smbdirect_socket_disabled_work);
+	disable_work_sync(&sc->disconnect_work);
+
+	INIT_WORK(&sc->idle.immediate_work, __smbdirect_socket_disabled_work);
+	disable_work_sync(&sc->idle.immediate_work);
+	INIT_DELAYED_WORK(&sc->idle.timer_work, __smbdirect_socket_disabled_work);
+	disable_delayed_work_sync(&sc->idle.timer_work);
+
 	atomic_set(&sc->send_io.credits.count, 0);
 	init_waitqueue_head(&sc->send_io.credits.wait_queue);
 
@@ -331,6 +347,8 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	spin_lock_init(&sc->recv_io.free.lock);
 
 	atomic_set(&sc->recv_io.posted.count, 0);
+	INIT_WORK(&sc->recv_io.posted.refill_work, __smbdirect_socket_disabled_work);
+	disable_work_sync(&sc->recv_io.posted.refill_work);
 
 	atomic_set(&sc->recv_io.credits.count, 0);
 
@@ -346,6 +364,8 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	atomic_set(&sc->mr_io.ready.count, 0);
 	init_waitqueue_head(&sc->mr_io.ready.wait_queue);
 	atomic_set(&sc->mr_io.used.count, 0);
+	INIT_WORK(&sc->mr_io.recovery_work, __smbdirect_socket_disabled_work);
+	disable_work_sync(&sc->mr_io.recovery_work);
 	init_waitqueue_head(&sc->mr_io.cleanup.wait_queue);
 }
 
-- 
2.43.0

