Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1F2C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 13:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiJQNmP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 09:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJQNmO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 09:42:14 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E99F02F
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 06:42:13 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MrdPV6n69zpTGF;
        Mon, 17 Oct 2022 21:38:54 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 21:42:11 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
        <aaptel@suse.com>
Subject: [PATCH 0/5] cifs: Fix xid leak in cifs
Date:   Mon, 17 Oct 2022 22:45:20 +0800
Message-ID: <20221017144525.414313-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Found some xid leak with the following cocci script:

/usr/bin/spatch -I include -timeout 60 -very_quiet \
	-sp_file missing-free_xid.cocci fs/cifs

@r1@
identifier xid;
position p;
@@
...
  xid = get_xid();
<+... when != free_xid(xid)
  if (...) {
    ... when != free_xid(xid)
        when forall
    return@p ...;
  }
...+>
  free_xid(xid);

@depends on r1@
position r1.p;
@@
+ free_xid(xid);
  return@p ...;

@r2@
identifier xid;
position p;
@@
...
  unsigned int xid = get_xid();
<+... when != free_xid(xid)
  if (...) {
    ... when != free_xid(xid)
        when forall
    return@p ...;
  }
...+>
  free_xid(xid);

@depends on r2@
position r2.p;
@@
+ free_xid(xid);
  return@p ...;

@r3@
identifier xid;
position p;
@@
...
  xid = get_xid();
  ... when != \(free_xid\|_free_xid\)(xid);
  return@p ...;

@depends on r3@
position r3.p;
@@
+ free_xid(xid);
  return@p ...;

@r4@
identifier xid;
position p;
@@
...
  unsigned int xid = get_xid();
  ... when != \(free_xid\|_free_xid\)(xid);
  return@p ...;

@depends on r4@
position r4.p;
@@
+ free_xid(xid);
  return@p ...;

Zhang Xiaoxu (5):
  cifs: Fix xid leak in cifs_create()
  cifs: Fix xid leak in cifs_copy_file_range()
  cifs: Fix xid leak in cifs_flock()
  cifs: Fix xid leak in cifs_ses_add_channel()
  cifs: Fix xid leak in cifs_get_file_info_unix()

 fs/cifs/cifsfs.c |  7 +++++--
 fs/cifs/dir.c    |  6 ++++--
 fs/cifs/file.c   | 11 +++++++----
 fs/cifs/inode.c  |  6 ++++--
 fs/cifs/sess.c   |  1 +
 5 files changed, 21 insertions(+), 10 deletions(-)

-- 
2.31.1

