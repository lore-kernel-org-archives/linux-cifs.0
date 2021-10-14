Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC183C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Oct 2021 21:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC98261090
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Oct 2021 21:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhJNWA3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Oct 2021 18:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhJNWA2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Oct 2021 18:00:28 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E52C061570
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 14:58:23 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id e10so9620387uab.3
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 14:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8cyEJ4E7CceaF+AYo5i3A5KMDLBVdGE1QnvckL/wP68=;
        b=Ir7esuxumVdmsEfe0gloUF/hjzk0M4lSbv6IYo1/KnwVZ1DmybzHh4G6US2m1Q965L
         sx0skVLOpMbAA2vsWAj3m3Yg4/aLJ8bMCj+5V3jbvFwSnq26U9y58N/k5Hv4IVq3oNyh
         PLd+So++OXNAExz8cchKWIDEsCyR1pQTL9GbeWIbXEeMUHi5XE8h1cWVcy4p+Q3mkrAS
         TTCM5BVTPvHLsZA1LpNYehdOzBUJbXw8qRGbpOf6Y4+oY8B678gn7xYIOZwZZT2652Hl
         LHUw+k22Wl9LEufC+Ad5C/jz85sCEwlPIGJpG5EUlFHyUgzZesjDZS2Dif6iJ/qhhjGh
         rffQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8cyEJ4E7CceaF+AYo5i3A5KMDLBVdGE1QnvckL/wP68=;
        b=mM3dg1FUPZNbnHL4iEZSN7Zx9nekle38PMRvzhYNiV4fDVNmBen73m79UXy+LnGPzD
         9dD08oWUGUXXkHgEikUA/FwSGQP3rFZnXKoG5CzX28jBzs8woA8fY3aiNUvhkud7r6pA
         ErCU582I+k0Dt+JMbrQiBi+kVdVvWeO1cAq3MDKrfHDEdn9kKuTrsVu71HPRwIRtmWfR
         /vQuBJ1m0kG3OKPViNpvWh/5bAn2N3e7QFAPe93/BXVAmpBHPCrk6jFuzBJ82yY4Yutr
         zmxfUisSIxSM/r4Qemh5r8tVkvX9fA+/29hBsuNCQov27cb8uSLEP3IQCmVeFpWOTXIO
         kGtg==
X-Gm-Message-State: AOAM5314WQeewaypcxdiZO148OG0HgxvGwGBYAQxm3UjI00IFOHowjXX
        70Sda4BrhqKzTEWXsW/NJgIH3KAIw+COZ6WfiHE=
X-Google-Smtp-Source: ABdhPJydxmGn/T25uzyhweQdlMcDY/AJH9l3atro4cncmP4Ukizr9Qhd13r7jBFtZunqjGJy6radt4+7IbkCyX3Kapk=
X-Received: by 2002:a67:c81a:: with SMTP id u26mr10899552vsk.27.1634248702692;
 Thu, 14 Oct 2021 14:58:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms_S9WsLNnQ=AYE7Ykss5+VCfeFtL01VVqt6tp=CY5sRw@mail.gmail.com>
In-Reply-To: <CAH2r5ms_S9WsLNnQ=AYE7Ykss5+VCfeFtL01VVqt6tp=CY5sRw@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Fri, 15 Oct 2021 06:58:11 +0900
Message-ID: <CANFS6bbzu+OjJKaTVnvDS7GogzCzhD=jVMPoQC2xjcFx-STWhg@mail.gmail.com>
Subject: Re: Ksmbd and max credits
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 10=EC=9B=94 14=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 2:03, =
Steve French <smfrench@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Thinking about the patch "ksmbd: improve credits management"
> (https://github.com/smfrench/smb3-kernel/commit/bf8acc9e10e21c28452dfa067=
a7d31e6067104b1)
>
> Hyunchul noted in the description:
> "Windows server 2016 or later grant up to 8192 credits to clients at once=
."
>
> I noticed that SMB2_MAX_CREDITS is defined as 8192 in
> fs/ksmbd/smb2pdu.h.  Isn't this a little low, although I see Samba
> default to it as well.
>
> Was thinking that that is roughly equivalent to 64 8MB writes, or 128
> 4MB writes.   Although Samba defaults to 8192 max credits as well, for
> Samba it is configurable (via "smb2 max credits" in smb.conf).
> Should it be configurable?  What do more current Windows servers
> default to as the max?
>

According to MS-SMB2, the maximum credit limit is configurable, but
the default maximum credit limit in Windows Server 2022 is also 8192.

It looks good if it can be configurable, but I can't find out the possible =
range
of values.
And there is a description, "You should never need to set this parameter"
about "smb2 max credits in smb.conf" in the Samba manual.

>
> --
> Thanks,
>
> Steve



--=20
Thanks,
Hyunchul
