Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD08DC433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Feb 2021 00:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8853D60238
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Feb 2021 00:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhBZAfW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhBZAfV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Feb 2021 19:35:21 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3CAC061574
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 16:34:41 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id w36so11354100lfu.4
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 16:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YDUjYyZVT51ov5dZf0ShD3ItPUSdb4knqQ6jDvrtbZ0=;
        b=Fwy0ONFM1Q8XKpfXCezsqqF+4D6xsp+KjZdFYEttUax+6EFg8QCR+2F521SBl7jO37
         rDVXke2v8W+YONXCyh+n9cVPr5IGZiTLAnB7x56+ZnjZOB5sC8A/g/HY9o3q8M5ZfJMz
         jQ0TOnQHANsxr0yZ4W42lpV2hzwCJCG7EqPZlRfQpCGKeUTZl0Q3PHK7BH8e09xbjIds
         HF21Uvpu+LkYJsxdPE4uw/a3P1S+Uy5W1KGiF9O7g9401xGMc8niYlCOdEOqS6hP8H98
         RqUID8mh5wKPTc6WYSxiMDylnmeLvFlu5AOlPsIQ7dTP5P2DJ3KHArDcLnGepGINuDg+
         xmhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YDUjYyZVT51ov5dZf0ShD3ItPUSdb4knqQ6jDvrtbZ0=;
        b=aBZsBVViSbdk1V4pe1WJEYugqtFgS8I2GvnBf85Fr4vChJPD88Vg/wk0jq/L8YOZTd
         WLxeviKzV1QaErtdf3qO4eSzHzTqeBt/r+i6PKgcUSIAkois2VqN4Nf4OYXKfwjgj7hj
         iFSWIL22CvrjI76E0IisCJngqkwcZUG/mKD5JY9f/vWImvV+LySdlgU1nZ6YiOhyVT7k
         Tujq+j9gCobPphW4j35MwZwLBNzthm65+nh7e2xkZOVjo/SJ8lb74CgVQZ8CDR9nbZhF
         xOjKI+KR+2njZUW/Ef4k/GodQPs96WIhZSNqmjSUR/aPqIVdbrmukivlo3Rmp+/gE0Dy
         1GlQ==
X-Gm-Message-State: AOAM533wTR3F02AUBCa9MuyMUbQ58Hd+oBOkhTgLmTFy7j8+W4CiY6Cb
        4OcCxzBS/wstP5BnZLzTsek4lXOv0dq5qotFnyfeXqjBHA31Ng==
X-Google-Smtp-Source: ABdhPJzK8AKASBRM4hyz/SjzOz2HflRB/xfR2NJak5TuzehWI8ePclHNMf89TQMSluPQ1RgxYZYMfX36LZZKHTs7AOU=
X-Received: by 2002:a05:6512:31c1:: with SMTP id j1mr237231lfe.313.1614299679564;
 Thu, 25 Feb 2021 16:34:39 -0800 (PST)
MIME-Version: 1.0
References: <1462a108-7130-b94c-cbd9-457c2cbdd504@totally.rip>
In-Reply-To: <1462a108-7130-b94c-cbd9-457c2cbdd504@totally.rip>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 Feb 2021 18:34:28 -0600
Message-ID: <CAH2r5mu+GOOb8V6PvnDSa_wQnQMBWAgQk4ERsfYrevLngjoOxg@mail.gmail.com>
Subject: Re: Passwords containg commas are no longer working in credential files
To:     jkhsjdhjs <jkhsjdhjs@totally.rip>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes - it has been reported and fixed (although not pushed upstream).
I expect to send it upstream and cc: stable so it gets backported
fairly quickly.

See the email thread
"[PATCH] cifs: fix handling of escaped ',' in the password mount argument"

On Thu, Feb 25, 2021 at 6:09 PM jkhsjdhjs <jkhsjdhjs@totally.rip> wrote:
>
> Hello,
>
> I'm using a password containing commas to mount a remote cifs on my
> computer. I recently upgraded the linux kernel on my system to 5.11,
> which seems to contain a regression, making the comma a separator even
> in the credential file.
>
> I'm using `mount /path/to/mount` to mount the filesystem with the
> following contained in `/etc/fstab`:
>
> //domain.tld/share    /path/to/mount    cifs
> noauto,credentials=3D/home/jkhsjdhjs/.credentials,uid=3Djkhsjdhjs,gid=3Dj=
khsjdhjs,dir_mode=3D0755,file_mode=3D0644
> 0 0
>
> My credential file looks like this:
>
> user=3Dmyusername
> pass=3Dabc,def
> domain=3Dmydomain
>
> With Linux 5.11 or 5.11.1 the following is printed to `dmesg` when
> trying to mount the filesystem: `[ 3051.668834] cifs: Unknown parameter
> 'def'`. This worked fine with 5.10.16 and below, the man page also says
> this should work:
>
> Note that a password which contains the delimiter character (i.e. a
> comma ',') will fail to be parsed correctly on the command line.
> However, the same password defined in the PASSWD environment variable or
> via a credentials file (see below) or entered at the password prompt
> will be read correctly.
>
> Thus it seems there has been a regression in 5.11. I tried to identifiy
> the commit that caused this regression, but wasn't able to. I also
> checked if this bug is already known by searching lkml.org and didn't
> find anything. Sorry if I missed something.
>
> Best Regards,
>
> Leon M=C3=B6ller
>


--=20
Thanks,

Steve
