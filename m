Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328F519CC0A
	for <linux-cifs@vger.kernel.org>; Tue,  6 May 2025 22:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746571035; cv=none; b=FBakxx/QLChEgHgCwG62qhvnpNIzau8pzK4Y5rYsLef06QYJDPyr5u+drRtXNSookhmlmnaLzlDiryXKGvyghYluXFcFPSXAyZ/dFw1VzJxtrac4+HkwY4RaWZlQvGJZ3Tbm1+6EW1vpz/G5TQKk9uMOriNGGDXE56wgs0KiXKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746571035; c=relaxed/simple;
	bh=3nB+Lk9Rp2YUeO7Y6lgXH3do6CLd6FsB+hUiW1TtnVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tOjaFQg6VRAVW6kq6dHtCpq5xvVy0Xwi5VOY8J5zpEjL2KBLB5vpX0vhBZfpndWDyQsFU6Vy8aurHu55d6bwD+PcWUO/uibcvi8itCbTYWNn1zldEdcmITh9LV616bS6kpk0XGkiB6GZhMN4Jm1jjsY1Dvlh25ud4uodvIyx2uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G+PG4PE5; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G+PG4PE5"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39ac56756f6so6966813f8f.2
        for <linux-cifs@vger.kernel.org>; Tue, 06 May 2025 15:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746571031; x=1747175831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8i3CSziPfdXXqKCTrk/dODufrjF1ntPvU+UZ+/JRmMc=;
        b=G+PG4PE5Cn0YmSdpECw2GUyvuUIDlJPM/qMNHeYI6dRfi2wgAMj7GvDcsk2kwJwMeE
         KvW5ILCa1n0RkPgWgTt2Zzuxf9fMb9Vql0X3s0ntN92MUiQileeYqjAigWlRACS4Ayhm
         RS7ZT+1UyupF8KQMu5oYDpXuJFlRv3odB6VRc+swBcxx5UarUaHJSxiYTNaqJehcoWi0
         k7ziRUNWROmAaCn2bNEUnRMmRCTuTW1DsMkpNvX14lX1l/vIliRD9+pZJVL6GqBp7PK/
         zUxr6gWfGuT60LBIcitDaL9r+lhc1APHtY1dafZ/syNKDWyVvzNH62CzpkiMstGw0YUl
         Bzgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746571031; x=1747175831;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8i3CSziPfdXXqKCTrk/dODufrjF1ntPvU+UZ+/JRmMc=;
        b=Zj//wI9CIPrNgqfkNRaHPSO1Bu/FYNXNUBnPnLRE4CRLzciZtCqsf0jNThf+/qtiFC
         BGPOR+Ejbdk1toDU00mT044T2afdUHiqQz3HSDvS51STWjQ52Xg6Z1yXPCI8qaidrPBx
         /56mF5IG4CPjXRyiyb0NCrHak0QsEqXeVppLqiRmhExL/BOB0JTY2WNjC4c+0yhDkLUr
         2F4vVRxSSNGf/p4IpHDG5VqSm3dhONA86O3I34sb2iknDU5F59L9VV7sHhgIjiH57K2T
         Y2ZdyUFvOH1yF8RBlt7JMF17JBb7RgAbUHHT7ABhyF8Fx9nqz3iuEq6O1uxnICPQ+BC1
         uT2A==
X-Forwarded-Encrypted: i=1; AJvYcCXPd76BA8Ux5Ab28mfbgLOeflDlL/4r3+DDivLH5swHuVWMSGw1dll+Km0v2VvWll3U55X9WhNU8m+V@vger.kernel.org
X-Gm-Message-State: AOJu0YxLJ3Snm0jcQclpJWCLpzQX6znUHVMW0X+91dfH3t6mGSRCjy1i
	qxA/XgwxiXxigXkamwuh9i8tuZJFR3SFwNv2V8TlGrKYcG4eRg+ucxxIyJaL94s=
X-Gm-Gg: ASbGncugwjbIehNfZxjEspKc1WlBmDjTdc+gUzOHwxlOXcqdEZKmzpwHxCdz99ctVah
	87TgQF4ygb77u92gHuPAXu41hJ4uY6UQ/J82lql0t9Lm9KgkVF7mGEpXXVhs4YCLQ0XUTMsad+W
	sOY4UZJ0x4g5LnhjHQcRMU24ZNldJgsdA81SDnYqIsX+PDaDk+2AP50VSmyoFIgmj5SjH/CKpea
	mzI/idGZinKvdWkFRJgSPqs5ZvePo3CM/yU9cOtYMbjxLkaCuQ2IbgIRF0KwmzBFN7nKmVyJwOb
	oHG96qUFmGNcRr1XE5pnbL9lpt4t65CAG7GO/+m6e2+dQ3Bgvi3K4vKvIjbNviwdbCedHIsHlvv
	h
X-Google-Smtp-Source: AGHT+IG+tsKFjd+vbEkXrJvf564Zcvw2Tn/Rbc/BQtTthF577H0M358EecsZTVydl2RLT2eRXOVcRw==
X-Received: by 2002:adf:8bd2:0:b0:399:6dd9:9f40 with SMTP id ffacd0b85a97d-3a0b4a06021mr704175f8f.9.1746571031374;
        Tue, 06 May 2025 15:37:11 -0700 (PDT)
Received: from localhost.localdomain ([2804:7f0:bc00:f1b9:7b60:60cb:ca83:87b8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e152291e3sm79368095ad.202.2025.05.06.15.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 15:37:10 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: ematsumiya@suse.de,
	sfrench@samba.org,
	smfrench@gmail.com
Cc: pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	paul@darkrain42.org,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH] smb: client: avoid dentry leak by not overwriting cfid->dentry
Date: Tue,  6 May 2025 19:31:56 -0300
Message-ID: <20250506223156.121141-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A race, likely between lease break and open, can cause cfid->dentry to
be valid when open_cached_dir() tries to set it again. This overwrites
the old dentry without dput(), leaking it.

Skip assignment if cfid->dentry is already set.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cached_dir.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 43228ec2424d..8c1f00a3fc29 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -219,16 +219,23 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		goto out;
 	}
 
-	if (!npath[0]) {
-		dentry = dget(cifs_sb->root);
-	} else {
-		dentry = path_to_dentry(cifs_sb, npath);
-		if (IS_ERR(dentry)) {
-			rc = -ENOENT;
-			goto out;
+	/*
+	 * BB: cfid->dentry should be NULL here; if not, we're likely racing with
+	 * a lease break. This is a temporary workaround to avoid overwriting
+	 * a valid dentry. Needs proper fix.
+	 */
+	if (!cfid->dentry) {
+		if (!npath[0]) {
+			dentry = dget(cifs_sb->root);
+		} else {
+			dentry = path_to_dentry(cifs_sb, npath);
+			if (IS_ERR(dentry)) {
+				rc = -ENOENT;
+				goto out;
+			}
 		}
+		cfid->dentry = dentry;
 	}
-	cfid->dentry = dentry;
 	cfid->tcon = tcon;
 
 	/*
-- 
2.47.0

