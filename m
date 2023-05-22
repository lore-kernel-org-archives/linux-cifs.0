Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B810C7EE23
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 17:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbjEVRdw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 13:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjEVRdv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 13:33:51 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DF7B9
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 10:33:50 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-510e682795fso9109518a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 10:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1684776829; x=1687368829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Slu3gux4GuUHwh68X0h4hh6LgeEzWMQzZomXLQPnCh0=;
        b=Ljg4LOy0fHrVHwQrC6CFPRl2RBlB71H4nfxmtrAN37UAHfFvzivakgEuSCbqDA1N+4
         i9+SneFGnaWeVgwnYb9dbnOzwq8hgg370KB87G8X/9Pg+cm8yutJsa3CPJ4QGUp1mYpD
         A3AKz+Vz4rkoke6nYDDwagdl3BNnF6xBH56y4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684776829; x=1687368829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Slu3gux4GuUHwh68X0h4hh6LgeEzWMQzZomXLQPnCh0=;
        b=Qp4UNqr0dX8MVN+4lbfk5ObwiNcgQmYObgRMhp1+i7AnVoNVVCatH8nAD3kFHLW8ga
         nq1/LJAL1t3gFPJ92fLm8ypK10W7ELdu34dRQ704oXB7iVoY8cduKJv5MmI3CrpJApVJ
         pY3o0PmGkcrik/kSO3A535ZlSmuK++OPYyUF9wTUQoS179UGxO7pbtx0ypEFvpEiAbaz
         KWMMXJgrlNCAlPVJgi6V43CvBkrjIUeyMOFYM7HzCEvtvKgo5tF6zo2aTzPSgXKaFO3S
         QLZgd7l8CBxaXT4KkBa2PGdg9jwr2DUOjsD1BVQw951GKkyjD5Tk2Bp1Lrj9OagvkiyM
         X+6w==
X-Gm-Message-State: AC+VfDwib78nDr8Zi5e8803nDZqnS58swOlU037GmZpQnWOBE90RCOnj
        Xa6SuSnl4tIWpDgbn4yPDgObWiszhdRI+UlK1PgGIQ==
X-Google-Smtp-Source: ACHHUZ6M64a5RKhLTj9NMeX9SM8potuPXnTwFSMgEe71UP+xSUXOGlVzx1lm/mXl2WAsAFkVSTcNRQ==
X-Received: by 2002:a05:6402:517:b0:508:3b21:7cbb with SMTP id m23-20020a056402051700b005083b217cbbmr9246205edv.19.1684776829070;
        Mon, 22 May 2023 10:33:49 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id d4-20020a50fb04000000b0050bcaedc299sm3230415edq.33.2023.05.22.10.33.48
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 10:33:48 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-510b6a249a8so11484405a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 10:33:48 -0700 (PDT)
X-Received: by 2002:a17:907:2d23:b0:96a:928c:d382 with SMTP id
 gs35-20020a1709072d2300b0096a928cd382mr11676946ejc.48.1684776828268; Mon, 22
 May 2023 10:33:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msVBGuRbv2tEuZWLR6_pSNNaoeihx=CjvgZ7NxwCNqZvA@mail.gmail.com>
In-Reply-To: <CAH2r5msVBGuRbv2tEuZWLR6_pSNNaoeihx=CjvgZ7NxwCNqZvA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 22 May 2023 10:33:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjuNDG-nu6eAv1vwPuZp=6FtRpK_izmH7aBkc4Cic-uGQ@mail.gmail.com>
Message-ID: <CAHk-=wjuNDG-nu6eAv1vwPuZp=6FtRpK_izmH7aBkc4Cic-uGQ@mail.gmail.com>
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

On Mon, May 22, 2023 at 9:33=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> Following up on the email thread suggestion to move fs/ksmbd and
> fs/cifs and fs/smbfs_common all under a common directory fs/smb, here
> is an updated patchset for that (added one small patch).

Looks fine to me.

I wouldn't have noticed the typo that Tom Talpey mentioned (misspelled
"common" in the commit message of the first patch), and that
SMB_CLIENT config variable is odd.

I'm actually surprised that Kconfig didn't complain about the

        select SMB_CLIENT

when there is no actual declaration of that Kconfig variable, just a random=
 use.

That thing seems confusing and confused, and isn't related to the
renaming, so please drop the new random SMB_CLIENT config variable. If
you want to introduce a new Kconfig variable later for some reason,
that's fine, but please don't mix those kinds of changes up with pure
renames..

                Linus
