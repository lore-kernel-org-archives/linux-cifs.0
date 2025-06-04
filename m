Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E6356B81
	for <linux-cifs@vger.kernel.org>; Wed,  4 Jun 2025 10:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032314; cv=none; b=pWCvnOHarNjiwuInfCHqZ5/i/rjJtGcyLjAUML2KF8iafny5f+znUEJEEQ1THTM58BEBzHsmhcvAmubNNgGBtD2iCqXTgSxPSGMg+Va1CLcaXB6QKQkNayAbduAzVd2+jp/0qde1zPv8heYbKRKqyRsjchlY47msjfhNNGyAWxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032314; c=relaxed/simple;
	bh=mVITb75J0XEsxhxTAyWW49ZdfYM7sICHVDBzoi3I+Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dGbrm5yIObMwZdg9w8yfnSnwrfeXv63sE8VY/31EucbRgDOkY5qtdrmkLSuRYoXQZ+A7ev/94elFSOBaNjlYnmd95P090dgHA6Nl1apEQt1q++uwUAJO2GIRNKERfgbX4Kq33UJvtrLKNZBgFx49RphyRpx4OTk+UT04GnHPziI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fOGfMEfY; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fOGfMEfY"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-235d6de331fso15583215ad.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 Jun 2025 03:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749032312; x=1749637112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ISNkRsjq6UYUO2aqPOy+h+A4cFKxKaV9jPstOogOjJM=;
        b=fOGfMEfYLwGTQmo4to2LisdsEsq7VouPCRdEZgatVVDaQa+V1bbkV9UkPvbj1qW/kh
         JKiga5qxD6b+ehQdg/mkYfRl8WY4Ax04+EsmI490eDRlmq433+ib3mdmULdndRZmo22x
         yJHn4gjj8ZOK/iV5oYOErveEBkr1a5pl8OLQVBJZdkc///qjTzyhr3M/hq/BSWBWMGPi
         YmFl5g7Hx4VlZtRyKgGvh5MyM3KPdr0yOaimYhAaWi2CuHYCenGXmD606TR+8/rDGT5P
         vcqXsEmg7MMQqPdHcijQUbTXz5h+lGGGQgfOraBR8Uj/WfHEnxnhcSEOMq/NwpER0q1y
         bb6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749032312; x=1749637112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ISNkRsjq6UYUO2aqPOy+h+A4cFKxKaV9jPstOogOjJM=;
        b=ha8KyqrCQagbWeCDqCV044yEzQhQQuMACt7ou+atdSnz+Jv17T539cfH1FhoPJZ/Nu
         bRI3eCt7tVew/pm8mbhElvC1YVm3iamp1asyn2hxy56TvPTPDs3iaiaJg8YOvCwNjcn7
         IUhW0Ay5a+JdYll+xqiCHNk5R+tEKCYPaJDY/o1PhXvLB8CPpitlUTrG/UxnQlqsy4XM
         BkzrUSMD2cpq+JdVGcRXPsYI7BE95jJGsXQitLxAMdNZl9hLpe0pykWgdOHnfEm5778S
         QlEsyFGceZejQD60XFOSIAnfwQTC3/LXYdCWoNOnXkz1v/2HRxhEZ+PBXGJs9RQSunZo
         97dg==
X-Gm-Message-State: AOJu0YwWEQEskAwHgu3Gj/aoc16hpOPrhcBaQmR4YUWkUAr6+JGcswtG
	pebMZVhPpt8VfYL3uGzjVw2HAtBLiHNW2YBTrmGI+jsvSMqPHVXkTLWnyWCMHTkb
X-Gm-Gg: ASbGnct0FORWWylsMEF0xrhEvKjjvCrWQVaWi+y080dbsehP5rtGv0LunovjUoiVFqX
	h8isq5NPD/NkFU5CIndhKGipuzm2VCgG3oFUBvcFBGYIOH1Gc3LQasdgEPh7Pec2mLH/BQslCIF
	XOYk1Mdi2XiFicL9ytA4qH7zH9qBzDpF6zK3m46EO4svPMvhGJcdNfKzecgZD1t6uaUx1Egw9+5
	9YQ3aNiX49SZJpjGn57gi1sPBwe4io62DkCwqpOng15Kqv53px3UZncw5WBRlh/qWzB1cqK+GFS
	YG161keVboLiNxcFomWCQhJ/zWyRpsOSF9ML5ssM++QZDP8D35DctjbopmiIJMBWs12CURYCOm+
	FUh0=
X-Google-Smtp-Source: AGHT+IHIz+ZMfHYOg3+dz04pF5lq9QAtrh1vaaE7Rl9kuZIFTKikIK6jwvmd7Xv2jdn6Owc9YX4ggw==
X-Received: by 2002:a17:902:db03:b0:234:d7b2:2ac2 with SMTP id d9443c01a7336-235e116bfebmr35623395ad.22.1749032312032;
        Wed, 04 Jun 2025 03:18:32 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506bf8132sm100563625ad.106.2025.06.04.03.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 03:18:31 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com,
	paul@darkrain42.org,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/7] cifs: Revert "smb: client: Avoid race in open_cached_dir with lease breaks"
Date: Wed,  4 Jun 2025 15:48:10 +0530
Message-ID: <20250604101829.832577-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

This reverts commit 3ca02e63edccb78ef3659bebc68579c7224a6ca2.
Upcoming patches in this code path introduces a new mutex, which
takes care of the same problem which this change fixes, but with
the use of mutex for the same section. So the net effect is that
there will be no blocking with spinlocks held.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 89d2dbbb742c..e6fc92667d41 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -29,6 +29,7 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 {
 	struct cached_fid *cfid;
 
+	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
 		if (!strcmp(cfid->path, path)) {
 			/*
@@ -37,20 +38,25 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 			 * being deleted due to a lease break.
 			 */
 			if (!cfid->time || !cfid->has_lease) {
+				spin_unlock(&cfids->cfid_list_lock);
 				return NULL;
 			}
 			kref_get(&cfid->refcount);
+			spin_unlock(&cfids->cfid_list_lock);
 			return cfid;
 		}
 	}
 	if (lookup_only) {
+		spin_unlock(&cfids->cfid_list_lock);
 		return NULL;
 	}
 	if (cfids->num_entries >= max_cached_dirs) {
+		spin_unlock(&cfids->cfid_list_lock);
 		return NULL;
 	}
 	cfid = init_cached_dir(path);
 	if (cfid == NULL) {
+		spin_unlock(&cfids->cfid_list_lock);
 		return NULL;
 	}
 	cfid->cfids = cfids;
@@ -68,6 +74,7 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 	 */
 	cfid->has_lease = true;
 
+	spin_unlock(&cfids->cfid_list_lock);
 	return cfid;
 }
 
@@ -181,10 +188,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (!utf16_path)
 		return -ENOMEM;
 
-	spin_lock(&cfids->cfid_list_lock);
 	cfid = find_or_create_cached_dir(cfids, path, lookup_only, tcon->max_cached_dirs);
 	if (cfid == NULL) {
-		spin_unlock(&cfids->cfid_list_lock);
 		kfree(utf16_path);
 		return -ENOENT;
 	}
@@ -193,6 +198,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	 * Otherwise, it is either a new entry or laundromat worker removed it
 	 * from @cfids->entries.  Caller will put last reference if the latter.
 	 */
+	spin_lock(&cfids->cfid_list_lock);
 	if (cfid->has_lease && cfid->time) {
 		spin_unlock(&cfids->cfid_list_lock);
 		*ret_cfid = cfid;
-- 
2.43.0

