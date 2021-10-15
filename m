Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AA4C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Oct 2021 02:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9059460F4A
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Oct 2021 02:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbhJOCLJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Oct 2021 22:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229938AbhJOCLI (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Oct 2021 22:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56B0E60F4A
        for <linux-cifs@vger.kernel.org>; Fri, 15 Oct 2021 02:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634263743;
        bh=MY2Y6t9qe9Sth63v3mMxCujh/pidCy1fVMzedCo5dFo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Zml+9eYfAjC6rUEkkdV327MlnHghWH0QA+e7k8xPOcxvaWikN7DpzgQ1A2LHFQZDD
         hL4g9pwaav4z1PumopXAsgm7S0RH3qIRFDGNS/lfQlZV7M2PMa+Hk+HFZf55/SvQ4p
         fuWvnPD2F9OGjUMjdV80nr9aqhpQ+Qvf2lYQMyfcRtlb0+D6V6Qxfc4upM+J1CjhaD
         WCTF5egbDCrdaRjp2gQvDVpUngCFvxMK2GuZAZcckADyg3afYIb/Ic3jHYgEOkvvxk
         tqCPuhopQOKXYOMMHz0KrIwFM/uqPhYudwuDk9U8cecMWOQOmZM1rui64ZVRM3vzKd
         Tlxc+LesKzxfQ==
Received: by mail-ot1-f45.google.com with SMTP id e59-20020a9d01c1000000b00552c91a99f7so1509931ote.6
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 19:09:03 -0700 (PDT)
X-Gm-Message-State: AOAM533/RaIwNPg612kOifRnLBm7eQSshcwnjcDdMy2c4VKNh5ri9PMP
        KL6O38sOfTKiOHa8k8OaRNIDErIH5MJc+HwPApk=
X-Google-Smtp-Source: ABdhPJwcff3tHtXDmeExaRg/yD88nlh10LgJfikWzXG0NZZZ2ltu87gFJ8uknNbgotfoDT+S9S/VA+aXuJmERICiHQ8=
X-Received: by 2002:a05:6830:17da:: with SMTP id p26mr5761707ota.116.1634263742668;
 Thu, 14 Oct 2021 19:09:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Thu, 14 Oct 2021 19:09:02
 -0700 (PDT)
In-Reply-To: <20211014150838.19339-1-ematsumiya@suse.de>
References: <20211014150838.19339-1-ematsumiya@suse.de>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 15 Oct 2021 11:09:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8EdvkPVWQztbPcZZQUwAFpp959Psk7fpwdG4_KDxXREA@mail.gmail.com>
Message-ID: <CAKYAXd8EdvkPVWQztbPcZZQUwAFpp959Psk7fpwdG4_KDxXREA@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd-tools: update README
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-15 0:08 GMT+09:00, Enzo Matsumiya <ematsumiya@suse.de>:
> Prettify README with markdown and fix some typos/commands.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Applied, Thanks for your patch!
