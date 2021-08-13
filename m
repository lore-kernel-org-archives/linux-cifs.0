Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE02C4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 20:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71F3860EE4
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 20:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhHMUNS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Aug 2021 16:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbhHMUNR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Aug 2021 16:13:17 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1224C061756
        for <linux-cifs@vger.kernel.org>; Fri, 13 Aug 2021 13:12:49 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id y6so538611lje.2
        for <linux-cifs@vger.kernel.org>; Fri, 13 Aug 2021 13:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vXw0WwVFOfliPZsOMCKkFRf1yTDE2uZYySjjPesF+ic=;
        b=OpLO1E0FOpem3nnY5Vdj11Z0l3I5no/KsHLwHl+8e38NEP9Z0cOSwgur9IRhUwxq+n
         NSKeCKSSFa06E9i5PBFFt0EJpuLF2rRT6XSt971kkqkmrqxj9vqvPDxds9KNKDnUpXmn
         IqtRWUzDTMvGwktJ6KpvliD9tQRIMtJ1wHk0fQDlodAI8zxT6pD+iA74Q9AVx767TYQ/
         o5D8N83WCISeRkHvfZbgfeC03cTcQlIjZ4Wx5PCVJJHRExE5SdUo2d0/bGeVLckLJsU7
         IJqu4wXqSN+H55Yf6dBR9Sz1Wq060JRgjHzz/vRdq3nQIdvJS7sQZLzQ4bDBGQQPFsou
         MbQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vXw0WwVFOfliPZsOMCKkFRf1yTDE2uZYySjjPesF+ic=;
        b=D6x6rE4sBKl7NA3v+k0dPfYGFBkkdbouH4yxrnOfFpXJ94HEPvHTTjH69JXfbQb7ft
         p2gplAGafGMP+/IYY6/NKIB5caJ33fvGSnE0JvVd++/9CbE2dMKgAOTDS4At5+wKgYyb
         g9kzgPrevoII4bnCiDsUNplTCWchZxPcB5VSpsIWC6XanIO+CNd3lqciS+rOrGktgeqr
         DtD06DvEiHPdU/bN8ppVNtq+ADb5sM0Sz1A4pVUGx7wi7BmInUVfJBnjrNNPQyYzNriO
         XTGo8jbsS2ZVKWliYHHrtFjJczOcP67O6FiIhMGh7E/uGNHrurTubrkBoZtqhoa+86ql
         YLsA==
X-Gm-Message-State: AOAM533Ufa9jOhrW3ShKpwL+uJH43dRQF4v0Uk8tcjW2NbCvliLk2V1S
        /O4GAp9NCggXCx8qeX/OObnr/gfoPhG85/yQWQk=
X-Google-Smtp-Source: ABdhPJwrQqC2wj0g6lFNXAXTL5BXpbbNmfWZNyqEb9v4fZW7xnLs28NI2YWCJDl2cttQ3k7wkCMhd5bNq4ovkQnvi9Q=
X-Received: by 2002:a2e:b60d:: with SMTP id r13mr3057220ljn.218.1628885567886;
 Fri, 13 Aug 2021 13:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210813195644.937810-1-lsahlber@redhat.com>
In-Reply-To: <20210813195644.937810-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 13 Aug 2021 15:12:37 -0500
Message-ID: <CAH2r5mtdF6mik_E8yq9xO_G-5_kD81oy14W3BzFOWBtVOv=0uQ@mail.gmail.com>
Subject: Re: cifs: only compile with DES when building with SMB1 support
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Goal of these patches makes sense.  Also will make it easier to build
without SMB1 in the future when required.

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
