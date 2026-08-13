Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E20544685D
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786614198; cv=none; b=MruQ8OzAfkgwqkdu5ofzV8DDKk+Q1YwYkLA3JaRtRIp9hdlrn1Fw/XXid5g2wZhfQUXFI9jszS8ED6/WPzxZxlgwgqjTNqVHdkak+PLXVUgxMr0Xv20FcmZaJ2J2YnEaTqur9z4ehX3qk7m5nHy3Ry+4jai6fhOfDdkQO9P+aUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786614198; c=relaxed/simple;
	bh=H4uLe+gabaJtwFgtfS6RUonwthFbapdwFSZHfAZ+qdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmEk0K8y7j9xdPDhTw4yvmxb9A5r+aM5nkT5p+25Ys/80qX3tY5Wz/3kgbmEkdCu9R0+chCMK6+GQr33x9dZHBjKnQ49p9LKbgThwf8jsvMhlJQfmDi/gwkHZHf9eLm5tmSjOSBoUImh5MtFUaGyahK3GIbdyVIrXsH/adjvjxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I1E0y3LL; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I1E0y3LL"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so2375875a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 02:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786614197; x=1787218997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NLbEqb7V5+6E4R3D88Wy4Tod7H6atR74xzPDhzHofmI=;
        b=I1E0y3LLQtrxjcvoUw+YM1q9buvF4elMKxIWxohVP4dleG8TAjsbLI7eg9rgbCuYZ0
         lZjjnslxO8x9t2f0OcDy5XbXU1lUhoqIJg7Y7D17GEMpUNIDsaK+cV6txF06I47xZU1C
         jTyt1zj28sOQyHJz1Jw5puJhD0oEhDSrWj3XoOaocLzhPVZLe8i3AUGIrp9bQ2gLQEsA
         214XI3rCU62F+H0b8jo0FXhg+QvBRVIgIalyLue7u7OhHabwxqIuyJ1xI9/jbvlOW/48
         l0l3oiotNTBV/U/b6TFlgplJ0dPvfqDKjQDE1oXrfb9HyJN3ntKs7NL9jssJt+igJH8J
         3o0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786614197; x=1787218997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NLbEqb7V5+6E4R3D88Wy4Tod7H6atR74xzPDhzHofmI=;
        b=j9p/OKh4kpuQs4rxolbZVqM1c2ciGPMyUrvLNrjadHxnoQAPKSksqOEbZnWZ52/RJn
         fF8pCxbqcRg1klxyPiMHzQVvAT8VeSMw2azKvo2GHxOflhzlHC4tEOh9eakXNbk5Szvi
         AMb6CvzURXP9cazzCa9TrP/VWU0oVU4WLUW7RfG8RYPVoRX+c3QRaEPiPRBqrThZHgxC
         RR2DK9o35WDB6PJvLpKHQ4QSyxgNg8HLUlXtOd1jSGaCdBbUQs45x0LDYok+Rjp+BmfV
         PEBeCrltFfbUlFrH+cFGbYuis4M2rB6TpX0dZQDXptTCvGIj7GUY0EyFllGDICBrKVAF
         HnnQ==
X-Forwarded-Encrypted: i=1; AHgh+RonL2cjdpsTx7JYRU3ahvK5u55uqN5PmgKMJeOnJdaLMl/LnRc7q7wlVlr+1PuIHA2RX3kdeCpe37FQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7Xyp8aPcNqdC9DWZUH01KNiCqHG/MjefX1JJha0Phd3S8Q8Oa
	qXi7qSn5qDU7oIg2BGBaiwjD5NqJlHYjUsQUtZ7wJ1f19IudN3c0tOJJ
X-Gm-Gg: AR+sD10yp8eV0/kSFazeqWFfgMRtjCE9Yuf3CzfZSWuuVYFhnDKiP7dGjgs+68W1/u3
	mWsS9Y/LwBkOxwXgIPoxZpF+2L0FJcwxDctFpINVk43qLkr/E/KOUaqLBdKkq+kTh7LjVb1VbwE
	VMObIPhlTR4aLdftG2C5Y5dRFqGYgfJGdXfFRAKGaGG+qX2ejMHxGgtNZ3dEmyYZXXi6s8983Wa
	9zF0aKX1TqR5tS+rbpW6HcnTc6dJrLmWSY9NvqDFJ+l2V8kIa7aELdYA2UCDKWCYwgngdFzgMnT
	q6C8Xs1V48PPB1QXaucWdpuCVbWe8XMgDdsC6324EoJ71JS2GJ8uwr37NyijHB1xqcX5J7uhr0M
	cXbY/1bDv2nfWb8AIx41IHb6XSzmT6vhu9bISVSaZqswEdfv8FuAdpN1wOPouiloH6GdyJBzGGm
	aKcSqRcEgSCXyJ+t3LlNRwluv+FK29E38Wrt0iqUazeY3jTo+hafHQ46KVvpqp5NN5o6raS5SdB
	ugHAi6JUc8apMtNYc2jc3mp+4v8HsI6dsmtT2mRSnSvjWJhpO9bdTkFrvjuOXiRZhCVPL/V6GDP
	WeF0ecYNxv6FMTkKWYxSOxsgwhw=
X-Received: by 2002:a05:6a20:394a:b0:3c3:b57b:627d with SMTP id adf61e73a8af0-3cc55038496mr6126679637.12.1786614196727;
        Thu, 13 Aug 2026 02:43:16 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebc760524sm6409135eec.1.2026.08.13.02.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 02:43:16 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v2 8/8] smb: client: take tc_lock around tc_count bump in cached_dir_lease_break()
Date: Thu, 13 Aug 2026 09:42:51 +0000
Message-ID: <20260813094251.666373-9-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813094251.666373-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
 <20260813094251.666373-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Every other tcon reference-count update takes tcon->tc_lock:
cifs_put_tcon(), the reconnect/mount paths in connect.c, misc.c,
smb2misc.c, smb2ops.c, smb2pdu.c, smb2transport.c, cifs_swn.c, and the
two other cached-dir sites (invalidate_all_cached_dirs_sb() and
cfids_laundromat_worker()).  cached_dir_lease_break() is the sole
exception: it bumps tcon->tc_count with only cfids->cfid_list_lock
held.

A lease break can therefore race another tc_count writer (e.g. a
concurrent put/get) and lose an update, which under-counts the tcon and
risks an early teardown / use-after-free, or over-counts and leaks it.

Take tcon->tc_lock across the increment and its tracepoint, matching
every other site.  The lock is nested inside cfid_list_lock; that
ordering is consistent with the rest of the file (tc_lock is a leaf
lock taken only for brief tcon field updates, and no path acquires
cfid_list_lock while holding tc_lock), so it introduces no new
ordering.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/cached_dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index f85d2d1dbbe3..c9b6eb56b37b 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -766,9 +766,11 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			cfid->on_list = false;
 			cfids->num_entries--;
 
+			spin_lock(&tcon->tc_lock);
 			++tcon->tc_count;
 			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 					    netfs_trace_tcon_ref_get_cached_lease_break);
+			spin_unlock(&tcon->tc_lock);
 			queue_work(cfid_put_wq, &cfid->put_work);
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
-- 
2.43.0

