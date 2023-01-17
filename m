Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C03DC46467
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Jan 2023 00:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjAQALB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Jan 2023 19:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbjAQALA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 Jan 2023 19:11:00 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6522716
        for <linux-cifs@vger.kernel.org>; Mon, 16 Jan 2023 16:10:57 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 0ED0A80267;
        Tue, 17 Jan 2023 00:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673914255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SKWwpnsCjO9W99zj2nvqCsU/USVpIDBZx7N0nRbw40w=;
        b=PLaQXoDB5qUeT0ntrEm6FxaEYR3A+PQG1JvFZoj4AuLUGo4OVaE6ypzzsIgedKljPL8qOn
        +LJYdGvy6r9h0q/P59ipCM2WQYi3VhmNfwAtvVygCRX880i2DVjdtF51tfEsB0FGJaT/R+
        GC7znNL+AWmxPUTQVs+2V/7NDsauaB3WnlAzmwfzEnp2XUKvbVcFJ4fs8BXULF8hobVth2
        rbWwmWnoKEl+vqSGifTb4DkS5538ksSPg0K+gaQPMCFUE9u7HeaHC0SzkhaxyLtzLJ0NZ+
        t0GkPR55wGXs5ha7NPFg2ODd9Z3UFUYTA/mJxIMbG0vZqP17dqV12Puq9Q+RsA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 0/5] dfs fixes
Date:   Mon, 16 Jan 2023 21:09:47 -0300
Message-Id: <20230117000952.9965-1-pc@cjr.nz>
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

Paulo Alcantara (5):
  cifs: fix potential deadlock in cache_refresh_path()
  cifs: avoid re-lookups in dfs_cache_find()
  cifs: don't take exclusive lock for updating target hints
  cifs: remove duplicate code in __refresh_tcon()
  cifs: handle cache lookup errors different than -ENOENT

 fs/cifs/dfs_cache.c | 185 ++++++++++++++++++++++----------------------
 1 file changed, 94 insertions(+), 91 deletions(-)

-- 
2.39.0

