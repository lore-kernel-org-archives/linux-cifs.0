Return-Path: <SRS0=PjUO=Q3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F27C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 06:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D1B02147A
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Feb 2019 06:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfBTGLy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 01:11:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfBTGLx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 20 Feb 2019 01:11:53 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BA5CC6698A;
        Wed, 20 Feb 2019 06:11:53 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-96.bne.redhat.com [10.64.54.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B1184242;
        Wed, 20 Feb 2019 06:11:52 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 0/2] Simplify handling of credits in compound_send_recv()
Date:   Wed, 20 Feb 2019 16:11:43 +1000
Message-Id: <20190220061145.28241-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 20 Feb 2019 06:11:53 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel, Steve,

I think we can simplify the credits handling in compound_send_recv() a bit.

The first patch adds an extra argument to wait_for_free_request() and
allows us to atomically wait for n (n >= 1) requests/credits instead of just a
single one.
All callsites pass 1 as number of requests so no behaviour should be changed.

The second patch uses this new feature to now atomically wait for num_rqst
requests/credits in one single call.
This makes the code much simpler, since we no longer need to return
the credits if we only got a partial number of requests (can no longer happen).
It also solves a potential deadlock if we have many concurrent threads
trying to allocate requests/credits at the same time. I.e.
each one grabs one or two requests but then block on the final request.


We still have the issue that if we we do not have enough credits for the compound,
and the server will not grant us any additional credits in any responses yet to be received,  and the client is not doing any other I/O which might bump the number of requests, then we might block indefinitely, or until the session is reconnected.
That is unchanged but should be a lot rarer since we no longer have the deadlock between many concurrent threads.


