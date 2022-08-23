Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CD0C32774
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 15:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243184AbiHWPFR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 11:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243241AbiHWPEv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 11:04:51 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357FC31FC37
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 05:29:36 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MBnbH4pTjzlWQn;
        Tue, 23 Aug 2022 19:50:03 +0800 (CST)
Received: from fedora.huawei.com (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 23 Aug 2022 19:52:53 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>
Subject: [PATCH -next 0/3] cifs: Use some helper function for preamble size
Date:   Tue, 23 Aug 2022 20:51:59 +0800
Message-ID: <20220823125202.1156172-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

*** BLURB HERE ***
The unfolded expression of header_preamble_size is too long, in addition, 
some expressions have specific semantics, e.g.:
  calculate the position of the mid,
  confirm it's smb2+ server or not.

Zhang Xiaoxu (3):
  cifs: Use help macro to get the header preamble size
  cifs: Use help macro to get the mid header size
  cifs: Add helper function to check smb2+ server

 fs/cifs/cifsencrypt.c |  3 +--
 fs/cifs/cifsglob.h    |  7 +++++++
 fs/cifs/connect.c     | 28 +++++++++++-----------------
 fs/cifs/transport.c   | 21 ++++++++++-----------
 4 files changed, 29 insertions(+), 30 deletions(-)

-- 
2.31.1

