Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00306C001DF
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Jul 2023 06:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjGYGWI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 Jul 2023 02:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjGYGWH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 Jul 2023 02:22:07 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EF312E
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jul 2023 23:22:05 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b95d5ee18dso75475251fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jul 2023 23:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690266124; x=1690870924;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8/aaov31GRADYeojPZcpfez5JZNiRK6LlYuMrumAfXs=;
        b=puLZ/3/fI6FNKK2c1j6LnvRtEXR2cIHL5LtfVjvHbR8gJkFtF3I2+TIYWR6frnwGbS
         Tq/AM/63fGyDgtVAdd1Xlxdn80NLhp+YyFYFGSLtMKhrsM7umpbkpOjjzs9tY3ruJD6x
         6bcK6ZwIngphqyGVrjbUwl/Jz2PpGoF+3dG2g9GNHp9ujV9oJeNiqHOVD3W4WWpvjUTF
         SUx1eK15t6ClOwexSkY6kAGpMDNEDwJlkYC+l5NT1U1BJUyO20s21MPIKwvA5/SEe+FP
         YHun22Rgkt72q1DdEFILagoQt/WIrujA2BgL9YJVvQKnlojWix/usARd0KmfNJffyS6w
         myLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690266124; x=1690870924;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8/aaov31GRADYeojPZcpfez5JZNiRK6LlYuMrumAfXs=;
        b=GqjnR0Esas+/sgYqNUBTrNW4Ax6hy38taltGI4qSw435s9HPDZM47FUKcaDIPzv1ot
         q8we6zEGc/PO8ZRlwPtClBQquQmI6RDf9lAtvcg+rgb17zFPsnrVLm+e1hcFKBtLr+vv
         vXEs2uQD5IkFV+SMFcEoPP/wGUyiu7XZ2ucvItGAxZDSPl02gsi/XQjtaHtcsHDlVPCz
         xuLvwEVvDLvY53Y0Og11IBJGtvNGnmP77qpyWydPEr0mY4gImpDAHhDu2FDsVaRy+AYC
         UVCjDqqMVgzHPJ0zK0ubUCexZsTv36H7y3o67aWS4PH8fwOkSjv/KIf6seBD8pk6y6yO
         7p8Q==
X-Gm-Message-State: ABy/qLbZRIo92CtYBGMa/ANHzUnhGvoXYEUo0G3GrWbAN2QPfQyOEIOm
        7LH4VqQfAbRirtY/L3OF5dLPY6PBkfLtpeFGg5wynhtQ
X-Google-Smtp-Source: APBJJlEz691p1+OIaXw8Ik3+VsAkBu50Mp2DO7ooMwqsw3h4JJY6n7dMBY7RbrtLwkfzn/albfqHm9pFi8Fg+ZNhAvA=
X-Received: by 2002:a2e:8911:0:b0:2b6:e159:2c3e with SMTP id
 d17-20020a2e8911000000b002b6e1592c3emr7666770lji.33.1690266123689; Mon, 24
 Jul 2023 23:22:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAOBqJ54ZGwCjuwZZwdTag3p-xSjWk_0Y1P61gbjVS5boCn8oLg@mail.gmail.com>
 <CAH2r5mvgPSf=e7b7jXfY+v1bzJfmfAhdqBkkomKG5xn4xMa8Ug@mail.gmail.com>
In-Reply-To: <CAH2r5mvgPSf=e7b7jXfY+v1bzJfmfAhdqBkkomKG5xn4xMa8Ug@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 25 Jul 2023 01:21:52 -0500
Message-ID: <CAH2r5mt94wGH9jr+xaVfjkAuMJSvhhSL6pEBNOM__Dx+S_ahDw@mail.gmail.com>
Subject: Fwd: Question about NTLMSSP_NEGOTIATE_VERSION in NTLM messages
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I have a patch for this now in cifs-2.6.git for-next.  See
https://git.samba.org/?p=3Dsfrench/cifs-2.6.git;a=3Dcommit;h=3D19826558210b=
9102a7d4681c91784d137d60d71b

On Tue, Jul 18, 2023 at 10:23=E2=80=AFAM Roy Shterman <roy.shterman@gmail.c=
om> wrote:
>
> Hi,
>
> I see that in the commit bellow we added Version into the negotiate messa=
ge:
> commit 52d005337b2c94ab37273d9ad8382d4fb051defd
> Author: Steve French <stfrench@microsoft.com>
> Date:   Wed Jan 19 22:00:29 2022 -0600
>
>     smb3: send NTLMSSP version information
>
>     For improved debugging it can be helpful to send version information
>     as other clients do during NTLMSSP negotiation. See protocol document
>     MS-NLMP section 2.2.1.1
>
>     Set the major and minor versions based on the kernel version, and the
>     BuildNumber based on the internal cifs.ko module version number,
>     and following the recommendation in the protocol documentation
>     (MS-NLMP section 2.2.10) we set the NTLMRevisionCurrent field to 15.
>
>     Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
>     Signed-off-by: Steve French <stfrench@microsoft.com>
>
> Now if I understand correctly the server side should return in
> negotiate flags the flags he got from the client and that it supports.
> It means that in auth_message where we construct the negotiate flags
> we will have the NTLMSSP_NEGOTIATE_VERSION flag as well although we
> are not sending the version as part of the message.
>
> Doesn't it contradict the MS-NLMP spec?
>
> Thanks,
> Roy



--=20
Thanks,

Steve


--=20
Thanks,

Steve
