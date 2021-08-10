Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF757C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 10:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB7B060EB5
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 10:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbhHJKo3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 06:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhHJKo3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Aug 2021 06:44:29 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9A8C0613D3
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 03:44:07 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id k9so12242613edr.10
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 03:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=PoB4ffYPS4ncgMK2IbZmX2wNO+7gY/LVYemZ/bMXf7A=;
        b=ePmW1YA1HmVVLXjn2/TmzJkMpQsT+T9R03C9Es2n/Vnfkdzbv2P7pbLxoiaZMChvtb
         G8jpVBZP4jCcfgqTZ/uAqHq0Q3U0DZebJCOHOPUfedN0mtZbGJbg6sv1l/l8YhwY8gs8
         VC6L5zSQu895Z7VajN5KF3DCU5JkJYSOlQKtytewDqkuR0MY194QjEi6wkRoefJr+kdR
         QmD+oWeAwiEmeJFIHELz9/lU3LaVTIo57KPfYPIMRgMtRVna5t8o0m28Lqq7hWa/gMrQ
         oNGUmHLaGTqCJ/SaxovWgO6yQw6Rm3q0bUIiSiWXjy+odzOB6EElh1E3mdBVmnihpHVp
         ANXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=PoB4ffYPS4ncgMK2IbZmX2wNO+7gY/LVYemZ/bMXf7A=;
        b=uTs2jt4JuloxqCYSys06UyPOk7+0+JxGYPxXF7Xz3GV/0CSlQ7THHz72Pq6iqOg4Rj
         v4W81FxofzKXTOmI9z064RKnkknViBS6Bw+nCn1qens1lwK+mb/VECCHcfwIswiioOXb
         6Tmr4t3ZMz/pEezeheQLlH09IcCBksPeb/XF21w2JyPm99eXFPwQKLOHjZf2SFUtAlLc
         VZqHbJF5Ff9fyNglBaOPqkJuxlMeFRkj2t0M/M2WIkfNIjzyzpplfPMJaMmdE/R4tbc2
         I8rWTO2Ph6Aw4azV/1rmWJVzv03FkhUISKxya/dzsAuFzY8qIu0fGK+fSKIKxpiyhWkB
         2QdQ==
X-Gm-Message-State: AOAM5306djXs8dIu+5UoC3sP/rbI+XqT39SMFUrrrcGgol3NkmRwvuOv
        h3xYgkyQnASX2SHZKdpID09qXQZjSXbzQmRYvXE=
X-Google-Smtp-Source: ABdhPJyyprkcrypU19g58tyv5AXLXWZXJvBlbdd7vy+bRCbH3M7+HFSFrPlP/ZMmCKvN9AdcldR50t3/xBdmbgaWLJY=
X-Received: by 2002:a05:6402:5242:: with SMTP id t2mr4190195edd.200.1628592245889;
 Tue, 10 Aug 2021 03:44:05 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 10 Aug 2021 16:13:54 +0530
Message-ID: <CANT5p=r5tE5VkQBG62K94fATeW4uGW7Q6_KcHj+5HsiKWoAD8g@mail.gmail.com>
Subject: [PATCH] cifs: enable fscache usage even for files opened as rw
To:     Steve French <smfrench@gmail.com>,
        David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

The following patch enables fscache even for scenarios where files are
opened in rw mode. Our current implementation only enables fscache
when the file is opened O_RDONLY.

https://github.com/sprasad-microsoft/smb3-kernel-client/pull/5

Note that this patch can safely be backported. It still does not use
netfs helper library.
I'll be sending another patch with the netfs helper integration soon.

-- 
Regards,
Shyam
