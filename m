Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2953C433E9
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 01:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F75E64E56
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 01:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhBJB6A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 20:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhBJB5P (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 20:57:15 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25986C06174A
        for <linux-cifs@vger.kernel.org>; Tue,  9 Feb 2021 17:56:35 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id y15so419560ilj.11
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 17:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nleXgW17AJHqREXLYFNkwgLH6JyE5ibh8zBSmp+WBHs=;
        b=OJ7PR10jratWIqpz4in4uZ9k3xYvWG5TeE3Qk9VLVDyvK9JVeSPLsMFjpGPnfgZDlg
         P10vXDy7AbZyZXnc11WTWF731y89F5H0NLnOOkji72Qtub4MwsCrQCk8+lV9jjop0cnz
         HpRmpzPrRNI6RN5sOgL165c5jIULiK+XIwoKvrvSn2sfpa+BL2J/yimz2qT1s7MrmydD
         BqT78vM3qSrBvDsfn93pZ19cZGeA/utTW33PSkbooL/OR2dOy3WjnvopHDKn2EYv2fy4
         UPQtcJHeziI1owlkZRJWmQ8+eb1R9MyefFuJwxISlaI14zMJHC64Y3bcBpFPsEqrdAJp
         ZyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nleXgW17AJHqREXLYFNkwgLH6JyE5ibh8zBSmp+WBHs=;
        b=mo55LoWQqEH79RyN74CbyCfUqFdxo0GoPNuVnXSS5N8XN/gFhulqDOEMz0vqy2imDj
         uDfLR7zaoddxlkSymUwuvwzZFLcOahkrLaYYXEktKthWVBovAF8tgMzI6wUUMf36IliY
         fe66AVEh0W/lQHcKitc0q9ZEQIx/dmappovsbZQz5MUcu5735A8PL54jSVkKrKZ6WFW/
         pOAeOoqX1EAU+oWfQ4V/dYmafPTzzw3phIAFkNiPj6ANqejzuMG6rm6D4NA8EpJeieCj
         MXcKo6DZgzsCa1hD6dHoli5ZYnY6l2mDm7/NzPzrhefDUJdZkuaNHbE5gNxEcpKN5Uei
         yo4w==
X-Gm-Message-State: AOAM531YWz/MPIc3Uf0ye2uAneVzGwoWJ8m2yk6xo2EVz0EBU+g9ODg8
        rqgOkM9cHouZbuWOM+KDJaj5dceXortvvPya/EA=
X-Google-Smtp-Source: ABdhPJyevcw+87wgqxAPzgw6fShur3AEGouO8NQNBKAbxP68xcoDdQVhMX23KZou9IbD1Ka7zBJZmnxtOx9H4c0tHo0=
X-Received: by 2002:a92:ce50:: with SMTP id a16mr757412ilr.219.1612922194629;
 Tue, 09 Feb 2021 17:56:34 -0800 (PST)
MIME-Version: 1.0
References: <CANFS6ba33DORg99OYHwaD9yJ+r6rt8A7v_R36_Uf_hHkw=agyw@mail.gmail.com>
In-Reply-To: <CANFS6ba33DORg99OYHwaD9yJ+r6rt8A7v_R36_Uf_hHkw=agyw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 10 Feb 2021 11:56:22 +1000
Message-ID: <CAN05THQyVJ_4CN41Ep1Wn93BuFYgqUZ1fqCVnqiUebHtobu1tg@mail.gmail.com>
Subject: Re: "noperm" mount option not working
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 10, 2021 at 11:18 AM Hyunchul Lee <hyc.lee@gmail.com> wrote:
>
> Hello Ronnie,
>
> from the commit 2d39f50c2b15 ("cifs: move update of flags into a
> separate function"),
> "noperm" is disabled if "multiuser" is not given. this happens even if
> "noperm" is given.
> Could you explain why this is required?

That was a bug. Thanks for spotting this.

I have sent a patch to fix this to the list.
>
> Thank you,
> Hyunchul
