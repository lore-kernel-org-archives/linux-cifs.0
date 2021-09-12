Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A397C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 12 Sep 2021 17:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 474C360F4A
	for <linux-cifs@archiver.kernel.org>; Sun, 12 Sep 2021 17:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhILRMv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 12 Sep 2021 13:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234437AbhILRMv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 12 Sep 2021 13:12:51 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60EBC061757
        for <linux-cifs@vger.kernel.org>; Sun, 12 Sep 2021 10:11:36 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id i25so11895896lfg.6
        for <linux-cifs@vger.kernel.org>; Sun, 12 Sep 2021 10:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zWdxUP+QTdSO6Q0WwPsIuyGqKmUL6RaLcD4w+eF8cAI=;
        b=FyfhAYhX1BLniqOU1LvoOCt2djW+wKb2RrgB1dCi9pl0dmNTkUZtOBrrXzB/tAlDwJ
         XwfRt14MXkIKMys9rL0udOGC8H9uyA+40Sboha8SSMqoVN0rDsbHIW4DGocvjPr/1ukO
         ivSPkXEuNecxInscs2CvndITV9Z2CzndKRkyw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zWdxUP+QTdSO6Q0WwPsIuyGqKmUL6RaLcD4w+eF8cAI=;
        b=evPrvJvSzqPmdeU/9UYRahfJHBP2Xea57WK0Au3Bt0Z8kl5b5TFtySmqDdJtBrDqQo
         fcBHCtFoR7hymvWsppEoya1TCtZMt9Jyxu+a3fH0DJw5lrAOGkauevdYlyBt08OLTGxm
         yIl+IvhIIjUXi0Z103MnfeJvoNb6aM7hIWCU+fBf3sha6vw2aYWSGv0B6k0culD/mXp6
         2xdn6BjmsCRPPKV6n3XuUVcCWxq/sZ7gDfyf2CuuL9/SvZyHIIu8a+ctpeM9oGpsqAaL
         ROA7TLC1vakBBdErpxR88oGFvw3sVvfcbAz2FpQTqb/8FE1ApSmfuncV5Opk4edzFRpu
         94zQ==
X-Gm-Message-State: AOAM531pkbPQsOFm0nTGaS0oPbapGmzvFkBmLNy3Gop3rqIOi2621Aby
        qCBHBBXiCU+iGbi+0/snw9XmirsHXVKFvFEWq5s=
X-Google-Smtp-Source: ABdhPJwW9kBwhyUF2Ib+MPsFceJ+EDTRiCw2eany9438T3kKB8gpPvT6ll3or9YKPaQtj9cT4LG1tg==
X-Received: by 2002:a19:c38b:: with SMTP id t133mr5935158lff.196.1631466694843;
        Sun, 12 Sep 2021 10:11:34 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id 11sm386678lft.266.2021.09.12.10.11.33
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 10:11:34 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id i25so11895802lfg.6
        for <linux-cifs@vger.kernel.org>; Sun, 12 Sep 2021 10:11:33 -0700 (PDT)
X-Received: by 2002:a05:6512:3d04:: with SMTP id d4mr5879343lfv.474.1631466693700;
 Sun, 12 Sep 2021 10:11:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms8Tbj+Jwo6pgM--fGtOBW3vyaSkU==959G=-HtoT5EzQ@mail.gmail.com>
In-Reply-To: <CAH2r5ms8Tbj+Jwo6pgM--fGtOBW3vyaSkU==959G=-HtoT5EzQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 12 Sep 2021 10:11:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=whB4GpMc90JJ-Bp9iO7-q0Ci3N50EPx4D6etHnZ-eD2yw@mail.gmail.com>
Message-ID: <CAHk-=whB4GpMc90JJ-Bp9iO7-q0Ci3N50EPx4D6etHnZ-eD2yw@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Sep 11, 2021 at 10:24 AM Steve French <smfrench@gmail.com> wrote:
>
>   git://git.samba.org/sfrench/cifs-2.6.git tags/5.15-rc-cifs-part2

Your pull request message was a mess - you'd done some odd
cut-and-paste with the automated output being mixed in six(!) times in
between some of your manual edits.

I tried to make a sensible merge message of it all.

           Linus
