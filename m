Return-Path: <SRS0=XjJ0=SD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E9ADC10F05
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Apr 2019 03:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1909320856
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Apr 2019 03:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbfDADy1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 31 Mar 2019 23:54:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60582 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731476AbfDADy1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 31 Mar 2019 23:54:27 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9EED8882F0;
        Mon,  1 Apr 2019 03:54:27 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-110.bne.redhat.com [10.64.54.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37C1B60185;
        Mon,  1 Apr 2019 03:54:27 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 0/1] secdesc-ui.py
Date:   Mon,  1 Apr 2019 13:54:16 +1000
Message-Id: <20190401035417.13738-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 01 Apr 2019 03:54:27 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel,
a simple python program with a basic UI to view the security descriptor
for SMB2+ resources.

With a basic starting point like this my hope is we can get some interest
from people with python skills that may want to make it better until
it becomes a full-fledged utility.


