Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954732F60A7
	for <linux-cifs@vger.kernel.org>; Tue,  2 Dec 2025 21:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764710157; cv=none; b=G7NS/ZhmZneDd4/LSR8XjatTzY/86kjVBxKPNxy+GogiylYIw4o6CHhSWSVfwOBLG4/22G2o6ZJmisClHXh0jeGUUpBOtk5/klYvQbCXjtNIw2ABc382lWik+kAEGG+dICPa29inXKMCMkcH/PIbWGQDqX16NSGM95x8vELEvsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764710157; c=relaxed/simple;
	bh=v7OhROcstayu/IS2Z1fN9Wh/ZvTREzRdLp/c1fjfRU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0Z1xOrgpZnW+Hl3keWorwftHlfFQusROWCqcLN+l0HTB6Iov0I+3NFYf4AoS8EJWk4sYecHtr4tIlnQGtMOocGRrSQpN4eJTuIYlb09nPlc2IWm2+vYz/3daTs6gnBXIdduQwvulAawBvyiWlgML9vqB6CHqzztPpUqTeCiQqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=zRVetU2G; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="zRVetU2G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nFx/LeqE9ahJ9gho311pUXSBD1x8oa7Rl1ekFX2Cs0w=; b=zRVetU2Gi8ONfTdpJMWyDkX+4D
	mUNg9Fl1DGz57JdIw6jsBhKAPVBMzZo2UoaUOwQZqdoD/zcZP6GdTsmToKZWhStERwj4Ka91L7LNM
	s5lFivIXoM3M0z0p4N+qz58IoPA7hswmqX9l2mQuuxXQPD0GeXjwjIituQwajFvmYcZZV0efJPT4e
	XhFEC/Qfqzv6X8IVHMvdyt0dIjCMXizAZb9mTNE8kLFLSMhoMNIXz2BtYcu7AsyE9qbbHUjD5KbxL
	H2zAzpeJmlljAawnXRszt6E8UDH1DzKve2RqSGicsO2/+6rg6EoMp6q26ojZzDf5WBGFbsyu2NEfo
	ynIECMEPocnqnCYNCLhdEF19fjSz7ft5vnOtMpYjEIPcEyu2dgH8Wc0fw41blfvyDuWMjn7cLw2zj
	B2Eh3NGnfl2qAlnVH08natoTaDyF/bSLInwffFc/K5m75yEr5PtzkPm3Xva/Peog9gU3SWr63Igin
	AE5PP6VY3Js2m7Rb1sIBo7K/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vQXix-00Ghsl-2Q;
	Tue, 02 Dec 2025 21:15:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [RFC PATCH 1/4] smb: smbdirect: introduce smbdirect_socket.connect.{lock,work}
Date: Tue,  2 Dec 2025 22:15:24 +0100
Message-ID: <bb7abd609300057a839001f2501f5e1827d825a8.1764709225.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764709225.git.metze@samba.org>
References: <cover.1764709225.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will first be used by the server in order to defer
the processing of the initial recv of the negotiation
request.

But in future it will also be used by the client in order
to implement an async connect.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 384b19177e1c..ee4c2726771a 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -132,6 +132,14 @@ struct smbdirect_socket {
 
 	struct smbdirect_socket_parameters parameters;
 
+	/*
+	 * The state for connect/negotiation
+	 */
+	struct {
+		spinlock_t lock;
+		struct work_struct work;
+	} connect;
+
 	/*
 	 * The state for keepalive and timeout handling
 	 */
@@ -353,6 +361,10 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_WORK(&sc->disconnect_work, __smbdirect_socket_disabled_work);
 	disable_work_sync(&sc->disconnect_work);
 
+	spin_lock_init(&sc->connect.lock);
+	INIT_WORK(&sc->connect.work, __smbdirect_socket_disabled_work);
+	disable_work_sync(&sc->connect.work);
+
 	INIT_WORK(&sc->idle.immediate_work, __smbdirect_socket_disabled_work);
 	disable_work_sync(&sc->idle.immediate_work);
 	INIT_DELAYED_WORK(&sc->idle.timer_work, __smbdirect_socket_disabled_work);
-- 
2.43.0

