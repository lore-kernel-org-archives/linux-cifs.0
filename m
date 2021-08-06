Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FD1C4338F
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Aug 2021 09:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5EDB60F70
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Aug 2021 09:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243821AbhHFJCd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243794AbhHFJCc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 6 Aug 2021 05:02:32 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDBCC061798
        for <linux-cifs@vger.kernel.org>; Fri,  6 Aug 2021 02:02:17 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id w197so7837315qkb.1
        for <linux-cifs@vger.kernel.org>; Fri, 06 Aug 2021 02:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1C0iG6Y+nOvPjgHA8aPk6CUfFIlG+2N+yIX3Y56SpWQ=;
        b=qH6qd8biCA3Tf6EePTKNhFRy++FDXeoBKPNEbi5N0eGJ81FBzlRHSKdb77fEE9BFh/
         XuyZCJNMcWZ2mGkKitvNjKRRooRtP5GEphQLKVnC5GJah+AysZwX6dKNoHlKGrw/WwI+
         2PUWv0EkX/GG0pabJNscFVOS+vmZR4UmB6xRcd1BYl7vPyxJRzK96gUCyZfrAcL84q7q
         XQWJhDE+LhrcF+bWbS+1n2vvZFx5kpuLr/qqZpC1Sn8NdU4618mQ1qnKon53uSzgGVZC
         I1RQxyHG1PlOvCQ3CjhGgbdlE6za03ICWshHvS7T7YHl0WiBo0yv2sBPvzJLRritqHtH
         0S7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1C0iG6Y+nOvPjgHA8aPk6CUfFIlG+2N+yIX3Y56SpWQ=;
        b=Refc1WGEog8xcqNTqGf3okxATAyQ9NeVIyHpGAYdgFRUKWqHxZTobK2Y0cu39n8CpH
         vXODcqnlgicH8mv2QVOlpYsA3BSJVW5Ci0rmcNPt3EBtPlGTC13pRMdlDDvunrtQfNFk
         sTcafWvj7llksEcOoO2acDfuGQ8ZDbz4+ZXGnJTClaXTrI315qzly1ejVj33odJT64pc
         9ibBGoOZp3FFGWH+u2minA0C6G1eDUmZLsVCgVjmlNxeMW0jJDhLttC66qA6N2Y93Hc0
         U8qDpSNJeRuTVJkOfS+BqouOEm6UGR5jbLv4phGDD8Zh9idMoIHx8KwSLf8n386GpN2h
         NCGg==
X-Gm-Message-State: AOAM532ULn3VpFFrvSvd+TIc6wOdy1rjcxnr1TPK2xK0p6bSlATWfCY3
        BXtG+7US57aSiadLeGgqOk1m/EXHHosBc6NJX6WJhSOVzA==
X-Google-Smtp-Source: ABdhPJxswE+Kj+NQfCswf3xR3kPIzmHkzysEgqDodpTYr6woVu/JUzF5gGH3I1X3aC9ykHoxVWdphPN/QDNIia4qMg8=
X-Received: by 2002:a05:620a:35c:: with SMTP id t28mr8821454qkm.51.1628240536633;
 Fri, 06 Aug 2021 02:02:16 -0700 (PDT)
MIME-Version: 1.0
References: <a01d5d22-5990-c00d-bc2a-582d2585ea69@alexanderkoch.net>
 <87h7k0zz6r.fsf@suse.com> <956dd84c4e27fd02541ca4fabb7b1776@alexanderkoch.net>
 <2f863f5d2c22907a88a4bfc04ab5f1b4@alexanderkoch.net>
In-Reply-To: <2f863f5d2c22907a88a4bfc04ab5f1b4@alexanderkoch.net>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 6 Aug 2021 02:02:05 -0700
Message-ID: <CAKywueTKFEjML1M4W9jGuo9=qNANwTv=9gY9KOv0Sv3xBnW2Og@mail.gmail.com>
Subject: Re: cifs.upcall broken with cifs-utils 6.13
To:     Alexander Koch <mail@alexanderkoch.net>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 6 =D0=B0=D0=B2=D0=B3. 2021 =D0=B3. =D0=B2 01:04, Alexander Ko=
ch <mail@alexanderkoch.net>:
>
> Hi Aur=C3=A9lien,
>
> >> It's unfortunately a regression in the CVE fix. We are trying to come
> >> up
> >> with a proper fix.
>
> Any news about the proper fix for this regression?
>
> I've seen there is no new release but maybe the is a patch that I could
> propose for the maintainer of the 'cifs-utils' package in Arch in order
> to
> work around this issue.
>
> As of right now, the only working option is to keep the package
> downgraded
> to 6.12.
>

Hi Alexander,

There is a patch that fixes the problem that will be included into the
next release:

https://github.com/piastry/cifs-utils/commit/7f9711dd902a239c499682015d708f=
73ec884af2

--
Best regards,
Pavel Shilovsky
