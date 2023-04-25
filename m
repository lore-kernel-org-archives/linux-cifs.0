Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8209EC6FD18
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Apr 2023 04:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjDYEnn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 Apr 2023 00:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjDYEnm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 Apr 2023 00:43:42 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3D73AAA
        for <linux-cifs@vger.kernel.org>; Mon, 24 Apr 2023 21:43:41 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2a8db10a5d4so51609611fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 24 Apr 2023 21:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682397819; x=1684989819;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q//kii23FKRzCG/0pybaXM8J980UgD3/Gh6plkgpeCk=;
        b=ZvjkoPKprG7Mh4FlXuKeC7O7qi4+QefG3GcEdadxcRuWNLaDfrgE14iKE8RnypAawi
         lhuPGwWb6DM0qn9h5GOjbc4pUjWUdimLADOtaMFVQWHjOXjC91+VTzXWezIW8ozFDLCn
         J2ooUOG/LziziuwAf/Z7sbZP/f+0jcfAfw7/mY9vxjzMQYNa28erKwd+4j+UIXzdstsr
         rSO//VB5rtUaw6zw5R/bKdk0k4wo1LEV6/H+Ogv/mOSNRus6A/nKFRjuxO7aU1nDC3bH
         jPGv4FloPqxNvpTe26mAtUy6lntXmuRLZSExYq8I3EsC9Y1xI/4EKQErEtevwv9l0J+B
         hccA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682397819; x=1684989819;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q//kii23FKRzCG/0pybaXM8J980UgD3/Gh6plkgpeCk=;
        b=GX8YFBgAZDQuRPnwMz2EB8oRpS9SGpHhoxrRRUnrmt1h/MCdDWAV8q6AGLIyIQej/J
         Pyoy/qnKvy7icM1Punaqiy5yTg/1uLuaSKMzLCPhl12zE+xxRizSKpwG0GRDijtfUQ2J
         k1mAiPCGkeIrX8k1vlJC3TQ2xNvtmUHfJ0l/A4O4iL8t/RIkj2HduSPnzzrSZVQmisg6
         zYtxIUsdnxAPBGZ0IL/5TZP/5yj3/QefEAABwFDJoI/8EYl2IaM1tVGcesDjuG/Oubgi
         59lwmL1Tdcx9HPJZtGVU3vHxxuigXzJxkVVRrbJKxf4lv2sUnHXk77TeRypHlvDjxS8D
         Ji0g==
X-Gm-Message-State: AAQBX9fAfI4bDtChlCoElLYtejhLouwFcLcRsSz9pHAC2yDV0nCVVxzh
        cwlcbDSP7VUB1oDfvfycTegHTdbeo2ADZ+1lpPMSFo413Qs=
X-Google-Smtp-Source: AKy350ZJbvuHMcQDpZ2nW7fH/ocULwdQC8nnXiYM7EpgvKC2ykoPOc2UHe8ypH+0wlp8PVWUAdQVbkFjyBe6XoT6YZE=
X-Received: by 2002:a2e:95c4:0:b0:2a8:a859:b5c7 with SMTP id
 y4-20020a2e95c4000000b002a8a859b5c7mr3046182ljh.0.1682397819114; Mon, 24 Apr
 2023 21:43:39 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Apr 2023 23:43:27 -0500
Message-ID: <CAH2r5ms6tY9zqG+rm1Rk2NPCGKUC89FLgjgUtdTbo+NJkJUc-A@mail.gmail.com>
Subject: Samba POSIX Extensions automated testing
To:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Jeremy Allison <jra@samba.org>,
        "Volker.Lendecke@sernet.de" <Volker.Lendecke@sernet.de>,
        David Disseldorp <ddiss@samba.org>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

With the migration to the new 'buildbot' (smb3.1.1 client test
automation) progressing, I have added some functional tests to the
Samba (with POSIX extensions enabled) test target.  We should add more
 xfstests to this test group as Samba server continues to improve its
support for POSIX extensions.   Here is the first test run on the new
infrastructure (server is Samba master branch, client is Linux cifs.ko
running on the 6.3 kernel):

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/11/builds/4

Some things that could help:
- support for clone (reflink) to Samba running on XFS, not just BTRFS
(reflink is helpful for more than just cloning files, various tests
require it)
- support for mknod/mkfifo
- support for ACLs and mode bits on the same share

-- 
Thanks,

Steve
