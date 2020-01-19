Return-Path: <SRS0=iK80=3I=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEE4C32771
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Jan 2020 03:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E626246A9
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Jan 2020 03:02:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="usOnYnEs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgASDC0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Jan 2020 22:02:26 -0500
Received: from mail-io1-f46.google.com ([209.85.166.46]:43276 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbgASDCZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Jan 2020 22:02:25 -0500
Received: by mail-io1-f46.google.com with SMTP id n21so30109466ioo.10;
        Sat, 18 Jan 2020 19:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agKJnFIyMT0PtPez9mJooFjHRmC2Gmtrz55KYKjIB2Y=;
        b=usOnYnEsw7MkaqdiNrdKTmvP+uiWJ5k/WQZScTOwDXRkr4NhFeXlEZnkNvuWwwEnvI
         sQEW5vHUFHu8QlE8QAQqrvvr8Iqvp++grve9sznveDooifToiDYrgBswTXyg303u7xo0
         WeWNXvYX9h+Hv9LF/PajGOjwTIELZGvHQxl5vQ7qEft7VDfa0o/EaIn53j3fJN4jmMjZ
         PTGLEx9kVf2L7d6UORQqkC8GJdTFauIQlwP1G4HoutiZASd+u1d0c6UEMDUkKSM/6DsJ
         tDxzDOcf0Nm0RFSB24pB/5dOSy4RNFQXtr0LLJWmKCMMTzv/hlhBmyXW+xbdv4+moYJT
         bGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agKJnFIyMT0PtPez9mJooFjHRmC2Gmtrz55KYKjIB2Y=;
        b=MKwfl1Ap1aWm8hBvUnamZJuuDvs+DvaOWdCNXXOEVJgr+rkWY6mFe9ddav9i2yRH84
         RUn64HiVIXgh9NWbq2eRfMFNhI29QWpu6vCvEZrBBU/ya1Z+WHYx0phMUj8HkVUxZ/B/
         oMLdGyNiw+JPr4nBA5GrUL9xyneiyqvhTBSV0Or1GZ8Ef7jcZLgk/pUrF7EStxyfwAic
         Cg+hryv8J0MW6HyE2VmuTgorkYWiIo3UECAomXY7/Ozp9PvHn9IlxEHJ0Ido5xKteR7H
         y5uvw/pH46Li3OPnzO9jkn+Ktg/UcRZx9nWVDBVY0tcU5wntFbBHpK/S3ZiIkGtZBeKO
         fOzQ==
X-Gm-Message-State: APjAAAW6NrEG9WABixSsX6cVAs+i+/HpHT+X7OpLHXwUhaZoiHjZYCbF
        /foFxNf8l99olVzSeuSbN6aIdBxDYLuKOGdKDHFJStFy
X-Google-Smtp-Source: APXvYqwQFBC7GPvwXB412C6DZC5jj5YFtPBJjvMDh/Y2HA2eCNvipq11ooWDqtn7hshWb5mgJhPuSlFkLt/8SuMLVDc=
X-Received: by 2002:a6b:c413:: with SMTP id y19mr36039473ioa.272.1579402944745;
 Sat, 18 Jan 2020 19:02:24 -0800 (PST)
MIME-Version: 1.0
References: <20200119122200.460fa314@canb.auug.org.au>
In-Reply-To: <20200119122200.460fa314@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 18 Jan 2020 21:02:13 -0600
Message-ID: <CAH2r5muJts7nak9C8D3VrMKaTdP+n=ky_oMYX2DJgOKmXDBYiw@mail.gmail.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the cifs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fixed patch and updated in cifs-2.6.git for-next

On Sat, Jan 18, 2020 at 7:22 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Commit
>
>   e09386c25142 ("cifs: remove set but not used variable 'server'")
>
> is missing a Signed-off-by from its committer.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
