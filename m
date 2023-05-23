Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632F4C77B75
	for <linux-cifs@archiver.kernel.org>; Tue, 23 May 2023 17:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbjEWRfn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 13:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237842AbjEWRfk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 13:35:40 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD63B5
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 10:35:12 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-50bcb00a4c2so185056a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 10:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1684863306; x=1687455306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WgE8ji/h7CMcJNn0UAt7kbxemzWw21WFjqqu1Nqn77o=;
        b=Vw7AS+AaFz/dbCV0lwHrLUjLV6JjQuZhqzF9BMNaNNjX6Zcflxx+AjQe3+paqQJtxR
         U0AHB5n4d398LhALQubCoAudNTHGd4tDGZ+hWZwuf+vVHZt2kdApH85vUqGhasNFnydw
         U4kljGqf63frbBV5XP9K6nh7prfXd7VOJBaNw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684863306; x=1687455306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WgE8ji/h7CMcJNn0UAt7kbxemzWw21WFjqqu1Nqn77o=;
        b=Nc1vRQikcwA1u5Ts8Z5PkJtg7iaMzGH4yL/7yKXHMbeFw/LinZNjLKLE5i3qrswgNp
         Ikn7woKfM5xbk1hMTEVYjQy8fJGqck8Hdnsjgo2n8QN/yW/kKGIr4TrHGNYHaQvg50bh
         kPy5hPSrsO+nQ6h0IXxOeygyGR5UJ+pNDzmdFPuRkd4KsWKXpNqbdpeyJeaWF5vcmTP4
         +WZkJI5+1rK3wDtlRYUxaSgZkgX7dQNzfvzEUCaac6BtWCXQ6ePpAKqftuNGxzfHPkT7
         7twr0EXEB19h0cbZePLn8HVizCYfvA1Osd1F+2AGFrI8UiqJpANdufOTE3DlsmAzbkbd
         2j5w==
X-Gm-Message-State: AC+VfDw9t4Zi7vp/umdtbTfKMtqJyDbrdZ3NNInwa1JNby4l/6DdXUtt
        wTxek+pYoWcZvYjBSxbbCxFE22KkseluSmfbERALmHog
X-Google-Smtp-Source: ACHHUZ4EMzly7f0o02qEg9ArAtn669I9ub6oaR99jJvXNnIW3uMka9mzDskInpvh9dE0ZjDgdGqHFA==
X-Received: by 2002:aa7:d1c9:0:b0:50d:9b59:4327 with SMTP id g9-20020aa7d1c9000000b0050d9b594327mr11651617edp.29.1684863305864;
        Tue, 23 May 2023 10:35:05 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id q8-20020a50aa88000000b0050673b13b58sm4461173edc.56.2023.05.23.10.35.05
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 10:35:05 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-969f90d71d4so1162498466b.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 10:35:05 -0700 (PDT)
X-Received: by 2002:a17:907:9443:b0:94f:3b07:a708 with SMTP id
 dl3-20020a170907944300b0094f3b07a708mr15767293ejc.29.1684863304990; Tue, 23
 May 2023 10:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msVBGuRbv2tEuZWLR6_pSNNaoeihx=CjvgZ7NxwCNqZvA@mail.gmail.com>
 <CAHk-=wjuNDG-nu6eAv1vwPuZp=6FtRpK_izmH7aBkc4Cic-uGQ@mail.gmail.com> <CAH2r5msZ_8q1b4FHKGZVm_gbiMWuYyaF=_Mz1-gsfJPS0ryRsg@mail.gmail.com>
In-Reply-To: <CAH2r5msZ_8q1b4FHKGZVm_gbiMWuYyaF=_Mz1-gsfJPS0ryRsg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 23 May 2023 10:34:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjYTAK4PSK23bDm_urZ49Q=5m=ScYcmK27ZJNKSBPdbgA@mail.gmail.com>
Message-ID: <CAHk-=wjYTAK4PSK23bDm_urZ49Q=5m=ScYcmK27ZJNKSBPdbgA@mail.gmail.com>
Subject: Re: patches to move ksmbd and cifs under new subdirectory
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, May 22, 2023 at 11:39=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> My reason for adding CONFIG_SMB_CLIENT, enabling CONFIG_SMB_CLIENT
> when CONFIG_CIFS was enabled, I was trying to make the Makefile more clea=
r
> (without changing any behavior):

That sounds ok, but I think it should be done separately from the
move. Keep the move as a pure move/rename, not "new things".

Also, when you actually do this cleanup, I think you really should just do

  config SMB
        tristate

  config SMB_CLIENT
        tristate

to declare them, but *not* have that

        default y if CIFS=3Dy || SMB_SERVER=3Dy
        default m if CIFS=3Dm || SMB_SERVER=3Dm

kind of noise anywhere. Not for SMBFS, not for SMB_CLIENT.

Just do

        select SMBFS
        select SMB_CLIENT

in the current CIFS Kconfig entry. And then SMB_SERVER can likewise do

        select SMBFS

and I think it will all automatically do what those much more complex
"default" expressions currently do.

But again - I think this kind of "clean things up" should be entirely
separate from the pure code movement. Don't do new functionality when
moving things, just do the minimal required infrastructure changes to
make things work with the movement.

              Linus
