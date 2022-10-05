Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A89BC433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Oct 2022 23:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiJEXAR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Oct 2022 19:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJEXAP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Oct 2022 19:00:15 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9953D1BE92
        for <linux-cifs@vger.kernel.org>; Wed,  5 Oct 2022 16:00:14 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id k9so46682vke.4
        for <linux-cifs@vger.kernel.org>; Wed, 05 Oct 2022 16:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date;
        bh=7pEYE4KLqgHM30UwE9NXxiOcWsUijSyuz60XmDfaLrk=;
        b=lpz3zPSLSA+3ksn8VOIz3P5RLzyYs0lbL/wFBgOoQxYajZkLd59vDgCjuXRKGHvkDA
         oQBu3rJ9ojwEf93EaxKvdoCjlRk86PY9IwzBC/sYNo0bV7oufAB3OsbjNiU/g9drXztP
         JLkD4A70lKyc3U69ZNouEk9KBomrAc8N3CFZRPyYlNgc6sbNMYGs30yJ4gWhUEfVtr89
         AvWfTOKkMt6DKvihKIk6u+TuGu38Q3rOMvoXT7VYcKdiwfMcLS6a0PclsOHm+wjiATk/
         pqR1NgUvLRYcDqUBZKJvUL/pigpTR7Gr2sk5SF3jqMID0V25bjKcPKTI/SkQdu2UsnXt
         dmXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=7pEYE4KLqgHM30UwE9NXxiOcWsUijSyuz60XmDfaLrk=;
        b=MzFemk/3lMZaUkGgp6O7K1qYzH4ao9JcoUMtSi3LWLpFNhjhAJsrCZwW7mGA4L0Y50
         6xjzZ+c7wUhWl1OWQMS66iAzOkdnCfWAF4aVPbJY36XjMjCYLYnsy5pcQkypJMQtPUGH
         n2uzTH9bmHsiNerycQdOD3PYst18Fp+VKu5ioYLE7smwgbdo96K1m5SYmXQ3OPmwyUFL
         6Z6AsKJGRmmwj9todGSwV2Rsv3RTQuQdcfi1cayOVRtbWtp1fOztJSVkQ8q6nPO5mfL0
         Ij4uCTwbZilwwaZ+4HCgRpSiSuTns3KKjRkA9Ka5x1CPV+3+OlPalu/TivMiTff3azSy
         jY3g==
X-Gm-Message-State: ACrzQf2CNhplhXM6wB5X066enRFHVRt1b507gdjhEc013FuYiDaaEhCl
        WH14d8L91c1giQ0NFE9g0Setp4R6qNEVNO+DhqsbV3rLX7U=
X-Google-Smtp-Source: AMsMyM4mO6eH7EBCtduTU0kn8wwVbzUwShzHOTeoqfZiZf9DlTpv/RdcrkcSmwG5A3LTTkkNxTz4psuURxuY28jNJ0Q=
X-Received: by 2002:a1f:dd07:0:b0:3ab:3e5:25bd with SMTP id
 u7-20020a1fdd07000000b003ab03e525bdmr1035150vkg.38.1665010813407; Wed, 05 Oct
 2022 16:00:13 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 5 Oct 2022 18:00:02 -0500
Message-ID: <CAH2r5ms9NbH+_ruMke+ezYo-7+qZuinrP_SQbHxf3E3ikxnN0A@mail.gmail.com>
Subject: build failures on 6.0
To:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I noticed that 6.0-rc7 and later don't build out of tree modules (was
trying to setup ksmbd for running buildbot tests).  Any ideas about
this "unrecognized command-line option" for gcc error (this is on
Ubuntu)

smfrench@ubuntu20-ksmbd-target:~/smb3-kernel/fs/ksmbd$ ~/build-stock-cifs
make: Entering directory '/usr/src/linux-headers-6.0.0-060000-generic'
warning: the compiler differs from the one used to build the kernel
  The kernel was built by: x86_64-linux-gnu-gcc (Ubuntu 12.2.0-3ubuntu1) 12=
.2.0
  You are using:           gcc (Ubuntu 11.2.0-19ubuntu1) 11.2.0
  CC [M]  /home/smfrench/smb3-kernel/fs/ksmbd/unicode.o
gcc: error: unrecognized command-line option =E2=80=98-ftrivial-auto-var-in=
it=3Dzero=E2=80=99
make[1]: *** [scripts/Makefile.build:249:
/home/smfrench/smb3-kernel/fs/ksmbd/unicode.o] Error 1
make: *** [Makefile:1858: /home/smfrench/smb3-kernel/fs/ksmbd] Error 2
make: Leaving directory '/usr/src/linux-headers-6.0.0-060000-generic'
smfrench@ubuntu20-ksmbd-target:~/smb3-kernel/fs/ksmbd$ uname -a
Linux ubuntu20-ksmbd-target 6.0.0-060000-generic #202210022231 SMP
PREEMPT_DYNAMIC Sun Oct 2 22:35:09 UTC 2022 x86_64 x86_64 x86_64
GNU/Linux


--=20
Thanks,

Steve
