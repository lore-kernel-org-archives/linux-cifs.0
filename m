Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BE515A4BF
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086493; cv=pass; b=nSn4Ymn1Qh/ba3CmS4b1Yv3nBzOti3CdQZ4ZFLDoaScBELkOK9TGqmBqOY0HqvZNN6jSx5VyX3ySOiTuliMmxnpxrvFLtfdoquO6ON9nn/eKyh7Ac8osGaW0xX3LN03JqU13sqJ4DkOolM9RJ0hyfC/MkbmuTYb7mV0DpY3tajc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086493; c=relaxed/simple;
	bh=0y65Yhj7aritcDWk0QDluzMc8Hv3v/kXQrJ9Dfcsuto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoLH+Glppzrs68pVFRGFnt4G7LuBzQ0+rAjXZi6zZ2ffJ1XU0F7iXNQZbYFYQMznyKqXOuLC/4OpNqIOK8VXONqlDb20Omn5SCuE/tACw4+eKZbbHteVSrjyo/vi2kmaBdo9HBi2CzLRZyP0KJ4PgkrAteT40+RIMJ9Tf5Zq0eU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=elO4OHC9; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="elO4OHC9"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOzNsb+SflPQ0gD+QhjM7r4S6a3jd8PY5kCSOpeaIZQ=;
	b=elO4OHC9W1U/GKmcxmx4TUP4OCA27U2o/mGNCPCABoJ1PF7q4ux0WwydX+8laF+9eWuCiX
	tfcLxUZ9WDQOZmSmRA/b4n24BMforU8NhD2N0BGNWDwVSfVpN9HlAbP/TEViG6kDkZ7bHM
	vze9I9fDVYS4JrrSch/WxMyHNmO6a80zBJ9fKNQSmVcwLwNQckfazlVc50WsFizNp01+88
	FYTEON4gqJKSrfT5yP+7fEztC0I25gX7dDUQGy8ZqGRghpu985A27aWcTsGT13CB51cTqw
	Ix80yscjoV+PfZiHwaK8w1wzMomJm8W/ckkksmix9XkfAn/qXJMaH9mHJfsTLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086481; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOzNsb+SflPQ0gD+QhjM7r4S6a3jd8PY5kCSOpeaIZQ=;
	b=spweh/N2bpcvvsAc+c/eUaEE+rC+vDPPyzkVUyDnjmOYZ7kGp8uriM8LBRnmDiTmegpDL5
	B1VZl+yuR4voQRqclDoKAPXvhMOar6s20Hj+X1DKNJ4SiseBloLGAvhcSRAxe52zZgaBS1
	ZvOPfWcmKZbmtdzMWpRoD0Dg4azIe8VHgy10ROiFTTol0AO2kkn0Brn5TUxHZRv/9aJtPQ
	+a8FuIUqFeginraPvFckWcU/MtQ8ofkjsO1yndIfTEDA5Y3gT8yFiQtvcQn8Qcf6BXp6jB
	7aUVS1rt21OzYh3ejFqUKUcrhagBBht0bCq3DDCAwANXnH825I7GjQpKvnWT3Q==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712086481; a=rsa-sha256;
	cv=none;
	b=LlDMpuU1tGe8hA5N4PoB5/Ix31PzwMTprXyfnewLz5lCUBNYdxMFq8VqNb1IM26Odd9Yl6
	Q77RWJ9AXGQAKv+RStl5E23dkCE/9SGT6SH/q672VZj8EQPx2ZR6xZvJdYs8pUPWt/gEQm
	CBsvgMH+EdDiXT9Fgr5xtYnpg2BjomOHi1lh8KNmoKl8FYFZ67l+01TkvrL2grYn4M/80L
	dInGoMImw+UjQDr91srZ4jayK3ektliQupMhIvU9stCmQ3XhTgSPKZG/xpAJLUyexJ58aN
	sbyrdKb/hH4Vh/3YCX1q91uYREvFEblhBY0PG2NPebqWxQ23tr5Qy/r/vL4ecA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 03/12] smb: client: fix potential UAF in cifs_stats_proc_write()
Date: Tue,  2 Apr 2024 16:33:55 -0300
Message-ID: <20240402193404.236159-3-pc@manguebit.com>
In-Reply-To: <20240402193404.236159-1-pc@manguebit.com>
References: <20240402193404.236159-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/cifs_debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index c9aec9a38ad3..8535c9907462 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -678,6 +678,8 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 			}
 #endif /* CONFIG_CIFS_STATS2 */
 			list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+				if (cifs_ses_exiting(ses))
+					continue;
 				list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 					atomic_set(&tcon->num_smbs_sent, 0);
 					spin_lock(&tcon->stat_lock);
-- 
2.44.0

