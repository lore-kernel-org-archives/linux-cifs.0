Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5735EE49AD
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Aug 2023 01:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbjHWBp1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Aug 2023 21:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjHWBpY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Aug 2023 21:45:24 -0400
X-Greylist: delayed 918 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Aug 2023 18:45:21 PDT
Received: from symantec4.comsats.net.pk (symantec4.comsats.net.pk [203.124.41.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C15E54
        for <linux-cifs@vger.kernel.org>; Tue, 22 Aug 2023 18:45:21 -0700 (PDT)
X-AuditID: cb7c291e-055ff70000002aeb-90-64e54c317804
Received: from iesco.comsatshosting.com (iesco.comsatshosting.com [210.56.28.11])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by symantec4.comsats.net.pk (Symantec Messaging Gateway) with SMTP id 0B.9C.10987.23C45E46; Wed, 23 Aug 2023 05:00:50 +0500 (PKT)
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns;
        d=iesco.com.pk; s=default;
        h=received:content-type:mime-version:content-transfer-encoding
          :content-description:subject:to:from:date:reply-to;
        b=A1D6aqodeUygJwheD81x4qzQX1p5p32JpZQ9dJ5fq8Sj65mqeIgFRRq+dHZ9Eg+08
          bGBO77Mmll9QlY6UgWhU8OGpgqqDipABdn3howanQKv3xntL8cZJYIE9iTACGMEm/
          BdQFzBhTXvbkc2fSiM9kC5cejPKVZd3m0eaGgEnXU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iesco.com.pk; s=default;
        h=reply-to:date:from:to:subject:content-description
          :content-transfer-encoding:mime-version:content-type;
        bh=GMzYzcyTxDsE6wX/XHG6MHqAdAiHrhqbmmLQ/TZ1QnQ=;
        b=aWDO66E6A6UMHUk9tEPj5HfjrwCbFklKdsAL0k40wacg5WRRYEyVfT7dhBzX7BL03
          MGUPqPzHdmjuLpYt7erUrGxrCYRrHMQm0Phnz+H9qFgPNissFCv99WpTysTvMO6bM
          1Qz+d21qO7v+yPlAVajDTvcyTWeuJZsa3m+JUxbqg=
Received: from [94.156.6.90] (UnknownHost [94.156.6.90]) by iesco.comsatshosting.com with SMTP;
   Wed, 23 Aug 2023 04:30:59 +0500
Message-ID: <0B.9C.10987.23C45E46@symantec4.comsats.net.pk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re; Interest,
To:     linux-cifs@vger.kernel.org
From:   "Chen Yun" <pso.chairmanbod@iesco.com.pk>
Date:   Tue, 22 Aug 2023 16:31:13 -0700
Reply-To: chnyne@gmail.com
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVyyUKGW9fI52mKwf8znBYv/u9idmD0+LxJ
        LoAxissmJTUnsyy1SN8ugStjyboLLAW7mSva+hexNDA+Zupi5OSQEDCR+PbwN3sXIxeHkMAe
        Jol1sy+AOSwCq5klNp2ZxAbhPGSWmPN1BStEWTOjRM+eNWwg/bwC1hJ9/UfZQWxmAT2JG1On
        QMUFJU7OfMICEdeWWLbwNXMXIweQrSbxtasEJCwsICbxadoysFYRATmJtZtOgpWzCehLrPja
        zAhiswioSly5vhYsLiQgJbHxynq2CYz8s5Bsm4Vk2ywk22YhbFvAyLKKUaK4MjcRGGzJJnrJ
        +bnFiSXFenmpJXoF2ZsYgYF4ukZTbgfj0kuJhxgFOBiVeHh/rnuSIsSaWAbUdYhRgoNZSYRX
        +vvDFCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8tkLPkoUE0hNLUrNTUwtSi2CyTBycUg2MbnXJ
        s1uf8Gdc/PBK/pxgHdOF5eWZ8z/sXh4kwHxyoUqkwXMh4xp/02sd4U9erva7Y5LHsnnGscla
        05cc6ZI1O8NwyGTC+0+2+rZ6OQ6T43juWZ3ottONFD/cELn27LS7j5OkWPP6+Lau4l7+jDMi
        06KBL0xhlmXt1VeGxyy/PamIDHLduMBQiaU4I9FQi7moOBEAbaM3fUACAAA=
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Re; Interest,

I am interested in discussing the Investment proposal as I explained
in my previous mail. May you let me know your interest and the
possibility of a cooperation aimed for mutual interest.

Looking forward to your mail for further discussion.

Regards

------
Chen Yun - Chairman of CREC
China Railway Engineering Corporation - CRECG
China Railway Plaza, No.69 Fuxing Road, Haidian District, Beijing, P.R.
China

