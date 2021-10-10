Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE78BC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Oct 2021 14:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBD0A61058
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Oct 2021 14:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbhJJOdL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 10 Oct 2021 10:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232020AbhJJOdG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 10 Oct 2021 10:33:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF956610D1;
        Sun, 10 Oct 2021 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633876267;
        bh=I5e0if3bbAU39SnKM3+lyercJe2Dv9qbSOpNHhwJ3lw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=UfEB53pD2h3DoSLZ4v24QtQFLcI0BYyc3QmBwIqax5EMDsrvKc3KYS740mTqAIiNC
         KCTOmHm5UKS2gPJIzITSUQ18zqPE7j1JrqL2fdLgmOMPbzGLseY+l49Bb5jHoor75k
         ZyZvU3Wistn+gs5W9wcRUiF5oUnZk+RvtRShp+DO/PrWJEhWz12eqaUISaM7lqGK7X
         6dlqL+2AF3KgsgDBBxeoUA2GFvUK/peMYueZfUSK/9j2vuElI7mx3loz6hmbdK8h5Y
         fptAcOT16cuYmnofcHNLu4s1lXz9TO14v8f6hb1b5RNmhHNUwcEixYLsgnpoAAUQDl
         Uy4eDjLmaVF0Q==
Received: by mail-oi1-f172.google.com with SMTP id y207so17780582oia.11;
        Sun, 10 Oct 2021 07:31:07 -0700 (PDT)
X-Gm-Message-State: AOAM5306w0GUsXmg9Hoc/HzPFQO4GoYACyVGheIyelX7b4Yy93r7ktox
        2+rnq3mtxI2DdM1mWPoXva7xI9xUgguP2i1GJi8=
X-Google-Smtp-Source: ABdhPJzuEbRMimOqMlVA1uO1swo+5suU12k4mo3OU9BjZUtb7X8cT3lOM4rXmlrXXK5ljjnya+AOsRjc1BDNP8hEcdY=
X-Received: by 2002:aca:b5c3:: with SMTP id e186mr24004139oif.51.1633876267173;
 Sun, 10 Oct 2021 07:31:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Sun, 10 Oct 2021 07:31:06
 -0700 (PDT)
In-Reply-To: <bf5648ef0933536661e42cc73aa06722522d5862.1633872027.git.christophe.jaillet@wanadoo.fr>
References: <bf5648ef0933536661e42cc73aa06722522d5862.1633872027.git.christophe.jaillet@wanadoo.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 10 Oct 2021 23:31:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_uOE9T47+xDJTvNbZQvsxCPUozTj-Se0tsRPi1EpXtmA@mail.gmail.com>
Message-ID: <CAKYAXd_uOE9T47+xDJTvNbZQvsxCPUozTj-Se0tsRPi1EpXtmA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Remove redundant 'flush_workqueue()' calls
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     senozhatsky@chromium.org, sfrench@samba.org, hyc.lee@gmail.com,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-10 22:21 GMT+09:00, Christophe JAILLET <christophe.jaillet@wanadoo.fr>:
> 'destroy_workqueue()' already drains the queue before destroying it, so
> there is no need to flush it explicitly.
>
> Remove the redundant 'flush_workqueue()' calls.
>
> This was generated with coccinelle:
>
> @@
> expression E;
> @@
> - 	flush_workqueue(E);
> 	destroy_workqueue(E);
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
