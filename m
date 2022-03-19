Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3292C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Mar 2022 04:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242053AbiCSEZA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Mar 2022 00:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242055AbiCSEYz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Mar 2022 00:24:55 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462201162B6
        for <linux-cifs@vger.kernel.org>; Fri, 18 Mar 2022 21:23:32 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id k21so392235lfe.4
        for <linux-cifs@vger.kernel.org>; Fri, 18 Mar 2022 21:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+IfDSbqdeL+NcT1LjQwHJGogeTT6WOc2VxBVIOnIFF8=;
        b=h8YUDXxNXqg7St/O902o2n3SsVgx1Af5imHCeYRfte7YM5nltQraQSnJl5ogATcMSq
         +cF7DUOAid7pt3IO+b6DICzHBL4CIe4mTrbsehc6GHNzTjLWpJegJjPydOgvevpsFpX6
         MQqg2OSrBNjK57V2mBIrY3yi//T5slRw+hJXv3TcRiSBoDC1xR6J0hSJbBjZa9ASpJk+
         ALXadOnOatmS3Zs+PwcFsiBrcjNwZEYt3EAEtKvXgdQMlZanfAghu/wySazEhL9BdZla
         0575TqNUWMp31VE/NG/j1V/UCUnWCFx5gJCijEn7JNXXmQbmHbF8aXoUd9oqwaTBqyfC
         F+Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+IfDSbqdeL+NcT1LjQwHJGogeTT6WOc2VxBVIOnIFF8=;
        b=7sMOqPLGINUGdEM86405sSyQxg/g1w9jitN/7Ih39JVFHGLXJ2o4ZW/H/QdRA7adJv
         EORH/M9wWg3kqPpTq+8eebqYNGUw9nrDGe9+qWCK6iGRAAxNigWX8enFFxkpKBj3dIdZ
         3baEOZaXT1kj+1YiCmnyEzkZqURw/MafGrHlbf2kA1Zg9Ez1K2BK0G6Sajdg2GTQvsyg
         hZj3kNfCtpqtmLjBgeubHOpxcke52bbBcaTKGLGxPnqNYcT1vEq/DqU4mYBOThrb8pO5
         xlogd4DJuHGd7zh78GWAKLXon1+0/2YaBZ2KMQFFD2Upfj9DwiZiAPh9I8DmC9rz3zqb
         dNqA==
X-Gm-Message-State: AOAM530bMpJh+GQn8fG3HEXSqFL1lYGrr+vGEwGu3gpo5dJpWyrx5tt9
        8ZFXTABw1dZsfzDkxRl9ajBd6GHB0bmb3YkzRRh6AToU6AE=
X-Google-Smtp-Source: ABdhPJw8IEcJWZ6pi3zR89VnBchRs+TKrw8BgO7o4+kaqiR/np0bey+JX2dC19z14fcXs8c/Jzi55i3YkYgQsEtwv4A=
X-Received: by 2002:a05:6512:b19:b0:446:f1c6:81bd with SMTP id
 w25-20020a0565120b1900b00446f1c681bdmr7967792lfu.320.1647663810187; Fri, 18
 Mar 2022 21:23:30 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 18 Mar 2022 23:23:19 -0500
Message-ID: <CAH2r5mvG6jmUKVi4zqRouFgYSjYxJjTExjmPtH64PAjFahE8dQ@mail.gmail.com>
Subject: [PATCH] cifs: fix bad fids sent over wire
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Any comments on Paulo's patch? It fixes an endian conversion problem
that can affect file ids used on big endian archs.  I will add cc:
stable

https://git.cjr.nz/linux.git/commit/?h=cifs-bad-fid-fixes&id=a857bb6b15646a7946fafb281878ddf498107dc3

-- 
Thanks,

Steve
