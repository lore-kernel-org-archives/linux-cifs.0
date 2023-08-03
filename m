Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E440AC001DF
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Aug 2023 13:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbjHCNDw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Aug 2023 09:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbjHCNDq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Aug 2023 09:03:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FCB2137;
        Thu,  3 Aug 2023 06:03:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9414A61D95;
        Thu,  3 Aug 2023 13:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3421DC433CB;
        Thu,  3 Aug 2023 13:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691067806;
        bh=G5aTKgMXgAFBTMj/jxfMknL56AhfR6yDEIMpVmQ4PV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvvZu08Ca9AiGqS3u7eWnDj7zat0hKsrok/cCDSIX03jOuWMmJpF/6muVO58tl6Ym
         jnahXcOsywbWM/nLaxTnSUvWBo+K9AakOpKg3tKgqPdpLYrw+t80DfQwik05f9IvRt
         mH9TRRaccl943uYLTSfUDJPnm1aYJB2dbbk1iyW1RSnID8S8HN3NlpFSlnwBZ+h+0X
         8+U5zQ5F+fA0ht/s6p7JYi744lNaY7jsjeUVbvarhGzPHZuPxwZW/CeP98iGaIpQJv
         7zXAWpAhzQN8BzKx6IzhnJwI8iYE4W6b4KLU1VrQd3vjysK9hMpHw7soGUlsV4wzQU
         /yZh8pl25/ueg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Winston Wen <wentao@uniontech.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.4 2/7] cifs: fix session state transition to avoid use-after-free issue
Date:   Thu,  3 Aug 2023 09:03:15 -0400
Message-Id: <20230803130321.641516-2-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230803130321.641516-1-sashal@kernel.org>
References: <20230803130321.641516-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.4.7
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Winston Wen <wentao@uniontech.com>

[ Upstream commit ff7d80a9f2711bf3d9fe1cfb70b3fd15c50584b7 ]

We switch session state to SES_EXITING without cifs_tcp_ses_lock now,
it may lead to potential use-after-free issue.

Consider the following execution processes:

Thread 1:
__cifs_put_smb_ses()
    spin_lock(&cifs_tcp_ses_lock)
    if (--ses->ses_count > 0)
        spin_unlock(&cifs_tcp_ses_lock)
        return
    spin_unlock(&cifs_tcp_ses_lock)
        ---> **GAP**
    spin_lock(&ses->ses_lock)
    if (ses->ses_status == SES_GOOD)
        ses->ses_status = SES_EXITING
    spin_unlock(&ses->ses_lock)

Thread 2:
cifs_find_smb_ses()
    spin_lock(&cifs_tcp_ses_lock)
    list_for_each_entry(ses, ...)
        spin_lock(&ses->ses_lock)
        if (ses->ses_status == SES_EXITING)
            spin_unlock(&ses->ses_lock)
            continue
        ...
        spin_unlock(&ses->ses_lock)
    if (ret)
        cifs_smb_ses_inc_refcount(ret)
    spin_unlock(&cifs_tcp_ses_lock)

If thread 1 is preempted in the gap and thread 2 start executing, thread 2
will get the session, and soon thread 1 will switch the session state to
SES_EXITING and start releasing it, even though thread 1 had increased the
session's refcount and still uses it.

So switch session state under cifs_tcp_ses_lock to eliminate this gap.

Signed-off-by: Winston Wen <wentao@uniontech.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 9d16626e7a669..165ecb222c19b 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1963,15 +1963,16 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
 	}
+	spin_lock(&ses->ses_lock);
+	if (ses->ses_status == SES_GOOD)
+		ses->ses_status = SES_EXITING;
+	spin_unlock(&ses->ses_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/* ses_count can never go negative */
 	WARN_ON(ses->ses_count < 0);
 
 	spin_lock(&ses->ses_lock);
-	if (ses->ses_status == SES_GOOD)
-		ses->ses_status = SES_EXITING;
-
 	if (ses->ses_status == SES_EXITING && server->ops->logoff) {
 		spin_unlock(&ses->ses_lock);
 		cifs_free_ipc(ses);
-- 
2.40.1

