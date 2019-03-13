Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92EAC4360F
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 04:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83A492177E
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 04:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfCMEiB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 00:38:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbfCMEiB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 Mar 2019 00:38:01 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 15B9A3086225;
        Wed, 13 Mar 2019 04:38:01 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-89.bne.redhat.com [10.64.54.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A19885D706;
        Wed, 13 Mar 2019 04:38:00 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 0/2] Start to fix fallocate support
Date:   Wed, 13 Mar 2019 14:37:47 +1000
Message-Id: <20190313043749.832-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 13 Mar 2019 04:38:01 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, Pavel

These initial two patches fixes fallocate -z (zero range) support against
windows2016 shares. This is a different case than what causes generic/469
to fail against samba shares but the approach for all these failures should
be similar.

It is a WIP in that it only addresses one single instance of this general
limited fallocate support in cifs.ko.
Next steps if you agree this is the way to go, would be to try to think
about how we can expand this to some/all of the othter cases as well
but perhaps without making too much code duplication.


Steve, can you run this against the buildbot and see that there are no new
failures from it?

