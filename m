Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94884C3DA66
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Aug 2023 13:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjHYNJK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Aug 2023 09:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236426AbjHYNI7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Aug 2023 09:08:59 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869B31BE2
        for <linux-cifs@vger.kernel.org>; Fri, 25 Aug 2023 06:08:57 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2bccda76fb1so13478021fa.2
        for <linux-cifs@vger.kernel.org>; Fri, 25 Aug 2023 06:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692968936; x=1693573736;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s7eqMtZG/296WN2nIurn7rT0RVX+f6NXe5PLdqXMKek=;
        b=Miq8VtVLUy14+dE1LAFRtOORRmRipjz3fvLr3+j9EvIqhXPj1/BTndaR9ZOnMLonKv
         08N6D29iVVfMerIwK+/vSs6o0iWzoKsMaxl7JPvLrKe5/c4UvwUlqtZoLKZ8vyqgLCXN
         ExOOt/PvAU3FU3CjrAJwoQ4XDA52+/LJ2ucpUwpTeiy/i96fY0m3Vr7BTzGKBAV5qJko
         pQ4mbVCYZIACDglH3cP+jKKISQc6Rr54UqUcuiYfvv9FCCic7bfz0k2m/3GUTz3Rol/K
         NkY/tdST7nnTcQg+Da1KMPkI6wSHSWs6nd800+2Fg7ZP84uk9RFKIOX5GF9ORLQnKubp
         sY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692968936; x=1693573736;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s7eqMtZG/296WN2nIurn7rT0RVX+f6NXe5PLdqXMKek=;
        b=lfclcbLOg4PnFpsVdVoFYOBHEiHUnsg1B34WA5svSN/w3KeqLtNMXywsO8F+vmtCpa
         7AJ5/167+u63PehF5X0lDpJZKDkciKW4+xJCCULdO/S1VR/ZKV39YUFz930jq8gZ0xSx
         MNUdmFD43yhykLtTofWoNwRvxSmkffb/m/b2qWyn6RWtCpVXL05qkJUPQ55pZjM7GTpY
         QDs9Fb3o31TcHUoGdfY62KWIPjue3jxrb4PLIPefLiRb4hiG6mon2b0Tpilkm3A1C4x/
         vEvfsQ80lFWBwVuWkM/lcF0AEhKFQPIPF7IYibWLZ3mOqnWO0CM+0YJZr5mPeczQkoOR
         39Fg==
X-Gm-Message-State: AOJu0Yz6XzK4S0OufMgOA+o0OgyMdFHHHGJYI/hcA6c8YV7qEz+goP5+
        xfyfHfod/Wk6qAqHPiPptlqq30tx4XgkuOUAKHSRnTe546ecqg==
X-Google-Smtp-Source: AGHT+IHIkSCRG3ISQkWAaNFr7vfkxLqZjZAZxW4nMhlNNrCuqkAEvASjyhm92G1dalqRbv6k4KvYAEMHQB+/a6ttyFE=
X-Received: by 2002:a2e:8717:0:b0:2bc:c11c:4471 with SMTP id
 m23-20020a2e8717000000b002bcc11c4471mr11749354lji.21.1692968935350; Fri, 25
 Aug 2023 06:08:55 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 25 Aug 2023 08:08:44 -0500
Message-ID: <CAH2r5mviQ_UEwqwvaz33dgZwzsqJxYT-xXccNmjW-GvuYokgbA@mail.gmail.com>
Subject: SMB3.1.1 QUIC mounts from Linux kernel
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Xin Long,
I am very interested in trying out LInux kernel SMB3.1.1 mounts using
QUIC but wasn't sure how far along your kernel code was.   Do you have
an update on it?   There was at least one other server type that
implements SMB3.1.1 over QUIC, but probably easiest to test to Windows
server (e.g. in Azure).

The SMB3.1.1 changes are small to support QUIC, and I could do those
(or review yours if you have already done it).

-- 
Thanks,

Steve
