Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD83C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 22:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiERWeO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 18:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiERWeO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 18:34:14 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC6B1FD876
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 15:34:12 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2ff155c239bso40052207b3.2
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 15:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=orxNez30F2jaeLqvbvKkHevfQB/EKgR6OpxR5yp1oxk=;
        b=pFuPQoQETV2evgVmo+5zL6gScv4ivuPyYLEUtaIaZyT6hXxNtCLt9bzqVp+cIv2vFG
         I826pku27U190BQxmyf/uO9cm/mCZLhzA0Za/I5muJcWjGXsMe9XWs28l3zvLMLdbgcX
         wWFkFjPDeUhOZGQO8pO2/jITRzLuEVJaRU1OGYHQIXjOF2pHPf29zU3Cbbu32RnNuLMr
         d16YfiqNyPosV9jbvRNp9G8KjGyaVpgnm/f/Ytz2ZjOhpAnr1UZUuFX2J1iyk6xAcnBA
         U0orN3okcV0QOeGk2+0d3DsZODtxsApsJaOf1WGnT1L7Y7ayRfcKjRKCqmf+gwQ5gp3o
         DUbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=orxNez30F2jaeLqvbvKkHevfQB/EKgR6OpxR5yp1oxk=;
        b=MewKZgs8c0gqSdmlz9aCaQ0U77dXSwnnN2Je2+Cp33Mg8b4mBxSCkBAMILkX7odrs2
         mAoFNpynnR4KLM6crbcxQPxhZxD1bLqWoDE9WcjkjuKBeRF6O4J2KpDKbpTRzbTYxvZB
         qGdEjYc6kBg9nbi9/0wN7tIHfJayLl3OF9Xz8wo7vwYfqg86QShOGFhongyxK2+Fsxj7
         HTu5gOZpxAoJfbHv3bh8JztLYv1hNwymyby9GI0PBNDG0cMwdyPCo89P7NVmE7TyJSEf
         q3soRAZDbUOSPN2I7MtF5zw+2FGFGadIv4lOjwaRCed/xoAlGj5aiiSFRfESBZ7GPjKB
         GI8Q==
X-Gm-Message-State: AOAM530wXcBAv3fe+1CSyI5UDXz+oHk84U5n20+XPWhY2t+QMEVgOLxe
        jpji45pJGvqoks8aVMRff7JWZCC7YVM0s9l3hGE=
X-Google-Smtp-Source: ABdhPJwePfRVN+7imkXBEc4LXjkRadIs4vEMmb7E6t+/VYwO4DHJN9A7gAloVQVygZ1JBUienTKY7ff8oSuTtB6l2e0=
X-Received: by 2002:a0d:dbd1:0:b0:2fe:cac6:30c5 with SMTP id
 d200-20020a0ddbd1000000b002fecac630c5mr1669182ywe.419.1652913251411; Wed, 18
 May 2022 15:34:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu1cWEuHAJiY4T6zNKgWNwaoVevpnT7hrHwbbPa=AQiDw@mail.gmail.com>
In-Reply-To: <CAH2r5mu1cWEuHAJiY4T6zNKgWNwaoVevpnT7hrHwbbPa=AQiDw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 19 May 2022 08:34:00 +1000
Message-ID: <CAN05THSYmBiKnwYyLVV0hQukRvBZUfwjxBWWUC2bWNteVhiy0w@mail.gmail.com>
Subject: Re: non-cifs change post 5.18-rc4 causing buildbot regressions
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 17 May 2022 at 14:17, Steve French <smfrench@gmail.com> wrote:
>
> Noticed various xfstests failing (see e.g.
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/11/builds/220)
> in 5.18-rc7 but not in 5.18-rc4.   Anyone else noticing this?  No
> cifs.ko changes during this time period so could be unrelated to
> cifs.ko (e.g. mm or VFS change)

I haven't noticed this.
Have you tried bisecting it?
If it is outside of the cifs module then it means a full kernel
recompile every time and that will be painful.

Maybe we should have a separate buildbot machine that we set up and
use only for bisecting.
We could set it up very similar to the current buildbot but then have
it semi-automatically try to bisect a kernel to find the
offending patch.


>
> --
> Thanks,
>
> Steve
