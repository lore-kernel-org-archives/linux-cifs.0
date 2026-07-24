Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2413538D687
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 22:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930532; cv=none; b=QatdHen5l/eC7SibtmdDNOpcPKAuSEPkaiQIHMTce+ZcEsRMK9NTIVlszYVmQlPO8mGAcXDIdEiVdmx3iyZS2KdBbIPf7HERv4alt0TZjFoEsLameieY2++oe6v0diJuadr4vdP5UlP7zogMFzW5aimxMvZMi2dvUHmzFw6OhCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930532; c=relaxed/simple;
	bh=6pLnwWeKSASc1379eeY67KlKjOo0bUXxMmQCpFnyiD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFyq7VlrpIxjsVwsNhf3XN/+LHcZhccAU9acScDAmpBKW+RDR1TM+oUgFkgiSAK7uu+xDHEz0NjHlHSHQQRgaKjzOWhOGXOBsd2nsc3pVzMxuduwqT9762Mssr90r46kyqujlDaCk+AR1MftoubbzbsqT5NUfi029sIr8tTBZzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dqKXQ1IP; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqKXQ1IP"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c08df8513so7011781cf.3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 15:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784930530; x=1785535330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=42dslX+jW/ktUVa63IhDYJMEcXLz+OxoplxTRWEwi+g=;
        b=dqKXQ1IPUCz9QoOEvRBXZwox5XzLKbUqbOuOqJOOXxZAUVVA7vrNk35La9Vw/tDMgO
         TSfY9Ijs8ehYuWfXMeLb6//WCNMI6IdZ6maNGceLUNGnJwdBK0bP91wl6AdnUpZb+iPQ
         NhlGdCsviHqeKQcRmdwk6fdp+N1giLxjIrOK4l8bQynOdeLdO9E0UcFptFFK/vjaqh6r
         knJcrcteZJCGf1ybbnH4CseJiQAaJcFFBKfBiR55grM9r0A/Iubvd4s5iMXLfibG6pWs
         HdPZrXB6VtQeP5C78KFDFUuCn/6C+e37iJ9K4dvAdpLAbtVY8nnF4Tp7BbXYDB2/oAxO
         wu3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930530; x=1785535330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=42dslX+jW/ktUVa63IhDYJMEcXLz+OxoplxTRWEwi+g=;
        b=HvbigGBg8xVKyISVke97ON6frMfye0h1Jh/TRs3k65WlPwdPk0Bzt0xw03ZRFzipFE
         BwfKaxEzVJTo5dVQJX23neByxhYz+ELWuZ7Mwmz9gzBENAPt8bX/Wk0BVT5wKhZZCIL8
         4iv7GXyYKhzERpCp/eGDccjySzy+EqSVpb54NSx9fvsS5Q00iSa1t/qFjsV44PJzTPD9
         jSWKx9QWhkfeVMBSluFRKzmX6vwBoaCtIMKm4/rz2xSXhdVlVz9UPly7qudqbP2wweEf
         na2EbnyJyF+DtdmGQNK3WkPpJUqLuuj7y7rE5JW/Qr46gyhpU9+sma+aqGXCxgfPOBpS
         jt+A==
X-Forwarded-Encrypted: i=1; AHgh+Rp4h5y5mHUntjV6TDIg14ZZO/KhoJFEALIPAgkEK1V8wI5gv7HSWqmbGtRrYPGhm7sDIQi3zYQjbg+i@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2cuqhp+TdXWR9A5naaK39LqWYUxqrQPRz5O8EV+40oCTblJjp
	aMIse8DdnqMU1hXN3K18307klzroxAg8MxHazVNx4uZYwhfEhydSKtSV
X-Gm-Gg: AR+sD11wRwTzXKa/+OODs6l3qrgHHSjAp3MVmUKoT0+RhNtDpvNePjyHQB28jLvzwNK
	voA0Ko6OiVun9+MV6OTjZ/+iPZJ51z3L5X5juGsw/cHv4+NiZpWbE+6PvNtu8XuCW2rJSoeMyfw
	NSS3w2hnSiaGHkWBUrc1yxUAGY36+7SlkHq+2M4iWLZJlL6Zyue//ZYEdTrEtnjiQTMTx/grrpm
	prGF89t2EZm811sBi9OzKyUQ8CAyMB4Ue96O45qrQqyVA2VDFD3YwHN7I1Fcgv1nmex2RpiIZQL
	f6KbXEZvrthSSJPOmO8NsNXZjLZuW4pjseqP/GPT7228Sr038Qdgq/3p8Rpx95WHuR7Ms0oV94t
	bUonk1rPIFAhI5B8fuFwjol8lUkFPE3izFPzt/2iUrFR3xpDOGOHK9itwXs3HHF4RJLVe2sjwQK
	1AnCLWM5fx9P2nssY=
X-Received: by 2002:ac8:5cc3:0:b0:51c:849e:e222 with SMTP id d75a77b69052e-529a8623877mr1752841cf.36.1784930529916;
        Fri, 24 Jul 2026 15:02:09 -0700 (PDT)
Received: from FredPC.lan ([2600:382:311b:26:c204:8bd0:9563:8b5f])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529a27f68f3sm8668631cf.9.2026.07.24.15.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:02:09 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] smb: client: harden DFS cache against invalid target hints
Date: Fri, 24 Jul 2026 15:01:45 -0700
Message-ID: <20260724220146.1859170-2-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724220146.1859170-1-fredric.cover.lkernel@gmail.com>
References: <20260724023539.1596955-1-fredric.cover.lkernel@gmail.com>
 <20260724220146.1859170-1-fredric.cover.lkernel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, get_tgt_name() returns ERR_PTR(-ENOENT) when ce->tgthint is
NULL, and dfs_cache_noreq_update_tgthint() assumes ce->tgthint is always
valid.

In preparation for clearing ce->tgthint in free_tgts(), harden callers
of get_tgt_name() against ERR_PTR results and harden
dfs_cache_noreq_update_tgthint() against NULL pointer dereferences.

Cc: stable@vger.kernel.org
Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/dfs_cache.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 8cd93cd2f00f..c9ace4326a35 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -869,13 +869,22 @@ int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses, const struct nl
 		goto out_free_path;
 	}
 
-	if (ref)
-		rc = setup_referral(path, ce, ref, get_tgt_name(ce));
-	else
+	if (ref) {
+		char *target = get_tgt_name(ce);
+
+		if (IS_ERR(target)) {
+			rc = PTR_ERR(target);
+			goto out_unlock;
+		}
+		rc = setup_referral(path, ce, ref, target);
+	} else {
 		rc = 0;
+	}
+
 	if (!rc && tgt_list)
 		rc = get_targets(ce, tgt_list);
 
+out_unlock:
 	up_read(&htable_rw_lock);
 
 out_free_path:
@@ -915,10 +924,17 @@ int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
 		goto out_unlock;
 	}
 
-	if (ref)
-		rc = setup_referral(path, ce, ref, get_tgt_name(ce));
-	else
+	if (ref) {
+		char *target = get_tgt_name(ce);
+
+		if (IS_ERR(target)) {
+			rc = PTR_ERR(target);
+			goto out_unlock;
+		}
+		rc = setup_referral(path, ce, ref, target);
+	} else {
 		rc = 0;
+	}
 	if (!rc && tgt_list)
 		rc = get_targets(ce, tgt_list);
 
@@ -959,7 +975,8 @@ void dfs_cache_noreq_update_tgthint(const char *path, const struct dfs_cache_tgt
 
 	t = READ_ONCE(ce->tgthint);
 
-	if (unlikely(!strcasecmp(it->it_name, t->name)))
+	/* Check 't' in case ce->tgthint was cleared by free_tgts() */
+	if (t && unlikely(!strcasecmp(it->it_name, t->name)))
 		goto out_unlock;
 
 	list_for_each_entry(t, &ce->tlist, list) {
-- 
2.53.0

