Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB98C38A02
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Oct 2022 07:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJ2Hzn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 29 Oct 2022 03:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJ2Hzm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 29 Oct 2022 03:55:42 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F0D6CF6E
        for <linux-cifs@vger.kernel.org>; Sat, 29 Oct 2022 00:55:37 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mzs7p4PQHzpW1n;
        Sat, 29 Oct 2022 15:52:06 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 15:55:35 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>
Subject: [PATCH v2 0/7] cifs: minor code improvements
Date:   Sat, 29 Oct 2022 17:00:04 +0800
Message-ID: <20221029090011.79367-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

v1->v2: Fix compile error and uninitialized variable.

Zhang Xiaoxu (7):
  cifs: Use helper macro SMB2_CREATE_* instead of assignment one by one
  cifs: Use helper macro NTLMSSP_SIGNATURE in decode_ntlmssp_challenge()
  cifs: Remove the redundant null pointer check in SMB2_sess_setup()
  cifs: Remove the redundant null pointer check in SMB2_negotiate()
  cifs: remove the unused xid parameter from smb_mnt_get_fsinfo
  cifs: Fix wrong return value checking when GETFLAGS
  cifs: Reset rc before free_xid()

 fs/cifs/dir.c      |  2 +
 fs/cifs/file.c     | 36 +++++++++--------
 fs/cifs/ioctl.c    |  9 ++---
 fs/cifs/sess.c     |  7 +---
 fs/cifs/smb2file.c |  9 +++--
 fs/cifs/smb2ops.c  | 12 +-----
 fs/cifs/smb2pdu.c  | 99 +++++++---------------------------------------
 7 files changed, 48 insertions(+), 126 deletions(-)

-- 
2.31.1

