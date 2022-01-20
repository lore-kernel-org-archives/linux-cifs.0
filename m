Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A299C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jan 2022 09:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiATJit (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Jan 2022 04:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239800AbiATJij (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Jan 2022 04:38:39 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EABC061574
        for <linux-cifs@vger.kernel.org>; Thu, 20 Jan 2022 01:38:39 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id b14so19384030lff.3
        for <linux-cifs@vger.kernel.org>; Thu, 20 Jan 2022 01:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1oi7dnPWui9j/+jfFhXtfalwSWwfnL2+HSbsutApadI=;
        b=HbAegqtQNWgcz+td/MyfrH87a4+U1kdadgAIfqZCkN7kZtr3xtkmVZSYev132PB2lv
         F9JhmYXbOmyUu7udCIPtbc5qDt0YmIGJ5Cn1DDC0vbxx7iY08T7k10d5XHoLECUX6ks0
         aOWDJleGZpgOCpRwm0o6S06MFIN2RTkCA3a53/apLXn/E+E2+3gwHIHvFOPxGPbvxJQk
         QiPnr23wbJaeJ/EXU+3ddS9AtRRW+7uiEoe3jK1muw9XwZS0M/OGu7AmSLbiyG2NtqI8
         0s4H3JlqFBQn+4ogg1UulxbfkYr19nC2bEZ8Cj4EkLrAHZDBDUoyFtLFTY2gq88EuXrn
         aDEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1oi7dnPWui9j/+jfFhXtfalwSWwfnL2+HSbsutApadI=;
        b=bjdw+sbaCAEPK7SGonqlJoEaATvpOz5tWT564f65dhfbWbymBP9Ysy8SEijxON5Ky0
         i/4cWRUIzSC+9SYq9/JdXaYOC8CHZVXQlpnDvO54DdUPEoMJDpI98nmnzC6NXi2si6jj
         pIkb5Gb2DhlsOW1ekzgdzL+Ud6VoZOtvP3Ajt37KTyks/BpZsDYpetTWK8dlPmEiz3aA
         lRdaCS1UF+mrAgcKZZGxAvCmJB+RpCY1smAD7J9ScqsyxMhajuYzvxXMRbEDvNGKWzqQ
         PBxiBbzR7ZN2poQxjiSzhY5UD9JPksGw10swGSB67WUtEMlzWfqoF6vb50kuI3enNsSI
         iyzw==
X-Gm-Message-State: AOAM530FVLyLKXnZgbrFkvk2VDM1HaiKkx3J7msgHPK6mWlWO55+qMVZ
        1UEP3nqw6lQtiR5h04S0gAh/DEir9bsD9ZfctJQ=
X-Google-Smtp-Source: ABdhPJx7RWuSkQer3fXEzuGR7eKZ4fTbCvkKkHKj7dgXsUzRdZzFGzoNlBwQ82vu1b3h2KoZzah9CU5BeU1TcozOg14=
X-Received: by 2002:a05:6512:11d0:: with SMTP id h16mr30704159lfr.307.1642671517214;
 Thu, 20 Jan 2022 01:38:37 -0800 (PST)
MIME-Version: 1.0
References: <20220118074512.2153136-1-lsahlber@redhat.com>
In-Reply-To: <20220118074512.2153136-1-lsahlber@redhat.com>
From:   =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Date:   Thu, 20 Jan 2022 10:38:26 +0100
Message-ID: <CA+5B0FPc3O7shzFgnVoWc9X2QktW0X2K-znU04L6P7Hpby8L5Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: serialize all mount attempts
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jan 19, 2022 at 9:49 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 2008434
>
> If we try to perform multiple concurrent mounts ot the same server we might
> end up in a situation where:
> Thread #1                          Thread #2
>     creates TCP connection
>     Issues NegotiateProtocol
>     ...                            Pick the TCP connection for Thread #1
>                                    Issue a new NegotiateProtocol

checking server->tcpStatus state should prevent this situation no?

> which then leads to the the server kills off the session.
> There are also other a similar race where several threads ending up
> withe their own unique tcp connection that all go to the same server structure ....
>
> The most straightforward way to fix these races with concurrent mounts are to serialize
> them. I.e. only allow one mount to be in progress at a time.
