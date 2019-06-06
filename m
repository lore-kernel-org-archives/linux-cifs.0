Return-Path: <SRS0=Xphx=UF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D1DC28CC5
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jun 2019 00:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 231F420717
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jun 2019 00:34:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rLvQQFVb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfFFAeJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jun 2019 20:34:09 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:41227 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFFAeJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jun 2019 20:34:09 -0400
Received: by mail-pl1-f176.google.com with SMTP id s24so175527plr.8
        for <linux-cifs@vger.kernel.org>; Wed, 05 Jun 2019 17:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ZLVIiajD+Swm9UGmZME/plasB16//2ZoZ1LZSXig8qA=;
        b=rLvQQFVbub11XTUWIncSgPvtJYnCp2fNSdKJAZ/tyAU2EVlGhk8T9qBSeEWHqzSbGy
         h3UUWw6OPfegzXzcrpRhKtVeVs3rz7o3SJuca7UfS8hA5soe9qCc+HEtcGJ0Ty/hGFb5
         WPg1H0CFejIONOjkMLwCER0ZuMIkVghwTjvVmm2yHFqRckQ1WH5EunsLAdLzJMWFrziP
         D+cMgdUXdqJQ82cx+WpJxWwapJmytW7sJQxLMhc/XmQ/5UyOnam7o2Tzdx/9ZWSjsgs7
         LZA0+RxC/1gM3cvox8plgQIup5w3AQ7ZfO9NiBmc5Juh9a3XRierFII99Zqj+Skx2xP2
         1LCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ZLVIiajD+Swm9UGmZME/plasB16//2ZoZ1LZSXig8qA=;
        b=USIUS5bwualXmIQkHjsHSbmXHK8fzp8HriDQXr5zMqmYVtdOSKEN9Hsk6KLUOUNaud
         hleTrSRIen4sH5Y5K2QedfJli0H0ETHRCc9NFaibBi3Ey7WgjIvQQzPOEk1XuGAtx+2J
         SS+raYCleZXKuu/47OwGngtFzeSC5pyy3+D4Hw1uqd4N1JWxOskLuUMKFDKjLqDPhwDb
         RyQ1I9VWMhZCI7hhuf5xXDiXjuQl3GaTXKIyYUsWYOF+PeENkHDzB9v8I7zzUhwIq2K8
         qeoN+ptxWcfBoWTLMsEl1DIwxg2Oqez/NKzQr0OXRPsy2ICc2SwFUZSR5j0DBi7FgNTp
         mITQ==
X-Gm-Message-State: APjAAAXnhzCOKSoF/iQmBmC/5wDPtP+4PtKHGakAck5v6bvna4uAqTh2
        qIKd8NLj8q+Wbu5ToO1foNmkfb5vi0r44ei3oMrp+lGm
X-Google-Smtp-Source: APXvYqzLG1MvYn9Rj/HnOfH6zsRIBxOSwigINLZI3jhJCLL6ZCrbYEoVbjRqEig02Gp/lJ6Px+EKQi+h2QthJnmqSWw=
X-Received: by 2002:a17:902:2a68:: with SMTP id i95mr48080052plb.167.1559781248477;
 Wed, 05 Jun 2019 17:34:08 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 5 Jun 2019 19:33:57 -0500
Message-ID: <CAH2r5mug=QUeFCOv=VqUVc4WruFmwenC-1PXixz0Q8e7cCK1Eg@mail.gmail.com>
Subject: match_server broken
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When we check to see if a 2nd mount matches an existing server we have
a bug in match_server - we compare the prenegotiate ops with the
postnegotiate ops which causes us to incorrectly assume that the
server's do not match when we are not specifying "vers=" on mount (ie
multidialect negotiate will always cause a 2nd socket to be opened on
a second mount to the same server unless you specify a vers=)

-- 
Thanks,

Steve
