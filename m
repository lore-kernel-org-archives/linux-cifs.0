Return-Path: <SRS0=MPEU=Y3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEE8CA9EC7
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Nov 2019 02:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BB692084D
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Nov 2019 02:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iIfNQ1ij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfKCCgn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Nov 2019 22:36:43 -0400
Received: from mail-il1-f177.google.com ([209.85.166.177]:47019 "EHLO
        mail-il1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbfKCCgn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Nov 2019 22:36:43 -0400
Received: by mail-il1-f177.google.com with SMTP id m16so11831233iln.13
        for <linux-cifs@vger.kernel.org>; Sat, 02 Nov 2019 19:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=AnubAyYz7x9zujXAX88X2WPDcUeE/YNOy16ez3UY4AM=;
        b=iIfNQ1ijIUcLuUCxqbs2VSQWiE92D+aHdZzTd+FOQjbWSsVfVd56VsNyUqDpsTynjL
         5I5Oa7xcLZpNx8jrhnlQ2e55iZj917SnRXbIBkyCKc/CHvj/S7cky9b/ZZ0DeIjidxny
         Lb+7tDP0KT83FEBdf9gUXKwfQbwc1vn049B/CwQa8rhygfjZbgwn0tjsCjv+BOkV3Lig
         M8eXfpl5vVd5ZsoalJ7dfsWwbY6/idG+Uy/G44Lb0Xn+/CYz6JkUGPOGTKeK4B7I5l2b
         7MkT/DbHj5tADvkDcSmC5MBlJCJIx6LIW3+oHnhCzgOiAo/WaCfRkOgMQuufwMlOxq4O
         uWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=AnubAyYz7x9zujXAX88X2WPDcUeE/YNOy16ez3UY4AM=;
        b=T0rxLtDlqeJMLa704S6pjNawIsVz34ZLWuEGIOAnUQBnS1q0+UlAn/gUucVOzc3NPQ
         4bVXGiHE14Vs0yeXGVKK6zzgwwu9hoNWPs/X9kGl7EpYuZzaI7mc3aF0H6F36UnoguVd
         y9oSYs1HZHg4LvPzXg08Gpo5Z2Je0rh+khWC+BzwNQ8Sg7COzkOLneG77vQXwYuy6DG/
         eC3iMDtj2vdNKVew8+3gs3YZ9ltKwMgrj+vRcA6rZA6ksXV3dxhEYGFCCGBR6u5CWHhO
         +l9WmJp8LoD5ocQCbgW4rH85TM4PW8ijzxO1eOJrpJIcC1ON3Agtc9HncrwdsWEFhx4k
         relw==
X-Gm-Message-State: APjAAAXKeVevSqQIdVOTZxViMdqAoWVPRYV4K+T+MMKxrN2WG8TU0qoM
        47qf6GhY3v5v6XxZCWBKcV8yYq95c01sTUqvAHOE75nSSW4=
X-Google-Smtp-Source: APXvYqzsRBNX06z7lK0xBLwEdRyK/MhEXAHq3CYHbmcsgC2H2jL8Jfd70CSZ5CNRQ70y8CqjetjeGudlnrWz7RfgcmQ=
X-Received: by 2002:a92:5d8f:: with SMTP id e15mr22640380ilg.173.1572748601796;
 Sat, 02 Nov 2019 19:36:41 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 2 Nov 2019 21:36:31 -0500
Message-ID: <CAH2r5mv8O0R1ath7fe+G0ENcv8fC-MXda4h7GHEun-4TCE7EyA@mail.gmail.com>
Subject: buildbot kicked off for current for-next (patches for 5.5)
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Buildbot regression tests kicked off for 19 cifs/smb3 patches
(including most of Aurelien's multichannel e.g.) - things destined for
5.5

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/277

-- 
Thanks,

Steve
