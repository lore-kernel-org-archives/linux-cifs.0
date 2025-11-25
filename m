Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8488B32AACE
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093464; cv=none; b=A7F7J9ZqxS/4wSivyYmveSZvNuR9LLqmrWERRuLEx7DcJspIJ76se3QeAIKlOy4A9+oPm2OUPsi/p9BI8+Acy0vTTkW0tQZYKmw6gzssRhPaswg/8S0juW7lHUeID4XXhQCF9OAMmBv7aHc12nmXYsjpOs28iIlXXvvAyK4bqMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093464; c=relaxed/simple;
	bh=hozGAP197Vp3CAvmRNGLMCeI754wvWKRqigHEO9VWDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgsjwhllMFYrRGSE3OVx/YqoZ1EvE24o+BDNC7AU/bM9+k5briwNPi9Awfma/Z5Hbu3F0egQFy7UDT+Y+JDap1jIHXdN37caY3UcB3rBoHCoqmU5PXo6pgCoqwpr9Erk2wx9iQHYUwYmo1EjTshyVx6w+qXhpxvxiCvqeJfymE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=NalQGhn5; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="NalQGhn5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=XCZcFRx3gKhyFR6uETrUvu/oijjMnMDxQQHTl1SCz+k=; b=NalQGhn5VYGu0GEJGdLzbYN8XC
	sgp6DJQb2soLQNztej0YBwBtBiVQaSzr4BLeUDDxdoeYFrMyFKt9pEvBr1TDz1JEka/lCmDTQ2XNk
	XpZbDKXC80qNZcePrSsE+1W0x0rQm2Y/A8aBh6NxhxJTXC7KGopGob2s+PZrtZCuyZWyCiuQ0K+Oe
	zwCjtETiN+QMlq5oH5nU+Xa4tMyAsL+bvE5pLYWawLh+ZmLsorm7EbxzFPIz35wVAjOMvwjbsazZH
	chPuhkQVa6+Dw2MEmwbAbNtjsCAxq+e7faiwGEb+dVhZ8ULuEH8kdgZNpWXf8uAwNlw5sAc25kH/j
	0OROh/Jq+kXWW+U1A0L3kLdPoMZD3p45mDXYyJRhUrVZEgBkERvlzg7s/pS68ep7Qxhuh5ybZGQWh
	g5rPunat0LAla2ufNZ+tds8FqhmTHva0xb7GBcYosi2FkoBdZ7xu2hEA3ZAsfSV4KWq6PT4xB5cr1
	GgDy2y07LilEUOcgeHOJRrCg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxII-00Fcca-2Q;
	Tue, 25 Nov 2025 17:57:38 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 010/145] smb: smbdirect: introduce smbdirect_socket_prepare_create()
Date: Tue, 25 Nov 2025 18:54:16 +0100
Message-ID: <c0627b370f6d39059a180eb5e95baa307cc4d324.1764091285.git.metze@samba.org>
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

This will be used by client and server until we reach
the point where we have only public function from
an smbdirect.ko.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 0a96f5db6ff3..421a5c2c705e 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -5,3 +5,22 @@
  */
 
 #include "smbdirect_internal.h"
+
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
+					    const struct smbdirect_socket_parameters *sp,
+					    struct workqueue_struct *workqueue)
+{
+	smbdirect_socket_init(sc);
+
+	/*
+	 * Make a copy of the callers parameters
+	 * from here we only work on the copy
+	 */
+	sc->parameters = *sp;
+
+	/*
+	 * Remember the callers workqueue
+	 */
+	sc->workqueue = workqueue;
+}
-- 
2.43.0

