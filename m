Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847DDC32772
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 15:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242767AbiHWPEe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 11:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240270AbiHWPEL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 11:04:11 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4947F31F1D4
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 05:29:13 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MBnwj4xztznTdX;
        Tue, 23 Aug 2022 20:05:09 +0800 (CST)
Received: from fedora.huawei.com (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 23 Aug 2022 20:07:27 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>
Subject: [PATCH -next 0/2] add release callback to cifs_writedata
Date:   Tue, 23 Aug 2022 21:06:35 +0800
Message-ID: <20220823130637.1164764-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The release function of struct cifs_writedata is determined when its
allocated, so add it to the struct and remove the extra parameter about
async_writev

Zhang Xiaoxu (2):
  cifs: Add release function to cifs_writedata
  cifs: remove the release parameter form async_writev

 fs/cifs/cifsglob.h  |  4 ++--
 fs/cifs/cifsproto.h |  9 +++----
 fs/cifs/cifssmb.c   |  5 ++--
 fs/cifs/file.c      | 58 +++++++++++++++++++++++----------------------
 fs/cifs/smb2pdu.c   |  5 ++--
 fs/cifs/smb2proto.h |  3 +--
 6 files changed, 42 insertions(+), 42 deletions(-)

-- 
2.31.1

