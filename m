Return-Path: <SRS0=OUxG=UX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F88C43613
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 06:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E53320663
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 06:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+LZ1JEY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfFXGIa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jun 2019 02:08:30 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:34324 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfFXGIa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jun 2019 02:08:30 -0400
Received: by mail-pg1-f175.google.com with SMTP id p10so6533551pgn.1
        for <linux-cifs@vger.kernel.org>; Sun, 23 Jun 2019 23:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=JvUkm9j2uc46LWhLTIvdFO1C21uflJE/x6S3m9iO1wc=;
        b=V+LZ1JEYVuHqv0OgAWx9FtSCHovHTbo315GPPrrtiC23fS9pj1314zDWiwyTNzDFko
         y6xphr8IIT2efk6yBOsm3igKczsC7zUhtqwEwF4nbGPPr99i9lXIPiSNCxRHWFwGg3QM
         1rzv7kR8d8eEp+3F6s4d91RPYSRzITkXl3Cs9JIVUu1cN2gxAC+6UjXQep5Ca5glKICo
         jZLnk8HdYpk7j6nDYmltB9kt+M2qwURiIFnHU8vCqk1brzh6Z6TLhoZ12JqWWfp04Hz/
         CluBWxiYQfUurtOr//uTVT+bdcF0vVwQNxMSa2r2sGTQWpU/AZFR2Xysrssa2BoetT9i
         mS4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JvUkm9j2uc46LWhLTIvdFO1C21uflJE/x6S3m9iO1wc=;
        b=WHgvAeER/W9WEvE+7+ZSivEuSv+0OiIEVGWojxjq0bdKf6zc08Xtv6QsoDelFu/UmV
         OUr2Fv9wx9zm0w+LiWzefwHueEskpiqa/2ihLipmPurXoo5p4Ug1kxozsqQ1TBNyae9h
         donXM42aKtSuEs9Q2aWJRjTygWysVbWAkPqqXPPY2UL6Hs0y1/TirG1NHW7Ava6R/Cyp
         db3Fp8cXpw+8jL7oEcM3U2nyNkTEZ4Oq58MH8GjiveM/PzbcNPTo4eZry7XV+uRLjLiP
         8P2f23CaJ9d/lWgP3rPFekjqN6os7W1+bSVF2GMvhbACnFo2eMOnB29UL01SqrHLjXmm
         DHDg==
X-Gm-Message-State: APjAAAWSAo+87u6hx0e4WqoDqALOOfgVeFCNDtg3OV9Nf7VGeI1P9RBb
        68JPmt8ZjNE8RiuLh9B89l90KhV3LCus9yWiG+UXO4Lf
X-Google-Smtp-Source: APXvYqzD/14CN7O25lqg+Rp/b400sIOi5A+0ATA4h3z7Umz+24ipJjeR0GjWO13TQINSiS2ZKhIt5WIBvg3EWofRhIo=
X-Received: by 2002:a63:81c6:: with SMTP id t189mr18984571pgd.15.1561356509007;
 Sun, 23 Jun 2019 23:08:29 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Jun 2019 01:08:18 -0500
Message-ID: <CAH2r5mvoNkD-oMwzYL6nYu1rWBfU3i=8iWZMLHASDoABMLJmJg@mail.gmail.com>
Subject: Matching superblocks on second mount of same share
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I noticed that we don't have these six flags defined in cifsglob.h in
the CIFS_MOUNT_MASK used to see if superblocks match when doing a
second mount of the same share

#define CIFS_MOUNT_RWPIDFORWARD 0x80000
#define CIFS_MOUNT_POSIXACL     0x100000
#define CIFS_MOUNT_USE_PREFIX_PATH 0x1000000
#define CIFS_MOUNT_UID_FROM_ACL 0x2000000
#define CIFS_MOUNT_NO_HANDLE_CACHE 0x4000000
#define CIFS_MOUNT_MAP_SFM_CHR  0x800000

Any thoughts if any of thes really can be ignored in the check for
superblock matches?
-- 
Thanks,

Steve
