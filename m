Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98553C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 17:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73917610A3
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 17:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhIYRqv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 13:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhIYRqv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 13:46:51 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0573AC061570
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 10:45:15 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id y28so54741120lfb.0
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 10:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oUTbCxwBoFwUUXAJuM2kCRvf2WTc7C8jsUluCEkp2nc=;
        b=N2T4KN7S8wKnGdDr1UZKXUcD04EJ/YtPTyY8tA9QpMkwgSIrYMsqNwiZRFomg4iSKS
         EXtkWwMLpz21YgCUl9B2IGx0l6YHf9CIsRG7Wb0OpxKwmghtrJgiQhJUWXuiQxmulGl7
         /w2jiyG994hPyzUEr0a+J37s3Arba333IGYDs+wQBm5UdNWFUazkAl58PObDTgtKPq0x
         PRLPRo3uCch2krKIjWY+DNzh6JQ6UELqnewQXPT7spOMUo2Jco9v6nK41PCmhDyEDh2h
         RVcEKad6TXcqOfEhD+wwVWEvEnWNz3DLYh22XQ19J14O2ducD3n3rNhLWuTQpac6MOtV
         /yKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oUTbCxwBoFwUUXAJuM2kCRvf2WTc7C8jsUluCEkp2nc=;
        b=zvJimWRJDhbDWTliOSEytxpDvmwZgfu7nNr56o3Yqqyf+spZuscq18ld4gczi1+kwA
         9aQlQQ0SDCIVO1DyrEcPBffbuL8NWNZjo9c7myz1DK+t+YSenN0p07whxnDvezLmA5C+
         qC336L0OMf046L6SAbYleb+gPEuPiQLQ2afTpwpTHq51eE3Q3vAtAOQxyvD7TfnpiV/h
         EE/ZZ4TfTyyuvlfnIvGSCfo6KHMfR8JSgWviXiDAz+uoNv0G13ELXoZFX93BK8ociPXG
         wpNnxA9D39NRxDRSoI2+4qCxMx2O6K6gt5ft+2fc0Bz4+AT9k3yFcR/gmU1MRdSSdVS7
         4n4A==
X-Gm-Message-State: AOAM531/PqXvv57RG4vwobEVSdChG+MKNrEg+Vrgn99+RDBT97QIs9HU
        y4u5FIKB4Z6+c3sEeVnEejMMB4w2aFnEfvKDs0U=
X-Google-Smtp-Source: ABdhPJwFplul+7pfjAwBEWKdml5ZM/v1n4eoX8pjVqPUeuM+phIR41Qn+1ZSkyzI2GiCLR6XtICU/h28lIylJQsDEbM=
X-Received: by 2002:a2e:4619:: with SMTP id t25mr17813417lja.398.1632591914197;
 Sat, 25 Sep 2021 10:45:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210924150616.926503-1-hyc.lee@gmail.com> <CAKYAXd-XqKdgYSsQKJmDDjUyzqQcGfSjd5uJth3mnsRkAWjOjw@mail.gmail.com>
In-Reply-To: <CAKYAXd-XqKdgYSsQKJmDDjUyzqQcGfSjd5uJth3mnsRkAWjOjw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 25 Sep 2021 12:45:02 -0500
Message-ID: <CAH2r5mvkQYahmG5Yz3356eEztKP_BS=wu7uMLG7v3UR1+xdxjw@mail.gmail.com>
Subject: Re: [PATCH v4] ksmbd: use LOOKUP_BENEATH to prevent the out of share access
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Ralph Boehme <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I tested this as well with some simple examples trying to escape the
share - testing going fine so far.

Also ran the buildbot from current linux next on client to current
linux next for ksmbd (and it passed)

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/73

On Fri, Sep 24, 2021 at 7:43 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2021-09-25 0:06 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > instead of removing '..' in a given path, call
> > kern_path with LOOKUP_BENEATH flag to prevent
> > the out of share access.
> >
> > ran various test on this:
> > smb2-cat-async smb://127.0.0.1/homes/../out_of_share
> > smb2-cat-async smb://127.0.0.1/homes/foo/../../out_of_share
> > smbclient //127.0.0.1/homes -c "mkdir ../foo2"
> > smbclient //127.0.0.1/homes -c "rename bar ../bar"
> >
> > Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> > Cc: Ralph Boehme <slow@samba.org>
> > Cc: Steve French <smfrench@gmail.com>
> > Cc: Namjae Jeon <linkinjeon@kernel.org>
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> Looks good to me!
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>
> Thanks!



-- 
Thanks,

Steve
