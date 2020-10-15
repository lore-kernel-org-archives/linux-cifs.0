Return-Path: <SRS0=foj0=DW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20FFC433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 22:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43CA02076A
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 22:08:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QxrAtShN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731685AbgJOWIx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Oct 2020 18:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgJOWIw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Oct 2020 18:08:52 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A631FC061755
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 15:08:52 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id k1so227861ilc.10
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 15:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KeD0pAqyBj/nTc7yB06pjQ9PvXqqysEUvEfoh4BqNSE=;
        b=QxrAtShNocDAsiKN2PKN9pyMS+YziIdlFA+tEerHAJ8fY/YYjIwV6aThJ+2VjCQIxi
         8SgFuvOl7R9gIJjzbiLr4XMEzfrzxzr547TXBbLWuS5Ob1Ochk1U8rn2SIKnnHXNCeSq
         yuQ7lGX0x6eyeu3fcO7fMYrEOeTecHGGpQGxVy0wfALxGKxSEMR5vl4Y7DuoXOnL5p1e
         Az0ThOpYUFWJt36MRWYnau5o/8nJxKQByuYqtNj7+Bq391/kocXNdOsgKbK+E4QasZAl
         p1fWHWV5JWZYH69KSiKW3zUiNef0xonF2stanLFv+vJUoCQPn4LcUGjC2JcWJm5Sw6Sb
         G9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KeD0pAqyBj/nTc7yB06pjQ9PvXqqysEUvEfoh4BqNSE=;
        b=lBQ8P8q7YUikPpS3RGkjX4ES55VuqkWDSodkni6IzYDJZ2e8nwqEpEf8jpZCc/iD1E
         k5XrW8kLf1BqjhHtyt2pD9Bml0+VSOWNKulYmfFw/5SRh1rxwzt26awOcMNxq7AZ1V91
         RmULIZxov6eyTdrA74VUSGgwvqf5Zuq7+wW6PujRpTlQhcMuIOg1wfGVHmc4iK0Zdw3z
         +0BNeGaAGoKoXjbu9TB65lWqQs2b+Lw8zw51qpkv1drxZ7+9MCJOEwf4lTM1HX+PkHpQ
         0bdvmejZIF9Ctizp7rr1PxCKVWlERIKA7KxrAcQLSGx8nVE50P7EggBny+kPS5B1gN9f
         Mw5w==
X-Gm-Message-State: AOAM530Z4fxGX9ZsfF1mbOOM6HbhkCWpeMzmudU65+6zS65NtoXB6lcM
        sT70mkKvznApfL/6fhMMaH9G8qkQOGC8WSO6YqE=
X-Google-Smtp-Source: ABdhPJzre7trEDoSb8tF5nPref8haGAeVqizZrLjgoOonNGlOiNJwd1ndTba5Gi9V6ctCXyc0l1Efu7D70sKc+MTV2c=
X-Received: by 2002:a92:3543:: with SMTP id c64mr484555ila.209.1602799731945;
 Thu, 15 Oct 2020 15:08:51 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=rkeg0w67RcdKhRzGRD_iHA-eB9cBPOO-6BxZz+iyRp3g@mail.gmail.com>
In-Reply-To: <CANT5p=rkeg0w67RcdKhRzGRD_iHA-eB9cBPOO-6BxZz+iyRp3g@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 16 Oct 2020 08:08:40 +1000
Message-ID: <CAN05THRNyzeHvfEOD1Aq1=fHj46NFn_3nyB=y4NQfZc5VAiSUA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Return the error from crypt_message when enc/dec
 key not found.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Nice catch.

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Fri, Oct 16, 2020 at 4:02 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Fixes bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=209669
>
> Please review.
>
> --
> -Shyam
