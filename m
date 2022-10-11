Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDD8C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 06:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJKGq2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 02:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJKGqX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 02:46:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2682377547
        for <linux-cifs@vger.kernel.org>; Mon, 10 Oct 2022 23:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665470782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BEHR5rl2LvogNEOZ0kK6WA/buymBTpQhkcE+lZVBjwg=;
        b=KbKIbuJPm0EI8Xd9WaZI+Um40KpzwUDNrME5VIvIy40Ssu9lpvUYUPEGbvIYtF66ZWbJ5j
        6T1eGuQG/9NtG/T0I1mcwj+GokC6Fu/+t4/Z28eMhsuV6YiXHM0Vv5HolpU/ohhXcuZryS
        fh4RQ+SOHvRMBK7zzQERcLf9KXyuRis=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-OpnAniaWMxu_w-I9DssPdQ-1; Tue, 11 Oct 2022 02:46:20 -0400
X-MC-Unique: OpnAniaWMxu_w-I9DssPdQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC50E833948;
        Tue, 11 Oct 2022 06:46:19 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B51E112D17C;
        Tue, 11 Oct 2022 06:46:18 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: cifs: fix skipping to incorrect offset in emit_cached_diretns
Date:   Tue, 11 Oct 2022 16:46:10 +1000
Message-Id: <20221011064611.1428646-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,

V3 of the patch.  We have to handle that there may be indicies that are
skipped in the ->pos sequence so add support to handle this.
As we now can handle this case we no longer need to modify cifs_filldir
to return -EEXIST for these cases.

This fixes generic/006/100/111/257


