Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2465EC6FD1C
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Mar 2023 03:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjCXDow (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 23:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCXDot (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 23:44:49 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A6A2106
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 20:44:48 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id x17so563246lfu.5
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 20:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679629487;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+fJ4l+mPl/fGT0G7l6Smk2rZ51LpoA+GNKXTOJdBxns=;
        b=HsbaDtIk9ykAXRs4BK1E/7WqN444IZ5Ovze0H6bu/l/HFgEktOJTpH0dweywJuGFdZ
         /VgJ6Z4nMpxajWLzma86CisC3g2RAk+X3w82bcy2/aCcEf8wsprer81ErrjYjR2dcT31
         p+G1MY3QZ43efVwvSxR9voVqr8PSA2p1FWPzJBOS16e+NiuFF8CsECjL92XbzdgCmrmZ
         ihbRUbifGPC3yHpeg9tA0S62ztDbX9TGCPKm5Bo//DU22P3eRb51lf8u+1DkJlud/JQG
         VZICiQ7I63Pw/RTW8txRETvvz6jPKIjnNhJ8XE8FYpgrkD/lQdxWn0DN4ZqSEAhho3Y2
         S9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679629487;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+fJ4l+mPl/fGT0G7l6Smk2rZ51LpoA+GNKXTOJdBxns=;
        b=E7hGHu3nd55bv64PLfAxsXyUj8titIWr5qgitEFLsoRW69VJ5DoTr2Fp91xgdcn7C/
         VMlHQs0JfjR8i6ROkeGPCoJC0HNJv/0m2lxY+BvfwhrbgdA+0aGJUbeKDpv7qMlvBpSd
         I7NRU2I6GfyH8UVk5joUwqNCE/EXJk3dOKpuMHw3VQC29epgY/t1GzRomHWFHYdaatFx
         ZLW00mz8EUCOucVqrB4eUTbowlQi+H/+suWDI/A1LTo/MXCe6Dm0/UsOYaTeCBW0fAez
         9yGQQHG+og1yUseep5J3AxLbKYxPlzCav8OhVQEOBYnme3rb5vQROEr0OAAqBsCkrijB
         uVTA==
X-Gm-Message-State: AAQBX9ec5sXHj+4ZhYkzINrXlsTJfLL9n2JScqtpKnZr8kvMfCynh1lU
        9ivpqYgN0xoFqi80b0SduLDPRGYjTf1uWyIwAak=
X-Google-Smtp-Source: AKy350Z0L57BMUmpfKLQzwzmouKRTX5QzN36nb/9qL7nnb+0dSv9OPc+YPKz642A8fmlDPfustHaWcxJD41FDNsPJCk=
X-Received: by 2002:ac2:5448:0:b0:4ea:fafd:e669 with SMTP id
 d8-20020ac25448000000b004eafafde669mr311916lfn.10.1679629486789; Thu, 23 Mar
 2023 20:44:46 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 23 Mar 2023 22:44:36 -0500
Message-ID: <CAH2r5mvd7tSEX-sh6tLhxS=5FbX6ZOVuwR2FoEbjXnnGksSiXw@mail.gmail.com>
Subject: Additional Functional Tests (xfstests) to run from Linux vs. ksmbd
To:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Was looking at some functional tests runs with current for-next vs.
current ksmbd and noticed a set of more recent tests that I had not
been including in the xfstest runs to ksmbd that I should be (since
they pass)

xfstests generic/604 609 610 615 618 632 634 637 638 639 676 678 and 701

By the way the only suspicious failure I got in this run was an umount
busy error in generic/509 (but it was not reproducible, it passed when
I retried)

Namjae,
Are those tests included in your test runs?

-- 
Thanks,

Steve
