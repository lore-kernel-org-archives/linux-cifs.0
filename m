Return-Path: <SRS0=e7zQ=TO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1B5C04AB4
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 21:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79C3820862
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 21:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfENVdz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 May 2019 17:33:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfENVdy (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 14 May 2019 17:33:54 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DA66E307D910;
        Tue, 14 May 2019 21:33:54 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-44.bne.redhat.com [10.64.54.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 733CC6135A;
        Tue, 14 May 2019 21:33:54 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 0/1] cifs: add support for SEEK_DATA and SEEK_HOLE
Date:   Wed, 15 May 2019 07:17:01 +1000
Message-Id: <20190514211702.19269-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 14 May 2019 21:33:54 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,

Here is a patch that adds support for SEEK_DATA and SEEK_HOLE.
It passes the SEEK_DATA/HOLE tests that are part of
xfstests generic/285,286,436,445,448,490


