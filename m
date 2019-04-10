Return-Path: <SRS0=49Qs=SM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D35EDC10F0E
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 02:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AE1820857
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 02:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hYxxw4+7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfDJCtZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Apr 2019 22:49:25 -0400
Received: from mail-it1-f169.google.com ([209.85.166.169]:54607 "EHLO
        mail-it1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbfDJCtZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Apr 2019 22:49:25 -0400
Received: by mail-it1-f169.google.com with SMTP id a190so935430ite.4
        for <linux-cifs@vger.kernel.org>; Tue, 09 Apr 2019 19:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=b2hETOUG3l2+0HIwaun6lcMzij0aTlI55puKC0GRz4g=;
        b=hYxxw4+7aNq9mpsB1h78PrtGUrLIScGEnsGqbesvDb0fAo/9VEFr7KAPIAWP8rO32i
         f1x1rSBNjLhP0AN91/700/iX3l/UABYA3/gtNG/JTgEmRBvFlfQf/ln8zi35bZYSnE5L
         JcIUnrJG57yYJ+Ht36BTJQ4cNZZ68n2MQjOhfSsqbIzIOtk2Ukr5cpf6zWtaJ0MLDX1P
         CI2YKAMwtOikP8TQMPg2IeuJsLWE/QMROQ1x9nvmcaGQwhF2uIVjrsOB/B0Cp0tA/+k/
         4R90nTlL02LZVXISCJzsinCbXR4N7viBjtcjNMJvhJookZjVoJ4pqaDXcv8WHqdbg5J4
         joUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=b2hETOUG3l2+0HIwaun6lcMzij0aTlI55puKC0GRz4g=;
        b=RWEI7/9Lq1aYwhh8qChQFEUDRU6aZV9uc4gSM8I/G/QIChiqO5UreVZEnIJLKQIEyA
         ls+pjYZaurM9qDujXxkSLkLowtPheRn8vL6RB6iDjpmNCH9StXI8DjnWxVsJo7RsmaMD
         hJ6dxVlcLknlsaqr0c2AfC5PZXo7nmrBcEuALB/VdRbH6C6ErRyuSlzhXegDI2uj9VsE
         7PHIRhS6TZY0Ug5wurseCGqBlnN4D6B+8y8dVmTOB+xMTLb+DqCdEppSvlu0fN+83h5z
         mp/cli3GfHE1VHDuzCOGL5OnQSt+qrslKfo5f9yi+gCxfb8WiWaHaNXQrR9LstBlBlaJ
         TRug==
X-Gm-Message-State: APjAAAUMxdbXJjmcQQ/GUF6Onj8/xAfSDNsbMbShDs2Kx74c2rX1mEaY
        vSQwL+y1PXgiipSAB/ncWEbYqX/RcosqbcnuIwNOefbD
X-Google-Smtp-Source: APXvYqzea2uaUqs3KNXomPu9aEhcPXQ6gJ1pK7IZt7a72xmOWH2Bc1+iPxA9Xwwf7W9TJmD1zEPsVYdYrzw0Z5TSOXs=
X-Received: by 2002:a24:2cca:: with SMTP id i193mr1631691iti.2.1554864563769;
 Tue, 09 Apr 2019 19:49:23 -0700 (PDT)
MIME-Version: 1.0
From:   Andy Beal <andybeal623@gmail.com>
Date:   Tue, 9 Apr 2019 19:49:12 -0700
Message-ID: <CAGCB87tK0qBHSZsGyEAAhNq_6C4Dv+ivqphn3-DgRHm8Yp9ERQ@mail.gmail.com>
Subject: Kerberos ticket expiration on CIFS client
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi there,

I recently deployed an SMB share for my team and am trying to access
it from Linux clients joined to the same AD (using cifs-utils). When
mapping the file share, I first run "kinit <user@domain>" to receive a
Kerberos certificate on my client, and then map the share using
"sec=krb5" in the mount command.

This all works flawlessly, but 10 hours later (the lifetime of the
Kerberos ticket) the mapped share stops working. Note that I don't see
the same behavior when mounting the same share from a Windows client
(e.g., there's no need to re-login after 10 hours).

Is there anything that needs to be set up in the Linux CIFS clients to
prevent the tickets from expiring, or to cause them to periodically
renew themselves (similar to what Windows clients might be doing to
work around this issue)?

Thanks!

Andy
