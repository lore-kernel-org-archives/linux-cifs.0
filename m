Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74222ECAAD3
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Sep 2022 03:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiISDiH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 18 Sep 2022 23:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiISDiF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 18 Sep 2022 23:38:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DEC14D31
        for <linux-cifs@vger.kernel.org>; Sun, 18 Sep 2022 20:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663558682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=f69wmdCfesA/q3dmA5huIe5fs9Tr105V9c56KdwPpr4=;
        b=QzyMapV+1Orw2mylQFAov6HOgxShdT817poI075HHLKQIKZ62aP3v2S/9RM/CcLOEsIv8V
        4QuzDknewLy2Ze0pjbhkrJ6kT8WUCsoZQOZRn6H2kT6UHZSYcnP5JnNb++i+wMKHcFYxuN
        G15Y/jsOwPYnTK9E5OA7qLmDcFTdQkw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-MoHB51AVMcWZFnI_Ag6ocw-1; Sun, 18 Sep 2022 23:37:59 -0400
X-MC-Unique: MoHB51AVMcWZFnI_Ag6ocw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC65C85A583;
        Mon, 19 Sep 2022 03:37:58 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42C224A9254;
        Mon, 19 Sep 2022 03:37:57 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Cifs: dara corruption fix for cache=none when reading a mmapped file
Date:   Mon, 19 Sep 2022 13:37:46 +1000
Message-Id: <20220919033747.461583-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List,
This issue is similar to kernel bugzilla 216301 but is the opposite case.
For cache=none, before we perform a pread() we have to destage any dirty
pages back to the server before we allow the pread() to be performed.


A simple test application for this:
===================================
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>


void write_x_1(int fd, int offset) {
        char b[] = {"x"};
        printf("Writing 'x' at offset: %d. Result: %d\n", offset, pwrite(fd, &b\
, 1, offset));
}


int main(int argc, char *argv[]){
        char buf[32] = {};
        int fd = open(argv[1], O_RDWR|O_CREAT, 0600);
        printf("File descriptor: %d\n", fd);
        char *m = mmap(NULL, 30, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE,\
 fd, 0);
        printf("Madvised: %d\n", madvise(m, 30, MADV_RANDOM));
        printf("1. Reading file content after mmaping: \n%s\n", m);
        write_x_1(fd, 4);
        write_x_1(fd, 9);
        write_x_1(fd, 14);
        write_x_1(fd, 19);
        write_x_1(fd, 24);

        printf("\n");
        printf("2. After updating file content: \n%s\n", m);

        m[5] = 'a';
        m[10] = 'a';
        m[15] = 'a';
        printf("\n");
        pread(fd, buf, 32, 0);
        printf("3. After updating file content: \n%s\n", buf);


        munmap(m, 30);
        close(fd);
}





