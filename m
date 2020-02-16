Return-Path: <SRS0=zJQV=4E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5175C7114E
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Feb 2020 02:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8786020729
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Feb 2020 02:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HyDwRc+9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgBPC7F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 15 Feb 2020 21:59:05 -0500
Received: from mail-io1-f41.google.com ([209.85.166.41]:35465 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgBPC7E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 15 Feb 2020 21:59:04 -0500
Received: by mail-io1-f41.google.com with SMTP id h8so2404259iob.2;
        Sat, 15 Feb 2020 18:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=schleolSZc0L2KAjwB51HaHMdUg0g+XfM0bX42148ak=;
        b=HyDwRc+9p8gBIxjm3W2nslV0oOTvct3FHxJaCBnyw/WCq3KoLwA+urEXVl6DkVDeSk
         39hTRYZbhrdFKmxON5bzbyn5EfY4FhWet/qnm6kLWvjQ2oR9ojtMOKHXpJQ3fZQMXL//
         RxEetjdTRCFd1A0L6UUUOkZALf9hax+fDm1o5DsgyaWLB4ATM80qLe6Js4limTb5zVGD
         sjBxBnPCBQSIjU2W3YRHamnfZosZYityfrAA1viAjbKQk1iwKN6nh7XzgMp8iCy6pO8g
         GqPbjMidqWbHszAi8uCKUAGhT62qlbRjAyVfekp6eEh3FtKDZ7kPu63pAMifwiaOqY3Z
         ofSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=schleolSZc0L2KAjwB51HaHMdUg0g+XfM0bX42148ak=;
        b=EWMJzKAp01LWSPQYdjjps6Pzm2w47VHP9K7SLXl3aPODHURCdbro4X3TgD2qGmtugb
         Q/mTXIBv6Cpya921ZGULTAf8eu+35uMPGfCTEOzjPHghHwy4P9sCdUcLmHwR2WUF9c+j
         khQysDDRX7jiZ9DpaVem17rk1jP6RbTk8nuqvhuvCCzhByoaRllbngbKp+uUggOvtHyC
         P1qzfwiJpvYTiAtUn/M7k/1i+13pvcFWpfvkXKJv7wT582MRFtgg84fFmEZ6zlWBpcmK
         YAuKZnziEqhqcVjbSiDYcQYn6vOrgIaknbOlbSI1f0UQipvFIldZHaeUfPg/E8dvi8hE
         VCEA==
X-Gm-Message-State: APjAAAVIg0Epn2rDh/xI6YB52a3w7GMCKRMjhvykCwlMA7SKAkaGJA+X
        0b0fb6NAv1SL+C0pds1h0N4+9+hGEF0P7NmrWHA=
X-Google-Smtp-Source: APXvYqyfuFaKs+Az/IwM8UIaBuu+LV3g1dvV7SsuWPlZ0SnaZu4Wzg47cg/7knZ8wDoiGTPhhQKzQgCiJDK969un/Ik=
X-Received: by 2002:a05:6602:1301:: with SMTP id h1mr7260101iov.5.1581821944200;
 Sat, 15 Feb 2020 18:59:04 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 15 Feb 2020 20:58:53 -0600
Message-ID: <CAH2r5mt=_P2tUC6H+bmFL-FAyKYQuvim2fYqa27gMdJj3882=g@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
bb6d3fb354c5ee8d6bde2d576eb7220ea09862b9:

  Linux 5.6-rc1 (2020-02-09 16:08:48 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.6-rc1-smb3-fixes

for you to fetch changes up to 85db6b7ae65f33be4bb44f1c28261a3faa126437:

  cifs: make sure we do not overflow the max EA buffer size
(2020-02-14 11:10:24 -0600)

----------------------------------------------------------------
Four small CIFS/SMB3 fixes.  One (ie the EA overflow fix) for stable.

Automated test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/315
----------------------------------------------------------------
Frank Sorenson (1):
      cifs: Fix mode output in debugging statements

Petr Pavlu (1):
      cifs: fix mount option display for sec=krb5i

Ronnie Sahlberg (1):
      cifs: make sure we do not overflow the max EA buffer size

Steve French (1):
      cifs: enable change notification for SMB2.1 dialect

 fs/cifs/cifsacl.c |  4 ++--
 fs/cifs/cifsfs.c  |  6 +++++-
 fs/cifs/connect.c |  2 +-
 fs/cifs/inode.c   |  2 +-
 fs/cifs/smb2ops.c | 36 +++++++++++++++++++++++++++++++++++-
 5 files changed, 44 insertions(+), 6 deletions(-)


--
Thanks,

Steve
