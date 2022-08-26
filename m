Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9914ECAAD2
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Aug 2022 09:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245312AbiHZJk2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Aug 2022 05:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344089AbiHZJkY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Aug 2022 05:40:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7B517E34
        for <linux-cifs@vger.kernel.org>; Fri, 26 Aug 2022 02:40:22 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MDZTD5LL8zYcmd;
        Fri, 26 Aug 2022 17:36:00 +0800 (CST)
Received: from fedora.huawei.com (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 26 Aug 2022 17:40:19 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>
Subject: [PATCH -next 0/2] Use help macro SMB2_CREATE_TAG_POSIX in cifs and ksmbd
Date:   Fri, 26 Aug 2022 18:39:25 +0800
Message-ID: <20220826103927.2802716-1-zhangxiaoxu5@huawei.com>
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

Posix tag already defined in fs/smbfs_common/smb2pdu.h, use
the helper macro SMB2_CREATE_TAG_POSIX here.

Zhang Xiaoxu (2):
  cifs: Use helper macro SMB2_CREATE_TAG_POSIX
  ksmbd: Use helper macro SMB2_CREATE_TAG_POSIX

 fs/cifs/smb2pdu.c  | 43 +++----------------------------------------
 fs/ksmbd/oplock.c  | 18 +-----------------
 fs/ksmbd/smb2pdu.c | 18 +-----------------
 3 files changed, 5 insertions(+), 74 deletions(-)

-- 
2.31.1

