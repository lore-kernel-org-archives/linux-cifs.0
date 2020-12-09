Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC18C433FE
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 19:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4567A23AAC
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 19:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733296AbgLITQm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 14:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733155AbgLITQl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Dec 2020 14:16:41 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D16C0613CF
        for <linux-cifs@vger.kernel.org>; Wed,  9 Dec 2020 11:16:01 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id u19so2815650edx.2
        for <linux-cifs@vger.kernel.org>; Wed, 09 Dec 2020 11:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YmfCW0vEQmPywOXh1buW6IlHTlCJZIhtwSmnT7uKid4=;
        b=I01Bvd1mCSZkVeJH98SbD5hkx57eKZO29wbWaTfHUAuZ9jdmOFQgIzSk1YC1OS0eSY
         gEe3b2qcviUWIC+KqlbBXrAEqBE/wXFpok+Xm7CAd/MRoj4eg/poTzQcFEIh39/8+C06
         ZdN7AfhDrEioZHsHHD9HkeTMTayJ39UCeHxUW6MNBErn2oRSnG6BkQOFObGyUa3PeqM1
         GIHEV9sAbUndrJkuPXACuk2wPDr+G6CF7ayQdBLuGPtWIjI9cYSaWnwLG0Y/CY1EGOQp
         E43sx2DvHmczegRgulF1GUYuPGDEqQ4q8I7pDQYUCNiSWEu8vS9FgO2g7OHF1P596Ad9
         iTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YmfCW0vEQmPywOXh1buW6IlHTlCJZIhtwSmnT7uKid4=;
        b=SL8a2Wz34iqv0MUK8cGKioRfXlS2Ev4pfyaZu9aTUYUJHXRHVrFUN/cIJMHzEgkwwx
         qTq/1b3PVRqOrn7TXIJj+o+g4BbewJzXoPODQpU0OrSn2td2QoJ4oSi/Nzi61oKFar1z
         EbuUQeoGFzUo6CzcPopmafcWgkKYZvKhqghEAA6Zl4ljQSVpOp8yEqWyFlsj8su/q+FI
         rHLiKsdNS8XnZSR3OgLbnTv07Y+So0+hvPCAVnE1e9hEUe+KMNYt65gJlcNklJGvU70w
         oDeG1O9zGZsBWl+KaMayOdzwgrotu4CZClAvvGbgn+B4N/3awhD800PenWiJqEp9U/60
         1lmw==
X-Gm-Message-State: AOAM530TKaGAZljUlF5TxiM3ecjk0XeS1REWo5IS/Vlhqm2C2M0yV0XY
        +F+gjgPO9BD5Q2RmE4VLHhnTpDqIyXP5VtTIJopi/JQ=
X-Google-Smtp-Source: ABdhPJyY2NKIYUeOgcHAKta3nyj1CYKQymq700wOK7mpw1hTabz7CIAyc3uAiasdK6gIY5cnlWtwOrMluPf0w3cgb58=
X-Received: by 2002:a05:6402:310f:: with SMTP id dc15mr3414810edb.225.1607541360025;
 Wed, 09 Dec 2020 11:16:00 -0800 (PST)
MIME-Version: 1.0
References: <20201121111145.24975-1-diabonas@archlinux.org>
 <87tutflztq.fsf@suse.com> <20201124133740.cixyh57b3rlto54n@archlinux.org> <87zh33dsou.fsf@suse.com>
In-Reply-To: <87zh33dsou.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 9 Dec 2020 11:15:49 -0800
Message-ID: <CAKywueRXd08NdeUEjqqXLz6RPCRvZWZye1nhM=ddUqZZ5LYuMg@mail.gmail.com>
Subject: Re: [PATCH 0/2] cifs-utils: update the cap bounding set only when
 CAP_SETPCAP is given
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Jonas Witschel <diabonas@archlinux.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into the "next" branch. Thanks!
--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 27 =D0=BD=D0=BE=D1=8F=D0=B1. 2020 =D0=B3. =D0=B2 02:02, Aur=
=C3=A9lien Aptel <aaptel@suse.com>:
>
>
> Thanks Jonas this is very helpful.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
