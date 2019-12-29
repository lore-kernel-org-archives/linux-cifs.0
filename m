Return-Path: <SRS0=MPZ3=2T=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71072C2D0C0
	for <linux-cifs@archiver.kernel.org>; Sun, 29 Dec 2019 05:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30648208E4
	for <linux-cifs@archiver.kernel.org>; Sun, 29 Dec 2019 05:06:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EzFF2TFX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbfL2FGr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 Dec 2019 00:06:47 -0500
Received: from mail-io1-f49.google.com ([209.85.166.49]:40394 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfL2FGr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 29 Dec 2019 00:06:47 -0500
Received: by mail-io1-f49.google.com with SMTP id x1so28941723iop.7;
        Sat, 28 Dec 2019 21:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=AymL547oXJ49uTr2xVvaDsDzbeRoNfeedJOIA++4HL0=;
        b=EzFF2TFXYQfVs3JCloU9LeazNGVL3q8zHKuiWIWyNZDJZKWFAuXQ22Bk7TiKQOMDpI
         tb2ymlm5d2nshYTCE80VmKP4SkbqTBmGiMMzdJUmpIumu8/eAWcVspueuLZd32Nl7SLQ
         o5P/AvBHelMpVeak+RNug5VULEeWwOSZ9o0hMpO1nOcTHIRabKXxdavNqZJAfl8w3/wv
         GksQ7WdGW0ni1F+QjDY+b2lzoe2e+RcODZBKCqCbcePfAu5e1Ba1N6Lc9MvbEVGY5r8s
         Ic6E94OYxi+XaL9l4FUq9HWxW5O59dAqigiWKV9iyfjMi2B/7FIE3d8oFh5SyBG2B1qk
         ndxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=AymL547oXJ49uTr2xVvaDsDzbeRoNfeedJOIA++4HL0=;
        b=nm2XgLeQIzvBQjIkjzsW6Ot+LT4q9pPyHu0gNERWrfup9c8hM+NZOJppq+UPf/QYjo
         XXql16fYQ9ePmtnwBdyZytuy95n0w/xTlvUn8EmxrlCO/TbC5e7CgrfIuntZ5f1RR1eT
         OBZCWmBuWYy8SQKi1yoBno0H1WmbhYoNoXHTY8SF2wHrTmTZ+B49IQJ/xg3bkJcoG9dt
         Wl6AAKVF7t5Mb3Cc/MePouEB0wDdHDglScvuJa9LoBhhpl4X4nYVW4gRulNM4sG9/FFG
         8N07LdaZCuF4gDrPmql8KYek0LDTqTfHguitQ12Q9h0s7JupUOYpFKIj9YcQgB25DCqH
         O8wg==
X-Gm-Message-State: APjAAAVjQlr1CZjcCXFiNFdS9AlwLyXYiaxaYkc3dhDgTkPZUAFDIenx
        5+S6rhYbdHR7Z5O97xPN+YSEFUMQTEQK/vDHCT2qL7K1
X-Google-Smtp-Source: APXvYqw/QimWB6AoCQgB/yBx0GZb8JVFHFvnasMGc08hnhVjLKd6lsumX5a5Pnod0YVrzDeUcpWt5I5Ie1ltRCXbtas=
X-Received: by 2002:a6b:c413:: with SMTP id y19mr671294ioa.272.1577596006227;
 Sat, 28 Dec 2019 21:06:46 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 28 Dec 2019 23:06:35 -0600
Message-ID: <CAH2r5mvWwwSA70MnKBZXm_ji9iT+DxVPu-33EcFb9L+GgEwcXA@mail.gmail.com>
Subject: [GIT PULL] SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
46cf053efec6a3a5f343fead837777efe8252a46:

  Linux 5.5-rc3 (2019-12-22 17:02:23 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.5-rc3-smb3-fixes

for you to fetch changes up to 046aca3c25fd28da591f59a2dc1a01848e81e0b2:

  cifs: Optimize readdir on reparse points (2019-12-23 09:04:44 -0600)

----------------------------------------------------------------
One performance fix for large directory searches, and one minor style
cleanup noticed by Clang

'Buildbot' regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/304
----------------------------------------------------------------
Nathan Chancellor (1):
      cifs: Adjust indentation in smb2_open_file

Paulo Alcantara (SUSE) (1):
      cifs: Optimize readdir on reparse points

 fs/cifs/cifsglob.h |  1 +
 fs/cifs/readdir.c  | 63
++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 fs/cifs/smb2file.c |  2 +-
 3 files changed, 56 insertions(+), 10 deletions(-)


-- 
Thanks,

Steve
