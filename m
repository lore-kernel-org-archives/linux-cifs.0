Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A153502A8
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442736; cv=none; b=Dx2exFN6sXH0a36JWt227w8cHTvU+uuO5OTUZICol/anC6lyCiK70DwvgWk2q+4ombB5YtQUUFUkQWRgT0WyTPbVvBpJyGJVtkEfHlRrahRBz3PWNosfff7Wfo8hsMxGq3XDX5M/1DOY6daKr7GvjuJ0opFHLxtDjbI4F5Oi3tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442736; c=relaxed/simple;
	bh=PNws5mwnRbKQce0nmr0F4ETiz1tK1EcaNaka93kF5D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+/V4NUQhhstAh1DoJifXi765v+oxhrpQn+B+8wSBhufMW3jAPGkWHL4fVENxiF7k9eaOjg+Vc+DbyAkB1uJsDhqRImG703nncaGjET+RLuNJIkYUh4kpDsIAFRd36Ox0muZwDpouHlmHJKVLK5i5uoAgFXYmddxFhTPlBMbCkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a0WwJ8by; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a0WwJ8by"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qX9dROQiP6/aMUr6ukkKfXCExfdWHH3TQJBkk4RJM7o=;
	b=a0WwJ8byuuNMs7lOVcPE2P7haqvpzEB0uK3IVAOtpk6KI0cRgNTvqhuoBg6cEXdA9qr/XO
	2yXQlBEU6kaOM0FineCDC/BnFsZU6D2BOCXkdewbyn+LRRWtXgGB+lhbOhpyJ/2o4zjz4x
	v2ZZESl1pWTu4EuUuPMA477V7zr/jBY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-246-BmeE_gLFPwmSOHBErFEanA-1; Mon,
 22 Dec 2025 17:32:09 -0500
X-MC-Unique: BmeE_gLFPwmSOHBErFEanA-1
X-Mimecast-MFC-AGG-ID: BmeE_gLFPwmSOHBErFEanA_1766442728
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A3FF195608D;
	Mon, 22 Dec 2025 22:32:08 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 51AF8180049F;
	Mon, 22 Dec 2025 22:32:06 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 37/37] cifs: SMB1 split: Make BCC accessors conditional
Date: Mon, 22 Dec 2025 22:30:02 +0000
Message-ID: <20251222223006.1075635-38-dhowells@redhat.com>
In-Reply-To: <20251222223006.1075635-1-dhowells@redhat.com>
References: <20251222223006.1075635-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Make the BCC accessor functions conditional.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/smb1proto.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
index 5ccca02841a8..0c622b5d2555 100644
--- a/fs/smb/client/smb1proto.h
+++ b/fs/smb/client/smb1proto.h
@@ -300,8 +300,6 @@ compare_mid(__u16 mid, const struct smb_hdr *smb)
 	return mid == le16_to_cpu(smb->Mid);
 }
 
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-
 #define GETU16(var)  (*((__u16 *)var))	/* BB check for endian issues */
 #define GETU32(var)  (*((__u32 *)var))	/* BB check for endian issues */
 
@@ -333,4 +331,6 @@ put_bcc(__u16 count, struct smb_hdr *hdr)
 	put_unaligned_le16(count, bc_ptr);
 }
 
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+
 #endif /* _SMB1PROTO_H */

