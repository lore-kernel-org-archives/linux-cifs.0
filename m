Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039E9C4332F
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Nov 2022 16:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiKHQeF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Nov 2022 11:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiKHQeE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Nov 2022 11:34:04 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C644B1006F
        for <linux-cifs@vger.kernel.org>; Tue,  8 Nov 2022 08:34:03 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id s24so21915102ljs.11
        for <linux-cifs@vger.kernel.org>; Tue, 08 Nov 2022 08:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q1nSFzssGURAQuJbSrXDLQeV7iClBMclGOq8915uKLU=;
        b=FbmJs7zgiY1+xtqRGEloYQD8fp9wj/kCSvkFNU859ozy63U8ijYKitPBob1/ZG4cmw
         Bf5zFKK58OppUWFtQxkQJ0nUZGrZlzIYhXAiQPj37+Qqxr+N15SPToYwXI/56PXlO1oL
         l5lDzMtrqMJpO78OHHrnBnaMnXdcqpI60UBdCVU9Q/pMij15bgCmU+Z0JpDOl7ZL/cvm
         JmRCVOLAIY81+DbX+HS2rzC239m1r1vkEL0CWT9wDAUy/ncSsaIwnfqymTWYZo9sB2Ky
         NCHq49sg1D3xqLIQy39qc6zdWq3Rn8joUDz3w/3xOaXW60OgAZmlyUy/cSreJAVHpWb5
         7xkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q1nSFzssGURAQuJbSrXDLQeV7iClBMclGOq8915uKLU=;
        b=qAzpSrjY4nZNx/TMYPiNo94qdF/XW8Dbx87FcZtLRhl7UBMsq5Y4nX0j+njJun2TrG
         DGCk118RFlP3MdDWv1Mvgz09qDl+aSnPmrFIg32xAIy7WWNNGwW48odwnFKyLZkd3kIz
         yPq5MxjUvD4f1E8tmj5ZYPdMy7mlO9K20T6M1kxnd4w++wd6Ip1aiL6YP+/oJxz230dz
         +SDvkyQafgUNj6rejRQY7KHftNCljb8uuZjm8bMlLqFk9Ef4wSm6mwmiD1XOUa4oBp9I
         cQLJxPfSK2I4aNeLim72l3lit/zrBymDUppVPb8qD12QESCoVFrJZCZ1Gd8otljcniXR
         eyEQ==
X-Gm-Message-State: ACrzQf364XcOxYGRf+exZarEBq9GEWWcDP/czxnDztWz8WVaKcT79o7d
        mapjsnbDgcvhoXYaTu+E9LaeqQwFE1ymG2gO34c=
X-Google-Smtp-Source: AMsMyM7cFsBY5gs8LJ2AH94pmQj62hZ4PgEwIEsWDH6vCOggcaDlx42kWkcBnKjP6msbZc+a5/0HpZEeujqwF0jt6VY=
X-Received: by 2002:a2e:8541:0:b0:261:b44b:1a8b with SMTP id
 u1-20020a2e8541000000b00261b44b1a8bmr20717380ljj.46.1667925241931; Tue, 08
 Nov 2022 08:34:01 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 8 Nov 2022 22:03:50 +0530
Message-ID: <CANT5p=pW_CMrD4EacJnwKGK74nW1sRxa2ummheWxujwXtfh0cA@mail.gmail.com>
Subject: [PATCH] cifs: avoid reconnect race in setting session and tcon status
To:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>,
        Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Came across a couple of race conditions between cifsd and i/o threads.
Fixed them here. Please review the changes.

This change should also ensure that binding session requests do not
race with the primary session request.

https://github.com/sprasad-microsoft/smb3-kernel-client/commit/c4ed4d985488640469acfc621bed5c3a55d67ac6.patch

-- 
Regards,
Shyam
