Return-Path: <SRS0=dbuF=XK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F9DC4CEC6
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Sep 2019 04:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C035A20873
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Sep 2019 04:12:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kxw6FpsG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725613AbfIOEMC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 Sep 2019 00:12:02 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:35600 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfIOEMC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 15 Sep 2019 00:12:02 -0400
Received: by mail-io1-f41.google.com with SMTP id f4so70594514ion.2
        for <linux-cifs@vger.kernel.org>; Sat, 14 Sep 2019 21:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uHD6y0z/b62cMiiBGIEyOMtcc8DsUDughrqVEUj3gEs=;
        b=Kxw6FpsG511ULV4H58RbRvRwXi8AZ5jqQN0I4xx4eJWtjFeSxR27OmMDTkSihVkIlq
         s8+AHMNViu+axNddz0mxU4PK8OiLhhPVH5zJwWQmK7jP1ie8o35tkFhWfAftuyKWh4Fa
         S2ZGyWTbikIElvAnpH7hPuWnBL6kOapWMHD33M4hS4KVLUOkM1jfgQSdDVxtkgzw58ys
         xIprqxByXzSAs6rimku3O15EQIWUy8CfWlWseU01mBLkuTB92ot2vLZp5l355Gviw6tM
         ZxSG9D2S2Qozovw0dAs8zbfUgfDGTXzgO/Rd3eSuH//BZYSwMe1gBxcFsYYzLhZdLkDZ
         toWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uHD6y0z/b62cMiiBGIEyOMtcc8DsUDughrqVEUj3gEs=;
        b=WKFqJayl6vMqUGdhwEW34PeI4FvhnmNMNZn0WKIq0KwSj782OT9/Xu4N+WJ/phrJcp
         /seeJkd6bQqVoVQKmZXycdN64KQE7CX7RV3Jnqz8h/faTiOrtFS16lNHy9VJy/q9beFB
         FA/Ul3Rk86E+GNfP730z/vSbrZzD4AUfZaARPpk9iCEdmZxTxau56jnh5R4z2vHuGo8A
         aX+0DJKJ3ZORi//jMzlWBcybtD/TFxQgGF25SXdkK44aaJHxUbbER9b8i7yaYROpzft5
         4f/1I29Lqtq+OZr5nr9S2ND9zbg+kjiwi8onyqrs1e9Q347RpFdz7AKKN8WZp/tsw4D3
         Ttow==
X-Gm-Message-State: APjAAAVTQ/7OxafvxDxnjkvA9+TWOohP9QcrjbDYwASAcwNGadU146gH
        TAZd7HeZuRUfrQmdshxPYsoP7MJZClN2vu3GA7s=
X-Google-Smtp-Source: APXvYqyEEUwxf1DY8htVZ4JC5+Pvs/b3mHO5r9cqJtWfkw1gjsuNJDFXnXIF+a8p2ufQwdduqqLC5v+0wp3kBppLt6Q=
X-Received: by 2002:a5d:8f02:: with SMTP id f2mr9324195iof.272.1568520720885;
 Sat, 14 Sep 2019 21:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190915020810.jy5pxjtk7buenmqk@XZHOUW.usersys.redhat.com>
In-Reply-To: <20190915020810.jy5pxjtk7buenmqk@XZHOUW.usersys.redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 14 Sep 2019 23:11:49 -0500
Message-ID: <CAH2r5muncmiTKBuaYEie6L7PeXmQ-MjKsBy9WrET4v85f36=qA@mail.gmail.com>
Subject: Re: seek sanity check failures
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Test 285 and 490 broke when xfstests were updated on the buildbot, and
are temporarily deleted (commented out in the buildbot script).  We
had a difficult choice - update xfstests and add 10 new tests but
disable 3 tests which broke with updated tests, or not add the 10
tests by keeping running last year's old xfstest test suite.

Ronnie and I did some investigation of why 285 and 490 failed and any
additional data would help - since we both got distracted with other
features and fixes

On Sat, Sep 14, 2019 at 10:14 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> Hi,
>
> On latest Linus tree, several seek tests fails:
>
> generic/285 generic/490 generic/539    fails on v3.11 v3.02 v3.0
> generic/285 generic/490                fails on v2.0 v2.1
> generic/285 generic/448 generic/490    fails on v1.0
>
>
> Are they expected or being worked on?
>
> Thanks!
>
>
> FSTYP         -- cifs
> PLATFORM      -- Linux/x86_64 hp-dl380pg8-14 5.3.0-rc8+ #1 SMP Thu Sep 12 07:31:21 EDT 2019
> MKFS_OPTIONS  -- //hp-dl380pg8-14.rhts.eng.pek2.redhat.com/scratch
> MOUNT_OPTIONS -- -o vers=3.11,mfsymlinks -o username=root,password=redhat -o context=system_u:object_r:nfs_t:s0 //hp-dl380pg8-14.rhts.eng.pek2.redhat.com/scratch /mnt/testarea/scratch
>
> generic/285     [failed, exit status 1]- output mismatch (see /var/lib/xfstests/results//generic/285.out.bad)
>     --- tests/generic/285.out   2019-09-12 08:04:14.120990746 -0400
>     +++ /var/lib/xfstests/results//generic/285.out.bad  2019-09-12 08:36:49.151230335 -0400
>     @@ -1 +1,3 @@
>      QA output created by 285
>     +seek sanity check failed!
>     +(see /var/lib/xfstests/results//generic/285.full for details)
>     ...



-- 
Thanks,

Steve
