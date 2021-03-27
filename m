Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DF7C433DB
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Mar 2021 05:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0921361A0D
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Mar 2021 05:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhC0Fme (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 27 Mar 2021 01:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhC0Fmd (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 27 Mar 2021 01:42:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 282B161A1E;
        Sat, 27 Mar 2021 05:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616823753;
        bh=loaJcrol/PTRVMRrsww1gLT50nDJ8omknyueW0Pevuk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=DzV1szVcasJX5KBkovy9pnJvfQVw3rx/z5xQOT2C8Dei+lW9UITUAVapAFTENymXn
         Mf7DW9BnhTrjeLrXw1aMATkiBOwblGGD+kp2LDK6Qo/aAfa7Z7MsMD6Pzy9YbtjBCW
         aEr/VwSg1EeZaiWQ0UOxv7W7kmEqcsyThfIymufeMiNLI2+QagnvfIJRMNz2oCmEmU
         U2S659OMtVBW6nAG31W3cnDIERaR3MjUeeXkXpRnqDjTM4sX5SivWoyC6kpCk99oIO
         R6b+ETVQxEk0IgXH4iL96HMXb3/5Hf5lDFDTENIAtca8qV/S0gkBGiyTULpHSYf/Ol
         UiE4FkKdUhEcA==
Received: by mail-oi1-f170.google.com with SMTP id n140so7888117oig.9;
        Fri, 26 Mar 2021 22:42:33 -0700 (PDT)
X-Gm-Message-State: AOAM530c+ujf9rCio6u2vtJNwYAMRAvl6k+MkSZoEaef/9cBA7SaJ1Mq
        8q2RSCKLpwNE6EmV/K3b+vWaoVuYaonmLme6+q0=
X-Google-Smtp-Source: ABdhPJyvRS6aynjHHQh55zHTQ+0rKLujRGaTPDJMYHWtytR3lW7/FhxKm2w9LM3ja1dm8hur3M7RhkKrW1VvJM3fwBY=
X-Received: by 2002:aca:f4ce:: with SMTP id s197mr12125327oih.94.1616823752543;
 Fri, 26 Mar 2021 22:42:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5ed4:0:0:0:0:0 with HTTP; Fri, 26 Mar 2021 22:42:31
 -0700 (PDT)
In-Reply-To: <20210325173538.485917-1-colin.king@canonical.com>
References: <20210325173538.485917-1-colin.king@canonical.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 27 Mar 2021 14:42:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Zq8FJ6sZZTTSBxuMpSdQ9rzeb_JEnOx+kQnXENHxhtg@mail.gmail.com>
Message-ID: <CAKYAXd9Zq8FJ6sZZTTSBxuMpSdQ9rzeb_JEnOx+kQnXENHxhtg@mail.gmail.com>
Subject: Re: [Linux-cifsd-devel] [PATCH][next] cifsd: remove redundant
 assignment to variable err
To:     Colin King <colin.king@canonical.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-03-26 2:35 GMT+09:00, Colin King <colin.king@canonical.com>:
> From: Colin Ian King <colin.king@canonical.com>
>
> The variable err is being initialized with a value that is never read
> and it is being updated later with a new value.  The initialization is
> redundant and can be removed.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
I will apply. Thanks for your patch!
