Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D63CA0FFA
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Sep 2023 17:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbjIER7n (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Sep 2023 13:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240609AbjIER70 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Sep 2023 13:59:26 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAE83A99
        for <linux-cifs@vger.kernel.org>; Tue,  5 Sep 2023 10:55:55 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2bd0d19a304so46237931fa.1
        for <linux-cifs@vger.kernel.org>; Tue, 05 Sep 2023 10:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693936502; x=1694541302; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HaLBF9JULR3pvVhPzdqXHldlD3WLab71DqI9y0iBuWo=;
        b=RNPvnvVPWbas6aTcfjSV8NFoEhhrBtx5fMTwDgCWhrHSr1JMfPC3xraXbZXtIfUk+z
         THUP9OzvgW/mPaOENt5iqdjUxmaxEX5T0T8brDwl6gBDNd6pqn7Z/mBB11+eBbp+98V7
         3l/gHLSAw8m4AP/EQWvPb6wMoiPnBj6y6qd3hKL/RQFvNAtnikDTyAjhn5Z1iy29Q8yT
         Uumo/tPjZBke0pRiPq58tbDlIv834ylNAwP4eiBLLw+gfFLGQm+LOApu+BO4sNx1HKCf
         TVL8ru80JfQWEP+hQjJ40CMJDkjmOTE5gCzZuUk/xZM07vgYtQKLU8cl6rP3VV8sFcId
         YzsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693936502; x=1694541302;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HaLBF9JULR3pvVhPzdqXHldlD3WLab71DqI9y0iBuWo=;
        b=LpLs54E3+R59+Ew0BL79rUiUspUGIMT602Spg4fj8oUaNv9YiwIF/n6jSXtSGSFhcP
         6qFPl2CKUe1dShKoj9wFQcuvGCFTwHvGUAt25tNj8+AR8doHaYp6OJfBi+adSjTOPG+2
         gm+YcheR5hXZORbd/eUuO7THa9Ke8+/WYHloVn/C4/Uuwc7snSz11ca6vCdRlHt3Nv49
         Np76IjhkGZ6Cl8qbZTxqOUoKeqiYzVdxuhwx8jWThUQqeZdYGcfU+3VcMlXj075z3jYE
         iers7/80pXfjgiag0UolaPQ4u1u2a+MtlFir0SKwHhs8gkVM83MLJ7fh7Sxvk+91mjKD
         zDng==
X-Gm-Message-State: AOJu0YyDaHbJUMSX1IQX1CRdmhjXDEEXxAP6WdAoezr7oOPNYhdXd6RG
        N5iO5XHN9rxJn8vXcWmmVr1yEKOtoTpQjWrHsjkx6o84
X-Google-Smtp-Source: AGHT+IGYm0t2z8e5SFDepkDO++qI0JUsgmPxQ/gvS2AIPOTXr5ljIusoaN03wM2/qGm+qAfvedFHv307ikU5SHLg414=
X-Received: by 2002:a17:906:749b:b0:9a2:26d8:f181 with SMTP id
 e27-20020a170906749b00b009a226d8f181mr383148ejl.61.1693933756199; Tue, 05 Sep
 2023 10:09:16 -0700 (PDT)
MIME-Version: 1.0
From:   Brian Pardy <brian.pardy@gmail.com>
Date:   Tue, 5 Sep 2023 13:09:05 -0400
Message-ID: <CAO+kfxTwOvaxYV0ZRESxZB-4LHsF9b_VBjAKahhwUm5a1_c4ug@mail.gmail.com>
Subject: Possible bug report: kernel 6.5.0/6.5.1 high load when CIFS share is
 mounted (cifsd-cfid-laundromat in"D" state)
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

My apologies if I do not have the bug report protocol correct in posting here.

I've noticed an issue with the CIFS client in kernel 6.5.0/6.5.1 that
does not exist in 6.4.12 or other previous kernels (I have not tested
6.4.13). Almost immediately after mounting a CIFS share, the reported
load average on my system goes up by 2. At the time this occurs I see
two [cifsd-cfid-laundromat] kernel threads running the "D" state,
where they remain for the entire time the CIFS share is mounted. The
load will remain stable at 2 (otherwise idle) until the share is
unmounted, at which point the [cifsd-cfid-laundromat] threads
disappear and load drops back down to 0. This is easily reproducible
on my system, but I am not sure what to do to retrieve more useful
debugging information. If I mount two shares from this server, I get
four laundromat threads in "D" state and a sustained load average of
4.

The client is running Gentoo Linux, the server is a Seagate Personal
Cloud NAS running Samba 4.6.5. Mount options used are
"noperm,guest,vers=3.02". The CPUs do not actually appear to be
spinning, the reported load average appears incorrect as far as actual
CPU use is concerned.

I am happy to follow any instructions provided to gather more details
if I can help to track this down. Nothing that appears relevant
appears in syslog or dmesg output.

Thank you.
