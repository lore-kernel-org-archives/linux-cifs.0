Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59478C7EE29
	for <linux-cifs@archiver.kernel.org>; Thu, 25 May 2023 10:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbjEYK5e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 06:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjEYK5d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 06:57:33 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3070C5
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 03:57:31 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-970056276acso71706966b.2
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 03:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685012250; x=1687604250;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k6Pgg5MYTu3woPKV5DNXP1ipgLfX0qRf9L756ApFYd0=;
        b=kfoObmMZ6EzsuOH7B/fdbjB4O86L71DUQZAiD5s/4uQllBTlqc9EPooLBcUYXkgPSt
         XcTdVs8jJPeh2T85vHarF+AwgIKp6+pbU6j1q1GWMH+GGNUDHWf5hyMaJCz7AJNvtNkP
         d70Ssle1lL1zTAOVAZHtwx19yYfUbKmcVBIKhzlReQawiLQboEl1P2fYJF7QoviEaQwY
         H5RFA1Pmn3hKAIqupSpaW5v7mluWWlZMeuWc1DBDQTqp4g+c3SZEjr3zf2S4WFqbsCoX
         L7A8yrAoeH3oqPR+kUlRZ8APvGQx2fwXRJrYD0Gb2Znr84FZeG6+4NWGY0/lfzbZ0gGv
         ShXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685012250; x=1687604250;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6Pgg5MYTu3woPKV5DNXP1ipgLfX0qRf9L756ApFYd0=;
        b=e00Kdcu3gaYRp1w64GWmwbTO8qFml0O1XP4fVMuiZylmVDVKZ32DPmHEZKKVARhQ0M
         sK5ZCnl8+khNubVrreKeMMEzADdlvhmpRlxFCJdRG4/e+Z8/sMPaE4igSZFEceb1s7Nm
         W9Owg8/pbctBG+rdUPUq5OFph4eIUumTub2MbzAtyFKnJdzC0UIQJgnrxE+v/qDWREfr
         hPQJ6oC+J/csbXyjVrXM1X8QuNSVwNtMuPkqluzJwKGF18ACjXCsjABFkvDxWxqDumpB
         f6GkcCo94DKiOs6tOdc4o3qGDquMEToIZql0qguJcLldu12TihBrcc65sl9454WcfCuh
         CQ4A==
X-Gm-Message-State: AC+VfDwHFGBVvTAwCw7+otnUxcJt5ExU78bVkAVsoAEIwpCc/ZvMpE1G
        jN23pCZxKMkqqd9lf8wRX69guabRC0yk+221864=
X-Google-Smtp-Source: ACHHUZ4hWK7KF+x9ZbDG4tjBWYnpf2EraJ4WkN0KGTXqqMxpzsfg/aylHZUH6TALXInZHIIK4kXF9eT2fcPIFxD7DO0=
X-Received: by 2002:a17:907:2dab:b0:96f:a0ee:114b with SMTP id
 gt43-20020a1709072dab00b0096fa0ee114bmr1145128ejc.21.1685012250235; Thu, 25
 May 2023 03:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop> <CAN05THRnHcZtTMLxUSCYQXULVHiOXVYDU9TRy9K+_wBQQ1CFAw@mail.gmail.com>
 <ZGzo+KVlSTNk/B0r@jeremy-rocky-laptop> <CAN05THQyraiyQ9tV=iAbDiirWzPxqPq9rY4WsrnqavguJCEjgg@mail.gmail.com>
 <ZG0/YyAqqf0NqUuO@jeremy-rocky-laptop>
In-Reply-To: <ZG0/YyAqqf0NqUuO@jeremy-rocky-laptop>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 25 May 2023 20:57:18 +1000
Message-ID: <CAN05THSWHq-3bJ5+tzZ==j9uGFGfbALw0FoLVa9UyucaZ92bGQ@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     Jeremy Allison <jra@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 24 May 2023 at 08:34, Jeremy Allison <jra@samba.org> wrote:
>
> On Wed, May 24, 2023 at 07:44:36AM +1000, ronnie sahlberg wrote:
> >On Wed, 24 May 2023 at 02:25, Jeremy Allison <jra@samba.org> wrote:
> >>
> >> On Tue, May 23, 2023 at 10:59:27AM +1000, ronnie sahlberg wrote:
> >>
> >> >There are really nice use-cases for ADS where one can store additional
> >> >metadata within the "file" itself.
> >>
> >> "Nice" for virus writers, yeah. A complete swamp for everyone
> >> else :-).
> >
> >Viruses? I don't think they use ADS much since most tools under
> >windows understand ADS.
>
> https://insights.sei.cmu.edu/blog/using-alternate-data-streams-in-the-collection-and-exfiltration-of-data/
>
> "Malware that takes advantage of ADSs is not new. MITRE lists over a
> dozen named malware examples that use ADSs to hide artifacts and evade
> detection. Attack tools, such as Astaroth, Bitpaymer, and PowerDuke,
> have been extensively detailed by various parties, providing insight
> into how these threats take advantage of ADS evasion on a host system.
> Authors, such as Berghel and Brajkovska, downplay the risks of ADSs. Our
> opinion, however, is that ADSs introduced the host of concealment and
> obfuscation techniques outlined above, but little has been done to
> mitigate these worries since their publication in 2004."
>
> As I also recall the published US "hacking toolset" also used
> an ADS on the root directory of a share to exfiltrate data
> from the target.
>
> ADS - "Just Say No !"

I think that is a flawed argument.
It only really means that the virus scanners are broken. So we tell
the virus scanner folks to fix their software.
Viruses hide inside all sort of files and metadata.
There are viruses that hide inside JPEG files too and some of them
even gain privilege escalations through carefully corrupted JPEG
files.
We fix the bugs in the parser, we don't "drop support for JPEG files".

ronnie s

>
> :-).
