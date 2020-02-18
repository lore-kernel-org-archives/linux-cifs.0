Return-Path: <SRS0=c9dP=4G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 272DDC34031
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Feb 2020 04:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDB2720801
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Feb 2020 04:18:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dGQFHZWX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgBRESy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Feb 2020 23:18:54 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40754 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726352AbgBRESy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 17 Feb 2020 23:18:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581999533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=2tjhgUW6BCBghuYbAyXmhLETZhZVWWt5+fTJ8ksqV1E=;
        b=dGQFHZWXIX5IlLoAAFnG4NHNO0MhiRASlwFLEIcoKKXUjwzfLrug7WOlxfPOC4NXbe7Had
        9qGcpDCmmW+NXhFY9BB90gntdZeKCaMzV0JO2jS8JK9utCf+3i+iuUSxYD/v2GJ6axnU5+
        D+gI1D1JmN/cJD3V6TAkHZNISfJPCNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-r2KSW0zuNTio3EWmfAGNgg-1; Mon, 17 Feb 2020 23:18:51 -0500
X-MC-Unique: r2KSW0zuNTio3EWmfAGNgg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADA795F9
        for <linux-cifs@vger.kernel.org>; Tue, 18 Feb 2020 04:18:50 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-132.bne.redhat.com [10.64.54.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FC7F19C69
        for <linux-cifs@vger.kernel.org>; Tue, 18 Feb 2020 04:18:50 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: [PATCH 0/1] dont leak -EAGAIN
Date:   Tue, 18 Feb 2020 14:18:41 +1000
Message-Id: <20200218041842.13986-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List

Please find a small patch to fix an issue where during a session reconnect we may leak
-EAGAIN back to the application instead of retrying the operation once reconnect has completed.

This can affects for example the stat() call :
  stat("/mnt", 0x55b802c096f8) = -1 EAGAIN (Resource temporarily unavailable) <0.002447>
causing applications such as 'ls' to fail with an error as this is not a valid return
for stat()



