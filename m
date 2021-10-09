Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A47C433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Oct 2021 04:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE3FC60EDF
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Oct 2021 04:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhJIFB1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 9 Oct 2021 01:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhJIFB0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 9 Oct 2021 01:01:26 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E04C061570;
        Fri,  8 Oct 2021 21:59:30 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id b20so48061786lfv.3;
        Fri, 08 Oct 2021 21:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=hfrhfFfHeMuH40pk8UUXISUecyF3YafJVf4birPzCpo=;
        b=j3xjbyOKIUrtsctGmfwkprOmHqvuUtYrHaHRJzCzrHczAbNfCTe5EXc0RisYYSnox5
         hcpOz0SkVg7zB5spWbka8GOpE5ujnajzHhYT7vTryg/LzkkRWSdrTdRWg6nvNkL4ZA0u
         Rk1nY7oYdvp2O8JV2JJu0j1mrliOEehHvs+Fea6NwNU8psS0FaxYLOxGRNkcg2XH/zi4
         J7bTwbPVoiIrI10UWUk5oCFNCkSpZCgW8fmKfW/5zE5gmh2/oFPDyHkYQTacx+LFWJbT
         mjMNYuvmzJrIFTli7ClQeLtsmsi1pX3sgJoCOCUfHPl6j97q+Njk0cH6g6cWt1aym5RA
         3Qsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=hfrhfFfHeMuH40pk8UUXISUecyF3YafJVf4birPzCpo=;
        b=Lxw7ePNqeeo/rkmaMEDiESRL73QGXXu6j72+suEl+FdlFk2dFhHQTN5UoBe/bC+sOj
         A36Tn3TJ1THHr+kOEKRpreOkWRXtPP0ZUNrf9kCU+OjmbOtYRMxm8Q6AbINDk76zLoZx
         WqCFV/PrxWbLOuIkQFRy+w3XTOBylmuyqW2gE5+VZceERL1/8h1xF4OkSVVqAEs4yZYA
         MG87mRgY63ojhy0Libdl11a2orxGlKyQXB+dPkg+UN2EMp4p8PT7pZBJmuNId+7KZ4fd
         9gn0r/8Hcnideo7Bd8lGMOb8gfcXmyvAzy2mjT12EH1a6knXn01GSsuvYw0ZBZjOy7JM
         7DqQ==
X-Gm-Message-State: AOAM5338zfG/FM22uuRjLOxpJRvuQcog4uvL5b4DBxyu6F+5/fmxd3aJ
        jBlY3YLn1W4lSLgtobooqQpGQmMxvZMgIpuzCX2wHl8twGQ=
X-Google-Smtp-Source: ABdhPJwZK3T6rc6/7dgQ8eGPgfyV/EBNOLbysl4tXxSIQBruci/Ifr7Vraf3VkaUwBtD4mnQpLX0O3k+zS2HBVv4ey8=
X-Received: by 2002:a05:6512:2307:: with SMTP id o7mr14009092lfu.595.1633755568261;
 Fri, 08 Oct 2021 21:59:28 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 8 Oct 2021 23:59:17 -0500
Message-ID: <CAH2r5msTLfojvmuejv+hO6CvF8cwuAw9CpiJWxs9a_D7pZfSLw@mail.gmail.com>
Subject: [GIT PULL] ksmbd fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
9e1ff307c779ce1f0f810c7ecce3d95bbae40896:

  Linux 5.15-rc4 (2021-10-03 14:08:47 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/5.15-rc4-ksmbd-fixes

for you to fetch changes up to 64e7875560270b8f669fca9fcd6a689fea56fbeb:

  ksmbd: fix oops from fuse driver (2021-10-07 10:18:36 -0500)

----------------------------------------------------------------
Six fixes for the ksmbd kernel server, including:
- two additional fixes for missing overflow checks
- some cleanup (e.g. remove dead code for less secure dialects that
has been removed, and clarify overflow checks in smb3 decryption)
- update ksmbd internal module version
- fix for an oops

regression test results from current Linux to ksmbd:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/79
----------------------------------------------------------------
Namjae Jeon (6):
      ksmbd: add the check to vaildate if stream protocol length
exceeds maximum value
      ksmbd: check strictly data area in ksmbd_smb2_check_message()
      ksmbd: remove the leftover of smb2.0 dialect support
      ksmbd: use buf_data_size instead of recalculation in smb3_decrypt_req()
      ksmbd: fix version mismatch with out of tree
      ksmbd: fix oops from fuse driver

 fs/ksmbd/connection.c | 10 +++---
 fs/ksmbd/glob.h       |  2 +-
 fs/ksmbd/smb2misc.c   | 98
++++++++++++++++++++++++++++-------------------------------
 fs/ksmbd/smb2ops.c    |  5 ---
 fs/ksmbd/smb2pdu.c    | 59 +++++++++++------------------------
 fs/ksmbd/smb2pdu.h    |  1 -
 fs/ksmbd/smb_common.c | 12 ++------
 fs/ksmbd/smb_common.h |  4 +--
 8 files changed, 77 insertions(+), 114 deletions(-)

-- 
Thanks,

Steve
