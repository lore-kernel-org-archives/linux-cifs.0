Return-Path: <SRS0=8LXX=Y5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7720DCA9EC7
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 08:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 362E820818
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 08:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y3uZ5GYs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387627AbfKEISC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Nov 2019 03:18:02 -0500
Received: from mail-io1-f46.google.com ([209.85.166.46]:33733 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387590AbfKEISB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Nov 2019 03:18:01 -0500
Received: by mail-io1-f46.google.com with SMTP id j13so5213121ioe.0
        for <linux-cifs@vger.kernel.org>; Tue, 05 Nov 2019 00:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=m8poMZ+JJ13XmziNYeEWRUKv+0wSc+/e+AzUMeB54wM=;
        b=Y3uZ5GYsxQCGGqtOifOtYx7ZYZkHofog1PdNg98SJ2C7mU6Ja1H9+sJrhEW/BKzKwK
         +SFcntgOfxsNvKZiljs6n1zV/m0RD81aLAZJsIzgQgcoKq8EMeSkupX9CizCPizXw28o
         oIUCnmpVffbHDJJ7A6sM6lQ0w8zL2736D7Sizuk7Uk9+IBdOJEU5OO5nYvgyZ1TJ+xHB
         TljHIw4XNVG28RJ3KQXgX25KFQrnAqjclbXKkdeKK7hwx/jvB1+zL0Qj2Lh2tWFayTCV
         40TEM3jjFLUI2jSaIalChbJuKHm7de+/isCYrOsOrmixpUGrT1xFdZljplOgc/D+HnE4
         2gEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=m8poMZ+JJ13XmziNYeEWRUKv+0wSc+/e+AzUMeB54wM=;
        b=M1Bah5K31XlUDagUgSFJWiBRrFvC2OEDeYpfTuVVp+woo/F2R1ZHXxYB13UEoUHf/o
         YoMe4cIF6sQj0c3xI/5OBmhgeBKKAYIfIiS+Bexu6P2r08V8sx/tuDHVYQeDQwb+Om+2
         TZ8ZZf5dOn2F4CeX45ecQMmM32pMlivp7zV9G0zRmAaP/4Eh54WbQG4fQU35UaTcSmux
         QVVyngW0w3DVvsOLplkMpPbKKnO5Z3204ryclG8Tx8W3n7daYr2TcCjUiSkO9Gm+InSQ
         m5aHfUPLOML4b1gR4Wle30foCV9d+0LXSbzGlLj1xq+6XGBHd3VHdJWagKZH1InrdqE3
         5Blw==
X-Gm-Message-State: APjAAAWJO0fP7VoWKEu/dKfplFLBSgO5xKVlx+ncfEcVtcd/zqgefa4N
        dUx50tD19hcF0ehfzZI4VkaQ+TUR6bGP3Afe8EI=
X-Google-Smtp-Source: APXvYqxGMBQklGuUuge6l7YzOeUq2CV9k5fDSKNahm/xHefy+zb5UmqpPXootyrO70ISoZk7TmHWojTDP0Gxzg7Cg9E=
X-Received: by 2002:a5d:9f02:: with SMTP id q2mr14748048iot.3.1572941880765;
 Tue, 05 Nov 2019 00:18:00 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Nov 2019 02:17:50 -0600
Message-ID: <CAH2r5muy7TezWnfq-yfpDg5uDaEV9beKtpXRdwBjtphMGgg3BQ@mail.gmail.com>
Subject: checking encrypted messages in smb2_check_message
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I don't hit this statement in smb2_check_message in smb2misc.c is it dead code?

        if (shdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {



-- 
Thanks,

Steve
