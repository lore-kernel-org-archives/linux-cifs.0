Return-Path: <SRS0=po33=YY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98885CA9ECB
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Oct 2019 21:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DA8420679
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Oct 2019 21:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A1bAiUu/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbfJaVBk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Oct 2019 17:01:40 -0400
Received: from mail-lj1-f170.google.com ([209.85.208.170]:41301 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfJaVBj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Oct 2019 17:01:39 -0400
Received: by mail-lj1-f170.google.com with SMTP id m9so8097119ljh.8
        for <linux-cifs@vger.kernel.org>; Thu, 31 Oct 2019 14:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wJV10x+vsMnFtzm4Sw8gEvHgbQ2/QukcPE5x0DI4ZL4=;
        b=A1bAiUu/vj/0s0n+yIV3iY/1kvbGt4o2gcHkd2KPdz83ur3AMCgiZm0ZtboGMDffb3
         tugU6VSmRA/JsjWA6hZOvq65SOHjP3pibtcBRYeTTpxUWPbWfoJW3/icLW7ya6t0BqD9
         EzSk9hsWjAWw7Y3sTeRS5tnDKgKFwFNgehq5ZZXvAyDrFlmnq2RADAcKCJL/v6TXBB5A
         IjF/j/H/uPcqRoB9el5Au03zN6c8wcKhSKqJoYs5JLCkLgi1g1XTxPsCMvunWQCbbJf2
         rbwLY0EtwePe2YBu+4/nnpnhCx0BxOSQth52naIV9uLinPSA+GzE8gw36OORRFM13kGU
         nvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wJV10x+vsMnFtzm4Sw8gEvHgbQ2/QukcPE5x0DI4ZL4=;
        b=Vw18LjC0jPtHjJPOeZe+BO8PebB317zb3T7n8Qmba2xDgJ6KfWKnpXQ5eUjh7exmXS
         DLODrddt234sa0mm19CRhGGHXaK5uycpWFxAVuwQA5YFMNIZnoD1W1jhvJJcAsAQBrx5
         9pUIxAr4y7E+CK3NTU5tIatuGqusM6B4WvwEjIG6UyykYltEpUXW+P+P9a5qXRfrK5XP
         zHQqp7BL16jAG2NCXM4KtAbPCPw+vheAWeb6oTZph/VcBOA4jzVZqkPMNeqQgRjBs3wV
         cLKn5LQTjCm8FDBk1RRfkMuXG08KWVWeEF4isYvePUlS2HvIfdQ7AQlfe11ByiSYuNhv
         abAQ==
X-Gm-Message-State: APjAAAXpU0SEX8vrRlQJuRgRTeLzLGK8fd+En4OtEHeObtN4wrGEXXr5
        mo5b1U0smf1T3ZdFN0JIzFjtUmhkZ2VWkA2+xbguCbU=
X-Google-Smtp-Source: APXvYqxGTUFyJ87t03BeoPKcpYHp4WHJ3whoxGKhH7kPhvjWg3W0UhgbLHntc0YoAXceAX3yKdWWQfjwfrCaRFQpBEA=
X-Received: by 2002:a2e:2e10:: with SMTP id u16mr1820753lju.51.1572555696307;
 Thu, 31 Oct 2019 14:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
 <CAKywueT=hWCTM=Crsafrj-8P=1mD93DY73oK=Ub8JeWc5X85fQ@mail.gmail.com>
 <4a017b583eb0f5fab477ecbe0e43b3a1@moritzmueller.ee> <CAN05THR5FE80VsnbKfpBzvt+g5jPu3rtiOqWkzU5yKoKUkhkiA@mail.gmail.com>
 <CAKywueTOjoP-Jh7WWCi5XJhfzgK+KZs3kvHKuVG_HW0fnYYY7A@mail.gmail.com>
 <CAKywueQUuwRK7hbbJhdquVVPre2+8GBCvnrG76L-KodoMm9m6g@mail.gmail.com>
 <b7b7a790feac88d59fe00c9ca2f5960d@moritzmueller.ee> <CAKywueQ7g9VYe=d7WU4AzL2Hv+pPznUgQBD7-RVi0ygBkhtGRw@mail.gmail.com>
 <bdf21b8770373c9ea4c37c27a12344d8@moritzmueller.ee> <CAKywueQ8woeupNRqspAuOqL8rG1hNpWN_hwLCjFUpkk4mXeCvQ@mail.gmail.com>
 <6492326ef9d8d1a9401fac243160646f@moritzmueller.ee> <CAKywueSWxDA5veCWjf+vGM96TSKrJbiddt93dv=arXyizJCbmw@mail.gmail.com>
 <6a49aa3e2cf17975efc5259f94c01ce7@moritzmueller.ee>
In-Reply-To: <6a49aa3e2cf17975efc5259f94c01ce7@moritzmueller.ee>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 31 Oct 2019 14:01:24 -0700
Message-ID: <CAKywueTqA+=8Hv9F=BGbUGnv9HjURxY6kKzrMvE2LG-Dq+9t_A@mail.gmail.com>
Subject: Re: Possible timeout problem when opening a file twice on a SMB mount
To:     Moritz M <mailinglist@moritzmueller.ee>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 31 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 02:20, Moritz M <m=
ailinglist@moritzmueller.ee>:
>
> Hi Pavel,
>
> Am 2019-10-30 22:51, schrieb Pavel Shilovsky:
> > I think there is a difference in your setup between v5.2.21 and v5.3.7
> > kernels. I found the issue in oplock break processing that can happen
> > if you have several shares from the same server mounted on the client.
>
> I think you are right. Usually I mount multiple shares from one server.
> It could had happened that I tested it with just one share mounted when
> using the
> v5.2 Kernel.
>
>
> > Could you test the patch to see if it works for your environment?
>
> I did and it worked ;)
>
> Thanks.

Thanks for verifying the fix! I will post the patch to the list soon.

--
Best regards,
Pavel Shilovsky
