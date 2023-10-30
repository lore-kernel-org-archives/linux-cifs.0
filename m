Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF48EC4167D
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 14:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjJ3O7V (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 10:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbjJ3O7V (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 10:59:21 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2953C9
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 07:59:18 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-507a55302e0so6459921e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 07:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698677957; x=1699282757; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ei4SVboxDUAHFeS29uvc+mP3mIzSaR0zKoC0B2c1eC0=;
        b=K6Ebgnf+jYalZAQSZU3GyahKUm5Ao5Fw+MefapiZjUsO/IgDi5LSzgH2XHmJpxKL/L
         h3WsVVfUBggSsS8dVJacydEFOGnS19K4UK7NDHkHpYeXeBwpNWg6Wdzo6EktFgZwsNo2
         foYf2/9Z0r4wmyHvkRLAgkwPp+eAQcORcOE70eJa/EXanh+0T0wzCI0QjWrC7OAVnIiP
         glHFjeGcADWHO8yZqgbsiRsi+JgZPBG77USJ6KxCtKCWiUQORcote63m7Qkvixk2Ncrp
         Qyn+/ucMrcfv5ZImXmmwLz01Cf0EWqQDIjIAoGvt9REylpIg23hMNitduZOsi2QGlPwO
         WrKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698677957; x=1699282757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ei4SVboxDUAHFeS29uvc+mP3mIzSaR0zKoC0B2c1eC0=;
        b=UcUKvMa6IvvBsSOND5uGKrJDXzpEI/xDn7lTpmOgxACaY9TxphCQX8j7l5hz+C3dZG
         grMUasv4t8WVptYQBJb6wj1CsEmmdBIanZOXe4QVMNzl111O367avWqjxcRWdtBzKyhz
         +GZtRc/wkY/jhIx//sT4AnSDb/2Ojlt83mmsoZ4HiIU8Iy/fu96WpcggDvQLe0c7JLlK
         S2/5kw2G3jvzqvR1FodPNu5IsHUCw6wEiq2Y+v4UZNrqxRFLRBku6cGh18+jClxv5SLL
         TpGowENNy7hhNQJa0a97CtKkIRzbEnrOmRXV5QQrzKowcULr3lJhQih5nDOO8PSLkzEP
         Q0Kw==
X-Gm-Message-State: AOJu0Yz8V36HpVjAQ/sW8t2J44YbGzi5zZ3smKqc6zwVYf9MLiObrUGr
        sMUKeWeNJsAA3kabGCr/k/diHuafsIjbAZjLvSemAVXcnYc=
X-Google-Smtp-Source: AGHT+IFnHiYYLbnLtAvtWDi5NBzQUR1pU10INVUAIRK8blhtYZ9oG0ggRFL5AwXncTWFXHF+jw0MLgYhTpd2SXUhn0w=
X-Received: by 2002:a19:8c0f:0:b0:503:1783:d5a9 with SMTP id
 o15-20020a198c0f000000b005031783d5a9mr6346912lfd.3.1698677956661; Mon, 30 Oct
 2023 07:59:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvxf3j6aXGdzh8b7cRYJ=fHvjfkv=aHPStJRYR+x8auiA@mail.gmail.com>
 <CAGypqWydCTT5M6T_0k4y1jPVZyiOtsFGBxdQfHVDSfx_v-dX7A@mail.gmail.com>
In-Reply-To: <CAGypqWydCTT5M6T_0k4y1jPVZyiOtsFGBxdQfHVDSfx_v-dX7A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 30 Oct 2023 09:59:01 -0500
Message-ID: <CAH2r5mtYsnsW7EEdfJZ0LXPxV=D68Na0tSOHHvYf5XKTLUxqSQ@mail.gmail.com>
Subject: Re: New SMB3.1.1 command
To:     Bharath SM <bharathsm.hsk@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

corrected - and updated the changeset in for-next

On Mon, Oct 30, 2023 at 7:44=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> > Also another minor patch to clarify some of the unused CreateOptions fl=
ags
> >
> >    See MS-SMB2 section 2.2.13
> +/* FILE_OPEN_REMOTE_INSTANcE cpu_to_le32(0x00000400) should be zero, ign=
ored */
> INSTANcE should be corrected to INSTANCE



--=20
Thanks,

Steve
