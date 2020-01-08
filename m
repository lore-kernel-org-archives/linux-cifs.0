Return-Path: <SRS0=ymiT=25=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE742C33C99
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 03:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E5232080A
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 03:08:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YaQ8y8Rm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgAHDI0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jan 2020 22:08:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29029 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726199AbgAHDI0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Jan 2020 22:08:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578452905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=Al4q+tVXhcJVfxsTO3YT/LYAqVwPsTcFxR6rRpj7414=;
        b=YaQ8y8Rm86nEo6k4R+urNBXWk3KQaGr9Xw23oHO7VrqxJkhZwNgbHqGUMZzzMnRbQy5QRx
        0AfpWbImzVLtW1x/zMfYkq+mzJl0w48I+ZDGnffcD/VNc7bOHyJLLzEJ+s3FJJjTEPPwU8
        cIejmot1vewnWGzz+vx5GPhpddUlVxo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-eZ_64AQkMZ6ZcIHfSot0Yg-1; Tue, 07 Jan 2020 22:08:24 -0500
X-MC-Unique: eZ_64AQkMZ6ZcIHfSot0Yg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69B221800D4E
        for <linux-cifs@vger.kernel.org>; Wed,  8 Jan 2020 03:08:23 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-61.bne.redhat.com [10.64.54.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00FBB77676
        for <linux-cifs@vger.kernel.org>; Wed,  8 Jan 2020 03:08:22 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: [PATCH 0/4] cifs: optimize opendir and save one roundtrip
Date:   Wed,  8 Jan 2020 13:08:03 +1000
Message-Id: <20200108030807.2460-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel, Steve

Please find an updated version of these patches.
It addresses Pavels concerns and adds an extra patch to set maxbufsize
correctly for two other functions that were found during review.

