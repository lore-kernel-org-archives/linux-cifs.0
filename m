Return-Path: <SRS0=dbuF=XK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB99C4CEC9
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Sep 2019 02:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B90C920828
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Sep 2019 02:08:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZrpMhQTN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfIOCIV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 14 Sep 2019 22:08:21 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:42797 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfIOCIV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 14 Sep 2019 22:08:21 -0400
Received: by mail-pf1-f178.google.com with SMTP id q12so5086pff.9
        for <linux-cifs@vger.kernel.org>; Sat, 14 Sep 2019 19:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=wEjNFzIlKLtZ05G36WcBYprCwSjvyrxX61RlV5ZHm4U=;
        b=ZrpMhQTNIEUABF19tsHho5YT+3y1U2uuODYn3wfh1JlpbwNxQ6uQjeHv8MeGpejB4L
         jvI2VkK3594XF7TPFhLn79sThr0oM/qFcw6sIZMMugVTdW4e3c64zFeQJqCgekjht2OZ
         eypy6X4HZXSwqoGrL0FEJm9BjaD6RwHJYT+fNaUN35ttKqtrym7YFDCFVX+2zO9Edxlt
         HkYa3EYjd1A3clzlfG8nkZiMsqR4/5QaYsq/DlxHCW+jyrY8HVa/Pfz7kKVqXV8Rfzy6
         sNHzlBOEwoTXyl7jrBkzYpoEKXewnuO+cttR6ZQO4qOhjDHWRtJjW8CG0wO5oymBYmQ+
         TtOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=wEjNFzIlKLtZ05G36WcBYprCwSjvyrxX61RlV5ZHm4U=;
        b=JpyPZzfyFnEaAzIDry3DoeiNR84PmhF7NhHISZjwZTfCaKBLFMDwdMGmdzgbmI4D76
         BBu3N8gOkJbrM9GKECSYsaR2ckxl8MWXA9ZEWrguGQ9vKSVIBi2aq6oMq6VtZnexuPtR
         VS8Kd697WKuybArBGXxDLfMvdsJV82ORoR0zJipJv3MpdH471NWeA4s53tLHDBBCowdL
         qkNyhGRw9CouM1bBa7JGMqUB93CDTsMNxzFE+MhhYs7RKwFGvpzKs5rZHav92fs9pdRn
         S1NvUOXj+GjehzEaVlbOJ4dvw95g0z7fuQ7usuN88r0t/cTjLkzh/YllVRSJrr+1SrgK
         cGjg==
X-Gm-Message-State: APjAAAW0LNWUrrDBb9mahc4zeUgb2+tf5l7PwvPHPna1vmbgsHXuOOLc
        UV4FnRghFjZlLlK2uTPkgLyX7ojj
X-Google-Smtp-Source: APXvYqwDzMG74BBTQ1Lbe09rXcUbvipektzR5lUIqNPYCmD1/ds8IdxphrFSpEfKZwfOeqzE23Zn5A==
X-Received: by 2002:a63:c304:: with SMTP id c4mr18675960pgd.126.1568513298626;
        Sat, 14 Sep 2019 19:08:18 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c15sm35389437pfi.172.2019.09.14.19.08.17
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Sep 2019 19:08:18 -0700 (PDT)
Date:   Sun, 15 Sep 2019 10:08:10 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-cifs@vger.kernel.org
Subject: seek sanity check failures
Message-ID: <20190915020810.jy5pxjtk7buenmqk@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

On latest Linus tree, several seek tests fails:

generic/285 generic/490 generic/539    fails on v3.11 v3.02 v3.0
generic/285 generic/490                fails on v2.0 v2.1
generic/285 generic/448 generic/490    fails on v1.0


Are they expected or being worked on?

Thanks!


FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 hp-dl380pg8-14 5.3.0-rc8+ #1 SMP Thu Sep 12 07:31:21 EDT 2019
MKFS_OPTIONS  -- //hp-dl380pg8-14.rhts.eng.pek2.redhat.com/scratch
MOUNT_OPTIONS -- -o vers=3.11,mfsymlinks -o username=root,password=redhat -o context=system_u:object_r:nfs_t:s0 //hp-dl380pg8-14.rhts.eng.pek2.redhat.com/scratch /mnt/testarea/scratch

generic/285	[failed, exit status 1]- output mismatch (see /var/lib/xfstests/results//generic/285.out.bad)
    --- tests/generic/285.out	2019-09-12 08:04:14.120990746 -0400
    +++ /var/lib/xfstests/results//generic/285.out.bad	2019-09-12 08:36:49.151230335 -0400
    @@ -1 +1,3 @@
     QA output created by 285
    +seek sanity check failed!
    +(see /var/lib/xfstests/results//generic/285.full for details)
    ...
