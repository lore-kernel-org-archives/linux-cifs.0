Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA5FC07E97
	for <linux-cifs@archiver.kernel.org>; Sat,  3 Jul 2021 21:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABEB7613E2
	for <linux-cifs@archiver.kernel.org>; Sat,  3 Jul 2021 21:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhGCV0E (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 3 Jul 2021 17:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhGCV0D (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 3 Jul 2021 17:26:03 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540E2C061762
        for <linux-cifs@vger.kernel.org>; Sat,  3 Jul 2021 14:23:29 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bq39so12418312lfb.12
        for <linux-cifs@vger.kernel.org>; Sat, 03 Jul 2021 14:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=8zXyhtu1MRHAtvuWNqDWvsWPZ9SX3B77AwD8QzMwIGU=;
        b=hMHTc+YT/yYPUX072pJ0dcCYSNP5vpt7SmQcf1S07T1ukwvxbbnBbGPy4fSQP6FaWv
         3YYtj1f9E0R0bS2kmqqYRY/JZCdBsge2BSubGL1QYO0Wd9piuwo8VzWdLdVMCbE9vwoz
         3MpT7oj7wKUVaYZpPm/R6KI66OSS2QUvKdbSArbA+SIr1o4AZKWKv9Jedt6RSHIJk8mZ
         f2jMcwBmZSJuYZo5DXjkCJE1iBhmQaVo0AM4EcqQqwK6Tfkm7xvgluPyWpBoYK7im8OX
         0hUVs+EOkm8UwOsdfH0VHczCSV9MJEAQ+Ks5BEcnsym0WsRMLqAHKqjNc/RhU3jCj6lf
         1saQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=8zXyhtu1MRHAtvuWNqDWvsWPZ9SX3B77AwD8QzMwIGU=;
        b=bigT9S7i0xoZZMu1CRfbXpE2u+Uhj7oU76jqQUqolnyt3GbRBfRtLlSsIy9LdulpPK
         P4wV8RhTD0wtJo5WpLy7gVtdOdQz9u/9s6thQKs1Juw026SxnPWuRrOROyVx7OtyXujd
         3PU99IuT/oUevFp/s+oQYnH8gar5QSyKd+uPz4g4zJzGNRnNoT9qcpXSQDBLFAjyL4A3
         Db9aHfh0YHOzT9dtH+Sh7090x/M87q9jf6MDo9CtYeht+/Ny9K6/tO1sMfCjJM+UrvZW
         9M1JiNHmavweP1z2MjTWOu+kN8zSINfH0h2VsRGKx8xx35A6CDKRVkvks8FebmgOlR95
         kkRw==
X-Gm-Message-State: AOAM533zsZ/NCRA/ts/POkMv8/PAJgAGj3e+aZGRvomck0ywk/Z5pAwV
        n74h3EGKeOwRZOxesfWZjTaclIpi7eJzMc5B0Z1Ni/dDpeg=
X-Google-Smtp-Source: ABdhPJyzwJN7gfymV+T9cPWE1cNgt+305YPSZnckuyFqdYKMLWxZuUDEnPRyLY5ES86L+uYqkjpMMO1IFVLF9C24+04=
X-Received: by 2002:a05:6512:3049:: with SMTP id b9mr4549210lfb.395.1625347407331;
 Sat, 03 Jul 2021 14:23:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu4qE+BPdLkVz=JvUPrbU2D7cUS15S_PBEgbr17VxgaYA@mail.gmail.com>
In-Reply-To: <CAH2r5mu4qE+BPdLkVz=JvUPrbU2D7cUS15S_PBEgbr17VxgaYA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 3 Jul 2021 16:23:15 -0500
Message-ID: <CAH2r5msWpB+uzaUH+jdOT7q4c18EbY5DhK_8rpeu9otm3_KECg@mail.gmail.com>
Subject: Fwd: Test results on latest ksmbd
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Sat, Jul 3, 2021 at 7:25 AM
Subject: Test results on latest ksmbd
To: COMMON INTERNET FILE SYSTEM SERVER <linux-cifsd-devel@lists.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel
<linux-fsdevel@vger.kernel.org>


I ran the buildbot (SMB3 regression tests from Linux) against the
kernel server with the recent updates from Namjae et al.  All tests
continue to pass.  Good news.  ksmbd seems to be making good progress.

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/49

FYI - An earlier run hit an intermittent problem in mainline (5.14-rc)
in the scheduler (not a problem with the server, the client side was
running on very current mainline which appears to have this
intermittent problem which I have also seen running unrelated tests):
       [ 4826.261325] RIP: 0010:cfs_rq_is_decayed.part.93+0x13/0x18



--
Thanks,

Steve


-- 
Thanks,

Steve
