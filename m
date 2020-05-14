Return-Path: <SRS0=e0WW=64=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAD7C433E2
	for <linux-cifs@archiver.kernel.org>; Thu, 14 May 2020 22:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F86A2065D
	for <linux-cifs@archiver.kernel.org>; Thu, 14 May 2020 22:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="edkk4V+k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgENWN0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 May 2020 18:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgENWNZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 May 2020 18:13:25 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CE7C061A0C
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2020 15:13:24 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id r7so224593edo.11
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2020 15:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Orc2q6coF3KR8uDrJEfkpD2+hbuz8HrAvPtSTw7mlUk=;
        b=edkk4V+kAdEL/y+Y6mqVbiaFnAsR6RP217Qj3vryv/Jj/RmjgZT89NgXqzIGXF2WAV
         N+6HOHkf2C9KPyjyU+ExbAyQk3tYcbTlUwNAoH3yWI4pU5yNCGSGdaPL4UgvSqDJmEF9
         vd0dbIjmz9XQAjgpjFzOyLXEUXzbNxlL+yg+6Pt6la+uWIoVKW/aFjrK/aMNA7emOPBz
         d0B5qO67KfL+4PzivIw6I6FtgQQj8RX+UOIHNNsuR6jOzSYBTZ6aFwiu/KD9b4+J3hGZ
         gHEJAgZ+Nz+YCnIzF1LyWUytVbZ6HjyMGov8d7QvP39qP0F8QsgMG+g1Wpj8yvKabaOH
         lP5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Orc2q6coF3KR8uDrJEfkpD2+hbuz8HrAvPtSTw7mlUk=;
        b=czbpc+VsP6dItFzWmfr2nHs16D9pyBTHqzLHWRy5v0jNmetDHFqoRpI60vZelojjFh
         XQegUdwsbUpWOQRqm6J8hAFeDhHpLmq+BQoJUDq8PbgmOKPiqQlkQY/Bq3F5jXTPj1LI
         SA0YHqD+94wwB0K41LJOw0nn++3Gi4hn3s2t+Qm/AN6IezvskDz4YrN3vr4VPZVjFKDo
         zaq/4MW5HukqtfqDgPinp5pXnigE8e8Cuw/Z9V8SggcE1cHFY4Eo+EHt9cxTMbWKXf+2
         LLJZWVQlG+vJbmK45w5jVkb9uPc9rmTPN50jcClqNf9tieTsltZVmOsRx0N0t+d9z3qV
         Ag6g==
X-Gm-Message-State: AOAM533XSkAY8fBVx0J6Q4FlFSwYMqs34qp50vIpbssN8rDRIff9+ytl
        /+85k0dhRg18dF+WjssJnrNcmPuArqcIHCWBaQ==
X-Google-Smtp-Source: ABdhPJzp/PHtjh4TZOd9pct+xh4R1CqSljzLsyG5XLgAcAt/dxSAWREWp2bAqf/3B5zA4krse353FbymJAbfcB0hgc4=
X-Received: by 2002:a50:fb09:: with SMTP id d9mr188388edq.129.1589494402981;
 Thu, 14 May 2020 15:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200513115330.5187-1-adam@forsedomani.com> <CAH2r5ms14KKspfjv7rc_vkWGMantAxoTE7p0bi66NmMzcex+tg@mail.gmail.com>
 <CAH2r5mtWeqZjHroapXKiN7XxYnt4XjxWuhaPSzRwNcVgrP6g+g@mail.gmail.com> <20200514011748.GB5964@bionicboi>
In-Reply-To: <20200514011748.GB5964@bionicboi>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 14 May 2020 15:13:11 -0700
Message-ID: <CAKywueRRLGdpzjDMVh5DJzMO-AzzLNDWOZor5YstGenboi+Gpw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix leaked reference on requeued write
To:     Adam McCoy <adam@forsedomani.com>
Cc:     Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 13 =D0=BC=D0=B0=D1=8F 2020 =D0=B3. =D0=B2 18:18, Adam McCoy <=
adam@forsedomani.com>:
>
> > Part of this makes sense Pavel reminded me:
> >       in cifs_writepages() we don't need to reference wdata because we
> > are leaving the function. in cifs_write_from_iter() we put all wdatas
> > in the list and that's why we need an extra reference there
>
> Yes, this looks right. cifs_writev_requeue() seems to work like
> cifs_writepages() in that the wdata2 reference disappears when the loop
> exits. If the loop iterates a new struct is created each time.
>
> > and wouldn't there be an underrun if a retryable error with your patch
> > with it getting called twice?
>
> There shouldn't be any difference if there is any kind of write error
> (rc !=3D 0), since the put call is just moving. The only difference
> should be that the put call will happen if the write succeeds.
>

Thanks for the patch! Good catch!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

This is the old code and the problem is important to fix, so, stable
tag is needed.

--
Best regards,
Pavel Shilovsky
