Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8090EC6FA8E
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Mar 2023 04:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjCBEMY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Mar 2023 23:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCBEMV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Mar 2023 23:12:21 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B2448E34
        for <linux-cifs@vger.kernel.org>; Wed,  1 Mar 2023 20:12:18 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m3-20020a17090ade0300b00229eec90a7fso2710874pjv.0
        for <linux-cifs@vger.kernel.org>; Wed, 01 Mar 2023 20:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google; t=1677730337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qf1UVR70I9c4J27u7Psh9oxSJK086m775x7kIZJnpDI=;
        b=RygWpE10X3MzY67t5nFXtRFziIUrnyHvKSz9YXKf1zQBIVUEatETl2IIRf752vNf8k
         3J2lrr4EcAvZK0kLrCpzM8oneRBsun1rynpJjXiYGErSsxwhMAaQ3SyrRVa0spnaVgjp
         26rc08cKTRqcLhzkli4YhLl+Um+ObyswczDsfwmMZcnBdkVg1PEe1CfUIJTRnPjfnXkm
         YyjFl5+EMvEY3zlX5KE3eLYxdSzciGaj0+8ZfmM73juAcLJ36oLpJle67P/p7kavZLNg
         7037eyP/mxhLrRhp1oF7JC1S4ESndKccjvFpJS8Yj89vs6nlXvC1tCjXRGBMhgQx/BVe
         6uOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677730337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qf1UVR70I9c4J27u7Psh9oxSJK086m775x7kIZJnpDI=;
        b=Q+0B1FVYF/AN214GeiUgy4yekZlCJpkpUR6YZtGZYXs6q2cJ4dZYwW65dAr7VkcEt+
         VZnn3XSZvdRV5AHk91zNT1+s8QnPbf5jyx4iq7q1DORVhyIMS7Xtd3HzV4s3BnilWxmg
         t4K7A9RGg2Tpo2QtZ5QyQQSfyNjynWlYsS26rZOBq96WkN/XjtV2DjRPPfPXS1elsvI0
         rZH+l3DRdpMRy4HLOKPaASmkTh4dzZcXTSCs1gS11c/inBAJitxSLWewOMgDSuUqlKKz
         wuqaQdqK6rtZXVqxoqOg+ozja1NdGBGlu46p3tXxiUbQwSsliDxyo/ZcCZcqMFe44X9T
         NhwA==
X-Gm-Message-State: AO0yUKXvUHNP8K68f7HaKt5ZKk5WyuAc/ewOD0+d+SwQB1pyfjz6P5dO
        31o9t9k5T6lV4HdEVZW8+aoOOaUhuab0CM56VxbGPsf+jm9txPBb
X-Google-Smtp-Source: AK7set9rQnOTsVQVyLTpj4SbMIp+sFzqS6bSjxVXKpwe5GPMz84/O5h2kQVVvI+ReaPY+D/QrWei1Lz94l4diqxFqAc=
X-Received: by 2002:a17:903:44f:b0:19a:f63a:47db with SMTP id
 iw15-20020a170903044f00b0019af63a47dbmr3223087plb.2.1677730337700; Wed, 01
 Mar 2023 20:12:17 -0800 (PST)
MIME-Version: 1.0
References: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
 <514a3d90d263bd8422e9d13bd4c6e269.pc@manguebit.com> <CAB5c7xrdKSO4YE_vUQ6tg+p=WwxEdquj+VrRpwKxi8Jd0vPyAQ@mail.gmail.com>
 <CAH2r5mv52koGnKbvtRKE95c_JwwtitTXFaRc6mcM8nwLmWNo9A@mail.gmail.com>
In-Reply-To: <CAH2r5mv52koGnKbvtRKE95c_JwwtitTXFaRc6mcM8nwLmWNo9A@mail.gmail.com>
From:   Andrew Walker <awalker@ixsystems.com>
Date:   Wed, 1 Mar 2023 23:12:06 -0500
Message-ID: <CAB5c7xo_qitGyZCCbhV1Nn+0UNCur8dU+qricAVXXsc-eNta5A@mail.gmail.com>
Subject: Re: Nested NTFS volumes within Windows SMB share may result in inode
 collisions in linux client
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Mar 1, 2023 at 8:49=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> I would expect when the inode collision is noted that
> "cifs_autodisable_serverino()" will get called in the Linux client and
> you should see: "Autodisabling the user of server inode numbers on
> ..."
> "Consider mounting with noserverino to silence this message"
>
> If this is easy to setup we could try some tricks when we encounter
> such a reparse point - do you have patch ideas for the client to fake
> up inode numbers in this case?

On the Windows server side it's trivial to set up. Just create /
format an NTFS volume (for example new virtual hdd) and add an
additional location (Computer Management -> Storage -> Disk Managment,
right-click on drive and click "Change Drive Letter and Paths"). This
will allow mounting the volume within an existing SMB share (like a
bind mount in Linux). If you don't want to go through setup and just
want to glance at pcaps of Windows Client <-> Windows Server in this
case I have some I can send to interested parties. I don't have patch
ideas at the moment.


Andrew
