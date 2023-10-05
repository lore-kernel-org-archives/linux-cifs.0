Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB27E9371C
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Oct 2023 20:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjJEUqd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 5 Oct 2023 16:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjJEUqc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 5 Oct 2023 16:46:32 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A5293
        for <linux-cifs@vger.kernel.org>; Thu,  5 Oct 2023 13:46:30 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-503397ee920so1789805e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 05 Oct 2023 13:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696538789; x=1697143589; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hTBVcT90GYeWhKZMQT3czx/pU+TOOoUAvSp7T6fIMYA=;
        b=nGHZ73+F48m2JxJ1fhETSFatbEsQS3V4lSZ0pBU8FJu+JJrfV5bfvXie/NbUU/LuU4
         BbfOFEWa+0h0NWAkGuTQZM/ZtAMje79hEsnotXVNHJKVyMDcoQOEELC+Yq4euOjbwNRC
         iOiJlti7OH7PNBwvlluHdUHodSAN1CtktrDTbEpXsNoqQwcwtBAJsWKC/iNQ4MmvdFMt
         louPZtZOi6LNKylz9ndmZ4tLHhZowhq+Tyvvx0NXK0r+Dr9H49RCpz3PBugvnhLXITwk
         upHI9Rji2VAalTr7f5iWlzxxN/RNpavhcp+5zPAERJvIdUAkPtejTnPPK94wKwJdZbkz
         goTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696538789; x=1697143589;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hTBVcT90GYeWhKZMQT3czx/pU+TOOoUAvSp7T6fIMYA=;
        b=I3rm6n1oqrRWKWvX2JFnD1de0Q+s9KpFDDqRXpqJdnNt8oq4JEpcm2G7h6XJFgq4sj
         hW5YM/XcAkMGiEID/ox0W3RvlPfwsdKKQx4URtstA9fR1eAtDMjp1W/rYTRpEyn6yU56
         1bt/Pdqlfv4M1msj3h0s0MMgKcpwvIYCqgi/UIZHudFFrJRFMLPMTu/nXnQIF7yRSr1Q
         F0QO13s4w6tc/jHD+qSWAocDG4fCofksuHM4lROUAghHCeexkMzWvebRwTEU6p4QGoKc
         mpNMS0eyK3EqHXf1osRUSr+bSuK0dIY8rrrQ3xe8Ej6LZSM5m1tndsqS2fzDEJ1wAdDi
         82Vg==
X-Gm-Message-State: AOJu0Yy7jUKp89soj8yFhWmG6c4gjvtcie9zmf9OYDgNClqQjWQ0aDip
        BpdXHSW/S32VQsoEN72E8SE5uygLjCvuD5LzJSq3ScfX
X-Google-Smtp-Source: AGHT+IG9WWkNRTJb5lEL4tF233DqqqSdGjTDk5ULBcRi1P+vcpKJVCvBb/SRznyIOjBjh1pweQKlcXlkZKh2M0+vzmk=
X-Received: by 2002:ac2:5f89:0:b0:4fb:89e2:fc27 with SMTP id
 r9-20020ac25f89000000b004fb89e2fc27mr5047237lfe.54.1696538788356; Thu, 05 Oct
 2023 13:46:28 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 5 Oct 2023 15:46:16 -0500
Message-ID: <CAH2r5muSe_-Cs-HitMnBE2eDAjbtJPCo4-i75mu0xdTq3+OrKg@mail.gmail.com>
Subject: oplock state inconsistencies
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@manguebit.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I noticed that for SMB2 mounts (which use oplocks) or for mounts to
ksmbd (which defaults to directory leases turned off, but oplocks
turned on) that the open code can get confusing since there are two
fields that are used for checking and saving and updating the oplock
state but they don't appear to be consistent.

struct cifsInodeInfo-->oplock
and
struct cifsFileInfo->oplock_level

Any thoughts of the reason for having two fields, stored in different
structures, to store the caching state?  It is a little bit easier to
follow with leases instead of oplocks.

In the short term I am trying to understand/fix why with oplocks so
many operations break oplocks unnecessarily (due to not reusing open
handles)



-- 
Thanks,

Steve
