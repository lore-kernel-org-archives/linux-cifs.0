Received: from lgeamrelo11.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3A3226888
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 10:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907433; cv=none; b=NGVNhRtYAELQZekUFN8QZTm7PU3e9C1zHOWLrgyMHl3s+GI/bv6xMvYVCfuKlQG6/Q1wvRo03dNHQcYbG1cZmxmU1Cdsto1l4E/IQ3KhWnPun3bSa/rehAc91ZweIvgF8yLxxO4x9J4XGwSALVy02khVL7PFvr8A7mLym1ZhyZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907433; c=relaxed/simple;
	bh=42Qj2pu6ZD9kXaMu36PwsauvAotNEEUuPapWHeOC1+w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=RlKs5Wt/Vii8/XpsEKD+9HDbKkvlCa8F1AoHJ4gED+OPN0tDk54JeWYji6NKBNRVQLPZzd5zB944Pd9UDmYkLbJtk2c2yARzZEcDOgDbbrZi/9GxgoN/FEmnNcn3cjdvZRVkI2C44idRFM0WXu8hr50OMnwSxoAteF8iQCbLy4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.52 with ESMTP; 11 Aug 2025 18:47:10 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: chanho.min@lge.com
Received: from unknown (HELO localhost.localdomain) (10.178.31.96)
	by 156.147.1.121 with ESMTP; 11 Aug 2025 18:47:09 +0900
X-Original-SENDERIP: 10.178.31.96
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	gunho.lee@lge.com,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	stable@vger.kernel.org,
	Chanho Min <chanho.min@lge.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 3/4] smb: client: fix potential UAF in smb2_is_valid_lease_break()
Date: Mon, 11 Aug 2025 18:46:38 +0900
Message-Id: <20250811094639.37446-4-chanho.min@lge.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250811094639.37446-1-chanho.min@lge.com>
References: <20250811094639.37446-1-chanho.min@lge.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

From: Paulo Alcantara <pc@manguebit.com>

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org # 5.4
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
[ chanho: Backported to v5.4.y, smb2misc.c was moved from fs/cifs to fs/smb/client ]
Signed-off-by: Chanho Min <chanho.min@lge.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2misc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index d7cbf1b07126c..c47927d257635 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -611,7 +611,8 @@ smb2_is_valid_lease_break(char *buffer)
 
 		list_for_each(tmp1, &server->smb_ses_list) {
 			ses = list_entry(tmp1, struct cifs_ses, smb_ses_list);
-
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each(tmp2, &ses->tcon_list) {
 				tcon = list_entry(tmp2, struct cifs_tcon,
 						  tcon_list);
