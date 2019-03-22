Return-Path: <SRS0=7c9k=RZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936D7C10F03
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Mar 2019 12:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61E632054F
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Mar 2019 12:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731717AbfCVMZt convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:25:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44812 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390965AbfCVMXo (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 22 Mar 2019 08:23:44 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 12422C05AA51
        for <linux-cifs@vger.kernel.org>; Fri, 22 Mar 2019 12:23:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 09B045D71E
        for <linux-cifs@vger.kernel.org>; Fri, 22 Mar 2019 12:23:44 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 01D3341F3C;
        Fri, 22 Mar 2019 12:23:44 +0000 (UTC)
Date:   Fri, 22 Mar 2019 08:23:43 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>
Message-ID: <280287391.8052131.1553257423805.JavaMail.zimbra@redhat.com>
In-Reply-To: <599904512.8051095.1553257291511.JavaMail.zimbra@redhat.com>
Subject: CIFS support preallocate partially
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.72.12.68, 10.4.195.13]
Thread-Topic: CIFS support preallocate partially
Thread-Index: fCunvduiND29aluzfIW0k2xHZghieg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 22 Mar 2019 12:23:44 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

Use xfs_io to test preallocate. It returns successfuly. But it's a empty file. And doesn't allocate space.

# mount //localhost/cifs  ~/cifs
# xfs_io -f -c "resvsp 4 4" cifs/file
# du -h cifs/file
0	cifs/file


Test on xfs:
# rm -rf file
# xfs_io -f -c "resvsp 4 4" file
# du -h file
4.0K	file

Is it expected for cifs? I think the size should be a block size(1M for cifs).

Thanks.

-- 
Best regards!
XiaoLi Feng 冯小丽

Red Hat Software (Beijing) Co.,Ltd
filesystem-qe Team
IRC:xifeng，#channel: fs-qe
Tel:+86-10-8388112
9/F, Raycom
