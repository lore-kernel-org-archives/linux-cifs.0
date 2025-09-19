Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5027B31A80F
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 15:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758295861; cv=none; b=L60oX68bOFzLpegp+0fv38wjhrIYAMgdT8vCsPP5zPdp1sPMcGIWBly3Jg45OG5l6FIgWwvsnb5LxeuNQ+Mv7ROUneJP6+deecS4vf6NVAgTaXVRuQvR0fxweFGrPDbPvuAvmfojkkstqgeVQ0m0MvMS/1u3H1Xzxn1O5Es9Z38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758295861; c=relaxed/simple;
	bh=spbITnuhLrmJZdEFdVFxKZuRCHlfMHXdHGDybtrqxXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKP7Wz47Xj/oCUXmaoFYPZFka1oAjLTseaeKv9WcQq+eh0PglmHl3Y5tbQOhaf7LAHOVzRT2TkPkv64CgBhdjX9kykvxF70tRxvK2T+XQug8icHWz0jvYCW9pkd4glECib+0RH+WNPdIopfI+ohzt0VTbLvwC8Ci//0F4zwncB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a0XzckS7; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a0XzckS7"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3ee155e0c08so1062526f8f.2
        for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 08:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758295858; x=1758900658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M7/tYVL6t7DMulLV1DKBgvrr66hlxT66DYpp3eAQXIw=;
        b=a0XzckS7wEaaWQoWnQe3YxrGtxlGKpfDefQsL3ztFebCygrXp2sp+NxJAgAd/+FQhw
         xEz31Ri1N8GAbhxoltldDpyl3BzJoKLpZMyFLKMC3mi38oSd4KhCt2IFRiPcrbwcA9Zr
         P72LqLW4azZiAYe/VrLkxnGUHZruVLnChAVXmPwWo/jUwwHPU7T6qnA+b/Ubwgct4jV5
         oi7GdDICzyNpZTPViVMUnmuY6mXjBAkXSWHT/RUI104d30qwyTRVPgX692HbYfSWHCJ2
         EbloYfsBIi1dn+33a44xsdIQ1Ux4lBOYUPmTtmpVI3X62R5o2tunnxt6oOVkLWac8A3o
         Mcpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758295858; x=1758900658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M7/tYVL6t7DMulLV1DKBgvrr66hlxT66DYpp3eAQXIw=;
        b=WwQUgnQ/saLzSg3Vs68XQjDhYOgD3TOxTX0ApRBLnOCqU/HJSjKLhpaq+rzE2qXcHy
         eQauXYcdz3kH3eo4jfUk0WZJ0X0u4RlSeiM/QVNKqyFb/9jD7sP1IBVMZ0uj39NAdhXm
         7keUYHJ6+O7N+j5RLcQsWzG3s2GtIT+iM1Z2shck6oYGzl4BKAPYQVUuNMxAKFgIxh4d
         YJMxDgo+pLbnEeWqNLpQUEztU+z7YxhqhG5+p3FN4hRbtXNYqbzrromA6xSsaas4IziK
         19MjYT8zJ035Vo6ZIrrTsdBVD4H7dowdNmMSPjZh4M3kypNu/MLOdC6FePQPDKq4ZnVD
         JFug==
X-Forwarded-Encrypted: i=1; AJvYcCV0LnMpVtdnQNHQt1ID3yY5seBTH1wNrcTKhwEJLJxN4c8LjHMjKLFnEw0fE4ACAqsvkqDC0F8bCCum@vger.kernel.org
X-Gm-Message-State: AOJu0YzSLyB2dzIdxS8xZkgmQFexu/L686BDwu/6fKPThOL+nZTILgFF
	UTcrV6mjEoVPUgWyNDYWyp7v7GgwQ0dXiMDpI28yusCiWNwTw+Y2/d37Wp/V31I1kCJRfgrhU5P
	nfhsR
X-Gm-Gg: ASbGncvEIeqVlErGUbVx51FrGO2BnMs489KFg/wWjc5LI8rkk35Bko5n0bt2nFb4Z5z
	Se890ru+KdQw0VHrGyWWl85zLlUYinMc6fAqVTKcBajx3xZB3eZLx0cWUHr6IUMNI9fs9f5VBId
	14y31cz1yuQGw8l+o/kNDTrdPztiXtVbrEFoGO/UilAkN/XGQs8SJx8Xh/O6O5+gWqARIqGLPjV
	ND99leFtBEupE08dTUncq2+cmpC4NLW3qC2Kf22Vi9BVPPw/SxLgH5UGi1wpmjKRyY6e78HanJ+
	QeAf68pzQw7qyEq3imrOdcgaC8Wb9xUrnoJvIK2umXnm837TYqTMymQZCWGML9bwYj9pBMtSI/i
	xBRgoQwB2f0vmTwDGEn7+jF0=
X-Google-Smtp-Source: AGHT+IEd8VuB8/YO8S5bkKsF0/mNQmmb6/aM1OLlRLYucDUOP+cfnHuqjQyKPEEOCTLOTYPTnO7uvw==
X-Received: by 2002:a05:6000:2285:b0:3ec:248f:f86a with SMTP id ffacd0b85a97d-3ee85e26b78mr3047008f8f.48.1758295857612;
        Fri, 19 Sep 2025 08:30:57 -0700 (PDT)
Received: from precision ([2804:14c:658f:8614::1cfe])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ecc735627sm5129683a91.1.2025.09.19.08.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 08:30:56 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: smfrench@gmail.com
Cc: ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 4/6] smb: client: update cfid->last_access_time in open_cached_dir_by_dentry()
Date: Fri, 19 Sep 2025 12:24:38 -0300
Message-ID: <20250919152441.228774-4-henrique.carvalho@suse.com>
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

open_cached_dir_by_dentry() was missing an update of
cfid->last_access_time to jiffies, similar to what open_cached_dir()
has.

Add it to the function.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cached_dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index df6cabd0966d..22b1c5dd4913 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -427,6 +427,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
 			kref_get(&cfid->refcount);
 			*ret_cfid = cfid;
+			cfid->last_access_time = jiffies;
 			spin_unlock(&cfids->cfid_list_lock);
 			return 0;
 		}
-- 
2.50.1

