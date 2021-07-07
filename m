Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5047DC07E9B
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 23:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3423F61C90
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 23:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhGGX1M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 19:27:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25890 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230029AbhGGX1M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jul 2021 19:27:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625700271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LmeLc7lPc5g61T/IShcxLm46LpZlNbYzG90EfaMDnvM=;
        b=VvA37XJdL5K3e1Jzqa8QFTps8tONHmTVKOAi+nJpiKVDwWsPfdCWQwkD+yJs9iSl3ubwnr
        qjrSsScP1Gp4lwAPjJYUjAyEZcjH7gNY3UxBh4O+WTVVukbU8jDXG4srxqp3flM0iLF2Hu
        DjJk29iRPCwDPOumc/V6Oew6MaWPtXc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-hbsyB785PYuWipPwKZ2bYg-1; Wed, 07 Jul 2021 19:24:29 -0400
X-MC-Unique: hbsyB785PYuWipPwKZ2bYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D85B936254;
        Wed,  7 Jul 2021 23:24:28 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-39.bne.redhat.com [10.64.54.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69B7A19C45;
        Wed,  7 Jul 2021 23:24:28 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 0/1] cifs: use helpers when parsing uid/gid mount options and
Date:   Thu,  8 Jul 2021 09:24:15 +1000
Message-Id: <20210707232416.2694911-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,
This is a small patch to use the existing helpers to validate the uid/gid
values that can be passed as mount arguments.


