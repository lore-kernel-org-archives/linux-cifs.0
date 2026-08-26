Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A001130B53F
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758348; cv=none; b=e63tlsjb/Z8qe1yxu9AX+Qpqy5e+zUUxlB5fyA1Z2PKPSlZgJTCdnFnpAXOXTu8d0jOTLsrM7p/nfAzATsBtthsvhUQPbsB1T2YbVHOE5h4Ogw7HuB3sHNmnclO5R5C0miJa0XMgylbFNAsiCP/M28Jq5jAyfPI4VXql1nyUHrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758348; c=relaxed/simple;
	bh=cIV+ZdC8TaMfF5dn2cUvf4xKuhzQ3Bv5jzj1pdF5zHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScPymPKB/G6aNkiq4brJ5Q4/4mr5dLkcxkrxwpCDScso4g1FQTVf61yX3FoVKD32OlMoSLq99HhVc9kqw/sca8JSFz7iyiIa/JTUKVaBZBZQ5hEFOez64a8FZ9+/P2TKIP2tNl76/lyck+EojWdjSdYUJROmqKs/m//CvJGyyKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JTikfLE1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=S0aSSnh/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JTikfLE1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="S0aSSnh/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787758343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0m5kEjDkzw8sjC1Qe5HadK/QqnTlsalc1w9/+PtUYIg=;
	b=JTikfLE1iPxhQnHAClCcvzVGaWuJJMQMIVwBmMSTV24FMSAQ/eFRNqDOWz3XtLHsg4f0qB
	WEcpNwRzhmWVZQGVg04gk6LYzkNsLfb+u0tTaIBKVCViEvzfxNdnWSrrkgH1JuXFhHuVuV
	Sa6m5DQWYLKEwXa3Coxi5uqxK28E8Sg=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-8cFC8LMpMoqmNqSVWnm8cQ-1; Wed, 26 Aug 2026 11:32:22 -0400
X-MC-Unique: 8cFC8LMpMoqmNqSVWnm8cQ-1
X-Mimecast-MFC-AGG-ID: 8cFC8LMpMoqmNqSVWnm8cQ_1787758341
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-66d1d240ac2so18172d50.1
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 08:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787758341; x=1788363141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0m5kEjDkzw8sjC1Qe5HadK/QqnTlsalc1w9/+PtUYIg=;
        b=S0aSSnh/b8dlwTN9L2E3ItJV7tPfGuVf6Cw1ZMLC1bAf4kxCN83yMXD88w1hPSAopm
         49o2uIqgazAW1howOjEI4nKwUwNOyyKGCkAeBeH9BX1BhxQ1Mpp5V+hkotaVF5VvIpk/
         SCpCGpiBIxFx+c7LoZl4Er9of5CfCdLcUT9DV9G5413meYn5oTfcnqQrzoi2n8+YCOvU
         9LW+s4xSUdAixfZ4hLXlAHo/qvf9MJ7Jjr8biVwTylZIGbMnw3Mvp4jpLYAKVZSuBFKS
         k0HhENVXw0uoOUOnkdkylyTFdjqhclpwNW692lJ/2joRl5RXfH7so6BY43bpQRsLccWq
         XTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787758341; x=1788363141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0m5kEjDkzw8sjC1Qe5HadK/QqnTlsalc1w9/+PtUYIg=;
        b=lHKYxBsFv9sZOeucRVHee5mTUvFsy166OFv4qcNOrKFNdpfwBMIKvZ1egI3NMbwXO+
         7VSG9uQLh5j/A+M37L928WXz+wL6o4BLYBCfYMYrJGANkeJswUagQiSbbo79vNL3EnN6
         Og7qo9yHW9/wtD59MedhOAPz48I0Wv112qRhIZEpi1jijY84ITtGbkEZU5UC1dl8ozBK
         4AGmAzNkgdciewp1BkEHk1a19WEQ7h+TkB5kkW80oDIYcXfn4ebBSIxiJZOSDXg6vBlv
         LxQMhczDPwiiYQOYAscrEdMXuQsyJ0sq+rwXCMwfgDwVrn2RGVQXJDt6jdeZZVRXC8/T
         dkqw==
X-Gm-Message-State: AFuF++nr7q7ixSLBIcpd8xKEKTVC99UxJlyKF7hdfhHy4nz6ecCZcPnJ
	gFTOZGfqW5K/J3xMkg4MgEfefPT4h2KXa5AI+NH4LoTuZDBWV8mod6b16b+LEfII3sPqEEsWNuD
	J7lkYocVXi3WC4lZ92oXCPgRWVIN3Xuz4FZMSzwltCfUowztF2q8iJjoj8jQm3jPCaVOBaBD9NJ
	o6t+WJLUt49mNDvVtCDPxAm9E0oEesInk0N9zFEe2mFf5Kku8=
X-Gm-Gg: AR+sD11zAnC4J1KwmT+N1k0kIZNgY1FN26vxI7xDXINrpMvBgILMF0L7jhtEXN1kWO8
	Mka7VEvunw1AOgCMPdatHfLzJxqJ1ur9xsyyk346Ukb7lhosJRVaTEFpfrot2EY63WR6gp4aj08
	yZvudOwYV01sQjX3mG9tFguqRg7zU548zyG+uj1eiSNPf+OBqBT1YFgA/Rts9q5yli1kw2iQiAh
	4Yu4hHXPui74sEV27/I6C/wO9uqtAhG3nI6ns1mmbEaiOGTUqwSEkcMBJGLCpBlIif0Yrma05gt
	11/31UacDBL5CG8iV/IMxPW54V3FnznUvoRfEZjc4gu9/To8RKvN7IRtAKpubN+nAvaKZ1rR+EU
	2O62s6KDiSd5/j6FR2OW+6soykS7DHyFaE6s2dIQ3IxIZz1BGGIMvTahZaThyM9YPgA==
X-Received: by 2002:a05:690e:454b:10b0:66d:20c2:3b90 with SMTP id 956f58d0204a3-66d20c23f14mr2768838d50.21.1787758341428;
        Wed, 26 Aug 2026 08:32:21 -0700 (PDT)
X-Received: by 2002:a05:690e:454b:10b0:66d:20c2:3b90 with SMTP id 956f58d0204a3-66d20c23f14mr2768788d50.21.1787758340460;
        Wed, 26 Aug 2026 08:32:20 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d24592f24sm1598209d50.6.2026.08.26.08.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 08:32:19 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 07/11] smb: client: fix missing iov bounds check in parse_posix_sids()
Date: Wed, 26 Aug 2026 10:31:43 -0500
Message-ID: <20260826153147.4112943-8-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826153147.4112943-1-sorenson@redhat.com>
References: <20260826153147.4112943-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_posix_sids() derives sidsbuf_end from the server-supplied out_len
without validating against the received iov:

    sidsbuf_end = sidsbuf + out_len - qi_len;

An inflated out_len places sidsbuf_end past the iov, defeating the
bounds guards in posix_info_sid_size() and allowing reads into adjacent
kernel memory.

Reject responses where out_len places sidsbuf_end past the received iov
or causes pointer wraparound.

Fixes: a90f37e3d7ac ("smb: client: parse owner/group when creating reparse points")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 98ea5c6c34af..c7a2dddb3959 100644
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

