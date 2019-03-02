Return-Path: <SRS0=lkMc=RF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D9DC43381
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 12:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ED3D20838
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 12:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NeUwJxNn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfCBMTk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Mar 2019 07:19:40 -0500
Received: from mail-pf1-f171.google.com ([209.85.210.171]:38178 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfCBMTk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Mar 2019 07:19:40 -0500
Received: by mail-pf1-f171.google.com with SMTP id n125so251773pfn.5
        for <linux-cifs@vger.kernel.org>; Sat, 02 Mar 2019 04:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=NS+4X6aAa3UYf0VTSFcrSjCIzDsF6OoVmWocCpu7ELk=;
        b=NeUwJxNnaz2jhG/igQbndgYYe2be2coJSaNr1TN6z8RgGohm3TPA1N7u9RJQrM296z
         DrtmPJ8kCjo+XiP9EYrn795QZz2O91PBm1TisYA1RGYNQXk+BHWC0ve9ftUMMbjb4wsv
         AM7yLIovExzpZdk7soLGdJgn0gUf7GzjiuF3lmR072PzRiL+J0g8YZCWCyeB5aezN6Pf
         YEz2BDXEuHKsudN6RcGAITfpEOb2WEbU1pk+I7xcdMGE+c375N9SPVq9WhVNdTisXn2T
         eybHfEuHZwcM0vlu56x9osUZlrJ2z4K0vAKvCMLpEBh7efjeibOVtN0pOACkOiBCqIEM
         xPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NS+4X6aAa3UYf0VTSFcrSjCIzDsF6OoVmWocCpu7ELk=;
        b=bYYBYgZUTqGnKrKRCBdavKGU/eYnGqucmkq3Qv+dWCbNLZu2hYOnZmE+evourMr0JZ
         sMvQEsTzhoqDsbuCvDirSZNMZMISVEPAv3iP/ocn9bEdfcNKLlepZnZzvWtkYDK+siVn
         O9N64xu0QASbe7PzEa2LJ0Snw7P+NKp6rFIPIe3M8ZLxS4viXU69M9MuOnNXzABepriH
         ujJpePJJTndY8uX4rQZAP7jnmaJRaUGRiX1fAa9FKxS53Mro+4l3eixPlsKmiJ5zW4Cx
         2aJdntsJD07Vca2On1EQxqY+aYV9xd8NuCHG/gy1zf9oTPRHSYfGjhB3iMM1ltr5z7qC
         FjJg==
X-Gm-Message-State: APjAAAWHyvbCgdSM95s8FxWG2Div1nSwSXk9F9SUmCVuX34WzQ4jJfxI
        NAC5FlyIyQdxE+oE7j3UVV6EBqbF6PahcerVp41lZGpC
X-Google-Smtp-Source: APXvYqyCVdHQuTwmYujYhQwIcE4peTBafLjSR0A/zoHE/VdKVjJ59R4d75iiWm4cpjfOg9dWlEH/ixddnQTxzBaj8kc=
X-Received: by 2002:a63:2c8a:: with SMTP id s132mr9697019pgs.440.1551529179483;
 Sat, 02 Mar 2019 04:19:39 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 2 Mar 2019 06:19:28 -0600
Message-ID: <CAH2r5mvcY15tefzySSqCfEET94Y2c6hVnr5hqCfHPNgvUBj6qA@mail.gmail.com>
Subject: buildbot - added five more tests
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I added five tests to the buildbot cifs-testing group (see
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/143)

023
125
208 (now that Long Li's fix is in - and it passes)
310
378

On buildbot cifs-testing runs 141 and 142 I had experimented
with including tests 037, 074, 129 and 133 which failed (most due to
timeouts) - I thought these had passed to my samba localhost test
environment but if anyone has any data on those four tests and if they
are showing any bugs that would be helpful to know.

-- 
Thanks,

Steve
