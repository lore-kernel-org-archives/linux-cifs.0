Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62184C4360F
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 04:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B12920675
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 04:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfCFEQF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 23:16:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbfCFEQE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Mar 2019 23:16:04 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C83A8FF4C;
        Wed,  6 Mar 2019 04:16:04 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-133.bne.redhat.com [10.64.54.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 609D95D782;
        Wed,  6 Mar 2019 04:16:04 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 0/6] cifs: simplify handling of credits for compounds
Date:   Wed,  6 Mar 2019 14:15:40 +1000
Message-Id: <20190306041546.10419-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 06 Mar 2019 04:16:04 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel, Steve

Version 3:
- Add a timeout argument to the wait function and abort with -EAGAIN
upon timeout.

