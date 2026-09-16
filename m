Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FD74A0918
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 21:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594480; cv=none; b=dNioRpMZfv75C/ZY8YQi1gAu72tXUvx7nsH0VcyxsqG+W0bfltybEPfui2+YJLZml7UBZ9A+VRxMskVTnr3x49yBgFucdlsbt8BM6QmvNJCZ1dwOIRJdCl6KRuI3Z3Wfb6W9xZy/EqEVH2BGUCq/ZhePYjn250knTzTwzZ96vC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594480; c=relaxed/simple;
	bh=ZEjT9QkVDXjtiRVIOkOW+oLyN5Rera53gXA9EX2Z2QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=casINuYFxn+Tz2QcMCNGG8Dbs0cmTAadE9Z22KJc843z5SrRfWniP5UILXI+XYkLkZPzom8yKDkEh+Rh2uzVsPRANtdCICZrnUhi4cErJixfWRFd8sWg0tgV0K4IulxGc4rPN+r9PgwhLI6uIkvJYo7VcB//X/uLQPyjc9oCcg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PSv4/SeE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tW4iLm1S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PSv4/SeE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tW4iLm1S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789594464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MPdJ72Rfzs/Tw7UY41TH5Szt4fBejZwkqr1D9WZOaks=;
	b=PSv4/SeEr7vb4pU/Z9BHdk7ebbGDeHJyoqDPpP5dnjm4DaKrM4hgjdMMgQ01TjUObGpIrS
	hMCMJZIWtEr+/eWnrciS4CX2aFu4m+h49Jqj5TOfxqfJNAKBUTq3jX9nS2F6GSt6KZN2ah
	IIuuObWzYjLpaXQUe6eNGcJ7/8hKGH4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-pvReHhv-PiKa96N26gw0wA-1; Wed, 16 Sep 2026 17:34:23 -0400
X-MC-Unique: pvReHhv-PiKa96N26gw0wA-1
X-Mimecast-MFC-AGG-ID: pvReHhv-PiKa96N26gw0wA_1789594462
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90e8dd8be81so2286536d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 14:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789594462; x=1790199262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MPdJ72Rfzs/Tw7UY41TH5Szt4fBejZwkqr1D9WZOaks=;
        b=tW4iLm1SdV/8THJuXX/yuss65R9esOBVURBo2AgxJs4GUqUl5yq2DzFUn2OX6cAlH+
         gdse1tjeNPoGIFWHQJmm8PnSRFrzGeroTzakcbxA6iGBPfcAwmZZeWdvawrHFLZnnw1p
         Q+bphkaDierxFkYwk/jLRoGHhenPMNUBNPUaWtOl5/RU/vD4Jb+pE+JPaXi3seABvcjV
         +4TZTr4fOWcAhzYpLLVSbCv6p0pSZZWrAIv/y2llAy+t7Crg3TIFmciZj7IL5VKeKv6V
         Hn1S6BIrTnTMUYu7FodT7LPibTv9nwb4eFYbNCjvU+B6KbtjQMqS2jZDx0PeU2rRX4IR
         PJdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594462; x=1790199262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MPdJ72Rfzs/Tw7UY41TH5Szt4fBejZwkqr1D9WZOaks=;
        b=zjM+96/4EPIf5qINivnww7ruYKREyC1vcrObsh24iq+c9kU53O266eKgu+4ycfAm+p
         483Nq2HRtAMy93JbT9JlzdZ5IxFBexmKT5xOQ8Vklu++Rl2SlskOceJrM+VAfPWuqHpC
         rICn2OP0oo54h/SJCUn4SIFnOisci5w851mAqquvUQKuClBuZPgAcsuMuLwPx5bSOnUP
         wwuYT0B3XINxaY12P8JQuR6m5jgN6rt2bqTNtgaFGRZQeQDTjZ0jOrjakLyxTs9zGDNj
         slcai5SOl3BeIPCb+7sTRsCAa5d45ezrruMF37p6CE6cQLW2WEYVyMSxmF3cKefw/9p8
         R7eQ==
X-Gm-Message-State: AFuF++kgiPU7E11kWdWpqpSx3t1/X+N2hcDfMFx3cdwX15ILbxzNLcbs
	LR10grrgDI6O+bTJIkl1TSaIJKIng67ni5IafArlZq6XQmIk13pU3FLqoGjwooEpS+JG6FH5HiO
	RnJ6dxo8AIUWYLeZcteG9cg7Tf5z/pL0IRbAiZgb1/FPLkbQ2JV/M3XeLJcd8fWclHSs1OL0ulL
	4a/+0g2LqTM9gYW7Q47JCzng9CUogsiuPlYVC9ewFhy+wvgc4=
X-Gm-Gg: AYBFou03gT4lRpTIuiqVgMSc/pbDYU6rzTByEZig48/7YoG/pbqlG3Hl3ga1SWVZ6vS
	TtDTu/6YaD1q1DiGqYBeMtnaehc32TMznNuiZeNOyW2m8DuUJc9L6axdZFJdYT1KAFDl4YKmDD1
	k2I68ozjMC43CYs4mqnmJbrKI9/P2wIKMv7u1lg29jUpcRZ8Z9wobX2Blf/irwf5MnNX9J8bBpF
	Wnbs56EsgpZCi5IChYaKB30VOiaFmYMoa5vSt5johNT5OxlZ8EWfjnThYyvD27EMQfnRBjy3eSw
	WIwTbjY+Z015DziYMTRFPLCm27OQzcbIiB6P5FxLiZbOdAvo35i/00Z9soV24ifk3RNSh6wbNd/
	nFYCn1rH+2q2eDsQlQwyBa00+iBaKAy99eiq6+XEVKki2BPRdmSPB46hgPN6C72DhVA==
X-Received: by 2002:ac8:59c4:0:b0:531:11ac:23d5 with SMTP id d75a77b69052e-5327ed7fca2mr70841651cf.7.1789594462447;
        Wed, 16 Sep 2026 14:34:22 -0700 (PDT)
X-Received: by 2002:ac8:59c4:0:b0:531:11ac:23d5 with SMTP id d75a77b69052e-5327ed7fca2mr70840791cf.7.1789594461708;
        Wed, 16 Sep 2026 14:34:21 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620d4cbbsm32447431cf.28.2026.09.16.14.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:34:20 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v5 8/9] smb: client: fix potential OOB read in smb3_enum_snapshots()
Date: Wed, 16 Sep 2026 16:33:59 -0500
Message-ID: <20260916213406.1496960-9-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916213406.1496960-1-sorenson@redhat.com>
References: <20260916213406.1496960-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If snapshot_array_size is smaller than GMT_TOKEN_SIZE,
smb3_enum_snapshots() sets ret_data_len to
sizeof(struct smb_snapshot_array) without verifying the actual length
of the server's reply.

Because SMB2_ioctl() places no lower bound on the server-supplied
OutputCount and allocates retbuf to exactly that length, a short reply
results in ret_data_len exceeding the size of retbuf. The subsequent
copy_to_user() then reads past the end of retbuf, leaking adjacent slab
memory to userspace.  The subsequent clamp check is ineffective as it
only reduces ret_data_len.

Fix this by rejecting replies shorter than
sizeof(struct smb_snapshot_array) with -EIO. Note that the bound is set
to the 12-byte struct size rather than the 16-byte
MIN_SNAPSHOT_ARRAY_SIZE defined in MS-SMB2 3.3.5.15.1, because 12 bytes
is exactly what copy_to_user() attempts to read.

Fixes: e02789a53d71 ("smb3: enumerating snapshots was leaving part of the data off end")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ee3c98e3f316..3464470d3297 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2463,8 +2463,14 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 		 * and retry the ioctl again with larger array size sufficient
 		 * to hold all of the snapshot GMT tokens on the second try.
 		 */
-		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE)
+		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE) {
+			if (ret_data_len < sizeof(struct smb_snapshot_array)) {
+				rc = -EIO;
+				kfree(retbuf);
+				return rc;
+			}
 			ret_data_len = sizeof(struct smb_snapshot_array);
+		}
 
 		/*
 		 * We return struct SRV_SNAPSHOT_ARRAY, followed by
-- 
2.55.0

