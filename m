Return-Path: <SRS0=xi6A=3E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,PDS_TONAME_EQ_TOLOCAL_VSHORT,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA4AC33CB3
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 01:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DABAE24658
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 01:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="arE2n2x2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgAOBXe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jan 2020 20:23:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24453 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728873AbgAOBXe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Jan 2020 20:23:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579051413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=lLgZx0+9duQR2qBOKK+Ty0x1uCH+dmDTmmGLKowvXik=;
        b=arE2n2x21sCwBO6CNn3B81zt3JOCtJL2HtqQoNDWwqwUPuUfQITSWMRrdHpC5QB38aLzAN
        kXt+ozclbsZccQ4vBruRJxmeMyjDAKo/5NZtCtwu3Q+GHNrtmT1n4ntxMPu16blASMtYjY
        zhPqS0Y9z0+m7GalbmUviAr+Vnxmsn8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-PsALQp-xOxipkFLdTuXugw-1; Tue, 14 Jan 2020 20:23:30 -0500
X-MC-Unique: PsALQp-xOxipkFLdTuXugw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 531D9802C8B
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jan 2020 01:23:29 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-61.bne.redhat.com [10.64.54.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC5365D9E5
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jan 2020 01:23:28 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: [PATCH 0/1] add support for fallocate mode 0
Date:   Wed, 15 Jan 2020 11:23:20 +1000
Message-Id: <20200115012321.6780-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,
Please find a small patch that adds support for fallocate mode 0
to extend a non-sparse file.


