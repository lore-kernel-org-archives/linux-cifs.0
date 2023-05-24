Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA97C77B7E
	for <linux-cifs@archiver.kernel.org>; Wed, 24 May 2023 01:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbjEXBmj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 21:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbjEXBmi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 21:42:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869B4130
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 18:42:37 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-25343f0c693so290935a91.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 18:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684892556; x=1687484556;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+I9na0UV1ioD0lJpb8VG8az8Od8atm1wZY2D6g1x9oY=;
        b=lt2ii2N1uTM1PPl0ztURJAOJUm9L5szJ8bps85yVJYx+Lo8GSRb/0a3ian56Mm2zRU
         uc2yKpTqgi0uAQh1683980369XQMUM/cnoc0G3VgLK6vrdtVgk7gZ/9IOxwVM0/mw12O
         iPADa63KkaNUiX8KMBiL3oIA9Q/3uzory0fAHHMwGDj6e/znrbwbYoYVmveA5B2XqNVC
         VbZLb3Vgnwt93sROO01u4j8l+z3vRO42oCXq8MaB+ivyQG6q0ifFOC4A/C5F5VOAl107
         tEcoMMvQcyDIKMZ1PBRtRBQ1Vlr6SGL9g/kSctN/qTfq9NZVr0So0bjYcr6nvKzDS7sQ
         Vh1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684892556; x=1687484556;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+I9na0UV1ioD0lJpb8VG8az8Od8atm1wZY2D6g1x9oY=;
        b=fuP4nYBawq2LO3Bfoh5VnX5jSwmSvy+VbDdHWQsuaTohJnliOvx9pekTsZGu9M8erO
         CTgWLe1EKCUejeya7ng9xcAnEqqtyU2pLPZ8J+LwmMlGkoshsIISJmPhSNTwS1wcFyPG
         YpgvsEOyK5s+8ZZvkG9PatvX7bMG2VpNnbecpvsAckm7tRm0XcMyUh1hGHj7rYFZE0e4
         1dH5h/w5z7jwTr9bSgDi6/lUNQpgkV2IZVTWOp+iG0GoahTpn3TsspPVW2A6cfzTp23w
         DngEav+a39GIhL9xmMK9lIIAs2JbrijlElR+m757BOS92jQYWLLgNAB4EjI5IbBqkTcr
         1/Fw==
X-Gm-Message-State: AC+VfDzUHk4LKaBavZzjO/KqoqPHRvrXSlV62oOpmj27Sjgh1+NgTzPB
        ohyW+nmnim2dipDx9peSol+QYkScQvpQzQ==
X-Google-Smtp-Source: ACHHUZ5d0TPKyFRfwc8gXzDjmSWdRmGpMRnYPdrqLUNRbs/gaqKuO/0pQaI3Di6MIBBaa0ntUOk1IQ==
X-Received: by 2002:a17:90a:e7ce:b0:255:735f:9224 with SMTP id kb14-20020a17090ae7ce00b00255735f9224mr7285847pjb.16.1684892556455;
        Tue, 23 May 2023 18:42:36 -0700 (PDT)
Received: from storage ([2001:569:76c8:9c00:cb4a:65e9:9f3f:7b04])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090abb9600b0024de5227d1fsm174448pjr.40.2023.05.23.18.42.35
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 18:42:35 -0700 (PDT)
Date:   Tue, 23 May 2023 18:42:34 -0700
From:   Tyler Spivey <tspivey8@gmail.com>
To:     linux-cifs@vger.kernel.org
Subject: Bug with mount.cifs and mapchars
Message-ID: <ZG1rih4YPhwaQdQs@storage>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi.

Note: I'm not subscribed, please CC.

I'm trying to mount a Windows 10 share from Linux with mapchars,
but it still uses the SFM mapping.

Linux storage 5.15.0-72-generic #79-Ubuntu SMP Wed Apr 19 08:22:18 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
mount.cifs version: 6.14
Command line: mount //192.168.145.1/e e -o username=tyler,uid=tyler,mapchars

This also failed under Arch:

Linux arch1 6.3.3-arch1-1 #1 SMP PREEMPT_DYNAMIC Sun, 21 May 2023 16:15:22 +0000 x86_64 GNU/Linux
mount.cifs version: 7.0

If I create a file called test? in a directory, the ?
shows up on the Windows machine as u+f025 (SFM mapping).
With mapchars, I would expect u+f03f (SFU mapping).

Looking at the kernel source for version 6.3.3,
it looks like sfu_remap needs to be set for this to work.
However, I can't find anything which sets it (mapchars doesn't seem to
be hooked up to it).

Thanks,
Tyler
