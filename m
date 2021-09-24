Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA75C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 00:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05D05610CB
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 00:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243599AbhIXAOP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 20:14:15 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:45921 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhIXAOO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 20:14:14 -0400
Received: by mail-ed1-f43.google.com with SMTP id c22so29005213edn.12
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 17:12:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=RCcja10SFVdtOiyzrCk0cciDdOc7qdrHC+TrP8HCrOI=;
        b=FBUKOFK4n+Vbmzgh8VHHUi/hFifNQcTlqXuIMBQNoYKkq5vcMyNPhHE7J6mXql62Is
         FB5FBqbXkxeThP8OpT8FKFV4BnDRrvNXOaqnqpc9LLPFKk/V5NYJdlE8Bh1C5mlV8Fo3
         ivR6OMK/zC60r02wjnKhexTPSqwkqK+A4jhLnjJCa22lXhzg0f7inbAGBftslxp95quC
         Vj79C3+7RkQ+fV3pUVBAp8SJx7OQdFP4I1T/tgvx1OVV9atwxNQl64IjizvE0lhtn6pu
         htJIQuxce58/t0f27wf+m3pue3HYcKvqMl5rpoKIkN1LYqov6cFP99a/90b/w21Hn/fW
         I9Qw==
X-Gm-Message-State: AOAM5308u0jy5m0A782yxAEcl5Ycrn/nYyLXnFpxOEb9sIMQQ2Mm0i7V
        xu+y0Ax5yXezOOCmix2X7tM6fnaayj1booFXAwV+0p7MbQ==
X-Google-Smtp-Source: ABdhPJz3JjjUyhYPJIOW1z5xWcYpz78UIFLcF4VV88Yayaum7TNYIyxGtiUiqMs2DEeRTUK2B3FJBJmxcyng61fSIkg=
X-Received: by 2002:a17:907:2624:: with SMTP id aq4mr8311794ejc.448.1632442361513;
 Thu, 23 Sep 2021 17:12:41 -0700 (PDT)
MIME-Version: 1.0
From:   Pavel Shilovsky <pshilovsky@samba.org>
Date:   Thu, 23 Sep 2021 17:12:30 -0700
Message-ID: <CAKywueRSG5NiomwOnR=8+bVgVTzMaZ-Atua1Csed+Af=Jq5xGw@mail.gmail.com>
Subject: [ANNOUNCE] cifs-utils release 6.14 ready for download
To:     linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        samba@lists.samba.org,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Boris Protopopov <pboris@amazon.com>,
        Steve French <stfrench@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Alexander Bokovoy <ab@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

New version 6.14 of cifs-utils has been released today.

Highlighted changes:

- smbinfo is enhanced with capability to display alternate data streams
- setcifsacl is improved to optionally reorder ACEs in preferred order
- cifs.upcall regression in kerberos mount is fixed

webpage: https://wiki.samba.org/index.php/LinuxCIFS_utils
tarball: https://download.samba.org/pub/linux-cifs/cifs-utils/
git: git://git.samba.org/cifs-utils.git
gitweb: http://git.samba.org/?p=cifs-utils.git;a=summary

Detailed list of changes since 6.13 was released:

8c06dce cifs-utils: bump version to 6.14
e2e216c setcifsacl: fix formatting
1a70243 smbinfo: add support for new key dump ioctl
9ad46fc mount.cifs: fix crash when mount point does not exist
7f9711d cifs.upcall: fix regression in kerberos mount
02cd3aa smbinfo: Add command for displaying alternate data streams
4d5daf5 Reorder ACEs in preferred order during setcifsacl

Summary:

Aurelien Aptel (2):
  cifs.upcall: fix regression in kerberos mount
  smbinfo: add support for new key dump ioctl

Juan Pablo González (1):
  smbinfo: Add command for displaying alternate data streams

Paulo Alcantara (1):
  mount.cifs: fix crash when mount point does not exist

Pavel Shilovsky (2):
  setcifsacl: fix formatting
  cifs-utils: bump version to 6.14

Rohith Surabattula (1):
  Reorder ACEs in preferred order during setcifsacl

 cifs.upcall.c     | 214 +++++++++++++++++++++++++++++++++++-------------------
 configure.ac      |   2 +-
 mount.cifs.c      |  13 ++--
 setcifsacl.c      | 129 +++++++++++++++++++++++++++++++-
 setcifsacl.rst.in |  20 ++++-
 smbinfo           | 120 ++++++++++++++++++++++++++----
 smbinfo.rst       |   2 +
 7 files changed, 399 insertions(+), 101 deletions(-)

Thanks to everyone who contributed to the release!

Best regards,
Pavel Shilovsky
