Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7000AC433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Sep 2021 02:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53E8260E97
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Sep 2021 02:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345668AbhIHCtY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345390AbhIHCtK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 22:49:10 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9DBC061575
        for <linux-cifs@vger.kernel.org>; Tue,  7 Sep 2021 19:48:02 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id c8so1851431lfi.3
        for <linux-cifs@vger.kernel.org>; Tue, 07 Sep 2021 19:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+YgnwSwQMXa51j8k9Mhijxmins+EEJeGya6wdi+xC7w=;
        b=EkCkvFWciTSRRGqxD3ZOaiFtQSU/mtOqusAA+pLDINLbGHv/FnsTxREaaANr5BKLgY
         dgQuf9MFp+pn1DvD0Kwgqq7UQ/YnazegArno4+OWEL88Sp6amPZgSJtH7IqW2wEMs4Gk
         u+FFOR0U4bEyelkQDJqRZCDHqJn5qUsZqktnUp1j6HzGuGHANB/N8GeMO7gx6kcMDMlz
         ACJyOApemsEpf3NAxS1Jo5FSYyeEW+9FN3zEsWAU4cH4UBSRh/VVP9NbuqOsHAUb6x6n
         15yZtEBgcLmQIh8AMC+QlrLWAj9a9mZh3a5eCLBlsAfNSKmkvKLTa3qMILbvmlDB04rm
         kOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+YgnwSwQMXa51j8k9Mhijxmins+EEJeGya6wdi+xC7w=;
        b=pMCUn+RPG4zouHGrEhfCBxgNGIty1h7+qWqoi346Osfvp4xDxP+TvtnxOiQfLN3dHL
         CNwHsjm4xdsxa+H49kIetFYZx/GhZEtyMkkirYY3zck3tXD1fjJLdRl54Ei6Ru3cg61i
         ZEQvwP/t5T4Lit6yh2L+7nohn4pBZZUzCIC96NM6mV8pBPiQ4WkoghmReobaq+Op9jhb
         15IYVAqo4gaw7e3qVxb9CwEOxCY28QrS81NkYMVzo7xXaBvHKjnxZXJh0vqcdhpWAcII
         Li3YWwv/k13c2ihBJZrT7gqsthinQd7PezQtIwQECRXEe4vbK+JJdriKYZwTQKigSUmK
         XxTQ==
X-Gm-Message-State: AOAM532a1+yD20amLSFMM/wLSWnmOGmvzfO273s4fNZUscBEph1xa551
        cBD0ji1t3lR/qucgk+gIJ6ZOkwwFlWD8Lru06bPWPxX/
X-Google-Smtp-Source: ABdhPJz+g4HIQtxW120Zcs9xtSfBubrt/qj9+XGAktJCXA2DX8AF1fqbP2M9+tKXuuSCDN5nlziSHsowKL9cPzJ1K9s=
X-Received: by 2002:ac2:41c9:: with SMTP id d9mr1024381lfi.667.1631069281035;
 Tue, 07 Sep 2021 19:48:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210908021015.2115407-1-lsahlber@redhat.com>
In-Reply-To: <20210908021015.2115407-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 7 Sep 2021 21:47:50 -0500
Message-ID: <CAH2r5mtrkU5B2A4Oi8QE+7J1npQWt0H38Xr653CzoLWZMp-8Gw@mail.gmail.com>
Subject: Re: [PATCH 0/4] v2 cifs patches
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged into cifs-2.6.git for-next pending review/testing

Should be able to add the server patches which depend on this soon.

On Tue, Sep 7, 2021 at 9:10 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Steve,
> Something got missing in the two patches in for-next. Here is a resend of the two patches in for-next as well as the next two patches for the smb2pdu rework.
>
> Replace the two patches in for-next with this.
>
>
>


-- 
Thanks,

Steve
