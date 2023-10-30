Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FAAC4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 20:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjJ3UUL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 16:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjJ3UUK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 16:20:10 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4042BDF
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 13:20:07 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698697205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H+IHXSCrkRjIjf8P6Ep3tsNeuTeJRdFAJe3l88hY7QI=;
        b=m26E3y6i03yitBTAOAcmZOm0f3iuEbi//psG2UEVxDMKfv/MMveOk4qn9ocaqA77hNQVzx
        OqWEtTia1jHzT1L2YWwru/mQqEZ5PCoEduxu7FCJ9pz4BxHHv/UfGq4yanm4EXze9Bscnp
        tqMv7oRIIgNlT88huF0InROtrmGnR+QGyOsP5v6epz5fBeQlASfTxyZVz0A5s92mD1z+H6
        RYSwCTqEr8xy28zqMrz+/JrxqnnqCQTZLd/jHBmaurYY4HtkLcAOtHvOYTBbiZAaxqPJXg
        VBZZqD+4toGsVhwII/stqAmGFXKM4O6z06HCilS4nj3gexKGBBjtsD42iWRgzg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1698697205; a=rsa-sha256;
        cv=none;
        b=EFY6OluLs2Zen7yPnAwHaEIF+lckmjNFmsRA+XlS7YzqfK5kf59dx8QiQ5fy1t/m4WRr0v
        rBmguyssmVWIgzb9hfOv3RprSWEHpdmKYxF7FatoZVlsJjra5TgWE+EwdKXVo/+ljKDjJy
        d8x44oFb+K61U5Qo0cTS6N6o2RQYa81hvLnkk2azewKn2ZT4V6Wpw7QL3uu1zjcGEVAvPk
        hdrehlxpXmzUTHI+70cHqrOqJI1KsW2GXIzXeo5+GBJv3c0z1R/hQNwKfETXj2ZRYBaYeR
        ErtdA2gzvMCbkerNvf5I3ZEHhwfk3r+FOVph0ACsd2Q3DqRJ5EOPnE+6IV4byQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698697205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H+IHXSCrkRjIjf8P6Ep3tsNeuTeJRdFAJe3l88hY7QI=;
        b=WlFAycKuzxC1T7BxSzh9lYo6GuVrtub1xVpn457uKh54tteJorHeFt0VYpf0LwT4SrF2kv
        oEXY0PCM1yGLx64KVV4g17rSCNn48vzPIAFBgRWLnWmaYeDWTIc/mIx4AxNSQ1kxPC1I7L
        mu8noCys26qjUzh/8TGI0geK6K+BWiCkgzmlzTXg+GdoP8JeTVwLGbniE0qJq8kvb2FZqQ
        UlqPZQ7uo58pTSizQL6uTa0cmUZtAX+QPi5LVj/ng/U9ySd5/ejay7K5a9nb2W7L8qPRUt
        A2q0/NCbe1n//Dsu6OAkZo/XRNl125pMLHAYqMVagyhYoZCLRIY4PfQk+ffZbQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 1/4] smb: client: remove extra @chan_count check in __cifs_put_smb_ses()
Date:   Mon, 30 Oct 2023 17:19:53 -0300
Message-ID: <20231030201956.2660-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If @ses->chan_count <= 1, then for-loop body will not be executed so
no need to check it twice.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/connect.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 7b923e36501b..a017ee552256 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1969,9 +1969,10 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 
 void __cifs_put_smb_ses(struct cifs_ses *ses)
 {
-	unsigned int rc, xid;
-	unsigned int chan_count;
 	struct TCP_Server_Info *server = ses->server;
+	unsigned int xid;
+	size_t i;
+	int rc;
 
 	spin_lock(&ses->ses_lock);
 	if (ses->ses_status == SES_EXITING) {
@@ -2017,20 +2018,14 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 	list_del_init(&ses->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	chan_count = ses->chan_count;
-
 	/* close any extra channels */
-	if (chan_count > 1) {
-		int i;
-
-		for (i = 1; i < chan_count; i++) {
-			if (ses->chans[i].iface) {
-				kref_put(&ses->chans[i].iface->refcount, release_iface);
-				ses->chans[i].iface = NULL;
-			}
-			cifs_put_tcp_session(ses->chans[i].server, 0);
-			ses->chans[i].server = NULL;
+	for (i = 1; i < ses->chan_count; i++) {
+		if (ses->chans[i].iface) {
+			kref_put(&ses->chans[i].iface->refcount, release_iface);
+			ses->chans[i].iface = NULL;
 		}
+		cifs_put_tcp_session(ses->chans[i].server, 0);
+		ses->chans[i].server = NULL;
 	}
 
 	sesInfoFree(ses);
-- 
2.42.0

