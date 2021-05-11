Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A46C433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 16:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21CBA6117A
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 16:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhEKQhb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 12:37:31 -0400
Received: from mx.cjr.nz ([51.158.111.142]:34466 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230435AbhEKQhb (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 May 2021 12:37:31 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 4A1127FEDB;
        Tue, 11 May 2021 16:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1620750983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qod3kPhoKqFubK7ZdAFp5sJwgWXTFnHdvr7QY83Y8tA=;
        b=NDrz42xiDs1pa8/ANNA/hpcLnl2rCcC0Y6rXe5r7Y/+1P9kcscQRxEBSp93n9Trmd3Bd0R
        YVP6+2p/dNhBGRMK5SYVUCxCc2W0athSaPhdaaxrxhxE6Rr22zDBMQoV5JOV9mMUp8toXt
        YLjVE4yPyUdv7WyoxfixBEj8dyx6tcUarlepT1FwAZ76NwvPa8qqTRFT6e2+vjzz/VVLy2
        nk30GcDyHvKZTuUeNU+arxzjVbYRG54IPgRN0pbA4gEfIw6MUeEZ7pYTJyDrMIR5jzPDyr
        WDsBtJyPrzMYSIJ2VtfQ2MU6sx1Lfx9zG8yjMsWYs9gmzTU5kpPyXRGB89SxKg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 0/3] Support multiple ips per hostname
Date:   Tue, 11 May 2021 13:36:06 -0300
Message-Id: <20210511163609.11019-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,

Follow a series to handle multiple ip addresses per hostame when
mounting, chasing DFS referrals and reconnecting.

We've defined a maximum number of 16 addresses a hostname can handle
as we did in mount.cifs (resolve_host.c::resolve_host).  If that's not
OK, then we could make it flexible by creating a new mount option like
'maxaddrs=N' or just increase it in both sides.

The mount.cifs(8) patch that passes multiple 'ip=' options to handle
all resolved addresses will be posted soon.

Paulo Alcantara (3):
  cifs: introduce smb3_options_for_each() helper
  cifs: handle multiple ip addresses per hostname
  cifs: fix find_root_ses() when refresing dfs cache

 fs/cifs/cifs_dfs_ref.c |   48 +-
 fs/cifs/cifsglob.h     |   24 +-
 fs/cifs/connect.c      | 1042 ++++++++++++++++++++++++----------------
 fs/cifs/dfs_cache.c    |   12 +-
 fs/cifs/dns_resolve.c  |   72 +--
 fs/cifs/dns_resolve.h  |    5 +-
 fs/cifs/fs_context.c   |   22 +-
 fs/cifs/fs_context.h   |    4 +-
 fs/cifs/misc.c         |   95 +++-
 9 files changed, 828 insertions(+), 496 deletions(-)

-- 
2.31.1

