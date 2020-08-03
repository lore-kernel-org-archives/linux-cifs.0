Return-Path: <SRS0=CZtn=BN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2854C433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 22:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3DC9208C7
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 22:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CBkOjCzA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgHCWpP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Aug 2020 18:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgHCWpP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Aug 2020 18:45:15 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AF9C06174A;
        Mon,  3 Aug 2020 15:45:15 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t4so32531769iln.1;
        Mon, 03 Aug 2020 15:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Agoua9JCHDPZSVu/sgTJ3ZU4j6VJQrjmmUvDnV2Qjzo=;
        b=CBkOjCzArEuy1db7VIr7ilDZMooH0FRSZha2I7WOWv6I6Cl5GVhk/zzoc1ZwXipk57
         eD1UgSp3wbMEyVbSDGILO6scmVJXSjC9m/cnhjaOymlrJwaUEisuniYncjGAH1AzioQ1
         qaPRtSf6EVf69mGDKwbwscwgIjquUzPB/xX2dIUo0SueLtilcWZb89OPUmhFwLEd2wo3
         SkWFAnoQ8Hk5+E8Ok73qcKL/nT3kfduxM3wkO3XHf+GyAYrhAIiA5FTnXUDBY3hYxya7
         mmCKNqn8DTH/KTjxEXgxKiVl1oydrTyRAtQCCqrQ6hJt9NG5yZdK/F6QvNDN4bWUEeL0
         SaTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Agoua9JCHDPZSVu/sgTJ3ZU4j6VJQrjmmUvDnV2Qjzo=;
        b=dSnQUgUMKcsOS4uJCuTGQD6BaewpmE4xLYMOcJlj/o6au5ZUiZBQySfjp89lAPCFnF
         XkConIWRpeFWf9ZpE3VNC1lpuJzv4JBky8nJgL4QMQ9ycWl7yVwWWMlkPIB1Pp6YiDEB
         BijGRDTRDA/3mGqx2r+fJpIQUcBJ/QgOWF7GTXcUanFgKx/i3MZakgCWQy3QabMLGPQ7
         MnBPos/aHEoiLJYHNzrDYRz1qDP2H3/KX7gXGc8YfE9pW45u6oGUStM6E8ZDl3PDZH//
         cxvdjQkGo+Hpl8mt1MQaL1mdYHXN+YlbH2fnXR2GniZqmqFn6+df9MfbnYSNFVR3yI0a
         txZQ==
X-Gm-Message-State: AOAM530T4aR1bgrg7+YqJWrVMadZuawJBau1AQ5hnx3qMzStMsQ53R1x
        /mdhtxnJVqLPOurHe+D0X1NIxSrgmfalDUf+0zbxZ1hvylc=
X-Google-Smtp-Source: ABdhPJyzb8qVkdEYKl/XUdRE8YTD5IEvET3KySG34H8fI1nLVSIeQ7QvA32FtfnyH9fXtRAoQTT5aN/scC56YizPF9Q=
X-Received: by 2002:a92:849b:: with SMTP id y27mr1759650ilk.173.1596494714333;
 Mon, 03 Aug 2020 15:45:14 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 3 Aug 2020 17:45:03 -0500
Message-ID: <CAH2r5mvA7xqmqPMmYRrU+Jc8SbF-YG=GH9OjvR+Upx_q6aH3jA@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
bcf876870b95592b52519ed4aafcf9d95999bc9c:

  Linux 5.8 (2020-08-02 14:21:45 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.9-rc-smb3-fixes-part1

for you to fetch changes up to 7efd081582619e7c270d1c0a422385dcaa99fa9f:

  cifs: document and cleanup dfs mount (2020-08-02 18:00:26 -0500)

----------------------------------------------------------------
16 cifs/smb3 fixes, about half DFS related, 2 fixes for stable

Still working on and testing an additional set of fixes (including
updates to mount, and some fallocate scenario improvements) for later
in the merge window.

Build verification test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/379
----------------------------------------------------------------
Colin Ian King (1):
      cifs: fix double free error on share and prefix

Liao Pingfang (1):
      cifs: Remove the superfluous break

Paul Aurich (1):
      cifs: Fix leak when handling lease break for cached root fid

Paulo Alcantara (6):
      cifs: reduce number of referral requests in DFS link lookups
      cifs: rename reconn_inval_dfs_target()
      cifs: handle empty list of targets in cifs_reconnect()
      cifs: handle RESP_GET_DFS_REFERRAL.PathConsumed in reconnect
      cifs: only update prefix path of DFS links in cifs_tree_connect()
      cifs: document and cleanup dfs mount

Qinglang Miao (1):
      cifs: convert to use be32_add_cpu()

Randy Dunlap (1):
      cifs: delete duplicated words in header files

Roberto Bergantinos Corpas (1):
      cifs`: handle ERRBaduid for SMB1

Ronnie Sahlberg (1):
      cifs: smb1: Try failing back to SetFileInfo if SetPathInfo fails

Stefan Metzmacher (1):
      cifs: merge __{cifs,smb2}_reconnect[_tcon]() into cifs_tree_connect()

Steve French (1):
      smb3: warn on confusing error scenario with sec=krb5

Wei Yongjun (1):
      cifs: remove unused variable 'server'

 fs/cifs/cifsacl.h   |   4 +-
 fs/cifs/cifsglob.h  |   2 +-
 fs/cifs/cifsproto.h |   9 +-
 fs/cifs/cifssmb.c   | 151 ++++++++---------------------
 fs/cifs/connect.c   | 508
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------
 fs/cifs/dfs_cache.c | 136 +++++++++++++++++++++-----
 fs/cifs/dfs_cache.h |   7 +-
 fs/cifs/inode.c     |   2 -
 fs/cifs/misc.c      |   7 +-
 fs/cifs/netmisc.c   |  27 ++++++
 fs/cifs/sess.c      |   4 +-
 fs/cifs/smb1ops.c   |   4 +-
 fs/cifs/smb2misc.c  |  73 ++++++++++----
 fs/cifs/smb2pdu.c   | 115 +---------------------
 fs/cifs/smb2pdu.h   |   2 +-
 fs/cifs/transport.c |   2 +-
 16 files changed, 560 insertions(+), 493 deletions(-)


-- 
Thanks,

Steve
