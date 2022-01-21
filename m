Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F9DC433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Jan 2022 21:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiAUV3O (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 Jan 2022 16:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiAUV3N (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 Jan 2022 16:29:13 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46473C06173B
        for <linux-cifs@vger.kernel.org>; Fri, 21 Jan 2022 13:29:13 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id z26so2011711lji.6
        for <linux-cifs@vger.kernel.org>; Fri, 21 Jan 2022 13:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=UXGv2x5YtAHM4AgvmGakTL+11bRnhwTubJMyxdTzw1E=;
        b=mwxYU13F+0sILvkCkM2Cn30yyX5ecy1cATl5jWGY4HrD+5F1d6sjON/ygEyO85hpOW
         5Xpx0J607YEcyo2pMCGlNwAoE5HMZQs3kbaQAh2bnmJhA5B3ZifDtIh6QJ701N7hnP7D
         dY3RJFOl4otnKwJ0HuA6ZMCF4Yh3UlCMJXTcG51w9RmcbsNr/zgvJ8qmxfF7g2XKNsTI
         eVxH52UhLDUqEHug3S9NiCWAN6WhLKkECzBGma0K7DCyeR311T6hhKIPVtKFyadDrgUj
         2UHOjAO7LHH9k98Iirhf1Fha78kApltm1ZLhRrBRaqJUNFyKus/djOKYU+aeQDq3w7xk
         7Uww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=UXGv2x5YtAHM4AgvmGakTL+11bRnhwTubJMyxdTzw1E=;
        b=8RTcRHMb+tHoGHctJOKIcEve3j/v4pSCiYXDgBmESUOUbSnzXDmeHqbO/aTAuQqLKe
         B/x+AkPSLYhliFRrBXmN75nGM2Q6phRxh3kSweyVHwDIq+oFt4JcrxMnLnWE5gEvkpVP
         nBrelhI1/1yP/qht8nif7YiTAfJga7GQZpM7BpShH8B2kQDemJkm96s5Y7sOgsytsGrn
         iT2U25kF3snGUzziBd3W4WU8y75UwwqOEUmFgLRJeNlZFz6SI+XIfzef3UarS9rUEkMH
         EH8Xh1Fln5uwfp2wp47UJlsoern6cXfU1ocn4aagjd6UfoLlslMzu9KBC5G9CwDBHPJx
         2+6Q==
X-Gm-Message-State: AOAM532lcPabbeK/QM6cAtTv9k+4T58j+1DyJ3XYHZttnoXO9VioGvjz
        lQ8xBaMCXzV3jQA344aMze351HTjor4mAjlJdSOu7tkHceo=
X-Google-Smtp-Source: ABdhPJy1YYOkYzAqIyE27qA5BgPRkiVE89Xz/fM1SEHBiM/ejOkrqybfNk24n0Nb74mbMeo1pyeknzmrAVB+F1grefE=
X-Received: by 2002:a05:651c:198a:: with SMTP id bx10mr4521182ljb.500.1642800551262;
 Fri, 21 Jan 2022 13:29:11 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 21 Jan 2022 15:29:00 -0600
Message-ID: <CAH2r5msBe2RPy1vmg9pyqiAe2AH7J1XKfSeXkWZDiSGJG-aDFg@mail.gmail.com>
Subject: ksmbd kernel docs
To:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like various updates needed (added ksmbd server features now
supported) to the kernel doc:
https://www.kernel.org/doc/html/latest//filesystems/cifs/ksmbd.html

-- 
Thanks,

Steve
