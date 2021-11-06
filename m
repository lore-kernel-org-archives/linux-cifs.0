Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12929C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Nov 2021 11:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B73611C4
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Nov 2021 11:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhKFL56 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Nov 2021 07:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhKFL55 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Nov 2021 07:57:57 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD11C061570
        for <linux-cifs@vger.kernel.org>; Sat,  6 Nov 2021 04:55:16 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w1so42640692edd.10
        for <linux-cifs@vger.kernel.org>; Sat, 06 Nov 2021 04:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=vSrx0dvuIcKYOMhyU6KFCSDtGQGT2XCk3kKizOIRGQs=;
        b=G9YdEjvl429mfPTVOZyhBNJVFR2+tGYwEg+9/7vyhBixesu+xUQt256R32l8uJ6TXG
         ccNg9mt/jtlHQwW1sxcxqTKwuAGTDwORg4qZJLspO+lFCbpzxfo9R49ZLbtc/OlO8Yb8
         dWwYeYVnRAOX027eijk/AK8VWlvvlm9MCmS/zpf6MCd4yZEySESdJ+F41y83XzvmMKj+
         hBX/ZZVJQnUMdctVbnvd12hUKGgoUXJ8fxrhn3CU6ZXEMtOc17ZQyfzsO4xP9eY2eqzY
         OLYNsveJmY7HwVrbAi3p52DTBzzNVM3gZM5rjmN6/i0n+q8+zPUTVjdTRoc0Af/nj8JZ
         8oEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vSrx0dvuIcKYOMhyU6KFCSDtGQGT2XCk3kKizOIRGQs=;
        b=tkaBlra9M7pi+TrCZYmDos+XiaHxMS0cvRcm1ybtT3QfSBuclXdxpIu0mG+7Gl617O
         pYcfeelia5vmDSjKT8creeuWWe48loZhcpMCg2H7NiibDciatbxo9IniAdjXjylmRepU
         CoHIr7SAQTNjGOIRb1VpSQCmBaKu4dF6NFhb76bbZwFb9YLeIewhoHFXsIrkzIJ5Fshs
         Jp5NdWCyPTuJ0nakY7rnyMSTo74tKX9lEy5HXqDZx8GA7/568ugnLsSWeMz85ExpPacq
         C16tui/i6ztNnE0/ioN2ehOCLXxK53fQ8kNqYdpaKuwZklzajNGBV/vT4hKqwW+xl5X/
         EoiA==
X-Gm-Message-State: AOAM530uPRQkJvtwSEoG718vEp2DxBlaoYmkf8sbIiAjlfLOLPmQducP
        QOva7C+vV9gSBxny7gi/yET4+tLTQxyJKXYkWEU=
X-Google-Smtp-Source: ABdhPJyO8FPcULglku4sCGXCmrO1wKLh1H2sz9divZqcYBcSjwj4s9eQwNCPmludtHWzLomaK0C57oVPPaX+xnSv35Q=
X-Received: by 2002:a17:906:180a:: with SMTP id v10mr79413828eje.112.1636199715073;
 Sat, 06 Nov 2021 04:55:15 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 6 Nov 2021 17:25:03 +0530
Message-ID: <CANT5p=rw6OqPgPcgRQRk-ujM43x7j_Rw7c97z6Lk4Tpb=vL1VQ@mail.gmail.com>
Subject: [PATCH] cifs: nosharesock should not share socket with future sessions
To:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        rohiths msft <rohiths.msft@gmail.com>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Please consider this fix for CC stable. This will be important for
Azure workloads.

https://github.com/sprasad-microsoft/smb3-kernel-client/commit/8f7a939555d6df2255b89d403ba5a30218852568.patch

-- 
Regards,
Shyam
