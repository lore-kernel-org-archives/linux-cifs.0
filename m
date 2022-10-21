Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50452C4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Oct 2022 03:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiJUDZI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Oct 2022 23:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiJUDYr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Oct 2022 23:24:47 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0669A255A3
        for <linux-cifs@vger.kernel.org>; Thu, 20 Oct 2022 20:24:34 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id c23so174895uan.13
        for <linux-cifs@vger.kernel.org>; Thu, 20 Oct 2022 20:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6Jb3/y82rYG5VRksobF9av01J/tmfyezURCOgvPsHlY=;
        b=fSb3VWhk0HXTP/lKEwp1pDwCg3cPTvD7MEc/hQLGG2+YYiYnfVSxDeMJEklTQBMsyS
         p61+pwLs4+j6RBAWPr404G8U2VJzlmQ8MQroMDdquF0o/8dFse0gEuZZzqV2FX4FnPPv
         MNSnDszWKlj3L7qfbtGF4+v77xsU5Tpir3yUrsDqQnGq+saGhQUkCnvysYd+VA9VxrjD
         zb2hAv1a36qPOPGM1IIoDFZd9Mnpuf1MF2bFDvw7tbjT6ALUQZRDLNsTFS14kMA6pghj
         5U5uGvmef0YRaEt6nZ6BV1gSy3IuXtt+GTiQG1zITa8JK4651tsD2xa08B+WTm31+iNS
         rFyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Jb3/y82rYG5VRksobF9av01J/tmfyezURCOgvPsHlY=;
        b=CRi/JbRi8grhLF0F2W3EVnwql/dCJzFHJnHcqTVmfzOSJbgQ3ahScTjS1Imzkoj38s
         8Qqq2FlVK7WPZHjcgRvgljnhF3B62faZyD4wVnbkW3RivASQ2HbGBUTzaUwCBTLaD4d8
         UwFM4/fw9M1MceU4ABxA22M0i8OdhMSXojBCif47Bisr3Y+APk4BqdVLB5Hcir9lrQmn
         sYDxfQ8gSHcmNyqBBwBwErZTkSGZkcgjKP26mO8jvAHhYyY6g+cN6Cv8axhYEwxfvTJp
         ce4ejmJF8bJ/iBRr5Tt1kzDeFc+5UTuH8xgFNM7eUrGsHIV7FTcSszyNP7URMTHf6m29
         QBgw==
X-Gm-Message-State: ACrzQf3o3XruaNezBaB98aZJ8lcqn08JwASs8XDwkX3lwZfbtpEABArE
        Oc90FXH9fzzjb9o6IcunHk6YieOQe8soP11DNTI=
X-Google-Smtp-Source: AMsMyM7pI18744S9haW110tnzjv64uYfAZKpKwg2l6yQcpCsenRqBQtleq2pJ+IyJezc1fWb1beNs0zjn4SOWzmy7Z4=
X-Received: by 2002:ab0:6f93:0:b0:3d7:b9af:39d4 with SMTP id
 f19-20020ab06f93000000b003d7b9af39d4mr10542721uav.84.1666322673221; Thu, 20
 Oct 2022 20:24:33 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 20 Oct 2022 22:24:22 -0500
Message-ID: <CAH2r5muLCRn1O31yCJ=pemuYBY5JpW3NhOBeRpDDE5=-jcLLpQ@mail.gmail.com>
Subject: new statx extensions
To:     Eric Biggers <ebiggers@google.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I saw this patch series relating to exposing DIO alignment information
mentioned in lwn today

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=825cf206ed51

Do you have any ideas of whether any network filesystem could support
this?  There are lots of features about the server filesystem and
preferred i/o sizes etc. that can be sent over the protocol (for
SMB3.1.1).

Looking at 6.1-rc1 - it looks like this was mainly for xfs and ext4
but is there any reason that it would be beneficial for cifs.ko - and
if so is there more clarification on what information would be needed
from the server to set this value?



--
Thanks,

Steve
