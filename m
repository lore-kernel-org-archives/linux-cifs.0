Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796F4EB64D7
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 05:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjFZFcF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jun 2023 01:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjFZFcE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jun 2023 01:32:04 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5507FE1
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 22:32:02 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4f865f0e16cso3466536e87.3
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 22:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687757520; x=1690349520;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/w7JG8rtdp7Al9AynqMYZ/Vjyx1V6F2+7ylD1hUPbSs=;
        b=KJl1fwKcSmdwt2n+BeQY47/GCuZmQlBx/sLhzmklIAYITC7zx/eRPcJ0q7fU3y1nfR
         WSu6Ku+baXLrhzssJ6SPDhFDR5qMWDVGu+pcYPWio90zNPkqoAVfWyap3kTx8j1o1p5X
         Ev0QL4XKcBaTyhl5tEUNHYpKhAtsdnFUm6YB3WGHYdqRrnwUtcSFCrhCQyWAHSn0uLzu
         l14JVp09B7TQPk7VHlnkYLyAFXmVEAD/YmiXTPokp5Nh23QAC3H9GRzb8FWH7EkiTKkV
         IjXBo9NIsTCK3WNtxlc4wKCT78timRKbJ/ec62lEzJHiUqsuAK9mrakjJmMGtcm86gsn
         q74w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687757520; x=1690349520;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/w7JG8rtdp7Al9AynqMYZ/Vjyx1V6F2+7ylD1hUPbSs=;
        b=BolGX4hu+e+u7PxdWIplOocyOQzg8ZiyghFuy3kTF2wXkfojmBk2m+B19O22gqZMpe
         hczPpFBsDX66FDvqpXQN4eaKL9uiXKHbFp1JlR8LrRONm9Wysq4Op3/qZxBenXyNhZ4N
         nu6D7mI2o45vm7+rc0eJKiF8E4/m8cAXn0UEct4tUlxYcZ1rhAV2gbbvOjQM1e73h9oO
         KuPLaSDS04j7UlhmsYFLrAfiZE2oiT+lBSvl4Zk4g8KBy6Pj5dRgJNvmUbhvqln3JRHh
         buyFJcHfZj0M7bRmw5tYciDK+XsMCFl3AwI6bSqrGLINTV2ngcZII35HIMSyxqR7Cg6T
         qQiA==
X-Gm-Message-State: AC+VfDzyBVaH1VeA2ZxeQkBCWbx/YUlaNJcKzmH/h5Ov4GBc2nMzH30a
        UDlo0sO26ytqBnwbDHCAnLTMbZS7oJ+zsOo1fjX8bbbq4wM=
X-Google-Smtp-Source: ACHHUZ6dw+bSHw0iBd/RSvdxPFQVw0VG4ezPaypq4Ct36pEqOlRpfJvHd9OcZ8bogf2Uz/E+62Tt4TUt6HqkVo/g4Uk=
X-Received: by 2002:a19:9106:0:b0:4f9:54f0:b6db with SMTP id
 t6-20020a199106000000b004f954f0b6dbmr9598055lfd.13.1687757520214; Sun, 25 Jun
 2023 22:32:00 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 26 Jun 2023 00:31:49 -0500
Message-ID: <CAH2r5mu2cnsjar5O3Ks5x_eioR41iWRnNUm85OT9sGyMRxNe+A@mail.gmail.com>
Subject: generic/091
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@manguebit.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Has anyone investigated (or have ideas) about why test generic/091
fails to Samba server?
I doubt that this is new since we had not included it in the Windows
target group and were only running it to ksmbd and Azure, but I do see
it passing in some of my tests earlier when run to Samba server on
btrfs

generic/091 103s ... [failed, exit status 1]- output mismatch (see
/home/smfrench/xfstests-dev/results//local/generic/091.out.bad)
    --- tests/generic/091.out 2020-01-24 17:11:18.688861397 -0600
    +++ /home/smfrench/xfstests-dev/results//local/generic/091.out.bad
2023-06-26 00:23:03.249198244 -0500
    @@ -1,7 +1,7584 @@
     QA output created by 091
     fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W


-- 
Thanks,

Steve
