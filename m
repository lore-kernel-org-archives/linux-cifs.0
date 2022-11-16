Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A53C43219
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Nov 2022 02:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbiKPCHD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Nov 2022 21:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiKPCG5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Nov 2022 21:06:57 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903692EF13
        for <linux-cifs@vger.kernel.org>; Tue, 15 Nov 2022 18:06:56 -0800 (PST)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NBmcm6jPXzmVwT;
        Wed, 16 Nov 2022 10:06:32 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 10:06:54 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>
Subject: [PATCH v2 0/2] Fix some bug in cifs
Date:   Wed, 16 Nov 2022 11:11:34 +0800
Message-ID: <20221116031136.3967579-1-zhangxiaoxu5@huawei.com>
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

v2: 
  - remove the 1st patch since steve already merged it into repo.
  - fix cifs 1.0 hung since not set READY flag when wakeup task 
    on 2nd patch.

Zhang Xiaoxu (2):
  cifs: Fix UAF in cifs_demultiplex_thread()
  cifs: Move the in_send statistic to __smb_send_rqst()

 fs/cifs/cifsglob.h  |  1 +
 fs/cifs/transport.c | 55 ++++++++++++++++++++++++++-------------------
 2 files changed, 33 insertions(+), 23 deletions(-)

-- 
2.31.1

