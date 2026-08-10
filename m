Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D52E3DD523
	for <linux-cifs@vger.kernel.org>; Mon, 10 Aug 2026 12:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786366756; cv=none; b=CimZI0z9KRtTbGgAZQnQQYxQ5ZYB9bYgNZd1lKU41tVZRwl/chguR3yUmxAB+y6QL4vuiOv84e8atHm9Alq5PcrFlANqKja+68ypDKBLC01wgjGh9gCcY8g8j3h1ub0h8WvinPc/HPrXdKiV4ai4Ahcl40Q0hB++ZW/tiKX1kSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786366756; c=relaxed/simple;
	bh=hqOsn2cNMRyVT4MKlsc0XKCWay55quu4DFVjEkbtKfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ie/X/xph5qytnVqAXu+oeLhrJorvzNVfwrdlWik0DqE6jjxYH62Fg5dcVGaj7OU2TSXJ2Ch0Vv4lk+RkyA7qxH4018xogWIRHq3RkOF6ZXhXh8EaI6SNJpUzg5OAWAY35dGHnoHVDwdZjx8+rbU6CbSsX3mzpEedNF+ffdxcG2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ohj7EMVH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ohj7EMVH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786366752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aM2BoD9AfIWZsdfQ60fb8ro4z7LPM1Ms9bdnD3yXW60=;
	b=Ohj7EMVHxrc5S3o+iaoihZkaUNZV87lygqw46BBdTwXVEmNx0uaJ9+qUphK4KYF+LLNvsU
	3IxJQgKLHQrNKY+SqhqamwdtMeXjTBr136oMlY9bpOHtih3Fu2q1ZncvMCQIo0VYq1/miS
	JtgfwZT+28IwoYnd8AOSslGJMk5htRg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-270-nFyaeFULMPuewdAOlun6uQ-1; Mon,
 10 Aug 2026 08:59:04 -0400
X-MC-Unique: nFyaeFULMPuewdAOlun6uQ-1
X-Mimecast-MFC-AGG-ID: nFyaeFULMPuewdAOlun6uQ_1786366743
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32C761955BD0;
	Mon, 10 Aug 2026 12:59:03 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3A84C423;
	Mon, 10 Aug 2026 12:59:01 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] smb: server: Clear sensitive stack and heap data in auth.c
Date: Mon, 10 Aug 2026 14:58:54 +0200
Message-ID: <20260810125857.1009618-2-thuth@redhat.com>
In-Reply-To: <20260810125857.1009618-1-thuth@redhat.com>
References: <20260810125857.1009618-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

From: Thomas Huth <thuth@redhat.com>

Sensitive data like keys that are stored in stack-local arrays could be
leaked via the stack to the calling functions, or via the heap when using
only normal kfree() functions. There is no known vulnaribility for this
right now, but it's good security style to explicitly zeroize this
sensitive matieral as soon as possible to avoid that it could be exploited
together with other bugs later.

In calc_ntlmv2_hash(), the struct hmac_md5_ctx is normally cleared during
hmac_md5_final() already, but in case of errors, this function is skipped
and ctx is never zeroized, so add a memzero_explicit(&ctx, sizeof(ctx))
there to fix the problem.

In ksmbd_krb5_authenticate(), the ksmbd_spnego_authen_response contains
the session key in the payload. It's currently freed with plain kvfree().
Let's better use kvfree_sensitive() instead.

In generate_key(), the prfhash[] array is used to calculate the key,
but it's never cleared, so it leaks on the stack. Thus clear this with
a memzero_explicit(), too.

In ksmbd_crypt_message(), the sign[] and key[] arrays are leaked via
the stack, too. Make sure to clear them via memzero_explicit() at the
end.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/smb/server/auth.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 4e7b6f0e6b8cd..998b40c35e97c 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -122,6 +122,8 @@ static int calc_ntlmv2_hash(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 out:
 	kfree(uniname);
 	kfree(domain);
+	if (ret)	/* Done by hmac_md5_final() already if ret == 0 */
+		memzero_explicit(&ctx, sizeof(ctx));
 	return ret;
 }
 
@@ -464,7 +466,7 @@ int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
 	*out_len = resp->spnego_blob_len;
 	retval = 0;
 out:
-	kvfree(resp);
+	kvfree_sensitive(resp, sizeof(*resp));
 	return retval;
 }
 #else
@@ -556,6 +558,7 @@ static void generate_key(struct ksmbd_conn *conn, const char *sess_key,
 
 	hmac_sha256_final(&ctx, prfhash);
 	memcpy(key, prfhash, key_size);
+	memzero_explicit(prfhash, sizeof(prfhash));
 }
 
 static int generate_smb3signingkey(struct ksmbd_session *sess,
@@ -848,7 +851,8 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 		ctx = ksmbd_crypto_ctx_find_ccm();
 	if (!ctx) {
 		pr_err("crypto alloc failed\n");
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto zeroize_key;
 	}
 
 	if (conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
@@ -928,5 +932,8 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 	aead_request_free(req);
 free_ctx:
 	ksmbd_release_crypto_ctx(ctx);
+zeroize_key:
+	memzero_explicit(key, sizeof(key));
+	memzero_explicit(sign, sizeof(sign));
 	return rc;
 }
-- 
2.55.0

