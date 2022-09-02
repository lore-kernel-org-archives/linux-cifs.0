Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8209ECAAD2
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 00:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiIBAom (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 20:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbiIBAol (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 20:44:41 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77A6A2237;
        Thu,  1 Sep 2022 17:44:40 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id j11so303104vkl.12;
        Thu, 01 Sep 2022 17:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=fRLBFK8FTp9/th4AtAcZFMkcxHRqZ1ZriRJ83e9dXnw=;
        b=DTfoXy/JvcwA1X3Zr91XtH6ZHn7GAS5vARVA2fF2otqdm34xh5tMiIz+1eMIdrEhTc
         SbaESz9D16t98mDVdE0Xiyk8AiOzaZ/Av9CcPVnmQwxnzkLG47rj+Ox932Pr2QjRXoxQ
         uN9/HU6c2wXgUel8fewcmS15U7eo5j+kNF3lhzPVK0Qx5OtR7COqjCtckX9oZTy96OeA
         QSgjFImUQC+BN6kokeZg4ehl8G5I2ulFr1GIR1VTsSjr2o4O+P1Nu/3z640QHZwedK4U
         Xb7aidlGfJzUdzqjHDQC1/SF9shYtdzPsvn8qu3NrHw7zD8TuXdoNOJKptdBs++AlvE4
         tzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=fRLBFK8FTp9/th4AtAcZFMkcxHRqZ1ZriRJ83e9dXnw=;
        b=RZwuez+xtUSqlTOszdT5cADvo9fusdBNm2YdMh2hNy+TkTnQPOD9/x+JXPsy/LWIpO
         DjvIfO0xQDmib1r1pfgQjoWwjuOxCZhFkqp8U2PlANVhh8pZCA8NjIMQkQvrYTIanIt6
         43m0ZdJi/AboPBoYqxSjd/sFnlgegZW6hQehjblALrNQTQOXtCzbwJqcnyfEFMC5gNhz
         K0maBCyD2qKSv+vn5ypXbfasppbEPy7uMKEHRtqp0GUt5hvmZb1h3au62UE6t2CK+LZ0
         oXQQeJnEvW1Blb3IyAaAhHxqXsaDs3mj9KjPm7CkmJoEemgWuIYOAXQRcq/V8A/ZO/vR
         rJQA==
X-Gm-Message-State: ACgBeo0+XvXPLPKhKg5aPVUiZLgzHVK7yfGcSPNuXOEjuqV7WboYDVlW
        R92ryrxrPGYIgWbIcyMBQ7p+ZgT8vQIMxj5WlNMxeqySZSI=
X-Google-Smtp-Source: AA6agR4Ye51m7JdY4c4tfZt7S84Sa6CaPKtp2LwBLyVA77ithUcnK8sJI3qDhmSnFKzRpv2YO8OhEgJHjZ2gaE85Ht4=
X-Received: by 2002:a1f:51c2:0:b0:37c:f131:e749 with SMTP id
 f185-20020a1f51c2000000b0037cf131e749mr9234886vkb.38.1662079479624; Thu, 01
 Sep 2022 17:44:39 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 1 Sep 2022 19:44:29 -0500
Message-ID: <CAH2r5mt_+2zK_y3mdqkbQQ9YSK_2cvKzzLTGWjx7Jd0w55gNFQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
b90cb1053190353cc30f0fef0ef1f378ccc063c5:

  Linux 6.0-rc3 (2022-08-28 15:05:29 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.0-rc3-smb3-client-fixes

for you to fetch changes up to 27893dfc1285f80f80f46b3b8c95f5d15d2e66d0:

  cifs: fix small mempool leak in SMB2_negotiate() (2022-08-30 20:08:13 -0500)

----------------------------------------------------------------
5 cifs/smb3 fixes, all also for stable
- fixes for collapse range and insert range (also fixes xfstest generic/031)
- memory leak fix
----------------------------------------------------------------
David Howells (2):
      smb3: Move the flush out of smb2_copychunk_range() into its callers
      smb3: fix temporary data corruption in insert range

Enzo Matsumiya (1):
      cifs: fix small mempool leak in SMB2_negotiate()

Steve French (2):
      smb3: fix temporary data corruption in collapse range
      smb3: use filemap_write_and_wait_range instead of filemap_write_and_wait

 fs/cifs/cifsfs.c  |  6 +++++
 fs/cifs/smb2ops.c | 69 +++++++++++++++++++++++++++++++++----------------------
 fs/cifs/smb2pdu.c | 12 ++++++----
 3 files changed, 55 insertions(+), 32 deletions(-)

-- 
Thanks,

Steve
