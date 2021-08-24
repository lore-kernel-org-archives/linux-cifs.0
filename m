Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D91C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 08:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6C446124B
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 08:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbhHXINq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Aug 2021 04:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234936AbhHXINq (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 24 Aug 2021 04:13:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7E2D61248
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 08:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629792782;
        bh=xC4tpTCT9yOfvdaxSweWZmt0il8MVJ8dITY8S8fDa9M=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=NSuBY5sBlcmwem1E17WsMvSDwFlLWk4/auTBMc7bdsfpq0D6SMtT5DneHdubxV4s3
         kBPnlXPJCzfzZqxbNQlg7D+AvPdSsYby0VPQebZ4WCH4HKYKBB/dqcU5+Q/ohJ0+/O
         hTzJm0NeGK1EUFV9+hewAMb3DhL0laxJlbw+HL3/+BJO76rwNjwgz7J2Tt7LLQS9NY
         8y9cS1X8MfRSHkiL/yMEO4vdq/vE2tzcRfw9b4K6IddQ8t22J8Wfn/dpYaTOywBlmL
         UtH27BStQO029sTeesTiDdKOZ5ytl36PPTZBEnfz35RCEb4dNJ8WNv6fFtFV5tX1Z/
         Chn/BobaQHAUA==
Received: by mail-ot1-f46.google.com with SMTP id i3-20020a056830210300b0051af5666070so34030854otc.4
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 01:13:02 -0700 (PDT)
X-Gm-Message-State: AOAM533cVhLKq4xT3VIytOy6NG9+djH+pXcPLlv5wwbaCj8kNtUhvmuH
        JQ+nU7fwTYmc93NW3DcKCgNuUoCIfv7p10xTqgI=
X-Google-Smtp-Source: ABdhPJzBtO7HYYr9+5BGBwqG46bvMwZ7itx8zReJZHeTzcRkfiPqwFgy6J6WiUwqpQUr2qmdM6JboNRbqhANrpXtrOY=
X-Received: by 2002:a9d:7651:: with SMTP id o17mr30294412otl.205.1629792782076;
 Tue, 24 Aug 2021 01:13:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:1bc6:0:0:0:0:0 with HTTP; Tue, 24 Aug 2021 01:13:01
 -0700 (PDT)
In-Reply-To: <20210823151357.471691-7-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org> <20210823151357.471691-7-brauner@kernel.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 24 Aug 2021 17:13:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd86gaPoYJJHW6STdHhN282p5JFdr-xWwdvgv4HobFOBUg@mail.gmail.com>
Message-ID: <CAKYAXd86gaPoYJJHW6STdHhN282p5JFdr-xWwdvgv4HobFOBUg@mail.gmail.com>
Subject: Re: [PATCH 06/11] ksmbd: fix subauth 0 handling in sid_to_id()
To:     Christian Brauner <brauner@kernel.org>
Cc:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-08-24 0:13 GMT+09:00, Christian Brauner <brauner@kernel.org>:
> From: Christian Brauner <christian.brauner@ubuntu.com>
>
> It's not obvious why subauth 0 would be excluded from translation. This
> would lead to wrong results whenever a non-identity idmapping is used.
>
> Cc: Steve French <stfrench@microsoft.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Namjae Jeon <namjae.jeon@samsung.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: linux-cifs@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/ksmbd/smbacl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
> index 3307ca776eb1..0d269b28f163 100644
> --- a/fs/ksmbd/smbacl.c
> +++ b/fs/ksmbd/smbacl.c
> @@ -274,7 +274,7 @@ static int sid_to_id(struct user_namespace *user_ns,
>  		uid_t id;
>
>  		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
> -		if (id > 0) {
> +		if (id >= 0) {
>  			uid = make_kuid(user_ns, id);
>  			if (uid_valid(uid) && kuid_has_mapping(user_ns, uid)) {
>  				fattr->cf_uid = uid;
> @@ -286,9 +286,9 @@ static int sid_to_id(struct user_namespace *user_ns,
>  		gid_t id;
>
>  		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
> -		if (id > 0) {
>  			gid = make_kgid(user_ns, id);
>  			if (gid_valid(gid) && kgid_has_mapping(user_ns, gid)) {
> +		if (id >= 0) {
Checkpatch.pl give warning messages like the following :

WARNING: suspect code indent for conditional statements (24, 16)
#110: FILE: fs/ksmbd/smbacl.c:290:
 			if (gid_valid(gid) && kgid_has_mapping(user_ns, gid)) {
+		if (id >= 0) {

WARNING: suspect code indent for conditional statements (16, 32)
#111: FILE: fs/ksmbd/smbacl.c:291:
+		if (id >= 0) {
 				fattr->cf_gid = gid;

With 7th patch, it shouldn't be a problem, but this patch itself seems
to have a problem.
I will directly update it like this if you don't mind :

                id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-               if (id > 0) {
+               if (id >= 0) {
                        gid = make_kgid(user_ns, id);
                        if (gid_valid(gid) && kgid_has_mapping(user_ns, gid)) {
                                fattr->cf_gid = gid;
                                rc = 0;
                        }

Thanks!
				fattr->cf_gid = gid;
>  				rc = 0;
>  			}
> --
> 2.30.2
>
>
