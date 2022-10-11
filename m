Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 445E0C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 22:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiJKWHs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 18:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJKWHr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 18:07:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E641578B0
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 15:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665526066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=22+3jtwNMANW+TGtLUlicuLnt2iFeHcS41AeiU+mGQU=;
        b=IFgTCX57S+C6abHgmZwS2mGsbkbf45O73MdlJB0pB/wVMEwM4yfEJIu/emRjuA9eUUM/Eu
        f/erY/EV5jQbZREPDcc7r/ioY1WkY3PMicbkNvFl3CTAIcPtmqMD6UhFkM5MEmT46rws2A
        kFyRgoyueTT3TajET8z01IvgXuikquM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-7_dFbC-NNh6M6e61NrFFFw-1; Tue, 11 Oct 2022 18:07:42 -0400
X-MC-Unique: 7_dFbC-NNh6M6e61NrFFFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E8C985A5B6;
        Tue, 11 Oct 2022 22:07:42 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8F6040C206B;
        Tue, 11 Oct 2022 22:07:41 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: cifs: fix emitting cached direntries
Date:   Wed, 12 Oct 2022 08:07:28 +1000
Message-Id: <20221011220729.1455757-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, Tom, List

I update the patch to change rc to be bool and also expanded on the comments
regarding ->pos  as from Tom's comments.



