Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41596C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 11:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2083C61156
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 11:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhIULQv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 07:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231956AbhIULQp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Sep 2021 07:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B95A61156
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 11:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632222917;
        bh=Qoci1Ff51drE6WZ2ogtrtyCmqFQ1E6wW3cObM9gBDlQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=VWnlrfAa/3pAKoOTZKfHFUBkXAISIUq9xzfyBNukfLc/xTDf9oDFOjYYQF1/alAhE
         6WlknAFe15j8hBWUwbVSVGNekgztrVyfu8HCSwZkal0kFidDUGWLxV8jhlNFThUYIY
         h6qbW9ef1HAvCnk39ZJEasBh+HH/fE+XGuduU3cQCufKSfWP1qPPDIm06OPCUFb9A0
         5XwY/CcRj7hiwJAOjfAlKzev1+p5cO10CnXsozuPhU4vgFDEKxqcpr28yC5rwd+b08
         HAE6s8GqbYfUs/a4/Coau/PgmREPTHD/nMl8EJnTGQghJgqGgoKLsobpO7PQ4mDF+Q
         a/qd3fOzArL/Q==
Received: by mail-oo1-f49.google.com with SMTP id y3-20020a4ab403000000b00290e2a52c71so6939886oon.2
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 04:15:17 -0700 (PDT)
X-Gm-Message-State: AOAM531Mi7IAiMvey0LVVEOFLOl54Py+gD7G/o8HP5nTpUK8CAS21vXn
        JlGkg7c7AgMo62qtmN9rW4abs+D7tx74l7iGzoY=
X-Google-Smtp-Source: ABdhPJz4hB6Io/gsQeTwnbxTIRMXXiysRfxLlwCM3naDx03ScjVZuLGJHNXOpXn2NNiCoyOKcUim4hrYY7gE4VvY9lQ=
X-Received: by 2002:a05:6820:1016:: with SMTP id v22mr15056790oor.27.1632222916626;
 Tue, 21 Sep 2021 04:15:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Tue, 21 Sep 2021 04:15:16
 -0700 (PDT)
In-Reply-To: <e053bc26-0170-0d48-3542-e3e8059735db@samba.org>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <20210919021315.642856-3-linkinjeon@kernel.org> <e053bc26-0170-0d48-3542-e3e8059735db@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 21 Sep 2021 20:15:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8bGxP++U=NsFCnZsUQbPRr-+uJmwWt_TCUPi4uj4y+qw@mail.gmail.com>
Message-ID: <CAKYAXd8bGxP++U=NsFCnZsUQbPRr-+uJmwWt_TCUPi4uj4y+qw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ksmbd: add validation in smb2_ioctl
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-21 17:08 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Hi Namjae,
>
>
> Am 19.09.21 um 04:13 schrieb Namjae Jeon:
>> Add validation for request/response buffer size check in smb2_ioctl.
>>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>
> the check looks good. May I suggest to also pass the pointers to the
> structs instead of the raw buffers consistently, same as we do for the
> setinfo levels now?
>
> We still pass the raw buffer to fsctl_query_iface_info_ioctl and
> fsctl_copychunk().
Hm.. Let me check it. maybe will fix it on another patch.
>
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
>
