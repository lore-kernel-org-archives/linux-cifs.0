Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49D2C32772
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 19:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiHWTPE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 15:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiHWTOm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 15:14:42 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1064580B4
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 10:52:03 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id n4so17875453wrp.10
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 10:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=L5vDksmX6kl63axC8fTX4W4UjA4ULlvaj4B5Lk9Uogw=;
        b=L+f8XLyA+qC3dl1BiCC63A2xsLWVaxkUCI8S39DAVQxI//2aOX6pcoVv2ZPow3f3tC
         cK4lPzuqIIdDHFHXKyO2KRbploN722Rcfnxi0O2cYIf2lTkK9Fw2w0sZDrK1Ee8IxrD+
         yU8xkJbWfAL0qZkeN4oSBiGVPBJpQQw9qv15o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=L5vDksmX6kl63axC8fTX4W4UjA4ULlvaj4B5Lk9Uogw=;
        b=KkpJHRf9W9MlqxtfQRPmGhaZcBnsC0ZCoFMhhnR2izG/AaNnHo/fkOaXTN/Wi6JFmG
         nyBEXpnG5/0pcd2/FJ/qlr3Re8fKMXH+X3myDDF4MEJTQXfNTTUhflc1+KmLsAs6Sz4Z
         Yaqv9xQhe436dliKTJIJMpS7t6T6TVVij5+dXV4lVpiglsvtMwsimWZ1o+HOQ5C4amC/
         MAhUYjMI3mWHOLpgkPyHoCEs+P/ce1yPEFuo7Xsv9AHSOfvXNfoWCgzXn7xzzqK3njhN
         DwJZIeBq7gkVP9d4dsIEJjQTb7POfk8X8J5NEuphXid9KGy+EX0nNASJ/DicgOxbrT9M
         VaJA==
X-Gm-Message-State: ACgBeo0ejSfPKJ9P0GF/rzWvTkcjOEcsBXKEdmLjxB1w/cWglZkkIHlm
        DWBR0vRL2qhlKU4eMenaX4VQZFque4CBxhTaSGs=
X-Google-Smtp-Source: AA6agR44oF2PuGDXGNf5wrrjb6R3EPnmTP5/lRkN6kfxR0n0+W5xmxA9NCX5qi1I02YRNHNJmKF0qA==
X-Received: by 2002:a17:907:80d:b0:73d:a576:dfbd with SMTP id wv13-20020a170907080d00b0073da576dfbdmr460099ejb.402.1661276276381;
        Tue, 23 Aug 2022 10:37:56 -0700 (PDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id gn36-20020a1709070d2400b00738467f743dsm185509ejc.5.2022.08.23.10.37.55
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 10:37:55 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id l33-20020a05600c1d2100b003a645240a95so5764157wms.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 10:37:55 -0700 (PDT)
X-Received: by 2002:a05:600c:3556:b0:3a6:220e:6242 with SMTP id
 i22-20020a05600c355600b003a6220e6242mr2799346wmq.145.1661276274837; Tue, 23
 Aug 2022 10:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtDFpaAWeGCtrfm_WPM6j-Gkt_O80=nKfp6y39aXaBr6w@mail.gmail.com>
 <CAHk-=wi+xbVq++uqW9YgWpHjyBHNB8a-xad+Xp23-B+eodLCEA@mail.gmail.com> <YwSWLH4Wp6yDMeKf@arm.com>
In-Reply-To: <YwSWLH4Wp6yDMeKf@arm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 23 Aug 2022 10:37:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=whU7QiwWeO81Rf+KGh0rGS9CEfKUXc5eik+Z0GaVJgu4A@mail.gmail.com>
Message-ID: <CAHk-=whU7QiwWeO81Rf+KGh0rGS9CEfKUXc5eik+Z0GaVJgu4A@mail.gmail.com>
Subject: Re: strlcpy() notes (was Re: [GIT PULL] smb3 client fixes)
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Aug 23, 2022 at 1:56 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> With load_unaligned_zeropad(), the arm64 implementation disables tag
> checking temporarily. We could do the same with read_word_at_a_time()
> (there is a kasan_check_read() in this function but it wrongly uses a
> size of 1).

The "size of 1" is not wrong, it's intentional, exactly because people
do things like

    strscpy(dst, "string", sizeof(dst));

which is a bit unfortunate, but very understandable and intended to
work. So that thing may over-read the string by up to a word. And
KASAN ends up being unhappy.

            Linus
