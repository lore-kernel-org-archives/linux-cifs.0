Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894D3C04A68
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jul 2022 15:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiG0P3Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jul 2022 11:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiG0P3X (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jul 2022 11:29:23 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF2643E46
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jul 2022 08:29:22 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id l68so10883609vsc.0
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jul 2022 08:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ekHqvilrTP5PQmZRDToYGA+BSbG8c/T6P6jqSobp0c=;
        b=FVfdyPncBY9+LsjFFDpj/FZjyCmkz6DO7agqHXRmPuITO2noPqgyt4M+aeuIgWc4m6
         83n90gvweWg38IZg8CT5FEktuIDo4NXGrfbvk0AQdv+OkBob7FSJijjWeONIuysDQXy9
         +/6AYinjK3T+UZpRM0nou6oPlbAVz8aPfZ4i0G6esiLCAj7SizCdEs91Vt9LGml/PMzE
         MpEx1Ct1JO/oNp2d8mtupUJ4jry1TSOQnFMyH8mHsNfyR+IUR/fI6L9vSdy/fxNnEotI
         SoKAONCbMdLphCduBK9s124u5q8Bx9JNPQsZuGzMas/zGTsJNwrxjhj13uWxSsrmk97o
         h9SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ekHqvilrTP5PQmZRDToYGA+BSbG8c/T6P6jqSobp0c=;
        b=485HSEK1TaJnjK1hxkzFcI4cCWxjoen4cTY3+1jPPrCe38IHmuoU8/owCzChSX1tnx
         7MYQlHe3VdDz07/QOPNzmBDaI8V0bNTFcCv3WBbbvALEi8zlUR2fy+IjztyKe2jKIIad
         sLuztQZ/JrwmNANhkK10nETH9HcdiW0umW7yXoxrpsXerN5gMPsvOzcjygrxhuIGpjHA
         9LxYiR6LISvy4JTq2d7s2ud9lId+8MQalOiP1N5/R8QSDxRJQY+BrQ441k2jTFHMPIw4
         baqHGBMSkoo6K1zgfVjUIQvUU7uICXLLnXQPT0AkRaX56mxT35JeljZGaalyP83vMrBr
         JUCg==
X-Gm-Message-State: AJIora/aAu0RLWMJFaD3fJ3xQwiXaYE0v3FxoxiwzGpdOL5uOukpUIkM
        OZQBCKtPcUCF0dvmhBLTY+P+xh7LfbJCw0dT1HM=
X-Google-Smtp-Source: AGRyM1tjVyuv92SfLrZJcwuakj7xg8Ac33fGSRZoK77lgeaZI4ALO05e9PdYbkvrfcF6nccDUBY43VQfAe5fM67hSm0=
X-Received: by 2002:a67:ca87:0:b0:358:5a89:b2c0 with SMTP id
 a7-20020a67ca87000000b003585a89b2c0mr5110346vsl.60.1658935761181; Wed, 27 Jul
 2022 08:29:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220725223707.14477-1-ematsumiya@suse.de> <20220725223707.14477-6-ematsumiya@suse.de>
 <CAH2r5mvTHwz2cxbcHFoFm8B6Q-H+V-iVesU05jiL78kT42pRRw@mail.gmail.com> <20220727151706.wxqowyibon5h3huz@cyberdelia>
In-Reply-To: <20220727151706.wxqowyibon5h3huz@cyberdelia>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 27 Jul 2022 10:29:10 -0500
Message-ID: <CAH2r5msf=Tm9MEmxqvOsWxv=VJP_uKQAtKhnphymhKiBOi6azQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 05/10] cifs: convert server info vars to snake_case
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 27, 2022 at 10:17 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 07/27, Steve French wrote:
> >I doubt that renaming tcpStatus to "status" helps much.  If it has to
> >do with the socket, included tcp or socket or connection in the name
> >seems plausible/helpful.  I don't mind removing the came cause (e.g.
> >"tcp_status" or something similar) but prefer other types of cleanup
> >to be the focus (moving smb1 code out of mixed smb1/smb2/smb3 c files
> >into smb1 specific ones that are compiled out when legacy is disabled
> >etc.
>
> Steve, the way I see it is, if we have a struct names "server_info" or
> similar, there's no need to include a prefix in its fields' names,
> especially when there's only one "status" variable for that struct
> (which should always be the case), e.g. "server->server_status" looks
> ugly and one might assume that "server" holds another different status,

That point makes sense - but these kind of renames are lower priority
than getting the features/bugfixes cleaned up for the merge window.

Lots of interesting things to work on relating to multichannel,
leases, compression support, signing negotation (helps perf),
fixing the swapfile feature, sparse file improvements,
more testing of posix extensions etc.
