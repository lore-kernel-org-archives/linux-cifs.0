Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73990401A14
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 08:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790584286; cv=none; b=efVO8XWRH656zGcmcB+WySnYTEjUmeUDhrd8AInoJ8b3HYCaBx5BD+0Mege6r3i6OXNzbi12xFTl2mwS1/Yj8gYf0Ufn0QzyKRSDZMJp3JgEXM7lnwdr9vBOcMVdhwBfA2Nc0uLS35eJgh7s10Sib3SJfCtkrKKfulNMxR9Fi2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790584286; c=relaxed/simple;
	bh=Pznk8hfVuVukVfclBPzbhLEaJi6ZtK/4mQJu/n1NEDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYIPuEPNadAN7qoCvYXdom+1QDoNZY6LOgUVQ0SOdLL4rU2zA7GnkZlFvUiPloOyez7mJxsjOZ3ERo4YrWsLb/6RRCYDSUpJknJhQjg7Q/v1dvebOcIPebwVvbwGTHQ7100CnKmjzpJ2+nR437eWvhjy/tEmYYbC2Jh8/DTiDvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SsXyG0Yl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SsXyG0Yl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790584283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dAu1bQF4/jUeSXArCSj5+nJuZ/vxHgx8HbK6kP4IS9s=;
	b=SsXyG0YlrEhJfVTWNnCcKRbV51Cz/ynDtsL6I2EzMR36OCCmfDI56pGzfX4R//Nw0miSfv
	Y0daZWnH4b17HONbpVbC+pZej5nnD3C3fefqybEsJmzHu7mdcNV+fPuJ0iRDwh90axLR6V
	xJDlf6kIAvUwqOo6v4X+oXaWYasrHYY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-Wzj9vxlHOPyGi-4ytySxIA-1; Mon,
 28 Sep 2026 04:31:18 -0400
X-MC-Unique: Wzj9vxlHOPyGi-4ytySxIA-1
X-Mimecast-MFC-AGG-ID: Wzj9vxlHOPyGi-4ytySxIA_1790584276
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0CF71954204;
	Mon, 28 Sep 2026 08:31:15 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.32.43])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6C4BD1956086;
	Mon, 28 Sep 2026 08:31:10 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 2/3] lib/crypto: sha2: Provide functions for zeroizing SHA2 hmac_sha* structures
Date: Mon, 28 Sep 2026 10:30:54 +0200
Message-ID: <20260928083055.104266-3-thuth@redhat.com>
In-Reply-To: <20260928083055.104266-1-thuth@redhat.com>
References: <20260928083055.104266-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In certain cases crypto code functions need to zeroize their local SHA2
hmac_sha*_key or hmac_sha*_ctx structures after use to avoid leaking
sensitive material on the stack.
Provide hmac_sha*_zeroize_key() and hmac_sha*_zeroize_ctx() helper
functions that can be used with __cleanup() to automatically zeroize
the structure when it goes out of scope.

Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/sha2.h | 73 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index 7bb8fe169daf2..22fbc37ae8407 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -7,6 +7,7 @@
 #define _CRYPTO_SHA2_H
 
 #include <linux/types.h>
+#include <linux/string.h>
 
 #define SHA224_DIGEST_SIZE	28
 #define SHA224_BLOCK_SIZE	64
@@ -210,6 +211,15 @@ struct hmac_sha224_key {
 	struct __hmac_sha256_key key;
 };
 
+/**
+ * hmac_sha224_zeroize_key() - Zeroize an hmac_sha224_key structure
+ * @key: The hmac_sha224_key to zeroize
+ */
+static inline void hmac_sha224_zeroize_key(struct hmac_sha224_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct hmac_sha224_ctx - Context for computing HMAC-SHA224 of a message
  * @ctx: private
@@ -218,6 +228,15 @@ struct hmac_sha224_ctx {
 	struct __hmac_sha256_ctx ctx;
 };
 
+/**
+ * hmac_sha224_zeroize_ctx() - Zeroize an hmac_sha224_ctx structure
+ * @ctx: The hmac_sha224_ctx context to zeroize
+ */
+static inline void hmac_sha224_zeroize_ctx(struct hmac_sha224_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha224_preparekey() - Prepare a key for HMAC-SHA224
  * @key: (output) the key structure to initialize
@@ -414,6 +433,15 @@ struct hmac_sha256_key {
 	struct __hmac_sha256_key key;
 };
 
+/**
+ * hmac_sha256_zeroize_key() - Zeroize an hmac_sha256_key structure
+ * @key: The hmac_sha256_key to zeroize
+ */
+static inline void hmac_sha256_zeroize_key(struct hmac_sha256_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct hmac_sha256_ctx - Context for computing HMAC-SHA256 of a message
  * @ctx: private
@@ -422,6 +450,15 @@ struct hmac_sha256_ctx {
 	struct __hmac_sha256_ctx ctx;
 };
 
+/**
+ * hmac_sha256_zeroize_ctx() - Zeroize an hmac_sha256_ctx structure
+ * @ctx: The hmac_sha256_ctx context to zeroize
+ */
+static inline void hmac_sha256_zeroize_ctx(struct hmac_sha256_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha256_preparekey() - Prepare a key for HMAC-SHA256
  * @key: (output) the key structure to initialize
@@ -623,6 +660,15 @@ struct hmac_sha384_key {
 	struct __hmac_sha512_key key;
 };
 
+/**
+ * hmac_sha384_zeroize_key() - Zeroize an hmac_sha384_key structure
+ * @key: The hmac_sha384_key to zeroize
+ */
+static inline void hmac_sha384_zeroize_key(struct hmac_sha384_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct hmac_sha384_ctx - Context for computing HMAC-SHA384 of a message
  * @ctx: private
@@ -631,6 +677,15 @@ struct hmac_sha384_ctx {
 	struct __hmac_sha512_ctx ctx;
 };
 
+/**
+ * hmac_sha384_zeroize_ctx() - Zeroize an hmac_sha384_ctx structure
+ * @ctx: The hmac_sha384_ctx context to zeroize
+ */
+static inline void hmac_sha384_zeroize_ctx(struct hmac_sha384_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha384_preparekey() - Prepare a key for HMAC-SHA384
  * @key: (output) the key structure to initialize
@@ -798,6 +853,15 @@ struct hmac_sha512_key {
 	struct __hmac_sha512_key key;
 };
 
+/**
+ * hmac_sha512_zeroize_key() - Zeroize an hmac_sha512_key structure
+ * @key: The hmac_sha512_key to zeroize
+ */
+static inline void hmac_sha512_zeroize_key(struct hmac_sha512_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct hmac_sha512_ctx - Context for computing HMAC-SHA512 of a message
  * @ctx: private
@@ -806,6 +870,15 @@ struct hmac_sha512_ctx {
 	struct __hmac_sha512_ctx ctx;
 };
 
+/**
+ * hmac_sha512_zeroize_ctx() - Zeroize an hmac_sha512_ctx structure
+ * @ctx: The hmac_sha512_ctx context to zeroize
+ */
+static inline void hmac_sha512_zeroize_ctx(struct hmac_sha512_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha512_preparekey() - Prepare a key for HMAC-SHA512
  * @key: (output) the key structure to initialize
-- 
2.55.0

