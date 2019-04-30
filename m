Return-Path: <SRS0=PRx5=TA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF87C43219
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Apr 2019 09:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EA0821743
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Apr 2019 09:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbfD3JBG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Apr 2019 05:01:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48945 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbfD3JBG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 30 Apr 2019 05:01:06 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 69FC13097021
        for <linux-cifs@vger.kernel.org>; Tue, 30 Apr 2019 09:01:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DA281001DF6
        for <linux-cifs@vger.kernel.org>; Tue, 30 Apr 2019 09:01:06 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5214E18089C9
        for <linux-cifs@vger.kernel.org>; Tue, 30 Apr 2019 09:01:06 +0000 (UTC)
Date:   Tue, 30 Apr 2019 05:01:06 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     CIFS <linux-cifs@vger.kernel.org>
Message-ID: <151404631.6398428.1556614866154.JavaMail.zimbra@redhat.com>
In-Reply-To: <1666985748.6396792.1556614132673.JavaMail.zimbra@redhat.com>
Subject: Memory alignment requirement for Direct/IO
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.66.12.126, 10.4.195.22]
Thread-Topic: Memory alignment requirement for Direct/IO
Thread-Index: LoBIubb5eCZh1Y+FU+kTDfBZPxyGUA==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 30 Apr 2019 09:01:06 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

I setup samba server in upstream  and mount it in local with cache=none,vers=3.11. Then test
the Direct/IO function like this:

fd=open(fname, O_DIRECT | O_RDWR | O_CREAT, 0666))
lseek(fd, 0, SEEK_SET);
read(fd, buf, 1);

For local filesystem such as XFS, "read" will be failed because XFS has 512Byte memory aligment
for Direct/IO. But it's success for cifs. I don't know if it's expected. Could anybody tell me
more about Direct/IO for cifs?

Thanks.

-- 
Best regards!
XiaoLi Feng 冯小丽

Red Hat Software (Beijing) Co.,Ltd
filesystem-qe Team
IRC:xifeng，#channel: fs-qe
Tel:+86-10-8388112
9/F, Raycom
