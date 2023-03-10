Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564FCC74A44
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Mar 2023 15:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbjCJPpN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 10:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbjCJPow (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 10:44:52 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFAD49FD
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:21 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so10213311pjb.3
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678462401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RycRAdB61mHxmeQ1gcw+uEuoua4OCSgZ9Rhw/hIQ4Js=;
        b=cCd4+dFqYhleDHtP8ehfvqDNAlv6A9p8q7i2bTT5kae9tz1lxq5F4Rc6iBPQn4aNfW
         YT37QaozMdqYzUt0zy7NEp98Ku81tDgYtoZ8iLt3F+C0wKFn1acEwrQ/njBdeeIWyA1z
         ZFSi2jsRPgYlFn/LPwyWOUnEB+9ceXOanet/79q8BP0aIuwymxMBAtgf9aVAsZeeXmX7
         6R895h4hW4qDm24D99sDXOhvEN26s9fxd92weKOJa+FVJG425pc0rl5+10qKDfioHlvR
         A2gZapCkrI6dreIkZYpMgbMo3mhQvxd7XxrF4RArvUFgNBy/HJ5fWsOn24celQLWwLAk
         B7dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678462401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RycRAdB61mHxmeQ1gcw+uEuoua4OCSgZ9Rhw/hIQ4Js=;
        b=pB0ZC004ilv3cyENqUhYy9JXpwHyFUp+B44tyQfI+krwTGXhBOe6pqgWjgP/p+2zbV
         62miWKgGiQONJ4GqubyI9VJQc47WA/DBaT1SaJkR0rDpbW4p0Y6MVfqooHRppPYgcEuk
         DJ0QbmQl3sYLXV2K+tSIvJ6K0+H+n2ahdBz8qjc3Sj771Oux8vFJH8TtOXzQf4lQ0uEE
         fp6S4oTNS912Rlv95FxkJHmxe+/Fkm+oYywaUV3WxmAxsHsQYCM9FCt6tM0gl28RLMX1
         b3igzvuyx2LhkJ1ISBkktGmWP8uw9nmyRcS7DCXfMdk09Y+imyUJmau2bJvafj9auPWU
         550Q==
X-Gm-Message-State: AO0yUKU0LcZIQRhLCRqxSTnOEua2OCudJ8ZkFCRLI2ib7ECFpKCGy0AQ
        S6dbgpnD69Oe7CzdP+YXk4g=
X-Google-Smtp-Source: AK7set8cFtNsG+2AWu04cWdqb5vPF+nZJqKb/rOWyr60aQZz9kgHd0YzG/H84CE2A8Blj+x7dFjmLQ==
X-Received: by 2002:a17:90a:19c8:b0:234:236f:1a8d with SMTP id 8-20020a17090a19c800b00234236f1a8dmr26266373pjj.14.1678462400796;
        Fri, 10 Mar 2023 07:33:20 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090a604700b00230b8402760sm71637pjm.38.2023.03.10.07.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:33:20 -0800 (PST)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz,
        tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 05/11] cifs: lock chan_lock outside match_session
Date:   Fri, 10 Mar 2023 15:32:04 +0000
Message-Id: <20230310153211.10982-5-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310153211.10982-1-sprasad@microsoft.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Coverity had rightly indicated a possible deadlock
due to chan_lock being done inside match_session.
All callers of match_* functions should pick up the
necessary locks and call them.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/connect.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4ea1e51c3fa5..fb9d9994df09 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1735,7 +1735,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	return ERR_PTR(rc);
 }
 
-/* this function must be called with ses_lock held */
+/* this function must be called with ses_lock and chan_lock held */
 static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
 	if (ctx->sectype != Unspecified &&
@@ -1746,12 +1746,8 @@ static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	 * If an existing session is limited to less channels than
 	 * requested, it should not be reused
 	 */
-	spin_lock(&ses->chan_lock);
-	if (ses->chan_max < ctx->max_channels) {
-		spin_unlock(&ses->chan_lock);
+	if (ses->chan_max < ctx->max_channels)
 		return 0;
-	}
-	spin_unlock(&ses->chan_lock);
 
 	switch (ses->sectype) {
 	case Kerberos:
@@ -1879,10 +1875,13 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 			spin_unlock(&ses->ses_lock);
 			continue;
 		}
+		spin_lock(&ses->chan_lock);
 		if (!match_session(ses, ctx)) {
+			spin_unlock(&ses->chan_lock);
 			spin_unlock(&ses->ses_lock);
 			continue;
 		}
+		spin_unlock(&ses->chan_lock);
 		spin_unlock(&ses->ses_lock);
 
 		++ses->ses_count;
@@ -2706,6 +2705,7 @@ cifs_match_super(struct super_block *sb, void *data)
 
 	spin_lock(&tcp_srv->srv_lock);
 	spin_lock(&ses->ses_lock);
+	spin_lock(&ses->chan_lock);
 	spin_lock(&tcon->tc_lock);
 	if (!match_server(tcp_srv, ctx, dfs_super_cmp) ||
 	    !match_session(ses, ctx) ||
@@ -2718,6 +2718,7 @@ cifs_match_super(struct super_block *sb, void *data)
 	rc = compare_mount_options(sb, mnt_data);
 out:
 	spin_unlock(&tcon->tc_lock);
+	spin_unlock(&ses->chan_lock);
 	spin_unlock(&ses->ses_lock);
 	spin_unlock(&tcp_srv->srv_lock);
 
-- 
2.34.1

