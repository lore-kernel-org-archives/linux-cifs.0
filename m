Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D23DC433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 21:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352223AbiDAVni (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Apr 2022 17:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351831AbiDAVnh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Apr 2022 17:43:37 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2D4266B53
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 14:41:46 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id bq24so7218799lfb.5
        for <linux-cifs@vger.kernel.org>; Fri, 01 Apr 2022 14:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MT/2MfbqPGvZ30GWatbUy2aJHfFDnuIQO2CEVbrFW6g=;
        b=aPw5tP3eS+RHs6l5QtI/rS6qiFIMGaSJgRjH2u+dbnLr8G3AwOcbqSEeycd3dk6vUK
         DIHf6/HV4Ap4xd1LzTzzGje2odmr9e+hYLQv0MgEFOe4NRpB/Z0JKJ+f+zaANr9KHs2v
         C6SW2Y+tIGz2xtDUqP9+06PDqrtHKH1zqDyMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MT/2MfbqPGvZ30GWatbUy2aJHfFDnuIQO2CEVbrFW6g=;
        b=B1CGej13ENBpUQNAiFeiLOkico1NDboNDZcK91huAehBghWSVmdzdU11Lp2uEQT4VQ
         gKUp93MNbx75z1FbTMWImHb2aWK82d6r/KM5dXyAZOIjz8ctHxzxfFy0m6BO4jiZlIr9
         iz8AsDi3yEQ9SuyQDybpEXClUk0Z4yKILW3vRD7UmvCE8c/Oyjzj7ys87VBwPcVraAXW
         se1ksMLufaGXHjURK/BNDM2a1l5sqQNe3EhIrSh2Kl5Q0S/Pz4nLTc3dHj1AhKS3DyJN
         3tEGy+l6c9Jo5x5wRsEJ/EqTnbH0NMk/S9antH2yua/6PoqiupuzvZ/LsVIvawOP6yRZ
         7Jjw==
X-Gm-Message-State: AOAM531SBvD/4m0PDHFqqTOcEP5lYw8cJvnELbKo8J/6whz1G3OvRJO4
        tQA91k+IBGyYcki9E1HmhFBAsCnV9/TBnvEJw7c=
X-Google-Smtp-Source: ABdhPJxriZZQ58M+PX1/6rSlzPAhU49sfsRqq2wkRFLY1SwlcFLDnBZJ97qNBOZOWl2mVX8IueMYXg==
X-Received: by 2002:a05:6512:1513:b0:448:39c0:def0 with SMTP id bq19-20020a056512151300b0044839c0def0mr15055310lfb.469.1648849304328;
        Fri, 01 Apr 2022 14:41:44 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id g4-20020a19e044000000b0044abb73ada2sm348570lfj.139.2022.04.01.14.41.43
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 14:41:43 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id g24so5556615lja.7
        for <linux-cifs@vger.kernel.org>; Fri, 01 Apr 2022 14:41:43 -0700 (PDT)
X-Received: by 2002:a05:651c:1213:b0:247:e2d9:cdda with SMTP id
 i19-20020a05651c121300b00247e2d9cddamr14876542lja.443.1648849303035; Fri, 01
 Apr 2022 14:41:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvE6YuhkO0AaPtmzA4V22T_T-bz7ttKbvgtqo0My68Kgg@mail.gmail.com>
In-Reply-To: <CAH2r5mvE6YuhkO0AaPtmzA4V22T_T-bz7ttKbvgtqo0My68Kgg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 1 Apr 2022 14:41:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg8snck485CvOK9CTXbTto3Lmf2eCRaoH5pGk6-1mCkVg@mail.gmail.com>
Message-ID: <CAHk-=wg8snck485CvOK9CTXbTto3Lmf2eCRaoH5pGk6-1mCkVg@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server fixes
To:     Steve French <smfrench@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Apr 1, 2022 at 11:40 AM Steve French <smfrench@gmail.com> wrote:
>
> six ksmbd SMB3 server fixes
>
> - three cleanup fixes
> - shorten module load warning
> - two documentation fixes
>
> Does not include the dentry race related changes which
> are being reworked by Namjae.

Thanks. An updated diffstat would still have been nice, though...

But I've pulled it, no worries.

            Linus
