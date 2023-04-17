Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5DFC77B76
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Apr 2023 19:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjDQTIg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Apr 2023 15:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjDQTIf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Apr 2023 15:08:35 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB111703
        for <linux-cifs@vger.kernel.org>; Mon, 17 Apr 2023 12:08:34 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id d8-20020a05600c3ac800b003ee6e324b19so13599499wms.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Apr 2023 12:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681758512; x=1684350512;
        h=content-transfer-encoding:mime-version:user-agent:date:to:from
         :subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uzQZYyB4F+c83lix99B24YydPixm3qL1Ph/IA8QKuyI=;
        b=LEyUALzYWafzht/vC87j+RnSzbN6nvgPI09F6piKYgLTNDr/RJmBdSAj3XWMaAWuCA
         cB0Cp0v2nvEX56ZpGEIgm4hfFqWRGJy0LTXf1A+zZQNmfKXbtjgmvWf9GHHggfsKZOjy
         ydVTOEetNf5YCN1bZQPZcnaY57bE6YjyUHApnikMoKhPLUdpKx9qwFHdODr6X7gFdpfR
         J6PjVHNG48clGx3jggc2RS70AY3Ej5C7gmBqtk4rjIG8LkjrjGfL2bjeOtZr2VFPJ3kp
         XXQU1gFbvp83K23pU6xVkgkG8fzQihqG4MK/Q0/aICg9MiGGM0slklD1zGPpInJfmPE/
         vnwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758512; x=1684350512;
        h=content-transfer-encoding:mime-version:user-agent:date:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzQZYyB4F+c83lix99B24YydPixm3qL1Ph/IA8QKuyI=;
        b=epdigTcW++4iYvjFsBVFDohuS9xDg3+efMDSY4bwQYsfhlLZpNf0LvT9yvmc8h0+GY
         CJ/xTjjlqjNXWePXTKfFzuWDf02QMRz3QEM88DBI2GsWjTBf6vfv8BbEMTZHhtqZ5b20
         er+dpXVB6QvcE0nB5s99vee+oOnReaqxi6xgpZHpEyRRhAShKhoTdvv/qwhy9Hxim8We
         VccizfauPexppsLKKp/Hb8RQwhkhSn+AhrgFPwvYSg1krnl0ZLOtWcBWl1y9uglSGoMF
         TBvjGYSmQgfxZBjDGQotcuvG/IfNl7YfxMShpibnQtjZEld1eckLU8UtDgDRaZaMhd5l
         VE6g==
X-Gm-Message-State: AAQBX9diNhg+fXEt0PpXoPTsanWR24lW4BjuqZ6BaMXoKATH6MVHCB03
        qeeMNI2sEALa4G1vFZU8EkeQRHiUkfy9vg==
X-Google-Smtp-Source: AKy350Zl/nKwX6PgLJeeK5wYb5iTCHkFWD42c70zzkCNxhPbvrsruJ80A72N+cDxBAxw7BW/IbEc9w==
X-Received: by 2002:a1c:6a10:0:b0:3f1:7316:6f4 with SMTP id f16-20020a1c6a10000000b003f1731606f4mr3636454wmc.20.1681758512444;
        Mon, 17 Apr 2023 12:08:32 -0700 (PDT)
Received: from [192.168.43.156] ([5.171.195.91])
        by smtp.gmail.com with ESMTPSA id c9-20020a05600c0a4900b003ee6aa4e6a9sm16636168wmq.5.2023.04.17.12.08.31
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 12:08:32 -0700 (PDT)
Message-ID: <82da2a3dc9704b2cecb51f00e93092c22a309a6d.camel@gmail.com>
Subject: informazione
From:   cristiano forestan <cristiano.forestan@gmail.com>
To:     linux-cifs@vger.kernel.org
Date:   Mon, 17 Apr 2023 21:08:30 +0200
Content-Type: text/plain
User-Agent: Evolution 3.38.3-1+deb11u1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

come posso iniziare usare samba per metterci file?

