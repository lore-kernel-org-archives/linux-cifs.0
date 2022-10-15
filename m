Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F31C4332F
	for <linux-cifs@archiver.kernel.org>; Sat, 15 Oct 2022 02:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiJOCBg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Oct 2022 22:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJOCBg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Oct 2022 22:01:36 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3998E731
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 19:01:35 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id 63so6612297vse.2
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 19:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8Mfj2luwT6YM6OE3knmZgFH395eXUOLRJuy3ovID+zY=;
        b=Ad76WnA+CzxDQ/SctV4/zaIxMkr4mgFx0Sgv/y6Drd5tRcFYudRQ+c3ydR398Zbt40
         6DJDnnLZNcrJzQUURZTD+3O9Dsaph4pfHIw5MWLM6nwOKiZVM/37nP/y214EJJuC4Dec
         bzACNZcs5XmgfFEh7+GsUicVmRjFQMw+qqHrrjaLNxocbNZfQN3sw9fN+2zNjY6pNbaJ
         2cYwIFMpfIgxPydXPfWsL1/gzVLkHyZ6qSP4wkE4NG3jA2XI+vUhjN2wNkScCcaqoKcD
         p7hdar7mFy+IflC7spqQ8mR+2wPJSQnyrUnFFuq9rMjP8oWgm1OWKcOrR/QPb4leQuWm
         0//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Mfj2luwT6YM6OE3knmZgFH395eXUOLRJuy3ovID+zY=;
        b=CX349xcMUmSx7x+s82JqbgRV9HFAHskEWC6UW+MrTHh5lL17evHXUDwp/VlnfAVNz8
         5XcAdC0T9jVUfqgfA0VmxRs2oeoN3dN3ZRskWqrBJqb4Qw4iTdOAuZCohMhUbkI/CPTZ
         bLq41z3uKRh7OMoz/J3087okpy7a05UlQGZmo4vgE5mFjybY25L9HojF3NVxDRt4wfYm
         +/WOUmwDoSkwN0PxNec7LoOWTUYZm62aFNCoM/9AHd3psvz/ADolGbct0FnTaofy6+dO
         Qv3iUp1MclkMYc/Yh5+1OywKbysqxZG7gzG4TgFAGNAZlhyGE6mDFy4dnR157POyZ0l6
         B64Q==
X-Gm-Message-State: ACrzQf3sKrZ/07Dei40Sk7Cn5QJnB/NbL7sar+o8J5GkNNtqvMAQId1Q
        QEpeZ6bfrgFGHUtc/PW7C1prbZtAPvmJ6CspQcc=
X-Google-Smtp-Source: AMsMyM7mhBar8teRz1+38YFX3CUPEumTixUGFU8TGy2QuX5N8uQL9xfHoeMHW9ycDidCCWeHJ/JkkzSWeSSKccd50sM=
X-Received: by 2002:a05:6102:23dc:b0:3a7:9b0c:aa8e with SMTP id
 x28-20020a05610223dc00b003a79b0caa8emr269185vsr.60.1665799294612; Fri, 14 Oct
 2022 19:01:34 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 Oct 2022 21:01:24 -0500
Message-ID: <CAH2r5mvcZRgF0NMRpiaK97iTby0FHjaZ0ZO7qvVTcsPqfrW_mQ@mail.gmail.com>
Subject: metadata caching and dir leases
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It looks like dir leases (and actimeo) are not helping much for examples like:

"touch /mnt1/dir1/dir2/dir3/dir4/dir5/dir6/dir7/file"
followed by
"touch /mnt1/dir1/dir2/dir3/dir4/dir5/dir6/dir7/file"

at a minimum (even without dir leases), actimeo should help us be able
to ignore the
8 revalidates on the directories in the path but when I try it ... I
get 8 "open/getinfo/close" compounded requests sent

The dir leases patches do seem to help if I did  "ls /mnt1/dir1" then
"ls /mnt1/dir2" etc. then did stat on a file in one of the
subdirectories but am wondering why actimeo isn't helping on reducing
the compounded open/getinfo/close for dentry revalidation.

-- 
Thanks,

Steve
