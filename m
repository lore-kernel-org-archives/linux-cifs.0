Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B1EC433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Dec 2020 05:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31DEC221EC
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Dec 2020 05:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgLaF5F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Dec 2020 00:57:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51519 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgLaF5F (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Dec 2020 00:57:05 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <sergio.durigan@canonical.com>)
        id 1kuqwh-0004hS-Bx
        for linux-cifs@vger.kernel.org; Thu, 31 Dec 2020 05:56:23 +0000
Received: by mail-il1-f200.google.com with SMTP id z15so17056897ilb.3
        for <linux-cifs@vger.kernel.org>; Wed, 30 Dec 2020 21:56:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=3AlNnr4Oy4fxytiIyy4suuWLnc8bFTRZn+C+ovKoyFo=;
        b=D8eSXp4W4CQCLFG/bRc1KzyGP4Lspe6CufNRq1T7wvJcc4QcFwjoDclA0m6ZlLvUbq
         u5TdLvuhsFCSEHPEerYXGrm9eUyErOY4IcIFx+ib1lDBkTNa48to6+75lOpVV3Sxg0wL
         QaLHluk6nwPEY2GpdMgFKOmYB5R4Rl+Ntx5x9yjMQUOUCoOjbuDmH4MxqzlusUxj9ikA
         LJbQXzcz6l1gQ5Tvm9w7E3g7cHv/A5550vGUkSbG0df5/nJz7z7yOkSXgUATUUBnf3eb
         9SYKTJ0hYADBPGm9pXlQIvPB6kZrZPyzzYNcdOHfrSCRbTKTtMtjuvd5lhL7jxMBhGXB
         ZqpQ==
X-Gm-Message-State: AOAM530tQw/vBSykOus4fiDK7AubarMWtrpBjvT+yMzRzN++kr1V3JWz
        yzZ6VKK9Y7jgZWW4nbBlptRabDQCf/Ojey2nnjN+h6KE+MtAY2M/US7vSnDLCdVzgHWlmFdyqsH
        InK6TM8JgtkMPtee5gw0JSMp3VV7kaSwfi3TQmU4=
X-Received: by 2002:a92:cb43:: with SMTP id f3mr52887243ilq.50.1609394181942;
        Wed, 30 Dec 2020 21:56:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyfI7j8lr/j+2AAdCAJk6vVs+J5pir1JHrkYAfDq35Wq8yZrkIeWAcqZb3vJ8GQ94ZysCv14A==
X-Received: by 2002:a92:cb43:: with SMTP id f3mr52887236ilq.50.1609394181717;
        Wed, 30 Dec 2020 21:56:21 -0800 (PST)
Received: from localhost (bras-base-toroon1016w-grc-31-76-64-52-221.dsl.bell.ca. [76.64.52.221])
        by smtp.gmail.com with ESMTPSA id m7sm34288668iow.46.2020.12.30.21.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 21:56:20 -0800 (PST)
From:   Sergio Durigan Junior <sergio.durigan@canonical.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] Separate binary names using comma in mount.cifs.rst
References: <20200609180044.500230-1-sergio.durigan@canonical.com>
        <CAKywueTDHV112-y125ROPK2aa+w6A1Fd_4x82YVEU6LauaAS9g@mail.gmail.com>
        <875z4ug4ax.fsf@canonical.com>
        <CAKywueR6hUyUt+RWbQi6rBDLWYun08aXgPa3VyXD+V5u-w5ZkA@mail.gmail.com>
X-URL:  http://blog.sergiodj.net
Date:   Thu, 31 Dec 2020 00:56:19 -0500
In-Reply-To: <CAKywueR6hUyUt+RWbQi6rBDLWYun08aXgPa3VyXD+V5u-w5ZkA@mail.gmail.com>
        (Pavel Shilovsky's message of "Mon, 28 Dec 2020 10:08:07 -0800")
Message-ID: <871rf6fri4.fsf@canonical.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Monday, December 28 2020, Pavel Shilovsky wrote:

> Hi Sergio,
>
> The recent release included only a security fix -- see details below:
>
> https://lists.samba.org/archive/samba-technical/2020-September/135747.html
>
> I am planning to make another release soon which will contain all
> patches merged into next branch:
>
> https://github.com/piastry/cifs-utils/commits/next
>
> Your patch is already there, so it will be included into 6.12.

Ah, thanks so much for the reply :-).

-- 
Sergio
GPG key ID: E92F D0B3 6B14 F1F4 D8E0  EB2F 106D A1C8 C3CB BF14
