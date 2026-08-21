Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB8A3BD629
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 18:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787337689; cv=none; b=qhTKJkQmsM84nHswENkqFgjl/t9OdiG7L9NfNl4ICmZ4zwPrNCSB28dC0z2SXV+c3rk+nG7E/YjDF5pgL3FDAEgrQnFMmW4uS7je8ZhHJXnWysWJcO62wcfHGE5ZZFpFb1wwOBizEOCE4u6vRjlsGa+YAMLlDLth9NlLkEMT+60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787337689; c=relaxed/simple;
	bh=VcNJNK//mkpsY1vMPo45uqDEB2rBm3fkoabhapZVXOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMLluLlVYDWbFRq1EvQdfKRh+243rV/A3j7Elkn3F4XP0CwD3w66iEN++RgUx06ROMg3H4lHETlOtTuPG75FeeiWs6CrpWun/1OD2wf12NAi5ZCmspqZvrWJ26IKSpusiZOukzGRNI9Y196eXJ+k6xC5d1JK8/oMO3RdpyBydH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dS6kd5ai; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=f2j98oB2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dS6kd5ai";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="f2j98oB2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787337683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nxW/9v8xImR1zQYOkQ8lRE7EKN7I4YapIqOEEMSl+Rc=;
	b=dS6kd5aiJlcEacy0rOib6QCh9hB4vjDYaT6zb5GgfsW1x2Rw+Ad8seGhA+yOqUQfLxTbsI
	K8WANruPVo8VfsbGhA1UI15PqTO51Pa+bbstah8W31Womeecth2V9sMptQKSVhnDjTMXCx
	F3W641sPeML0HcdfEmhSRy3uqbOI1l8=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-dIK2Qm2MM66DbpQdBLSLrw-1; Fri, 21 Aug 2026 14:41:17 -0400
X-MC-Unique: dIK2Qm2MM66DbpQdBLSLrw-1
X-Mimecast-MFC-AGG-ID: dIK2Qm2MM66DbpQdBLSLrw_1787337677
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-845cc1ab48eso48291617b3.0
        for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 11:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787337677; x=1787942477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nxW/9v8xImR1zQYOkQ8lRE7EKN7I4YapIqOEEMSl+Rc=;
        b=f2j98oB2/zAhwBRa06BA+1mIZMJvrONo2wHB3QOaPMxr5J27wi3asOtoYdHzHIIcuT
         z0xYj9Cn4NrvBkuxvabzLbc1iPAMXRsmWz9blxNfLBlASpmmGH0s9EQbi1urCpwUuUv/
         wz+dhpt0AHsa3Hx5ZSbMUwe2vUIZ50XNxTGTv02aH/8xST+8Kw1sGP/8zInBvN6L841D
         B9Y94xlJUwqnXJJU/CL/8ZJWz1RQwT4bxodt3DACVm2I8CHWcNc338WKFP80dA78QL6I
         us/bOwDExKsb6Kn7LInbWtVjodTL4gF5keCL7viri+g0xhSQ4JLdRAgb3qkrtD3wPgWx
         l3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787337677; x=1787942477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nxW/9v8xImR1zQYOkQ8lRE7EKN7I4YapIqOEEMSl+Rc=;
        b=VKxHP2dpxVECRRGvmyeXNF9KpOcZerCXG/VKDn/mbBNdMgk2wwigwXHLIZDgQGpqH6
         vzG9omNs+GsJrAIAN8zEU7/c9cX/3HC07JoTZde63ca1vp7lG8Qnjokbj4rHeQ04RS5+
         NZYDb7h4a0NrFVCA0Yc0PMAQ4YXjfU6WCKMHVp9EpGpxe81DStWG2UOdElG808F7aWAH
         9UE4yFBEdj0QTcIV3ddF2nOcfedI8iEjhBUFeIrichxAUTBTr0YbUTE6FS/fj8UcETWM
         4nJ7+ltSf80tIiszSXJ9ys8z+e34O8qrUyOwEZ9+JFCvCeyYpPGVb0gJCZRwdLka1K31
         GkiQ==
X-Gm-Message-State: AFuF++kNqq1KGZjwG5/6WJjS4+Z//7fxjNt9glTgIZYYV3F6yFaxkURt
	VEsNmudqmIUBkDAmQ+cZNq6gUpY79Felhm+N336y0l0Z2BR9htyAPGdo+h6FVoHTxBDyD1T5WUs
	hbjkTzadMwcnlJOh84kqhQIXcx8CUd6f2iPBFvBYNXw4SKk7sSMzrDJfyo8YIP7cPpZTwu6elCU
	Dequ9Y0+6PdjvmRHiHYQIsrOvTke1GyM0tAjZIjTBs+Kl9klg=
X-Gm-Gg: AR+sD13qJa+d1BbJAIj/JbRd+8A74FTtiSD0gzvkTy7NIOR99A7xWtNTd8G1AW9gzi/
	5jO4ZTqGaZz73BBY7va4xZEoyDC28Eb39Smu1jS+jg/t8yISHBc1TxSo+nWQ1oPYCkhG1iXgo1m
	7fYdGrqNbns18cbZSPGxMskALgITj2ewRkbYLaEEUMCWu5UnjK8IwfynkeUglvmJPqMtXQE7NZ7
	5D+yxuwKm2GHR2uU0Ji2zublAe555CtN5JOgkDy+3RZr/lODdNCdb6zbNfrSzyjlHkhEGXa9di1
	q6QdW0189lTh+tCWnunt5v9cqbDkab0nF61bbcK4bfmxE80qaJusJAqMcjud6LvXnAkfq3ZFYGc
	xQAvGihxQPT1DlZGRBTlXxXnamppri7eqC/6fhX/BgOGLU/6evBFlXaqbskW5mHV2ag==
X-Received: by 2002:a05:690c:e68f:20b0:836:dbfe:40cc with SMTP id 00721157ae682-849f562d153mr26009037b3.20.1787337676531;
        Fri, 21 Aug 2026 11:41:16 -0700 (PDT)
X-Received: by 2002:a05:690c:e68f:20b0:836:dbfe:40cc with SMTP id 00721157ae682-849f562d153mr26008627b3.20.1787337675769;
        Fri, 21 Aug 2026 11:41:15 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84cabd2861esm539707b3.37.2026.08.21.11.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:41:14 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v4 2/2] cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0
Date: Fri, 21 Aug 2026 13:41:09 -0500
Message-ID: <20260821184109.1834871-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260821184109.1834871-1-sorenson@redhat.com>
References: <20260821184109.1834871-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With len == 0 (clone to EOF), the effective length is computed as:

    len = src_inode->i_size - off;

If off > src_inode->i_size, the result is a negative loff_t, sending a
corrupted ByteCount in the FSCTL_DUPLICATE_EXTENTS_TO_FILE request and
wrapping the filemap_write_and_wait_range() range.  An off >= i_size
check exists but fires only after the ioctl has already been sent.

Snapshot i_size_read(src_inode) once and use it for both the bounds
check and the length calculation, eliminating the TOCTOU and 32-bit
torn-read risk of direct ->i_size access.  Use strict inequality
(off > src_size) so that off exactly at EOF is not rejected.

Fixes: 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifsfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index e9e5ba4fa865..d2a0a9ed4bf3 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1415,8 +1415,15 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
 
-	if (len == 0)
-		len = src_inode->i_size - off;
+	if (len == 0) {
+		loff_t src_size = i_size_read(src_inode);
+
+		if (off > src_size) {
+			rc = -EINVAL;
+			goto unlock;
+		}
+		len = src_size - off;
+	}
 
 	cifs_dbg(FYI, "clone range\n");
 
-- 
2.55.0

