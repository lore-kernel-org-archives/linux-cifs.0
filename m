Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2824EC6FD20
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Mar 2023 05:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjCXFpg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Mar 2023 01:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCXFpf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Mar 2023 01:45:35 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E3EDBE8
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 22:45:34 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id dw14so574052pfb.6
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 22:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679636734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MbDg+6lowyJG62SMCwh5sYEjvfse0HdfkzFuCY9KNEk=;
        b=ffZ9bMDIQFVLUIr4D0c3w0Ujg1LCT6deKIXaWZw1ZhXs4C0qATWuDaIBU9wTEkpK6w
         fOdqCHEZcLcnwbAu+VQdTJJ2mFdKlVIFllI1D6W2nMOOepLr0bfM9iLKA3f2JN/KfjDn
         7UiArnmBZtNjyapJn+wjfgcrqPeXDGgqkWpzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679636734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MbDg+6lowyJG62SMCwh5sYEjvfse0HdfkzFuCY9KNEk=;
        b=lwSMb/q4dwihobftgQ4tmN9fHaWwQQy+hXwmshKcllgDBQqla2kfgJW1up1IMsMlHg
         5aTjBhuPj9tUKzgj9YyeudYpbSOT3hAnydo+CTWe+IAoJb/l/2LMCpu+SlJ5PymX/iZ8
         pA804/ZX1SR62NAW4glwbllb01xZqrTMrycNrLZVt+w+Zsga6230x8S8MMtD36txAWa7
         nfPZkjB0Nc6/igxj2TZPnSFRZ5HSmhpAcyL6wX0E9+R8xzlI1wHEBOL38VZpc81HKPIj
         Byk+KA6oepqwfetAyW/jk6wiesoFn+Klsm9wmMLto957935zhg7BqvgEegpbnd+SO70I
         Tb5g==
X-Gm-Message-State: AAQBX9drf2sOYwRDancmMD8GD1Jc/rHlLj7Se9BxPiPQgnjxCuhi6G8J
        hpHvnz8hLRT7l+IL0RN2FVP+Lg==
X-Google-Smtp-Source: AKy350aYTX4ghRoPrWSI+OzhYIsEEGy7K4MNq+zsjrhAH/40u3qbWUJ/sMTky38MoiKXIGvTNaHd1w==
X-Received: by 2002:a62:1b12:0:b0:627:f9ac:8a33 with SMTP id b18-20020a621b12000000b00627f9ac8a33mr1685888pfb.13.1679636734209;
        Thu, 23 Mar 2023 22:45:34 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id e23-20020a62aa17000000b0062a8cb3aa81sm899808pff.218.2023.03.23.22.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 22:45:33 -0700 (PDT)
Date:   Fri, 24 Mar 2023 14:45:29 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com, Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH] ksmbd: don't terminate inactive sessions after a few
 seconds
Message-ID: <20230324054529.GG3271889@google.com>
References: <20230321133312.103789-1-linkinjeon@kernel.org>
 <20230324035000.GD3271889@google.com>
 <CAKYAXd_y+xh_2Rp9RLi1xWfrsgYSBvQENMkE0uS=W1Wnp6Espg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd_y+xh_2Rp9RLi1xWfrsgYSBvQENMkE0uS=W1Wnp6Espg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/03/24 13:28), Namjae Jeon wrote:
> > By the way, ksmbd_tcp_readv() calls kvec_array_init() on each iteration.
> > Shouldn't we call it only if length > 0? That is only if the most recent
> > call to kernel_recvmsg() has read some data.
> If length == to_read is equal then it is not called. And in case
> length < to_read, we have to call it which reinitialize io vec again
> for reading the rest of the data.

What I'm saying is: if length == 0 on the previous iteration then
we don't need to kvec_array_init(). But maybe I'm missing something.
