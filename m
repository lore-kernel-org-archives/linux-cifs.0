Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F1723A6
	for <linux-cifs@vger.kernel.org>; Tue, 12 Mar 2024 19:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710272448; cv=none; b=Nq7wtAqutgL3d5rBQCehas9tpVgkCMX5nwn2VVr49qbf28tRETOl9Bf2fL3JEZqrl1RZwAGTxvCDBL8XRgB5PEXo/eaaigt2Q4NSjeqNybAdIg5+EfJicl2O8txl4Rezwc8MxpfVJ+cHIpWS980X7yhi2qrodFI+lvX1/MhfqPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710272448; c=relaxed/simple;
	bh=JqLburLw6TaoJi6+ytFBpERUxdbcj25GT4+puziQEvE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=gTZmZxs6IgiKDEW6YqQUguJ73lUncsmFketgGzJrbfN5BJ1w9D/O0LKZdx7tsL3Zo0h2jK3voEzYkcauL0cxeHKPMEVBmU2ec1peUUMGTTxRXA5RNagwTjv4PY35z6M4xYiXzwb/rfTwCwpsPdzqbPzNsclBCXYfnMputIopJJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SnaKNLuI; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SnaKNLuI"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e617b39877so4373991b3a.3
        for <linux-cifs@vger.kernel.org>; Tue, 12 Mar 2024 12:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710272446; x=1710877246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=mPBut8A5lucs8HKaFnhUgro9qteeVTx/Et0dCXtdBSA=;
        b=SnaKNLuIULEfhxlEhMEvyqrbwSwJHCqnzPGmcKn588RMRS9sr8LDhiRHxBgfxW18jP
         4YFpVnaQgBSBZ3hfv85nvqru+fnkgn5mRHZKU1NqfPbzTAB50fK48FBY2BUTs2sk2/ac
         oeTXs1FCOjQNGr/8YodpbIRR/cQssc1xwd+casLL8qbmXk91A8slFhVdPYdBA+YVNnh7
         JyfNmJyHEcp2fwUkbciSGDXGx5W5MHQp1foKZT7Kt3QLLFwrgZ5wh96gIov4J+ETfJtb
         zqLcmUfhSVduumykcTEJnEnypNBe0vMUViGmjJcOmsulC4MJomWjMyqUHXrEoPGbsd5m
         r3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710272446; x=1710877246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mPBut8A5lucs8HKaFnhUgro9qteeVTx/Et0dCXtdBSA=;
        b=hoYs5D44Vmggh/QwGnbcisiilun1F8KCNdviAV6+LGXVKrnBYRCX93HCmUGnmf9Inz
         gLJJgr80Avfx0mhXpBi4cn2ONJSf6VBVciPhBeBFDdEQfxC5fzkYtk3SWXwfcuEai21D
         2Ek1y5+Is1sltHoYww/DNpGzBl4ZJkHFfj62TUuMpl6yZ4nVd9JB2idkdijz+ScFDl4i
         uNcNessU7e6U/SxrFV44VK3ATUgG+uzfJyXAIiyjRYmdA6witS4YRN4V22SmopUZWsVb
         UI4vQuaKgE51d+ODZdBwPmxmvzOmkwqerZGQvp28zwjJQ9IVBAPwYt0YFEyrpUCulWtY
         qR6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWXlgd3WA8axjVI/Tug7Nl5E66BYpPKjAETHQwdRri4mTlBS89IhDKLVGep97hPNcaiOCsoZQpjl10r95VRHTOwMm+GdVbe7F5bdA==
X-Gm-Message-State: AOJu0YxkJv26Vvj1cEZPuPupLWQFUimaUm9ZiBDr9l4ObRZ6/cbaXZGA
	D+Rit0D0vMUnMpQxK8W6j+lc845XWT1jggzzIJQe9ZZLaIj76vkg
X-Google-Smtp-Source: AGHT+IGonzsLmMVBuRGM8tEv7fjC0+18y21+gI0P/1avpOpxKnBPaTMlG+Z91DfgvELuj8QT9UlB4Q==
X-Received: by 2002:a05:6a00:4b0f:b0:6e6:4fe9:7ada with SMTP id kq15-20020a056a004b0f00b006e64fe97adamr439512pfb.17.1710272446589;
        Tue, 12 Mar 2024 12:40:46 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([167.220.2.189])
        by smtp.googlemail.com with ESMTPSA id x6-20020a056a000bc600b006e6b2ba1577sm546690pfu.138.2024.03.12.12.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 12:40:46 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: pc@cjr.nz,
	sfrench@samba.org,
	nspmangalore@gmail.com,
	lsahlber@redhat.com,
	smfrench@gmail.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	bharathsm@microsoft.com
Subject: [PATCH] cifs: defer close file hanadles having RH lease
Date: Wed, 13 Mar 2024 01:10:27 +0530
Message-Id: <20240312194027.160701-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously we only deferred closing file handles with RHW
lease. To enhance performance benefits from deferred closes,
we now include handles with RH leases as well.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/file.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 9cff5f7dc062..c3cc83d55f78 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1072,6 +1072,19 @@ void smb2_deferred_work_close(struct work_struct *work)
 	_cifsFileInfo_put(cfile, true, false);
 }
 
+static bool
+smb2_can_defer_close(struct inode *inode, struct cifs_deferred_close *dclose)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+
+	return (cifs_sb->ctx->closetimeo && cinode->lease_granted && dclose &&
+			(cinode->oplock == CIFS_CACHE_RHW_FLG ||
+			 cinode->oplock == CIFS_CACHE_RH_FLG) &&
+			!test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags));
+
+}
+
 int cifs_close(struct inode *inode, struct file *file)
 {
 	struct cifsFileInfo *cfile;
@@ -1085,10 +1098,7 @@ int cifs_close(struct inode *inode, struct file *file)
 		cfile = file->private_data;
 		file->private_data = NULL;
 		dclose = kmalloc(sizeof(struct cifs_deferred_close), GFP_KERNEL);
-		if ((cifs_sb->ctx->closetimeo && cinode->oplock == CIFS_CACHE_RHW_FLG)
-		    && cinode->lease_granted &&
-		    !test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags) &&
-		    dclose) {
+		if (smb2_can_defer_close(inode, dclose)) {
 			if (test_and_clear_bit(CIFS_INO_MODIFIED_ATTR, &cinode->flags)) {
 				inode_set_mtime_to_ts(inode,
 						      inode_set_ctime_current(inode));
-- 
2.34.1

