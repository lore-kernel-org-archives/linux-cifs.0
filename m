Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 362AEC678D5
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Mar 2023 04:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjCHE5d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Mar 2023 23:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCHE5c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Mar 2023 23:57:32 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534E85F6E1
        for <linux-cifs@vger.kernel.org>; Tue,  7 Mar 2023 20:57:31 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 16so8932403pge.11
        for <linux-cifs@vger.kernel.org>; Tue, 07 Mar 2023 20:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678251451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D65o4dKG0vg28kBFLbdxlT4zYb14HEqxi84aOm3h630=;
        b=LIgUKAINQXbYkkythzP5yWG1VAnfTJ3VKJYIIIGt9m1E6pxV1jW3dYf41TN6OkkHuD
         ceiwJoBbRpddJCE4NQWy5FEplCP8ZScCAKtlC84CsR2oCYWiF3oaxcXUMR+xz5FPUv3O
         SEDr8jBiBslAf63/7il+DkLXx956eIxYFXkuw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678251451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D65o4dKG0vg28kBFLbdxlT4zYb14HEqxi84aOm3h630=;
        b=BrRdlpbOZRndekIVV+8gR3l4h+vLBYy1F5kion/B9InOhG2Z+NAmCo3jXdHP9ONlwK
         Prj9sgvggDEGEm3C22hoAJYAzsLPijPsbvhyRj6ddlHJjnJrGJh6lBYHVdspCjZd5UVo
         2N+Uo0G6f6HEc6aRt5i4MO5XU+LAxZaNTVqTS4WFSchH1MW+YHr21HXvO+vgOUZrWyoN
         S40buiS+hQnP7y3P8GBqW/t6xk4KBTQYkvF0De20oELD8a5t2+pRcTuK47IXMBnyL3ox
         PHXZo6ZLTDCH1cWnAZwEf7Gs6szZAJvN/1kE940rONApnfZrtFhCZdh01AZhahgBbeSn
         RaIw==
X-Gm-Message-State: AO0yUKV807XZWXfeOYWTP3fPtP0BH8UXZz2x7QXwK+zxMXPleG3GoTwS
        ijU3ttJ5J0YEwYw242pp+hnj8w==
X-Google-Smtp-Source: AK7set/kguC+q4gHxZDDkfHOpUEmY9wJwh1rQxJ1s+kOf4IIGtZ3LqRCbmcztZkkaROPhkGV/Qszgg==
X-Received: by 2002:a62:1886:0:b0:619:53de:8880 with SMTP id 128-20020a621886000000b0061953de8880mr11115493pfy.16.1678251450691;
        Tue, 07 Mar 2023 20:57:30 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id j19-20020aa783d3000000b0058bf2ae9694sm8622936pfn.156.2023.03.07.20.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 20:57:30 -0800 (PST)
Date:   Wed, 8 Mar 2023 13:57:25 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH v2] ksmbd: add low bound validation to
 FSCTL_QUERY_ALLOCATED_RANGES
Message-ID: <20230308045725.GH5231@google.com>
References: <20230307130150.5188-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307130150.5188-1-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/03/07 22:01), Namjae Jeon wrote:
> Smatch static checker warning:
>  fs/ksmbd/vfs.c:1040 ksmbd_vfs_fqar_lseek() warn: no lower bound on 'length'
>  fs/ksmbd/vfs.c:1041 ksmbd_vfs_fqar_lseek() warn: no lower bound on 'start'
> 
> Fix unexpected result that could caused from negative start and length.
> 
> Fixes: f44158485826 ("cifsd: add file operations")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
