Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A1DC433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 07:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67B4061354
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 07:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhJEIBF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 04:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232935AbhJEIBF (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Oct 2021 04:01:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A31661352
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 07:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633420755;
        bh=yfJ+/QVfqL5gCxmBWfyfU3GniIdwMLqBTbw6hs1nNLc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=FmCRGO1/wz+4Hpj04gg8rZUB8PvzhcgyEkf1gKAGF0rNWkJ4uyzVSfh4zoDCURHru
         OvCnATJeUGkLwkFi2r5yg6/mChmn/SqORig5muTgphbS7X+7hCb4zjWeJZaazfGdtH
         ypJ5JeKjh7TKP1Q0mzPc92W/R/c2qmadgTQVotqDjYYcrFJ01N70W8835H9y/VrOUt
         FR8CoAZVj84LMHJO2peecGv2wqveNiFqt2xwzpYjqXr2nlWcUUCh9oOD6DLJse1yJU
         FIHegdpAQFpS+roMwsZw9+UaKDUK6++h5h5L4XP8t3rRij5NgaOpYAqL2mgHgu15Ex
         jKad84oDl6s/w==
Received: by mail-oi1-f177.google.com with SMTP id v10so916131oic.12
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 00:59:15 -0700 (PDT)
X-Gm-Message-State: AOAM530x3Lwt350YFOQUtx1dbLhx5JfnFqcnSdzVr+nTPCxijvS5n9jt
        Cen70igGHT4BXHnNaN7mPuogOJ4eE1gACP1zp+0=
X-Google-Smtp-Source: ABdhPJzMt6qCov4iWBcnu1gBn1DrN+p+pvOA3q3SVOwLogJ/G76WIw3Z2UKmSixTRTrXB1DLH+MzetNeiFyeDPGqxs8=
X-Received: by 2002:a05:6808:64f:: with SMTP id z15mr1286107oih.65.1633420754415;
 Tue, 05 Oct 2021 00:59:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Tue, 5 Oct 2021 00:59:14 -0700 (PDT)
In-Reply-To: <20211005050343.268514-7-slow@samba.org>
References: <20211005050343.268514-1-slow@samba.org> <20211005050343.268514-7-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 5 Oct 2021 16:59:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Cvsj_ACppqZJ9KnVCpF=CMUKEOVWyNzHzE=yc4fobww@mail.gmail.com>
Message-ID: <CAKYAXd_Cvsj_ACppqZJ9KnVCpF=CMUKEOVWyNzHzE=yc4fobww@mail.gmail.com>
Subject: Re: [PATCH v7 6/9] ksmdb: use cmd helper variable in smb2_get_ksmbd_tcon()
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-05 14:03 GMT+09:00, Ralph Boehme <slow@samba.org>:
> No change in behaviour.
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Ralph Boehme <slow@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
