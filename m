Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4BE1FC8
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555569; cv=none; b=pMm8dH1a6+5XyJlPS3fxQtkDHEthX8r1dl+QoZ46dflvTCCZbztBsI+jn+zcjL52M9dLYYX7jlSbD2JdBTu74oW4uWn6c5lVQFtdy/Z5IO5jNPvslNhiFiwG9wM+JA2n4pWrZozLnTFpn5X/yLgjq3a1vr6J1YurRDx5K0WjGtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555569; c=relaxed/simple;
	bh=P/LufqrN/BUB3yyROtQ/VjROhPBC0ZAmhUHIkw9EALI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXc9rpqlJ91BA8tcE5WsZH/TATgcuwG5Da7YGIYrVNH/OktMpHFj+08tChl6VDEs/AteVt7mnlEmIRDu7eQw3NC0WvF2oItOBh1QLvRCCoAyN7K/LCggmYFn9XtWjokVccDVSwE98nWr7Byt/BF5HJq3hfU/QyzwqImCY2W1zl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h4kMsGt3; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h4kMsGt3"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so2557005e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555566; x=1784160366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R07P/hp2TtHFADkF3do88Sx6GoQi4RiTW8fdztZNKn4=;
        b=h4kMsGt3n8tYrnhXfwxIGdpNiw3Zibpjo0pDUTOKPEMR3YXM1ncQhmid5SbciQghf3
         jNOTWVcSeeSG7djioWe9D9BQosQmqfkusabBcZL5ImXPxrP5LzzpN/CQrZIdj2iZJgPI
         X7PlJZvzdtKb+eHKo+mWSfhHOvm3xhqYuMrglwgDglusZpwizK95ANfBcceGDWZEI90y
         g6udGzmk5xZijmMylG+yLcFiq57pHzqE3HwMdgLoZa7hOf8ePfD08TcBWMgvjUZuT0O6
         Ffo71gMor3rbrMnHtt53lFpw65wiL8XtU0p8x6pXjfKHhi4+eBoP3AZJ3JmDkVVgndVs
         YRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555566; x=1784160366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R07P/hp2TtHFADkF3do88Sx6GoQi4RiTW8fdztZNKn4=;
        b=cso9mDrkZdcRP4tCo9nZza01PXhpVVpX3e8tGlg3FSRxqDvsThTybHIIZ4ZUP6jCDp
         o3KAjH2lLWzooJVLZEwMJVz5r9Nw3RWsolDvRVFfTYbxh010tdSGxNca3ykj28s7NeYz
         0QG/eoX0MLyJntGslAhVEYtxuPZhHixH6MjWcSBFnn9xYcqYn0W1FqWTSH/bstzFT1u4
         DvwnVWsdoQzp+r9vonWmawyQkqP3jJLQ33Lt2CQ5kvdAlpKK3qzU0NQEooAOU/wLZ1UY
         oZbCHtgirsUkJqE/IdDh5759vtEtFg8SQ8fTsXASSoyypjJdd5cI0N8RT6HEDXoKY7Wy
         HXlg==
X-Forwarded-Encrypted: i=1; AHgh+RqeGEzNVz2jSlLgZKwg8SML6bjMNjFaAIeZT62ySFUJJFxjnPIMwCbFAWYZsxM/cN/AJQRflYru9SYL@vger.kernel.org
X-Gm-Message-State: AOJu0YwbrB77/71sWmjYs+QUuTs4c9jegBNIOUxWxJRfDQlAVpeq/ZqF
	l8Ijp+x3ihfw+pJCWEc06Bu72neHskD2EuDjcRGzd3wrB5odVmyz3aux9Yq+mRFD
X-Gm-Gg: AfdE7ckWF8etwdlVe1S8CBGFRHinBZ+CFtpPmORaWJ1XQM326Qi9CsBEv/KVyX8beP1
	Cd4NJpSpnw0X44lMRaisnoHD1BnsCkDNBv7h0MJPhn2Xsoc3vhvNZU5hnBZ7keI/KPsB1RmGG9A
	ZZI7DSzR4GuOb3fosAYgUyd26c0GTo83VWX0enZ7Nrm1NrQEks6z1rqnQ1vRj94kR3pj8HPX3x0
	AEkNkbeHaSX32MyHt0/Gdf6a0EZ+2yrc1wiDcJdkzhlv+AoRr4T5zkqO+9/7w1Qh4AE6DsurL/c
	NfIv14++F0uo106HTKicEkdT4sUxuZ1zQXrQpuIVwEruTWX4c2A6yu9w+wibzJY6hnHqzyMYVB1
	3RE0Gv2yJ+k6GpVxhW23oTfQMGrp9EpSBbsnUVgkNwEASobQY1YwrCdaYfflsVk0sru9BZ3X5qf
	IcWlBFaidB5kLAxM4Vn7cMa0V8H5JDlZrZ7eQ=
X-Received: by 2002:a05:600c:4fc6:b0:493:72d3:4a81 with SMTP id 5b1f17b1804b1-493e68cd7c9mr40883415e9.16.1783555565768;
        Wed, 08 Jul 2026 17:06:05 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742d0esm15843755e9.13.2026.07.08.17.06.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:06:05 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 6/8] ksmbd: zero-initialize xattr_dos_attrib in smb2_update_xattrs()
Date: Thu,  9 Jul 2026 02:01:09 +0200
Message-ID: <20260709000548.66445-7-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709000548.66445-1-g.blivet@me.com>
References: <20260709000548.66445-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

ndr_decode_dos_attr() only populates da->itime for version-4 DOS
attribute xattrs; for version 3 it's skipped entirely (only
da->create_time is set). smb2_update_xattrs() declared da without
initializing it, so fp->itime = da.itime unconditionally copies
whatever was on the kernel stack for any file carrying a version-3
xattr (e.g. written by an older client or server) -- uninitialized
stack memory that can later be exposed to a client via QUERY_INFO.

Zero-initialize da at declaration, matching the pattern
fsctl_set_sparse() already uses in this same file.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ca3d4985a..7d7315e34 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3000,7 +3000,7 @@ static bool smb2_parent_compressed(struct ksmbd_tree_connect *tcon,
 static void smb2_update_xattrs(struct ksmbd_tree_connect *tcon,
 			       const struct path *path, struct ksmbd_file *fp)
 {
-	struct xattr_dos_attrib da;
+	struct xattr_dos_attrib da = {};
 	bool store_dos_attrs = test_share_config_flag(tcon->share_conf,
 						      KSMBD_SHARE_FLAG_STORE_DOS_ATTRS);
 	int rc;
-- 
2.43.0

