Return-Path: <SRS0=r70z=SI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EAD3C10F06
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Apr 2019 07:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D6842173C
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Apr 2019 07:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfDFHna (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Apr 2019 03:43:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47512 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfDFHna (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 6 Apr 2019 03:43:30 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7E4CB4611556CCAEFF43;
        Sat,  6 Apr 2019 15:43:28 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.408.0; Sat, 6 Apr 2019 15:43:19 +0800
From:   ZhangXiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <sfrench@samba.org>,
        <samba-technical@lists.samba.org>, <zhangxiaoxu5@huawei.com>
Subject: [PATCH v2 0/2] Fix KASAN use-after free in SMB2_write and SMB2_read
Date:   Sat, 6 Apr 2019 15:47:37 +0800
Message-ID: <1554536859-139778-1-git-send-email-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

v1->v2: Add Fixes: eccb4422cf97(smb3: Add ftrace tracepoints for improved SMB3 debugging)

The trace function use the 'req' after released.

ZhangXiaoxu (2):
  cifs: Fix use-after-free in SMB2_write
  cifs: Fix use-after-free in SMB2_read

 fs/cifs/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.7.4

