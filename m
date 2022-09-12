Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52529ECAAA1
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Sep 2022 03:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiILDFF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiILDFD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 11 Sep 2022 23:05:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08F811161
        for <linux-cifs@vger.kernel.org>; Sun, 11 Sep 2022 20:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662951900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PLhbtU21xpL8yJMI2S8b3XTdEFytsJkjs4aU1ItdEXY=;
        b=XYF9XyFO6sXZx5tmcv80RDCoCwlncmNw86zvYnjqCqPtcYiypGJ5TwWjNoiZoMsfYOh7Xq
        uNq8IXROEKXc0Q6xjmQ6JEsZIAKDzKIlrO7NF1L4/h4uClXaGFmgz2fNc51otTS0fki8M6
        2LK2JEbVpJNkUTwvHje8OIrOg18tHL4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-7NA-l3vCPBGXatvVIuCwOw-1; Sun, 11 Sep 2022 23:04:57 -0400
X-MC-Unique: 7NA-l3vCPBGXatvVIuCwOw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13E7529AA2FA;
        Mon, 12 Sep 2022 03:04:57 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67DAF492CA6;
        Mon, 12 Sep 2022 03:04:56 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Cifs: fix kbz 216301: return corrupt/stale file content
Date:   Mon, 12 Sep 2022 13:04:45 +1000
Message-Id: <20220912030446.173296-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List

Please find a small patch that fixes kernel bugzilla 216301 which can cause
writes to an mmaped file to corrupt data when reading it back.

The issue arises when mmaping a file under cache=none. In this case all writes go through the
direct_write codepaths directly to the server.
But IF any of the mmapped page are already present then the write will go to the server without
updating what we present to the application in the mmapped pages.


