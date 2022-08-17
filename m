Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC33C3F6B0
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Aug 2022 23:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241796AbiHQXIL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Aug 2022 19:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241809AbiHQXIL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Aug 2022 19:08:11 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A43F1127;
        Wed, 17 Aug 2022 16:08:10 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id b81so19383vkf.1;
        Wed, 17 Aug 2022 16:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=T3E1vP/brbNOmAOltkSBZjprufFb8Jeg8FiR8yaRW1I=;
        b=n+bz2wxiFfB0r0w218AsHZnOYrnbOZrkz598m8wIHlbG0ZlhmABRQxblGPWllYuV/X
         /QvNt4MsHEMHlJ/Z6JnERCwhXDdrTX7+FUCfikuiUNQDKXqVlFhJxOlp2oyol5HPB1Ov
         GmN6tj/lR+ljvqxO8aEGnouvaozuGcE8AYB25V8mMlvarz18OMJ7xl+2gS80p7+W+l7T
         40WlAxGhLo3/7nSEzAZZHmE0ytczo3wWAN5NL/pbiFvv1UzJwwBo5zGfvqg/yEw/bO0y
         ZwUjaQ0vrY+9hmcYJJ/E5PjdP6Vfc7ib68K6IBJcaZZm4QEoHecyNFgv8erTKoc0dr+w
         64lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=T3E1vP/brbNOmAOltkSBZjprufFb8Jeg8FiR8yaRW1I=;
        b=VP5hNdF5Gb8I/bjoZauOKhh/SYlWmgw/h6Ig9135ZDQRbg2RLpH1Lt1Eu66QDmYTlj
         pU+JLBzBFBlTGgvIckZQwYJdAspBkGSx+3twBRGBoz/r3lXy+xR6Gb4Q13k+YkSlsrK8
         7pCvB2xb331hi+QnCInyeQpxOYs4ffvOWmSivRuubw2NLyDsHmve4RtPF6FDO8YUa4cy
         GUuebXGw7Z4cg3VFIRDKn/UDBp73dOhv7hETluetdIqX0SIIZ3awR6HBzsXkIfEGjB9u
         jq8VoHNcjXkJ5SF0oJsyDtnFxD9hK6943X3qYiScpZxVSwjczy84EEgpK0KIUmyRAbXF
         javQ==
X-Gm-Message-State: ACgBeo1mDbvPvhQtqnu0xD4n9UNujUtgN4DztK/6KfhQdIjSZ+wfSN/z
        LIFDtY6gPhDeheI9YiwkGra8NvI56gT5v6kAvUN58ULO0Ko=
X-Google-Smtp-Source: AA6agR4kjvDnA0kfMgKQ9EUeGRgBPaBXO2uYQRntDQgyAcmpvgH+a89WIcbKmbT+WdQJQBow0GtfnwMlw7QsspL3hfc=
X-Received: by 2002:a1f:5c42:0:b0:382:3eac:56f7 with SMTP id
 q63-20020a1f5c42000000b003823eac56f7mr152119vkb.24.1660777689070; Wed, 17 Aug
 2022 16:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220818082146.4ec2738c@canb.auug.org.au>
In-Reply-To: <20220818082146.4ec2738c@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 17 Aug 2022 18:07:58 -0500
Message-ID: <CAH2r5mtbS87dw5+49ksVoCRvH8at0OHLB6_yn1OBCYfQBOdK3A@mail.gmail.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the cifs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fixed

On Wed, Aug 17, 2022 at 5:21 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Commit
>
>   f08791fd0061 ("cifs: remove unused server parameter from calc_smb_size()")
>
> is missing a Signed-off-by from its committer.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
