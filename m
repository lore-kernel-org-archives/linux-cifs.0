Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51C9C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Sep 2021 02:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 941AD6115A
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Sep 2021 02:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347189AbhIHCLw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:11:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347188AbhIHCLt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 22:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631067041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x7/+rijkLJ3KN1RKmhRlLvONYwzMt8KXjStrQofBDV4=;
        b=ZV4SLJqZ43fyYIujLhQjvI2GOGdvr9AW6QO6ZI2paTxKWzNLfDpQpqO/j093Ya71Tbo5FQ
        C5LApccoLBeeNXvVOMGMEW+rLBwZs6ykYCvhzijk7ku6rx8AwfFVHQyBil65c/E9fD1jN9
        WzsyI5tvntyBvWeLFNcs9Hk7CF4v89w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-4J8XN4IyOrK4Ox5iS8cdLQ-1; Tue, 07 Sep 2021 22:10:39 -0400
X-MC-Unique: 4J8XN4IyOrK4Ox5iS8cdLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F336980196C;
        Wed,  8 Sep 2021 02:10:38 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57AE5196E2;
        Wed,  8 Sep 2021 02:10:38 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 0/4] v2 cifs patches
Date:   Wed,  8 Sep 2021 12:10:11 +1000
Message-Id: <20210908021015.2115407-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,
Something got missing in the two patches in for-next. Here is a resend of the two patches in for-next as well as the next two patches for the smb2pdu rework.

Replace the two patches in for-next with this.



