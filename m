Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846DAEB64D8
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Jun 2023 07:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjFTHtA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Jun 2023 03:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjFTHs4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Jun 2023 03:48:56 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07CA173E
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jun 2023 00:48:14 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2b46773e427so42663531fa.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jun 2023 00:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687247292; x=1689839292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O1+TsiJS3mhzhaf4kwMzcq68t6iy9yh4MEnbdkFReL8=;
        b=OvsxmcF81HQfoXRlHrLK7A1V6y9BJhJsD1ptkFu//fnrLZbaV6ypRYJ5uYo64JFFOl
         kmoINiw2glkjHzZAce/th0/qerRJKrxCApBylUdDU7pExgEbOGcJGUdc/urkZ8qd40Gd
         K1Tnwqw+lN2OGO1TN5FRTTKj5hlvsHl1rXxtuV7dbATRPCaTfFmqd3kF/zrGmMBRWJz9
         spzPXTtm+59PaoAfeZX+gneq31SYy59yIBEgyQpu/dBWQzdXuPUluiLoeaHc4Rq2YQLH
         ZJIKX03F6CAOQsbRh89xtwWwCtlzCr/y7Cnbkh6e5dHYtaTT1rCBIPldZfjfnakrUuUc
         nP5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687247292; x=1689839292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O1+TsiJS3mhzhaf4kwMzcq68t6iy9yh4MEnbdkFReL8=;
        b=UtiM3DuK60j4XKQ2KOKyuM/Qc7/ZNK0JRBU0ZyaddGZWIX2hXqNreV2Io6fGgVKodE
         jLdrpS4h7SKRfl069DwMbfnQQq6mKZ4w/xaGc/WeSU2MZsQWOOdoC1qg1hGw+UhSMGPf
         EI5wxuvcptXdTL9EXSQXXYsTnZ0pbqEpptCpDj4Q6DQSTR6xB+OmQasfMJlJAcgAOgeq
         2ZCWtJV5d3wSnNXhrAUmGWSnDrXgsOrZ/3hS4pNC3edtpMEyycW6DEe1KO475AcTZNVr
         m35Ib1pkEWFswPenjL7A+YKafRqvSotVl5I4NlqfhvQv3gGtbRZlaR/NLoazSw1fCx64
         TUWg==
X-Gm-Message-State: AC+VfDwEJJE/6vU6c2WlpwpJ6sSLXn05QZA7nn+JcK17ax7qyVhxsNRO
        maSLB66ZW1rEElVCiZPZRIV+ibFtN3dXH8985UiS5fVk2zAqkg==
X-Google-Smtp-Source: ACHHUZ7rW/eG81BgpUeNZ0Bg1RiWM26ndCPdkdqsOWxngwBtjHM3OIjVeiNC7IqYPPaqb47JCtH85aPZJY12cOFi95Q=
X-Received: by 2002:a2e:9e44:0:b0:2a7:7055:97f5 with SMTP id
 g4-20020a2e9e44000000b002a7705597f5mr7638704ljk.0.1687247291722; Tue, 20 Jun
 2023 00:48:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvuuCeQQKN+RRxoELjf9NOfLNOwgOjBbxdUKYiowsbY_w@mail.gmail.com>
In-Reply-To: <CAH2r5mvuuCeQQKN+RRxoELjf9NOfLNOwgOjBbxdUKYiowsbY_w@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 20 Jun 2023 13:18:00 +0530
Message-ID: <CANT5p=rO7KX9KJVJ+tQVfdYXtORQbHvbR0zZq2Gjd5nvOmWjvw@mail.gmail.com>
Subject: Re: [SMB CLIENT][PATCH] do not reserve too many oplock credits
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jun 20, 2023 at 9:12=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> There were cases reported where servers will sometimes return more
> credits than requested on oplock break responses, which can lead to
> most of the credits being allocated for oplock breaks (instead of
> for normal operations like read and write) if number of SMB3 requests
> in flight always stays above 0 (the oplock and echo credits are
> rebalanced when in flight requests goes down to zero).
>
> If oplock credits gets unexpectedly large (e.g. ten is more than it
> would ever be expected to be) and in flight requests are greater than
> zero, then rebalance the oplock credits and regular credits (go
> back to reserving just one oplock credit.
>
> See attached
>
> --
> Thanks,
>
> Steve

Hi Steve,

> If oplock credits gets unexpectedly large (e.g. ten is more than it
> would ever be expected to be) and in flight requests are greater than
> zero, then rebalance the oplock credits and regular credits (go
> back to reserving just one oplock crdit).

Why this value of 10? I would go with 1, since we already reserve 1
credit for oplocks.
If the reasoning is to have enough credits to send multiple
lease/oplock acks, we should
change the reserved count altogether.

--=20
Regards,
Shyam
