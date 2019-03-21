Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEA2C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 01:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 198AF218AE
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 01:44:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tN+/TiDR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfCUBoV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Mar 2019 21:44:21 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41425 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727586AbfCUBoV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Mar 2019 21:44:21 -0400
Received: by mail-pf1-f194.google.com with SMTP id d25so3210803pfn.8
        for <linux-cifs@vger.kernel.org>; Wed, 20 Mar 2019 18:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SrcE/oThReZFVTT1fjhCvgr9X6BwCk9XX2Iif0dWb38=;
        b=tN+/TiDRWxglWwQYt+3+OcDGBUJz1JPLtf5Fveim//pQAh2lGY7VCXCcJxIwuDX6vB
         eraGahrc73VdpkUzVZ33OsmIJNvgHYxNnjigkB/c2MB+WVwvO9zhbh+cbDHOZ+et8E7I
         0LeCt2uvXMdBiIPG7fONB/HLJKVXfZXJOlrssxPd3Hn25YszXgWh0o/mGC5i5zDz6+2g
         brRa7UVjj+AR6n0C13xHQ1ekb1hmWJ86eYVfR3tg5aYaekmNb0pIegoTm50dIuvdzm+M
         5NcX0uk/zn/Whgz6GI1AoXlBjiIxxdPdbGbyQqky0Av5155cx7Rb3ttNotwVhRKOIyng
         6R8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SrcE/oThReZFVTT1fjhCvgr9X6BwCk9XX2Iif0dWb38=;
        b=DfDYTIuykK5K8yoaCJXE6gyRzaPjGCUW8x/OpEvKfvwiZ6bAVHvJ02z/Gg8WPesu8Y
         xf4l9OI6LT+NWK9/siLWHUVRijr2c5XjSN9ysbKaZtAhXY8KUK/SMbJOVGw3G97VijBC
         9Yjnr1UPwHwvZKa66OAw1oTyOVke0l8d8JdqWY6D9mnp0fmCcBgCreceXf+xEuIj62yH
         jelBRYY8FC4G/t+c1Lca3+Wq90kzCipB05EM3Q8EgzjUAiYb+JzreZU29oK6sf+usy7g
         9ngTj89lenQw7Bs0Uzq25LD1cyI+KkaTBcYLNyy4af540dt9YHL49bN9bGt3DGKdndAV
         e5Ug==
X-Gm-Message-State: APjAAAUBge+zFQqrrR7Yi67JmFipBBT5w7J/x+2lfuMekGHdxRxlqAaU
        1aPgMK1H8+TQhUUpkoZ+E2Op4aYXk5QaaDnVSMA1Tw==
X-Google-Smtp-Source: APXvYqw4XSYcScIYTMkRrkDDECl6S819NFEIBfr7E5S4qfLIhkjTabNv42fi6yli1U+XiJdObfv//HahFwBTXNjxYuY=
X-Received: by 2002:a63:1053:: with SMTP id 19mr1007448pgq.55.1553132660231;
 Wed, 20 Mar 2019 18:44:20 -0700 (PDT)
MIME-Version: 1.0
References: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
In-Reply-To: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 20 Mar 2019 20:44:08 -0500
Message-ID: <CAH2r5mvm+pFsaGU1dQrkLJQ0O6ggkOff0yYLe6VV9m4RgpyfUA@mail.gmail.com>
Subject: Re: "Bad SMB2 signature for message" with kernel 5.0.0, works with 4.19.0
To:     Andreas Hasenack <andreas@canonical.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like you have "server signing = mandatory" in
/etc/samba/smb.conf on the server.  Is that true?  That (in theory)
should not work with guest according to the protocol specification but
I am comparing with 4.19 behavior to see what changed (maybe we
ignored 'sign' if guest?)

On Wed, Mar 20, 2019 at 1:40 PM Andreas Hasenack <andreas@canonical.com> wrote:
>
> Hi,
>
> I can't mount a share as guest using SMB2 or higher when running the
> 5.0.0 kernel (ubuntu's 5.0.0-7.8 specifically). When I switch to a
> 4.19.x kernel (4.19.0-12-generic), then it works.
>
> This is the mount command and output:
> root@ubuntu:~# mount //localhost/pub /mnt -o guest
> mount error(13): Permission denied
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
> The share is a simple one:
> [pub]
> path = /pub
> guest ok = yes
>
> The server logs this:
> [2019/03/20 18:24:46.245816,  0]
> ../../libcli/smb/smb2_signing.c:169(smb2_signing_check_pdu)
>   Bad SMB2 signature for message
> [2019/03/20 18:24:46.245860,  0] ../../lib/util/util.c:508(dump_data)
>   [0000] 2D 60 1F CA 49 06 92 B0   69 06 60 82 42 39 21 F8   -`..I... i.`.B9!.
> [2019/03/20 18:24:46.245894,  0] ../../lib/util/util.c:508(dump_data)
>   [0000] 75 F8 77 09 63 D5 4A 7B   9F 91 51 93 6D 12 6F 6F   u.w.c.J{ ..Q.m.oo
>
> Here is a dmesg output with cifs debugging enabled:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1821053/+attachment/5247960/+files/dmesg.txt
>
> That output was from a kernel running patch
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.0/cifs-do-not-skip-smb2-message-ids-on-send-failures.patch,
> just a quick attempt to see if that fixed it, but it didn't.
>
> mount.cifs is version 6.8
>
> Server is samba 4.10.0.
>
> Is this a known issue?
>
> Thanks!



-- 
Thanks,

Steve
