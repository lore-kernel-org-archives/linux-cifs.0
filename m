Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CE0C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 00:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A7C561251
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 00:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345825AbhIYApO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Sep 2021 20:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233410AbhIYApO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 24 Sep 2021 20:45:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 916D8610EA
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 00:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632530620;
        bh=Y0d+RAp4sGENxJ+flkJoPUEnoDoUI3IPVE/ntWUDFRE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=VN0W4buov6hUrnEBlCmzv+OesbKOi4U5ZksHCDN2cT6Mq2E735ulAYah/eaE9ouSD
         jqCPE7rifQCqZ3ch3ORmXPl24pY75Vk0itg/1TjtmUWQXz6toPLg/LzXb474KRrRMy
         OsiO0ws6AUTbMdByl2MNKTfpUphdUmXmKmvwAOq/mPxIXntZJ7tIcrWGGnVvIAyEQk
         Il3sopIome40SgNMDbSoP1z7xtT7xyUPRbIuZQQea07TqRols4+/72v0unjP0f6KHK
         df35c9G68/VyLh/9f8pAUaRqdzXlKSd33M+GjeSLRY4H8hMf5Zxlx08PJzBHPgog9f
         Eb9PPfSuBWrsQ==
Received: by mail-oi1-f176.google.com with SMTP id w206so16932351oiw.4
        for <linux-cifs@vger.kernel.org>; Fri, 24 Sep 2021 17:43:40 -0700 (PDT)
X-Gm-Message-State: AOAM530UDrP0z7sHMFADYjmv8XiXs1SUkGn9zvZ0SYntGRZmhcBKwGCv
        XqW/jz/sh4xu4rFgf/nY0C+L85k3S8GmqVHv7sw=
X-Google-Smtp-Source: ABdhPJwmLIsgxwOJNJL57h4El+3wwXOTI3gf6Hkh6jx+i+WMDhNjEBI99QlTReqCT6MZZCjwTdOOgcRZaY3TuCMwe+k=
X-Received: by 2002:a05:6808:21a7:: with SMTP id be39mr3735197oib.138.1632530619978;
 Fri, 24 Sep 2021 17:43:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Fri, 24 Sep 2021 17:43:39
 -0700 (PDT)
In-Reply-To: <20210924150616.926503-1-hyc.lee@gmail.com>
References: <20210924150616.926503-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 25 Sep 2021 09:43:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-XqKdgYSsQKJmDDjUyzqQcGfSjd5uJth3mnsRkAWjOjw@mail.gmail.com>
Message-ID: <CAKYAXd-XqKdgYSsQKJmDDjUyzqQcGfSjd5uJth3mnsRkAWjOjw@mail.gmail.com>
Subject: Re: [PATCH v4] ksmbd: use LOOKUP_BENEATH to prevent the out of share access
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Ralph Boehme <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-25 0:06 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> instead of removing '..' in a given path, call
> kern_path with LOOKUP_BENEATH flag to prevent
> the out of share access.
>
> ran various test on this:
> smb2-cat-async smb://127.0.0.1/homes/../out_of_share
> smb2-cat-async smb://127.0.0.1/homes/foo/../../out_of_share
> smbclient //127.0.0.1/homes -c "mkdir ../foo2"
> smbclient //127.0.0.1/homes -c "rename bar ../bar"
>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph Boehme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Looks good to me!
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
