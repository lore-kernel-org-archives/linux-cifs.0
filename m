Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1593A36C9CC
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 21:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789335937; cv=none; b=sUTlcDIZmqddBEdLTEyPpprVaHTnwGXneIx8XGZBqcy564ndhfBGGMd9jVkodP6Jxv7tknwpeE4Gvqzo89Qlk3EM1o8fy5NU8d8yOwPiXNZHi6+9Tg4AogHFoDqpeKuhCHGi6TMufT4sQgDTiHB0WjFd60Ce2Y7x9SHdNW7Ol4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789335937; c=relaxed/simple;
	bh=Sj36XIv5xMRsbs/wOZ+6qit3KbIBL5gKeu9FcM1KgZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNZ/cMGbKw8HhkhmcTKnnMHrdZJNrIma+nok2zHjs0/G2OSbEnZyFn6/b4FsgZXxsvL5VHzO8xyE0bvHL6Pkrxb4DlLikFMuezqkLC7/uJwfsz8S7KUgJSgWsTbaXwT7uiF2qNh8thvGEMze2jb5VpWIdghqzLCBtOqhJQSIzoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WfCc3BNc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=m8tcJdpK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WfCc3BNc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="m8tcJdpK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789335935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZWuq6vDDxC9a57mHhVLz+GoF6OV48cjZqu3A8mCuPWU=;
	b=WfCc3BNcqjh2Dmm7IB07uva6GJolDRggoIrc9UPIYcQBwH7L5+KFiJ9y09i1JnlBsRTQnP
	QFg2/G2v0xIoGyd/h4flBfWAXa9Mwm2JKkDkhlS7kW0/RpVR1KbvQZ9AqLj3HtFtuIAgIN
	5u+eEJC3+B8KKCexvOSwMWwdCdAoqT0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-S6azwphxOgC4s1y5fB78zg-1; Sun, 13 Sep 2026 17:45:34 -0400
X-MC-Unique: S6azwphxOgC4s1y5fB78zg-1
X-Mimecast-MFC-AGG-ID: S6azwphxOgC4s1y5fB78zg_1789335933
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-9104ba8bf51so74071966d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 14:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789335933; x=1789940733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZWuq6vDDxC9a57mHhVLz+GoF6OV48cjZqu3A8mCuPWU=;
        b=m8tcJdpKOloXXB80jxqnv1dOPwQljVC9tarIqRNvJBbGK+K1Kc8wLh+dRtyzr2EDST
         FoAzdCb7v3llFaIB4I+7M9xSQToHDvWJa4Zjqvo/EeBVZ7yE9lYl0HZN/kv6J8kHmCyn
         GKOvirEhXd3A3at2Ffc8huVe+SzWtNNhlZxBRLmcudNq7M4FQovUwCjKdoB7ZbppNuAd
         IHIL0qG8vUFYLMAIqRPqzUO53C7nJzAa9fPFgil7OhlEPJiUROE20vp+onzZ+k08cfKM
         Ckd7HqKieQ7qkoxmOkFi68qwFN5xhZmyrG55F/wOc68OMCCjE8emEIjSxXEfR5Pd0MyG
         w9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789335933; x=1789940733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZWuq6vDDxC9a57mHhVLz+GoF6OV48cjZqu3A8mCuPWU=;
        b=HgnLjbAlsY/7Q5p7xnuWHJ/bz1e9w9PpAPVAwBADfwhijCgLr8WJr9HFyVgGnENR8w
         mM5+l9w89tfmfoha9xusm06+LirK+iKcWviHa8MO5X0JUf8B360DxpwHXH/FXyIcyVJa
         FhDtjYB5aZyyhSLGFAxtJb7VyR84gVhyKhawrNo6gTV/mDy7Y3eC7ui1ccg7bG9GtQ6w
         rWXdn62rf881CsWuYuH0eF06BQD8dBLEZW0Sz+IY2CRTAawpiDiXT2mLCXg667QsIyQB
         M/eD63rPQbeB6ul38ZTx6+Dupx1t8sLjYcdSSKoQ2Ig4cFDxlkenZbctPJzyyBt0tn9F
         2mHw==
X-Gm-Message-State: AFuF++lpRlQJhCUtgwYbbJusdRNzKM2Fpdgwu8qa7biSWJOJPx/cdVbw
	lR3s6H+WLgeJxlAIzhlC90Xm8WkD3ddNllvEJTCq/r1as4wxwU9qAIF+2QJSrhrF7M4qzRq9XQF
	szXS0dnb3Cfnt7lJZb6ZOY+0VnGNA7fv1hObjEpWC/Z1dZ0JhXKu7ST3xs9uFJITBgm3uM3O0oY
	wFqqR4z693p7zZHgGobPbpCAklDrByHQ6qolNwvgLam90TsSs=
X-Gm-Gg: AYBFou3h806/bK+xW3KHKV5eB78f3T0CjzdLFiUUmMJnktPdPYgwXyxto1azitbKc3k
	vYnJnU1uxaSAdBL/sayOaUaFifoSjUeoqNUzkIIvahU8pJtf9WdJMuYSQSY9Tm/R7JqR7w9GJ//
	RT7xrtvjjbpxebjhshPICrojNkant9kUVipNcDkrXoEFcsrjAor3QJudYtgHjKv/qWxsfwiqvTS
	ZXaa8wrIC2psiCtfjIU7c602AtTRURv9T5mDWYm3o/Hip6FyPysTIbHGn8gXOR+7VxPgI81pz8W
	n3FNsWJtCpqs08LGli3VDnugFDuzDA5N+UYQct3tziM75hodroEiDwFKuBkdFo3uZCO1nqKIHGC
	hFnJB74eDKPs2B1gxx+6XUtnbb9FdGU0SEQ4/1amAoriNOUpX+t/7IREA6x0ekXMxbA==
X-Received: by 2002:a05:6214:f64:b0:910:3452:d57f with SMTP id 6a1803df08f44-912120efc7fmr264356736d6.31.1789335933454;
        Sun, 13 Sep 2026 14:45:33 -0700 (PDT)
X-Received: by 2002:a05:6214:f64:b0:910:3452:d57f with SMTP id 6a1803df08f44-912120efc7fmr264356406d6.31.1789335933009;
        Sun, 13 Sep 2026 14:45:33 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f49444bsm78581126d6.29.2026.09.13.14.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:45:32 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v4 10/10] smb: client: fix reparse buffer bounds in cifs_query_reparse_point()
Date: Sun, 13 Sep 2026 16:45:08 -0500
Message-ID: <20260913214510.3071370-11-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260913214510.3071370-1-sorenson@redhat.com>
References: <20260913214510.3071370-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In cifs_query_reparse_point(), the start >= end check before casting to
struct reparse_data_buffer * only ensures the start pointer is within the
response. It fails to verify that there is enough space remaining for the
fixed 8-byte header of the structure.

If a server provides a DataOffset that leaves less than 8 bytes remaining,
the check passes, but subsequent reads of ReparseTag and ReparseDataLength
will occur out-of-bounds.

Fix this by ensuring the remaining space is at least the size of the
reparse_data_buffer structure before accessing its fields.

Fixes: c13b779d26b3 ("cifs: Fix validation of SMB1 query reparse point response")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f9aff0712794..6dddbd84b93b 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3080,7 +3080,7 @@ int cifs_query_reparse_point(const unsigned int xid,
 
 	end = 2 + get_bcc(&io_rsp->hdr) + (__u8 *)&io_rsp->ByteCount;
 	start = (__u8 *)&io_rsp->hdr.Protocol + data_offset;
-	if (start >= end) {
+	if (start >= end || (size_t)(end - start) < sizeof(*buf)) {
 		rc = smb_EIO2(smb_eio_trace_qreparse_data_area,
 			      (unsigned long)start - (unsigned long)io_rsp,
 			      (unsigned long)end - (unsigned long)io_rsp);
-- 
2.55.0

