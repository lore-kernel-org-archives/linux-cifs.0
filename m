Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2A5C38142
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Jan 2023 22:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjAQWWk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Jan 2023 17:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjAQWVE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Jan 2023 17:21:04 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D115EFA4
        for <linux-cifs@vger.kernel.org>; Tue, 17 Jan 2023 14:00:53 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id C9BED7FC02;
        Tue, 17 Jan 2023 22:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673992851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4tV+ITJXwcFRqwhnlAzWkrTBGNpXL6qGPnK99ZQac98=;
        b=oArEu1W84QUnQQcW+6f2UmIUb22Jv8Q19rWzeo3jLkkGQS8+LRwzt1iwI1RK6/WwnrVP7y
        jRfkAPuhhk0U5LogFnWIvCdYxOGmIC4zwGh8W0JsnudTpMrZ7kEr/FihEeUyD9MOMjuLRS
        vgFMAn0YPTRUtYb4ERKyVqrrzQt6+Df3qW/nInDQAREIUweV1tKRTAf/FcSB3VqWXMeGIa
        itNI7IjCMZmIDwP5hjLlQr9VGo4Od/rF1rwhAndFyuF5q1JPz6xOM8tNPllVj2hV3fmxoW
        3PhOpVlcwC2yQjfBP0piYS5kGW6KENklS+K4Seq9HUXKyA53vYS9nAFgpkXmeg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, aurelien.aptel@gmail.com,
        Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH v2 0/5] dfs fixes
Date:   Tue, 17 Jan 2023 19:00:36 -0300
Message-Id: <20230117220041.15905-1-pc@cjr.nz>
In-Reply-To: <20230117000952.9965-1-pc@cjr.nz>
References: <20230117000952.9965-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

The most important fix is 1/5 that should fix those random hangs that
we've observed while running dfs tests on buildbot.

I have run twice 50 dfs tests against Windows 2022 and samba 4.16 with
these mount options

	vers=3.1.1,echo_interval=10,{,hard}
	vers=3.0,echo_interval=10,{,hard}
	vers=3.0,echo_interval=10,{,sign}
	vers=3.0,echo_interval=10,{,seal}
	vers=2.1,echo_interval=10,{,hard}
	vers=1.0,echo_interval=10,{,hard}

The only tests which failed (2%) were with SMB1 UNIX extensions
against samba.  readdir(2) was getting STATUS_INVALID_LEVEL from
QUERY_PATH_INFO after failover for some reason -- I'll look into that
when time allows.  Those failures aren't related to this series,
though.

I also did some quick tests with kerberos.

---
v1 -> v2: add comments in patch 1/5 as suggested by Aurelien

Paulo Alcantara (5):
  cifs: fix potential deadlock in cache_refresh_path()
  cifs: avoid re-lookups in dfs_cache_find()
  cifs: don't take exclusive lock for updating target hints
  cifs: remove duplicate code in __refresh_tcon()
  cifs: handle cache lookup errors different than -ENOENT

 fs/cifs/dfs_cache.c | 191 +++++++++++++++++++++++---------------------
 1 file changed, 100 insertions(+), 91 deletions(-)

-- 
2.39.0

