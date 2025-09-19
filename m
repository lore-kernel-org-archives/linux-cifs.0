Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F07731AF01
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758295867; cv=none; b=H3++0wY7r8phVd6UyhaimjbYcLEoj+q5vYj12re9CHFE8w0AxJn+UsIengLrmEDq/R+bZfMVqgjs8Z5C5NXopkdTM4+PU+CWJzWGaHAFkQM/Uf3xdcQXhLKZTxmbRKoKBn3+kFugma3HpanWO6qi4gSHF0J04mzxMLLy8rW4ACs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758295867; c=relaxed/simple;
	bh=Cf791B6OsUmL+Jp8C1F4a7bD5ZzRqUNRvgstNyyzu3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQqDj+Z7BicaZEAN85psoj3mOUzAZqRGY88ez/18D2Z8j/l7JtjyI8/1ntj2E65xSbUKtSoku2mttJshrjI44k7hAflX9E1tqXH7IuOmDj9xT/Ta3AqLUtmBO3ZIv9Ff0DP1YJAR/QHVPPoTRDgAqVAhmf/d18B4Ls3HEGkmPRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GnvCR3bD; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GnvCR3bD"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3ee1381b835so1232637f8f.1
        for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 08:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758295864; x=1758900664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMS84KMZwTiwuYVuvCXaaRNOUjWe7ZcPnP1PNE3kj38=;
        b=GnvCR3bDikAZg3ACEV9ves+hFngR48Qa5r+agA7En9o4l+3zACinXMpBKHZ7GtozEj
         kFwJnnWPUF5fpilCcko6mSXVuAnhIBG/crrmk9675d5pjrGoqkysxWgCv+VEWUtfSO7Q
         lRutXDIjqVQZYyl1yaJimxDwYLyysDJVCfh15zBHGiQGFIvaLrbxuuiaaCVOtO5yAaK0
         PQgDdlT5LjGf9JlOyJOCKinAT3doG8a9pt0MU89DZZ3SuZu+3JIc0+LiKvvfdMbc+Pae
         mNYwf359qNTcv5GliE+Qr2on+THAoudCAB5b6naqrON1Kv07cY7i/CIF8TV4kEMhY8G0
         UdgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758295864; x=1758900664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tMS84KMZwTiwuYVuvCXaaRNOUjWe7ZcPnP1PNE3kj38=;
        b=lrr8/LnCYfmdkr5Z54RjYQxyCa1eFDDLr3tC8KhrMCbR1HCS7U1nLXX4HgV3Zo4Prz
         7ewiIIYMwnLNUzvStuwVRzigwG98rrAhAoTPgk7LlWKNbcEaAeiyHkiuv7+THtyrgBQq
         eRM8979ckbBl2UfnjDejLz/7HFKmxaCT9tKxm6WsAfODM2RNeEzacyPvgixAoHQCBOy+
         NiRNNxIZwKlqNJVnZGpR6aumoi6qIVaDsfsHiIxCW0hhnW/yPcHUc7dJk/d3xCu46wxl
         M+lFxXJMa0GOu9hcdMEMiyO5hlR1HsOK8BM/IRWNnI1XJt0fDiZiWPvdXIOqNokRvSnh
         0ZOA==
X-Forwarded-Encrypted: i=1; AJvYcCWQ34RXMFapQzvPjOC6r0705NmwxiGMZ7PFSEQPr0deXPvYHr8W7/bq1KQ2r8rFebah4mt8bdx9VBKG@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4XPTBni2og2fa9dDzkXF3nPQcnjZ6UijC+qeq5O2bnBKGw/w0
	akYrC0B8bF2ZDIa3PoacvdOyy87tc+4/7UD3d/QveWiQyOq8aEPJfmnLMefDFwNjKDE=
X-Gm-Gg: ASbGncvTsi0stzRUw2E/lzZFZDBt6a4k9lcUQpp9G2tckj2Hv5Xphc1bpevwcVxk7U8
	Kqu6GBhM3059RApOvGfaVKG3wII+oOiwc4LZokLMVfDqorbX4Miz6FPmtTxxq/zYeJY/RGK1Zbl
	ikdstJCoBsQfteVyPo2QV5cPp1hkuAzZ79KqsBmcWkBe7JBIIOkgIwvrxRy7N9TgmxeIeq9DwD0
	DHUdHdRbUestEtYsanSidtfWYhpt3vsPFo0vjE+HMLIEvEMVh8hsp80xF/mHPZev/U88VMsbe3Q
	LwEcV1UpsHcUJ14Xp++0dlzr2oQtU+OR5QmhQOQVg8gjtA9f3c/SuUcgnpNQR7gb+PcgMjuog0d
	/8/+ji/pAMddvVEVebnIFhDY=
X-Google-Smtp-Source: AGHT+IEeroxKoDrxS826VwcaxQThbwOdkljaCrykeNAPmavLCdzDNWwYxZ2tz2EnaBAfvz0G7LvR6w==
X-Received: by 2002:a05:6000:2386:b0:3ec:d926:329c with SMTP id ffacd0b85a97d-3ee8732796emr3364152f8f.56.1758295863818;
        Fri, 19 Sep 2025 08:31:03 -0700 (PDT)
Received: from precision ([2804:14c:658f:8614::1cfe])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ecc735627sm5129683a91.1.2025.09.19.08.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 08:31:03 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: smfrench@gmail.com
Cc: ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 5/6] smb: client: remove pointless cfid->has_lease check
Date: Fri, 19 Sep 2025 12:24:39 -0300
Message-ID: <20250919152441.228774-5-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919152441.228774-1-henrique.carvalho@suse.com>
References: <20250919152441.228774-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

open_cached_dir() will only return a valid cfid, which has both
has_lease = true and time != 0.

Remove the pointless check of cfid->has_lease right after
open_cached_dir() returns no error.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2ops.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 94b1d7a395d5..e6077e76047a 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -954,11 +954,8 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid);
 	if (!rc) {
-		if (cfid->has_lease) {
-			close_cached_dir(cfid);
-			return 0;
-		}
 		close_cached_dir(cfid);
+		return 0;
 	}
 
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
-- 
2.50.1

