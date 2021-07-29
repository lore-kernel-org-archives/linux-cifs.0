Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CE7C4338F
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Jul 2021 22:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B734E60F6F
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Jul 2021 22:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhG2Web (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Jul 2021 18:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhG2Web (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 29 Jul 2021 18:34:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4A9660F5E;
        Thu, 29 Jul 2021 22:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627598067;
        bh=zomzZNfjR8p+XnfC2Ygez//VpjpDJhcWVwtbsVajGZE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=u9pYx5HPjUcguJUWuZ3CXUOA1cUY6WMmhzShjlTT16ASyqfnO31mZYzzr8ZLzHmb+
         pmMAhRJIdbiwPVemK4PtuQ/U++NcsiJpS0Y9VsWxaedUTRlo69DhrWxd8lCCi/oT/T
         NuWdLy1ptYxZKOPqCjZy/utKChZaMmRbvPjCpCDen8RY9DBnTS3y3rDldA+lG/QiQX
         D4bMd21++NamRkpoYTY1cmQ/mjw/hSD+MhQ2aMuYtkGkcFkdhCiiIMD8JNu8vWTAYo
         d8ap60LCF03UKjuIkCe1cKrhNzCyoYt8lWxusxvK+QGOR4zJp7Y+eE1LgrWgVWC524
         vrrhePm9IzNLg==
Received: by mail-oo1-f48.google.com with SMTP id s21-20020a4ae5550000b02902667598672bso1960789oot.12;
        Thu, 29 Jul 2021 15:34:27 -0700 (PDT)
X-Gm-Message-State: AOAM530KXDyaDbvxk7sFUFyGbe0ShAnJ8nG3bQk3c9kr8Li566vNreub
        yRZJR8mCDKqqmrElXq1tddhwZk33CYoGgi4obwo=
X-Google-Smtp-Source: ABdhPJweEgBucApLcnd9Jb/lRMVDGvXqX4x1eyUtjZAcbMsS1od7T87oBIZaspAKPDGc+OJsWglCPWhODueQlz2e91s=
X-Received: by 2002:a4a:da0f:: with SMTP id e15mr4473094oou.53.1627598067214;
 Thu, 29 Jul 2021 15:34:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5a4e:0:0:0:0:0 with HTTP; Thu, 29 Jul 2021 15:34:26
 -0700 (PDT)
In-Reply-To: <20210729141534.GB1267@kili>
References: <20210729141534.GB1267@kili>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 30 Jul 2021 07:34:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-GOQ08YZeCu=3D8pTOa6Zq36QhtTvQ9yp=RgPXF1ifEw@mail.gmail.com>
Message-ID: <CAKYAXd-GOQ08YZeCu=3D8pTOa6Zq36QhtTvQ9yp=RgPXF1ifEw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix an oops in error handling in smb2_open()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-07-29 23:15 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> If smb2_get_name() then "name" is an error pointer.  In the clean up
> code, we try to kfree() it and that will lead to an Oops.  Set it to
> NULL instead.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
I will apply, Thanks for your patch!
