Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBCFC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 03:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00364613D3
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 03:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244032AbhI2Dz4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239845AbhI2Dzz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Sep 2021 23:55:55 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EBBC06161C;
        Tue, 28 Sep 2021 20:54:15 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id b20so5096878lfv.3;
        Tue, 28 Sep 2021 20:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/p6DGmnC7B0nWD9+vlgj0QVMsJ4q8uTVTskxGseDyEI=;
        b=DQKEchpuEgrr0m9GIPyBIZZJb7OreDvHtj4IRDcszBVgwMRa9fj6xXeUw+l+pUB3Xb
         RbfFq16hoTsRTw476ryh/gD4nUKfaosFupj/zEPUcoK/geh1+Ior0CRcix78o63G2Xlz
         KByRYxar13m9i/XTbvOiGByjzzc3yMh5PAW0IGHFKK1xZ0OmRt+D3/daOGuG8iUR2FF5
         dxAQs3M1Z2FjBWTaq2X2BN0Gw7owrB8WGxKFrIh5Ya6Pqz0FHfh5vr7wulILUuSwwaGT
         5x1X3I+r6pYi/ioxGWcqFICSPnOb7GvnFIc6964Xbf5eWjTXdUDRhiY74DoNonB3DUt/
         2v/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/p6DGmnC7B0nWD9+vlgj0QVMsJ4q8uTVTskxGseDyEI=;
        b=uJK9lU2AUVHNq4gfVuW43yydqizovZQJOyUbAu39UK68zGD2EW+wCDCaiIh/AGMq3l
         L4tPB4cz+GOXSftU6bHXO9RdqaV/2nvGY73sy0WIDxUlcJjK9sZVJ92OnROT7xe2nODb
         1jQzq7vPMijh/TCv9r272wKqr94X5moCoJQioOIwpcoB/OgEH6BVCZbu4o09Xaur4lRh
         qyyLCJnEJQFPHFZh4pJbXnk904TEJtDMqAf6S1yKNTezsaYhr2mxSMnLC1KghZhZ/FPV
         hwzUJDr/a7tRLjYLqWL8ZsfTKZ3unrPI9c51ZI5MZC89v8ZmKB8npxFgXVKHg1dAKzR4
         5Qtw==
X-Gm-Message-State: AOAM5313EcCF6Ebn+147nnQupV+kUq3KIzdgQ7lgt9y/KkCt3He2lry4
        QqyIQwsHZ6Ue330XHvHsCJ8lKmDWEowNkWY5jzM=
X-Google-Smtp-Source: ABdhPJwakKU+DVlfOB/GlGLsAIc3BTBvu7tf98MJiucp+U52Tqx0EmdnvCyePRKZLuuOcd6hSH+zFZjzdw7/iz4jBUM=
X-Received: by 2002:a2e:1548:: with SMTP id 8mr3800257ljv.229.1632887653293;
 Tue, 28 Sep 2021 20:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210928225634.28432-1-ematsumiya@suse.de> <CAKYAXd82wCtdNOSzPu7LaivkGVga5QoXcHsU-z5KEGDd8R+o2A@mail.gmail.com>
In-Reply-To: <CAKYAXd82wCtdNOSzPu7LaivkGVga5QoXcHsU-z5KEGDd8R+o2A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 28 Sep 2021 22:54:02 -0500
Message-ID: <CAH2r5muxv7XyGQAERuYAk=6TxYJVs_Lj+G0pmuiGr5HwDiUNAQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix documentation for 2 functions
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifsd-for-next

On Tue, Sep 28, 2021 at 7:10 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2021-09-29 7:56 GMT+09:00, Enzo Matsumiya <ematsumiya@suse.de>:
> > ksmbd_kthread_fn() and create_socket() returns 0 or error code, and not
> > task_struct/ERR_PTR.
> >
> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>
> Thanks for your patch!



-- 
Thanks,

Steve
