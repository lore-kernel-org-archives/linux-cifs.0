Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E296C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jun 2022 10:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiFFKbs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jun 2022 06:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiFFKbr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Jun 2022 06:31:47 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE2A1E3E1
        for <linux-cifs@vger.kernel.org>; Mon,  6 Jun 2022 03:31:45 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id q1so28037932ejz.9
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jun 2022 03:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=OaocCN2lwX0qHxzmGr3olyZWpWErn49dOLHfvceslVE=;
        b=HpNTujsSkT8nYLuf2kBLLlq4RTIYy9dGfMRnXHhzuy4yP/GMce7ClQvsE0Y8SizOy2
         Q0MXoYtLhc2Dm0Iky0X0J3Jm+qQHMkY3DK83zOxA+2eHsTMz1Rm5vrOSfCTfPCE6y8TD
         MQFwkM/MbjhiaFQ0QSNoQnMKb/sBwBgzSr7BN4NfZxTE/wTPlOu8ULt05/VI4m2rT69y
         2z8GZtKVHOQE35p60sb0M5db0i/F7DRueEYewKc9Cxn77pgfPJMI8Zo6yuP1gvQP3Ble
         6oMnjR8Aq8xX3R/ajDrbGA7VUOxCRZSCHom+JRZUSsvYaex092XsDtbgSPA6rparYZmX
         IqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OaocCN2lwX0qHxzmGr3olyZWpWErn49dOLHfvceslVE=;
        b=kxaz9ENkZbZGJKD/TywFg+nTFCR7dQXOTFqEha/blIFjLQolhgudRnszC0Zcjbvzsg
         CwE5aHdlT4FaoFA0pteudEQ9Dm2YXFsH6HrVbmnsrSr5VZXGLpzXCPFkepsVpIcSg01a
         /2dLiBTUKr3qNNnuOQIueYqSoSFxYaTch8HppBhYWgdROK8eh3MUhsa7+nYJ9EogxRC4
         yuwLmQ9ILQvOtCTmo0mQN4gtLg1zQQX3pL1v2hf9uwx5/hZLc67s6GH/wUkJzChAYHH5
         y2xUz/Hr+Ly09P03OZX5m9P59oqEqlM8o5mECNhjxkgS+8pu+dWuDu+G/fWseJwcelzD
         RntQ==
X-Gm-Message-State: AOAM530HEkIwLBjlbGFt+34RhPL1qvTepQHEVlBOuSXGLN7Bi5fOLedn
        BiEvLZKofH+/HUKpzv8NXFTMh2UWk1p7nRoIvLK5TSXeDjk=
X-Google-Smtp-Source: ABdhPJwZTIFizBN2ZK0zryLwxFZKvGgjK60EOPlgJOMB5HhixOAW73hcGwNtYCyE9XiNBwBUs+CJVeXfYWjyEAChYts=
X-Received: by 2002:a17:907:2d8e:b0:6fe:b423:9693 with SMTP id
 gt14-20020a1709072d8e00b006feb4239693mr19899936ejc.698.1654511504262; Mon, 06
 Jun 2022 03:31:44 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 6 Jun 2022 16:01:33 +0530
Message-ID: <CANT5p=p24djme0_rDzVHTJAZWEqnQRQXkXFf6hNAaLORDp-MfQ@mail.gmail.com>
Subject: [PATCH] cifs: return errors during session setup during reconnects
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I think we discussed this fix in the past, but never got to actually fixing it.
It looks like we missed this validation for when negotiate went
through, but session setup failed. Please review this change.

https://github.com/sprasad-microsoft/smb3-kernel-client/commit/c0bad5b3c5eec5c612723b404e619cac4b370bb8.patch

-- 
Regards,
Shyam
