Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1B9C433FE
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Oct 2022 18:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbiJFSTq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Oct 2022 14:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiJFSTl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Oct 2022 14:19:41 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4276F616A
        for <linux-cifs@vger.kernel.org>; Thu,  6 Oct 2022 11:19:40 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id n186so2830905vsc.9
        for <linux-cifs@vger.kernel.org>; Thu, 06 Oct 2022 11:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=lZAn0nc20ZSyu2thsRn/Tj7cNaQyvi2UZJAOsvF4BlQ=;
        b=daGdrzrc5o5rRc5vGwqSwIeYm7Mh1AZPs0ePiUur68WtEzHBcIhLpPaJtCLqBbBuM7
         4qtpTomSrvmIXsREz+y0Z6/XRuHKpCO4rAKUZKl9cEBx5tEvV/mDhs3g+7ERCBg0vRsf
         nlCkJiFFxzkbMmkmHO/QqkXmSvbVxK5SBhXFgMPYJX37CuzZ8SvobF1bkPimRDckXk7C
         MrulpME8IKzrnUBKjdaklB8j/3WSFl9mEyeYiJgYRXdh0UXkwUTS9BGGKueuOPsfPlsf
         iXo57iwc838tM+ulwWFZNzKGOdPvIyH7girRGj954WxCTiAlAYrekLuq4lTpa9Kj3qYt
         TFZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=lZAn0nc20ZSyu2thsRn/Tj7cNaQyvi2UZJAOsvF4BlQ=;
        b=Yb8mWenWJ7DkJHgvDIjwVJibDSWUi0UXPKDMS1bpQrMxteWDUntKSfcTDautXw/Dfk
         zhgcTsZJ9lorNAxeQfTH7R9sCZXOYaUhcS+OMMyt4T+h4xsCBZxhiXMDm6Xl4cYprjKc
         1d1+cWKivG9hs+QFrT8OeYFUqfBFWRsnY6vv4hfQBgN7LMmoIQ5f1Doc5MDVkZuVG0sD
         rjG5lgsqflVwGJ+T0W8922zY8C2E0tpcEktWStJPn4Ou90FOnM87e8hvi5ce8UiUQ8jT
         aEkLMZ2oWngs3eiFaxwLro2CeQ7caYZeoicJsQRoxTDnsFSh9blrAMU6dT54NsU+CPSY
         5Vxw==
X-Gm-Message-State: ACrzQf3FKy073JUxNZthOuO/mh/c1R75IJ66T4/l1CAEgc5qsyp9zGms
        Nkc6ZF6NMmverTLKo4kcsM8n6QXGM1uYp11z0V4=
X-Google-Smtp-Source: AMsMyM6LYZHChCSVA4dq/kWFMPqdj1yU9NVfw9/LfL+G6tUmcWQr9ydPOFLl4HZLj33v/3O5XKIqdCOZeoPfa6b8wFw=
X-Received: by 2002:a67:f603:0:b0:3a6:ff45:997e with SMTP id
 k3-20020a67f603000000b003a6ff45997emr877666vso.6.1665080379233; Thu, 06 Oct
 2022 11:19:39 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 6 Oct 2022 13:19:28 -0500
Message-ID: <CAH2r5mtt7TCJJ12nzSF3NeZpBwV9wbu03N4amGhhY7mGL90T2g@mail.gmail.com>
Subject: missing multichannel crediting patch in Linux client
To:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Was looking through old patches and noticed one from Aurelien that
looks important but didn't seem to get incorporated into the current
pick_channel code on the client.
It looks like without this patch we could have cases where we assigned
requests to a channel which was out of credits rather than one with
enough credits.
round robin channel allocation is probably fine for many cases except
when other channels have more credits and this channel is short of
credits.  Thoughts?
It might explain some of the perf problems we see with multichannel
not scaling as well as expected on some workloads

"Subject: [PATCH] cifs: try to pick channel with a minimum of credits

Check channel credits to prevent the client from using a starved
channel that cannot send anything.

Special care must be taken in selecting the minimum value: when
channels are created they start off with a small amount that slowly
ramps up as the channel gets used. Thus a new channel might never be
picked if the min value is too big.


-- 
Thanks,

Steve
