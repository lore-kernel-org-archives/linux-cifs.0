Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E6BC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jul 2022 18:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiGNSed (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Jul 2022 14:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240711AbiGNSeb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Jul 2022 14:34:31 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28E454CB3
        for <linux-cifs@vger.kernel.org>; Thu, 14 Jul 2022 11:34:16 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id mf4so4961456ejc.3
        for <linux-cifs@vger.kernel.org>; Thu, 14 Jul 2022 11:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IqYZBmeUsaJiDrPDnwdrO1TyojMly/IYpZnkKBrChTo=;
        b=Uk8r1h0dDI69+5IH2XRon08rvJXZZD5N4ch9x6PYg/hcWZYK9kXPWJWyrBJI98tCEV
         Rv7nARX9+m9pytkl+411YJMzGJh+QTuXwd3vmuecTfAUch0NUrZEtCux4joYjVnIf14C
         RkrUv7VWkmEXYhQG9OUGIO2d7Wsw0Cb8Deb0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IqYZBmeUsaJiDrPDnwdrO1TyojMly/IYpZnkKBrChTo=;
        b=wzYdqFDBkKZJ5RQPNNYXon1sXIDdzOxCv0rdBTYC/zs6aeGoVGt2ZX2f8+BPLn7ITn
         HmztksgNPRJCbC88QP3GRsPMvJxp/T7OqhfLYhndXGI4tkgfBJGTMFg+icYl2r11tnkk
         G7dlGyrIt2F7lVF0yqIqXqDmbvqTr4wB+Kod7BmQ4y0BvSFTcZ8yVbQcHb7frB6LW4Q+
         cmALdgoFZBF/FKIHzDfz4yHoC/r7e3QWY55a4CYlDIU00YQKPPlmcRSlZRE+yaqjzPOW
         nFHfrSitm1ru9LLkgJeO6ely4I9hWRrQVynxuNRm6YdCF85cC0LJwPzaa9N9+HnE9J/1
         R+Og==
X-Gm-Message-State: AJIora8CTQvTatyGbmT2uRWlJYcDcO7Y5dHXfCUS+hxQXpEZnNaO7cmc
        tm4WkgMAnSx9Mwa6n3LGmLIbqfxzdpP5id1Z17A=
X-Google-Smtp-Source: AGRyM1uIK1BCuEcgvgaD05PqGaw4FEe3312wNCUJB8ZvPnQJ9jiqDOYkesqsXrDrX6CWinj0WsZQJQ==
X-Received: by 2002:a17:906:d54b:b0:72e:ece1:2956 with SMTP id cr11-20020a170906d54b00b0072eece12956mr810760ejc.156.1657823654975;
        Thu, 14 Jul 2022 11:34:14 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id d17-20020aa7d691000000b0043577da51f1sm1463930edr.81.2022.07.14.11.34.14
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 11:34:14 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so1716459wmb.3
        for <linux-cifs@vger.kernel.org>; Thu, 14 Jul 2022 11:34:14 -0700 (PDT)
X-Received: by 2002:a05:600c:2d07:b0:3a3:585:5d96 with SMTP id
 x7-20020a05600c2d0700b003a305855d96mr2740169wmf.38.1657823653896; Thu, 14 Jul
 2022 11:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtQwDNtprMOXog3Az8av3hjdFWOCVfk8xmaP4vKJO0tdg@mail.gmail.com>
In-Reply-To: <CAH2r5mtQwDNtprMOXog3Az8av3hjdFWOCVfk8xmaP4vKJO0tdg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 Jul 2022 11:33:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjOMyh4mWTAp-o_402EHLsJ4MMY4d7ja+Ec0x0=B=UKAw@mail.gmail.com>
Message-ID: <CAHk-=wjOMyh4mWTAp-o_402EHLsJ4MMY4d7ja+Ec0x0=B=UKAw@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 13, 2022 at 8:36 PM Steve French <smfrench@gmail.com> wrote:
>
> Three smb3 client fixes:

You don't even point to a git tree..

Please use the whole "git request-pull" thing, and include everything.

              Linus
