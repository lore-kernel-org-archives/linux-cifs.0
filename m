Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4288EC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28E66603E5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241701AbhITQEc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238404AbhITQEb (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Sep 2021 12:04:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFDF4603E5
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 16:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632153785;
        bh=6JcnkKfV9OkuP9z1LF1tZNxM7zIb6cBISFWFMiDWZWA=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=tpG4AXJjTz/Y4lBKjMS3z7MzcEl3qtpiFT5D+pnhvIs6fKCmdSuvmCxYY31qcNwjk
         R6/aLANDTlSigVekGNBA7Sy9lgOvzsFrKWMGAccL5Xd5GTjSouHwbNIretQBwxTNBd
         v5SdUX+vwRJlOE17s7QiJHzxETQ9QpeWqJVGOGq7WoL2P84AmDbdtgVJHUM+3sDYYI
         m9h6qEmzurM53QcyL8Mp1H65AdiuFDlyH2+ETeJ9fEaoVtHatR9JHWXH3neUtzlu8S
         GDpRSQsxjbGtyqMLPgGplwzIwigqWP2eXtlxhN1iEn6Q2W0G2sdAfpO/E7V8vT11jC
         tLZs0xJpyDrjQ==
Received: by mail-ot1-f45.google.com with SMTP id c6-20020a9d2786000000b005471981d559so2742352otb.5
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 09:03:04 -0700 (PDT)
X-Gm-Message-State: AOAM5331XGJcDG3HMIO+/y755JtAbxPtKJQq4zjwt6wTSxO4zMnFjokn
        nKa2e4uyH1rRKXYNYbRAq6SyRBns43ZgS3dLkH4=
X-Google-Smtp-Source: ABdhPJxuSm+Lafi0WZ/yfFVvUShny7KhXbIsxPkjAPqv+z0VLIqtpGNaL0HMKxSzCxrnjk1jUaMxdCKRU/tVW2u84kc=
X-Received: by 2002:a9d:5e05:: with SMTP id d5mr21234522oti.61.1632153784391;
 Mon, 20 Sep 2021 09:03:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Mon, 20 Sep 2021 09:03:03
 -0700 (PDT)
In-Reply-To: <d42feeb6-51e6-e897-27ae-f66e8543556a@samba.org>
References: <20210920065613.5506-1-linkinjeon@kernel.org> <d42feeb6-51e6-e897-27ae-f66e8543556a@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 21 Sep 2021 01:03:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9h6-jz5C7SOTq+F4p0hGLkyu6_e0wRRv1Zy1K0gcHzZQ@mail.gmail.com>
Message-ID: <CAKYAXd9h6-jz5C7SOTq+F4p0hGLkyu6_e0wRRv1Zy1K0gcHzZQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-20 23:44 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 19.09.21 um 04:13 schrieb Namjae Jeon:
>> Use  LOOKUP_NO_SYMLINKS flags for default lookup to prohibit the
>> middle of symlink component lookup.
>
> maybe this patch should be squashed with the "ksmbd: remove follow
> symlinks support" patch?
I think that the subject is slightly different.
1. prohibit the middle of symlinks component on path.
2. remove LOOKUP_FOLLOW and  "follow symlink" parameter check.

Thanks!
>
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
>
