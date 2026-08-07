Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19DB30BF6B
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 17:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122646; cv=none; b=lFr+Ibq0kIvNhzXuZMoS3xkr1xzMm6FC/TNuRVK7hfX3HSDx2U5091AnCGxGgH9Lz/9Mal9tdNwwMmkyznKOnR/803ocoBwVeJFb1NJSWP+6PLg6syVoqxbQJ8KWytZCs6I1RCVuUajZJf/exMH+WhXbQS1JaK4I01JVFHQFC8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122646; c=relaxed/simple;
	bh=hhBqAYcryluxrC/9AzCe5JEdlxEqjRUJt7UEL1B+pmM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YL90d8tdYTwkclRp1uOwfXLWqp6lAc0aaNCbbGEsJB+fcJABw+tE6QyiETwi5z1xQcnf6sveT7d3/v5YW7pZIHLyQnsoTm+w0P1Sh0JMm+aQtV0gReC/OIXMPoW8DYh2D7b0/X2u7WROf6ylL9JTfuTkyvLUJsSwlbvxsMIdW1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XT6fPRKX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XT6fPRKX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786122643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=I8Iiu2nwWIJEFUeMkYZYd+XPwaRbkQwO7rwHvokknRk=;
	b=XT6fPRKXrJxuWtO4aZfutoDn1/oTRaMC7iy48LBdGZQ5gEk8IDDukBq8pcrd6XO023OVcd
	KaGYGHGvmQ2rS5QaTtHOLaWz1N8BYE1c7B+L8ZrguPqtwryEiaHoA+XCFC0Ds3OgM7LSJ6
	YiviBJZdK0DiXEJCDq0Ot78+3+LWMSU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-59-9xB09XCVOqOv6hT7N-lBtw-1; Fri,
 07 Aug 2026 13:10:29 -0400
X-MC-Unique: 9xB09XCVOqOv6hT7N-lBtw-1
X-Mimecast-MFC-AGG-ID: 9xB09XCVOqOv6hT7N-lBtw_1786122628
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C72781800747;
	Fri,  7 Aug 2026 17:10:27 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BD47C18005BB;
	Fri,  7 Aug 2026 17:10:25 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: server: Clear sensitive stack and heap data in auth.c
Date: Fri,  7 Aug 2026 19:10:23 +0200
Message-ID: <20260807171024.1529513-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: Thomas Huth <thuth@redhat.com>

Sensitive data like keys that are stored in stack-local arrays could be
leaked via the stack to the calling functions, or via the heap when using
only normal kfree() functions. There is no known vulnaribility for this in
this code right now, but it's good security style to explicitly zeroize this
sensitive material as soon as possible to avoid that it could be exploited
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
index 4e7b6f0e6b8cd..acdac40bee813 100644
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
+	kvfree_sensitive(resp);
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

