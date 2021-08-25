Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9EAC4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 11:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 890D160F5C
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 11:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239257AbhHYLtL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Aug 2021 07:49:11 -0400
Received: from mailrelay2-1.pub.mailoutpod1-cph3.one.com ([46.30.210.183]:26136
        "EHLO mailrelay2-1.pub.mailoutpod1-cph3.one.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232199AbhHYLtL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 25 Aug 2021 07:49:11 -0400
X-Greylist: delayed 963 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Aug 2021 07:49:10 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tjernlund.se; s=20191106;
        h=content-transfer-encoding:mime-version:content-type:date:to:from:subject:
         message-id:from;
        bh=kjHYQrynI033dEyMNzkrcT20LZafwWRpkmtgJtMg78I=;
        b=qa0LrV93KubioTbz3u6uXGxJ3VXNcOh0JBmvVXlSq4m8+vJNLigj8B8dMLb8acq5l6LzCVjkmAp/e
         kxqrVE/iQKovMo9jsmkcSzriobLCYKimXr6Wr8PvGknTqtfR9hIWzCgcOYkOw0hxORvhu2WiKUjsSN
         uEUMXmUQHBZZqUF4XTjC+UKmM4F7aarbi1KQBVnKy5x9uvbrfHoGoJsD8HNDOvQLdJkH2uiojaeNMX
         K5NBqLwM+U0WqUEgDvuCmuQxoqBBV8Oh5WXCVOA9qHAB5gtkmQx3g6ZePxH50DcNgwNDlnKo2CMGDF
         tPDUa6Aqm4WZBOvaLidLFRiZKKekoqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tjernlund.se; s=rsa1;
        h=content-transfer-encoding:mime-version:content-type:date:to:from:subject:
         message-id:from;
        bh=kjHYQrynI033dEyMNzkrcT20LZafwWRpkmtgJtMg78I=;
        b=EI2nttjSC+u2J5xyV2/Yxdidsd08qiwXsQy/5WqdY+O2XqmThFwSNlhyBP12b1N3Rg9VZPPyJjRSw
         R2PodOBrv7iOCF1Bgw0XIrfsISIKMAc/b6LMBm/qReyuY+Xbea7k5XNUBmm+EsMAhav+HAgR4Q6qr0
         YgVQBswUd81mKQ0LDtPUBUQXMdx1+XO6RGSDw5Bdy3rieoEPQSHaVQLl9h+UhMT8YCRuuvD/45TCSa
         eCxZTqDBq9qNvpXSYzhWqbfDJrpvGS2P4DEwXDvLjOUaecX1vuaQMrJ3nqe7cnFCD5/FU/tnB799vE
         j6JesJFQxmBGa0qT3umnaPNN2bSb8Pg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=tjernlund.se; s=ed1;
        h=content-transfer-encoding:mime-version:content-type:date:to:from:subject:
         message-id:from;
        bh=kjHYQrynI033dEyMNzkrcT20LZafwWRpkmtgJtMg78I=;
        b=JB+yo7mo4NQDiNUHmN/KWQjB38yvFm2fUoZYrsQlD5kioD2gcIA6HOyPl19aHxVC3dkDnrtobdgVv
         tEvEXw8DQ==
X-HalOne-Cookie: 577a3b87c360f9e7fd529f755463a6701fdee6db
X-HalOne-ID: 1b23d3d0-0598-11ec-bd51-d0431ea8a290
Received: from jocke.my.home (h-158-174-186-24.na.cust.bahnhof.se [158.174.186.24])
        by mailrelay2.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPSA
        id 1b23d3d0-0598-11ec-bd51-d0431ea8a290;
        Wed, 25 Aug 2021 11:32:19 +0000 (UTC)
Message-ID: <bec6e1554ba990330cf812050f4b43feda92aeb9.camel@tjernlund.se>
Subject: CIFS version 1/2 negotiate ?
From:   Tjernlund <tjernlund@tjernlund.se>
To:     linux-cifs@vger.kernel.org
Date:   Wed, 25 Aug 2021 13:32:18 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We got an old netapp server which exposes CIFS vers=1 and when trying to mount shares
from this netapp we get:
CIFS: VFS: \\netapp2 Dialect not supported by server. Consider  specifying vers=1.0 or vers=2.0 on mount for accessing older servers
CIFS: VFS: cifs_mount failed w/return code = -95

If I specify vers=1 manually on the mount cmd it works.
However, GUI file managers cannot handle this and less Linux savy users don't know how to
use the mount cmd manually.

I wonder if kernel could grow a SMB1 version negotiate so a standard CIFS mount can work?
We are at kernel 5.13 and I can test/use a kernel patch.

 Jocke


