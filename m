Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF7631159C
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442630; cv=none; b=FhuOK1rYhNP0ZxncOK/MZu1tkLkT+DHP0Ks1uJxx95KTIyQ7G1qPaca+kk4RVeHE1Xd+4kdLoNxdhvs4+y0uefJBV9zI25ri2hDynAs7Rk7j3z694zEcSGbSDJHq4eH8kDk8lOQhOVPqbCCjb0QuzHvpNf8hG7ppkzfiOVeDTXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442630; c=relaxed/simple;
	bh=7YeUtAWwc1Q/OF+xWa0k6gLeoVvf794K1nDWjz/6u3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yo/Vn6L+qtzwOwE+THb/ucYjxYSmB46SBErXUAK82COveFeI3gSrJgR/ayfLZrakMx+vhX/oLKD44XwSZ3FlvP10JFMuPGbZEDRbaICCXhPuFi3I7P3m7OSlz5AkTyP++6crPjYkg6NpBlTFLPqqAL0Maia9Er3p0oWtQxvPS4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g9twcUck; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9twcUck"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DcvtLl6W0LGaN+onglGxp4ViPysCQEHvxK5LsOGIXAE=;
	b=g9twcUckD+DdPcrUdjUnlqSRZP2dFVLmpxdDf8LlGdtOqrC0Sx3MzgAioHM1BekC7gxHMN
	qOQh5/rmF2UxSr03rQktSSa9VzpWUGkcD0b8mKyoFwIjAlTlcZC4m8CFel6vnUTgRDcRNC
	c4Yr1S3iyeeRpDLKj4rgF9KG5o/q1O8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-__9_f_-pPEGgqH6f09qjcw-1; Mon,
 22 Dec 2025 17:30:26 -0500
X-MC-Unique: __9_f_-pPEGgqH6f09qjcw-1
X-Mimecast-MFC-AGG-ID: __9_f_-pPEGgqH6f09qjcw_1766442625
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B9E4195DE49;
	Mon, 22 Dec 2025 22:30:25 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 57DB930001A2;
	Mon, 22 Dec 2025 22:30:23 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/37] cifs: Scripted clean up fs/smb/client/cifs_unicode.h
Date: Mon, 22 Dec 2025 22:29:29 +0000
Message-ID: <20251222223006.1075635-5-dhowells@redhat.com>
In-Reply-To: <20251222223006.1075635-1-dhowells@redhat.com>
References: <20251222223006.1075635-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/cifs_unicode.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifs_unicode.h b/fs/smb/client/cifs_unicode.h
index 6e4b99786498..9249db3b78c3 100644
--- a/fs/smb/client/cifs_unicode.h
+++ b/fs/smb/client/cifs_unicode.h
@@ -55,19 +55,20 @@
 #define SFU_MAP_UNI_RSVD	2
 
 int cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
-		    const struct nls_table *cp, int map_type);
+		    const struct nls_table *codepage, int map_type);
 int cifs_utf16_bytes(const __le16 *from, int maxbytes,
 		     const struct nls_table *codepage);
-int cifs_strtoUTF16(__le16 *, const char *, int, const struct nls_table *);
+int cifs_strtoUTF16(__le16 *to, const char *from, int len,
+		    const struct nls_table *codepage);
 char *cifs_strndup_from_utf16(const char *src, const int maxlen,
 			      const bool is_unicode,
 			      const struct nls_table *codepage);
-extern int cifsConvertToUTF16(__le16 *target, const char *source, int maxlen,
-			      const struct nls_table *cp, int mapChars);
-extern int cifs_remap(struct cifs_sb_info *cifs_sb);
-extern __le16 *cifs_strndup_to_utf16(const char *src, const int maxlen,
-				     int *utf16_len, const struct nls_table *cp,
-				     int remap);
+int cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
+		       const struct nls_table *cp, int map_chars);
+int cifs_remap(struct cifs_sb_info *cifs_sb);
+__le16 *cifs_strndup_to_utf16(const char *src, const int maxlen,
+			      int *utf16_len, const struct nls_table *cp,
+			      int remap);
 wchar_t cifs_toupper(wchar_t in);
 
 #endif /* _CIFS_UNICODE_H */

