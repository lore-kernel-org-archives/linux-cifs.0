Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0257C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Apr 2022 22:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbiD2WGl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Apr 2022 18:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiD2WGk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Apr 2022 18:06:40 -0400
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46967DC984
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 15:03:21 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id g23so10492511edy.13
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 15:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=bPmhOVUWo0n5hG/Bfz/n8rvpnhUee/nCZeFEHS7ETZ8=;
        b=NSV99oA3DNqG6aR4EHAQl8AYJv8g/bRrdSANE7c1LW0nRJz2qUYYu37c6O9zQxR8cy
         GlagPUPRHSLnzl8Xf0N6Dlii8XjOwx3nVieySVihCv/TnxPNU1sBTDPbpww5OZngg0tp
         Way4S8F7dpb1dJNlz+J4eZP/b/DHdNsgwTIs9qxvnE6iNpFNnZqfqnIR+LtbDIP6KjTh
         EbR6JfodF9Jh9nYAdzq1KM6MkJY4MG5lNfmTh5a9oTYjt8sbPWu5F4gB4fimZpacLW1Q
         QmivRWIU3nHAZsuhqQJ/mfTMYzLFNns2HOfx69tNt6tPZInmggAZcQQtlsI+ljMZzJuu
         HioQ==
X-Gm-Message-State: AOAM53121NTPjOfN9iaLrPITuf4DhlKyk/rKy3YRO51dEK/+ftx2MR5t
        GT3SECZgH/tuDCXgeraE4/TpbcEXmxEiW4lvkfX8Nt1+OQ==
X-Google-Smtp-Source: ABdhPJz/yv8Dcvt94vlyaoWhyHGprWg7rzxKlb8JpI2bt+Gp6VAMUHLZm6+HKxdDU1uDwyyX3pLYDyXcLpN3mhEcoDc=
X-Received: by 2002:a50:c3cf:0:b0:41d:5fc4:7931 with SMTP id
 i15-20020a50c3cf000000b0041d5fc47931mr1453175edf.244.1651269799450; Fri, 29
 Apr 2022 15:03:19 -0700 (PDT)
MIME-Version: 1.0
From:   Pavel Shilovsky <pshilovsky@samba.org>
Date:   Fri, 29 Apr 2022 15:03:07 -0700
Message-ID: <CAKywueTY1gvxKAH7q3rP1U0XSU9AhTZqUcH3GoqgQdbOfbh=Ow@mail.gmail.com>
Subject: [ANNOUNCE] cifs-utils release 6.15 ready for download
To:     linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        samba@lists.samba.org, Jeffrey Bencteux <jbe@improsec.com>,
        David Disseldorp <ddiss@suse.de>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

New version 6.15 of cifs-utils has been released today. This is a
security release to address the following bugs:

- CVE-2022-27239: mount.cifs: fix length check for ip option parsing
- CVE-2022-29869: mount.cifs: fix verbose messages on option parsing

Description

CVE-2022-27239:

In cifs-utils through 6.14, a stack-based buffer overflow when parsing
the mount.cifs ip= command-line argument could lead to local attackers
gaining root privileges.

CVE-2022-29869:

cifs-utils through 6.14, with verbose logging, can cause an
information leak when a file contains = (equal sign) characters but is
not a valid credentials file.

Both issues were originally reported and fixed by Jeffrey Bencteux.

Links

webpage: https://wiki.samba.org/index.php/LinuxCIFS_utils
tarball: https://download.samba.org/pub/linux-cifs/cifs-utils/
git: git://git.samba.org/cifs-utils.git
gitweb: http://git.samba.org/?p=cifs-utils.git;a=summary

Thanks to everyone who contributed to the release!

Best regards,
Pavel Shilovsky
