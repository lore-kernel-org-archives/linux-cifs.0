Received: from lgeamrelo11.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8272343C2
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 10:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907437; cv=none; b=hG+pL+ao6PFQ8gWJXO/Q7c5+kwsUKd8DiyTSRRfwSFcN9mwE19xie7EC0gEO5MRlap2lHGeyP/IHN6UqDnc52JH2Wl6NgSUsURCw22nNU6aUNg6SOP10WJUYugVkmHNqLtJiMA2C7UQrNxGBUbLUEbGQGUI8pASAUAkNwYgh2Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907437; c=relaxed/simple;
	bh=r9tXkFCKd3yPOLffy2yeY3OwJMYq9y0SXOXHLnhdWFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=hrByixYi7HEZ7wPm+6ANjsC9WFMOnayIknCESSYBazXZ1+M5HOL+FSr6qL3+4rlA3hXW7jRWth8luxpNFHU0bwwz2cgJmX/dx95RL6JFprbf+1VuL81Ig5WJX3Mm7rf52u4+lspK408MrGoELvhii1IHcS+yQHj6v4NsjqBFDXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.52 with ESMTP; 11 Aug 2025 18:47:13 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: chanho.min@lge.com
Received: from unknown (HELO localhost.localdomain) (10.178.31.96)
	by 156.147.1.121 with ESMTP; 11 Aug 2025 18:47:13 +0900
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
	Steve French <stfrench@microsoft.com>,
	Chanho Min <chanho.min@lge.com>
Subject: [PATCH 4/4] smb: client: fix potential UAF in cifs_stats_proc_write()
Date: Mon, 11 Aug 2025 18:46:39 +0900
Message-Id: <20250811094639.37446-5-chanho.min@lge.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250811094639.37446-1-chanho.min@lge.com>
References: <20250811094639.37446-1-chanho.min@lge.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

From: Paulo Alcantara <pc@manguebit.com>

commit d3da25c5ac84430f89875ca7485a3828150a7e0a upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org # 5.4
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ chanho: Backported to v5.4.y, cifs_debug.c was moved from fs/cifs to fs/smb/client ]
Signed-off-by: Chanho Min <chanho.min@lge.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index df3dfa611c352..47190e676aa25 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -470,6 +470,8 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 			}
 #endif /* CONFIG_CIFS_STATS2 */
 			list_for_each(tmp2, &server->smb_ses_list) {
+				if (cifs_ses_exiting(ses))
+					continue;
 				ses = list_entry(tmp2, struct cifs_ses,
 						 smb_ses_list);
 				list_for_each(tmp3, &ses->tcon_list) {
