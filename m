Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D78C2D0A3
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Nov 2020 23:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADD0D20679
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Nov 2020 23:46:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="thuIKJtP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgKIXqS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Nov 2020 18:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbgKIXqS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Nov 2020 18:46:18 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E472FC0613CF
        for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2020 15:46:17 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id w13so14813227eju.13
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2020 15:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dS+8rGshrXbBUplAsZNgqe6MUeLm5wMMMVMzkX9haag=;
        b=thuIKJtP3ZLz/O0NxPUxofxQz23fQLQnyNdxCKfjiOliW9I1G2mZhy6XFcFlnKmp+5
         jAyVMIsCGZvccVKHqNZ8tYE1iUW3cxOZZKXVzQ/Ja0/wIxOnSudm+L6+iXAgoxC2NkVP
         TQFsk64F9vNfhboKUpYXTYFisTmtmUhiZMSBfyvaUtSlBOnNMyr7DoC4mY0SZxrV5s4D
         jYChj8iOQ0rWedu/zj6RruT+0/QTDg0BpAm0R9WDHL77mt5+92PXEGSq9X5R5lcR2S1Q
         mMCxAcjhcDfy0hFRfDUeLoHufdgxjhZl1zhLRQDSCXKBIKkycvMpsVbJvmdTPwqFwbcp
         0fKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dS+8rGshrXbBUplAsZNgqe6MUeLm5wMMMVMzkX9haag=;
        b=U/byN1i8b0xDRJruvE3mAVFuhi8ZJEP3UhMvLbeVnVKK4gayEj0TlF8opSXSg1+7fG
         h78LJ+4/JgNCbAALsNLxC/1wg8QhMIYQUjMy64bZbAmhpyYEtuwEDPxHBlgaITEEXE6L
         0UppaVJ4RAw5Zx8byjIOyxQEGC74OvZkurHtD88GQWJYYvz7mqnhV5tYXblJTNmYVtEI
         CwlcpMPR8RPdVfzYRxWv3AU6AGY9W9DkdPN5ISGDvaTeju6FvfbM5ftETY3F2OyUjZEr
         pHoCt9+AqJla8d1Rf6gMlHEhFFemJBKXCNXpHjlaHdCvySEpbr7ij8nCXd/hxmOo4Kcr
         OQ0Q==
X-Gm-Message-State: AOAM530i+URUuazVtf4IR1JDFazyIvN2rs12Fcg8Z0A8H4TYmWOoOrm6
        YWNYHr/gsW2npAmO5Sv91LSCVewyzVNXv3J4K73JubI=
X-Google-Smtp-Source: ABdhPJzsQCRY0OBg+ELpcTOzRgw/Tjmbe6SvD98rsZTLcYoiS5tneEVLpoOtQjEYsL7wKlfxIIdYaP8BeBS4TeQ2a8c=
X-Received: by 2002:a17:907:42cf:: with SMTP id nz23mr17261770ejb.138.1604965576699;
 Mon, 09 Nov 2020 15:46:16 -0800 (PST)
MIME-Version: 1.0
References: <20200925113200.371db298@martins.ozlabs.org> <87o8lujjaj.fsf@suse.com>
In-Reply-To: <87o8lujjaj.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 9 Nov 2020 15:46:05 -0800
Message-ID: <CAKywueT_PAarufhVe=A2ZiJETNQnYTGGNP_FRU+r-97y2Jet9w@mail.gmail.com>
Subject: Re: [PATCH] mount.cifs: ignore comment mount option
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Martin Schwenke <martin@meltin.net>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged. Thanks!
--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 25 =D1=81=D0=B5=D0=BD=D1=82. 2020 =D0=B3. =D0=B2 02:30, Aur=
=C3=A9lien Aptel <aaptel@suse.com>:
>
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
