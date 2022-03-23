Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225EDC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Mar 2022 20:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbiCWUND (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Mar 2022 16:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344584AbiCWUNC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Mar 2022 16:13:02 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4F07CB1B
        for <linux-cifs@vger.kernel.org>; Wed, 23 Mar 2022 13:11:31 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 17so3448668lji.1
        for <linux-cifs@vger.kernel.org>; Wed, 23 Mar 2022 13:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=LV7k5jLzYPz0AmBk/+8vbqt9HCCPuoNTYqG9VcycOHM=;
        b=I2Ghs26iP3TMqTy8azZKpX4eOwTtjWSrwATSLEVVA+cQ0q3igSeOIWJujxZlOPuP3k
         qVmSJ7qBmXwaU8eRwfCLcHREKRDpuoJWf/nweKbv1xfvyzKUtXck3xy0NmiBtZgbxLSi
         iGZpqXC2ZNVKgwKt1slNBmWGMvaFeLc3GDSMm2Uc18StXx+FizPEKAaRiALilTj55yEj
         XB7Dbu544dMuivRn1a7Tgm1gw7DrDUQw0bdQU3OjSwGvbdAERH2koowkQZlcqZOR26bz
         CoQNaisq4tPUX7XsxO6zWmyhrJc6wOX7l85wd/jLkl0jvej4tXN3AWTSwF8FR6vWub/g
         7LoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=LV7k5jLzYPz0AmBk/+8vbqt9HCCPuoNTYqG9VcycOHM=;
        b=06zzMcdxW/IunR4HCGcCeh5JCQkq7BI+6afyqeeET7qAYSpgRcW48XBhnekoxrdSRs
         tNGDG4H2JduIqW4R3Qpl79XWNZ0pOIgNOLVkBunh3u3bM/ATWJfuRXRpbNKt5L5/POd8
         e8cC9FSMibu1gHC8n6pZjioEMS7Oap8o4tvG3DkEu5UHBRmPvGd+GCy7HgZ2mEujjEYG
         lz3qXFTYv8LAO0ydpBYUx6soicpdwOQTSH62aOnj96HEsm4wayc7llDrSIr7u1gAsTA3
         17E5/Lw/Q3iVr00CtWU8zPgYsXQQuampMZFZqMAameR9GlrajCOc349kqOnI9KKmJuUN
         iVkg==
X-Gm-Message-State: AOAM530ih56F8iDMAAYpTCft5+MmMHhE/7txki5n6jhQ6UAf9yyt/ZFu
        MWTDqt7LHM6n84tsAPti1Bxkii0KhzFK5aamt9M=
X-Google-Smtp-Source: ABdhPJzeg7ov70s0rsVSxw9cVvWG34rbLKSuXtbP8X5+YuaDNIsqhQ1a5cdQrXEQtvmbtQBCjov/WEDkl0/beKl7XXc=
X-Received: by 2002:a2e:9dcf:0:b0:247:f8eb:90d5 with SMTP id
 x15-20020a2e9dcf000000b00247f8eb90d5mr1405545ljj.23.1648066289869; Wed, 23
 Mar 2022 13:11:29 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 23 Mar 2022 15:11:19 -0500
Message-ID: <CAH2r5muPKQhYZC-sz1f4JHrOfzeUHaVR_0kGYBk0qhE_bL8Myg@mail.gmail.com>
Subject: confusing behavior of cached root directory
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I was doing some experiments with Ronnie's patch (to use a cached
handle in query info/query fs info compounding cases, if file is
already open) and it does appear to help a lot, but ... I see some
strange behavior

if I do a mount a share to /mnt directory then
1) stat /mnt
2) stat /mnt/file
the subsequent stat /mnt/file aren't sent on the wire (cached) which is good
if I then to to the server and
3) echo "somedata" >> file
I see a lease break and subsequent stat calls aren't cached until I do
4) stat /mnt
then
5) stat /mnt/file
again

-- 
Thanks,

Steve
