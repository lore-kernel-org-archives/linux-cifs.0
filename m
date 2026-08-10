Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9A23DF000
	for <linux-cifs@vger.kernel.org>; Mon, 10 Aug 2026 12:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786366762; cv=none; b=DaPmHQRyc9+cHfjR4nVTjXuUCVmG4EIVpsNt/MaLyNZ5nYVIVHMDuyhju5CVcyCLmQ3U7ycuyseS52GhfOi3/CJqa9HPIapzC0ivxzBT3teYgbQu5WtIcfE37vgaIMC4fvud7ZdeBLKnepqDtHsL2JdxQxknpV6Eqjpz0YXZ/m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786366762; c=relaxed/simple;
	bh=b65RSAh973EBeRrILQ+bC30gE0R2eI0sxLXpsNsAsJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ak0juSGyolzL5XoPPhAWURzW1KSE5vqZwBOipMgVUKdUdPCZCQ0m/ci85k8K4G5D8myNwmgmDNXmSdmcqm/tee5YfwvcnyQUb5dqzCkHsIO9MVyAqlAvCg+hnmQ6734mR4LmZFmSjbEwtLKEisMPADep3awJTXV2+GCkYBzfRhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=COAG0UnB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="COAG0UnB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786366760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MjPZy/DF5PxGdGmbN+m/5NAlaarhrUbd1MfWS27xehM=;
	b=COAG0UnBnAbcUqC1DzZG+R2PzhCSc5rIG3SBArspT/gHJci/5dVKexPBUAsWgO5JIKt44W
	IvFV3Oqa1Wj8mTN71wfIZcsTSPRqqOJRzYb/6txAE0YjO31HdFYUWyCAT09T7YEYi8+jH8
	kj2MHk2VJRZG6yTd0qcDC0gBnWRF/+A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-669-hfY_s0-9PiO8hsHu7qQBsQ-1; Mon,
 10 Aug 2026 08:59:11 -0400
X-MC-Unique: hfY_s0-9PiO8hsHu7qQBsQ-1
X-Mimecast-MFC-AGG-ID: hfY_s0-9PiO8hsHu7qQBsQ_1786366750
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 655BD19560A5;
	Mon, 10 Aug 2026 12:59:10 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 91048422;
	Mon, 10 Aug 2026 12:59:08 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] smb: server: Free sensitive connection data with kfree_sensitive()
Date: Mon, 10 Aug 2026 14:58:57 +0200
Message-ID: <20260810125857.1009618-5-thuth@redhat.com>
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

struct ksmbd_conn contains an embedded struct ntlmssp_auth with the
ciphertext[] and cryptkey[] arrays, so to avoid leaking this information
via the heap, it should be freed with kfree_sensitive().

While we're at it, also use kfree_sensitive() for freeing preauth_info
in ksmbd_conn_free() to avoid that the Preauth_HashValue[] could leak
via the heap here, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/smb/server/connection.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index ef6f202f4024c..bcb688c9af918 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -117,7 +117,7 @@ static void __ksmbd_conn_release_work(struct work_struct *work)
 
 	ida_destroy(&conn->async_ida);
 	conn->transport->ops->free_transport(conn->transport);
-	kfree(conn);
+	kfree_sensitive(conn);
 }
 
 /**
@@ -183,7 +183,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	 */
 	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
-	kfree(conn->preauth_info);
+	kfree_sensitive(conn->preauth_info);
 	kfree(conn->mechToken);
 	ksmbd_conn_put(conn);
 }
-- 
2.55.0

