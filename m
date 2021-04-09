Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FF2C433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 03:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6828610C8
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 03:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhDIDxd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 23:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbhDIDxc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 23:53:32 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37535C061760;
        Thu,  8 Apr 2021 20:53:19 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id b14so7475561lfv.8;
        Thu, 08 Apr 2021 20:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WvAkE14RRxFyw37VbW7supzk2d4KzKaaFk6V2nsZhQc=;
        b=Bes+aZ8kQWHR8gW+UFXLxhe2qQj9C4RZbvCC9IHufR4O78b+ajGfFHFXjQa5Dldzxs
         u3jvjTjJXaOVJdpfWEKQ9wfK+KxymjJKajonU+uL4191I3QspKmea917j9nMus5xMXGy
         3k3U4X0sLzyjDT+k8Dpa1CodWZEyltZgQvotn4B0QmnFY16ZQ5ibWdoRFjpayByEnEab
         dD02pRam72lYHtwHuBngVn97sA7LA15NLjRyrSfX81DIi66RyK+RTuStrjich3nWmLnJ
         o5EYAG4IWjIowlBgLkvG+4PqAkXcgWtU6P3Dm1NsNimGRsGzsORZEnWBxrr0vPOcaDC6
         GCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WvAkE14RRxFyw37VbW7supzk2d4KzKaaFk6V2nsZhQc=;
        b=XHvtVgJrRrj2I4uj2JgQLAL06+Q10OLlSruwUpIbsBYWwMP+oL7pdN3XVHj+UhDzyE
         O2GaPeeq9oc+mUvsODMMKHe/Av/GPXEgvgS2IWfByhY0thol1aClPoKGjUh9bo+qltMf
         4lyZDhVKylQwkIBn3aWRrAe4RbLJvnkeKKhuiFRPFZNAJdI3ECdSY8hAcMUeW8AhM2VE
         NhKGrk4rRw2okfAw1pk/lltkbWzQJ8skt4i6N2xuMGnegjhaRCnE2IHo+GmrPwcHqw7u
         WgjxYsknsr0YWICIeQkWD3cXQzyorVv201diSjmhlFvQVArGLEfX4DLTdZegBeDcpLgV
         u5Iw==
X-Gm-Message-State: AOAM533Lc1uPYFgo0iwqZYHtnQYbSAFQTSpVr9ITyyQ+qQhiTuxcA+4I
        9NlLdWtBWlbIbPyWgjnQ1tUse2+Vp9+4PU+D5Em66R8xQNg=
X-Google-Smtp-Source: ABdhPJz4OoYDuXPlbyzjjdbCDm7bu+Itw0zg+AhNUPCi78022CFqFtV8pXgxDrS3RfpuLFbQVdCBZCiVCqd6Y46rsoI=
X-Received: by 2002:a19:8c0a:: with SMTP id o10mr9022702lfd.175.1617940397489;
 Thu, 08 Apr 2021 20:53:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210409024639.1092204-1-wanjiabing@vivo.com>
In-Reply-To: <20210409024639.1092204-1-wanjiabing@vivo.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Apr 2021 22:53:06 -0500
Message-ID: <CAH2r5muuziT__TfpFWgeQkXRLkE0ZmekAXLBVwxwOAmCAFrh2w@mail.gmail.com>
Subject: Re: [PATCH] fs: cifs: Remove repeated struct declaration
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, kael_w@yeah.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Apr 8, 2021 at 9:47 PM Wan Jiabing <wanjiabing@vivo.com> wrote:
>
> struct cifs_writedata is declared twice.
> One is declared at 209th line.
> And struct cifs_writedata is defined blew.
> The declaration hear is not needed. Remove the duplicate.
>
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  fs/cifs/cifsglob.h | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index ec824ab8c5ca..5ec60745034e 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1316,8 +1316,6 @@ struct cifs_readdata {
>         struct page                     **pages;
>  };
>
> -struct cifs_writedata;
> -
>  /* asynchronous write support */
>  struct cifs_writedata {
>         struct kref                     refcount;
> --
> 2.25.1
>


-- 
Thanks,

Steve
