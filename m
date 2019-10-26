Return-Path: <SRS0=6ipX=YT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A88ACA9EB9
	for <linux-cifs@archiver.kernel.org>; Sat, 26 Oct 2019 21:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D379F21871
	for <linux-cifs@archiver.kernel.org>; Sat, 26 Oct 2019 21:04:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FPt6X7P7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbfJZVEc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 26 Oct 2019 17:04:32 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46719 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726386AbfJZVEc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 26 Oct 2019 17:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572123871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xE+P97Pce+UcEFbNwpwcpOAy2kp3plg9/Rzwm/58kPU=;
        b=FPt6X7P7cK6vCsTBReQhPYk3J2WXchdulM/64miXVNIZZ0Knz8LiNVEBLMqVuKjzEf9W+h
        ZHUI/vqeukfrpP65M2ZBuRilFVSBkOJSsoouEbYB4ztdC3UHjnwvOhgkcW1orsyjrKbeP/
        qBjbvIQRWs3f+w0TmKYBZbV7zZqUKr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-dbc58Hi8OlmGW2fqvPHTUQ-1; Sat, 26 Oct 2019 17:04:29 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA4201800DFB
        for <linux-cifs@vger.kernel.org>; Sat, 26 Oct 2019 21:04:28 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-48.bne.redhat.com [10.64.54.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B3445D9E5
        for <linux-cifs@vger.kernel.org>; Sat, 26 Oct 2019 21:04:28 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: [PATCH 0/1] cifs: move cifsFileInfo_put logic into a work-queue
Date:   Sun, 27 Oct 2019 07:04:18 +1000
Message-Id: <20191026210419.7575-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: dbc58Hi8OlmGW2fqvPHTUQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, Pavel, Frank

This patch moves the logic in cifsFileInfo_put() into a work-queue so that
it will be processed in a different thread which, importantly, does not hol=
d
any other locks.

This should address the deadlock that Frank reported in the thread:
Yet another hang after network disruption or smb restart -- multiple file w=
riters


