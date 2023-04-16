Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3A6C77B61
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Apr 2023 04:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDPEQQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 16 Apr 2023 00:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDPEQP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 16 Apr 2023 00:16:15 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BE42683
        for <linux-cifs@vger.kernel.org>; Sat, 15 Apr 2023 21:16:12 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4ec8399e963so687399e87.1
        for <linux-cifs@vger.kernel.org>; Sat, 15 Apr 2023 21:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681618570; x=1684210570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0eRmwm04NCkFbcmrEOqfczhlvdEj815rB5sreWUDCk=;
        b=chct726qnU7n6oylYir3UnIKX/0gZ+gdgnN4ZxEvZEof71eM0PHiCXTeMALWROHz1f
         IFF0hi/S7MY1/KDdtB8TM17T8j3lsCZMVV7ug1nZFtoGusy3p9sfV9B0g+sL0MLGjHHW
         pI9OBeuIhF1z/n7I01LxfHktVSAVB9H4lMTvlycF+osjpX3keJxF5C3Fjn7K3DNaZWlu
         JY4GybXbZsaw3viDKLSbPSQNybxkZUYyNIGU7xqszrVkAkyRi7AP3XEB0i9QlMJTXpJc
         jgjIP3rbYw1DPMd0qwCiuNsmX5RvLYOzjiH6hosIYOnNL5mjz/k6i4t9iI2jP+EEf22o
         IPug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681618570; x=1684210570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q0eRmwm04NCkFbcmrEOqfczhlvdEj815rB5sreWUDCk=;
        b=lDD/nKJIFazVsTL9ek6+rasGthPgykwCTW2t1KznxeSIodsnIFyNpN3geVFli561tS
         5B3JL18qhXJdMqdkdcUNWnmQMaXOZdU3nrd7NhgS0fjWJyc78PCxu9FBj6GYER2ietJG
         gZCTBValgT4ndnsyITCwPaW5BZ59z7w7sJ+aZtfpt9sCt1BrUzt3pPojT4+hjz6xvQ9q
         Z+ppThbjRvFLzp0KPcjC1uQ6SLdW3V9xJ+AONqFx+Sz5qYcCEdrjUx2qbyQbKB9fqjlE
         aaUwv4u4T5BnVg6wkEoqZjjUP5PXiF1wS8ZRBj0Q70Wnu7k3WDyG99koi3V0Ji2BPzDt
         26Zg==
X-Gm-Message-State: AAQBX9cf7jNZDo/GPz2RI7JEfRuoFENT6+5g9xBwZZPlOoA7VH8OORyX
        5abbR+K2RhhYBDE3V6PlEXgeJH2qnea1K/irba8CY/E/
X-Google-Smtp-Source: AKy350Z2HkyqXkRUsqkQR7LOnevCAMPKDZqiP2iyE/QIrSUy7s2z+7tM07ekYUN+Ae5TaQRJuRGBqGMgbp0T0fRfJZE=
X-Received: by 2002:ac2:5383:0:b0:4ec:a052:9e93 with SMTP id
 g3-20020ac25383000000b004eca0529e93mr1016238lfh.7.1681618570174; Sat, 15 Apr
 2023 21:16:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mumQ=wg8H4d+vYGZZGPz1cbK5+LOeCoBxo+VbYta05QBA@mail.gmail.com>
In-Reply-To: <CAH2r5mumQ=wg8H4d+vYGZZGPz1cbK5+LOeCoBxo+VbYta05QBA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 15 Apr 2023 23:15:59 -0500
Message-ID: <CAH2r5msYsy-pERjcdy9WiA6tir+94Kn_HTWHwQvWsa=Jd9qx2g@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server fix
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I cut and pasted the P/R text twice by accident (if you need me to
resend it let me know).

On Sat, Apr 15, 2023 at 10:52=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Please pull the following changes since commit
> 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d:
>
>   Linux 6.3-rc6 (2023-04-09 11:15:57 -0700)
>
> are available in the Git repository at:
>
>   git://git.samba.org/ksmbd.git tags/6.3-rc6-ksmbd-server-fix
>
> for you to fetch changes up to e7067a446264a7514fa1cfaa4052cdb6803bc6a2:
>
>   ksmbd: avoid out of bounds access in decode_preauth_ctxt()
> (2023-04-13 14:17:32 -0500)
>
> ----------------------------------------------------------------
> smb311 server preauth integrity negotiate context parsing fix
> (check for out of bounds access)
>
> ----------------------------------------------------------------
> David Disseldorp (1):
>       ksmbd: avoid out of bounds access in decode_preauth_ctxt()
>
> --Please pull the following changes since commit
> 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d:
>
>   Linux 6.3-rc6 (2023-04-09 11:15:57 -0700)
>
> are available in the Git repository at:
>
>   git://git.samba.org/ksmbd.git tags/6.3-rc6-ksmbd-server-fix
>
> for you to fetch changes up to e7067a446264a7514fa1cfaa4052cdb6803bc6a2:
>
>   ksmbd: avoid out of bounds access in decode_preauth_ctxt()
> (2023-04-13 14:17:32 -0500)
>
> ----------------------------------------------------------------
> smb311 server preauth integrity negotiate context parsing fix
> (check for out of bounds access)
>
> ----------------------------------------------------------------
> David Disseldorp (1):
>       ksmbd: avoid out of bounds access in decode_preauth_ctxt()
>
>  fs/ksmbd/smb2pdu.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
>
> Thanks,
>
> Steve



--=20
Thanks,

Steve
