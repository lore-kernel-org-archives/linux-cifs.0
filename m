Return-Path: <SRS0=ILFa=ZG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDC4C43141
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Nov 2019 06:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED8A720409
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Nov 2019 06:17:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KgMg8vvv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbfKNGRA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Nov 2019 01:17:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36009 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725601AbfKNGRA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Nov 2019 01:17:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573712219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XOGfyfu8CAhhRfLJa51+AGNmCHdJjNBkqo0MymJaORY=;
        b=KgMg8vvvPxcTB1+oj4RsNW1MVa/BZD9o+8uApJ7+VIidkYBBZC/ZAFMcN1HeVZdzmw3o1K
        S0zlNez9twZ/TvNcciI+3jH+mQ30Oy4FuIXR6UukAqfemZJ3jarueD+UnjGQX+rP+I+0Ry
        R1RPohUUHjcX2ndHQbpBrExNe7MHxQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-uJG-ACfROMCCiwwmzhW6fg-1; Thu, 14 Nov 2019 01:16:58 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77078107ACC5
        for <linux-cifs@vger.kernel.org>; Thu, 14 Nov 2019 06:16:57 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-39.bne.redhat.com [10.64.54.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0ED0F26186
        for <linux-cifs@vger.kernel.org>; Thu, 14 Nov 2019 06:16:56 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: [PATCH 0/1] cifs: fix race between compound_send_recv() and the
Date:   Thu, 14 Nov 2019 16:16:45 +1000
Message-Id: <20191114061646.22122-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: uJG-ACfROMCCiwwmzhW6fg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, Pavel,

I don't get any leaks on open() any more with this patch
and no leaks on close() with Pavels patch.

version 2:
Use is_interrupt_rc() to decide if we should flag the mid as cancelled.


