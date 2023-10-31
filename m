Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1EBC4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Oct 2023 03:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjJaDbk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 23:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjJaDbk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 23:31:40 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21966B3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 20:31:38 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-507b96095abso7483706e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 20:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698723096; x=1699327896; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2QdS7u2TWgcah9K813sHX1aJKtKY38tlLEWWtZYjS5Q=;
        b=DCGjDA9NGJGwvmUyw/v0Ck70sjEaSvxaV+L6IEhMi5bmTabJAPajlQiDGflkdkoOM9
         5fcaDEUiekJYm2LMSgmXMFlhOxVR2dWCZAhF+flxsEkNIDdRmWH00NjYOEdbXGyrLsMz
         nSHyRE6S6Bg0RGjdLwnBLrZUqq0f11Qy+aALgNWpDGu38nY17jcCpBtNedYO5gmlvKh4
         shwNtaJEK8WajekvYB4PKCwEtiHNOgAVsf1ayKG7qf8izclVOszY9gHhIJa6Uyqfhlad
         aJP9bKRAnbt0aZHQFb2NaI0WJk9LSSzgFfFaAuQL3UeE7Zt6dNzzkfaz34W9xiU5Tmwi
         X8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698723096; x=1699327896;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2QdS7u2TWgcah9K813sHX1aJKtKY38tlLEWWtZYjS5Q=;
        b=g/Kz9p6xilnkC5/v4c3bbtOKIe9pP5C1+ZBHvIWcuxtlgKYhiotPeJFSUFHy8J4Rge
         jRhLv8B8UaJP0DGWZJD/E+MOPMJIwjEC66UPprzaUlgJZU0CtTuRQoDIbwW+Bgczb1WE
         FxppRnH+u4SAkaYZ2n6p9bbTcYyeu6BWBMKyjA5Tpxdjj+Zlw3coX4CfjRSgybe2/Tcj
         /3qzEadWMo5k78AZiZW4yjziCS0X+hNH6kDfZyS+6toK0gb92FQV/ti5yOO2SLmyCLMj
         12bohdDoNMnEMIMzN48HqV2gIoCZjg7KkcAkBKIjAFGRabZLxaQw9cXFhzZSLlsvPBrq
         8VoQ==
X-Gm-Message-State: AOJu0YwWQMZjA398D8TQKyI89focKKbb8aJ8LA/i5N47CM/t2I9JpX7b
        BQdxFQI+RUyHTAiyD/7ESYvl2c/ZbA104qSpgSd32ptFb6fV8g==
X-Google-Smtp-Source: AGHT+IGxAWXT9YCOlVvZSXeDrjsrImfw3LFAp5+/imFqqn5Ma6ldzPpvU9eqj0kBdawbI+ExeEXB24CMHDx6U0T51is=
X-Received: by 2002:a19:5204:0:b0:500:780b:5bdc with SMTP id
 m4-20020a195204000000b00500780b5bdcmr7842046lfb.49.1698723095873; Mon, 30 Oct
 2023 20:31:35 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 30 Oct 2023 22:31:24 -0500
Message-ID: <CAH2r5mthWZsX8rwMW-r8CTymWDkGTWeaD8v6n_Wyp1=BPmeqhQ@mail.gmail.com>
Subject: Linux SMB3 client quality improvements
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Have been running a large set of xfstests against various server types
and comparing where we were earlier this year with now - and see big
improvements.

Here are some examples from cifs.ko to Samba server e.g. - comparing
the 6.3 kernel from earlier this year to the current 6.6 kernel.    10
additional tests pass:

No longer skipped: generic/051, 068, 390, 491
No longer failed: generic/049, 069, 434, 474, 505, 524

But ... we do have to check carefully, it looks like we do have two
intermittent failures (mount/umount busy regressions due to deferred
close) that were introduced after 6.3:
New failures: 046, 048

Thank you Paulo, Shyam, Bharath and others for helping work through
some of these.  From my investigations it looks like we should be able
to get 20 to 30 additional test groups (from xfstests, the standard
filesystem functional test suite) passing with a series of minor fixes
and features.

Good progress ...
-- 
Thanks,

Steve
