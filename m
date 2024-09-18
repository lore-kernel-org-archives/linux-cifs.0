Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F92F13A3EC
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 05:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726636582; cv=pass; b=WJ8jFp/l4YxlqomrVUmDu4/z6HhJA2pxqLLcIuV0REusd9KnZVcJdgfiI1scj7sMGv5IXp8k/TpTkKhsxkrzDJniDSqkr1EigwUzZiqTyjDBTCtABXdjtM2CT5GdSGtSl6btlU+zpOMToH00FjuB8R/qsACmqDia9JXLwnfFrKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726636582; c=relaxed/simple;
	bh=d3NEc/JbGFf3TRhq6vEL16X1LsGHTTdlSLhfjVHdl20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbemTax+lKYvQOeIhsVjqAAcN1MUAIMROW9ZyDMyXJs+qKJBu1MYLrPexHhXoy/L3MHyhYrGSwGFiUWM/Ym8H3pU5DhYLftn2lM3KG/rV2M9M7UagPLuZubJvxFs+lwoiax2wM5msmck6dpeRnsTFEP8C2PBvs1sSqPscgkb8oc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=ROxDSAQC; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ROxDSAQC"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oc+2fbCEJbzJbzJOeWAYxCHBz1uZPJ6lPSWdyAyQFk4=;
	b=ROxDSAQCxL3MRkPNDW//R96BZ7t+J3s/FuyjEfrc576qhMPgGl7KuyEDtm5Ej+32u9I7Cm
	g72wSV0kNRgPjUCOnlY2AKuSN5nd3Glot5JxToeZzDNxNo4Fbto295s+FXzLTBzJWsy2Cz
	xt2faq/pHCaUX63I6vrQPzsWRpo7SiJcwfz0hft2IqkFZ5vDN2fbgoY0imDyIne6DsHDM4
	6wKyu0YTjPqKulYZVSIdViKHsoeCG3lqqqwHRC2aINaKU4+MClTDdbaKxVb6MGVmOibwLR
	PkT+t0tS+3jCR1s8IVm26q/51HZzgflywwbXL6pjtiPt0qz4d7a+tfKwodTEoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636579; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oc+2fbCEJbzJbzJOeWAYxCHBz1uZPJ6lPSWdyAyQFk4=;
	b=hEgp7sjkvjQnNHx4hPUtsFMG6tDDkcELYLedpVYZ3kDJ7HVsdqseK9fIAEIRH5A79qcYxQ
	gcc/TUue5wB3tFcDbNtnhWpTsx3HnyzUuA2lqrrhkXYLgcWhe+hk+oQ+pyjH/1KEjp8g4F
	vSErZx+CY0jM5xgWNJKbB4gWVb5K7HTAVPOQ/zmh3cxzLdSU6iDj1/3uhoanvv4VPHyClO
	L+sP0eQauJhDdaXOgLIyYf3LKWPk7mdoV9UkeA7INSKyOoowku696MvN180DejPDX5Sa/R
	pxYXn6uvZ2dzuetYFnPigD9LCAw6W8MtNII7yv/xeTFKcCMWtpF+izhCDwZEwA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1726636579; a=rsa-sha256;
	cv=none;
	b=L3896pH5hdEnECFeV+IV4qAcV07qIey80AD1lvoRRZOQd0E6TfBXe7BKCmzU+1fXmAQv2n
	hyv/Ry8rPKrbbR0ycEG4HJGIUgKmFofrL+JWxaX3KPNC5dkiO6RSenHAJiqJVa+d3mHChE
	xX2xDhIbo9mHd5mNaY44ZKOfYpBetagBjsdBtKPjCQviVnx+WuFDQ2qRMBP32oZUJQdvRi
	ThvMjFtwLLtb2lGzp5Ht4WZDsPWCIgaDqRrXlmNJaePnJ2DrqMmimI5mzL1COEMsj0VRL2
	QPZFf8BfCMx1fM/g3oRzkVimHZkQO71SQbswaThkBGY0KwSqzdTsYDPQgHW3BQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 9/9] smb: client: propagate error from cifs_construct_tcon()
Date: Wed, 18 Sep 2024 02:15:42 -0300
Message-ID: <20240918051542.64349-9-pc@manguebit.com>
In-Reply-To: <20240918051542.64349-1-pc@manguebit.com>
References: <20240918051542.64349-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Propagate error from cifs_construct_tcon() in cifs_sb_tlink() instead of
always returning -EACCES.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/connect.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index e71b6933464a..5dda17ed9c77 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4213,9 +4213,9 @@ tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink)
 struct tcon_link *
 cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 {
-	int ret;
-	kuid_t fsuid = current_fsuid();
 	struct tcon_link *tlink, *newtlink;
+	kuid_t fsuid = current_fsuid();
+	int err;
 
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
 		return cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
@@ -4250,9 +4250,9 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 		spin_unlock(&cifs_sb->tlink_tree_lock);
 	} else {
 wait_for_construction:
-		ret = wait_on_bit(&tlink->tl_flags, TCON_LINK_PENDING,
+		err = wait_on_bit(&tlink->tl_flags, TCON_LINK_PENDING,
 				  TASK_INTERRUPTIBLE);
-		if (ret) {
+		if (err) {
 			cifs_put_tlink(tlink);
 			return ERR_PTR(-ERESTARTSYS);
 		}
@@ -4263,8 +4263,9 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 
 		/* return error if we tried this already recently */
 		if (time_before(jiffies, tlink->tl_time + TLINK_ERROR_EXPIRE)) {
+			err = PTR_ERR(tlink->tl_tcon);
 			cifs_put_tlink(tlink);
-			return ERR_PTR(-EACCES);
+			return ERR_PTR(err);
 		}
 
 		if (test_and_set_bit(TCON_LINK_PENDING, &tlink->tl_flags))
@@ -4276,8 +4277,9 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 	wake_up_bit(&tlink->tl_flags, TCON_LINK_PENDING);
 
 	if (IS_ERR(tlink->tl_tcon)) {
+		err = PTR_ERR(tlink->tl_tcon);
 		cifs_put_tlink(tlink);
-		return ERR_PTR(-EACCES);
+		return ERR_PTR(err);
 	}
 
 	return tlink;
-- 
2.46.0

