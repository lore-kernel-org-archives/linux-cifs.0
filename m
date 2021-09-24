Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65577C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 23:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B32461250
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 23:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344413AbhIXXZD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Sep 2021 19:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343764AbhIXXZC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Sep 2021 19:25:02 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E402AC061571;
        Fri, 24 Sep 2021 16:23:27 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id g41so46597043lfv.1;
        Fri, 24 Sep 2021 16:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=pnGNv82mcjDLNEw7T3SnDlIiLho+ZHsLnxO6mqL7FKw=;
        b=FYjZOynLJIuVZUSSi/fmecdqHQ09h0iebTVrAXMqGPjl4XlkgMZFO+o3ESnxIAieef
         mSW7CH3oj+IEquYOr6C21drpaCARzBT4WbJXAVfeLhTk4hUkTThCLPXkRV/xBjXNvOH6
         dQ1wXJYtboOz1tIJGK7TjfgWcn8oNBCxztEM2mojwa1NhSt0hlp/e35HA5tA2C1eRf0Z
         eW7HC9ZLjZ6He4mhFbB/3sTsuoDiOjR8lPZ+JpwKFrLm58u582nuUMIn7ROF7uhzF+tO
         vE8dn4OREs79PF17axPlwDgifuFstC/VGvoB/5Xm8DnWeZyq+SziwRxGz3zpF+U11n/Z
         H/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=pnGNv82mcjDLNEw7T3SnDlIiLho+ZHsLnxO6mqL7FKw=;
        b=Bg7hhWMm2+xUCXQIHr3Fl++3fAJNATX9KtLUXXIX1XTQPG6TT8GDL8McLw4MzUlH79
         F8p5HEel1So1MDTdQcEUmg94qsTboipp+xIJKIvd+jed/KrUQcpPy2cCjvB1mygRYlc8
         XmAm+ggNTgxZTBk9ASZImHg/pUcZZbAw8C2KuTijJJpQzCSt6OyB0jAjc242a+0VdMWb
         Lfor9ZXDma430BuvzD4wNyGANXaWHwgqdcGKnEScWh3iJRpZbMrLEgfhqf2vpMvOpTkW
         25puGqfAuX3kRvfd5XNxg9BmWGSPrgTac0RlYZ4/dwDkTJgxuSzEXhmYJkjFibBeMfkz
         5zJg==
X-Gm-Message-State: AOAM530oFr1BisRyqAXHwMWjQAphJJPJJ6XPZvdfvU1J1IR1Z3cEfIkT
        IHsNw0oNo4PxLdVKGviPdoIsEuAdKGMuF1ZUHFD7gFy+kDg=
X-Google-Smtp-Source: ABdhPJyk8J77hCfVH7U2ceD9PkDOUWO+vA1WSGdHqoSQcEm/3p0ufjBVVB8ru4UR0FTinZv9RvZbDSO0I0WA74CBnto=
X-Received: by 2002:a05:6512:3d93:: with SMTP id k19mr12421847lfv.545.1632525805552;
 Fri, 24 Sep 2021 16:23:25 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 24 Sep 2021 18:23:14 -0500
Message-ID: <CAH2r5msXrOGB1_JC-4jg0F4jbq5G33bGE8-uvdO6Doyw79E_mA@mail.gmail.com>
Subject: [GIT PULL] cifs/smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
fdf5078458793fca9e9c0fb5e58a1a970ca0fdef:

  Merge tag '5.15-rc1-smb3' of git://git.samba.org/sfrench/cifs-2.6
(2021-09-20 15:30:29 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.15-rc2-smb3-fixes

for you to fetch changes up to 9ed38fd4a15417cac83967360cf20b853bfab9b6:

  cifs: fix incorrect check for null pointer in header_assemble
(2021-09-23 21:12:53 -0500)

----------------------------------------------------------------
Six small cifs/smb3 fixes, 2 for stable
- important fix for deferred close (found by a git functional test)
related to attribute caching on close.
- four (two cosmetic, two more serious) small fixes for problems
pointed out by smatch via Dan Carpenter
- fix for comment formatting problems pointed out by W=1

regression test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/805
----------------------------------------------------------------
Dan Carpenter (1):
      cifs: fix a sign extension bug

David Howells (1):
      cifs: Deal with some warnings from W=1

Steve French (4):
      cifs: Clear modified attribute bit from inode flags
      smb3: correct smb3 ACL security descriptor
      smb3: correct server pointer dereferencing check to be more consistent
      cifs: fix incorrect check for null pointer in header_assemble

 fs/cifs/connect.c |  5 +++--
 fs/cifs/file.c    |  4 ++--
 fs/cifs/misc.c    | 17 ++++++++++++++---
 fs/cifs/smb2pdu.c |  4 ++--
 4 files changed, 21 insertions(+), 9 deletions(-)

--
Thanks,

Steve
