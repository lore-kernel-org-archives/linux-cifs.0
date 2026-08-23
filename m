Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8970637D131
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 18:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787511517; cv=none; b=jvYgildBqtlSFBnuZ+KqEPQ0UtFgJy4a4KZu1joc2yU9l0LahsIB+wxqh7YFot32HDP5jdAaiqiiYWot2rPWhk216scyJqerDNq/QTAe6cPoN0GdeVvZ/fsQ71vns0m6CQnGDlD25krz/uTLDAu1mkwtbilvGtEJr9VQctTvPvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787511517; c=relaxed/simple;
	bh=bnE+FSzqjNtL1H7wkLOmQEnV0PRbeLockTJl2iVs8IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVLT+Xsev74dXmUoglb1rbLxChllANp6jpVSOuxjO5ROQtqpNBsl0d5gmKnKL+KW3ptJ1EDy0z48IZxT7R4Mj8VJjBHuPres/nWtRQLiPJmhZ7k0spHf4AheKd4EUhe9fuFc118PxIm+hJRhv859iwjLiG/8HP/gO6CdHmA8NOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q4ymDQIf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tTcXJz+C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q4ymDQIf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tTcXJz+C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787511514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yc9hSSoUhAGZ2KNjDSvIAWtYSFJOBn5h7x8TSBvchF0=;
	b=Q4ymDQIfcS6WkcEQR+1r/0EzcJbUCQNO3H3v2tPc7KfOQBnBxtrS2d61weF9Ec7TXBljPU
	qLqhLg4qXzz+GCQ3p21CodSdZuosJaIc2B4Z/1Vlg4A3v0V2cunRZEFxwBVKSxsHU5YhFZ
	8BHsm5ef1W+/EwuZ76LwQpDm/Dvwz3k=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-LZbA_LL3M2SaXZFVgUnNMA-1; Sun, 23 Aug 2026 14:58:33 -0400
X-MC-Unique: LZbA_LL3M2SaXZFVgUnNMA-1
X-Mimecast-MFC-AGG-ID: LZbA_LL3M2SaXZFVgUnNMA_1787511512
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-44aeefa1a30so6848256fac.3
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 11:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787511512; x=1788116312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yc9hSSoUhAGZ2KNjDSvIAWtYSFJOBn5h7x8TSBvchF0=;
        b=tTcXJz+CmrH7urCca1w/ipxIk6bAsvHOPVhE/HXQOpEseO8djBwxPkEpdci6MOtq6F
         og6mHpTg5IzqQZuWSMon467PBYK8NpCvSrWAOkSkUbbaiMwxKsUgkvNhSZjyiGJuLhE5
         095EupQ4puph+qcaQ7oWkdCT5yqHzIDFJU3jYR4Rjqlki9bNbUdGCfhNgcLOfOqgyLmP
         kcf0HFJ+UDRU4ijKvs16dQGFxctqQN/wCe9bAtJxEyP50O1cIjOeO+98xdZOhLuAFCJx
         QK5wfUeNBE61IKtTTw2H6dYsu/Ex7ok5M9dEa/+YgSeJI5xHwCT0YgDczH4COrD1sSXw
         Ol2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787511512; x=1788116312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yc9hSSoUhAGZ2KNjDSvIAWtYSFJOBn5h7x8TSBvchF0=;
        b=G/TtkK6SUdA/4QNA7A017H41lYkGDP+BiEJtaYsdqAJCapgR1Sx/jyCoGzBy9ongWo
         ThjCaNtT39fyDApeOvgTCGeGRdfsQs0C5NilYpWCz1DFFptElBXLHWEVDqvf9tO+wC1g
         Eeu7enP7K9SzlE3qtZU4sNOvnyf+Y4epJx6C7Z9L3as0O+WQJcKgVewWkvo0TUKTCs37
         zGqjw3TmsqKHuxaHDwt0Gt2No1e6YTGc4uV5tB2er5qMD3Vy+NRxnfDRLmi8Tka83w6H
         aVCQg9/M+Qj21M1cR7jW28Jd2WhDXop4EmWT7lvo1wz0GrIabdn0lvI0QTBhXHqVYoa0
         ZxTg==
X-Gm-Message-State: AFuF++mrPfMPi4J3YU/3AGmKfcR5gaszAlay2RYsDkybL2PNCtBKJn3d
	5SgDENSXRKEv+O+z4Pq7B78VVBPVmRrv/mKmPRl0AIuekmfQHSvSmhau/AhBwN0EwfJlU77l6S3
	MfPJ6BLexQHkSBxD5WmKJZxtVSeWBRm3xwOSHextnXnBgU/LM7oxiyXcBbOKWFtlNWSnoCRxvgI
	GrcLsOg6k/G+fhFJ5ONI6GdYZ4iZnz4W9feEIWUz7BnMJAT3Y=
X-Gm-Gg: AR+sD11dnBrge+9KCKYo2HJOuOAuYWhXirpmnL1xncnBKsRJY/rDoUVx/5IqpUOFEFU
	87aTftzi9A3WhfSJL2E06eJntzeG1ZU9Ex0AbzOYlQyY8Zxs6HtPUoLAsumM8yotZ51R+aDo3t8
	ZfTMdvSL8sTKH8w331u0SOR2sfbrehw/1RPXfD5UN/PLvleZfWc188H7FHYicWNQdffkBwj8V6f
	eqcyzYmkTqovpXaZNAeG+XL10Br30VKxFGXyl4LJGtUmi1XlhuRxf1XFp9k7zXCDqCDsfbXSg5t
	A8yOpN/t+pBG7PNX4U8FYp2kbvVvBe5UcEmT3QcRsxTUQLwlt6DKCzm8a88zEgkmQXt7lxkSnOI
	4Hn1499OJchw79YTQXiGDZjUmLCRKa8kZMG6iKr5ZOpq1PbKj4400l7+mgHkGVfVJ0Q==
X-Received: by 2002:a05:6820:1c93:b0:6b1:4e37:41d1 with SMTP id 006d021491bc7-6b1593ad7c5mr21842073eaf.21.1787511512256;
        Sun, 23 Aug 2026 11:58:32 -0700 (PDT)
X-Received: by 2002:a05:6820:1c93:b0:6b1:4e37:41d1 with SMTP id 006d021491bc7-6b1593ad7c5mr21842028eaf.21.1787511511718;
        Sun, 23 Aug 2026 11:58:31 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm2518710a34.12.2026.08.23.11.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 11:58:30 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 01/11] smb: client: fix NextCommand bounds and aliasing UAF in receive_encrypted_standard()
Date: Sun, 23 Aug 2026 13:57:57 -0500
Message-ID: <20260823185807.3115901-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260823185807.3115901-1-sorenson@redhat.com>
References: <20260823185807.3115901-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Four related bugs in receive_encrypted_standard():

Lower bound: next_cmd is not checked against MID_HEADER_SIZE(server).  A
non-zero NextCommand smaller than the SMB2 header size passes the
upper-bound check; memcpy pulls bytes from within the current PDU header
into next_buffer, and the next iteration casts that region as a fresh
smb2_hdr.

Upper bound / trailing slice: the original check uses strict greater-than
(`next_cmd > pdu_length`), so next_cmd == pdu_length passes; memcpy copies
zero bytes, smb2_check_message() rejects the zeroed buffer, ret != 0, and
free_rsp_buf() releases next_buffer (aliasing server->bigbuf) while
allocate_buffers() still holds it: write-after-free.  Even with strict
less-than enforced, a next_cmd satisfying next_cmd < pdu_length but
pdu_length - next_cmd < MID_HEADER_SIZE(server) leaves a trailing slice too
small to hold an SMB2 header.  The next iteration reads shdr->NextCommand
from uninitialized slab content; if it reads as 0, the else-if (ret != 0)
branch frees next_buffer, again aliasing server->bigbuf: another
write-after-free.  Replace with three unsigned comparisons that avoid
addition: `next_cmd > pdu_length` to guard against underflow, then
`pdu_length - next_cmd < MID_HEADER_SIZE(server)` for the trailing slice
minimum.  The addition form (`(size_t)next_cmd +
MID_HEADER_SIZE(server) > pdu_length`) wraps to zero on 32-bit
kernels for next_cmd near UINT_MAX, silently admitting out-of-bounds.

Aliasing after goto: once server->bigbuf = buf = next_buffer and the goto
fires, next_buffer still holds the live server->bigbuf pointer.  If
smb2_check_message() fails on that iteration, ret != 0 and the else-if path
frees next_buffer, freeing server->bigbuf while it remains referenced.
Set next_buffer = NULL before goto one_more to prevent the aliased pointer
from being freed as a standalone buffer.

Decrypted extent: decrypt_raw_data() moves plaintext to buf[0..buf_size-1]
via memmove, where buf_size = pdu_length -
sizeof(struct smb2_transform_hdr).  Using pdu_length as the upper bound
allows next_cmd values in (buf_size, pdu_length], letting buf + next_cmd
land in the stale 52-byte transform-header residue and memcpy to copy
stale ciphertext into next_buffer as if it were the next SMB2 frame.
Assign pdu_length = buf_size after successful decryption so bounds checks
and the per-iteration decrement operate on the correct plaintext extent.

smb2_next_header() already enforces the equivalent lower-bound:

    if (unlikely(*noff && *noff < MID_HEADER_SIZE(server)))
        return -EINVAL;

Apply the same constraint here.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7d6738ffcb80..e75420dbe950 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5242,6 +5242,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	length = decrypt_raw_data(server, buf, buf_size, NULL, false);
 	if (length)
 		return length;
+	pdu_length = buf_size;
 
 	next_is_large = server->large_buf;
 one_more:
@@ -5254,8 +5255,15 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	}
 
 	if (next_cmd) {
-		if (WARN_ON_ONCE(next_cmd > pdu_length))
+		if (next_cmd < MID_HEADER_SIZE(server) ||
+		    next_cmd > pdu_length ||
+		    pdu_length - next_cmd < MID_HEADER_SIZE(server)) {
+			unsigned int max_next = pdu_length > (unsigned int)MID_HEADER_SIZE(server) ?
+					pdu_length - (unsigned int)MID_HEADER_SIZE(server) : 0;
+			cifs_server_dbg(VFS, "invalid NextCommand offset %u out of range [%zu, %u]\n",
+					next_cmd, MID_HEADER_SIZE(server), max_next);
 			return -1;
+		}
 		if (next_is_large)
 			next_buffer = (char *)cifs_buf_get();
 		else
@@ -5291,6 +5299,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 			server->bigbuf = buf = next_buffer;
 		else
 			server->smallbuf = buf = next_buffer;
+		next_buffer = NULL;
 		goto one_more;
 	} else if (ret != 0) {
 		/*
-- 
2.55.0

