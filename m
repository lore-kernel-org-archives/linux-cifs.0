Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52DBC0015E
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Jul 2023 18:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjGVSYE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Jul 2023 14:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGVSYD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 Jul 2023 14:24:03 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F54326B7
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jul 2023 11:24:02 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-51ff0e3d8c1so4122706a12.0
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jul 2023 11:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1690050241; x=1690655041;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jLlpX4ximjQ8EiWaYEdqr90sGKj83EdXmDgZ/NkCSBw=;
        b=CH4gI2Dn9VA0UYtGTEIDdEKc/9szPsG5SqZxR+tnlfRASw9ZYFLo/VNbon1ya4NUc/
         4JaavY+6jh2vbmjBP2Jvk9OK660Jyie/4osr8GivHZFE6q52hNnx1JSm59m0UH1V6DNV
         qdXV5FutW8A7J8IKo7IIi9M9y4dQvUfl/qdQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690050241; x=1690655041;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jLlpX4ximjQ8EiWaYEdqr90sGKj83EdXmDgZ/NkCSBw=;
        b=GhApYT56u9pJsWrYUucTjpLnpNEFNcMEWUnEH7pklE4gZ3ZJYAiEIobpJLoi1j18xc
         KC2eTdp5+HN2UUglXKVC559eDyIJKX71xecgwpYAdAevYWQ15ExkXmlgVooJHVAK/jBq
         MR5xulLxXSJVhyQ4NIkxlMGQWa+07AEm7uoH+217KNxiFukr0+7/VkMpejnRsgZLrt5R
         GoOjlRwFbEDMAIgXPO8Ppkd6wfAg+Udzn/S2OF3WoS5CvSBOqC1rNRnUIyBgweob8v21
         +gRGD8bieAeuHOJ1V5aYQqEW1N84pC7JTvia6XYH5O+oXinHfwhpG16x2KjwbAJG7Vn3
         nvFg==
X-Gm-Message-State: ABy/qLbGKjLVgyZxVuzehhHId7NhfpXnFidqdbEfVsO9KWfMH8A2Cihf
        Mnp/SbUgHbuuSGUiSo4heRC4OZkkykcgwgxirmfsIw==
X-Google-Smtp-Source: APBJJlEfNkY1gjsqDOd0AX35POmnUeMiZpL5UWwMwUyp9Cmgu6fpkq/Wa52zExapcuo3mxVQBauBWA==
X-Received: by 2002:aa7:d50f:0:b0:51d:d615:19af with SMTP id y15-20020aa7d50f000000b0051dd61519afmr4762095edq.28.1690050240895;
        Sat, 22 Jul 2023 11:24:00 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id n12-20020aa7c44c000000b0051bed21a635sm3690635edr.74.2023.07.22.11.24.00
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jul 2023 11:24:00 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5221ee899a0so492190a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jul 2023 11:24:00 -0700 (PDT)
X-Received: by 2002:a05:6402:2025:b0:522:206a:d6d2 with SMTP id
 ay5-20020a056402202500b00522206ad6d2mr374604edb.26.1690050240086; Sat, 22 Jul
 2023 11:24:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msCqEDv1mUMMVTg8t7K+CO82Ha_xQoYJ-FkQ9h83By5wA@mail.gmail.com>
In-Reply-To: <CAH2r5msCqEDv1mUMMVTg8t7K+CO82Ha_xQoYJ-FkQ9h83By5wA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 22 Jul 2023 11:23:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=whTnOWaYxG2sU8ikFZsowUPApWgHxf0jM77ELUb39SuAw@mail.gmail.com>
Message-ID: <CAHk-=whTnOWaYxG2sU8ikFZsowUPApWgHxf0jM77ELUb39SuAw@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client minor debugging fix
To:     Steve French <smfrench@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, 22 Jul 2023 at 07:19, Steve French <smfrench@gmail.com> wrote:
>
> add small debugging improvement
> - it is helpful for network debugging of smb3 problems to be able to
> use directory not just file (e.g. access to empty share)
> ----------------------------------------------------------------
> Shyam Prasad N (1):
>       cifs: allow dumping keys for directories too
>
> Steve French (1):
>       cifs: update internal module version number for cifs.ko

Bah. I pulled, and then unpulled, because that module version number
change was obviously garbage.

That versioning has been problematic before too, and honestly seems to
be just completely broken and pointless random numbers that mostly -
but not always - are in sync.

This pull wasn't really a "fix" anyway, but then when I see nonsense
like that I just decide it's entirely bogus.

             Linus
