Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BF2C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Oct 2021 11:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF85060E0C
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Oct 2021 11:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhJ3MA3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Oct 2021 08:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhJ3MA2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 Oct 2021 08:00:28 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F69C061570
        for <linux-cifs@vger.kernel.org>; Sat, 30 Oct 2021 04:57:58 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p16so26465709lfa.2
        for <linux-cifs@vger.kernel.org>; Sat, 30 Oct 2021 04:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=lBP0q8SugUz5/4ONVbrDiZru/Cxg7lBnii1q1Zyb+wA=;
        b=fjR8e9kS4IUIJnjnwr+uW5vsXUsFVSSPcZ19onoptDYh3tdXYUS5CRKIx4YR9UyxjJ
         hKU1NdEX7aXc46W+43YbV+5azWEYiVMr0D+Sfu2k/bE6BuLAP5dF29B5zUB7XDZnH1HO
         7asJKzSN+d7/XEgwRp4cqAAcP3cdUBErlik1XCpj4HCtzDyUIqB/TdK1qlq2lhhoudZG
         44JMTElrWZL7c/gACV4PhKEilI5W/mb8uDzvvpi7HFXUf11SdO5oI/oZNkuLB/TuMW+l
         /F3hAUlBVXD9J3t0O7s6SxfPMnWzBFuIJ11oI5EeZqgRInI7x8rw/ElQZan6c8nqtfsd
         x8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lBP0q8SugUz5/4ONVbrDiZru/Cxg7lBnii1q1Zyb+wA=;
        b=5xUPd8HkF6zkk8bJ6rrx4Nv4D6F8yl6ymrHT6GK4oYSMst7kUXBk67ii5E2tYTVPLB
         0cYU0wk7WO3fHKnhHjA0s6SHidrJ85nYaXdTT16sdSUq+IEa7AQedUt6hmogndACjilx
         l9uE0+IknkOVh5fCW3sG0t1OkGL2Z2U3XvQwCy36j4Xie4lI0aHlG36sEcifRgRQfEGj
         OoBGo2Pji/M60TcZWwnK/TRZXPu/kBTOWpH/gT3HU5vGE3zo0VUaFCl97wxD3qQAnO09
         6VTo1AOnRXzKiYVSDM9x47b8ykWhKkF8nOKgZ7HmSfFeHPnt9p/LP9PIl8ulKpAoczL9
         1hyQ==
X-Gm-Message-State: AOAM533F6Shezy1/ybnJwntZXXjJfBWPy0AIb12Eyh4WF1uSn+GbpjRl
        Y4yDb9Isr1YAO3TgqHeDfzRj9SReCZCIi+LycUE=
X-Google-Smtp-Source: ABdhPJzUNITIx1Uq08faePyGlHANPDfDgG3YU8gYYxeNnymsmLuTlpeE+kOqa38R1I9PNMEajrMkVx70SEe6tv8wGWY=
X-Received: by 2002:ac2:4309:: with SMTP id l9mr15958097lfh.667.1635595076587;
 Sat, 30 Oct 2021 04:57:56 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 30 Oct 2021 06:57:45 -0500
Message-ID: <CAH2r5mv8HDTp6mQD=JQE8z1vZMZ8JytsB-Te7JnhPOiKzwe_2w@mail.gmail.com>
Subject: Volume Serial Number and Creation time not populated by ksmbd server
To:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When debugging an fscache problem with Dave Howells, I noticed that
ksmbd does not populate the VolumeCreationTime or VolumeSerialNumber
in QUERY_FS_INFO for level FS_VOLUME_INFO (see
smb2_get_info_filesystem() in fs/ksmbd/smb2pdu.c)

                info->VolumeCreationTime = 0;
                /* Taking dummy value of serial number*/
                info->SerialNumber = cpu_to_le32(0xbc3ac512);

Can we fix at least one of these to query info from the underlying fs
to populate this so our fscache info is more unique by fs?
-- 
Thanks,

Steve
