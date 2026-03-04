Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6FF3BE14D
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 14:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772633122; cv=none; b=BUBi7L1OS40T/tWrMdNo1IOowjST1yvimERD5SDF4jQMV1tmkqBQWIktZTbjHwXOr1pfEd0RW9gDQ04qsuZo29ZgoKbzWbN0USq6wMtAM876MS1ziwmJL1dmG1yo/Taoxh/giPgU1SdHn4ybhrrONUKUG+wZr1mqXu49JfwOiI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772633122; c=relaxed/simple;
	bh=BW/nCNQi/Wwtq8VceluTVWZMpfy1RTkmPNQfQ4CSMX4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Zy5ZepkhcAKijZjNya3uluurhcYiES5oIJSvgV3ksYlEvFM8wlRsCqGw3EL9BY81okSuWPAxwFxWe8xFUu1sZIsQPig97BRJGU4xfURf4jLG/KIoyzWOCmiGdZ6wFNcIMH6Sq/UFoqLbweIXhe6fpNwOvbE9vcTTiDNwii1z3KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TLCiZyQh; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TLCiZyQh"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3597b474cbdso2059562a91.1
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 06:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772633120; x=1773237920; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Drhy/JUcroGEZ7sou8Wymaklx4bBsa8tDfSu0E7JSNU=;
        b=TLCiZyQh6289c3qBuapXJreiC0O7/FJq9loLu+GA11pE/4BpFybdYYdmg5cQS3K9bE
         bsI5Wxl9LNyAYFvkLxBWcdXzdSpbUy5AHaFxkX1kWIqfTrv6y0Bj5RH5ShtLWiFNP1UF
         iGY4ag/es4PoyjApHyiVXHBtJvT8MYYEOHdznVAImlsQ2bo8L9iD2XwFRc4BD8euMO+U
         UkKAWyKw3n10ve1VrPmiIKguuJDUoL3WI+/2jPng2rKRkuE3oxDEXZ2Pq5i3TQSyLgUw
         LovtbUoLvuFFaxH+R6tGwWXWYOGLKBjGVVVDdnw+3d8Rvung3bPhACSnthe3CgNpL9tM
         PtOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772633120; x=1773237920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Drhy/JUcroGEZ7sou8Wymaklx4bBsa8tDfSu0E7JSNU=;
        b=KmDWa6ACdMFUJB2nzSnzgY7YW3H3Y665IL9crQOM2UrfXhTc1sxYIXQPFCn5HAuE6L
         KbjUVY6g6I+Wel6o6qJH5ASwh0wuhcK0jiXZSdUmYNa70kZocsNUNc8RmwqrZovBUCpd
         psDV1RssGbyo38f7JASkyIZoHGlbRK8NV34GHrrN1ywZVo9bXLS88ePIs4a3SMj8sOtO
         irpFvlQ8/sCRKNeQTBvsSEqGOZgUOX9gxB2BIlMjyA/XznEFEXNjIYXtE/MSGIlTE6yZ
         UbjuNrP1mN6/TNSKo5hL+7+OtlZY6aV0SkKOTnBzf3OhVUxVNHRY89CMaaRNMuY7pku2
         UOGw==
X-Gm-Message-State: AOJu0Yz/ZwZT088To8Nz8nqRbp9+NdoPaZJdNeXLHi6QVRJq5UK2Grnf
	l/ZodVMZWmVKh3mPpvF1gl4jleUFHhp61MYe/1+F5XbTRdYuxyl+mvyPVzfnSlfF
X-Gm-Gg: ATEYQzwFfvF7vr/kZbudsSsCMUc7Hv8jQEH2y/KhP07N7+EuxNGOdZkq4Ecx9y8rxor
	lg9tG+Y2gBlxhGbhwVigMq7N4nI695hEvCb7D1jv2i5vpZ8zVrgu3OsrC+YjIIcau1wg+gLrjuN
	7Y7Q0l9n1VAGbcar8OwqBFPv6wUOJBPcNVPcXh1p0FBZEO0P5gW8eSY00nl/n//lAtWLl71mM2z
	jr4qpdCCGZGizgKlBsRaGxdLvXlsHPcmvdb+zIT+Y5vy/c/O2TUAWCgzgzcP7n53ctzs1Cb8HbQ
	bdW/50K7TRLAq9y927KlCKzkPhcuOC2D/FOif4AwgmFHRxhLSWePRvWfHr60samr5umoeLvtyvy
	Xv+moONtrxuZkpXIQYGSZAi3qaicv7yAF/a/HLfiZQs7lmFys/XxKLWquFMN5VzY/Nm+oypTet8
	mE1ksKx6jBJJZaiyLowIpwG2G9AnlXWLR7y+co+AQPzT83FL7hOA==
X-Received: by 2002:a17:90b:3d50:b0:340:be44:dd0b with SMTP id 98e67ed59e1d1-359a6a7bcb5mr2156907a91.34.1772633120193;
        Wed, 04 Mar 2026 06:05:20 -0800 (PST)
Received: from bharathsm-Virtual-Machine.. ([167.220.110.53])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359aa40c1bbsm451953a91.14.2026.03.04.06.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 06:05:19 -0800 (PST)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	dhowells@redhat.com,
	sprasad@microsoft.com,
	pc@manguebit.com,
	ematsumiya@suse.de,
	henrique.carvalho@suse.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Subject: [PATCH 6.6.y] smb: client: fix page cache corruption from in-place encryption in SMB2_write
Date: Wed,  4 Mar 2026 19:34:52 +0530
Message-ID: <20260304140452.1606662-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMB2_write() passes data kvecs inline in rq_iov by setting
rqst.rq_nvec = n_vec + 1. When SMB3 encryption is negotiated,
smb3_init_transform_rq() -> crypt_message() encrypts data in the
kvec buffers in-place.

For synchronous writes through cifs_write(), the kvec buffers point
directly into the page cache via kmap(). In-place encryption overwrites
the page cache with ciphertext. If the send fails with a replayable
error such as -EAGAIN (e.g., from a connection reset), SMB2_write()
retries the write using the same iov[1] buffer. Since iov[1] now
contains ciphertext from the first attempt, the retry encrypts and
sends ciphertext-as-data to the server, resulting in data corruption.

The corruption is most likely to be observed when connections are
unstable, as reconnects trigger write retries that re-send the
already-encrypted page cache data.

The sync path can be reached during partial-page O_WRONLY writes when
the page is not in cache (common for append workloads with repeated
open/write/close patterns).

The async write path (smb2_async_writev) is not affected because it
passes data via rqst.rq_iter, which the encryption layer handles
without modifying the source buffers.

Fix by setting rq_nvec = 1 (header only) and moving data kvecs into
rq_iter via iov_iter_kvec().

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/smb2pdu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index a8890ae21714..a88a19dec494 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5072,7 +5072,11 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	rqst.rq_iov = iov;
-	rqst.rq_nvec = n_vec + 1;
+	rqst.rq_nvec = 1;
+	iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
+		      io_parms->length);
+	rqst.rq_iter_size = io_parms->length;
+
 
 	if (retries)
 		smb2_set_replay(server, &rqst);
-- 
2.45.4

