Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8452C6FD1C
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Mar 2023 01:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjCYBUt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Mar 2023 21:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbjCYBUs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Mar 2023 21:20:48 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7658D19F20
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 18:20:28 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id z19so3434623plo.2
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 18:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679707227;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xRU59Fp1LPCf2L9u79Fxev0jeYDDSl0nAnmtEcwYt0k=;
        b=Gblh5P6wOi+3Vk7yht26IljnWQaGUVcIHVDJfTW5QQIE2S7Jc+welPvGIGUK3Arv7o
         lRY6zU6X6eS/dJDuSm83CcsKMEXtCK+DpamswOkkiZ+SUhF2+F2vknhjXPThDKb3WovF
         EP1sjpoYg2ry6q03v/LrZy3x3hnv+tNZ03CkM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679707227;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRU59Fp1LPCf2L9u79Fxev0jeYDDSl0nAnmtEcwYt0k=;
        b=vzlxElHmORb05L1z/9+4qQVOV6hgPlkfDSSxbrNdDSmuLSUHlyyA4ZwlwjFyl9olYE
         9eMXnDiDWiIl5nBPii7ZoyHgMqNfeEqCiTGUebp3dlQD+Uh1gyT5bwIbGXFnPv4q0ONe
         aEZD5GeqTd8NFdi/IO6HKlLYkG1uxT8Hrtu5DVD2YDk7dYiHi3bnlpRiRSOHr0hmNzjh
         9it7IztvtM5AzLLo1sYhLCLItHa2/cprgT9/b1Q0TCTkh2+qhhgymufk8oxrE6gig2HR
         EcvnIUgKS4DCM2Q+6tTxYbxKmKnvMdEcxs+yXh5ullLOU9QLO0q5fvpWT4TqKmkX/Upj
         pGAA==
X-Gm-Message-State: AAQBX9f6qQ59jgBrQ4L4A7m+V3S1nxR6K3isqY6GYAXNOd+C0mTsAiCv
        rPNngUc2P2pFZzOaVjFQl941/g==
X-Google-Smtp-Source: AKy350ZzS7Y6pc1qWAFsV1Kr4heRJSNrsm+/JeoaH9QVVJn4GXIZCCUZPXrtKpXfaSfy+Z6kX9PdTQ==
X-Received: by 2002:a17:90b:38cd:b0:234:67ef:304b with SMTP id nn13-20020a17090b38cd00b0023467ef304bmr5082656pjb.37.1679707227397;
        Fri, 24 Mar 2023 18:20:27 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id n3-20020a654503000000b004fb997a0bd8sm13917727pgq.30.2023.03.24.18.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 18:20:26 -0700 (PDT)
Date:   Sat, 25 Mar 2023 10:20:22 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Tom Rix <trix@redhat.com>
Cc:     linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
        tom@talpey.com, nathan@kernel.org, ndesaulniers@google.com,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] ksmbd: remove unused is_char_allowed function
Message-ID: <20230325012022.GH3271889@google.com>
References: <20230324173056.2652725-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324173056.2652725-1-trix@redhat.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/03/24 13:30), Tom Rix wrote:
> 
> clang with W=1 reports
> fs/ksmbd/unicode.c:122:19: error: unused function
>   'is_char_allowed' [-Werror,-Wunused-function]
> static inline int is_char_allowed(char *ch)
>                   ^
> This function is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>

We have a copy of that function in fs/ksmbd/misc.c.
