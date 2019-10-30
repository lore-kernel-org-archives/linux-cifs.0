Return-Path: <SRS0=jcY3=YX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FCACA9EAE
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Oct 2019 02:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16A6220866
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Oct 2019 02:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E5ZBBMvT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfJ3C7U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Oct 2019 22:59:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53804 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726714AbfJ3C7U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 29 Oct 2019 22:59:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572404359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PvzTZJZHxfBDc4fevyccCRJcTAnWKUUXwGYVAxD1khY=;
        b=E5ZBBMvTBwcvZMWS247hOHOzRXNfK2vHWn5SA84zriyxeI4WJFF9gLXdXdjFIzycKqeZ+y
        jGWyg9XKvRZXdeQgpKLogjN9fDaTCnPedXQSwGIptT06uTocBgQdGsNLw2M3aWR+0jB2JF
        FzhwL17jp5SFS83G2YgyRnaBZqf4+6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-dKMOTYhVM46k2kVndFWsow-1; Tue, 29 Oct 2019 22:59:17 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C07A1800C80
        for <linux-cifs@vger.kernel.org>; Wed, 30 Oct 2019 02:59:16 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-99.bne.redhat.com [10.64.54.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56C005C1D8
        for <linux-cifs@vger.kernel.org>; Wed, 30 Oct 2019 02:59:16 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: [PATCH 0/1] cifs: move cifsFileInfo_put logic into a work-queue
Date:   Wed, 30 Oct 2019 12:59:05 +1000
Message-Id: <20191030025906.14395-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: dKMOTYhVM46k2kVndFWsow-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel,=20
version 3 of the patch with your suggestions.
I left the full commit message of the deadlocked threads as is though.


