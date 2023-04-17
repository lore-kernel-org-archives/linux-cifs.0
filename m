Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA895C77B76
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Apr 2023 19:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjDQT4q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Apr 2023 15:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjDQT4o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Apr 2023 15:56:44 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE1C59E8
        for <linux-cifs@vger.kernel.org>; Mon, 17 Apr 2023 12:56:07 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2a776fb84a3so16028761fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Apr 2023 12:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681761365; x=1684353365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIXNyEqz8w4LSqLZEAM1j0vMQNbtYnPf8a4T7Be+F6A=;
        b=LbhgV47v5DeDLStzUNHTowfrzbnuWObE+snZvIffz59PHRoAP0Ke2qHoDgqBrJ2mtX
         tnNWIFrykv58Km/6uAzZdnZwdXWYksIdr3ZTyesCKlG3Mlq4edQ3p4R6mDHvOdaRMAWh
         eaa1yY/O9rFLZXLFjl5qFUc03/C984TIY43B5KiDvuZdVcjsE3Cic+bfQ6YQNF1rLEtY
         ciWmOYhq0mcHuou4JK0EG59Mbcj2SZLNFxmiVdE+CN8d85rlp7J5Y4kdp3TCVrrAuCPo
         x4wGRCocfCZ1YB0jaKHLjlOiugujogBkd3y/4V3z9NYDpWPQyWfkp4hpirl0xAsY2yIP
         Z1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681761365; x=1684353365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIXNyEqz8w4LSqLZEAM1j0vMQNbtYnPf8a4T7Be+F6A=;
        b=LTzmQfPKA9Cu01Q3sH6zbIpcOwrGfRJKhBWly9Gii8Lg0wdxF/nR3DKaihwQEqICuc
         1lTyHpLwFZO2x8PJbLtCgcAZFFUP9/z0wVt9M2aP5mtJXku3VYWK+uHoO1qzzPoimeUZ
         x+yQes3nHYY7Rm+VebQ6w6OVnGz5HT3OJGHJr1IGR2otflHDdRj0mP36CPR5t2z235if
         72jPKeyTEmN9xKN0eSChmMiFTTk5ZTWIduwr09qiP1+mIOjk8PclwbhpB2zjIv1Yhalb
         QgtRaS65Tg7E56QQAQJE3q7YLHxh/s0unuIXluMWuhTjquc9hKc3vcgKk7yOTdHp9um5
         0zYg==
X-Gm-Message-State: AAQBX9eQSNsSt+wy5vx0TFligZ1A0E9XXZ15COPOItuAqIczX4WSRlPY
        xER5Cjrqr4BobQP5sjZ29Y7pGl8nm79BMvycyrNuaWDaCGU=
X-Google-Smtp-Source: AKy350bDxfO8SHE9mYSd2SQGSBQtt4MTqiSDio1XU3Z0dX8psbrfbKRrhygbjNy1Q34OROxaFZcwErCdh9Qi2chpq0Y=
X-Received: by 2002:ac2:528b:0:b0:4ec:9350:e57f with SMTP id
 q11-20020ac2528b000000b004ec9350e57fmr2607072lfm.7.1681761365209; Mon, 17 Apr
 2023 12:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <82da2a3dc9704b2cecb51f00e93092c22a309a6d.camel@gmail.com>
In-Reply-To: <82da2a3dc9704b2cecb51f00e93092c22a309a6d.camel@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 17 Apr 2023 14:55:52 -0500
Message-ID: <CAH2r5ms4pdFMGEuuMRuGu-iL2Xqqb5sNoFgxd85M8p+cm2fg9g@mail.gmail.com>
Subject: Re: informazione
To:     cristiano forestan <cristiano.forestan@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There are multiple tutorials out there, here is an example from Ubuntu
of setting up the server:

https://phoenixnap.com/kb/ubuntu-samba

here is one example of accessing it from Linux:
https://www.chrisrmiller.com/mount-samba-share-in-ubuntu/
and more examples:
https://www.privex.io/articles/how-to-mount-an-smb-share-setup-an-smb-serve=
r-on-linux/

On Mon, Apr 17, 2023 at 2:15=E2=80=AFPM cristiano forestan
<cristiano.forestan@gmail.com> wrote:
>
> come posso iniziare usare samba per metterci file?
>


--=20
Thanks,

Steve
