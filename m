Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B7FC433B4
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Apr 2021 22:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E48A61177
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Apr 2021 22:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhDNWGM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Apr 2021 18:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhDNWGK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Apr 2021 18:06:10 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AE4C061574
        for <linux-cifs@vger.kernel.org>; Wed, 14 Apr 2021 15:05:48 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id w8so8584515plg.9
        for <linux-cifs@vger.kernel.org>; Wed, 14 Apr 2021 15:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rSPfUf4Tc4e6lBgmzrupbg4lxZLaqyGXwToZqHjvsc4=;
        b=M4MJsaClN1FaCMG962uDeGfEnJtNdNYz12je5cUAX9+f+NWsm5Afl2Jys65XDwq34r
         4I566MTOnNmzdIDV/duyo64va3kzfOxG1W36UUBvvA9+hYO9XLYw2vaF/a1TcaxDcOgk
         33UeEwaNYQh0aHWniIZeKdlQmAblaCvRbcnlJ9z/BB2De4AUDww6KXCBfrA2fFPzgaT2
         Xd0MrUjHu1nAXXOMt4ew9UVVXtb4Ki2yYl0Y3sSVdtNfPZkqHsHP7OYy2lk65tahnQ/3
         otYgE80ttR74Dp+C8qRccq5KT+SE/4kfINxbkeG+qm4iiFpqAFjLpwl+AzMmtxPOOrM3
         M2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rSPfUf4Tc4e6lBgmzrupbg4lxZLaqyGXwToZqHjvsc4=;
        b=tUXzXf8d4mIOA5sb6pl666qaYk8NbG/ssJ8OHfhdq6/fM2YuM+s1bKyYq3UIIDSCvq
         Rb2Pamv0fUkyb7H+6bU/QSWBBsZfYUK1PjpFnxzT9+SnyMaMaA3ImTdvJdudUR6FQKkY
         SngEBaA7H0nridfoDfEC0ZilgzMIErBgF2MGh57ScER5L5fJQTQ3aY2YACVEoyEFx1ga
         CJY875mwDe1Eetb4/PPR5Eo3knoWA8ovXodbHQ4fetU3mTm/6JZn4Ukz9HNAUfR4O0HY
         vilurlWtRrSDeNwmd6xdrQOPXZQHf2XznmaJcbGS3Rhz1rumYT94oTbAvlUoIvmpXgl2
         soqA==
X-Gm-Message-State: AOAM530sh14ZHzr6WJ1QJNG/oUrjc8884csnGPngJn7xnuxQyf8PQEJT
        wKfoYzjTJ6wyYBm5BdA/hrk0p8c2QRAaovSoiX12eKWoeno=
X-Google-Smtp-Source: ABdhPJxm3viXpPIjG9RVKqcjYWBXoUJJ7MbfdvtYy89h3+XG9qukBdc3kifiK6VBFqgqlxkj3tpg66C85BD0cDPq/wo=
X-Received: by 2002:a17:902:b68c:b029:eb:6c82:60da with SMTP id
 c12-20020a170902b68cb02900eb6c8260damr383689pls.25.1618437948146; Wed, 14 Apr
 2021 15:05:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAMM8u5miX1JbzWMG3WLZLZeD1_ZL=6nufWJaT7ensA+yPo5zeQ@mail.gmail.com>
 <87r1jj364f.fsf@suse.com> <CAKywueR6QF-TrTDMwcGz9cp5+6HgrjvZQhZp8T13C64m23ZxVw@mail.gmail.com>
In-Reply-To: <CAKywueR6QF-TrTDMwcGz9cp5+6HgrjvZQhZp8T13C64m23ZxVw@mail.gmail.com>
From:   =?UTF-8?B?Si4gUGFibG8gR29uesOhbGV6?= <disablez@gmail.com>
Date:   Thu, 15 Apr 2021 00:05:35 +0200
Message-ID: <CAMM8u5kGUaoZDc=pzOkfAWdjTHghW=JhgHs3hpZGaCCORMS4PA@mail.gmail.com>
Subject: Re: [PATCH] smbinfo: Add command for displaying alternate data streams
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Great, thank you both for your time.

On Wed, Apr 14, 2021 at 8:55 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D0=BF=D1=82, 9 =D0=B0=D0=BF=D1=80. 2021 =D0=B3. =D0=B2 07:06, Aur=C3=A9l=
ien Aptel <aaptel@suse.com>:
> >
> > J. Pablo Gonz=C3=A1lez <disablez@gmail.com> writes:
> > > This patch adds a new command to smbinfo which retrieves and displays
> > > the list of alternate data streams for a file.
> >
> > I gave it a quick try and it works. LGTM.
> >
> > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> Pablo, Aurelien,
>
> Thanks for the patch and for trying it out!
>
> Merged into the next branch on github.
>
> --
> Best regards,
> Pavel Shilovsky
