Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07529C77B7A
	for <linux-cifs@archiver.kernel.org>; Tue, 30 May 2023 14:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjE3OBn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 May 2023 10:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjE3OBn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 May 2023 10:01:43 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C483EEC
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 07:01:40 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-30ae7cc0e86so2540036f8f.1
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 07:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685455299; x=1688047299;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R6QyDstE5anjukt6eoV/kZWKhWe+uxVxjos/d/82Gyg=;
        b=syvhcDptBbQPSmYPArGktGme7Gt0EkLyDEIm1u4+8zVPXqmF/4Lrf9qaIzgJ42KBjg
         A1KT6lzT57XKq1omqcGCLA7ObyxB9jroO/1bLv1rFlRNM0x+NaOU5UOebA7gxKhGpajk
         UgQjPJSSyv7v77y9d2okR5+/YdrvzLTFVeoJG6KZw0qyQ09EzInArJQ9zQvgwl8lu0PZ
         IKKtw2aCfhRh2M4mYGjqZNJLd3rPyKhPJaHt0QImq+5/LFOX4GynNRSUHp4SNb9EOiSO
         Cx5fwHZsaFFWkCZVLGFFblNZqh0/15o2m+4QzWzyVpqYizwLLCYE2JBdUcfHej6nu3r7
         n6sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685455299; x=1688047299;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6QyDstE5anjukt6eoV/kZWKhWe+uxVxjos/d/82Gyg=;
        b=bz+hdLnXxEuB3rTk8HH6+3XK9xtFqv4v1Pxa+M2jtB4rE4+5BxPrNasc9BCtoycGW/
         jbNsML60ZbqexUswt90ETh4/v24L9f4EFkVkgAQd7ONGl8JlebW7Xi0pb/hWzXd1qMRt
         DzCvwJNZC16tBvNDkJCf70x0Nz//pqC77ENVgXwq3ATbVDKmAS26Bp6f+K4Elx5yREM1
         s/VshYQkWw2ULtFQHZwojKt0BYUjtCqIjUx5VGlkMkaO66b4WoO8EOTB456yj364uTZV
         zMTMeBRY9w6PuPW7k9lOtoEys6vcgbrM5UP6pa8tbQEZznJEGjxfM4tGqy1nx1nAkdQa
         VNPA==
X-Gm-Message-State: AC+VfDxBaIW3Xe/iqAbM5HAkGyM6RjO2WDjB4/4F/8mWczMp3eGC4CGg
        f5+odgJHhQv3J+zGUtIRNZx4Gw==
X-Google-Smtp-Source: ACHHUZ4dsGCUcQmLK6RgiPWOSYjSou1751HLkXEFDRIVp1AYAnxBNMMVB3pdCG9UmhnZyulkem1y2Q==
X-Received: by 2002:adf:ce0a:0:b0:30a:eeff:3e63 with SMTP id p10-20020adfce0a000000b0030aeeff3e63mr2121544wrn.64.1685455299085;
        Tue, 30 May 2023 07:01:39 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id o13-20020a5d474d000000b0030af54c5f33sm1933830wrs.113.2023.05.30.07.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 07:01:36 -0700 (PDT)
Date:   Tue, 30 May 2023 17:01:34 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com
Subject: Re: [PATCH] ksmbd: return a literal instead of 'err' in
 ksmbd_vfs_kern_path_locked()
Message-ID: <9f7d2528-45e8-45bb-b703-f4f8e1c08ed2@kili.mountain>
References: <20230530125757.12910-1-linkinjeon@kernel.org>
 <20230530125757.12910-4-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530125757.12910-4-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, May 30, 2023 at 09:57:57PM +0900, Namjae Jeon wrote:
> Return a literal instead of 'err' in ksmbd_vfs_kern_path_locked().
> 
> Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")

No need for a Fixes tag.

regards,
dan carpenter

