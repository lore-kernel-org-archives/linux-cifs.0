Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B3D5C4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Dec 2022 02:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiL3Cy5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 21:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiL3Cy4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 21:54:56 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6F0263B
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 18:54:56 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso24706993pjt.0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 18:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i8M1DvGFn/IOUPV7luzJzYiKF8Vw6N8DIX/BnYrNrMM=;
        b=av3BV2sbAMn4gj1FybfsCdoGa+Y7Ax0xj9J5rWpgPZasWgOX/gZqbPhBS4WwF6Yv4f
         HK9+BVY0B8O5x/oqG+UNt5dYXjyCwJHVfHde0jXj6f3p0sVgCWDDLZRmSNIL9aHIkR7V
         EttBT5XipVFv/cW0Ckq8viE9Dt3XeLeNBon5k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8M1DvGFn/IOUPV7luzJzYiKF8Vw6N8DIX/BnYrNrMM=;
        b=Ts/qiFsUePLVEKMpRKESuVTLbuOA+f2/MQHXfcZAt6FiXbbVM9LWP2Ez0Q8daBiC+j
         tKsyMLHrpEddqD46E75J2te/Cx2+B8XrvAUNkfgnOMo6i6L0Tp67rpzn4pCYiGTZisCC
         smLXXnDcxKIjUwYYUnOdyNSHT0JjszkqjxLJy+bvPv1ieFJMsuBroJKtReWNNaZkAR6i
         4Ju9cdSzZvAw/DoZdd8YUk+L4YA0YVuG3BuTUzSbHnXdYvFVdKODsBFt9+9TdFWNlJy2
         6yEGQ39/hbGiDJ1iVwDLCFhjBJUhgxfjKilOAG8U8q0zGQFLA/hLv7bMduHh3B8T0HII
         l2hA==
X-Gm-Message-State: AFqh2koCvVi0ItP1LvhrQzgDUemj4OfpPbDGFXcZvJLd6wtcJ39teaQD
        dhV30fVsAezDGAcWWty/bEAfPA==
X-Google-Smtp-Source: AMrXdXtH08h50VKEYH2PQAkcIc6KZX3VixQfXcywo880yjTtzoCfGbczGHqvPpczCRsR+SEupLQCBg==
X-Received: by 2002:a17:90a:cc2:b0:219:9973:2746 with SMTP id 2-20020a17090a0cc200b0021999732746mr47289089pjt.0.1672368895688;
        Thu, 29 Dec 2022 18:54:55 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090a300300b0022618929f89sm3768917pjb.45.2022.12.29.18.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 18:54:55 -0800 (PST)
Date:   Fri, 30 Dec 2022 11:54:50 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com
Subject: Re: [PATCH] ksmbd-tools: add max connections parameter to global
 section
Message-ID: <Y65S+r6PtXWjvmmx@google.com>
References: <20221227150213.9842-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227150213.9842-1-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (22/12/28 00:02), Namjae Jeon wrote:
[..]
> @@ -175,6 +175,7 @@ static int ipc_ksmbd_starting_up(void)
>  	ev->smb2_max_write = global_conf.smb2_max_write;
>  	ev->smb2_max_trans = global_conf.smb2_max_trans;
>  	ev->smbd_max_io_size = global_conf.smbd_max_io_size;
> +	ev->max_connections = global_conf.max_connections;
>  	ev->share_fake_fscaps = global_conf.share_fake_fscaps;
>  	memcpy(ev->sub_auth, global_conf.gen_subauth, sizeof(ev->sub_auth));
>  	ev->smb2_max_credits = global_conf.smb2_max_credits;
> diff --git a/tools/config_parser.c b/tools/config_parser.c
> index 2dc6b34..5f36606 100644
> --- a/tools/config_parser.c
> +++ b/tools/config_parser.c
> @@ -548,6 +548,11 @@ static gboolean global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
>  		return TRUE;
>  	}
>  
> +	if (!cp_key_cmp(_k, "max connections")) {
> +		global_conf.max_connections = memparse(_v);
> +		return TRUE;
> +	}
> +

I'd say that it'll make sense to me if ksmbd will impose a default
limit on the number of connections, which people can overwrite. Yes,
I know that samba doesn't limit by default, but ksmbd is a kernel
module and the price of unlimited resource consumption is higher.
We can't probably easily apply the "samba does it" rule here. What
do you think?

How about:
- default `max connections`, say, of 512. max possible value, say, 64k?
- `max connections` cannot be zero
