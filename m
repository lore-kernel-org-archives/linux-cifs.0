Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F963C43460
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 04:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 646F86101A
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 04:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbhDAETz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 00:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhDAETj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Apr 2021 00:19:39 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C5CC0613E6
        for <linux-cifs@vger.kernel.org>; Wed, 31 Mar 2021 21:19:38 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id d13so821416lfg.7
        for <linux-cifs@vger.kernel.org>; Wed, 31 Mar 2021 21:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4i9StREZ9jU8ujdCK5qtZJTyFfNL7BdONZu7qVS7abc=;
        b=sdET+XEXGP8+FgxkJeIDSmOE22aTGXs+cB365RWjOtd2QBS+3zO1BfbyQkKTVXE186
         LPFqY01TY8jCGn9G2D+uh4VED/uHANgz9XiMBOGQdbFpqg3Net9Y72uX23/I0ueIkkf2
         NL7L0skZgyERPaY+hwcvWbBqO8M/EEtJ/G9LRU2KTtyMY1HS9mQtGYmwmHXMWsy0MEzW
         9667P2InNtMviuA6lYulaiOn7Z86T4Io35SYKmRnUobNVYN024BdJZFS7i8B7krqePKF
         9h/dDvFnwg8WT8hPwmVsca0l781QhP6zWcPc22RWjtwJvyqVI0Y+SXqsIv1My/Jqh5X7
         zjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4i9StREZ9jU8ujdCK5qtZJTyFfNL7BdONZu7qVS7abc=;
        b=PY2G69L4Qtqfl4v00a4akSNUGVMwHK8wYdrWhiAEQarmHY9u+csfdaqYrtZLcgDeEd
         sP5AdqV8mAVHSwNnmjUfEGnl4gDFWXbZCue3HusgWDZSJtKGLIAPLFvxXyb4Zzeswjwq
         SEAjq+C012e2TX6vsL2QHtkS+UJ2vsSchsfOLZNCaBWROzyZNjGl37REqt9BBQ8dXApE
         UUAZJyJCnY9MGhkZY9LXr8OR9+xMkr2i0RikTRO6t7Mt5YvCG/MlBLSo7OkHLITfceqC
         Un1UkrPmYkc51TmKls9lri2MUJHiQJb01syI3C+5Oz1Eo76zXO+kaZjhsdbwJ0saBdr1
         Rvxw==
X-Gm-Message-State: AOAM532aCTN2tmSfO4zVgOO9bemmcBmg5doFb2Xm/Ea/t+zRYY8edw4H
        ogImGyFvqNjbD+j3xeGOHKGzkwANwRx9OxRrbQhja0j3/8enQA==
X-Google-Smtp-Source: ABdhPJxPGIjkSR98P834/YSk1be4axh1ZgjboOvW10Nf+uiBg2c1CVg36Zzs0Dx5hFp2HN6qj8nrs1gJzj95fxnCoqY=
X-Received: by 2002:a19:8c0a:: with SMTP id o10mr4278814lfd.175.1617250776675;
 Wed, 31 Mar 2021 21:19:36 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 31 Mar 2021 23:19:26 -0500
Message-ID: <CAH2r5msHtBOPvdfj0-mQ9nO3fMyDhaVoYkyTxNFyf9=J_o+gsg@mail.gmail.com>
Subject: cifs.ko improvements - Additional xfstests
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

A larger set of xfstests passes to REFS than we realized (even more if
non-default mount options, like modefromsid,idsfromsid are specified).
For example I have been running this set:

./check -cifs cifs/001 generic/001 generic/002 generic/005 generic/006
generic/007 generic/008 generic/010 generic/011 generic/013
generic/014 generic/024 generic/028 generic/029 generic/030
generic/032 generic/033 generic/036 generic/069 generic/071
generic/074 generic/080 generic/084 generic/086  generic/095
generic/098 generic/100 generic/109 generic/113 generic/116
generic/118 generic/119 generic/121 generic/124 generic/125
generic/129 generic/132 generic/133 generic/135 generic/141
generic/142 generic/143 generic/146 generic/149 generic/150
generic/151 generic/152 generic/154 generic/155 generic/161
generic/162 generic/163 generic/164 generic/165 generic/166
generic/167 generic/169 generic/170 generic/178 generic/179
generic/180 generic/181 generic/182 generic/183 generic/185
generic/186 generic/187 generic/188 generic/189 generic/190
generic/191 generic/194  generic/195 generic/196 generic/197
generic/198 generic/201 generic/207 generic/208 generic/210
generic/211 generic/212 generic/213 generic/214 generic/215
generic/228 generic/236 generic/239 generic/241 generic/242
generic/243 generic/246 generic/247 generic/248 generic/249
generic/253 generic/254 generic/257 generic/258 generic/259
generic/284 generic/287 generic/289 generic/290 generic/297
generic/298 generic/308 generic/309 generic/310 generic/313
generic/315 generic/316 generic/323 generic/330 generic/332
generic/339 generic/340 generic/344 generic/345 generic/346
generic/349 generic/350 generic/354 generic/358 generic/359
generic/360 generic/373 generic/374 generic/391 generic/393
generic/394 generic/406 generic/407 generic/408 generic/412
generic/415 generic/420 generic/422 generic/428 generic/430
generic/431 generic/432 generic/433 generic/437 generic/438
generic/439 generic/443 generic/446 generic/451 generic/452
generic/460 generic/463 generic/464 generic/465 generic/504
generic/524 generic/528 generic/532 generic/544 generic/551
generic/565 generic/567 generic/568 generic/590 generic/591
generic/604 generic/609 generic/610 generic/612 generic/614
generic/615

We need to do additional testing with Ronnie's fcollapse and insert
range patch set.  REFS, like Samba on BTRFS, can run various testing
which depend on reflink ("DUPLICATE_EXTENTS") so additional testing
also needs to be done on Samba with btrfs to see if differences
(indicating potential bugs).

-- 
Thanks,

Steve
