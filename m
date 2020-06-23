Return-Path: <SRS0=n4et=AE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C8DC433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Jun 2020 11:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E96F206C3
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Jun 2020 11:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732335AbgFWLae (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Jun 2020 07:30:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51878 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732191AbgFWLac (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 23 Jun 2020 07:30:32 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A4D437A0799BEB6908D4;
        Tue, 23 Jun 2020 19:30:30 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 23 Jun 2020 19:30:24 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <zhangxiaoxu5@huawei.com>, <sfrench@samba.org>,
        <piastryyy@gmail.com>
CC:     <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>
Subject: [PATCH v2 0/2] cifs: Fix data insonsistent when fallocate
Date:   Tue, 23 Jun 2020 07:31:52 -0400
Message-ID: <20200623113154.2629513-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

*** BLURB HERE ***
v1->v2: 
  1. add fixes and cc:stable
  2. punch hole fix address xfstests generic/316 failed

Zhang Xiaoxu (2):
  cifs/smb3: Fix data inconsistent when punch hole
  cifs/smb3: Fix data inconsistent when zero file range

 fs/cifs/smb2ops.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

-- 
2.25.4

