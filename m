Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38642C61DA4
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Jan 2023 15:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbjA3Pn7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Jan 2023 10:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236320AbjA3Pn5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Jan 2023 10:43:57 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677FA3D938;
        Mon, 30 Jan 2023 07:43:56 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id b14so256878ljr.3;
        Mon, 30 Jan 2023 07:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DilJcfGDasqC97KmooB5AfInxubuvWnnOroxtRaylXo=;
        b=pviCkOjxQwgB4M2HxUN+JUzEkbHyzEA3VNmug0VwZ4tqoZ7pDBI1C/ipu/m5+1nYST
         WMw3KjHsWtadF+0ImMm1gv71XWzc0GATZz8M8ya2h8otA4mJxKI+NI51q2/7CZPGMw3D
         5iiA5IB3SjGuiW3sbKgZoEOcN2nU5i9DADnP6qHkgL+i/JLsG4padKPTDFvv+9qKXSvC
         xLXZD13BJzI89itbR9/E7bykok+TpHI6t04zwXO+vzN/WlNo98yTxYg1RZFRhlTDM2+B
         FKpuO5CudX21db0S4Dvu3LQvsAAdF1uKXD8cVmmVoue6O5GPdjA68g3iMpbIxKUtGzX/
         omog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DilJcfGDasqC97KmooB5AfInxubuvWnnOroxtRaylXo=;
        b=H8aKdXAN6TyxHqosdNsBfeKlVcyZaM90mW4Hyu7kZvnKYPGqpQyDEcXQ/imSLLr4QP
         g2liOJG6zwVPtp3WgG4j/my+u9FVgYCSzKYs2o1d0DU60LcVbG4+APlHXwSawXWP3y+y
         I8y8mY9WtIhaeunzAC8BcJbe+gh+qsEVEZmI6855YWSVzcYdBklLovdxUJdFJSdtCs7y
         SNihN4dxQ2ab1eeP9o1pdeUf19Cf+cj186MMY51LYPKYVdmy1pAmDmMaVOwk1iBOjYHM
         xKdQaFI1se3aQtrefZOd7yS5y5VU9Er0x9/QBX7HB8spjo5jRPNibCNdP5CLLaEYoX8d
         BPKQ==
X-Gm-Message-State: AFqh2krYHtxH6b68KYWHOMqWrsMjqUAUsihy/EWrPVPn9/CwPc7l3jci
        5Bdz+rZcracWOfpPwtdkenZvjU4CaTUAhoY11fM=
X-Google-Smtp-Source: AMrXdXt1gcHUMGP/1TtmrLEEG1lqDpcAxpyANu9CAsIdShc7VsiOjTGTcu6qPdMLuwzJW5KpVjIStNLlxwdV8KIU7qI=
X-Received: by 2002:a05:651c:481:b0:28b:a09b:b02e with SMTP id
 s1-20020a05651c048100b0028ba09bb02emr3234836ljc.106.1675093434419; Mon, 30
 Jan 2023 07:43:54 -0800 (PST)
MIME-Version: 1.0
References: <20230115103209.146002-1-set_pte_at@outlook.com>
 <TYCP286MB23235FDD8102162698EF3154CAC09@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
 <Y9dEZ5IgfwpZNlVm@google.com> <TYCP286MB23230E29CC81F5C0590C59C9CAD39@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
In-Reply-To: <TYCP286MB23230E29CC81F5C0590C59C9CAD39@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 30 Jan 2023 09:43:43 -0600
Message-ID: <CAH2r5mttK-QTZWkVzB=GsdgiKtv4Y+CtFm=sW7JLO6K3U1mFOw@mail.gmail.com>
Subject: Re: [PATCH 3/6] ksmbd: replace rwlock with rcu for concurrenct access
 on conn list
To:     Dawei Li <set_pte_at@outlook.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        linkinjeon@kernel.org, sfrench@samba.org, tom@talpey.com,
        hyc.lee@gmail.com, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jan 30, 2023 at 8:17 AM Dawei Li <set_pte_at@outlook.com> wrote:
...
> Steve, Namjae,
> Please drop this buggy patch from ksmbd-for-next.
>
> Thanks,
>      Dawei

Done


-- 
Thanks,

Steve
