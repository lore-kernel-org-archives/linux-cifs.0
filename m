Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746C6C7EE23
	for <linux-cifs@archiver.kernel.org>; Sun, 21 May 2023 19:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjEUTVl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 21 May 2023 15:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjEUTVl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 21 May 2023 15:21:41 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183E4CF
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 12:21:40 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-510b4e488e4so9616216a12.3
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 12:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1684696898; x=1687288898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HXhFRUhp8ATNRE1IY8Xb1FY1Xv4mWGcfTkE+W6AJow=;
        b=PAm1kCzX2Y7OPOmT60te/tIf6F6s8zGjojbIvuwMyxeQ8rxZdAkxC5rU7iSH/xiFbx
         u/O2VypCPAnFqLVAu81U3SvZICDXoX3/d+n6t0v10NtIrOzdnvSYbFQjfJchUwsUwkvq
         XyEs57loEM7JOyL0tBZrygh5oEicB0SzRbtBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684696898; x=1687288898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4HXhFRUhp8ATNRE1IY8Xb1FY1Xv4mWGcfTkE+W6AJow=;
        b=XnPvZNEDR9lo1PURRGw/yyFz3ZNl0ud/f8Lf8eZJoxTSYAgF/1PFAl4lcVrIvfMdn8
         qrYpRJKnafkYW3PSdd7XKhSlIsMmpvQfnyOLGWqyMN9054l/8V4GQcA+cju/FeskDFuB
         9g9tzLpoO58ZJxXgHlqViAT1iXCpZ+7oHEg5gCi1343k6dMPCSVh2yIg4EIl+paOQQi6
         IFfX/FEcHfv6PHe1Z63GToe4yMGEA6WSKnMiTKTdiwV0D/qr1f2ygJqjtR8xYAdiybkA
         aK8xgh84Jcz0QDAjnXMa6QN6P/Odonr8tNH9OUVDgbzilvq1xaDlFtJtPsRBA1fhgwIL
         OW9Q==
X-Gm-Message-State: AC+VfDzr5b8CICFZHXbeNd6EFWyPGqyKnyN1EyjePLZE3ksNMp13PsRl
        ergD49JxyBbeTOey6GdIH1AIKXVqkh98xPxkdtbfHg==
X-Google-Smtp-Source: ACHHUZ6So+lfVV5KFE74LYxFXwgydBgeJ+/x0GhapeyYLezsc9OfY/id5qH2gQH590DhB4hWpy+PGw==
X-Received: by 2002:a17:907:75e6:b0:965:d17b:292 with SMTP id jz6-20020a17090775e600b00965d17b0292mr8203944ejc.60.1684696898264;
        Sun, 21 May 2023 12:21:38 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id z25-20020a1709064e1900b0096f6e836fa0sm2183160eju.27.2023.05.21.12.21.37
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 May 2023 12:21:37 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-510dabb3989so8569077a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 12:21:37 -0700 (PDT)
X-Received: by 2002:a05:6402:6d8:b0:50b:fb60:f431 with SMTP id
 n24-20020a05640206d800b0050bfb60f431mr6096635edy.7.1684696897335; Sun, 21 May
 2023 12:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msxkE5cPJ-nQCAibJ+x+hO7uSLpasGm81i6DknQ8M5zWg@mail.gmail.com>
 <CAHk-=wiStOAKntvgzZ79aA=Xc0Zz7byoBxBW_As5cmn5cgkuoQ@mail.gmail.com> <CAH2r5muxwEMA9JpE6ijSbZEByxRmtNSiwcXMbOz+Ojo8_APJUQ@mail.gmail.com>
In-Reply-To: <CAH2r5muxwEMA9JpE6ijSbZEByxRmtNSiwcXMbOz+Ojo8_APJUQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 21 May 2023 12:21:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjeuUNo6o6k4y3nQD2mmT5T04ack7i_UOAetmga-4_SbQ@mail.gmail.com>
Message-ID: <CAHk-=wjeuUNo6o6k4y3nQD2mmT5T04ack7i_UOAetmga-4_SbQ@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server fixes
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, May 21, 2023 at 12:03=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> I would be happy to do the move (to fs/smb) of the directories and
> update the config soon (seems reasonably low risk) - let me know if you
> want me to send it this week or wait till 6.5-rc

So I think the "do it now or wait until the 6.5 merge window" is
entirely up to you.

We've often intentionally done big renames during the "quiet time"
after the merge window is oven, just because doing them during the
merge window can be somewhat painful with unnecessary conflicts.

I would *not* want to do it during the last week of the release, just
in case there are small details that need to be fixed up, but doing it
now during the rc3/rc4 kind of timeframe is not only fairly quiet, but
also gives us time to find any surprises.

So in that sense, doing it now is likely one of the better times, and
a pure rename should not be risky from a code standpoint.

At the same time, doing it during the merge window isn't *wrong*
either.  Despite the somewhat painful merge with folio changes, I
don't think fs/cifs/ or fs/ksmbd/ normally have a lot of conflicts,
and git does handle rename conflicts fairly well unless there's just
lots of complexity.

So it's really fine either way. The normal kind of "big changes"
should obviously always be merge window things, but pure renames
really are different and are often done outside of the merge window
(the same way I intentionally did the MAINTAINERS re-ordering just
*after* the merge window)

But we don't do renames often enough to have any kind of strict rules
about things like this.

So I think "whenever is most convenient for you" is the thing to aim
for here. This is *not* a "only during merge window" kind of thing.

                 Linus
