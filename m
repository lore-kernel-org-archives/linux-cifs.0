Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3120C76195
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 13:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjCONFw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjCONFu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 09:05:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE42570A9
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 06:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=9x4Bm9H1uhZfjy1inAXt6rhGoE94LlElYSHSInWdjGU=; b=s4ykIrxG67TJEdVsfXuFCwedGd
        viDlOovbA1rLaL62ggcTBDQc9XcClXs3a77a1qkMJudc5N3Iy+22Cv/CMIkfmU+mmYCro6fOGrfxg
        dj/bJQsXdmRTQiZpmHhXhbZuzKVYgxreqpfe5/s8EonmRwUrI5nGgvcLUsv/H0osjQEzqy3wE0J9+
        4wGbprPhLDLzwh4c7Zj2PLK70ji61ndAftMDyWuEbXRDz6cqV1MfHmCMQiPyJTnfDdEWETFWNIYMd
        w2SMQFrXiPff0+omAuOQraWpE44+AHcyWStSL3EyaHmyNLLVGYPNZ5/yBUeKjSGchniYg21Obf0vd
        RuJh1ZEI7HvwCQWLY8IL58obM3LFJnAkY20OPZlHMFJBpR1xamIvQDrXlR4zUCs7BDL/yPHobxK0N
        ZuZkUw0Qo0KNtU2WMNHUniA56Aiwe8KrKyxzt7dAgtVcMxzUBG4B1JhlNHxn0YnDlv+w/KjMBjXVW
        iOHXzZQh8mZGjZ13Cs9Ay+CW;
Received: from [2a01:4f8:252:410e::177:224] (port=40716 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pcQp6-003KNd-Gg; Wed, 15 Mar 2023 13:05:44 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 03/10] cifs: Slightly simplify cifs_readdir()
Date:   Wed, 15 Mar 2023 13:05:24 +0000
Message-Id: <468ae3a579bb44fca13113680fecfd550e36b055.1678885349.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678885349.git.vl@samba.org>
References: <cover.1678885349.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"else" not needed, we do a "goto" in the if-branch. This makes the
following condition a bit easier to read for me.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/readdir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index ef638086d734..7dfa33b6954f 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -1165,7 +1165,8 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	if (rc) {
 		cifs_dbg(FYI, "fce error %d\n", rc);
 		goto rddir2_exit;
-	} else if (current_entry != NULL) {
+	}
+	if (current_entry != NULL) {
 		cifs_dbg(FYI, "entry %lld found\n", ctx->pos);
 	} else {
 		if (cfid) {
-- 
2.30.2

