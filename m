Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35846C38A02
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Oct 2022 01:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiJZBRy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 Oct 2022 21:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiJZBRx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 Oct 2022 21:17:53 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0478C34C7
        for <linux-cifs@vger.kernel.org>; Tue, 25 Oct 2022 18:17:51 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f140so13810269pfa.1
        for <linux-cifs@vger.kernel.org>; Tue, 25 Oct 2022 18:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0R/zuogst9d/iMbwGJahqQyG29x6cKUoOmr+NFwHscw=;
        b=CI1yQ/YQ/tnZzmgve848XpigUhg8RfAlohpGXwTPlL1rtvw+cEuQkOOqNoe4cJ5Nmn
         wOKRSCOiCCIJxQdierMy2Bb+V59SGh4lVxTYrVx6LTmEqWGsLsTEPDReqGvaXHfBZ4sN
         QjhppDIvzcNeXJ+GjtJhhSM5sKqXtbq8P7Iis=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0R/zuogst9d/iMbwGJahqQyG29x6cKUoOmr+NFwHscw=;
        b=5ZeeRiut9TK76uOa7dp4rR/HZl2b/B1TzbKV9HHPps9mlOT9Gs5szVKpTQqHZp3FWT
         NGkVzLOzAOvvXVjjtNtRDuSh3ILYmgpEbwBXxkS/9Z0XFrNCVGCYlxR2Jf8Yb0XxGzLI
         A/AISwvj8dbuDRpTaa1/XFQL5NPPCZGSo3djYFifcjgANttxtoiOS4cIDA7u44UARf0I
         +f2rPvwB5uS/6OwWLbtyls4/7iJbJpeW6Sr/LMgRtobE2ygXtz/3E0UF4cX+uPEzjJ6h
         Sdp8VGqMr4Pon6Mq72+/J3HG2NgxT2c2c6ELCLrudl0owZMETXwb5nZOwnYMrV/aphQe
         7NSA==
X-Gm-Message-State: ACrzQf1IKn7yyjDxlEiubTFGoZEFpienRaGIk1lC2hSjN/MMCkcHvapb
        licXX2jOuCnnh3cm+YGHuCvBUF3IX2vRAw==
X-Google-Smtp-Source: AMsMyM7Xro5ZU7+jhnQa/JNPDsQcNW9Uc99cbnu1rLZvco3Ob13wL1U0NxHdZxNRbtzgHPEN4QT4qQ==
X-Received: by 2002:a05:6a00:348b:b0:56c:35fb:8dab with SMTP id cp11-20020a056a00348b00b0056c35fb8dabmr4070124pfb.13.1666747071125;
        Tue, 25 Oct 2022 18:17:51 -0700 (PDT)
Received: from google.com ([240f:75:7537:3187:faf6:e503:6cac:3b53])
        by smtp.gmail.com with ESMTPSA id j18-20020a634a52000000b0042988a04bfdsm1840383pgl.9.2022.10.25.18.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 18:17:50 -0700 (PDT)
Date:   Wed, 26 Oct 2022 10:17:45 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     wangkailong@jari.cn
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, linkinjeon@kernel.org,
        sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        roman.gushchin@linux.dev, akpm@linux-foundation.org,
        willy@infradead.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] ext4: replace ternary operator with min()
Message-ID: <Y1iKuYLba/hingnG@google.com>
References: <5036013e.4.1840fa09d42.Coremail.wangkailong@jari.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5036013e.4.1840fa09d42.Coremail.wangkailong@jari.cn>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (22/10/25 22:51), wangkailong@jari.cn wrote:
[..]
> @@ -879,7 +879,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level)
>  
>  		err = oplock_break_pending(brk_opinfo, req_op_level);
>  		if (err)
> -			return err < 0 ? err : 0;
> +			return min(err, 0);
>  
>  		if (brk_opinfo->open_trunc) {
>  			/*
> @@ -913,7 +913,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level)
>  	} else {
>  		err = oplock_break_pending(brk_opinfo, req_op_level);
>  		if (err)
> -			return err < 0 ? err : 0;
> +			return min(err, 0);

Honestly, I don't know. My personal preference would be to keep it as is.
"return min(err, 0)" is a bit unusually looking code. Just my 2 cents.
