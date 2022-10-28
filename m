Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D771CECAAA1
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 11:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiJ1L4v (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJ1L4t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 07:56:49 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3216E1C8D48
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 04:56:47 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MzLcH41d2zHvJ8;
        Fri, 28 Oct 2022 19:56:31 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 19:56:45 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>
Subject: [PATCH 0/7] cifs: minor code improvements
Date:   Fri, 28 Oct 2022 20:11:22 +0800
Message-ID: <20221028121129.3375402-1-zhangxiaoxu5@huawei.com>
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


Zhang Xiaoxu (7):
  cifs: Use helper macro SMB2_CREATE_* instead of assignment one by one
  cifs: Use helper macro NTLMSSP_SIGNATURE in decode_ntlmssp_challenge()
  cifs: Remove the redundant null pointer check in SMB2_sess_setup()
  cifs: Remove the redundant null pointer check in SMB2_negotiate()
  cifs: remove the unused xid parameter from smb_mnt_get_fsinfo
  cifs: Fix wrong return value checking when GETFLAGS
  cifs: Reset rc before free_xid()

 fs/cifs/dir.c      |  2 +
 fs/cifs/file.c     | 46 +++++++++++----------
 fs/cifs/ioctl.c    |  9 ++---
 fs/cifs/sess.c     |  7 +---
 fs/cifs/smb2file.c |  9 +++--
 fs/cifs/smb2ops.c  | 12 +-----
 fs/cifs/smb2pdu.c  | 99 +++++++---------------------------------------
 7 files changed, 53 insertions(+), 131 deletions(-)

-- 
2.31.1

