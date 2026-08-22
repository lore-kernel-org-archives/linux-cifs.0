Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E4438E5FF
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 21:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787435747; cv=none; b=RE7NTBYGr5uT5YpNBLzU69Y9UaNY7pBg2MRL3C8NYCWSMXwtAEVyz+1IU3UVGwqvR7/eOYskwp0QAozlmwHFUY4XTMoxMA3hCnHVm48sKF+knoS1UTy7B1Mofv1v9gkqKDMuJbS7EsPnj0ewZcxgkXVky6X+Wp1brYAx/1I2Vjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787435747; c=relaxed/simple;
	bh=cN56vkqtUcNihjn+Hz//y7e54+XzLhZoycPV1BPVx8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Go8R8eqb8Dpv8lWrshTv/uxASVF8AMpw6fxiYlQeK1FYd89i1yT4q8TPdEx+YqLeOrMsVNyvibSwRaJZB4vxmmyQvmsvd3mhk8/foY4O/5tzn3zxC7tXDI5RL63MFZ5SwdHluf4oxIx+ktKE4LwNeE48L5hJaRll8e4Mp0aArXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UW/VOOGK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ez50fWur; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UW/VOOGK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ez50fWur"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787435742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SNvfEtHsgFIZfKx8urPXlA3nvaULkRFJM4C3FTjbo5c=;
	b=UW/VOOGKxVAgS+doOij8UkjkUc1ditI6BtMcw/5+RxXNXL+chxT53nneX6YJxIG7u5JhGO
	o+2o7wrPjaMLzkOB7MCD2FsUiBtUiviUS1fpTKt2hKnS4Apywfi/7M/xUgVchyZUex11jO
	QDeIDRdSPpcLGmrfZNYgDaAKwyql9B4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-EKxPeR1KMnyHYEuml_2t5Q-1; Sat, 22 Aug 2026 17:55:41 -0400
X-MC-Unique: EKxPeR1KMnyHYEuml_2t5Q-1
X-Mimecast-MFC-AGG-ID: EKxPeR1KMnyHYEuml_2t5Q_1787435741
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-9308eafb465so391180885a.2
        for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 14:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787435741; x=1788040541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SNvfEtHsgFIZfKx8urPXlA3nvaULkRFJM4C3FTjbo5c=;
        b=ez50fWure77IxWkITsMOQ6BNhOBZ/rtty8NLZjgh/BylLhDqPWDgorc1v8sAbizVVz
         V3/59/RddDBW4P2ow4YMC5KoMfUZVQxhJmJLsmC5snUhG+nStz0oItaLL0iqGW1uhIhw
         Kkr1ugk5F6x6qJTMGcTk+iDv16q+daVscQRShKOyCocjTZ0jg3XyRvkJSpI1rrqD3uNZ
         d/nNPffIHBQPxCAQc54Pq6dhNhAEUY304ktBrvOBoVZzWZ6QN5+hShSUOFLyc7lbOHZw
         HAuB2eChMytL5ToGO9TCIGUateMXK3LlaKpoO20UJ7x9NnrX7P3Kxa/OEWtFaIK5G3xY
         ohPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787435741; x=1788040541;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SNvfEtHsgFIZfKx8urPXlA3nvaULkRFJM4C3FTjbo5c=;
        b=LyQzvXTwTFRC2M16r9tKA4S903ombYvxRBeEfqO8Sxe+LrZ78R8NH9nlkW0Yh+F6hR
         kVsPkxIzNBEK0kGQbQIWigHUTVnBX9OcM4GGbPA/k5XHTSoAXiio0ER3TcLm1a1Pwhvr
         wiEbf8de+nxsK7HKbfkkv7XfrxwDW6YSUe381heRHvomx9Zr7EYHfygXBH55xy5xMhux
         ReSMp5DcKc7KOBYwBSE8wKGGAprPQlP7Mn8jL6ftT3iJv0NzGwGvI+MaCRwSjgTIiZis
         tJhlEoNjlTIyzOXP1ceYlpCTQUnoisGLxvCWusbiWOeNHyWGOyt+JWFiSYbXe2uoD13M
         R22Q==
X-Gm-Message-State: AFuF++kY2Wh2P5DCY9fXhUy9liH/kDBd3IpvbY1VQt1NGFQBtCMWY8aC
	G/lfeM3K1iwvhgR3qjXmti6QcooSSHmvt1VgM3B5T3as/78hAXNV976lL3kUCQTKO984fW3jWWa
	0zMacWzvbItaC+88VDusZp+E284lIUjRrIF3iU7/XEBrE2N9zh2RuvouIS/9nnWxAnFl4TT6H8L
	aK22azfLCM6EoWFSWRK76c/m3wzzG8ZEtoV6fBeBb4j8JgdOQ=
X-Gm-Gg: AR+sD106i0ss34ppxfa+OYtBkp6ma8hgXsoauAg0gxL7Fsvtf8veo2EtNA+KiZ3/vu5
	IL4GpISXveKTbxcGSZxWrm2WxxLcWEY6V+vApMWXS2SFFMUAgNOl/WQea7DyfgUzRsroXeJRs5p
	nc5qGiQPHxIPOvv4wqcwdODrnHwUD6tDq+cGUhPAX06Zvrbc/RRsmW5uHO6aWxXHlAF/8oNhnS3
	Dl6P4nZMxZjaGxBDZq9ROFoIkgzC8lI4KSTu1EHzqFYfbQJzLhO/Ao4wDXGu8OOUztS19p7he24
	9DU0GvoLdTLM1HowqrwPWMZ49mz+SmdAum9kY7hYdNroSokTOy34zL63bHuKe3LTMB9KtDNALyV
	VfoEsPkEKBM4u6ooBC0yHmkDYH4Xn8tpADUCY9AjYV1HwBC7P4S9h8ysxfrRjgp2Ihw==
X-Received: by 2002:a05:620a:280c:b0:930:f129:1a45 with SMTP id af79cd13be357-9374695204bmr714076585a.30.1787435741072;
        Sat, 22 Aug 2026 14:55:41 -0700 (PDT)
X-Received: by 2002:a05:620a:280c:b0:930:f129:1a45 with SMTP id af79cd13be357-9374695204bmr714074185a.30.1787435740474;
        Sat, 22 Aug 2026 14:55:40 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93749d9544dsm186786985a.27.2026.08.22.14.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 14:55:39 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0
Date: Sat, 22 Aug 2026 16:55:17 -0500
Message-ID: <20260822215517.2353835-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With len == 0 (clone to EOF), the effective length is computed as:

    len = src_inode->i_size - off;

If off > i_size, this is a negative loff_t, corrupting the ByteCount
in the FSCTL_DUPLICATE_EXTENTS_TO_FILE request and inverting the range
in filemap_write_and_wait_range().  The existing off >= i_size check
fires only after the ioctl has already been sent.

Snapshot i_size_read() once for both the bounds check and the length
calculation, eliminating the TOCTOU and 32-bit torn-read risk.  Reject
off > src_size with -EINVAL.  Treat off == src_size as a no-op,
consistent with __generic_remap_file_range_prep().

Fixes: 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifsfs.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index e9e5ba4fa865..d8be6c707b62 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1415,8 +1415,19 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
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
+		if (!len) {
+			rc = 0;
+			goto unlock;
+		}
+	}
 
 	cifs_dbg(FYI, "clone range\n");
 
-- 
2.55.0

