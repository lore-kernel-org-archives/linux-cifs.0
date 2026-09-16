Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA603BB689
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 21:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594479; cv=none; b=Ce0LB7HLJjqtR4Q0dfGOZX0N80U61sAdVFySd2c3A0cRJQWyHBnUXD2gE+kbhUXGzYZupYCRUUhFs99If4zVCPmJsH0Ssl9p+6LPd1kY6HpCEDiUnyMseB8LSmbVUUn0Yvcg+u4rWSjsBQ7b6owF+1BwdfD7JWuzycbE+DrLd10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594479; c=relaxed/simple;
	bh=V3hRYaC6tmgdcsZ5yGYav0Xh/yfqqFN1hacg6eKFoxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SD6Xo5VRTt4zOX87IoIBbqYL8gymeeWrlKtsLSODG9f6BXOy1ICkYxCUiZUiuc123DOvZOJpvQuqLF0eJnMFXVdnoymo6Na5w8l1p3gXl0OuWpsqG/N5JKXeRRCXw+axl6GftboxjmzSs3duDWxHKltqFuLLv1yHtsWI2sha3K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SvmWznw3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oYh2+SWT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SvmWznw3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oYh2+SWT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789594462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVRh5kukn/D6rYTpnAmlPzdqiIatWEMIIV6vU5NUkSQ=;
	b=SvmWznw35VvUGQddGL8yhGrdvajAJIe/PnN9S9ULUfwPFY2tqzsBR1jX+BVxSk9mtq/F6S
	VYSkS4VWFiMSSBDJ/hBty3oZUGVXpIpdgxu1M2uJleTKjQfaZU37WogZNlhzkNJLjqtYqQ
	qI0a1vgdMXFZwK1+MEvvO70z/BmP9d0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-sb5JO-fzP9KKMo1vsHGfSQ-1; Wed, 16 Sep 2026 17:34:21 -0400
X-MC-Unique: sb5JO-fzP9KKMo1vsHGfSQ-1
X-Mimecast-MFC-AGG-ID: sb5JO-fzP9KKMo1vsHGfSQ_1789594461
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-9104c2ce026so3641856d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 14:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789594461; x=1790199261; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CVRh5kukn/D6rYTpnAmlPzdqiIatWEMIIV6vU5NUkSQ=;
        b=oYh2+SWTcbCYrIshkV7BBwSKWeN6i6QVkzs3LdFAlDJliL2peQqvuBnMoSPCUcf2jC
         6wWaS2Z8uOmWFuGfJGNd0h/UfKxw4Wb3HaK+hvuANeAC5aPvbyjs9KCQsR51qhtjYPim
         js5krc2zy3nTNx2ydBK8PfLDgKbpnXsVXaCu/UBPlcSG0GEz2hOwWsFGsKhDZgAM/cNu
         Sh6g3N97Rrwo2FBBLCDTe/phh+VFr9dnwppx4Xvj2cFGM+XCNKHOygRDJv6USktFW/bc
         W0duUhBWerwic9YxrUCQtI5t3167k1eqquocTo1yeDaGhZypOhS69zYb3DRLY684hsKx
         DRxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594461; x=1790199261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CVRh5kukn/D6rYTpnAmlPzdqiIatWEMIIV6vU5NUkSQ=;
        b=E54v9W4mmU+nZAdx+00fVrAImiv9UOQsh70errO/CAUQcjzZHFa7sF3GJdxfBhOZXq
         Hi7OR+IE/IcNExRf2zVe7Q8uI/AtLLFQzJ1rgB7lbkcT5n03oI4EYzNM3P36x4qfYId6
         Y0U41pF0htp2wSIhf6kYaTBvd5L3C7DHzu1ZTGYh3XBe3BtuUUEsX2Bx59EYgCm8xDEi
         r6PlQBnoI4SergSN2x2F23cWhBbCtE/a9gxFmnokijZi9wCrtHrvRayMedALIz4IRMgj
         eootebwa2Ldfztr9YGfHjrPsLzBJeE4dlRvT4lqyWHimfh87yu3oJh6Sp4fBCRpPSRtC
         BjjA==
X-Gm-Message-State: AFuF++kzAi//GY9frT6yV9atAjzYoJ2IBuALpCDJXIj68Vp0EIYBIRp/
	1M/HPX3BnYWQOba8a/o5FmyaofEWoeRso7LEGZJ4qHB9vHS14eSgc8auyhGlrzTItkO/d4k/R9r
	qFZXENJdM9zL9BKzicoZocUW4I/EOE3pisfgCqSmpGyykIImOzU5EgmE5PRC86pxiR8RP0YKDU0
	xNgz2miPcDmwojSUIYXJj3qU6zU9NhN+uWsET3UWrDdNEDVas=
X-Gm-Gg: AYBFou2Sf10h//WXWewH5Y2vpJC0BLvArU0X69M2DGMSeh9Ve8FCRXiFi9CcB1HYaw+
	BwYFLfWZMw7mPAJF62R5wEhSMrM8EhfCwur+1pL/7T3wxCC826axPi2tIwTD4+TWw1JtPsYMY0m
	d8a+oQvG9vBJAmRC17WbPfnmDxF39P4h6dXurnIEwnxfQVfP+BSvrWg4cxvX209tpTwUj95U50O
	E+lGM5aT+J8m0zxzx4U8XbVnmw5J4pLoPvPQJNav4J+dMMJkLk2NUFqRLhZ2W+EvdAz7/RcvB4Z
	9td4n//2YH9thePsHXVWUdySuXhuYAT9p/hKlR8DCvS7M0eud7nVyT6DKtWtf5vACwSz1xZtV0n
	z/J3EV74czbIwqZmWH2/2VzWtdjDdtTI8qzsk5auxj87fimaDhtGMWG3T7NNWaMeLuA==
X-Received: by 2002:ac8:5a13:0:b0:52d:28f8:578c with SMTP id d75a77b69052e-5327ef20911mr72606131cf.31.1789594460672;
        Wed, 16 Sep 2026 14:34:20 -0700 (PDT)
X-Received: by 2002:ac8:5a13:0:b0:52d:28f8:578c with SMTP id d75a77b69052e-5327ef20911mr72605671cf.31.1789594460121;
        Wed, 16 Sep 2026 14:34:20 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620d4cbbsm32447431cf.28.2026.09.16.14.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:34:19 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v5 7/9] smb: client: fix missing iov bounds check in parse_posix_sids()
Date: Wed, 16 Sep 2026 16:33:58 -0500
Message-ID: <20260916213406.1496960-8-sorenson@redhat.com>
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

In parse_posix_sids(), sidsbuf_end is calculated using the server-supplied
out_len without being validated against the actual length of the received
iov (iov_len).

If a server provides an inflated out_len, sidsbuf_end will point past the
end of the iov. This defeats the bounds guards in posix_info_sid_size(),
allowing out-of-bounds reads into adjacent kernel memory.

Fix this by rejecting responses where the calculated sidsbuf_end would
exceed the received iov boundaries or cause pointer wraparound.

Fixes: a90f37e3d7ac ("smb: client: parse owner/group when creating reparse points")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 96063e355186..13fe8e3b48f3 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -77,6 +77,17 @@ static int parse_posix_sids(struct cifs_open_info_data *data,
 
 	sidsbuf = (u8 *)qi + le16_to_cpu(qi->OutputBufferOffset) + qi_len;
 	sidsbuf_end = sidsbuf + out_len - qi_len;
+	if (sidsbuf_end < sidsbuf) {
+		cifs_dbg(VFS, "%s: server-supplied out_len %u caused pointer wraparound\n",
+			 __func__, out_len);
+		return -EINVAL;
+	}
+	if (sidsbuf_end > (u8 *)rsp_iov->iov_base + rsp_iov->iov_len) {
+		cifs_dbg(VFS, "%s: server-supplied out_len %u overruns iov by %td bytes\n",
+			 __func__, out_len,
+			 sidsbuf_end - ((u8 *)rsp_iov->iov_base + rsp_iov->iov_len));
+		return -EINVAL;
+	}
 
 	owner_len = posix_info_sid_size(sidsbuf, sidsbuf_end);
 	if (owner_len == -1)
-- 
2.55.0

