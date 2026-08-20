Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EE13B1EEE
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 06:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787209117; cv=none; b=fGomWq/pC6E7u+mVMkKLdSBrulm/b8HbZbXv4lcbb7vmeCpMzsKoGvOq68QWvcJC/FtrOeicuj2a6psqxJ61+4bEc+ofotzG6yu19C9HQydh94qCpnXx1bwmT5wwkVrJC5QrY9rNBDcluw2iQQrgJksvcd0EqFFZpScH48M3i3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787209117; c=relaxed/simple;
	bh=kynTe+djMAUMAKZWbeeP8HeejqzbszSZFzgZxBbA2uw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K4WzOPq300GgRINLTWB7EzB9gmg8+9pwN36kULxdh2ZuNJPysEEt7gOS656ORYIjv3HRaUTdfrH51VvnFh9Fk7jMTzCPH5IFFWflR+eAnWpOx0pFeWR/6jK9BdEy+hn8wsh4LbGbvifACueQlBe/TXezpyqiEztOD4tDAwRsk9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ts9jRgs5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ts9jRgs5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787209114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1oMvv+ilbzFWyz0kC2CFBl3hm5fV9dGF5RL85Fpz3eM=;
	b=Ts9jRgs5A8gyfNOtBLtCa8lJBFodlztlZ+R0d0x/fTd5jdTpbBFR7Ex3HBP616Eyxq8NjQ
	4c5R78raEtIL/nEiGgjUC5YqGnEjNoufMCrc1Njk6JhIHEQ6SbIMDe6aYO9G5p2mylwdcD
	S169SgmvQwHym3GHvMNz1H3PyjskIAo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-650-Y0Wy8mjBNHCPmmkEF1NkVQ-1; Thu,
 20 Aug 2026 02:58:21 -0400
X-MC-Unique: Y0Wy8mjBNHCPmmkEF1NkVQ-1
X-Mimecast-MFC-AGG-ID: Y0Wy8mjBNHCPmmkEF1NkVQ_1787209099
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93872195608B;
	Thu, 20 Aug 2026 06:58:19 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.32.124])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 78FE0423;
	Thu, 20 Aug 2026 06:58:17 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: server: Remove obsolete "select CRYPTO_LIB_DES" from Kconfig file
Date: Thu, 20 Aug 2026 08:58:15 +0200
Message-ID: <20260820065816.44267-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

The DES encryption in the smb server code has been removed in 2021
with the removal of the insecure NTLMv1 authentication code. Thus
we don't need this "select" statement here anymore.

Fixes: ce812992f239f ("ksmbd: remove NTLMv1 authentication")
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/smb/server/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 08d8b7a965a64..221ec9717a834 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -9,7 +9,6 @@ config SMB_SERVER
 	select CRYPTO
 	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_ARC4
-	select CRYPTO_LIB_DES
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
-- 
2.55.0

