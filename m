Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732DB283FD9
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 18:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787682757; cv=none; b=DBS4abqrSpnUiDjZfr5wkXxtaQ7N47hWFsfT4TEwm2uq6Y0RKtOJu0s2PTGK10HJEPwkUdJzZ4Sjf39n40vTJGqHFjPtIBvXoQ5vWdnbKURKTdaQON07vGx3gSqWvHFrhgMojWLP4tc9R/k8fMIoXukwYBhthRv6lR0hpaQ0uXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787682757; c=relaxed/simple;
	bh=PEUh5RLGTVidTbS/TJT9PVJi1gQFkodyRDfs9AfH9W0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kwlaOXxN3BAN3fhLzlVTE9qMeddTFzJHyG/5Wk0C/f1mUU9518GqdMPtJMi/awy6zHFKX3+JpCVPclPJrN+2vfnU6+6RV/c3I3jN5Zrh39Q5AEy3fHD/V5ILKPfwuSmu5TVvTgZnt6y56LP/1JIUUz6BNk95ysNWAdtWmcDcak0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dal9Q50D; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=P1cC7LUa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dal9Q50D";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="P1cC7LUa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787682755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w+YMnu6id4V5XvUuXw+f6RGrlFEPCBCMRJX1CXIFo/0=;
	b=dal9Q50Du6F8VNqgG/2BBs57FNIZW+dLj4jq1gRV1NnVW3fiH7VQ4o2HTF3OdVY9w6Ien9
	mjJ7GYRXHEvOYNiTL5GV+BYE3+wR0dEnL3cJyilxcJf40OcMNzk0Jin1xqWyPfkjW4hiWF
	SRb3wZ3AVFEsOXu9jTnYPkD0SRzHlwI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-DuaOJVBENY6a0qOgtDyHEQ-1; Tue, 25 Aug 2026 14:32:33 -0400
X-MC-Unique: DuaOJVBENY6a0qOgtDyHEQ-1
X-Mimecast-MFC-AGG-ID: DuaOJVBENY6a0qOgtDyHEQ_1787682753
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8f113592bf3so2600716d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 11:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787682753; x=1788287553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w+YMnu6id4V5XvUuXw+f6RGrlFEPCBCMRJX1CXIFo/0=;
        b=P1cC7LUaBMS/bemdbt8p0lP9ItP8vkiZnrrvyqKby+G6k0rwMWBM1wrtLxbTmHglYS
         vnHT/h0FKoU6phXpa3zShHDOp1zEM93vziiz1ud/wwPe4pPcB05VkElUS3jucSZmmwdC
         W+A6nRb6eYtvxj1cQTnEBcckde8TTGjS6e+U2fE80+jo/DGEcMfNpSLgBwqK/x/k/aXk
         4mC5yqrgvhZXbmaV+bt3XWDQ+O9j9WUNXCxQtZuzOpaJvI+zTTLrnMg7ss2Dl2T9ZMrr
         Auj/1VGcwB/RlMA86VmhPqMEFkw6QyLRsWdAUt+UFu6BSPh3CAttEgH7VQXYRezACYdZ
         /ugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787682753; x=1788287553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w+YMnu6id4V5XvUuXw+f6RGrlFEPCBCMRJX1CXIFo/0=;
        b=dYhG10B7RwDdotAAgLviPtgX3WemI6WRY2YgbICuqMV9t5I2Awm/SeXbZCzuo3ttIN
         SNA2ctZJwu78W4SV0Yh74r7x/SSvLdqw73mGQWRmOBlmQqC8XQcMGHgFjQoxrhYWyjUa
         PcoYexZCxXZ8yaOAMBbZmnsti052MoNvrYwI4eMwkW+RTuMh2g4+91BxA5x+SWwwxZoD
         mysBwZKm8LDLR8xpuio5Hxir6/s76c/WTlMpidoaxgK42169uJzGh7swLQGbR/gFcwHr
         Uk/HIxk4gGfpM9bSn7QMuGvaYawE+VGbsKEvb8UrXquxxPYwEk/uS86UngQRvuQxW2wZ
         C1/w==
X-Gm-Message-State: AFuF++m2i4SI2kBV5Jy+tOxkZ9nNHxi2EoVg/xr6O3CX6oioe1qgyw/M
	rKbtNFWXpjmYySpm2TS0tYRsckc//L76MdxrjpJDN8oV5FGxNe7/GeKeO+PBQZhOBMwT32zU9VQ
	tTA9ggT0y1vRSIf0C2VL1LujNp1OuzCadfNY7SRqTJmD8kKXVz2X0LDWDZX483P2N17KzeWsro+
	envcmaiqsve2HJtwRi8BXtnSnX7a2VLMYZ57unPmwlAOlfJG0=
X-Gm-Gg: AR+sD10+JfaczKYcbpxWvvh2Re3WdMmIA0nBP2Fr2KsmS/7OvYEBPrrPZ6XyGQwQVpe
	hv1gQYnHbMHF4SIt+ZIqp81UxbzCZDZYKLoVYVSLtNkf8T351d5zps4cpMk28mSThXd4ekUECqk
	F7++hdUqoaWJt/oFNTLsPSbLjZJrSPJOt62k98e/RF62R9bOe9Q6s9EVGIlHh1Noc6dOKhAlTyx
	H+1Bba3EPv/LtV14vqGYGTPBZIK8h+jR7LU9SORbJS2F794hX19x5bOXKjFqyRhhf3W7Rr9+OU4
	+A2nfXmiseJIT/gy956fBxFumN4DduMw9doF07aYv6HYatdhbKpgFX7NzXrWtlea/B0tSrGJ+Ar
	UmZklwsYcZMeWhSfSG6aUg7RwKbNIZSKofIyrI/BkWB5fi3iy3cv+PNTWQCZ0
X-Received: by 2002:a05:6214:4608:b0:907:c0e1:62e4 with SMTP id 6a1803df08f44-90cc792d3e7mr7220736d6.9.1787682753016;
        Tue, 25 Aug 2026 11:32:33 -0700 (PDT)
X-Received: by 2002:a05:6214:4608:b0:907:c0e1:62e4 with SMTP id 6a1803df08f44-90cc792d3e7mr7219776d6.9.1787682752382;
        Tue, 25 Aug 2026 11:32:32 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc641a940sm5250666d6.20.2026.08.25.11.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 11:32:31 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix heap overflow in cifs_do_set_acl() from mismatched ACL format sizes
Date: Tue, 25 Aug 2026 13:32:29 -0500
Message-ID: <20260825183229.3799705-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_set_acl() validates ACL size using posix_acl_xattr_size(), which
computes the Linux xattr format size:

        4 + (count * 8)  // 4-byte header + 8 bytes per ACE

But cifs_do_set_acl() calls posix_acl_to_cifs() to write the CIFS
wire format into the same buffer:

        6 + (count * 10)  // 6-byte header + 10 bytes per ACE

For the same entry count, the CIFS format is ~25% larger.  An ACL
with a near-maximum count that passes the xattr-based size check in
cifs_set_acl() can overflow the heap allocation when written by
posix_acl_to_cifs().

Before converting, validate that the CIFS format size fits in the
remaining buffer space.  Replace the bogus hardcoded MaxDataCount
value (1000) with CIFSMaxBufSize.

Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifssmb.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f5aad5f61dce..4ce22fe3cb2e 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3555,6 +3555,7 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	int bytes_returned = 0;
 	__u16 params, byte_count, data_count, param_offset, offset;
+	size_t cifs_acl_size, bytes_available;
 
 	cifs_dbg(FYI, "In SetPosixACL (Unix) for path %s\n", fileName);
 setAclRetry:
@@ -3575,7 +3576,7 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	params = 6 + name_len;
 	pSMB->MaxParameterCount = cpu_to_le16(2);
 	/* BB find max SMB size from sess */
-	pSMB->MaxDataCount = cpu_to_le16(1000);
+	pSMB->MaxDataCount = cpu_to_le16(CIFSMaxBufSize);
 	pSMB->MaxSetupCount = 0;
 	pSMB->Reserved = 0;
 	pSMB->Flags = 0;
@@ -3587,6 +3588,15 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	parm_data = ((char *)pSMB) + offset;
 	pSMB->ParameterOffset = cpu_to_le16(param_offset);
 
+	/* make sure we can fit the larger cifs_posix_aces in the buffer */
+	cifs_acl_size = sizeof(struct cifs_posix_acl) +
+		       (acl->a_count * sizeof(struct cifs_posix_ace));
+	bytes_available = (CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) - offset;
+	if (cifs_acl_size > bytes_available) {
+		rc = -E2BIG;
+		goto setACLerrorExit;
+	}
+
 	/* convert to on the wire format for POSIX ACL */
 	data_count = posix_acl_to_cifs(parm_data, acl, acl_type);
 
-- 
2.55.0

