Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3ED4C54EE9
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 01:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiINBQ5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 21:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiINBQz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 21:16:55 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FF661B33
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 18:16:54 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MS2RR062dznTyd;
        Wed, 14 Sep 2022 09:14:11 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 09:16:51 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>, <tom@talpey.com>, <linkinjeon@kernel.org>,
        <hyc.lee@gmail.com>
Subject: [PATCH v6 0/5] Fix some bug in FSCTL_VALIDATE_NEGOTIATE_INFO handler
Date:   Wed, 14 Sep 2022 10:17:36 +0800
Message-ID: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com>
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

v5->v6: use 'static' for 'smbx_neg_dialects'
v4->v5: reorder the patch; 
	add check in smb2_ioctl() to ensure no oob read to DialectCount
v3->v4: Fix the wrong sizeof validate_negotiate_info_req in ksmbd
v2->v3: refactor the dialects in struct validate_negotiate_info_req to
	variable array
v1->v2: fix some bug in ksmbd when handle FSCTL_VALIDATE_NEGOTIATE_INFO
	message

Zhang Xiaoxu (5):
  cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message
  ksmbd: Fix wrong return value in smb2_ioctl()
  ksmbd: Fix FSCTL_VALIDATE_NEGOTIATE_INFO message length check in
    smb2_ioctl()
  cifs: Add neg dialects info to smb version values
  cifs: Refactor dialects in validate_negotiate_info_req to variable
    array

 fs/cifs/cifsglob.h        |  2 ++
 fs/cifs/smb2ops.c         | 35 ++++++++++++++++++++++
 fs/cifs/smb2pdu.c         | 61 +++++++--------------------------------
 fs/ksmbd/smb2pdu.c        | 14 +++++----
 fs/smbfs_common/smb2pdu.h |  3 +-
 5 files changed, 58 insertions(+), 57 deletions(-)

-- 
2.31.1

