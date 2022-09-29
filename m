Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29905C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 22:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiI2WNZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiI2WNX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 18:13:23 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964FA139BF7
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 15:13:19 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id m3so3721317eda.12
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 15:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=eRyCPvPZZxYwXFNSo/W6sA/ZYiea2DcV7a4pnsRRR94=;
        b=Q/FOij97WrmwNlv4yD0XfcfYb0kHvenYahekG8795HxK8fDd9gC6/nruCpGEUiohmK
         88DTgFxWGceR1b+5BSyMJRnukjrQf8j/KU6g3/7VnofPCOwqgeRKjKRjqz9bXVm+g3tP
         OxaQ/PhubRZ1rIsMvg00268YuvXsyeIjGhmyWzX04/BY+9/kdQFCrp6bXpDc17fqNY/A
         IfgzPXCYJvcx9o4sRB+ZnLQr4QAPcvpV3qZnscfKPzQjtBabYiqw/NoKX2PacccxS7VD
         BobbststjpTSGnjJ6wLfYU48WPuRaUQcStLHMMgGdr8XlupRIGUtCwZKex+r/8MPT93f
         xOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=eRyCPvPZZxYwXFNSo/W6sA/ZYiea2DcV7a4pnsRRR94=;
        b=FQZ+vSDC9uig1fb7GEra6cBqhzQfYLtbxaaNDO7zNPzckv3vbJRMxUExYxEe2aEyWP
         SzksI704iIcuPjbv6JwNTQGko3NTVH2bzLcDIhHWvspK+ajBq4RxFLBRpXxrjF5g6BXj
         txD11nXgX+xLXSzJf8HW+afskpghk7NXDT/ipUST2iVofPidnxGmggnS/hZFxfVROAaI
         DS4J4R5yq9uyDBT3KOuNurRH/82YvHXfDonLyzQ2TNlcTcYZwWu/sjbrXFmHo/xN2sNN
         3iekMO4FkCB699bWlRMAzCq4UQvzEnBtU2NlhOB7my9YqJ1ZklfjUdZawJwsBbjy1QnA
         dXxg==
X-Gm-Message-State: ACrzQf36YHArn2LYynArZug2D6LD2bWK2egsBTfDgH3wcdOQ8wWB73zZ
        ZPDK6LVmxjWeuZJlRiX5Yzfrxig4Igm3ZqUBpEtqrsJubiA=
X-Google-Smtp-Source: AMsMyM5TLrVTeQQRLF8noR/lG9nGIseK4WXJZ2ZqXFnr6xTsH1VFMD0c5a/aHusNUsIuEee0fxkzOMTuXVbSp2EWZfY=
X-Received: by 2002:aa7:d504:0:b0:458:862:ffc7 with SMTP id
 y4-20020aa7d504000000b004580862ffc7mr5420607edq.67.1664489597945; Thu, 29 Sep
 2022 15:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muXa4pn4EYcW6quTgn1o++o6DYxAckpT9=CsRmcPKGL7w@mail.gmail.com>
In-Reply-To: <CAH2r5muXa4pn4EYcW6quTgn1o++o6DYxAckpT9=CsRmcPKGL7w@mail.gmail.com>
From:   Sachin Prabhu <sachin.prabhu@gmail.com>
Date:   Thu, 29 Sep 2022 23:13:07 +0100
Message-ID: <CAKbxtwS4K+9mmAwgCxzDOwDK=pW_mXeGO252VvfwnHpGcEynOA@mail.gmail.com>
Subject: Re: cifs.upcall debugging
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Steve,

Good to hear from you. I will consider what parts should be added to
the wiki. It has been so long since I've debugged this part, that I
need to refresh my memory before I can give you a good answer.

get_tgt_time: unable to get principal

The strace for the cifs.upcall helper is available at
http://sprabhu.blogspot.com/2014/12/debugging-calls-to-cifsupcall.html
The debug logging for the cifs.upcall is pretty good and if you can
see the debug output, you can get a pretty good idea. If not, the
strace will show where it fails in obtaining the tgt and usually
contains the debug messages from the cifs.upcall.

Sachin Prabhu

On Thu, 29 Sept 2022 at 05:43, Steve French <smfrench@gmail.com> wrote:
>
> This had should useful things about cifs.upcall (and an earlier one
> about debugging cifs.upcall problems e.g. with krb5 mounts returning
> errors)
>
> http://sprabhu.blogspot.com/2019/06/howto-cifs-kerberos-mount.html
>
> Shouldn't some of the cifs.upcall debugging info mentioned in an
> earlier blog post be also added to wiki.samba.org ? e.g.
>
> http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
>
> Any suggestions on how to debug cases where klist shows the principal
> but cifs.upcall can't find it - see log entry:
>
> get_tgt_time: unable to get principal
>
> --
> Thanks,
>
> Steve
