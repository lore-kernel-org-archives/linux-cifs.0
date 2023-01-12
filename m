Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E806DC63797
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Jan 2023 22:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240129AbjALWtV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Jan 2023 17:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239940AbjALWtT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Jan 2023 17:49:19 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADFC59508
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jan 2023 14:49:18 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id b12so13799478pgj.6
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jan 2023 14:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kKQGCZPzZbd3ZAVje9DUWvZ/4P5iphI9r4/knWYs2KI=;
        b=DqAvkM/R4fERKLDz4NsatM9cNHz4ENrtbMNuDlDhe6+SGgtZcJOpGDV1NtZy8D6g11
         OG5MQlC4G4CQtZ+DZ+a8I3j4rQU+HtZiuJn5XS2rsQaIq1AajCNHB56JdLJjBsPKSLRB
         fZEngltDARzgtGJ4/vaZiCTBMTQBVOED+B2RU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kKQGCZPzZbd3ZAVje9DUWvZ/4P5iphI9r4/knWYs2KI=;
        b=ZRKhMH3+LLRNF1HUS0bLnMUs5Fa6PYR/inYeYpEeT1kOLDyYUMDCtBQSEPy+YaziC7
         7OLwb6pIM4i7ptN3jVcehg1pVV0BGLdRSA5X4gvz6b8v65Q79wrKWyhionUhlM8oYdKg
         jPLkLKRz4JIVgYPe4KbceDJWyEW3bAPNhwjHcW0Uq39//tKCwyhTYZ7UbvJIfmiBdFr9
         mu9zFQhNmBM2gVTaN/sohd33fuoWhF7ksiA7nsiAujWhe/GMlkb4x3XfIw/HpYzLajcm
         a+m3g1NHhG3lfPNjsV7YxeCbi70Dgi5FtoW8OIzHvtMVN0HWkbekBaKBq+RozOFsJpQ4
         v4jg==
X-Gm-Message-State: AFqh2kp2YT8nePVhk4zD4iSUHmyjDtWnqEfANbcyBZTKNsdw8bpK8I9G
        qcSx5M0QR2eqfkeisqs1FjlCEg==
X-Google-Smtp-Source: AMrXdXvY/M7blTARbqw81Mw7A+JAPU1y/bg5507VAhxOjDjcAmqvxizBDYZ6yXfrGoYG/Y4sBpyBDA==
X-Received: by 2002:aa7:8599:0:b0:588:eac0:b05b with SMTP id w25-20020aa78599000000b00588eac0b05bmr14527982pfn.27.1673563757683;
        Thu, 12 Jan 2023 14:49:17 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h19-20020aa796d3000000b005825b8e0540sm12371171pfq.204.2023.01.12.14.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 14:49:17 -0800 (PST)
Date:   Thu, 12 Jan 2023 14:49:16 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] cifs: Replace zero-length arrays with
 flexible-array members
Message-ID: <202301121449.1C2AEFC2E7@keescook>
References: <Y7zBtCZ/eRJCpjBf@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7zBtCZ/eRJCpjBf@work>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jan 09, 2023 at 07:39:00PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated[1] and we are moving towards
> adopting C99 flexible-array members instead. So, replace zero-length
> arrays in a couple of structures with flex-array members.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [2].
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays [1]
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [2]
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
