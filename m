Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27CEC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Apr 2022 00:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356685AbiDUAI5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Apr 2022 20:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378889AbiDUAIx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Apr 2022 20:08:53 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF0E14018
        for <linux-cifs@vger.kernel.org>; Wed, 20 Apr 2022 17:06:05 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id EBAA77FD1E;
        Thu, 21 Apr 2022 00:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1650499564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tMWf1vhuoTh+UGFMSx7I6vB3r8Xrxp9WqudHc9bqt0E=;
        b=qiaDDnwBsOtAyaYMletAwwj3XpHeM+RcKO51WsXAbEG+maMOvCsv18ylUmbUJ8j4jd2MVC
        2PmnTO3mAuFmsV61c6PzBUckd2zY9n1EuOKwuFyMJ9pGzUBV8kvNB65PBdOzn5GlyUh8dJ
        IUtHfHpxF3/mNzx7Bl+yfoq4aLNcKtCHI/fNfY2yGQd/qDCkJivK9BMeSYdL8i4k5G3ccp
        6w1Qx1v7SXsd3VpkZ/4PdaraEEthSIVfGYjZjWzU40nVwfcJZiFR5cXusZH0t9Wovg7isT
        OKFHPHvo6C7gCP3Kq2jeuVF8yqmB4MQ71iQe47LTzYX497qHTKQt30M3mgpRlA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 2/2] cifs: use correct lock type in cifs_reconnect()
Date:   Wed, 20 Apr 2022 21:05:46 -0300
Message-Id: <20220421000546.5129-2-pc@cjr.nz>
In-Reply-To: <20220421000546.5129-1-pc@cjr.nz>
References: <20220421000546.5129-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

TCP_Server_Info::origin_fullpath and TCP_Server_Info::leaf_fullpath
are protected by refpath_lock mutex and not cifs_tcp_ses_lock
spinlock.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2c24d433061a..42e14f408856 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -534,12 +534,19 @@ int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
 {
 	/* If tcp session is not an dfs connection, then reconnect to last target server */
 	spin_lock(&cifs_tcp_ses_lock);
-	if (!server->is_dfs_conn || !server->origin_fullpath || !server->leaf_fullpath) {
+	if (!server->is_dfs_conn) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return __cifs_reconnect(server, mark_smb_session);
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 
+	mutex_lock(&server->refpath_lock);
+	if (!server->origin_fullpath || !server->leaf_fullpath) {
+		mutex_unlock(&server->refpath_lock);
+		return __cifs_reconnect(server, mark_smb_session);
+	}
+	mutex_unlock(&server->refpath_lock);
+
 	return reconnect_dfs_server(server);
 }
 #else
-- 
2.35.3

