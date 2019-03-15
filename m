Return-Path: <SRS0=S2FA=RS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C69C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 06:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F89C21872
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 06:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfCOGWZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Mar 2019 02:22:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbfCOGWZ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 15 Mar 2019 02:22:25 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC029308FC5F;
        Fri, 15 Mar 2019 06:22:24 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-111.bne.redhat.com [10.64.54.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 732221001DC7;
        Fri, 15 Mar 2019 06:22:24 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 0/1] Add an example on how to fetch FSCTL data
Date:   Fri, 15 Mar 2019 16:22:14 +1000
Message-Id: <20190315062215.29499-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 15 Mar 2019 06:22:24 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel,

Here is a small patch to smbinfo to fetch a FSCTL blob from the server.
There are very very many types of data that might be useful to
surface to the user and this is the first example on using the passthrough
API to fetch an FSCTL blob.

This requires the patch to cifs.ko to add fsctl support that are not in
upstream yet.


