Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF6EC43334
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 00:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiGYAUK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 20:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGYAUJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 20:20:09 -0400
X-Greylist: delayed 397 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 24 Jul 2022 17:20:08 PDT
Received: from smtp01.aussiebb.com.au (smtp01.aussiebb.com.au [121.200.0.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0900B85
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 17:20:08 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by smtp01.aussiebb.com.au (Postfix) with ESMTP id 90832100384;
        Mon, 25 Jul 2022 10:13:27 +1000 (AEST)
X-Virus-Scanned: Debian amavisd-new at smtp01.aussiebb.com.au
Received: from smtp01.aussiebb.com.au ([127.0.0.1])
        by localhost (smtp01.aussiebb.com.au [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1sQ4oH17qdL9; Mon, 25 Jul 2022 10:13:27 +1000 (AEST)
Received: by smtp01.aussiebb.com.au (Postfix, from userid 116)
        id 86F731002F9; Mon, 25 Jul 2022 10:13:27 +1000 (AEST)
Received: from donald.themaw.net (180-150-90-198.b4965a.per.nbn.aussiebb.net [180.150.90.198])
        by smtp01.aussiebb.com.au (Postfix) with ESMTP id B84F21002E3;
        Mon, 25 Jul 2022 10:13:25 +1000 (AEST)
Subject: [PATCH] cifs: fix negative option value parsing
From:   Ian Kent <raven@themaw.net>
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Leif Sahlberg <lsahlber@redhat.com>
Date:   Mon, 25 Jul 2022 08:13:25 +0800
Message-ID: <165870800544.18681.3152428501550287295.stgit@donald.themaw.net>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The valid values of options that are defined with fsparam_u32() should
be positive.

But the fs parser will return a fail for values that are negative and
if the sloppy option is given success will then be returned resulting
in the option being silently ignored.

Also the sloppy option handling is meant to return success for invalid
options not valid options with invalid values.

Restricting the sloppy option override to handle failure returns for
invalid options only is sufficient to resolve these problems.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Leif Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 8dc0d923ef6a..2dc5cdeee354 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -863,7 +863,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	if (!skip_parsing) {
 		opt = fs_parse(fc, smb3_fs_parameters, param, &result);
 		if (opt < 0)
-			return ctx->sloppy ? 1 : opt;
+			return (opt == -ENOPARAM && ctx->sloppy) ? 1 : opt;
 	}
 
 	switch (opt) {


