Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735A8C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 04:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B9BC60F24
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 04:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhI1EVB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 00:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhI1EVA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Sep 2021 00:21:00 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B524C061575;
        Mon, 27 Sep 2021 21:19:21 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id s18so14342489ybc.0;
        Mon, 27 Sep 2021 21:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=cTx3fpQiL2dVtZ9Kn53fvZNvPqKfwkkFPrZ5oYqTISk=;
        b=HKdqE5pTn27yVrUWdtqGvHAld2cMSGD/XTZ3Wfo1askMLJOjMyrFWsKk69zxro4eR8
         Zx5UgGcU8XY04pbGELHlwhKjJHCXLf/d30zvaTXvS7YDYhukZNeC2ampZDlwP07LY/+W
         cI6A6KhX1ay+xJ/sO+kPYaSpUycsWmIKJMTGb9jsvWHWJChhZ2DAyyndD48/WOumwSm5
         qZp/dEFNsmEAYEDLAPDz+71crn8os/u45wd/b4ySW1YQlRbidqZu1y8AVGZZY3iZItaE
         YWrynC8Kq0Se0mhoqYMJUotRrtUFVDPerQYTSWLOauBO0U44YBl3vjDQu1VI/0Rhjg8P
         soJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cTx3fpQiL2dVtZ9Kn53fvZNvPqKfwkkFPrZ5oYqTISk=;
        b=MIrgBLD1CIaGe2oPduZY6Lw2Olq+OeBjnl4hfD2QO6CcUdP9e5GZWRUSAx+SCVHVFG
         TcdCm13b20yrvR2qnUKB5sOnZpapy0FSHJ4KuYPeOgwwDych9s7uq9KEO3E3hx7NouOp
         ux7gGbMJuBTXXNeiMkqdwI1GWJr4eR40e6/XfuhFIMkOZkpas4Ao7gFIwaSs5V1CQheM
         OUDHRePOLuPt2ILgqIFRAuVNO8IoFoBusSLcjIE47n3Kt6Kxw7cUemQeOXk/GxvXFvxa
         Bh082wefXeiUYuuAY6yA5+qVm9HaoQxN+719NBzycY4+9NGmcKgGbAxviY1SP2M4FEeg
         FfRg==
X-Gm-Message-State: AOAM53071g6NQTvh4lD3M8W7KXbRxFeyh4mYIQVcRJ+NztPT6Uk8Pb9o
        0lA2I1T6cAEobN+JYOmu3V8E0JMAA3fD1uBKAH3M67xQ5cg=
X-Google-Smtp-Source: ABdhPJwh4Yq0LNEVrejcfInY0odQBcD9yrp7v+F3DI+Ce1c5cFwPZno/3sDrB3sDj85UWjgyE9yyDchnqNAvoVeoxUM=
X-Received: by 2002:a25:d157:: with SMTP id i84mr3995507ybg.434.1632802760850;
 Mon, 27 Sep 2021 21:19:20 -0700 (PDT)
MIME-Version: 1.0
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Tue, 28 Sep 2021 06:19:17 +0200
Message-ID: <CAKXUXMyhrjf0=0jaYG89zHULKGA-z+tgUZr=tQmBWZZUCCDuwQ@mail.gmail.com>
Subject: No fs/cifs_common directory in kernel tree
To:     Steve French <sfrench@samba.org>,
        Steve French <stfrench@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dear Steve, dear Namjae,

I am tracking consistency of the MAINTAINERS file and noticed:

Commit 332c404a55ef ("cifs: add cifs_common directory to MAINTAINERS
file") and commit e9e3d5f9e34c ("MAINTAINERS: ksmbd: add cifs_common
directory to ksmbd entry") add the file entry fs/cifs_common/ to the
sections COMMON INTERNET FILE SYSTEM CLIENT (CIFS) and KERNEL SMB3
SERVER (KSMBD).

However, as of now, there is no fs/cifs_common/ directory in the
mainline tree or in the latest linux-next tree.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains:

  warning: no file matches    F:    fs/cifs_common/

Are there more commits to come that will add or move files to
fs/cifs_common/, or did you decide against introducing fs/cifs_common/
in the course of the development and these commits are left-over from
a previous development?

Best regards,

Lukas
