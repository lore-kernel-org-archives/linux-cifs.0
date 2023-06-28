Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2493DC001DB
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 00:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjF1AZS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 20:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjF1AZP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 20:25:15 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005672704
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 17:25:14 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1687911913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=asVZYqVn6NqWCsWUz8xil3gCXbx1Fr+LFBXjP5BH58M=;
        b=Yzz3B5GzEgChTGAD00ru/SbWau4z2HPco55HUj+NumTDNLjNmlH5a4BNb+bZhe75CSLjYw
        caO+AJChtiJ5egLlhX+qwtYW9f1fpD86Ky/KJa8RzPKM7vGLGlNeg+aJ4TwRaDXR/YrBHM
        Q32gTOKNclE8jloyrFIu7KDQvbf94XMymTNcSeVYHs4CuUygR9EmD8ZjRwAlzjbQjusMuh
        u7pSfS+c0+GIrS8ek3Mt+qfP9BJCCQ2Dk61gP0y50pUbKyv037GJB8T3eMwJyN725Xo6JX
        RqqYh99+CKAu8YoG2EgNVEdO93uOurSikUBq/DDOzO2dwtKmpduT0AqEbcS1YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1687911913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=asVZYqVn6NqWCsWUz8xil3gCXbx1Fr+LFBXjP5BH58M=;
        b=OnwYnBh1WjIhdU9JOOKTQzCmfreJbj4O+ZB00qKeSJfcIWKzC8gfGX6IbVduuKdM+17jDM
        BovMrAJXoiDfdr+dSobKn5ylNccuTi6/DgnyVNwAvLhjSftnMHzrc7ZT+8qj2b7fAafUkc
        4SKtNkjr4bKyY/aDkKq+aV3nGll8DVkrIauoJkihnbRUB6JTUhYLS/cMjtm732FH6bYp5U
        lznKXbkpDaZvyLMudW3CbltJS7x+yq2T7gynbrOj0bud5bZ1YRuEiQEtFJXCx0QHV74cOY
        btjP8JzVNF9FAZpSgq1U08onAQntPz0ARghdUHK66dQBpyBxbtTKdT8iGOAduQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1687911913; a=rsa-sha256;
        cv=none;
        b=LCQ/yjTsi4ccCulWxTLbwOl97gfpcWdQo3bIAQb13sjvUCMAA+xgNIo89iL3oxeBoADpkv
        KVlF9eJ22hVRMEoo7Uj9KLd6atLc5Aa2NNwOvq7BPRhjjxdmx6AcFfdUr2Dyj8lpeEi9UB
        gp67it3THQ5I5Vd8Sumy3iRFw0rcZkgHsjF/lh9F+WjagM0jKOQAhoyTR4NDAGN7kcP5cL
        56/R7e6oaWJ4ZLBLFxykEpus3ASn3ryqEP2GVGBWWeowx+WSM5ZxWP4SR+nznR68pJ4fHl
        4AOpRFsRqZty7E3bywePwe0YVk7l8ECfFAGcisOI6n48vlH/nY8n0xbVnMZwJQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 4/4] smb: client: improve DFS mount check
Date:   Tue, 27 Jun 2023 21:24:50 -0300
Message-ID: <20230628002450.18781-4-pc@manguebit.com>
In-Reply-To: <20230628002450.18781-1-pc@manguebit.com>
References: <20230628002450.18781-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Some servers may return error codes from REQ_GET_DFS_REFERRAL requests
that are unexpected by the client, so to make it easier, assume
non-DFS mounts when the client can't get the initial DFS referral of
@ctx->UNC in dfs_mount_share().

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/dfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index afbaef05a1f1..a7f2e0608adf 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -264,8 +264,9 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 	if (!nodfs) {
 		rc = dfs_get_referral(mnt_ctx, ctx->UNC + 1, NULL, NULL);
 		if (rc) {
-			if (rc != -ENOENT && rc != -EOPNOTSUPP && rc != -EIO)
-				return rc;
+			cifs_dbg(FYI, "%s: no dfs referral for %s: %d\n",
+				 __func__, ctx->UNC + 1, rc);
+			cifs_dbg(FYI, "%s: assuming non-dfs mount...\n", __func__);
 			nodfs = true;
 		}
 	}
-- 
2.41.0

