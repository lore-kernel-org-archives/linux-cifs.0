Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA4A254AFF
	for <linux-cifs@vger.kernel.org>; Mon,  9 Mar 2026 10:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773052261; cv=none; b=XxbV4o1v7UD76dLxjAgFioFKilzjbGodMNw9jqIIzyY6r1CmGHp5NTWL7V32+i8oLRYoG9IZfR4wgCMJxk7QlDeXNXAdXPcGbHIi44OLr2Wqlb2Flb8mRDjDsQQ8IkN31e1bEomrpJz/s4PC/mq3sR7bScHjBcH2wkAikS+iNF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773052261; c=relaxed/simple;
	bh=I4VhLGxV7OVpyVEPKpRlfLvPe7al9k3jMKaog6stCmY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k1MyKHfV8OVzqAFNNTsaW7oObdbPLz9g7DUgKS/Coc6rZqPeg3tHZtWG3YGrKXZoWQy/VUrxmE01VfurchagC1FKcMU77XuPhs/EsJPInhHyIPG/gWH1Lv+Z6iL7oktI7/29N8lBcSDSMrUAtYrf67HK10/5mQoshP+rff4ooOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dc/5g3dh; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dc/5g3dh"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3597fea200dso6128418a91.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2026 03:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773052259; x=1773657059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bt1A8GB8orVztyFXC9NAQIyKbNAxGtNa35UhGGLkqWo=;
        b=dc/5g3dhL1G4eHzFA2hkVuqy4NHOHi3rJmR+wQb76eZQugJxSWM3amXwMm9zealzvm
         zm/BGdu+HimBOByCXShWgvWr+0Th0vERQ6NhxqxzZ1trGxG/tb/nZHpS3hQmnL4w39uH
         gtW4+ieRdnsIFw94S4+sUTCzamVCksWmrOrwni7N4yKx9StgBEiTNelSFf3u2yiTjuvn
         Cg7l/kbplAUwmDTY1hAnB8FXiwlv43a+Tmz7ez7PnxhaZQPT5Oigr05o8pu3cSaHabes
         69DPhCoKMfrPnOeC9m7VjVMhAtGm7rHuVNgez4PIYwdKxRKWnZPajsU6IT7bCE+XLrGM
         n0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773052259; x=1773657059;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bt1A8GB8orVztyFXC9NAQIyKbNAxGtNa35UhGGLkqWo=;
        b=vPIv3XuAhQYK+FPY+3o3lIKrVsWrGILpjEPu7gMbCrXt3i3S5Sv70vtkEWclLxBcpJ
         AoE9ZWZsFW02CLJ3kJQABgVtvJxzur1EWhb4+0Lo53NtTg73VeRMPbGDuj45iuZSyVbg
         ekp4gU1p64zcbxW+SDgDCmirOiV9iJw4Uef3H0mVVBCdMNzWB9NGTg+NWrh7mfVjR3AU
         gBWbd86OnDgk5kR1p+rgX1AZNbMuerpoJY6kaIr0N9liItmwjjIv+9AfdCePXzBFX0D6
         kCwxy9QCx8I10yfU3aCIzn6GD8dNJam5RpimFYaqs8YQSwpJek7792GdkhcJ8XLhymo9
         86pQ==
X-Gm-Message-State: AOJu0Yy6u9A1pN4A3E/a7lAsHD3gMrgwiYvMdiTiozyJ1679A8SHADhv
	mNur6CKAP6Ya30/gmsIkcOou1hR0Y06V5lPiiFi2w1tZf02Lf95tUYVMhHasc8Ks
X-Gm-Gg: ATEYQzzgEOoJ/V8fdRXadD8UupUvTyg13o19QhTyFJEx8G0TzxRRtg/AjM7vOlPxdSA
	ZH3Aw8Q9lhfe92NbzpQa9U3cTKPsP3W+OU9K/tLADCWgNLV9OoLP4K8GzjyPdigW9Nts7TsEFG/
	tvwpiwiRZvAbwOWA5hED2rHvv0JhCAl4lBVXel+LyYw+VVDM9Q+DnSnq4VvqpiOnZAHoZWN343y
	ojrXUj3O9O4WtYLnPbKKOQLwQEjHI4YtBgdUD0LtwsYhbNXxOG2ilnlInIh0/zXFcr4aFKdNZlJ
	WEAsVMFJJIbb0Cx57jK2NtBPHqvQ8aRWSsgERSAMYaTGB5vG+266qdVinsX53jtVeU77z9MwgQQ
	+vZPndEs5RnFQDjuGe7vKE1/skb5Qm4tAJJJskAOkJTsjG2XAnOUJY6PJ/tew7lB/h6R2YqzlwZ
	3bCCgZHps1HPWC6vM9thO1WtyliDsH+dnj/tWk6mGGUPBkaY4aPPtm28aejQWbCw==
X-Received: by 2002:a17:902:ce88:b0:2ae:593c:48fe with SMTP id d9443c01a7336-2ae823cb7d1mr107829595ad.13.1773052258942;
        Mon, 09 Mar 2026 03:30:58 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([167.220.110.101])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ae83e57c1csm154206615ad.18.2026.03.09.03.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 03:30:58 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	dhowells@redhat.com,
	sprasad@microsoft.com,
	pc@manguebit.com,
	ematsumiya@suse.de,
	henrique.carvalho@suse.com,
	bharathsm@microsoft.com
Cc: stable@vger.kernel.org
Subject: [PATCH] smb: client: fix in-place encryption corruption in SMB2_write()
Date: Mon,  9 Mar 2026 16:00:49 +0530
Message-ID: <20260309103049.22169-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMB2_write() places write payload in iov[1..n] as part of rq_iov.
smb3_init_transform_rq() pointer-shares rq_iov, so crypt_message()
encrypts iov[1] in-place, replacing the original plaintext with
ciphertext. On a replayable error, the retry sends the same iov[1]
which now contains ciphertext instead of the original data,
resulting in corruption.

The corruption is most likely to be observed when connections are
unstable, as reconnects trigger write retries that re-send the
already-encrypted data.

This affects SFU mknod, MF symlinks, etc. On kernels before
6.10 (prior to the netfs conversion), sync writes also used
this path and were similarly affected. The async write path
wasn't unaffected as it uses rq_iter which gets deep-copied.

Fix by moving the write payload into rq_iter via iov_iter_kvec(),
so smb3_init_transform_rq() deep-copies it before encryption.

Cc: stable@vger.kernel.org #6.3+
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c43ca74e8704..5188218c25be 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5307,7 +5307,10 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	rqst.rq_iov = iov;
-	rqst.rq_nvec = n_vec + 1;
+	/* iov[0] is the SMB header; move payload to rq_iter for encryption safety */
+	rqst.rq_nvec = 1;
+	iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
+		      io_parms->length);
 
 	if (retries) {
 		/* Back-off before retry */
-- 
2.48.1

