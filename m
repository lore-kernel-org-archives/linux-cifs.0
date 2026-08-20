Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD523DDAF3
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 21:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787260494; cv=none; b=X/iA4GIzYrvhP28BNbK3n0TMvEn0Z52sSr5tG6GBhrhR0b1rlwaNd7bax61U7NVnrr0x6LLS+l+9Z//9G4EkIKRHt0C55XQih0Un/R2EYeOuJLlk+/07EZCo3YAIwgM787I3mUKaIvFf1w+nOyHpQK7nWMDx8aVquFH6/RVenc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787260494; c=relaxed/simple;
	bh=3bWQcr7TNBM46gyKoJNARikO6CH9pGujyVGQNvF9cDo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CPSoyr99s/SSS2rJPaXX+OnEZgowSXiDenJiHJgQSQiNfHKyas9OeEXfzLjegIeegW5rOqtfC9+i6RKXaVDuYMXIrJwxx/mrHsGaVufXJofasajK79lvEqhU+rcqpTLA8I2gwUrzmlmRaaE/5jWLhsRZA6WlSvgXnEi1Z4hykjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i4YV1//Q; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QHFnCtKG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i4YV1//Q";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QHFnCtKG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787260488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=abqScsiBuwtCwb/Z41XnM7DDFxXR4QW8C2iyjS040tU=;
	b=i4YV1//QzNQu15FON4vMizNrppH03zdPvxuJRltNvf7hs0PpRY0tOxH40cq9KUijfo1Qoc
	Wcn4GoNNdFiP4gD88hxJPRlg+bQHgUU+GyIfYep3+Qc7M1utxiAv7NRUmBI8KUHMeDayfI
	zmpW93dhydztQ5VDaTyBjTXvQ7JCjg8=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-pBSbHsvaN36ii41d26hEIw-1; Thu, 20 Aug 2026 17:14:47 -0400
X-MC-Unique: pBSbHsvaN36ii41d26hEIw-1
X-Mimecast-MFC-AGG-ID: pBSbHsvaN36ii41d26hEIw_1787260486
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7ee1e335245so360627a34.1
        for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 14:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787260486; x=1787865286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=abqScsiBuwtCwb/Z41XnM7DDFxXR4QW8C2iyjS040tU=;
        b=QHFnCtKGotoGt1m7MjDG9s5F86wiLnlBRGscWg3CyDNWucZKBR37y44nWPrKtL4wTR
         yag1XLYeNJCQtjwJz9UHxVvBJqaFoLX7KFNvz6Eb8f4TJYKn3WyHM196IZR/hUkYV3T1
         0s2Yxxrsve/J93iI8hD1GIW5onw4LdEzOE/1YDOVXgmPdXGxcoYbFXk3xuN4HYRfZ+EU
         v2LdwdKMCBXggLbjqfK8YsM0kK6SonHO3R7T893DA08ig7WHrodsJblatX3zEMAhdPLU
         IzYXW4Fo8SQDX0ratTljDjl4Jg+h5TroyY1RvXcQa94P4Rdh6RSZo7VgjSUQSt909XS8
         KVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787260486; x=1787865286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=abqScsiBuwtCwb/Z41XnM7DDFxXR4QW8C2iyjS040tU=;
        b=rdmeEz/7zrINz69AS29QPmZk4GaWMA8+dZKpVsCX1cMmnhGK8eM7vDWVsnoYT4Me/h
         CTGX9jmcVKoArgPdGjsRYHvPid+nrvuHDoSyNZhePn5/f8NQi7Q5evT0r/UF74NGNZDs
         yBAVyKeTL4Ok+iHxxXqJ9iPhfM2AXEx6G+apQzeoAd0h3SbDpXNo9CTNunUeWBXOpKwo
         Lojw1cBd3OklawZpskjQ4qODzeJeU38uwd8cdwzSpVIkuOV8isdij2Dzd8vJMxFoFcpH
         bBTFaEAzkXzKcqCqSpY+dKGjxy5b7OYQoQNIh3gKoHCC/PE6Sr4Zw7PiAQncUsPXWRUc
         8MDw==
X-Gm-Message-State: AOJu0YygM81U3QmGGLpNPwIZ0GXyHd48bG0Bk8/Fh60theUuZt9BsV87
	3vUm7xyzDmasolhzy1lErZYlNoz/92jbBttZmiot7wbQKhuNROHYW3OjgVrq/9ttucBQCa6PH7r
	4+nut5v1BRNcIf/7RxKkDOcNrnHTL0+ns6XLsty2CBbPh+GPdE0O+BfqDv3lcsKKM6JsDWtMi3F
	j0icZbnKpQK1Toa2CYZoKN6zdRXxSc3yIUHoiVT1btHAybidM=
X-Gm-Gg: AR+sD11cZbSZ59l6n3TllrK3j3AyVeEf8NxcaNdnGxBb+vDtOFEzWJbpI9KxRQ/+Dfg
	Q2A8geqYvXxUyg3NDturr7OsGI5Sz9jL20poFs30qJEdNuCKNnX7chPgpWgezp7Q+40CrZsgUYc
	+8glh6vRWnB99TLk6lxtjWD/J85G0DLPIMmw+qmCiEaweBYiOiwjlv4cHq4iDFmoxRO6DsOENct
	xMjK5FYs1h/p8YpPsULxep7U+1Qct58dfCsauhWi1VzzZdDxWZZ7vUO07bM5/SC/f252SimyOLP
	yMB0vj030x8dyif3toYqlIqCkkj1lHkXP+ZylTiXljGyoiTPYASQ/YR3YAoG/pDDV7J9+rKN69T
	Pk1cFG0eeIEUPY6CP1HsXAscJA6AxAloij7GmIUOBvbpKg9uGbvqQTvv6ImHQWWz/TQ==
X-Received: by 2002:a05:6830:4406:b0:7e6:cfd0:42de with SMTP id 46e09a7af769-7f461563384mr1555235a34.15.1787260486328;
        Thu, 20 Aug 2026 14:14:46 -0700 (PDT)
X-Received: by 2002:a05:6830:4406:b0:7e6:cfd0:42de with SMTP id 46e09a7af769-7f461563384mr1555190a34.15.1787260485759;
        Thu, 20 Aug 2026 14:14:45 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f43fea4893sm5995884a34.9.2026.08.20.14.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 14:14:45 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] cifs: fix i_size inconsistency in smb2_duplicate_extents() on FSCTL failure
Date: Thu, 20 Aug 2026 16:14:43 -0500
Message-ID: <20260820211443.1472310-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_duplicate_extents() pre-extends the target file before sending
FSCTL_DUPLICATE_EXTENTS_TO_FILE.  If the FSCTL fails (e.g. ENOSPC,
byte-range lock conflict, unsupported file combination), the server
and client i_size are left reflecting the larger size while the data
in the extended range was never cloned.

Save the original i_size before pre-extension and restore it on FSCTL
failure.  If rollback fails, force revalidation instead.

Fixes: cfc63fc8126a ("smb3: fix cached file size problems in duplicate extents (reflink)")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7d6738ffcb80..38bd344a9740 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2200,6 +2200,7 @@ smb2_duplicate_extents(const unsigned int xid,
 	struct duplicate_extents_to_file dup_ext_buf;
 	struct timespec64 ts;
 	struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
+	loff_t orig_size;
 	u64 asize;
 
 	/* server fileays advertise duplicate extent support with this flag */
@@ -2218,7 +2219,8 @@ smb2_duplicate_extents(const unsigned int xid,
 			       trgtfile->fid.volatile_fid, tcon->tid,
 			       tcon->ses->Suid, src_off, dest_off, len);
 	inode = d_inode(trgtfile->dentry);
-	if (inode->i_size < dest_off + len) {
+	orig_size = i_size_read(inode);
+	if (orig_size < dest_off + len) {
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
@@ -2235,6 +2237,23 @@ smb2_duplicate_extents(const unsigned int xid,
 	if (ret_data_len > 0)
 		cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
 
+	if (rc && i_size_read(inode) > orig_size) {
+		int rrc;
+
+		/*
+		 * FSCTL failed after we pre-extended the file.  Attempt to
+		 * restore the original size so the caller sees a consistent
+		 * file rather than a larger file with uncloned content.
+		 */
+		rrc = smb2_set_file_size(xid, tcon, trgtfile, orig_size, false);
+		if (rrc == 0)
+			cifs_resize_file_locked(inode, orig_size);
+		else {
+			CIFS_I(inode)->time = 0; /* force reval */
+			cifs_invalidate_cache(inode, 0);
+		}
+	}
+
 	if (rc == 0) {
 		qrc = SMB2_query_info(xid, tcon, trgtfile->fid.persistent_fid,
 				      trgtfile->fid.volatile_fid, &file_inf);
-- 
2.55.0

