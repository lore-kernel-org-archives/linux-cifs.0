Return-Path: <SRS0=fxvP=RX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0AC9C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 22:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B105C218AE
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 22:08:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rh2Bvo0V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfCTWIY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Mar 2019 18:08:24 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36212 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbfCTWIY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Mar 2019 18:08:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id r124so2786589pgr.3
        for <linux-cifs@vger.kernel.org>; Wed, 20 Mar 2019 15:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h6eybnrj5P0yS5vw1vuDXv7XMVqgOmIXZ0wpC/VjWpg=;
        b=rh2Bvo0V8kXZMrZ1Im2fgmrJwkl5qxHmyIcFJwko2wQ5gFuencTb305ZBUthwNiUUl
         QlT5vbCx6WvZYpoyDvFd6qF+XDKPNHujuNJssrTjgR93XD8EVxgSJSr0oPC6aTzEo0Dn
         VGj9rD/EjjeOuJaXpg3ysIj/6tfd4P9uz9mDkvtJXEDT1LYA3e1mDxAq5DaDuaQT3rWh
         7Ce+8N86+rkueqE1QGO3vQf4mLGyd1tmXgMzhmkJ51oNOpGhyK5deCrvhRMDH6yAnOez
         oNlSFHMbjRQSs/RKCnmt9hou/2CZnen1dv4N+5yVdN7K5vtb8Gn99di/0MDSoPlHwvcX
         NiVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h6eybnrj5P0yS5vw1vuDXv7XMVqgOmIXZ0wpC/VjWpg=;
        b=IHewo/06j8Fkhnu6lCGvS/hwZuOUlAzyusyKgV+X/8rNgeFPHxQUGyAUc70veaI05I
         ic+E2yCnj5B1phfKNUa4U1puzLEg+2PTMrcCd0+G1xKMgk+eWrycz9MpbtQoM5BfiHhr
         DfuL3RB6tIFUOVSmuLEeL+KEh51VQ3bvUFC9/rIacZekhFf2qCnI51JZdWhTMUZwZfw4
         wS1L3eFXxapHDLP+u68owPVrUOcdrfSVo0LWCFY6GMseVE99rGLibRgoeKiuemdABkeI
         G3177z3RObTtZOenlFlGsdetCeNxpTWt8Q1z6/h+r7AfGySSWPcp0VXaOcXEQUYfAmnW
         avBg==
X-Gm-Message-State: APjAAAUOzYRfL6XQhbM7VAeTIVVyG3zpiRQolSQKbAaxvwFxD7P7biUz
        nKDf/V0RajbCWDo97trYdr0l1sTDizBtqK5iMpg=
X-Google-Smtp-Source: APXvYqyhmCH7BJuJfYTtsaMIlZ9/yn2l65707M8DuwyWB7QKKf+zq8A8JEwKWTmO7F0YFYx1ltkpEDyfhSlFnHS0k1c=
X-Received: by 2002:a62:59cb:: with SMTP id k72mr71627pfj.111.1553119702956;
 Wed, 20 Mar 2019 15:08:22 -0700 (PDT)
MIME-Version: 1.0
References: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
In-Reply-To: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 20 Mar 2019 17:08:11 -0500
Message-ID: <CAH2r5msqKdOwDwTsfeXGKg2wQ0tHfNGp+Lh=EchMKO+a5k6NNA@mail.gmail.com>
Subject: Re: "Bad SMB2 signature for message" with kernel 5.0.0, works with 4.19.0
To:     Andreas Hasenack <andreas@canonical.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Paulo Alcantara <palcantara@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I am not sure it is legal to require signing and to connect as guest.
 See quote from protocol specification (MS-SMB2):

If the SMB2_SESSION_FLAG_IS_GUEST bit is set in the SessionFlags field
of the SMB2
SESSION_SETUP Response and if Session.SigningRequired is TRUE, this indicates a
SESSION_SETUP failure and the connection MUST be terminated. If the
SMB2_SESSION_FLAG_IS_GUEST bit is set in the SessionFlags field of the SMB2
SESSION_SETUP Response and if RequireMessageSigning is FALSE,
Session.SigningRequired
MUST be set to FALSE.

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
