Return-Path: <SRS0=GStD=SR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33443C10F13
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Apr 2019 02:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02063206B6
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Apr 2019 02:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfDOCay convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 14 Apr 2019 22:30:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfDOCay (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 14 Apr 2019 22:30:54 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 131AD308FE8F
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2019 02:30:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A7F860123
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2019 02:30:54 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 023673FB10
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2019 02:30:54 +0000 (UTC)
Date:   Sun, 14 Apr 2019 22:30:53 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     CIFS <linux-cifs@vger.kernel.org>
Message-ID: <510628530.3487503.1555295453817.JavaMail.zimbra@redhat.com>
In-Reply-To: <359361880.3486881.1555294820885.JavaMail.zimbra@redhat.com>
Subject: [regression]: CIFS: block in wait_for_free_credits when open file
 for SMB1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.66.12.126, 10.4.195.23]
Thread-Topic: : CIFS: block in wait_for_free_credits when open file for SMB1.0
Thread-Index: uc6LxSQeP6si3r2rXj7bXEntlukyzQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 15 Apr 2019 02:30:54 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Setup samba server on v5.1-rc3 and mount it in local with vers=1.0. Use the reproducer below to test if open file succesffully after unlink.
The process blocked in wait_for_free_credits and never return. SMB2.0+ don't have this issue because of

  https://bugzilla.kernel.org/show_bug.cgi?id=203271

It's a regression issue. Testing pass on v4.9-rc8 but start failed after v5.0.

[<0>] wait_for_free_credits+0x258/0x460 [cifs]
[<0>] SendReceive+0xcd/0x360 [cifs]
[<0>] CIFSPOSIXCreate+0x1bf/0x440 [cifs]
[<0>] cifs_posix_open+0x1ee/0x300 [cifs]
[<0>] cifs_do_create+0x447/0x710 [cifs]
[<0>] cifs_atomic_open+0x1ab/0x530 [cifs]
[<0>] path_openat+0xd54/0x1670
[<0>] do_filp_open+0x93/0x100
[<0>] do_sys_open+0x186/0x220
[<0>] do_syscall_64+0x55/0x1a0
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[<0>] 0xffffffffffffffff

reproducer.c:
#define _GNU_SOURCE            
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/file.h>
#include <errno.h>
void test()
{
    int fd;
    int ret;

    fd = open("./testfile",O_RDWR|O_CREAT,0644);
    printf("errno=%d\n",errno);
    if (fd < 0)
    {
        perror("open failed");
        exit(1);
    }
    ret = unlink("./testfile");
    if (ret < 0)
    {
        perror("unlink failed");
        exit(1);
    }
    //add close(fd) here, then does not block.
}
int main(int argc, char **argv)
{
    int index=50;
    while(index)
    {
        index--;
        printf("loop %d\n",index);
        test();
    }
    return 0;
}


I reported it in https://bugzilla.kernel.org/show_bug.cgi?id=203269

-- 
Best regards!
XiaoLi Feng 冯小丽

Red Hat Software (Beijing) Co.,Ltd
filesystem-qe Team
IRC:xifeng，#channel: fs-qe
Tel:+86-10-8388112
9/F, Raycom
