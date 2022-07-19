Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBF6C43334
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Jul 2022 04:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbiGSEDt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Jul 2022 00:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiGSEDs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Jul 2022 00:03:48 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B39E2F028
        for <linux-cifs@vger.kernel.org>; Mon, 18 Jul 2022 21:03:47 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id n3so6308059uak.13
        for <linux-cifs@vger.kernel.org>; Mon, 18 Jul 2022 21:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=cjMoIqHDxFN1qKUowl/83nrzSi/ZR7l2NMedkDr+Xw0=;
        b=lXtlVNHkrp43gnOKmxhF+KmFyD4O+CCOf5C1q/+5kMiIg7LuS3Mxxf5eKNBtHDPSD+
         foge/5N8jqueC7RMuyJkLUjuJ9VNoerh1T9nPWocKh981u3ONNP2Z/Com84ftKypTNmM
         wL5TtOMxrhRzuC0djcr8CY1ENQaXn5fofruOI7F1vMvqvIW2ArJPdD/dFkWAUzQ0p3Oq
         p4DaEdJsAhVKs7H/wD2Sv1UASXDX2sHiD+hqueVgrHFelTeqdmiVU9EZnbb8ayJYMI06
         c9Pa6uKBxlXsC5diSBZsXC96xyNHGyXJn6aqdRnXhyuwKUaFnWLm7ZDkDLtq4boE7iHq
         kToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cjMoIqHDxFN1qKUowl/83nrzSi/ZR7l2NMedkDr+Xw0=;
        b=YSr0a3CYB7PcfhuLCuj1bJfgW5xN/KFBSGpaHLWC3nJoUHRH9BM6QlKMNns1l2BgF/
         MlpfZlZagrrF+1t0ryd9uuMB6/jg/RyXGhy3/x7FP339eUX1r5FIHQaLJ+NINpVn8JGm
         AQXlE+wL/wjiIu4DIsS1CM07zQ1KoGXpM5T+SoOdw4TmUnGobBUFUz5J+ZkKY/QuveAI
         CvpDYlndCKFcgU+mEPJyshsem6KMtOzs39HOgLKs99jKzKGgTaGZsXjulECjuiHsE7N8
         1EJ/ujgb0Es8xFbB/sHZPAeDUIxb0btZvy4UoRztoBJGynuWGo7Xj6HU9BSOZKfxNPQc
         w7oQ==
X-Gm-Message-State: AJIora/NwqMOiXZizO+LQqyV5QirhAYNdbkE4Ru0r9A4OEfCtg2eTd9j
        Gh44OfVdxfH9HtryuHQgY9NbcsqKxCPziFwQs54O7TO1OkKQ1w==
X-Google-Smtp-Source: AGRyM1tAGUJ8NNdu7SV48XqXPepSDend/xIe2NSvs7XGL6mgpiWQB3r0SLlCquubE1mozTkq+FPjiN7tXsR0zgOc/qE=
X-Received: by 2002:ab0:35d9:0:b0:379:1b79:cf48 with SMTP id
 x25-20020ab035d9000000b003791b79cf48mr10872117uat.4.1658203426226; Mon, 18
 Jul 2022 21:03:46 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 18 Jul 2022 23:03:35 -0500
Message-ID: <CAH2r5mvuaWJp1=UT=TYmMSPgGZ6M-UsDtMVWT7PhXBwnHzdnbA@mail.gmail.com>
Subject: 5.13 backport of all current cifs/smb3 client fixes/features
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I recently updated the "full cifs backport" from current cifs
(5.18-rc7) to 5.13.  It includes 268 of the 295 cifs/smb3 changesets
since 5.13.

See

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/5.13-backport

It passes the buildbot:

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/11/builds/267
and
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/3
and even passed the larger cifs-testing group (it did have one
expected) failure in test generic/373 due to the VFS behavior change
in clone_range).   I did sometimes see intermittent failures in
git/0000 when rerunning the tests although not sure if that is a
concern yet.

Feedback welcome.   Let me know if any problems found with testing or
if any updates needed.
-- 
Thanks,

Steve
