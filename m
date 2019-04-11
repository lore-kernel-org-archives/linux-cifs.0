Return-Path: <SRS0=pabO=SN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D67AC10F14
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1699B2075B
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfDKCXS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Apr 2019 22:23:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfDKCXS (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Apr 2019 22:23:18 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A574D30654D4;
        Thu, 11 Apr 2019 02:23:18 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-110.bne.redhat.com [10.64.54.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FC4EBA4A;
        Thu, 11 Apr 2019 02:23:18 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 0/2] Add get/set compression support to smbinfo
Date:   Thu, 11 Apr 2019 12:23:05 +1000
Message-Id: <20190411022307.26463-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 11 Apr 2019 02:23:18 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel,
Two small patches to add get/set compression support to smbinfo.

The second patch will not work until we get fsctl passthrough support
for writing data to the server into cifs.ko.
I sent a patch to cifs.ko to the list.


