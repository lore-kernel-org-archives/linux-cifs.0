Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE43CC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Mar 2022 18:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbiCaSDy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Mar 2022 14:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiCaSDx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Mar 2022 14:03:53 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62BE231ACC
        for <linux-cifs@vger.kernel.org>; Thu, 31 Mar 2022 11:02:06 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 756377FC3F;
        Thu, 31 Mar 2022 18:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1648749725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AWPm2z/4sdwJiYL6bBabrHeDSTgx8PxueplbbfeQAXA=;
        b=XnhlryZ3XX+XUg0Tr9BnTasL7HYL+b0I1HNql0S2tAfls8oThBTs6HEg9QXaq6bR/cxeh5
        Ei8teiB16b1BubI5AypFITrW0Ceu0OnrmDsoXCVRqp8lcC/mJVx1FMGE2BHoMmCgDBpLxA
        vyg/+ybA6qvKNLeTqok3w6vrwSnCD55skt+7s+b6XK+DnREIxKA2G7nLTH3ZdEQHbawvBh
        1oPksdy/IWkp5tgAz6bhPkGOKKj/DO43RHeEl/HDMxw9iytyb9L7hs2GEM1gAEEr9UDFJ+
        jFUvPRUIZgz2KaVzCdbfb/bx8lq7BwjpcWiyYUXehr/wMB9NTC73wQUW0pW6yQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 2/2] cifs: force new session setup and tcon for dfs
Date:   Thu, 31 Mar 2022 15:01:51 -0300
Message-Id: <20220331180151.5301-2-pc@cjr.nz>
In-Reply-To: <20220331180151.5301-1-pc@cjr.nz>
References: <20220331180151.5301-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Do not reuse existing sessions and tcons in DFS failover as it might
connect to different servers and shares.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3ca06bd88b6e..3956672a11ae 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -536,8 +536,11 @@ int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
 		return __cifs_reconnect(server, mark_smb_session);
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-
-	return reconnect_dfs_server(server, mark_smb_session);
+	/*
+	 * Ignore @mark_smb_session and invalidate all sessions & tcons as we might be connecting to
+	 * a different server or share during failover.
+	 */
+	return reconnect_dfs_server(server, true);
 }
 #else
 int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
-- 
2.35.1

