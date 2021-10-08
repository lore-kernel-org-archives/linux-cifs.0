Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F30C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Oct 2021 01:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4054860FE8
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Oct 2021 01:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhJHCBp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Oct 2021 22:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233169AbhJHCBm (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 7 Oct 2021 22:01:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2DE361039
        for <linux-cifs@vger.kernel.org>; Fri,  8 Oct 2021 01:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633658387;
        bh=DbS+P56iCeRryXc2+m9wNel10vnZza2iCp9TIKxr6vQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=igXAXMnHbunPsW2miiBfZa01HM7LeUdGpFnJIgK3GtbTjOoWLXdWYFQGGXhKogtfI
         7CbR5uPAnbRfXW+4OZI64+eVdg1yeGN4JImjm5Hu2UtT5cWXP3QqOEStByDFY5lNDi
         73hR3Q5B4AtkSgGYIWdp91xwmh/12Ef2mceGu3AzLiZMhjef5DYC1iDqyD+ypPoYE3
         Z76zzMWAt9/L1QX46rAh6YuRtWmPqtA/ihU3+0ew2ezC+7ytJ0BcmlhJaObB66M7iY
         P4YWmtrfltFeXNOJco7jxK0ha3mM5jEO2IXSITME3v7uv7TYRIdoQqiVgP7mHjZK4m
         MAA4R0m5lPfnA==
Received: by mail-oi1-f171.google.com with SMTP id s24so11698768oij.8
        for <linux-cifs@vger.kernel.org>; Thu, 07 Oct 2021 18:59:47 -0700 (PDT)
X-Gm-Message-State: AOAM533gG2+m7+35uMeVB9Bxi4+wm4zXWvqZc+hgB6f3kDIl83kQoxoP
        /gaBOY4YP9WBFjRdJe+RmGyBujwKAcAgc4I9IRo=
X-Google-Smtp-Source: ABdhPJx9xlW3YnsPnWlTZ3ss8WnoitNO2emm+I7Z9cTWVCmJVcD0Jj4YeztlmF6IXtz0y2ud1coOQmnyfHs+t+Mwv9Q=
X-Received: by 2002:a05:6808:287:: with SMTP id z7mr5804112oic.8.1633658387354;
 Thu, 07 Oct 2021 18:59:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Thu, 7 Oct 2021 18:59:46 -0700 (PDT)
In-Reply-To: <20211006161431.4638-1-ematsumiya@suse.de>
References: <20211006161431.4638-1-ematsumiya@suse.de>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 8 Oct 2021 10:59:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_V7+QAwi8QpD6a5Z9zbqtrEw-ZEjk8cp=mZnwb7_HtHA@mail.gmail.com>
Message-ID: <CAKYAXd_V7+QAwi8QpD6a5Z9zbqtrEw-ZEjk8cp=mZnwb7_HtHA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: update names in logger
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-07 1:14 GMT+09:00, Enzo Matsumiya <ematsumiya@suse.de>:
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Applied, Thanks for your patch:)
