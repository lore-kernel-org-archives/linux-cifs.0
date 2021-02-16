Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD0BC433DB
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 06:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F1864DF0
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 06:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBPGFX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Feb 2021 01:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhBPGFW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Feb 2021 01:05:22 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC2CC061756
        for <linux-cifs@vger.kernel.org>; Mon, 15 Feb 2021 22:04:40 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id u25so14081095lfc.2
        for <linux-cifs@vger.kernel.org>; Mon, 15 Feb 2021 22:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=clXo+dLZbSDFzWQjbIAhXm3zAkVUiaui7MA2b6O6I4I=;
        b=cdmMilfR85fbl2rWnge2bNRIPdqrK4PmhhQ6Pq8fU/o7WuvIUmtBzHLKTtRg5wHfxa
         khzdcQPJMGcCzI51SgSc7OBOd0U1N+lQwHRBNftoLPoG8WXYsDzET82X0eLq8CaAPQLF
         Mh2FlLC2vFlAqZfJuDL5Qkq9X+mXw2F2TeMLhP6ykrpeWvlT0hpCmfQ4MjW89etMWBO7
         qhYvFYugYTfq+bb2ORxswXXXK0xjQk5s3qr1Z5xJpY+lp2CSY2nCQG36sMYEiuAiYoft
         5Y1QzOGeLMC/LYdkMrW31y3snCU5ZGmpOkvUMXZJRHq/pyeamALxTE5RkPU50VMPAqwF
         3QYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=clXo+dLZbSDFzWQjbIAhXm3zAkVUiaui7MA2b6O6I4I=;
        b=jUHBtrJ2oyNBS5vr0cedFSrteOrWAOsD2epExJHzYEsiplAdO8D0ziVe8BO7j091o1
         mqa34yzEJuyKFICdD0VB1x257d1EnwsBfBxdNRZfVi0SoeW5VtwVbSvUscHUy7nh52Xd
         8Ofn0NFphqh+LEVdkaugX2Z1cjPv50uoVD8htTnYE2M1NpbkPHiXiip8pxQ38vnYIgNV
         ZJGZYyiP60CtGl2CyIycZrJLW0P1Y81bWcvN/YSAK49zsrlyRXHHpWOhPPhbxREgVJVw
         oxgNurXm3f9VTC1vDyllCtzBWyS0jeyTvnTfCvQG4X/lOsPhLuGTdVq6VkvJbOnKE0df
         zF7g==
X-Gm-Message-State: AOAM53266JerB6kD6OtlqzcDynH8hWVxAlDoSjFCl/q2uNZzrdGbrDIm
        mLHddfR1XjFpwjK78I3znqDUlZIs+SVOnG0zdSIjkrvtlFM=
X-Google-Smtp-Source: ABdhPJzJ00Ml0d1BKbwgPsZnbT733PqUOuHZBVlvtw1F+Pnk63x98ZRORmz62Dv/6AgyEKnuK/bByYnUFSKPLKrdSBs=
X-Received: by 2002:a05:6512:1311:: with SMTP id x17mr10841371lfu.307.1613455478794;
 Mon, 15 Feb 2021 22:04:38 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 16 Feb 2021 00:04:28 -0600
Message-ID: <CAH2r5muxMuKw4Vk6k8P7A5SNVnO5E0zgFCfXd_DYXxvt1MfLgw@mail.gmail.com>
Subject: cifsd rebase
To:     CIFS <linux-cifs@vger.kernel.org>,
        linux-cifsd-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

FYI - Rebased the smb3-kernel github tree cifsd-for-next branch onto
the recently released 5.11

-- 
Thanks,

Steve
