Return-Path: <SRS0=n6BV=SH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFC7C10F13
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 06:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C751F217D7
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 06:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfDEGNO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Apr 2019 02:13:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33994 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbfDEGNO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 5 Apr 2019 02:13:14 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 51040A21748A5F7FB0BC;
        Fri,  5 Apr 2019 14:13:12 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.408.0; Fri, 5 Apr 2019 14:13:01 +0800
From:   ZhangXiaoxu <zhangxiaoxu5@huawei.com>
To:     <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>, <zhangxiaoxu5@huawei.com>
Subject: [PATCH 0/2] Fix KASAN use-after free in SMB2_write and SMB2_read
Date:   Fri, 5 Apr 2019 14:17:20 +0800
Message-ID: <1554445042-98793-1-git-send-email-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The trace function use the 'req' after released.

ZhangXiaoxu (2):
  cifs: Fix use-after-free in SMB2_write
  cifs: Fix use-after-free in SMB2_read

 fs/cifs/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.7.4

