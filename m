Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7DA137C37
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 05:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746162939; cv=none; b=lMEgbo6n3UuMeJEDCgboSOP3Wvtv5sB5KqUSqupQ6OMUtUl6UfsOxld73hOehACMQNfB9UU7t5CLB26PzkQCvRqHQ08rifDeAAzNudZDR9bel9z0jYdEWo0ti/QbKc0dcxHYQBHYn331tu1KyReVESv5956Dyht7LepHzoRMmr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746162939; c=relaxed/simple;
	bh=Fm5QWF+A1IbnQ9MlSwRxHA9IhI4UzVWZCxa0EroULbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0pEiI97Gg1MY6JsVb2yj/F1APXWJ8kCW2UThhPk18pSrmP2Iih4Bm8eEqp/OBfOps+En8HWGjN0cOkO8tWBJXgYi4b1ZNGDOWt7NOaZCm2SeAuxY0AWCbSFsKFHq5pO4XAy5s0/CxKW9GjPTynktRjBCFLNRsPzcufdwBhaQfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kttvllv6; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kttvllv6"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-736c1cf75e4so1575661b3a.2
        for <linux-cifs@vger.kernel.org>; Thu, 01 May 2025 22:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746162937; x=1746767737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NE2cIn1Ycyu6Ce6tCkFhxk11hSscJn6AbZWsWZ71dYU=;
        b=Kttvllv6IgonhYeSt2l0i3k7eCuMwPo2SPi4NkCSX5Oi6BU/pSMRiixYXVd3Rqy01g
         /ljwkO4Pt4zzGh/dmUOKuCao3rhVKBEasiwF1D7Xx0OvaQOBQGW/HobADSMg70pH7bF5
         9TsrM7jkei05Y97shYUI8U/w/AbI6Q0AFIA7oNU7tLIkVIc+/IpWbTDrRz+iuU3Zig/t
         0EYzj/E94WPAa9UYJx0YQlql9EH05Q6BIrNRCVVNHJZtn2fnpdr1AOPoPY+mfsFJ/VMI
         gWXShWuiBNW31h9O+h0ijrLUpvsJR3RVzFgFG7lCq6D5rCl3w1TJBrqZiDdh1nrbMKIe
         JUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746162937; x=1746767737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NE2cIn1Ycyu6Ce6tCkFhxk11hSscJn6AbZWsWZ71dYU=;
        b=DRO90641bDembD8B9VMzmpOdY9kcURNQvoBNi13PbQjYpzv+fFuR5bDIomKjI0P5Ka
         4MKD293t7CAaMtwzIyriN6t0xy8BhAibH2HN47BUQK3witgaNJOOd9zuDlhjI/v7l5+s
         QYzrrPvyUsE2akzNrmGT23BN6o81Tv6t2bDYAZdbDl75v8QMeW75KabJoo87F2wyLI7T
         FjGycuyjIjX3BoO+1S4m2gWSB7Y0zSGYxhZtXL2F6LUxa4yi4YgKIQAVA92UMVoX2mXS
         XKCGIsUnBn78MpSLsNiwOAlmSTkYbSCZLqfnJknnvbHRiplBdUh2TlmyvT2mUSQj4oqB
         L5qQ==
X-Forwarded-Encrypted: i=1; AJvYcCUy1NVJmIwRqH2jPcXPe3DARrKgCZWW31/aJJsWWS58Rt5aXxBmQk2lSA2FN6J6D6aOppEcR3+hGKiL@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqtv+MHjZt1htyVZKuYEfTIgo9cj+YboxNhW1nfa1+czQHTSwD
	OGPbqKL3805QKmKDL7ub362v3PgCt6o50pE/NPn+N3RWUMZLqdoa
X-Gm-Gg: ASbGncsjaCJoHJV1GO6m+/XuuO7/jKM0DdAIzj4DDjjgc1XKo73RktbDzoNmty1WKUA
	3Ihw0mF6Rr+9I+GjG/TaH25e7C/wi7QFe5tzACj+PLOdF9npTUpc+OU2KVXOJJBJp1Yt9FxIv7D
	B2bCWPSHgVT4vb0gcyeKFtWq2P2shQaJU34jkX0NJYT/UeMG5myU9cf34P2aeAT8N13NpZ63Bs9
	C1y86UwbwAskOBUtFuCEdVJjtGR5OsHsE3d0ZngoQSx+zBoksUaO7tyBcsnxcoF+5ub7Sbu8rpP
	Aq/Pj56vPL0ERzs8ss4kUcKpicx8nesjGtB9h1OGng5P0GA4JnziusOXPeVHtBBzdF8+MF186sA
	2LeuzYF97kUs83Q==
X-Google-Smtp-Source: AGHT+IHsOsayWaZkDzvhvu/gq1TEFoN5/vTOJT+A5JXE5J82na3H8q5iK8xCM2ebsx+ig/kwoG6z+w==
X-Received: by 2002:a05:6a00:2e05:b0:740:595e:1676 with SMTP id d2e1a72fcca58-740595e2134mr2181930b3a.8.1746162936896;
        Thu, 01 May 2025 22:15:36 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fa82ba71asm425397a12.45.2025.05.01.22.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 22:15:36 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	ematsumiya@suse.de,
	pc@manguebit.com,
	paul@darkrain42.org,
	ronniesahlberg@gmail.com,
	linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/5] cifs: do not return an invalidated cfid
Date: Fri,  2 May 2025 05:13:41 +0000
Message-ID: <20250502051517.10449-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250502051517.10449-1-sprasad@microsoft.com>
References: <20250502051517.10449-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

open_cached_dir should either return an existing valid cfid
or create a new one. Validity of cfid depends on both
cfid->has_lease and cfid->time to be true. However, if has_lease
was invalidated by a worker thread in parallel, we could end up
leaking both a dentry and a server handle.

This change checks if the entry was invalidated and returns
a -ENOENT in such a case.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index f074675fa6be..d307636c2679 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -198,9 +198,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	/*
+	 * check again that the cfid is valid (with mutex held this time).
 	 * Return cached fid if it is valid (has a lease and has a time).
 	 * Otherwise, it is either a new entry or laundromat worker removed it
-	 * from @cfids->entries.  Caller will put last reference if the latter.
+	 * from @cfids->entries.  If the latter, we drop the refcount and return
+	 * an error to the caller.
 	 */
 	spin_lock(&cfid->fid_lock);
 	if (cfid->has_lease && cfid->time) {
@@ -208,6 +210,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		*ret_cfid = cfid;
 		kfree(utf16_path);
 		return 0;
+	} else if (!cfid->has_lease) {
+		spin_unlock(&cfid->fid_lock);
+		/* drop the ref that we have */
+		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		kfree(utf16_path);
+		return -ENOENT;
 	}
 	spin_unlock(&cfid->fid_lock);
 
-- 
2.43.0

