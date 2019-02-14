Return-Path: <SRS0=e9ua=QV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC432C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 08:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B350F222A1
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 08:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391397AbfBNIFx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:05:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733268AbfBNIFx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Feb 2019 03:05:53 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CBF883F3C;
        Thu, 14 Feb 2019 08:05:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CB4C5D9C6;
        Thu, 14 Feb 2019 08:05:53 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0C6C23F7CB;
        Thu, 14 Feb 2019 08:05:53 +0000 (UTC)
Date:   Thu, 14 Feb 2019 03:05:52 -0500 (EST)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Message-ID: <1715745087.982638.1550131552920.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAH2r5muwi0BSpU7jujroojVNM6qO8pRO_mXTBA4TpSsp2Cd=5A@mail.gmail.com>
References: <CAH2r5muwi0BSpU7jujroojVNM6qO8pRO_mXTBA4TpSsp2Cd=5A@mail.gmail.com>
Subject: Re: [SMB3][PATCH] request more credits during session setup
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.54.96, 10.4.195.9]
Thread-Topic: request more credits during session setup
Thread-Index: 33owiIvSjFl1xK5lhVpEwI0JVX5gRw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 14 Feb 2019 08:05:53 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In libsmb2 I am very aggressive about requesting credits during early session establish without problems
so I am confident we could even dial this up to say 1000 credits.

Though  105 might be more than sufficient.

----- Original Message -----
From: "Steve French" <smfrench@gmail.com>
To: "CIFS" <linux-cifs@vger.kernel.org>
Sent: Thursday, 14 February, 2019 5:27:41 PM
Subject: [SMB3][PATCH] request more credits during session setup

We only request significantly more credits (during mount) on first
session setup so we typically end up with from 43-49 credits available
when mount completes - which is not enough for a large I/O to complete
(if started soon after mount).  We need > 64 credits.   Solve this by
requesting more than 2 credits on tree connect.

After mount (before this patch):
43 credits (not enough for a 4MB I/O)

After mount (with this patch)
105 credits (which is good, enough for two large I/Os to be issued
immediately after mount)


-- 
Thanks,

Steve
