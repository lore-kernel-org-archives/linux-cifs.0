Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618993A3E9F
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186153; cv=none; b=NkVUMuecHEBgvXpbh+nFTes464o0hPFIXN2ccja9XDxIoYz+DmjzNr2VWiWNoZdHjpRJ7GrX+1A60RiHa9FtH1R9Cf+Itc7EnMOEnwjXiz4oavn3nLT4dm5SYrqi93bgk07+qatigppNlHng1+ryqeWh/zHayD8g6KYCXErReFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186153; c=relaxed/simple;
	bh=73ZY8mW8gUqD884gH4nOwq7lM6Zo/5jkbSSuOt61xjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUNRLwwDivG6kO3qlow0Tfb40JiJuHS53aQaBOg4bXPLotRPVDdqAu/s4bSyGpiNQd/Uhg+WPDUD3W0Ikiy+nbKFKRoAku9HK8GoZJ4H5OEXh9vVrHwuAs/z+4AXt/WXuXcn4bC1/g3G0APQRB4X6CQtldOVFU3F43rMruRD0jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HhkwfXXI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HhkwfXXI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VtgqytRwGrmRD2asl1hoBpXgeAMJbC0kkMX9/JldibM=;
	b=HhkwfXXIbjQ+RHVEPE7zwM2U3FL1f6ruVhf2YfnTnhUubm3kLnVAn3XmUFBrEfNwG5cLew
	fWErjE4Uh0DU3NZLBZ/6FQzeDUlg4xdkEhbxSmtyLD02g3L1YaW2zkykj5rjzkutoVKFnn
	zlozVxiUp1wwhP1Uc5VOm/eAWU/skgQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-LcVG3lBxPWCABxmRFfliNQ-1; Tue,
 19 May 2026 06:22:27 -0400
X-MC-Unique: LcVG3lBxPWCABxmRFfliNQ-1
X-Mimecast-MFC-AGG-ID: LcVG3lBxPWCABxmRFfliNQ_1779186145
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9898318005BA;
	Tue, 19 May 2026 10:22:25 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 68E9D19560B0;
	Tue, 19 May 2026 10:22:22 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 04/36] cifs, nls: Provide unicode size determination func
Date: Tue, 19 May 2026 11:21:22 +0100
Message-ID: <20260519102158.592165-5-dhowells@redhat.com>
In-Reply-To: <20260519102158.592165-1-dhowells@redhat.com>
References: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/nls/nls_base.c            | 33 ++++++++++++++++++++++++++++++
 fs/smb/client/cifs_unicode.c | 39 ++++++++++++++++++++++++++++++++++++
 fs/smb/client/cifs_unicode.h |  2 ++
 include/linux/nls.h          |  1 +
 4 files changed, 75 insertions(+)

diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index a5c3a9f1b8dc..69bc266b4a49 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -174,6 +174,39 @@ int utf8s_to_utf16s(const u8 *s, int inlen, enum utf16_endian endian,
 }
 EXPORT_SYMBOL(utf8s_to_utf16s);
 
+/**
+ * utf8s_to_len_utf16s - Determine the length of a conversion of UTF8 to UTF16.
+ * @s: The source utf8 string
+ * @inlen: The length of the string
+ */
+ssize_t utf8s_to_len_utf16s(const u8 *s, int inlen)
+{
+	unicode_t u;
+	size_t outcount = 0;
+	int size;
+
+	while (inlen > 0 && *s) {
+		if (*s & 0x80) {
+			size = utf8_to_utf32(s, inlen, &u);
+			if (size < 0)
+				return -EINVAL;
+			s += size;
+			inlen -= size;
+
+			if (u >= PLANE_SIZE)
+				outcount += 2;
+			else
+				outcount++;
+		} else {
+			s++;
+			outcount++;
+			inlen--;
+		}
+	}
+	return outcount * sizeof(wchar_t);
+}
+EXPORT_SYMBOL(utf8s_to_len_utf16s);
+
 static inline unsigned long get_utf16(unsigned c, enum utf16_endian endian)
 {
 	switch (endian) {
diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
index 4a8a591f4bca..f8fac73dcc1e 100644
--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -276,6 +276,45 @@ cifs_strtoUTF16(__le16 *to, const char *from, int len,
 	return i;
 }
 
+/*
+ * Work out how long a string will be once converted to UTF16 in bytes.  This
+ * does not include a NUL terminator.
+ */
+size_t cifs_size_strtoUTF16(const char *from, int len,
+			    const struct nls_table *codepage)
+{
+	wchar_t wchar_to; /* needed to quiet sparse */
+	ssize_t out_len = 0;
+	int charlen;
+
+	/* special case for utf8 to handle no plane0 chars */
+	if (strcmp(codepage->charset, "utf8") == 0) {
+		out_len = utf8s_to_len_utf16s(from, len);
+		if (out_len >= 0)
+			goto success;
+		/*
+		 * On failure, fall back to UCS encoding as this function
+		 * should not return negative values currently can fail only if
+		 * source contains invalid encoded characters
+		 */
+	}
+
+	for (; len && *from; len -= charlen) {
+		charlen = codepage->char2uni(from, len, &wchar_to);
+		if (charlen < 1) {
+			cifs_dbg(VFS, "strtoUTF16: char2uni of 0x%x returned %d\n",
+				 *from, charlen);
+			/* Replace with a question mark */
+			charlen = 1;
+		}
+		from += charlen;
+		out_len += 2;
+	}
+
+success:
+	return out_len;
+}
+
 /*
  * cifs_utf16_bytes - how long will a string be after conversion?
  * @utf16 - pointer to input string
diff --git a/fs/smb/client/cifs_unicode.h b/fs/smb/client/cifs_unicode.h
index 3e9cd9acf0a9..f774e0dd7461 100644
--- a/fs/smb/client/cifs_unicode.h
+++ b/fs/smb/client/cifs_unicode.h
@@ -61,6 +61,8 @@ int cifs_utf16_bytes(const __le16 *from, int maxbytes,
 		     const struct nls_table *codepage);
 int cifs_strtoUTF16(__le16 *to, const char *from, int len,
 		    const struct nls_table *codepage);
+size_t cifs_size_strtoUTF16(const char *from, int len,
+			    const struct nls_table *codepage);
 char *cifs_strndup_from_utf16(const char *src, const int maxlen,
 			      const bool is_unicode,
 			      const struct nls_table *codepage);
diff --git a/include/linux/nls.h b/include/linux/nls.h
index e0bf8367b274..026da1d5ffaa 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -56,6 +56,7 @@ extern int utf8_to_utf32(const u8 *s, int len, unicode_t *pu);
 extern int utf32_to_utf8(unicode_t u, u8 *s, int maxlen);
 extern int utf8s_to_utf16s(const u8 *s, int len,
 		enum utf16_endian endian, wchar_t *pwcs, int maxlen);
+ssize_t utf8s_to_len_utf16s(const u8 *s, int inlen);
 extern int utf16s_to_utf8s(const wchar_t *pwcs, int len,
 		enum utf16_endian endian, u8 *s, int maxlen);
 

