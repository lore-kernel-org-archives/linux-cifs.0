Return-Path: <SRS0=BRhE=RO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD40C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 06:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 006CC20657
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 06:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfCKGAd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Mar 2019 02:00:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52388 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbfCKGAd (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 11 Mar 2019 02:00:33 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 50105C057F49;
        Mon, 11 Mar 2019 06:00:33 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-95.bne.redhat.com [10.64.54.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB40D427C;
        Mon, 11 Mar 2019 06:00:32 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 0/1] server stat data out of cache for the root handle
Date:   Mon, 11 Mar 2019 16:00:24 +1000
Message-Id: <20190311060025.9750-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 11 Mar 2019 06:00:33 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,

Largely finished WIP patch for starting to cache metadata for the 
shared root. This initial patch caches the FILE_ALL_INFO infolevel.

I should break this up into a series of smaller patches so that we can separate
out what is just standard boilerplate code and what is the important changes.


