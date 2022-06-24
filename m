Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DB6CCA486
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Jun 2022 14:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiFXOn1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Jun 2022 10:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbiFXOnM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Jun 2022 10:43:12 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE6A21814
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jun 2022 07:43:10 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id fd6so3789543edb.5
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jun 2022 07:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kePoNp+Y8Ql6yNgEgT6w6rvu3eKTQ/tSJEjFNfODfkU=;
        b=I6SKWc08zZjchV8D8dgdCwfMquQg3dp7/ToOLXhlkBQ+LJNLwuj00wEMMI89I6hlmE
         hAleVBqja3t54NmEONEHPkpVwQ2zyITFskMsgO6XKOS+sTvFfD8H6Fi4tEJ6FaHy/+i6
         ruqNJsfvDwJ/xRMx+pztj4FCS//DqhjyrMH/JOliQAqvnrawg2T59JiHX/EEfUArDH+D
         FGwUvp2rU1QscEsCnEU36rGh8W5ihtk1Te4ksOZIpyHAxpWxonL+Rfs465B0ETjgx/p5
         JMpHR28OmsT6WBMPnFZbirHiQKUfbf3r4V469tc35tabOpRQNvK79gnPuvmxWDC+fFMc
         Y8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kePoNp+Y8Ql6yNgEgT6w6rvu3eKTQ/tSJEjFNfODfkU=;
        b=lktEBNuVqatQGKH3R+8ICsjOOaRCV53NotTKHh0ekZhUj9Yh1VMwu8c2efenNCroew
         vEMd/+TMT8IJtsHcmU6mMeCQDbH5uofLEDG1Abp0/PRSEDeK+uHMX4FbCMcx5syVOtPx
         pwWyiSTJ19Dp0N5p4RhKMS2jAmtViqwIez0tssDMw/qnCUhQxo5JIwJco7T8EVGJ/NNL
         1wbSUOf2RjO8ZHBoB+as+J8R4zXdonh5ocZ0easXZV2sU0qxpXBN5g4/BqldBYPbtnH9
         ztzfIFdXpNwlO54F3BwAdivjkUvW1uV8hv5PJyX+lkC3gv2BoC6hTdxm6fbOSWz/qe7h
         RhUQ==
X-Gm-Message-State: AJIora8v+mnhbhuKtG+wgt4qF+d7/IhW3Bnu72ICN0SFUp/bttb10PiT
        UIp140bfxBU43FEHPYlhQQKBEMl4y0fi72yoBX4=
X-Google-Smtp-Source: AGRyM1sOwg9p0dpmGmg3oGdhQOZF9NRTZxq2h2NZL+F9R8RXxsk0xw66lqOH9jJZ/ULEbQymMnxhOKKrCluNajBrMSw=
X-Received: by 2002:a05:6402:320f:b0:435:7236:e312 with SMTP id
 g15-20020a056402320f00b004357236e312mr18120564eda.115.1656081789227; Fri, 24
 Jun 2022 07:43:09 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pfEF91j3frZFJgxMLU6XmaC-pn=_oQnOF2BQPaj7Bh+Q@mail.gmail.com>
 <874k1m3b56.fsf@cjr.nz> <CANT5p=rRTWpBR6MKiXrMtH0r_PD_jKyLhUhM_Of_oev=7rybDA@mail.gmail.com>
 <CANT5p=rw=JamyDwYby1VVgMXAANMCou_aMhcw0vB48gggDWJQQ@mail.gmail.com>
In-Reply-To: <CANT5p=rw=JamyDwYby1VVgMXAANMCou_aMhcw0vB48gggDWJQQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 24 Jun 2022 20:12:57 +0530
Message-ID: <CANT5p=q6xyaaqqNizp1HsXhLFTnwezJ267SJDqr5WwyG8KZO+g@mail.gmail.com>
Subject: Re: Multichannel fixes
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 6, 2022 at 3:57 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Mon, Jun 6, 2022 at 11:12 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > Hi Paulo,
> >
> > Sorry for the late reply.
> > Good point. Tested basic DFS mounts. I was facing setup issues while
> > setting up DFS for failover.
> > Steve will be running the buildbot DFS tests anyway, which will
> > contain DFS failover.
> >
> > On Thu, May 19, 2022 at 12:45 AM Paulo Alcantara <pc@cjr.nz> wrote:
> > >
> > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > >
> > > > This time, I've verified that it does not break the multiuser
> > > > scenario. :)
> > >
> > > Thanks!  What about DFS failover scenario?  :-)
> >
> >
> >
> > --
> > Regards,
> > Shyam
>
> More fixes for multichannel:
>
> [PATCH] cifs: populate empty hostnames for extra channels
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/fb231a3e148e7537c899f4e145fc0dd876c2b195.patch
>
> [PATCH] cifs: change iface_list from array to sorted linked list
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/94363021b50edb86813ae280526d7f33d6903703.patch
>
> [PATCH] cifs: during reconnect, update interface if necessary
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/7610df44d276634a51155e6314ee159b7618013f.patch
>
> [PATCH] cifs: periodically query network interfaces from server
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/7dad71410514232501f921a8c3ad389d3344fddb.patch
>
> First one is a fix for ensuring that reconnect does not resolve extra
> channels to possibly wrong IP address.
> Rest three enable periodic query of server interfaces. This is
> important for Azure service, where the server can change the IP
> addresses of secondary channels.
>
> Reviews will be appreciated.
>
> --
> Regards,
> Shyam

Updated the last set of patches to the below set after fixing some
coverity warnings.

https://github.com/sprasad-microsoft/smb3-kernel-client/commit/37d488b3d38c04f9f4caf1fab2b58301f0c20227.patch
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/a21e72b2a9599482739884329523ed91cfabf8db.patch
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/ad8f403ac707cf326371d1361ef5880d89b9bbe6.patch
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/85ede3abb8348d3b9b5a2548c9773ed0fec0f157.patch
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/8577d17e605634f297e1be71f602c8027737fefc.patch

-- 
Regards,
Shyam
