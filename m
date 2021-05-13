Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC58C433B4
	for <linux-cifs@archiver.kernel.org>; Thu, 13 May 2021 22:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99FC6613CD
	for <linux-cifs@archiver.kernel.org>; Thu, 13 May 2021 22:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhEMWug (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 May 2021 18:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhEMWuf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 May 2021 18:50:35 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568ECC061574
        for <linux-cifs@vger.kernel.org>; Thu, 13 May 2021 15:49:25 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id v5so35647111ljg.12
        for <linux-cifs@vger.kernel.org>; Thu, 13 May 2021 15:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=N7z84WrM7CHyGqLFlc48Pi/ZYJXZpcXBdv/wuq5XCFo=;
        b=ObpImCKwXrdP17c2Ml8dNoZeBjnq5WAILtv4+ga3cmPnGrfEFftCMN2iBPC5+/2oue
         PA+3B3pg4ccyW8aILpddiwiLUw58LJSnYVJMAAkxvFIEkeLXHP3Hc3JpQN//yW22KnjC
         Ow4jw4qhDY1sewE47YOIqqMG/7kNgrlZGIYOukUbVONs8X97mJK2g8Ge4yxieggjbjpy
         gYOXh1B9Sl92gUA/EhipLxbtRy96oVrphjl9iPI9AiDnvCYOLdqLytG3yrIz6y5ldrfk
         dgyCFX0b7Tx3bZqpJBzO7Rfp/B8fUedqc0ppBJUFx8x/6+T1wvXzEU57yLxP08Un3f1F
         9Wbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=N7z84WrM7CHyGqLFlc48Pi/ZYJXZpcXBdv/wuq5XCFo=;
        b=K3SHQTw3H7LlQ/yWgNBlIqXLhX9PwmY2MHVQpgE4dtcm2c6TlGJkBH4KuQGAtySRDz
         ONrui/RqHga3IzPtNhoYkmtumNTh14JMyWFvWT2kbpwJWTgJWmZU9S8PiNDj2WTevFlr
         USZ9qcs6CBnTZ5VyNn4CF9QQg3ZCoteYSLMLozm8xvvx+O2JpvFd4SycMtogRVUBjZX4
         yDe76uZ+0sET+WKHK9htBnH4enn63paUjrss/nPifqE6+wbSVj6SsCa9c+NEk9eDW7Le
         DsbQGORnjSAqd9OtD47dhjKIudV7S1ZGxInpsQhhvXnQOC+K5/57YzKoLx2TqaY9YhS3
         4G8w==
X-Gm-Message-State: AOAM531jnjukJ0vcmllaMAj8bcFMtL8MsRulkl8mlbiLtFfiRUpqFa6u
        1KcxLehucjxYRRRoe+4WbfP+eMh7yTq3ICThP4+l8qyC9ao=
X-Google-Smtp-Source: ABdhPJzCil8hCDGBFLyredOYJNHY7RP6f8rvIQhwMJVtlm1Phu16stRY/l+1wXPZesFfvmbyowXElw+2ZqLSYxE3SXs=
X-Received: by 2002:a2e:5042:: with SMTP id v2mr11013463ljd.256.1620946163662;
 Thu, 13 May 2021 15:49:23 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 13 May 2021 17:49:12 -0500
Message-ID: <CAH2r5mtxZx3RG4Z_b6-9bsaLBMAHObGas-yPe3rttj1tXcFtnA@mail.gmail.com>
Subject: Additional xfstests
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Did some experiments running more xfstests today, and we continue to
be improving - can now add significantly more (e.g. to Samba server
running on btrfs), 25+ tests that are now working in my quick tests
this afternoon.  That is in addition to the ones we have added over
the past few weeks.

051, 110, 111, 115, 116, 118, 119, 121, 139, 144, 163, 164, 165, 170,
183, 185, 188, 189, 190, 191, 194, 195, 196, 197, 201, 245 ... and
more



-- 
Thanks,

Steve
