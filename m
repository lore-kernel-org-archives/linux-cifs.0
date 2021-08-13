Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18849C4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 20:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5B6361042
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 20:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhHMUOJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Aug 2021 16:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbhHMUOI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Aug 2021 16:14:08 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D469C061756
        for <linux-cifs@vger.kernel.org>; Fri, 13 Aug 2021 13:13:40 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id d4so21901759lfk.9
        for <linux-cifs@vger.kernel.org>; Fri, 13 Aug 2021 13:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yPWPZ2s3U3R+Aae/yZhWXO3RNRx1+8T/ah0KdULDKWw=;
        b=KyQ6lP2mKztIh5CetUffS/v53RNiQWD0ACFAEOICSQMSn7tbV2sx8zJu0VUoF/CKH/
         HI+0RoX/rATUucLxeipwBIWUH3e6Mpx1aPV72R+nilPq5M6Ls4L01QpJUpPV8Eab+qT2
         yReweqnprGzJTi3GE+aO+XO4tVrPOta59zURb3f1ft1tujtp+o4SdbVGfRieN0jBkIMX
         ufaVCgDUSa2QOoczw3QJ1UV0tK5siidsXR0pznsbxmp+IUEeNxSi3IwRZQiop4s6R0ug
         +JbjjsDALywdWRMk6cV4fcQh8umFbUXC7pjOdHCfEPqGmtFvH6n2HQ90KbpNo3XQDoik
         L9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yPWPZ2s3U3R+Aae/yZhWXO3RNRx1+8T/ah0KdULDKWw=;
        b=cJvPKbvwz2Ya5CgnGsLL6c+Bvqy77t5Og0gKuZJvQ75CC4LI8YN5s9ZeGj8CXANUiG
         J+NeT+NCidI05ox0zBe0sGqf/MbasvdGbTuXzSO/3iR6JDLSfAwAj8J66ArjMfrVv2Ls
         4vQea9o79lTx6vZOlvuGi0C7ox38dDSPQKxWSP3TtMruCNh7wYl2/CyF5xyY6hJQNS0Y
         X7h+fvXtICX41PCWKGrt10cVPvhMfX+BDW9bXpvuHtiJH/WdK2f9kFl7d0Qox9gtCcz3
         xeQh3xt6pUE9bic73itf0fok03K3hfPrFuO/XDKM1FVKMMHvQK7G5r9ToKrfs9uypWSm
         3OLQ==
X-Gm-Message-State: AOAM530lALBzmJvdKikGR4bSPhhGCV3C8IPs/XGyoB9ob93XnH9Nqsdm
        W4hwRM0BcaLdwlB4/bz2eXQA4wKXJs9vwUd8oOY=
X-Google-Smtp-Source: ABdhPJzcsIyJ7dIS6y+E9UWQf8uccl2WKX/kJWC/0JKtBZfbR79Yg8FnZqsDhzqkKniek7vlwk4VPp1a3Ta5zGnXd/c=
X-Received: by 2002:ac2:4350:: with SMTP id o16mr3018155lfl.184.1628885618906;
 Fri, 13 Aug 2021 13:13:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210813195644.937810-1-lsahlber@redhat.com>
In-Reply-To: <20210813195644.937810-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 13 Aug 2021 15:13:28 -0500
Message-ID: <CAH2r5msnD1f+Oqit=821QzjZcF=qrBa+axaW4NkWkVeAcjS7mQ@mail.gmail.com>
Subject: Re: cifs: only compile with DES when building with SMB1 support
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Any idea how much memory it saves when loading cifs.ko built without
SMB1 support?

On Fri, Aug 13, 2021 at 2:57 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Steve, list
>
> These three patches moves smb1 and all functions that depend on DES
> into smb1ops.c and will optionally compile smb1ops.c iff SMB1 support
> is enabled (CONFIG_CIFS_ALLOW_INSECURE_LEGACY)
>
> Additionally, make CONFIG_CIFS_ALLOW_INSECURE_LEGACY depend on
> CONFIG_LIB_DES so that if the kernel is built without DES support
> we automatically disable the smb1 protocol.
>
>
> This allows to build a cifs module on a kernel where DES has been disabled.
>
>
>


-- 
Thanks,

Steve
