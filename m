Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5DCC05027
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Feb 2023 23:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjBNXVq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Feb 2023 18:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbjBNXVp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Feb 2023 18:21:45 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994CA22003
        for <linux-cifs@vger.kernel.org>; Tue, 14 Feb 2023 15:21:44 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e12so1078958plh.6
        for <linux-cifs@vger.kernel.org>; Tue, 14 Feb 2023 15:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wVlSW+MzcaFhWzFtR663veMvlkA/2gETJbdbvLMrqwg=;
        b=YtQfkyFjqHsFwgLK1k2ylJT9ni2w93w6RvbOhhSCH/15ARnLhvtKyJPzZ3MhtXGpg7
         cdWXC1UTFP3cd9zeCHpjnWyQaOsxOk1eH4efxLrUbr5ULex03BITFebPGEAIvx7y7au5
         W32xN1pFjjKkOZ/v4N8ddGbx9TomNuN74dKeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVlSW+MzcaFhWzFtR663veMvlkA/2gETJbdbvLMrqwg=;
        b=M89FvhetEQY+2XjZ0GsbKHDpf35yuKm9Quxcfr6mSLdtlJUeatv5om0r3c1OopzvnV
         YuGM/TBF65+49Y4qQaTbHAOLviCCfzezspXQBt2uxjQSfBXFzgZN18l1VnFsdY1Jx3f+
         4czuCS/S64UqkxFzVpeLfHGKTdW1DJuljK3TqursCOf9AykBgyxpxm2TQ2XNwUjk2f7B
         mIcgHdJyeNyJjoyZmUg6fJG5YRE2iAdvr73ov/Nn/m5ccgv+ZZ7SAt+dwkHq1w19TqVs
         tw5jPN/k2ZEyRxY6LXjKfc//YlKk/WQF+npk1yhT2o2YGC1ibYQpkCOFaY/gVBDzsePq
         ZiVg==
X-Gm-Message-State: AO0yUKVqTCyk5907jGVOBsLhkrihuLr7I/9ZqcvTaRcc3GYP4DTyhhFe
        xI6nLnlCiwtTIOggjGV0mEX5IQ==
X-Google-Smtp-Source: AK7set9q8bTv2pNuwHm4PPCPSiBfM2nKd30kkfNZw8jfMk5RqJT9oVnFuc8N8F2HAJ3AyI3Zi9kfSw==
X-Received: by 2002:a17:902:d501:b0:198:b945:4108 with SMTP id b1-20020a170902d50100b00198b9454108mr642068plg.0.1676416904081;
        Tue, 14 Feb 2023 15:21:44 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id w9-20020a1709029a8900b0019605d48707sm10721849plp.114.2023.02.14.15.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 15:21:43 -0800 (PST)
Message-ID: <63ec1787.170a0220.8e840.4d7a@mx.google.com>
X-Google-Original-Message-ID: <202302141521.@keescook>
Date:   Tue, 14 Feb 2023 15:21:43 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] smb3: Replace smb2pdu 1-element arrays with flex-arrays
References: <20230214215446.never.567-kees@kernel.org>
 <CAH2r5msOxm0PLoc1fAFjDnaonGVv+E1vyHxBGEh_rtAvJ_qNaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msOxm0PLoc1fAFjDnaonGVv+E1vyHxBGEh_rtAvJ_qNaQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Feb 14, 2023 at 04:53:10PM -0600, Steve French wrote:
> This seems to have a lot of conflicts with for-next (doesn't apply).
> Any chance you could rebase it on linux-next

Ah, dang. I was working off of 20230203. I will rebase! Sorry for the
noise. :)

-- 
Kees Cook
