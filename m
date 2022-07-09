Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F34C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Jul 2022 06:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiGIGPV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 9 Jul 2022 02:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGIGPV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 9 Jul 2022 02:15:21 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85670165B8
        for <linux-cifs@vger.kernel.org>; Fri,  8 Jul 2022 23:15:20 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id g1so465081qkl.9
        for <linux-cifs@vger.kernel.org>; Fri, 08 Jul 2022 23:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=zO04l1IGuknvP7alA7k3YudsNoE/2u2bik2LAz0PHVc=;
        b=jaFcHOqPdHVhezhiWoupzJrRmZEJzqYjvz3lFj4UG/rtXLReRQNDYc7E731fZqBlB+
         y2LcAhM2aN0/a5IKzakgZiQE4BdUnpQbT+746gWBh4222Q2DBbj3agii3pbR6JNDCwCS
         Nqc7SiV70+JxWA9PDRtGfnmiLpaEPCb5JIbyys5gWfelvwvV6VpdiWGOjozJofT1j7kE
         X116pOoPInBrpsVnqFcKRBpLnC41vYr7skZBoKNCLePrQvNaJbF0r9a3j8ubqxQIKme4
         l/heqpH2VlPq4/kXmAURzQjdP+Mop5N59jEosOo2baHmOaVg8ZmRDNXeOubr8TUQl3nO
         OiZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=zO04l1IGuknvP7alA7k3YudsNoE/2u2bik2LAz0PHVc=;
        b=p5FPnTBlJr7g96PRM7Olv7ib8pBIZ/L8zqU7Y3q6O6lnoDPttKn0J8WQsSNBx9p22T
         +WyhNb4cwsK7lA3tUlphXjZmsfFCJ+D4SL8rLlzN8HVc6pvTZutsEdpljCrmJT72+v+g
         gPFN8sFuEUOpRgyV+A4BkPhA3+Bmfy1sNHNt3j59flQZYWo3TKB//JiCQ9suu1bmboeq
         RRiMlnDEEmWbi+2b/fnOXkoQBJgo2zoH3AIwGjkTaS3EMaB2GzVx2qqz0QnSGYJTBr8A
         wWd8oorQtZ0dipTttd9z705ZnEoR70H6YGg8JrGea6aJuqPIrdcjNN+MU+T6j9bHVGOJ
         HSTg==
X-Gm-Message-State: AJIora+5uhGHYzj1HTyNfRSlkH41WIxmqHL4ggNXeRfpipVQBYsT4faB
        kXK5VmcWSJhiRQyfAUvUrnYdtSxQVYiH5me2HZy7Yu8SmCMomg==
X-Google-Smtp-Source: AGRyM1sW2ws75hBT5zyRYszIADyC3/SAIpPpMDBHbvUTONkUYCqyOyDpaVaHXjcSb1sfafARPds0YkVV+Yee68LWR6Y=
X-Received: by 2002:a37:9f4c:0:b0:6b5:52dc:3b62 with SMTP id
 i73-20020a379f4c000000b006b552dc3b62mr4956489qke.68.1657347319599; Fri, 08
 Jul 2022 23:15:19 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 9 Jul 2022 11:45:08 +0530
Message-ID: <CANT5p=pamwCmYC3pFHPmg1QGNTEpNdqp9aoE=8w++BEVk+8nbQ@mail.gmail.com>
Subject: Problem with deferred close after umount
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve/Ronnie,

I'm seeing a strange problem with deferred close.
This is the test that I'm running:
1. mount a share with actime=600
2. open a file in the share so that a handle is opened, and it gets
scheduled for deferred close.
3. umount the share. That works.
4. rmmod cifs does not seem to work. It says module cifs is in use.
DebugData shows that tcon/ses/connections are all active for the
unmounted share.

I think I understand why this happens, but need help understanding how
to fix this.

Each handle open takes a reference on tcon, and also on the
superblock. So even when the mount point is umounted, tcon does not
get freed. I see that it gets freed when all handles that are deferred
for close are actually closed.

I tried calling cifs_close_all_deferred_files for the tcon in
cifs_umount_begin. I even tried printing a log there. I did not see
that getting logged during umount. Does that mean umount_begin is not
getting called?

Wondering what is the correct way to fix this? Ideally, we should call
cifs_close_all_deferred_files as soon as the share is umounted. Which
is the first callback in cifs.ko for this. I was assuming that
umount_begin is that callback. But my experiments are not seeing that
getting called.

-- 
Regards,
Shyam
