Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23AF3C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Mar 2022 20:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344609AbiCWUW2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Mar 2022 16:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344602AbiCWUW2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Mar 2022 16:22:28 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116F540A2A
        for <linux-cifs@vger.kernel.org>; Wed, 23 Mar 2022 13:20:58 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id b5so3442584ljf.13
        for <linux-cifs@vger.kernel.org>; Wed, 23 Mar 2022 13:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aHTl2xeuGkmRcpRa9prRGpKzt7CM9KmgJ3BEajkishc=;
        b=bR+h/GAy/Y7K+m7yStIx1SUaBScpljiGBt9YmO70PbZWXj720E3r/RmJ1tWTf1F76N
         7xxp6B/kbRMqOFRIM/73LzzlFzWbxDErjzZMcNUsEh+7eF9XV39i7bSFMUmENlFbhqeZ
         YY6Ag9Ejm+1DRthS8pzx90PArXZAUg/sSHkNXNg1v5qnK6s5SWGRcyNvE3Ma4kxFyzqp
         JbH+RZChkb6VgZYea0ZazAHbPWP+VR0ExSpx0y62fqWZY8gZh5o8T4DXSEgb84yd0OrM
         PTG5tPmAzBMzFGcTuWWlnqIatXff4HOSDq2WoelDa3qN/DuB36z9BAPaSY1pGq8Cxxwz
         JRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aHTl2xeuGkmRcpRa9prRGpKzt7CM9KmgJ3BEajkishc=;
        b=EC92NkvogJqC9Fg+JtKH0R0FM53YU+xibs+uBjNGa9WF7PvjJ8PyOvOkWbE9vnfSwe
         /W4jVtl2eDWyRvbj47qtwkiGUGI+H2d8lJrr8S3ZCLZtujmwk6pUAzvH4PU1voz0XHVu
         Y3mQQeRh+r5gn2zRygsQ6uLeb0WusuN/Cfxnh03M1OvVPMMYdThBPwE9UWa5Dbpb/B0b
         ik6Ne8lMWMDkRG+G1eiiqVrHLQ9MStaEXdrI/HFYgB0McSalDnP2ERYJL60sLi9M5wIv
         H2/VGOLM5h9+3CWYW5KtQd073YzHyXU9ZbT4PlEKvT1gTE/aIulyugizA8v0jvfcyM7c
         gJhw==
X-Gm-Message-State: AOAM531m6botftqPaT7sWUbS76z8K5FjJCXQBUB2lN6s0pbkilWnhc7A
        VE4dqUG4v/vUov8AD9Da0WsNo7fdxwkaAdifLUsSKHkT
X-Google-Smtp-Source: ABdhPJysMi/Vilbipc7XeKVnLAVMpxAW/Z288LGMhU3Jum8QJZmvVN3rvuAYinkqEi59KTBr9AVn2wT7j45kUiifJeU=
X-Received: by 2002:a2e:9048:0:b0:249:78bb:375e with SMTP id
 n8-20020a2e9048000000b0024978bb375emr1460844ljg.229.1648066855707; Wed, 23
 Mar 2022 13:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220322062903.849005-1-lsahlber@redhat.com> <20220322062903.849005-2-lsahlber@redhat.com>
 <87tuboitpm.fsf@cjr.nz>
In-Reply-To: <87tuboitpm.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 23 Mar 2022 15:20:44 -0500
Message-ID: <CAH2r5mtrCTo5x2NzG5aqmeFN9Y_hZxwhSw2HGD-7bWsOQftdjg@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: change smb2_query_info_compound to use a cached
 fid, if available
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

also fixed one minor typo in the patch (missing space)

On Wed, Mar 23, 2022 at 10:17 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
>
> > This will reduce the number of Open/Close we send on the wire and replace
> > a Open/GetInfo/Close compound with just a simple GetInfo request
> > IF we have a cached handle for the object.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/smb2ops.c | 45 +++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 35 insertions(+), 10 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
