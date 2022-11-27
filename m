Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E34C4321E
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Nov 2022 00:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiK0AcH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 26 Nov 2022 19:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiK0AcH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 26 Nov 2022 19:32:07 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6535B17E30
        for <linux-cifs@vger.kernel.org>; Sat, 26 Nov 2022 16:32:06 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id e15so1410592ljl.7
        for <linux-cifs@vger.kernel.org>; Sat, 26 Nov 2022 16:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hjCK41hw6fHxQbWxeiZocKCVh7+/3o4BeimACMr1yh4=;
        b=caJjfIbIiaYwjHRY+w0aKbZlZXAxvdTr0Ho6/3zqR737bjRAYMN1mdSignKvgr7DCp
         HkqgIg3nS9hknWBoAbXwu/K73tmR0pShYAZ2YNpe/8mtr9WVbbW+zJmVz7GMWJldkgf/
         yGcvg+aRd68RmHdybMRNsCuB/zSuRl/K9ChTmaYU2K+I8ES7tGQJx5sXTCKVCArURslS
         tuXQUpqsp1n6td08GTiwWIfjAKy74s7TCxe/LP2eWExAheh1cqOTtW6UGa1GS4Hp7U21
         VJh/o44so/ZO9YQlu2e3xHmkyz3xeq8dWasY/I1D1wOtmAqF+2zZ0c79iEhrEAr9654p
         A+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hjCK41hw6fHxQbWxeiZocKCVh7+/3o4BeimACMr1yh4=;
        b=35+5peI6/jwenlMxRTimv2AXLNhGCCwYkiQLBsCXZRNnP2UopNETL3oh5aqJRU6Men
         5iRj5LfwCgy6U0xl9uEB9vjaQ/bejjyLjOuB/PruGREVtdVMvaLhJu5VNqQUhCXqtU7k
         NG8aUENtzQicPgC4pjLnIvuE66Ty75Zg5t0C7T/FmyKROrMsd08ifC8EdsL2uNm2WzbP
         3x3Yg8DVCFMYeLDcKXCFrQJO8/CEgQqxMJLjotkiSaAFezJUrk+Ax27mT7OmZcPdeK1+
         8ttU+iUIBoDyEMDCB/UMCGS9AJFWv69tqdgiNEupChb81xJxcxfyXlnftODvIYItvF3n
         tjOA==
X-Gm-Message-State: ANoB5pkJ1TBW14MJyWaQlnhmYwu3ak4MJQEnS/LgZAe0k/U8BwaP5ArN
        CblXP7u2V8Kpxt3okDM4FPiZ2EP6KOASwMKKciecSNNDjUY=
X-Google-Smtp-Source: AA0mqf5jfh7KS/0pkAt0gIBdBtNmx8SuoP+8bRdvShs/4txjsMxpeE/JWb9DRhExuYNHbkC0E9cd6bIW0w3wElR7jKY=
X-Received: by 2002:a05:651c:894:b0:277:3e1:297c with SMTP id
 d20-20020a05651c089400b0027703e1297cmr10459927ljq.109.1669509124390; Sat, 26
 Nov 2022 16:32:04 -0800 (PST)
MIME-Version: 1.0
References: <Y4DJ2o6w+SxIH7Yl@sernet.de>
In-Reply-To: <Y4DJ2o6w+SxIH7Yl@sernet.de>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 26 Nov 2022 18:31:51 -0600
Message-ID: <CAH2r5mscUWuAbsSjw1DOFT=yG3dDZhcmCtAVLNhoH-5hrby-tg@mail.gmail.com>
Subject: Re: Parse owner and group sids from smb311 posix extension qfileinfo call
To:     Volker.Lendecke@sernet.de
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like this does help the group information returned by stat, but
will need to make it easier to translate the owner sid to UID (GID was
an easier mapping since gid was returned as "S-1-22-"... but SID for
uid owner has to be looked up)

On Fri, Nov 25, 2022 at 8:19 AM Volker Lendecke
<Volker.Lendecke@sernet.de> wrote:
>
> Hi!
>
> Attached find a patch that aligns "stat /mnt/file"'s owner and group
> info with the readdir call.
>
> Fixes a TODO from 6a5f6592a0b60.
>
> Volker



-- 
Thanks,

Steve
