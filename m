Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107D4C4743C
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 11:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E69A7610F7
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 11:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFWLSK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 07:18:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230031AbhFWLSK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 23 Jun 2021 07:18:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TpUqeJ0SjeP2ZHG2cawop1b7ObM1FUMLtRLSHx3qa/c=;
        b=H6HSPoaPiI/a1QputZtfKQDZ5mlh0kteWDvP+ldO5lMt5ANaygexCRD3lsnEfqYI9bVwDQ
        T00rgHasnW6WELrBh7QLtP0g7wOGU/kuSc5cvCLWnhxj7XqlZB1IscUwtGUBNGS3dM9N3T
        X40a3AfHIZ1SmGMAnUQdDdgI17jpCxc=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-3Y57gMkIMVGzSUB7DIgajQ-1; Wed, 23 Jun 2021 07:15:51 -0400
X-MC-Unique: 3Y57gMkIMVGzSUB7DIgajQ-1
Received: by mail-il1-f199.google.com with SMTP id g14-20020a926b0e0000b02901bb2deb9d71so1507995ilc.6
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 04:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TpUqeJ0SjeP2ZHG2cawop1b7ObM1FUMLtRLSHx3qa/c=;
        b=PLe7ySKUmoS5S0v0kmo6m1qFKmV/br2V18SCqDr5+Ln7CeAzbg51iRnXXzvM16o+GP
         IXu8DkXjctgwec2bx33mMkhBTwYeTLlklLzJ2cWq02oaEnCqCqsOKA/aD97azsLjKO5H
         vQ3pCyYPf5SSty1hemi2O8GFySg6vX+Hl8lc9KiZxH471w5ty0kDihtHsmKzaEwgbfU7
         7QPPPVd5EiVpe1fiCL0BvbMK1NRlnHdyL2DrBCN3Rz6h9CcZbODOdUMl/PYxtAcZPFh8
         5OcLh9uZHj1cQ7rOaxgIiyMwwHoOKY0oKgk0VLJYqSXlyOcPQ2so4rsf9VlybEDOLb5x
         +Weg==
X-Gm-Message-State: AOAM531TJjWPYVDsRmhwIkbSzyucAElnQCz7QfposJu+MpM6XU2Tb5TZ
        8axVSNxqgTVLUXm4Ss7nq6f5Zqwj9izRGeaiWRHqRxDMZWOrKp/akxwfHfniGI8/Fbmvxy8w3/I
        9MxXVAzHAYe52kLyqP9j3J7mZJd+TofNc3rM8jQ==
X-Received: by 2002:a05:6e02:1c85:: with SMTP id w5mr2537022ill.285.1624446950382;
        Wed, 23 Jun 2021 04:15:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxebWuL9eoya2+No8n2viGr8Mq4+oEg5NHH3LcUcdVZEt8fGJ8og8/yESLFA3lmw6ugO6NxFYDr+M1H0WGvFCQ=
X-Received: by 2002:a05:6e02:1c85:: with SMTP id w5mr2537007ill.285.1624446950069;
 Wed, 23 Jun 2021 04:15:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtN+0MLW3e_xhqEP3R_EFULWjrzScuyYZgZ2AE9ukERRA@mail.gmail.com>
In-Reply-To: <CAH2r5mtN+0MLW3e_xhqEP3R_EFULWjrzScuyYZgZ2AE9ukERRA@mail.gmail.com>
From:   Sachin Prabhu <sprabhu@redhat.com>
Date:   Wed, 23 Jun 2021 12:15:39 +0100
Message-ID: <CAMcOejUBxh3wk6iZyjfbaqPmwSWXWZ7YwYgVTxNyF80Re8pnRw@mail.gmail.com>
Subject: Re: [PATCH][CIFS] missing null check for newinode pointer
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by: Sachin Prabhu <sprabhu@redhat.com>

On Wed, Jun 23, 2021 at 2:04 AM Steve French <smfrench@gmail.com> wrote:
>
> in cifs_do_create we check if newinode is valid before referencing it
> but are missing the check in one place in fs/cifs/dir.c
>
> Addresses-Coverity: 1357292 ("Dereference after null check")
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/dir.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 912333082b18..aca6ed58cc44 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -384,10 +384,11 @@ cifs_do_create(struct inode *inode, struct
> dentry *direntry, unsigned int xid,
>   goto out_err;
>   }
>
> - if (S_ISDIR(newinode->i_mode)) {
> - rc = -EISDIR;
> - goto out_err;
> - }
> + if (newinode)
> + if (S_ISDIR(newinode->i_mode)) {
> + rc = -EISDIR;
> + goto out_err;
> + }
>
>   d_drop(direntry);
>   d_add(direntry, newinode);
>
> --
> Thanks,
>
> Steve

