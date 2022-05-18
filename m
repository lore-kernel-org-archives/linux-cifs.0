Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D127C433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 22:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiERWfL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 18:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiERWfK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 18:35:10 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE282222403
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 15:35:09 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id v71so6092013ybi.4
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 15:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BT1PmGnLzGQUDAGj1oC2KxZF6wzZgd3uYkdEqSCvarg=;
        b=hBzUh8y9+K2jPK1/ZoS1zB7S3nmAAhDi3bMm4FTjbvaU3wK7iHF4gFmNjL1MKR2XXn
         Vy/VmmB7G/tDDGFd/JqL6jTfa8cg6V27vtjve61EnqQpg1JZVmTQDAuoICc/yubdZL9C
         iCEKWyKX3zXVgAiDu6sSQq5C76ACRM1l8R8Tu/JFfmIMoJu62+eQNCx+Jls+i8NhF5M+
         su2G/TZrvy8csl0u1Eb+rcViLIRgUNtVZetC5fx68WzSBfyZl5abX6YJOz0pzzXqEBKx
         mntQRfFSjZ/FhE1mQ+fyDhdkAz8Zcx67xxKbNFUEWaLIINMOWpyME1wOZq4224PxORYr
         MsMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BT1PmGnLzGQUDAGj1oC2KxZF6wzZgd3uYkdEqSCvarg=;
        b=nuQWeIYj8D8JmptipWNRDocPG2aSSSgvS4xeJhsh6O58lf+TV18GEG6XSLxpwAs4e4
         X6YVHuk8qJ82OaWIiTJRZqFU036iaVY0KOCUiIpEHvJ3A6xvCsANSUMtg6svE2Xii7ZM
         9DtCkoJP6C0Irw3N0Di0gQP2eNPHNUYuBeujutN04o/oJYQnWU6kZ5ANvv2ygRoBRsyV
         OFpTbxL0zxoUl814FKSrTiv5bWnSpA1iUA5lP3v4gllNVzUXUsqSpZIzb3jinUVIOi6a
         wv+3JjffWowlVwiijfaTDirSuwnFySOum4xRd+G0/mkERgIpha4o1xAuwED7aP9OTBw9
         oa4A==
X-Gm-Message-State: AOAM532hALjxKPDOlnNLjIwobdRZN5Ag7SLmNEB9Zr+k1cNc8y4cg/X4
        uacvtgcIXJB44UswUEMIcM+2CzpR09vX0Y+yGnWQWZuj
X-Google-Smtp-Source: ABdhPJwdrCqgp/VEDutHQrqnDB5eRVnWs20jNatCvWCTtnTpLMxQuGECvdov5Wdc1o5CUHprpVCnM5jLzXgCIy15paI=
X-Received: by 2002:a5b:c8d:0:b0:64b:a4c6:b4fd with SMTP id
 i13-20020a5b0c8d000000b0064ba4c6b4fdmr1732308ybq.150.1652913309175; Wed, 18
 May 2022 15:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtk36dm00uH+Y0bYu0c6J_k7LcEQUBa2H0SLEX4RLXUPg@mail.gmail.com>
In-Reply-To: <CAH2r5mtk36dm00uH+Y0bYu0c6J_k7LcEQUBa2H0SLEX4RLXUPg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 19 May 2022 08:34:57 +1000
Message-ID: <CAN05THQVbcEJJkhzgcdav9FBjdXx2tPV9Ze1aEJZqoF9M4TdeQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] add dynamic trace point for debugging lease break
 not found
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

LGTM

Acked-by me

On Thu, 19 May 2022 at 07:35, Steve French <smfrench@gmail.com> wrote:
>
> Looks like we don't have a dynamic trace point to catch the case where
> the server sends a lease break we don't recognize.  Attached is a WIP
> patch for doing this.  Thoughts?
>
>
>
> --
> Thanks,
>
> Steve
