Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D72CC433E6
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 19:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09F9D65238
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 19:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhCITnL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Mar 2021 14:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhCITmr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Mar 2021 14:42:47 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11276C06174A
        for <linux-cifs@vger.kernel.org>; Tue,  9 Mar 2021 11:42:47 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id n16so29210003lfb.4
        for <linux-cifs@vger.kernel.org>; Tue, 09 Mar 2021 11:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=UoZSV/1okiYaAxLsyYtLvVcyeQ2TTbLTyKqZoHP23vU=;
        b=vU/rw4EZHkQw6XjOZZFRkc0t+1OVfTmxfQ5329e2iAqxaw+DObkKJ12wUgEA88ks8n
         NGApru/iS+/wwLaoI+kSBTrIq+Yr6oF0XoN+xF9C7VixMGoAsh2cmLck6YCiitZcO4Py
         uUbWdRbWPAk/BnBc7jUGrWkz5p5sOERsbUMVlaLL0KVhMj6pxOzSAGRmkAIxZzbbJGfj
         hT3duWvFnForlr9t+nwjh8BK5kpaXNZ12hml/eg+wxb+dwLZib3ZOvZyQKzNeB06qQ9S
         Au3558/2OKbOh58iyxdLOau6/2DOaUC+USsTS5S4Jb2MJRbp0gUkOFdQ0bXfRh4AvESJ
         jL7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=UoZSV/1okiYaAxLsyYtLvVcyeQ2TTbLTyKqZoHP23vU=;
        b=oXKv3k/8COWJVTazkcR5k17czibnrbwdUUKizz/ULrZGCW4FJj0fnS99RB1ZIPc+Ca
         8vGYe0qrW8S75YV7eDzTOlf5Bsd09uPt2nckfP6tD1pqqb/+6s7T3Ju2UXysQU90ft/U
         RerAAJBwiFooIr2kNRD8qgr6lOyWRGa29ET0lQvpDwkXXbZuVWiFSKa0EyESi8zZ0sD1
         LJ+J9c75FUkH5mBmaHY+l1Xhl6mgywrEo7zCWx4EEXWPNVkfbhaQhmqcThBeLdjJJ4DM
         tj3YyJ+BBKX1Gf3xpVJOU7/ihTkuysCmpV4zhElRYbUusOzyO/JDIlZFmNbl1GUnJOa4
         7Z/g==
X-Gm-Message-State: AOAM533t7MWwltHUfIy7haxVBGfs7qWdgWo4IpC8GvPZMoxsYEN7x3tf
        odaL4jQ5qvmUTsRceAeWMJ9Ija/URm+WdJlAZAEc9nrD7rfIzg==
X-Google-Smtp-Source: ABdhPJxFGvq0a7nsCx32wmSLUV8s/kzxRtt2zPHLTj/XJLhpkUlZmNULZGoY7ezqAn5DU0Hx0+ukevVSI5en0dDHcHg=
X-Received: by 2002:a19:404f:: with SMTP id n76mr19166455lfa.184.1615318965346;
 Tue, 09 Mar 2021 11:42:45 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 9 Mar 2021 13:42:34 -0600
Message-ID: <CAH2r5ms9Wd1ywF6-_jb379dCsY-0ZrE-k95pSchGgsHnB5tctw@mail.gmail.com>
Subject: DFS tests look good
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

With current mainline (5.11 + all fixes in 5.12-rc1 + the 6 pending
patches from Paulo and Aurelien), all DFS tests pass.  DFS quality
looks good. I am going to hold off the fix for slash ('\') in paths
until later to make sure it doesn't break DFS.   Let Paulo and us know
if anyone has more tests that need to be added for DFS scenarios.

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/3/builds/93

I am also trying to add more tests to the cifs-testing group - there
has been some recent progress (e.g. adding more tests for swapfiles on
cifs mounts) but going test by test finding the missing features can
be time consuming so more data on specific things that would help us
add more tests would be helpful.

-- 
Thanks,

Steve
