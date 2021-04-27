Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B56C433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Apr 2021 10:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04CD6611C1
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Apr 2021 10:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbhD0KZ7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Apr 2021 06:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhD0KZ6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Apr 2021 06:25:58 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C197FC061763
        for <linux-cifs@vger.kernel.org>; Tue, 27 Apr 2021 03:25:12 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id q192so15034852ybg.4
        for <linux-cifs@vger.kernel.org>; Tue, 27 Apr 2021 03:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=utbUAovdMHAf+XUL0PRQa2Dd7b9tLp7dPyhVxQStc68=;
        b=C8pXenvC8m4HROEg+Zm6tOSWlyJG323E1hn69NUlBPa++01YtF/6CUlS+O9SX3YNKV
         ohVWxqQ8E16+rN2YCDK/pWohRRtHQku3bn3ihinqIcMmn+856CiEyXONt64ZOMs443OX
         CzPhKbt9LK2f9oWGqH/KsE5G/0ux8isd/+IhI3IDtr0b5sj1vkyDZ7Tp4yNau/45YJQV
         aSTXSWz1Ok8EnFUUdhKnVyoUy0zuI81dj7bZd5VmIrZgGLATLHC9UbxhTGhUA+l/57tK
         DvSVCNI34ODL4qob4Wc5ydRRmlXwsT6ARrgBgL3JZe7V5bZWYhsiyWqFURwEEUNvDOHK
         /cBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=utbUAovdMHAf+XUL0PRQa2Dd7b9tLp7dPyhVxQStc68=;
        b=NiujuHRK6pN8Dk2DDu1I4JNQK60ET05/iNubaM/fDu5/MT0IFd14OfBudH4dsNNV9T
         t/MGME6whe0YUHVNJ1TuMrJXZTNlJp8vSpDXQiyJoBUDsf2IXyaVd0QGl7vNQ5DW9UzE
         IgG4TI0m47jK1mNJdaV+Sem3UrXHD6IwUmG/nRGrXF2FBPmmHRb+l8KABb+DbhfbBqrq
         kqHoxslN/k2eX57MIRNPVmG7/DklXWAbrPwJoN9ruZjQkc6SKVbKFm4vSODbkW1OtU6U
         FqWKKBqiMsL7lCgW9iYGjfUvM+ttuORdpGxtjaKZS7vMqnsUNmZkjYvP3LQvaokYw0Ag
         bj5g==
X-Gm-Message-State: AOAM531bZd7Zaq/l+1XSgJxQ6RNmZBxfMIY52AIs1BGtJ7svvRMpf4a5
        EF16HeF6NcfBQq0vsyOGhya80z58xdGKUUCw2+MT+d1Oq/Y/+g==
X-Google-Smtp-Source: ABdhPJwYl3pbQH7G3RuXn5c/9y3B5KIJp2nGaNHuOG5fo28v1Y7+6PQQe0/Z+bdQXxNlY8JI/HR8qO0LHuzjZ4AcFio=
X-Received: by 2002:a25:2a0a:: with SMTP id q10mr29404297ybq.403.1619519111717;
 Tue, 27 Apr 2021 03:25:11 -0700 (PDT)
MIME-Version: 1.0
From:   Daniel Lewart <lewart3@gmail.com>
Date:   Tue, 27 Apr 2021 05:25:00 -0500
Message-ID: <CALE_k2GChTGfKjU8ws-rKQLmYP-5NY0PcKGEOmRE-3auKvAUyA@mail.gmail.com>
Subject: cifs-utils mount credentials file is relative to mountpoint
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cifs-utils Team,

mount.cifs and mount.smb3 both have the following -o option:
        credentials=filename | cred=filename

E.g.:
        mount -t smb3 -o cred=mycredfile service mountpoint

I would expect mount to look for mycredfile in the current directory.
Instead mount looks for mycredfile in the mountpoint directory.

I consider this to be a bug.

This problem is caused by chdir(&mountpoint) being called *before*
the credentials file is opened and read.
Below are excerpts from mount.cifs.c which show some details.

I can think of two fixes:

1) Open and read the credentials file *before* chdir(&mountpoint)

2) Document that the credentials file should have an absolute path

Thank you!
Daniel Lewart
Urbana, Illinois
---
mount.cifs.c

2039 int main(int argc, char **argv)
2040 {
2163     /* chdir into mountpoint as soon as possible */
2164     rc = acquire_mountpoint(&mountpoint);
2187     /* child */
2188     rc = assemble_mountinfo(...);
2353 }

acquire_mountpoint -> chdir
assemble_mountinfo -> parse_options -> open_cred_file -> fopen

###
