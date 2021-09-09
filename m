Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70ED7C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 04:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 403D061090
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 04:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhIIECf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Sep 2021 00:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhIIECb (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 9 Sep 2021 00:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6238461176
        for <linux-cifs@vger.kernel.org>; Thu,  9 Sep 2021 04:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631160082;
        bh=1+DU+s5l5MFKpP3wDS6abSFCoVxm9tgm7WBBYypRr+I=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Hxf8cf4TAAtQmd+OwoXLcWFP0c+Q8imVmrj1UgQuv9xsrVwh/rbNC9dVyrPFy4MtD
         o9qfszJq2g9LLOpAxniWMt5MEkWE51zhYQtQaiQadVO90K4p1LTcmaj+TDL2rK/Mzt
         ieyYgC/ni34KwrxZdso1ZCbKaJbGgyAGkEjUw/mbsF46v8Esb+mYH5L8SXsa36WPeM
         XNL261Wh/AWxG1tUpckX5Y/KMlJv3mnpGeM83XIcEngYquxBakWupyP5U+NlRl5927
         Sjan4lywg7upjs+mQx/is1SehZ0NUHCi9O32fc7qDpPzPYTkaop5Ar86OHbMJDv4r4
         JiUUr04ENswFQ==
Received: by mail-oi1-f178.google.com with SMTP id q39so859421oiw.12
        for <linux-cifs@vger.kernel.org>; Wed, 08 Sep 2021 21:01:22 -0700 (PDT)
X-Gm-Message-State: AOAM5306cbZ738xuH3FBTIy9VjJlNWFzN7sQvQVgv2LNu9kPdi3GUvFv
        EOHXQpGGcaRM7pSTB7G5/IBi5pZevRLYfFD8zEc=
X-Google-Smtp-Source: ABdhPJx19XkRDWzV2vKuoKe4YZP+SP5k4w7aQFHuqhvDRvl3zh/NKZ+0C3IXnMYhNI1xkbNX52R7Siy29rk+spVI8Dg=
X-Received: by 2002:aca:1b19:: with SMTP id b25mr642397oib.138.1631160081748;
 Wed, 08 Sep 2021 21:01:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:74d:0:0:0:0:0 with HTTP; Wed, 8 Sep 2021 21:01:21 -0700 (PDT)
In-Reply-To: <CAH2r5muuLpCj2W1JFUm8UqvLhb6Js+qR76pTMmWu4jiyzV6QEQ@mail.gmail.com>
References: <CAH2r5muuLpCj2W1JFUm8UqvLhb6Js+qR76pTMmWu4jiyzV6QEQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 9 Sep 2021 13:01:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Ld1X2tmeBQkDEWd6rzW8xDNsO+SgR6adifgnKtRX7Ug@mail.gmail.com>
Message-ID: <CAKYAXd_Ld1X2tmeBQkDEWd6rzW8xDNsO+SgR6adifgnKtRX7Ug@mail.gmail.com>
Subject: Re: updated smbfsctl.h to allow for future common version
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-09 11:50 GMT+09:00, Steve French <smfrench@gmail.com>:
> Here is an updated fs/cifs/smbfsctl.h that includes most of the changes in
> fs/ksmbd/smbfsctl.h and is updated to include one missing #define from more
> recent MS-FSCC
>
> This would allow us to use a common version of fs/cifs/smbfsctl.h for
> server and client
We need to rename header guard in diff when moving it to fs/cifs_common.
+#ifndef __KSMBD_SMBFSCTL_H
+#define __KSMBD_SMBFSCTL_H

+#endif /* __KSMBD_SMBFSCTL_H */

Thanks!
>
>
>
> --
> Thanks,
>
> Steve
>
