Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75949C433C1
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 13:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A70A61A11
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 13:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhCYNAE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Mar 2021 09:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhCYM7v (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Mar 2021 08:59:51 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDB0C06174A
        for <linux-cifs@vger.kernel.org>; Thu, 25 Mar 2021 05:59:50 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gb6so1029412pjb.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Mar 2021 05:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CGvIQg06uYj/iOn3NOGY45efBiveaMxIqTqhwct71NU=;
        b=dGGrZAl1XdWYDo279sO7iPPy0mGhCmw2/2SOehTfDRqR1NQMsAIhSigTQZ31VrpM25
         kXZ6da4ypQi6frpRo1BeNmUBVP7yAEf6Q8x4ME/3ZVZQpcyd0xdOp1Mad8nq2IkU3Ume
         ZNUyCdH2RtppUc7uLeQhpi4rqHBDfWgNOzj9bfNYG+Dlqb6DY5wJSw9AFY/bjxAFUnrf
         kym75vVCHlp/Y8iLUPaNYPu79zC+G8MJwoc5DBLdmwr/xOsL6jaSTACFgKOhzmLPEboX
         EJFPXZw0FgcDzN3oXEDtwTfveDzTTo4+U8mFuWO/siGn46KkKzYnPU0+01iuDB0vabZm
         qtbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CGvIQg06uYj/iOn3NOGY45efBiveaMxIqTqhwct71NU=;
        b=mT0yMwxUVzfmAh0ViwyreBj22mT1Vev1EVIYW9Tz07FDN8uj0rrsx3lUl+taRNCJLC
         Eri5uCgirUfrjAzOi5gD7NwYhqNYp8OswEYDdoDXNuoF0bTVZzHYv08jy30elNFQlYYy
         M97oKDd8L9rrabaHBxvlO32D+sB8DVHW6TQTJBSD7/FwQGUz4XFtYR7QKCaUB6Rhsu8I
         8Y1ReFsExJ+o10+o1AW3ndYwkYhsL68SyZqb8MwrXHyxHssAyK7sgsoHMPP+6AzzZZqr
         Cf9FyeIIxiuN4qWq82d6CutabIUcALlKUluRNFEM7iMVYmjC7XN/+MQYDijTLthvPGHd
         IEyA==
X-Gm-Message-State: AOAM533I+v+KYuVh2BtYYsGQ2CIZTMub2SgO8EmJtv3p6EsSg8jJiqVO
        p+TB79E+sEY7+zCF3H0+astUi1AnkzTcHW8tFPdueSHS
X-Google-Smtp-Source: ABdhPJw7QMPtdxVv06T0wy+w/5+kt6XHrPhYOxmg/+cJRwlVGkjMe7VF49vbZmLQUY6bYfXeS3VL3hedEyyrWJOKQcs=
X-Received: by 2002:a17:90a:c207:: with SMTP id e7mr8618955pjt.188.1616677190631;
 Thu, 25 Mar 2021 05:59:50 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qKxu17O__xWzwfbJJ4RAAK4whg63Yx6P6FGKVYrMkxOg@mail.gmail.com>
In-Reply-To: <CANT5p=qKxu17O__xWzwfbJJ4RAAK4whg63Yx6P6FGKVYrMkxOg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 25 Mar 2021 22:59:38 +1000
Message-ID: <CAN05THSVmeYGqky=jG2_Jrf0GxdPumASnWoMx8TrzQ85hbDLDQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Adjust key sizes and key generation routines for
 AES256 encryptions.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

-ENOPATCH ?

On Thu, Mar 25, 2021 at 10:53 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve,
>
> Please include this fix for AES 256 encryption algorithm based mounts.
> I've validated this by mounting and performing I/O.
>
> --
> Regards,
> Shyam
