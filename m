Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07C2395AD3
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246015; cv=none; b=Gt1vbwHlFzfbOAbfdZCh4K3kJgVMl9LWRVL4e+btwf8FEpk6uFUtFjNIX9P7p0CWCu77aHsj2v0yeHbvHUqztAanoecDs+lITnC2zxJfGePbTogBtuJUKHM8ApjLShJFtbfSro5xIb8i1P7kbHajwt20KVhjXeT7vM7h80c/q8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246015; c=relaxed/simple;
	bh=j06TSK0SMmVExGPDqgAJ/z/Po5iNb0CC4lM6lWlx+dU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mjdZzg5l1JKNeBD/P4aeVhx8VoEh8k6QriOnJ21gxg17YQyu4XZ7AygSa4J1lQH5G0zSMd+C5N+zShG0x6fMjASfHeEfUoJshuKqmMjxXt96rD3yatpeWuWJgf+OYqEUc0dX4VfGI9txG19ECYkzp2rd7nNYBWPwCUZBQ21hpns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Be/cbtS4; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Be/cbtS4"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6a1009f6adeso209010eaf.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246013; x=1782850813; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/xM5UNycbvQRDFAauQbOe/ghqnsUtvfa/jNaKXQiQCM=;
        b=Be/cbtS410VgKVwMYgT4uCH1m6KmmqwdwW2CLrR4HJ/60m9uogkM9MzMitSj/+8KX0
         WFLkGEdEOTFLH/1P2iaR+6yRC3rWN/Tev0Me9sVOAp0ydByKqPK1kNk0JYk4lCzN0KQb
         8UVFmUx9hfKlRt3IJjOM+9N50VSYuXNi+4W8ilAl7QtGc6QxlnmDBuU7HKKjaLh4uiTo
         WrbgWAa+7zJ0isAiNUhGfjELn8+xn89W3xWgd/x1Mgyq9XAfxHgzmU+Q3zVizXDyL9tt
         tqTH4rr4+ijotdaicmi6/6hO3BnTqtr4B5jT+iExOv7pXMERuJY+FGMYMitJHMtlURYV
         Hrzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246013; x=1782850813;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/xM5UNycbvQRDFAauQbOe/ghqnsUtvfa/jNaKXQiQCM=;
        b=QhwOcBZOWLGjsfNhf0SmhGF/21cVpTSAl7TSAFs7rcCtjkeoxYwLHnTI3x3I3dJQoN
         93JBoBg9j+fVXlqirX7ttV+XpSr6GhKoo9sA+jCldeNtNahr31EHAuM7lS2i7tNlUo4q
         0fyIyWUJsygLjvCJQDeqELPrfHlRChWw+Ms0rxOaBrqbCMPnUV8Iq1bEQ/oiLnB6VWTG
         w+qnuMrLNayIDVlQX22CLQL2WIV0IT63+7oFdeltOURNmQaqGOeVrsF3RxQUuOxZ+DOc
         Y2OzV5G2mEipVTEwCuCMl69vlCTa0CBotCdmWU6OXyADoVC1d2o339rDE+2LtdazS/d2
         jw5g==
X-Gm-Message-State: AOJu0YweXLOHM0L9OjzLNkmqT9Ng0JpTlpkhYrA+QYpw0FW55lCkoPtX
	iGRK7ZViE7R77mLr7pJKV/6OCCDHLXGImz6+qkNLYnuHSZyORQKvYtcnbHp+mm7j
X-Gm-Gg: AfdE7cn/B7kg+UEDZ70J3ajypFDywTqMtlsiXlwLAAkX7/E3yrg2+oDMJKmCWWNVq2h
	HMABh5ZEb3OqKLCP2q4NAYoVq0RJg2jOOCG3fxMojGhNRT+BvhKoPipPrtPp9EXavla1k3/+K67
	8I+mwcoCzJ53/j0Db3p7LAkQO2P3UpeM+qaRNyrrAhL/eHwTtaoF2p+18ozIQm7wPXWO18zcxRk
	Ag/ynMGye/KeCOrEWF/lVrTnDCeIGeoHII+kDWcKFuqk6lthHDIlM8YIuZEzmtcBqV6TkeYd61T
	HhU0x/q4pg3d5lHX8wVbtAcXnBjbd9hh5Eq4u3CsYHBZZyHN704NmNgKft20QtODR1L1WSWRbDf
	KXnKcvAxV9roqfTADsC8GFjNbfJjUckXQ2hrLVZVYmJn33ayadpyRFJce0yNSXXN+GJS9nyoBFY
	iVpnPS1DmbxSA0gMEtVtE36p/YuyOJZK0+F29Sm94gQFxkY30CjFt46kdtwN5LlS87HZ1ObZvbz
	0JlOzIRMUhcWM561RfUANv7cdthI4MklQlgQoOR9qrk05LZfTnGB3zjgWXPn4ZmBCvE3YJY+8pm
	/4PO4Y12lDcsU+zpZPBNqW5TyOw=
X-Received: by 2002:a05:6820:1987:b0:69e:31fc:d12c with SMTP id 006d021491bc7-6a12300790bmr198660eaf.4.1782246012713;
        Tue, 23 Jun 2026 13:20:12 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:12 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 01/16] cifs: define variable sized buffer for querydir responses
Date: Tue, 23 Jun 2026 15:13:28 -0500
Message-ID: <20260623201344.2043841-1-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

QueryDirectory responses today are stored in one of two fixed
sized buffers: smallbuf (448 bytes) or bigbuf (16KB). These are
borrowed from server struct and are not sufficient for large-sized
query dir operations.

With this change we will now define a new buffer type specifically
for cifs_search_info to hold variable sized responses. These will
be allocated by kmalloc and freed by kfree.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h |  2 ++
 fs/smb/client/file.c     |  2 ++
 fs/smb/client/readdir.c  |  2 ++
 fs/smb/client/smb2pdu.c  | 14 +++++++++++---
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 82e0adc1dabd..79876c062d1d 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1391,6 +1391,7 @@ struct cifs_search_info {
 	bool emptyDir:1;
 	bool unicode:1;
 	bool smallBuf:1; /* so we know which buf_release function to call */
+	bool is_dynamic_buf:1; /* dynamically allocated buffer - can be variable size */
 };
 
 #define ACL_NO_MODE	((umode_t)(-1))
@@ -1904,6 +1905,7 @@ enum cifs_find_flags {
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
 #define   CIFS_SMALL_BUFFER     1
 #define   CIFS_LARGE_BUFFER     2
+#define   CIFS_DYNAMIC_BUFFER   3    /* Dynamically allocated buffer */
 #define   CIFS_IOVEC            4    /* array of response buffers */
 
 /* Type of Request to SendReceive2 */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index b60344125f27..fe862bcc99d1 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1563,6 +1563,8 @@ int cifs_closedir(struct inode *inode, struct file *file)
 		cfile->srch_inf.ntwrk_buf_start = NULL;
 		if (cfile->srch_inf.smallBuf)
 			cifs_small_buf_release(buf);
+		else if (cfile->srch_inf.is_dynamic_buf)
+			kfree(buf);
 		else
 			cifs_buf_release(buf);
 	}
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 1ff77f3d1de0..a50c86bbe60f 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -732,6 +732,8 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 			if (cfile->srch_inf.smallBuf)
 				cifs_small_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
+			else if (cfile->srch_inf.is_dynamic_buf)
+				kfree(cfile->srch_inf.ntwrk_buf_start);
 			else
 				cifs_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index fbeb2156ddb6..b4cd5514b77b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5636,6 +5636,8 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 	if (srch_inf->ntwrk_buf_start) {
 		if (srch_inf->smallBuf)
 			cifs_small_buf_release(srch_inf->ntwrk_buf_start);
+		else if (srch_inf->is_dynamic_buf)
+			kfree(srch_inf->ntwrk_buf_start);
 		else
 			cifs_buf_release(srch_inf->ntwrk_buf_start);
 	}
@@ -5655,12 +5657,18 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 	cifs_dbg(FYI, "num entries %d last_index %lld srch start %p srch end %p\n",
 		 srch_inf->entries_in_buffer, srch_inf->index_of_last_entry,
 		 srch_inf->srch_entries_start, srch_inf->last_entry);
-	if (resp_buftype == CIFS_LARGE_BUFFER)
+	if (resp_buftype == CIFS_LARGE_BUFFER) {
 		srch_inf->smallBuf = false;
-	else if (resp_buftype == CIFS_SMALL_BUFFER)
+		srch_inf->is_dynamic_buf = false;
+	} else if (resp_buftype == CIFS_SMALL_BUFFER) {
 		srch_inf->smallBuf = true;
-	else
+		srch_inf->is_dynamic_buf = false;
+	} else if (resp_buftype == CIFS_DYNAMIC_BUFFER) {
+		srch_inf->smallBuf = false;
+		srch_inf->is_dynamic_buf = true;
+	} else {
 		cifs_tcon_dbg(VFS, "Invalid search buffer type\n");
+	}
 
 	return 0;
 }
-- 
2.53.0

