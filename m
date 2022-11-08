Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A8CC4332F
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Nov 2022 00:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiKHAp6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Nov 2022 19:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiKHAp6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Nov 2022 19:45:58 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D0020BC6
        for <linux-cifs@vger.kernel.org>; Mon,  7 Nov 2022 16:45:52 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id a15so18823402ljb.7
        for <linux-cifs@vger.kernel.org>; Mon, 07 Nov 2022 16:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XHHgdMe4feIszYMppdCPgQObrblKNWDiQjxYle8RSks=;
        b=h4XLxXH8Yhp2IyB86fiD6frLrGkd8Y/i2XqTJ1mCnnOaVTHsm0K4mjV9YHK7K8e66p
         uQv5drfMdAXscM5VFgcCO/t+SzMTy3acy4RpTllUpVRF1i28npyJyB/MqqC6s5SYBWAY
         BDfIu4/Rs6BjZ0qn4IMMo8/L0vRwaLAxBlNDXZswIC7q49UEX47Ry3lQJHyS9+/mKcu/
         053hdhDTuPuK/KwgRZrchqvftt90xT41kuSpgRuK/nif1gRdxARiCS7t4Bcc0ncJ/BRK
         0uKhXDK+B2nYI1x2gWtsbFS+IpBshmVgVnUafmacBD3o3VChD/GQ3Az4kyanknLCk1Xg
         LwxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XHHgdMe4feIszYMppdCPgQObrblKNWDiQjxYle8RSks=;
        b=Q0NuQjY0Bc1c1MY+nhAj/BpDoAatZlT2YeqdSWf01Lbx7DsX7k17QJzVHybKTVqYFx
         rYLqvwoVf29O0l9rgh+Ky/eIhV3OlJahZ5e5iNTOh4vK5+uAmlRh1NVgD+/C2gC68yQD
         kiazVuK0pStFRBSHkRHYZiENxBua3wldcAW+TuQq3Df/cXUNAt+QrkbW9xZzB1JR2ewg
         iOjMSDLBiypkMCKq6HHGrc+G/Sc73IXRM0UDyRcAvepPKlHzUC3j4mXLX19SANzUjtJr
         pgDahz0qUrulc06bFBsusgEc2Ukgw6LK3uzEeomDGQc+FgfFjD7a7tx9PzDi9iKqm8wX
         Bo0w==
X-Gm-Message-State: ACrzQf3eEqdhIOWhIEdaQ52y2EzoSWSv5bCWNe+d3+59mEJcZ/fVzKSh
        COwIpUOl2Ck4t79dWycUPqbZbuy28LEyBvyCCFvVgMpL
X-Google-Smtp-Source: AMsMyM7tU9tdzvaaGDXNitVJ6s/eVgDrkDEuRsiIGYgVCfFiX1+FC11549zOmgJ0fi80wmPJf33QqvyV5h9XUvBvGTA=
X-Received: by 2002:a2e:9bcc:0:b0:277:f0f:927e with SMTP id
 w12-20020a2e9bcc000000b002770f0f927emr6356995ljj.138.1667868350504; Mon, 07
 Nov 2022 16:45:50 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 7 Nov 2022 18:45:38 -0600
Message-ID: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
Subject: reflink support and Samba running over XFS
To:     samba-technical <samba-technical@lists.samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I noticed that reflink (FSCTL_DUPLICATE_EXTENTS) is not supported on
Samba when run over XFS but is with the vfs_btrfs.

I can do reflink locally on the XFS mount point, but not remotely
unless it is BTRFS (or to Windows eg. when the share is on REFS).

Any idea if there is a way to enable reflink (FSCTL_DUPLICATE_EXTENT)
support for Samba when not running on btrfs (e.g. on xfs)?

duplicate extents is needed for various Linux client features
(especially various fallocate operations)

-- 
Thanks,

Steve
