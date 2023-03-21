Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BEAC6FD20
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Mar 2023 19:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjCUTWU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Mar 2023 15:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbjCUTWS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Mar 2023 15:22:18 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EA12C66D
        for <linux-cifs@vger.kernel.org>; Tue, 21 Mar 2023 12:22:14 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id cy23so63821848edb.12
        for <linux-cifs@vger.kernel.org>; Tue, 21 Mar 2023 12:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1679426532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHtgR0XvPydSJ2xRHzSM20hkxNSVo2TSBRlBp9YTFyU=;
        b=KmDXelWzwks1nQPoqr13pMfnkAeJPlI5I87zd6sk3jWexgoUltTzps7nAnLUWDBxrt
         RcJTL9schkxn8BPHGqO+k2sSwBNFSyewigW2qtZ2GTbMK34tDm7z9BbVnBckaR8Sk0xQ
         7DS3Ne4gSlU+Nye5NqrnhBdAHKIwj3vmt4JOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679426532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AHtgR0XvPydSJ2xRHzSM20hkxNSVo2TSBRlBp9YTFyU=;
        b=FkML0aajP3JN6WHpfQ9rJEZ0qFklovpuQnxcwZsjc6UW8QSFU7sFphprC4uIaqUjVG
         pnwfPFLaPvsBzXBXSKnaON3lWKvOzMmNKiTwWnas36RiXRO+Eie+QmCvJ8HsqNeJmKfq
         2BJExFfZXBErX4IDOxWDc35gWskOYzoEcpByRrrO1bsz+MZHwzs43KCHLifScJe60LmJ
         WerwuQXhzhEAQ0J/02KduEBNzJwJd1mkVkQo7w8DTOqnvLxCUq3S03abyvphDdpNTuzd
         50DxDy/LeF8b5xf/9JLpIy46vhvaTOTUlQuaiKVv4dyp00papFadzxmr1tY2j47V7IwC
         GdYw==
X-Gm-Message-State: AO0yUKWIT+y80WmkAbpUKLtcUbxrjSmesryGXgnhspyW2TJWllk5Jski
        4xQ8Jm6eWixZbrdHHLM48o6fqSWeYpgdlyTss393pGKl
X-Google-Smtp-Source: AK7set9O7MPqk8L08X43PRDSsTKGvW9/bmVgIqbFUjtR4y9PRP3yrAiYgemZI3yT+PfNmiXIiidheQ==
X-Received: by 2002:a17:906:a457:b0:922:c4f8:806c with SMTP id cb23-20020a170906a45700b00922c4f8806cmr4265751ejb.60.1679426532650;
        Tue, 21 Mar 2023 12:22:12 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id m27-20020a170906259b00b0093a3a663ebdsm1003883ejb.154.2023.03.21.12.22.11
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 12:22:11 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id o12so63904480edb.9
        for <linux-cifs@vger.kernel.org>; Tue, 21 Mar 2023 12:22:11 -0700 (PDT)
X-Received: by 2002:a50:9e6f:0:b0:4fb:482b:f93d with SMTP id
 z102-20020a509e6f000000b004fb482bf93dmr2321260ede.2.1679426530851; Tue, 21
 Mar 2023 12:22:10 -0700 (PDT)
MIME-Version: 1.0
References: <2851036.1679417029@warthog.procyon.org.uk> <CAHk-=wh1b0r+5SnwWedx=J4aZhRif1HLN_moxEG9Jzy23S6QUA@mail.gmail.com>
 <8d532de2-bf3a-dee4-1cad-e11714e914d0@kernel.dk>
In-Reply-To: <8d532de2-bf3a-dee4-1cad-e11714e914d0@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 21 Mar 2023 12:21:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi2yeuwCxvB18=AWG+YKnMgd28WGkHFMqTyMA=59cw3rg@mail.gmail.com>
Message-ID: <CAHk-=wi2yeuwCxvB18=AWG+YKnMgd28WGkHFMqTyMA=59cw3rg@mail.gmail.com>
Subject: Re: [GIT PULL] keys: Miscellaneous fixes/changes
To:     Jens Axboe <axboe@kernel.dk>
Cc:     David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Bharath SM <bharathsm@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Robbie Harwood <rharwood@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-crypto@vger.kernel.org, kexec@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Mar 21, 2023 at 12:16=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> I haven't seen the patch yet as it hasn't been pushed,

Well, it went out a couple of minutes before your email, so it's out now.

> It may make sense to add some debug check for
> PF_KTHREAD having TIF_NOTIFY_RESUME set, or task_work pending for that
> matter, as that is generally not workable without doing something to
> handle it explicitly.

Yeah, I guess we could have some generic check for that. I'm not sure
where it would be. Scheduler?

               Linus
