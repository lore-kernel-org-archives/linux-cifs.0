Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C2BC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 06:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2578F611C7
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 06:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbhI1GMj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 02:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238814AbhI1GMh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Sep 2021 02:12:37 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3902C061575
        for <linux-cifs@vger.kernel.org>; Mon, 27 Sep 2021 23:10:58 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id m3so88158155lfu.2
        for <linux-cifs@vger.kernel.org>; Mon, 27 Sep 2021 23:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NXI/4FSGtBP5QyrUDUozYHA30fFsmmruOEpZVP79nZ8=;
        b=paN+G1E27l3mEIDnBIBqia4lABnAMNDhMvBPRQuK6Y9YGnsd77tyhOncrdTlnN4CZV
         I1xZHOY3MEVlIqkER3Hxo/62wL8O7IpEkuXOsZjnxCOW4vRuDaxnVSZLKxzNpj4RyWSo
         /64UJIn0sGWV8zOPxXtxpzSjy7DNRdiOglIFxII9GQHg+P/4cC8D4YvGdIsQib8sfWpS
         Jv6CCduJdOnr3A1T6bPKnO/aS9bfw168Or9tNr8Qu2qhFZtKiMefvjD/d69N1mHQINf3
         5s/nMZww7k/aKJq5IGz+ebpsPfus4iSxNhnM8h2GaOGnQ0vPijrQ+EZ87iDDP2Ow+Gu8
         OlrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NXI/4FSGtBP5QyrUDUozYHA30fFsmmruOEpZVP79nZ8=;
        b=bw9/xOwPKGn/3NSLcmKce07YtbSkpXDbAeipRUpfVi2aZ2bxLWb9YdAUI83pLXz1li
         p9yDOqcAhMpG1brQ6EvxON5KJsGGBl7hUlRitv99uQpDMSsbDikFxphQ+vmprijTdRz1
         We6poli1VQFvmFXEN+jihIo8xf2WF/Nl+j2Z0bqtvqJGZ5+BGYKyInJaR4Lj2aUK13S4
         KVGMBydc144HnoPEuDtzHOqAsENbPVvB2pAxEqrx5wxRSsywICeEkmWewz6OzJGZPM6t
         UDYBJ6ZuBNVbU070y0hPBZ7DBS2E/aFA3GSyhk6R2N4EYjMhmWkUyRRUZdW/e0XLSwuE
         svTQ==
X-Gm-Message-State: AOAM530WkVgUq9TQgBLvpHtPhs/h6kwua8Wmd7Jyng4PdMNL2zD6jVR4
        GJs8MUu7HfGkYKXZdSSdWZDSkimcjrJsgBF81x2p8a8I
X-Google-Smtp-Source: ABdhPJz8+7ClAF4H1FY7rX/CZ1Zmnt6GhefUGLVqsSv3ZTD4UM/YguW/WjuN/H4Wot3QgDOXSNyuZJ/Y6fdHAKRA0gQ=
X-Received: by 2002:a2e:4619:: with SMTP id t25mr4058951lja.398.1632809456911;
 Mon, 27 Sep 2021 23:10:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210928060404.6329-1-linkinjeon@kernel.org>
In-Reply-To: <20210928060404.6329-1-linkinjeon@kernel.org>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 28 Sep 2021 01:10:44 -0500
Message-ID: <CAH2r5muUHmKxrSq4QYZy+7kxjYh4uss3DctTLoUskWYRsy709g@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: rename cifs_common to smbfs_common in cifs
 and ksmbd entry
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifsd-for-next

On Tue, Sep 28, 2021 at 1:04 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> commit 23e91d8b7c5a("cifs: rename cifs_common to smbfs_common") cause
> the following warning from get_maintainer.pl.
>
> ./scripts/get_maintainer.pl --self-test=patterns complains:
>   warning: no file matches    F:    fs/cifs_common/
>
> This patch rename cifs_common to smbfs_common in cifs and ksmbd entry.
>
> Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5b33791bb8e9..8a8c0e6eb458 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4655,7 +4655,7 @@ W:        http://linux-cifs.samba.org/
>  T:     git git://git.samba.org/sfrench/cifs-2.6.git
>  F:     Documentation/admin-guide/cifs/
>  F:     fs/cifs/
> -F:     fs/cifs_common/
> +F:     fs/smbfs_common/
>
>  COMPACTPCI HOTPLUG CORE
>  M:     Scott Murray <scott@spiteful.org>
> @@ -10193,8 +10193,8 @@ M:      Hyunchul Lee <hyc.lee@gmail.com>
>  L:     linux-cifs@vger.kernel.org
>  S:     Maintained
>  T:     git git://git.samba.org/ksmbd.git
> -F:     fs/cifs_common/
>  F:     fs/ksmbd/
> +F:     fs/smbfs_common/
>
>  KERNEL UNIT TESTING FRAMEWORK (KUnit)
>  M:     Brendan Higgins <brendanhiggins@google.com>
> --
> 2.25.1
>


-- 
Thanks,

Steve
