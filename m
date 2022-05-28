Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D19C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 28 May 2022 22:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiE1WiU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 28 May 2022 18:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiE1WiT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 28 May 2022 18:38:19 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BED4939C5
        for <linux-cifs@vger.kernel.org>; Sat, 28 May 2022 15:38:18 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id i186so7476907vsc.9
        for <linux-cifs@vger.kernel.org>; Sat, 28 May 2022 15:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=uiS9SmfmKYaMiJrRetIgon5Dn/KyHXhXz2mf7RVxhs0=;
        b=OBS3d4Mk7Je+8M6EWiFdsRB9ips+5heYdTg0Z3SZ+3+00svdkDhUnLsQ0Hi8aqLlHQ
         2KHRoBbv4j10i3IhVBuAhZJwRsjRr2ycnozoCYyBq2W7vEoOMweex9qo7aPVYRpsJ247
         peluyuSMvQZ6x5edoADrErztUXtXksb1X2iqRRw+0glMPrQu/6sgbV/1FlkOAnhgwi6w
         aGKad2DDJfLFRi7gpho3u+orKKygxhYmJSxXtcp3x65VJpwCQQrYsA1lZkTr8K3uGpwu
         Wx89ZnKN31O3VC4pIRYAvBWfgAn1IvrSQ2VGClohvG5sVSeAJJBJGSjcGCT5VSpSbJ+i
         7woQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=uiS9SmfmKYaMiJrRetIgon5Dn/KyHXhXz2mf7RVxhs0=;
        b=mOGBXkLp8HElGzc1wy8JLy1LFgvrl4Abj+DQw6BRz7yyA2m/EKA2uRXfJMkvxX2AmW
         pJ+Q/GUYa8rXoT4Ik00CiAmFFMUxmGVKj09xIgryetS8S4CRVm3Pc5e9RW82bTadHtp4
         TiU0eMsle39Ou1UIfmZ1WJIILNO1Jr4Rpux9HWM27afuup/UgoUdOH4HGCPAE8rnMavn
         tRwohbqpWE+L5vOEs9dbo9WyLXBhO+zp4cZO3wUYQqzaNbtN3LDWsyQjma0T3JyWkJql
         rdTK68+Y+grL4J1Kyee0lfXjDXelEyhDpoTquN06gUnZIzW7tCT7efGEyIq5U2/nGI+8
         VpbA==
X-Gm-Message-State: AOAM530rJE+qgmG64w0i71EAE16fc+1wc5KM4dF938O8ZajbH7vmrnBJ
        3GTY06zf8bvGviHgpHvhsNgIc9BYJ797mFoh/lXAJqIX
X-Google-Smtp-Source: ABdhPJw3pvo3jz4PphfDLsVz0NdN5c0mUupeTBFYNbxBtzncLxawxhAxOoZVDAp1lHlqX5vaieFTyoUOvHC+Q+oMFQk=
X-Received: by 2002:a67:fe57:0:b0:335:ef50:1b94 with SMTP id
 m23-20020a67fe57000000b00335ef501b94mr18251959vsr.6.1653777497158; Sat, 28
 May 2022 15:38:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 28 May 2022 17:38:05 -0500
Message-ID: <CAH2r5msE-duSk+O2PJoBKzo2ip9y9e1TiYB1pvX3TY6R9Rq21Q@mail.gmail.com>
Subject: Suspicious xfstest failures to ksmbd
To:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Noticed a few differences between ksmbd test results and other servers
that may be server bugs:
generic/615 22s ... - output mismatch (see
/home/smfrench/xfstests-dev/results//generic/615.out.bad)
    --- tests/generic/615.out   2022-01-30 15:05:53.495186894 -0600
    +++ /home/smfrench/xfstests-dev/results//generic/615.out.bad
 2022-05-28 16:29:12.603177975 -0500
    @@ -1,3 +1,4 @@
     QA output created by 615
     Testing buffered writes
    +error: stat(2) reported zero blocks
     Testing direct IO writes
    ...
    (Run 'diff -u /home/smfrench/xfstests-dev/tests/generic/615.out
/home/smfrench/xfstests-dev/results//generic/615.out.bad'  to see the
entire diff)

also test 208 fails:
generic/208 201s ... [failed, exit status 1]- output mismatch (see
/home/smfrench/xfstests-dev/results//generic/208.out.bad)
    --- tests/generic/208.out   2020-01-24 17:11:18.720859829 -0600
    +++ /home/smfrench/xfstests-dev/results//generic/208.out.bad
 2022-05-27 21:43:43.204933555 -0500
    @@ -1,2 +1,2 @@
     QA output created by 208
    -ran for 200 seconds without error, passing
    +buffered write returned 12582912
    \ No newline at end of file

Tests generic/472, generic/497 and generic/554 (swapfile tests) are
skipped to ksmbd (with "swapfile not supported") but not to Samba


Also would be interesting to see why test generic/586 fails (although
this fails to multiple servers, could be client bug):
generic/586 11s ... - output mismatch (see
/home/smfrench/xfstests-dev/results//generic/586.out.bad)
    --- tests/generic/586.out   2020-06-14 15:13:59.924160846 -0500
    +++ /home/smfrench/xfstests-dev/results//generic/586.out.bad
 2022-05-28 16:28:54.723201574 -0500
    @@ -1,2 +1,101 @@
     QA output created by 586
    +[0]: sbuf.st_size=1048576, expected 2097152.
    +[1]: sbuf.st_size=1048576, expected 2097152.


Test 213 should also correctly return no space on disk (could be client bug)
generic/213 0s ... - output mismatch (see
/home/smfrench/xfstests-dev/results//generic/213.out.bad)
    --- tests/generic/213.out   2020-01-24 17:11:18.720859829 -0600
    +++ /home/smfrench/xfstests-dev/results//generic/213.out.bad
 2022-05-27 18:50:38.984025733 -0500
    @@ -1,4 +1,3 @@
     QA output created by 213
     We should get: fallocate: No space left on device
     Strangely, xfs_io sometimes says "Success" when something went wrong, FYI
    -fallocate: No space left on device


-

--
Thanks,

Steve
