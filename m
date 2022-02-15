Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1423C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Feb 2022 19:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243397AbiBOTL5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Feb 2022 14:11:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243393AbiBOTL4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Feb 2022 14:11:56 -0500
X-Greylist: delayed 304 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 11:11:46 PST
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632953F325
        for <linux-cifs@vger.kernel.org>; Tue, 15 Feb 2022 11:11:45 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id CB717808A9;
        Tue, 15 Feb 2022 19:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1644951999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JPAZc3JY2LcAMYfpwdNOYBCFdIYxs59jHP4C75eG+ss=;
        b=gfy50yYc+C+NDanU/Um19J65y6T++cqitqpF156kvDR7XopIpIABm0HRfJ9fU46mJIQkhj
        U7+Q1ZBtLpqqcnhTrwrNRHYCDMyQIVKcSNOh8ABh/y5eW8BqhEg5hkRZ+l7eh9BLIzEh3e
        gvpN28iB/MRnPe6x4585UcXml6ecDmV+7J/+5p2TwH1A2S5hwdIhKRYCyMb1nrYe1x27g8
        7QHys7RgHUstEItINoQRtUoJ2G+mwZD9TqJ+M1Z+OjAF4av5aUS8z5EnA6DgGG1vdpdYnv
        V5KrReYMYiAfVJ/aZm158ksMDPuALrgz1kzIgjCOKQUhF2YzS46G4WoGvT9ZBQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: use a different reconnect helper for non-cifsd
 threads
In-Reply-To: <CANT5p=oyS-49nAvmddV=s+VOz+TG0SG7RcTEs6f25g_2hC-rUQ@mail.gmail.com>
References: <CANT5p=oyS-49nAvmddV=s+VOz+TG0SG7RcTEs6f25g_2hC-rUQ@mail.gmail.com>
Date:   Tue, 15 Feb 2022 16:06:35 -0300
Message-ID: <87leyckkzo.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

Shyam Prasad N <nspmangalore@gmail.com> writes:

> My patch last week was not sufficient to fix some of the buildbot
> failures we saw recently.
> Please review and use the following patch for new buildbot runs.
>
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/2b599dec7c9399b66b56419fcb252ab37de94e3b.patch

Patch looks good, however you missed these:

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 053cb449eb16..2e00cd58a8b5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4416,7 +4416,7 @@ static int tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tco
 	 */
 	if (rc && server->current_fullpath != server->origin_fullpath) {
 		server->current_fullpath = server->origin_fullpath;
-		cifs_reconnect(tcon->ses->server, true);
+		cifs_signal_cifsd_for_reconnect(server, true);
 	}
 
 	dfs_cache_free_tgts(tl);
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index ebe236b9d9f5..235aa1b395eb 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -896,7 +896,7 @@ map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
 		if (class == ERRSRV && code == ERRbaduid) {
 			cifs_dbg(FYI, "Server returned 0x%x, reconnecting session...\n",
 				code);
-			cifs_reconnect(mid->server, false);
+			cifs_signal_cifsd_for_reconnect(mid->server, false);
 		}
 	}

With that, feel free to add:

Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
