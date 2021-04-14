Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ABCAC433B4
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Apr 2021 18:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF22600D1
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Apr 2021 18:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353172AbhDNS4N (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Apr 2021 14:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353150AbhDNS4M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Apr 2021 14:56:12 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB39DC061574
        for <linux-cifs@vger.kernel.org>; Wed, 14 Apr 2021 11:55:50 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id sd23so24348995ejb.12
        for <linux-cifs@vger.kernel.org>; Wed, 14 Apr 2021 11:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pxX7KtlcHmV0ZjNIxm7fQ5KaHyPVWNywXkXy0NuIT94=;
        b=lUFafNfLrIzEYN6x3kAH3OBdew5IApF9korICBPwz+TowghxZE1veNmnYcwZjq9RDN
         6MgXyhWkxV/Ed3hTK1Aln/d0ZurhmA6XR9LZ5xCChqzzHiHtMiN2wPv3O1cjFGNFyJK+
         9cIaBtmfMWM6JxekamW9bX8EO+QiV73Adh7kf8rCM+O25Z1OvwhtzB5HPdQ3vJqkzALv
         K8EjeDqukZpZV89hcko2QWJGS4EaZQfwa7XD9GB2rQCoA//XuOOuN6stPNILPHmDi+Zr
         R4f6TnA+KfTwNfH0TS8JMoMgmROvYhOp4ooUSsC3T/YHeKIMqIfNq+wI0yoCzNGJ7816
         Z5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pxX7KtlcHmV0ZjNIxm7fQ5KaHyPVWNywXkXy0NuIT94=;
        b=Bomt/rCilAROSW8oDwg8JL0BUwXLMZDa6nSAy1hYYbP0lSBfYvwdVkL7/g1ALLOw63
         /+y5AcDZSjVJYUUNtvSqF+i12S21ho7vPdOacD8QUNORFSdJJP5Qf3FO3hPh5FbmMSqN
         1hvMIfxE4qQRj5GRt3M/sCJ8ZQlXIwy8b3Abl/h5uH5kVzClIDMudgMZ/VwJC27GtDPV
         4utdZx2U7KZvOVqXdCBy3QQGWGa5zwPQOXr5TcLur6sORM5YFHJJHxJoRAFkLs29sFnJ
         I3n2RVsx+np12G0Xbe/USSGEipZcf/noCk1zfg/OhM02tMzw5MqRGyUbOQHVN6u8Jcs/
         mqTA==
X-Gm-Message-State: AOAM532t1oDU5T2mv++v2rNnUF10/BmA3RjMh7pElo2XAnaR9Jm8j0FP
        bDTkfvYQEB3ImuHqvOESMSZm7BXrQTGWImeO+A==
X-Google-Smtp-Source: ABdhPJwGl52TAxI1HesRKQ92OrWWL96Ab3UwUBv1R29fRf+ifkM99lF2b4aysySZJK8u137bxkPak6lkZKFG7yYGTBA=
X-Received: by 2002:a17:907:94c3:: with SMTP id dn3mr327865ejc.280.1618426549684;
 Wed, 14 Apr 2021 11:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAMM8u5miX1JbzWMG3WLZLZeD1_ZL=6nufWJaT7ensA+yPo5zeQ@mail.gmail.com>
 <87r1jj364f.fsf@suse.com>
In-Reply-To: <87r1jj364f.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 14 Apr 2021 11:55:38 -0700
Message-ID: <CAKywueR6QF-TrTDMwcGz9cp5+6HgrjvZQhZp8T13C64m23ZxVw@mail.gmail.com>
Subject: Re: [PATCH] smbinfo: Add command for displaying alternate data streams
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     =?UTF-8?B?Si4gUGFibG8gR29uesOhbGV6?= <disablez@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 9 =D0=B0=D0=BF=D1=80. 2021 =D0=B3. =D0=B2 07:06, Aur=C3=A9lie=
n Aptel <aaptel@suse.com>:
>
> J. Pablo Gonz=C3=A1lez <disablez@gmail.com> writes:
> > This patch adds a new command to smbinfo which retrieves and displays
> > the list of alternate data streams for a file.
>
> I gave it a quick try and it works. LGTM.
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Pablo, Aurelien,

Thanks for the patch and for trying it out!

Merged into the next branch on github.

--
Best regards,
Pavel Shilovsky
