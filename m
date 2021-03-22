Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303C0C433C1
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 20:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00EC361992
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 20:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCVUl3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Mar 2021 16:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhCVUlD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Mar 2021 16:41:03 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDE4C061574
        for <linux-cifs@vger.kernel.org>; Mon, 22 Mar 2021 13:41:02 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id a1so22802222ljp.2
        for <linux-cifs@vger.kernel.org>; Mon, 22 Mar 2021 13:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=HewuPpOxkdLcnnFrjkOEFBj/Hl2Wcca0LcoZKP0PLDs=;
        b=c0OD2UFaAxDtrDFIY+8zdcnC5RJswAYNIzSWV8bpNV5i3PjIGOCM9W/FLw5UTmC/jG
         Cr7evsdGIXcqsDF+SGKjpTDVRorN3BDBgkKd1Ht5iVuCz/cGdnyVE8EKGVqgPGKvaE/z
         9ldH2PO9ZStNwDUIRNyb89Xd1Dblfsyy6Hs9kl8Dd1oqf9UFmNE55wtDmYfX/GcXLKcM
         +23eO5nGwrZgQgoq7vu03MUDdNIpoxc3YxZtua5OcieD1DtGbvrylgVlUIs4W/tivh4b
         N3kmP0Qz4kZJd3EOFLDnmeTmcEFbKv+dcZFzNR5sYCS39HPD5NU78BLORqtwWbM2FV5l
         f8gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=HewuPpOxkdLcnnFrjkOEFBj/Hl2Wcca0LcoZKP0PLDs=;
        b=WVxjjc62S+KnQEMrEwdghLTkWio+EbY/xXjH7skWtQua7nNq/EQdOGgZ+DXbVSV24P
         7Ph0Dgmr2v0F4GxAPr4zqx6o0D7PiV3laaNSeDvBvQmonDI7Ez57Njo45CXO01e2OGMs
         sbBCqeIJaF26VHxjKR96WMg/8nKrnTcAc1MNH07GXCiGO2DpG2zyUlyDz5U4pxyn3q/A
         vzScDZc7MCrj1DLVYsStPabrGsralZpeaZKuDeexsAe9svLOKCWR4kS7PuYXhadhVLJ2
         eqil91b2aohUAaK2rUv9E/Xu1QZt7qCAj0q3OuBplnGKhpQXEkUG62r7pDOmtFNhYC2i
         zpSA==
X-Gm-Message-State: AOAM531zwi4DpjczgcSQO73pgVhbc2G1y26RygQojTMrNiICeRAU/zUb
        +o4waVz08nn5rRNaIvtMmNzua7w8vAhhZkRVTNo=
X-Google-Smtp-Source: ABdhPJxlWyLJqdnrLjWPNC1tImykjox8nv480vON5kbxS22L5jgedujYFjFBncLJm8ii1XJPlKq0XT+JreKsFkEFTJI=
X-Received: by 2002:a2e:1612:: with SMTP id w18mr850079ljd.6.1616445660614;
 Mon, 22 Mar 2021 13:41:00 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 22 Mar 2021 15:40:49 -0500
Message-ID: <CAH2r5muFSCWQUVn+iuZ_8fiWrCXtNmO0+AaEEEqFmD9+qj8-1w@mail.gmail.com>
Subject: ksmbd wiki page
To:     linux-cifsd-devel@lists.sourceforge.net,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Did some updates for the wiki page for ksmbd (cifsd)

https://wiki.samba.org/index.php/Linux_Kernel_Server

-- 
Thanks,

Steve
