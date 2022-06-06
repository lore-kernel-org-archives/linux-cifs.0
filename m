Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB635C43334
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jun 2022 10:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbiFFK1g (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jun 2022 06:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbiFFK1f (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Jun 2022 06:27:35 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8BA26AE6
        for <linux-cifs@vger.kernel.org>; Mon,  6 Jun 2022 03:27:20 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id er5so18147434edb.12
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jun 2022 03:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sl96IlMMhoAU+PngFbL7Zkn163e4epvFtovUJKzJJpo=;
        b=DUPuP2T6M63CPRXY2B8xIbVeImz1yPQNnYLfelAxYf8qmgXZ5H45voz/WaCvPdLCk0
         kk3BOqlbbqDnZHMpUSlPPzEu4mnrhM0N1+ZHt0UEep84sbAfMrxUmXYzldbdvkCYU4cw
         j9B6KAjZYjlZnmtoh4HbxaU/4hMZ+LJBkWJuUsM/1nnCJVefWwSLFn1LES1/6oXgwP01
         fKplO+guAn8hT8AVcn78m1UYTIoXOLp8EwvAvdKp11pYx1bfgxWMcflb8E9zueQBdpnS
         9ks9vC1jHMyEfMGyFHY9Ut9pnjsBN29XxCyjVk6MyXTkJUJT/l+ty4gSPXg9epw0WynT
         8KMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sl96IlMMhoAU+PngFbL7Zkn163e4epvFtovUJKzJJpo=;
        b=ffSSkiHoxyqYUma+PgiM8cXylCEQ1fVCXe8ZX4Rw+7KYiYYpfBdyjNbQTZne8kvT9F
         qOXMAni2I3G7V5JZqybAjsfyzXtv9tY2aFhe/wVGWnG3bNyX6By3occX4DXbMDpYAVIA
         4V9eniTdUkAWIhvv4sd4xeCo/gNCrtpOEOu01VsSvxBXfGLHEE/jC4LgFaUiPHQAgaTV
         bZ5W8Au05D1632Tfyv7t7wbKC+z8CNMDd6Bl90curp16NquItMw53CSlDr/sWUSicqnP
         aU6CE5LOWrekNS1RYlnTOv2tsAfW0T50xqGARGXHqwqm3x4LKziv1yWWNlEshGJvSMW3
         i39Q==
X-Gm-Message-State: AOAM532fRIfeAlktGluf2TxMLOAwtTpDCgCEdrZn6tJQtMFrFSl+oaAf
        juJLRTGMxBL39GuX1h0V+fkoIcKJpVBkgKTy/xI=
X-Google-Smtp-Source: ABdhPJxC7W5+l+3yWybU9AX3KLRyO/aKcO/HKNFnS6qxxD6jNCAvdlVBGZ8LwvufD6nxbI5oR4pWOoXjH6pojQ99EpQ=
X-Received: by 2002:a05:6402:1941:b0:413:2b7e:676e with SMTP id
 f1-20020a056402194100b004132b7e676emr26475915edz.114.1654511239343; Mon, 06
 Jun 2022 03:27:19 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pfEF91j3frZFJgxMLU6XmaC-pn=_oQnOF2BQPaj7Bh+Q@mail.gmail.com>
 <874k1m3b56.fsf@cjr.nz> <CANT5p=rRTWpBR6MKiXrMtH0r_PD_jKyLhUhM_Of_oev=7rybDA@mail.gmail.com>
In-Reply-To: <CANT5p=rRTWpBR6MKiXrMtH0r_PD_jKyLhUhM_Of_oev=7rybDA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 6 Jun 2022 15:57:07 +0530
Message-ID: <CANT5p=rw=JamyDwYby1VVgMXAANMCou_aMhcw0vB48gggDWJQQ@mail.gmail.com>
Subject: Re: Multichannel fixes
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 6, 2022 at 11:12 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Paulo,
>
> Sorry for the late reply.
> Good point. Tested basic DFS mounts. I was facing setup issues while
> setting up DFS for failover.
> Steve will be running the buildbot DFS tests anyway, which will
> contain DFS failover.
>
> On Thu, May 19, 2022 at 12:45 AM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> >
> > > This time, I've verified that it does not break the multiuser
> > > scenario. :)
> >
> > Thanks!  What about DFS failover scenario?  :-)
>
>
>
> --
> Regards,
> Shyam

More fixes for multichannel:

[PATCH] cifs: populate empty hostnames for extra channels
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/fb231a3e148e7537c899f4e145fc0dd876c2b195.patch

[PATCH] cifs: change iface_list from array to sorted linked list
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/94363021b50edb86813ae280526d7f33d6903703.patch

[PATCH] cifs: during reconnect, update interface if necessary
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/7610df44d276634a51155e6314ee159b7618013f.patch

[PATCH] cifs: periodically query network interfaces from server
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/7dad71410514232501f921a8c3ad389d3344fddb.patch

First one is a fix for ensuring that reconnect does not resolve extra
channels to possibly wrong IP address.
Rest three enable periodic query of server interfaces. This is
important for Azure service, where the server can change the IP
addresses of secondary channels.

Reviews will be appreciated.

-- 
Regards,
Shyam
