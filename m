Return-Path: <SRS0=HnFe=RD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1D1C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 06:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D451821850
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 06:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfB1GYN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:24:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbfB1GYN (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 28 Feb 2019 01:24:13 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 153A930D039E;
        Thu, 28 Feb 2019 06:24:13 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-37.bne.redhat.com [10.64.54.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8150F601A3;
        Thu, 28 Feb 2019 06:24:12 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 0/5] Simplify credits handling for compound requests
Date:   Thu, 28 Feb 2019 16:24:00 +1000
Message-Id: <20190228062405.32107-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 28 Feb 2019 06:24:13 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel, Steve,

Here is an updated series that tries to simplify the handling of 
allocating credits to compound requests by using a new method
to atomically wait for n>=1 credits.

Aside from simplifying compound_send_recv() it also solves a potential
(but very unlikely) deadlock that could happen in the current code.

The first two patches are just rearranging the code and changing signatures.
There should not be any change in behaviour from them.

The third patch makes it possible to wait for >1 credits atomically
however no codepath yet uses this.

Fourth patch is to address a potential starvation issue that could happen
IF there are requests for >1 credits.

Fifth patch changes compound_send_recv() to ask for the required n
credits in one atomic wait.


