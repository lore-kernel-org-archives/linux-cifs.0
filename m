Return-Path: <SRS0=JwxV=BV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4217CC433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Aug 2020 01:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CEE9206DC
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Aug 2020 01:25:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FIP5mv0U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgHKBZd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Aug 2020 21:25:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49521 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727985AbgHKBZd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Aug 2020 21:25:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597109132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=wbtvcQspsBIoUXrnb488GjLwznDX71oWzwrHbQ5iJ50=;
        b=FIP5mv0UN6C1w+pFWikNux876YbFd1FDW+K0Kbc8d8+DGjqmnTLr4Xdb6YMBoQ9u0ZIF1g
        tvlcN9tMyCmAjCpFnz6JO5/ruMd8iWCBG6j8CmUIgvxgELOmJVtuS95WyMO2wcBFjA18yJ
        CZ8kD0cGpsRG321hJYiBuj6nuZqnlhI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-pNf-ZVevMQSOf93q1N0dzg-1; Mon, 10 Aug 2020 21:25:30 -0400
X-MC-Unique: pNf-ZVevMQSOf93q1N0dzg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DE2559
        for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2020 01:25:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8751761982
        for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2020 01:25:28 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8176D4EDB7
        for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2020 01:25:28 +0000 (UTC)
Date:   Mon, 10 Aug 2020 21:25:27 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     CIFS <linux-cifs@vger.kernel.org>
Message-ID: <3704067.45751512.1597109127904.JavaMail.zimbra@redhat.com>
In-Reply-To: <1097808468.45751159.1597108422888.JavaMail.zimbra@redhat.com>
Subject: FS-Cache for cifs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.16]
Thread-Topic: FS-Cache for cifs
Thread-Index: KXhuMfHTM790eCXfua/oIh10OZKIXQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello everyone,

Recently I'd like to test fs-cache for cifs. But CONFIG_CIFS_FSCACHE is not=
 set defaultly.
Are there any concern to enable it? Test it to enbale fs-cache. It seems wo=
rk. The file=20
/proc/fs/fscache/stats is update when do some cp operations.

Thanks.

--=20
Best regards!
XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD

