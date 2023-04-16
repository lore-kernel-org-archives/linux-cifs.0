Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE77FC77B73
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Apr 2023 16:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjDPQlJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 16 Apr 2023 12:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDPQlI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 16 Apr 2023 12:41:08 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC8F1BFD
        for <linux-cifs@vger.kernel.org>; Sun, 16 Apr 2023 09:41:07 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id q23so48723805ejz.3
        for <linux-cifs@vger.kernel.org>; Sun, 16 Apr 2023 09:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1681663265; x=1684255265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BvrMWAPGZgK8IdojxnEJ5nIRXF/wPv/EkMFoXNSkKBo=;
        b=JzyDJMNzP4XyTwkPzZtnjrLr67SEChxerO6ryb2YA5X6E3Fuz1617r3RxLpkMj/z5t
         0TDNGlM+WTs8b+/F6k6T8Nsd2nkn7jD7dhhZi70gsqPyO6sMQeREn8SE+OuWh/T4A7o2
         VzXtOMnxC1y/0sb7MwZju43bLdKfCeyLdCaq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681663265; x=1684255265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BvrMWAPGZgK8IdojxnEJ5nIRXF/wPv/EkMFoXNSkKBo=;
        b=YKSAjynh60bTXMkkWsVKOTHYtkQ9aajf/smJrgDV0yV3QjP/ClqUMD/8ABUGJ/11mg
         NyMlPz7p5MObXoObfiM3UA8banwbXg5pMrTcL6rioN6tcIrfYd8sotwfzrkdXqIcRgUK
         +D7yDO37ABiVRB0DzMsSoowaQhNAisSKsobohFcadjIGFIx9XSFGNWcdHVQtqfLnTQf7
         GEKT0oXtVeSg6fii6hA6/XscqYobWvaxpLs5qZC0MC3IYUd7P7IW0YWJ05IIARsinmWS
         tCWJ19RP4yTuQqR82TtcICT1O5pG7b0XE9QMdrSeiDDm6pKqKXaXu0+4Llf1O17UGeJD
         R+aQ==
X-Gm-Message-State: AAQBX9fqTtxISdz/gD7Myg2GwmwYHgDHFLmpwMqpGV+hU+ZjNiRQgaSb
        yPCV+JnCbjNDsyMxvsnQJexLsZZinqaQgkfUbB83gw==
X-Google-Smtp-Source: AKy350bji3tf+1lxrfyl+GcFazU+4FAfli27B8JWlKN8B+54ww9SA3PreuLuslN2inHCsTGkutjkEw==
X-Received: by 2002:a17:906:28d0:b0:94f:27a1:f1d with SMTP id p16-20020a17090628d000b0094f27a10f1dmr4286074ejd.77.1681663265647;
        Sun, 16 Apr 2023 09:41:05 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id me15-20020a170906aecf00b0094f4e914f67sm1129019ejb.66.2023.04.16.09.41.05
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Apr 2023 09:41:05 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id dm2so58299931ejc.8
        for <linux-cifs@vger.kernel.org>; Sun, 16 Apr 2023 09:41:05 -0700 (PDT)
X-Received: by 2002:a17:906:7d8e:b0:94e:fe66:ce64 with SMTP id
 v14-20020a1709067d8e00b0094efe66ce64mr2328355ejo.15.1681663264757; Sun, 16
 Apr 2023 09:41:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mumQ=wg8H4d+vYGZZGPz1cbK5+LOeCoBxo+VbYta05QBA@mail.gmail.com>
 <CAH2r5msYsy-pERjcdy9WiA6tir+94Kn_HTWHwQvWsa=Jd9qx2g@mail.gmail.com>
In-Reply-To: <CAH2r5msYsy-pERjcdy9WiA6tir+94Kn_HTWHwQvWsa=Jd9qx2g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 16 Apr 2023 09:40:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi8r5s6Qdb=uMBo+4g5CyMqLR-=qK6yC3cuKbdWmJ4v7w@mail.gmail.com>
Message-ID: <CAHk-=wi8r5s6Qdb=uMBo+4g5CyMqLR-=qK6yC3cuKbdWmJ4v7w@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server fix
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Apr 15, 2023 at 9:16=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> I cut and pasted the P/R text twice by accident (if you need me to
> resend it let me know).

Heh. Not a problem. I don't have any automation for my pull emails, so
it's all human (apart from searching emails for "git" and "pull").

So as long as the information matches, and the jumbling isn't _too_
confusing, it's all good..

                    Linus
