Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330D3C4338F
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Aug 2021 04:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 097BD61078
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Aug 2021 04:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236369AbhHEExE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 5 Aug 2021 00:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhHEExE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 5 Aug 2021 00:53:04 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81CFC061765
        for <linux-cifs@vger.kernel.org>; Wed,  4 Aug 2021 21:52:50 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x14so6498731edr.12
        for <linux-cifs@vger.kernel.org>; Wed, 04 Aug 2021 21:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=yiHbk7rGRCn8vwooVTGwJwlKbijj2VRwtGUl7MbPhOE=;
        b=o13/8Eli5yjc19aXkZWTVAkb3BWD5+mAUu/FBpg3IqUnFQiNI8+tzCifMiIHyInMC9
         P7zaSS6l4O4mXPoH/il9bYUbqOlH0XKxunmf0FtwFddi8nGorOvDw1qk1ChEpFFP/6bu
         V4sEkZAh4rByZor8yChoLthXX/9J9p8esMVtIeWSLLJ5BceZ5ccSIZOJ7rmIM8dzBwbW
         Ge9nScE/6SKivJ0rjx7GS+zo3pU4Ia5uwHc0pVDST+3DXXPGwx1cHeGzWt4W5EvdNnfv
         L4seyD9h0jFsnTeGjfLBiAmVPqbZDs0PAXLLZqNj54lyqEP2WoXZrmeodKS7JP9lWCPe
         QPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=yiHbk7rGRCn8vwooVTGwJwlKbijj2VRwtGUl7MbPhOE=;
        b=dIA+Rp08BW7mGRjB8SHZ+uf9x43WLQoKj1LcrAqJjGs0vj5woWH1P0Tgfruwj2yO2m
         9pcwBHvY1TDvKQQBUeF/rWa602YHcWcHhccAuFsBb5JhT/SzUESHKxnQNqtCd8pPk2o5
         VqgVYFJSyYwuOklbfhTr4uC/zbEQRsPGSjzYp3n1+C5LF26P+FzjknseVL+gq1tEMfD0
         0gjf+WsZf0p7kP262umPB61F4hryeQBWLbIvIZe2Ju5L4kDJCuDWsCuDbxTxjhkqe1IN
         u5gNfZWLlD16fVOrEqo6hGZACkawP7J6o6xcQ7jWvUnjViE9OaL3914nE5V7QeSMHujf
         ceJQ==
X-Gm-Message-State: AOAM5304gNyjsnXb3+L6WOI5XrE4LM3cOjcX6Np6YtY1Y5qkuLW/kvxc
        6M/JG8OXS+v39OOfItIwtTKBZ3ktzMdFLCxauRk=
X-Google-Smtp-Source: ABdhPJyOyw3HoIgrpEsxP+b4ICteuuP/iXV6duP5SJy6Za6dY2cM/uo8fho8OKWU1l2QE91y32ZxMXPlHc9daO/Un28=
X-Received: by 2002:a05:6402:53:: with SMTP id f19mr4093087edu.200.1628139169303;
 Wed, 04 Aug 2021 21:52:49 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oFC6ekqPQxmE5Hx6511ge3Bi0xjQn2abPdbKTo_j6JxA@mail.gmail.com>
In-Reply-To: <CANT5p=oFC6ekqPQxmE5Hx6511ge3Bi0xjQn2abPdbKTo_j6JxA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 5 Aug 2021 10:22:37 +0530
Message-ID: <CANT5p=pxO0W7tt5tMLhq_VneO3yZ_Ou2HmjDyYrhB3p8aYDZfg@mail.gmail.com>
Subject: Re: [PATCH] cifs: use both modefromsid and idsfromsid when either one
 is specified
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please ignore this patch. I'll be sending the correct fix as another patch.

On Wed, Aug 4, 2021 at 6:21 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve,
>
> Please review the fix for the bug reported at:
> https://bugzilla.kernel.org/show_bug.cgi?id=213927
>
> We don't have a way today not to set particular fields in a security descriptor on create. We need to supply the whole SD. We could do a getinfo followed by setinfo, but that's more complicated, and is prone to race conditions.
>
> https://github.com/sprasad-microsoft/smb3-kernel-client/pull/3
>
> --
> Regards,
> Shyam



-- 
Regards,
Shyam
