Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B2BC6FA82
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Sep 2022 21:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiISVik (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Sep 2022 17:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiISViU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Sep 2022 17:38:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC97229C89
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 14:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663623495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZRghTUwQutwgrIa64LUt6vo7nDUT09U/KNJqhF/7y3k=;
        b=d9D1oe5pXgxdUTFTqJYWhpKLaUF4kvnyNMQBy2KGJB4XDyXHhkdjzPj/tdridnhuegzYzU
        i8ArFFCr5UkHVgScgLvpiCvd5CQ2mw/2xFD21lduDcgtoFF4P9PW82wy2AZTzRYzUGlTYS
        q+rBb9Qxy3GchwQhLVSkucwCm4dik44=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-zgF8QxOUMXyrmg6qvDB3Gw-1; Mon, 19 Sep 2022 17:38:10 -0400
X-MC-Unique: zgF8QxOUMXyrmg6qvDB3Gw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50F51811E87;
        Mon, 19 Sep 2022 21:38:10 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FA0017583;
        Mon, 19 Sep 2022 21:38:09 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Updated patch for the corruption with cache=none and mmap 
Date:   Tue, 20 Sep 2022 07:37:58 +1000
Message-Id: <20220919213759.487123-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, Enzo,

Updated patch that removes the redundant conditionals that Enzo pointed out
on the list.


