Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B29A3C77B7C
	for <linux-cifs@archiver.kernel.org>; Tue,  9 May 2023 21:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbjEIVUe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 May 2023 17:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235731AbjEIVUJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 May 2023 17:20:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789EA525E;
        Tue,  9 May 2023 14:19:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 912DC6372F;
        Tue,  9 May 2023 21:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92022C433B0;
        Tue,  9 May 2023 21:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683667195;
        bh=MyJym/A8uDMrsUIhBPRBtMLhWWIvJY7Py87zmu1fesA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usly2NnSDqjZdzlyHps+GaJCe3vrm5tU2HEdXIZQXheUi00UhbK/hpDHaNS7SIheV
         hOLkqxxzMIxssMF+aBve8so2n1IQQZdCknlNwbwmlorLcIsGeXIOetCC6qnHdjOR7z
         A8U71c7WOoAm8BtqO+ZDb7wP94+WPzrtLGqcf2qn699OCR8gY05Oz6cayOHttZL8r/
         oM5+19LVulAhZ1C/4kNJJLOt0Z3fVOqQ+LHCRe6RWmz+LN9FkvJoMUcG+7uW0FjHHo
         idcheye8JlEjPYcMCBF3LzuBrfNaWPVl3k11Sp+w3pBDSHyx/KTTK+g9czANADI31F
         cgPfJ2KtSqPhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Paulo Alcantara <pc@manguebit.com>,
        Bharath SM <bharathsm@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.3 18/18] cifs: missing lock when updating session status
Date:   Tue,  9 May 2023 17:19:26 -0400
Message-Id: <20230509211928.21010-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230509211928.21010-1-sashal@kernel.org>
References: <20230509211928.21010-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 943fb67b090212f1d3789eb7796b1c9045c62fd6 ]

Coverity noted a place where we were not grabbing
the ses_lock when setting (and checking) ses_status.

Addresses-Coverity: 1536833 ("Data race condition (MISSING_LOCK)")
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1cbb905879957..7bfef741f758d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1916,18 +1916,22 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 	/* ses_count can never go negative */
 	WARN_ON(ses->ses_count < 0);
 
+	spin_lock(&ses->ses_lock);
 	if (ses->ses_status == SES_GOOD)
 		ses->ses_status = SES_EXITING;
 
-	cifs_free_ipc(ses);
-
 	if (ses->ses_status == SES_EXITING && server->ops->logoff) {
+		spin_unlock(&ses->ses_lock);
+		cifs_free_ipc(ses);
 		xid = get_xid();
 		rc = server->ops->logoff(xid, ses);
 		if (rc)
 			cifs_server_dbg(VFS, "%s: Session Logoff failure rc=%d\n",
 				__func__, rc);
 		_free_xid(xid);
+	} else {
+		spin_unlock(&ses->ses_lock);
+		cifs_free_ipc(ses);
 	}
 
 	spin_lock(&cifs_tcp_ses_lock);
-- 
2.39.2

