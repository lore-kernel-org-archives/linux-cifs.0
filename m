Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E05C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D68960C51
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbhIGIHQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 04:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhIGIHP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 04:07:15 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F273FC061575
        for <linux-cifs@vger.kernel.org>; Tue,  7 Sep 2021 01:06:09 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id f65so3959828pfb.10
        for <linux-cifs@vger.kernel.org>; Tue, 07 Sep 2021 01:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d/01MhQ8az2KsubiJsXOE3GvtoJpq/UsCghzy97xeIs=;
        b=W19V4SgXaBhfcRGI/YwgIiW/M2fm7L1sufN3+pvLeME1PocoeRMqHFIDgCEewYloKj
         7YAf3uH8dsYXb2wMrtXZRieaQUK9AUSZWosPfSgVZNwa1kJT451vaCAmZCHW+DGQEGk1
         1x3/rX6eePZmta2/oXgPHbyAQ5IVqPudQfyS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d/01MhQ8az2KsubiJsXOE3GvtoJpq/UsCghzy97xeIs=;
        b=t64E9DnIaDdl1rmUnOrthV1UKhxlwN5xXp95G7MQM8htIA1zvmnTTKit6QeNM4/n8X
         qPZvGUOS7v1xqF+F+saB+8LsCG1zbqIfA9aq+SGWktaZA1wEeJUXL9BOtq9av+D68p+m
         aKmuVEMt0/XXiTspFzbXBzuhNAftVlCBN4fXNeX6Qd//5iYc4WtZFdFtT7YgKtcpT3Wu
         YWmmnZahycqhpLVHfqvfWt+Ts6hbkb8j2GD5lbTz5dd6Y51mdmf3fBkrijP0EYu+xjOv
         2D7EZECrCtLeuQ/kXahyrQ0mUf5qg+10869eDD2ATW5YJrSlEC8FMX+4ATVjcmF3/7mt
         UQvg==
X-Gm-Message-State: AOAM530b95sbKbPLQKfzpgjTi8Dl3b62rM8+xVmmfCkCMjMR4Z7NbSis
        v8ZN7IA801+owGsMUuihed5I0w==
X-Google-Smtp-Source: ABdhPJzDWNJzzE/YtzGMdaNz0PvSy18J7L4YpoLZeYLWSPCsDqC8NkD4y8/HKcmvH/NgmO1zF7ZKbA==
X-Received: by 2002:a62:5297:0:b0:3f4:263a:b078 with SMTP id g145-20020a625297000000b003f4263ab078mr15565156pfb.20.1631001969331;
        Tue, 07 Sep 2021 01:06:09 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:4040:44a5:1453:e72c])
        by smtp.gmail.com with ESMTPSA id g3sm9838015pfi.197.2021.09.07.01.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 01:06:08 -0700 (PDT)
Date:   Tue, 7 Sep 2021 17:06:04 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: remove unnecessary conditions
Message-ID: <YTcdbOgmB7758K+/@google.com>
References: <20210907073428.GD18254@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907073428.GD18254@kili>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (21/09/07 10:34), Dan Carpenter wrote:
>  
>  		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
> -		if (id >= 0) {
> -			/*
> -			 * Translate raw sid into kuid in the server's user
> -			 * namespace.
> -			 */
> -			uid = make_kuid(&init_user_ns, id);
> -
> -			/* If this is an idmapped mount, apply the idmapping. */
> -			uid = kuid_from_mnt(user_ns, uid);
> -			if (uid_valid(uid)) {
> -				fattr->cf_uid = uid;
> -				rc = 0;
> -			}
> +		/*
> +		 * Translate raw sid into kuid in the server's user
> +		 * namespace.
> +		 */
> +		uid = make_kuid(&init_user_ns, id);

Can make_kuid() return INVALID_UID? IOW, uid_valid(uid) here as well?

> +
> +		/* If this is an idmapped mount, apply the idmapping. */
> +		uid = kuid_from_mnt(user_ns, uid);
> +		if (uid_valid(uid)) {
> +			fattr->cf_uid = uid;
> +			rc = 0;
>  		}

[..]

> +		/*
> +		 * Translate raw sid into kgid in the server's user
> +		 * namespace.
> +		 */
> +		gid = make_kgid(&init_user_ns, id);

Ditto.

> +		/* If this is an idmapped mount, apply the idmapping. */
> +		gid = kgid_from_mnt(user_ns, gid);
> +		if (gid_valid(gid)) {
> +			fattr->cf_gid = gid;
> +			rc = 0;
