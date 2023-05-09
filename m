Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A4DC7EE22
	for <linux-cifs@archiver.kernel.org>; Tue,  9 May 2023 20:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbjEIU4x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 May 2023 16:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbjEIU4r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 May 2023 16:56:47 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80465B81
        for <linux-cifs@vger.kernel.org>; Tue,  9 May 2023 13:56:04 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2ad1ba5dff7so42574171fa.3
        for <linux-cifs@vger.kernel.org>; Tue, 09 May 2023 13:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683665698; x=1686257698;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fR9UYariANfKNbUu5CYkvB/lFJh2KDM4XjyejLUkM44=;
        b=MJJGFqUVVXBGcQZWSf1KQ9ISa3lvpDx25Ekl8B6h8n4GMJI7+jCylLFacex34EbM/F
         bCSNP9PTQoKg5ZrDsRxJjSTLwJaD3I94riI8KFwbNoCftPjZbKQWkOtMPYSJ6cL8fsw0
         U+Y9cE2L8NwKSGRWYa0+0JESSEx98GNrpw3Zdnzu7UKpeSWTH+wZwzMlML9Y14Ch0fKd
         kt85zPCW9fk4G9Te0suPl+/IWa9F11AtDeL++OrmQGQEDJjbUOtIU0Sokc5nucy3ViwU
         gMStVLQ37MgsTy6lE1GT3o65kgthSAWJ35upc9ECedmxDSGfn4C3HE2jxkDueiCn8UMJ
         twYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683665698; x=1686257698;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fR9UYariANfKNbUu5CYkvB/lFJh2KDM4XjyejLUkM44=;
        b=FV1lNHDa9qDr9xN7uD3fy7uLPWOpzadf+OziiPCOZk4U4rlfGFryKqXd5mHl80BNDz
         MiJDgD1l4PUwL1m3BY3kDUeDGqzC/4IHZ0lQ0wVAbu6I1gQu03Mm833bn1Tuq5Ymyrlf
         G2kyjwCdBpAiinx0pWK2sYWGiVwse7VXN0pjatSGM1RuIsCrt5+uSyMTKKlYb3c8+aDs
         SqQ9+oKnoDz8dxOWrRdgM9tCSmBiVQYygc2m9Ibd8DbqY3XkJmVg0MKr5q8Me3ieB8cd
         TnZmpFqdwBxBg8sPS+z7667UnQhyJTT0GESHvMicCyA1g3np5bt/Ru1jNEEpE8RyiXv0
         tIhg==
X-Gm-Message-State: AC+VfDyo0Zt7YwD2Ozn1UTHliOdtBjGVjOPn2lWNrVrKKNoWZ7Webxy5
        evBTYlBtyC+jDXoHS2KgsHyEqvie3oFa3T3C86Fuxln86BkiWR6K
X-Google-Smtp-Source: ACHHUZ7VVGUOPOsTKwT86ksA/6DJ9YvqHlgtol3hlgbt37vCr3s+6M0J6dNtDmX++RhgKFx0MtG4LFwIR5uJJrW4OZk=
X-Received: by 2002:a2e:7c0f:0:b0:2ac:7ae8:2c10 with SMTP id
 x15-20020a2e7c0f000000b002ac7ae82c10mr1395421ljc.33.1683665698290; Tue, 09
 May 2023 13:54:58 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 9 May 2023 15:54:47 -0500
Message-ID: <CAH2r5muZavtKBU__Qy2s+XRG11u1HXyjC3oXF2yxY5h1b2jh1g@mail.gmail.com>
Subject: Samba returning mtime for multiple time stamp fields
To:     samba-technical <samba-technical@lists.samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I noticed a problem with Samba when running xfstest 236.

xfstest/236 does
touch file1
stat file1
ln file1 file2
stat file2

And checks to make sure ctime is updated.  Locally I can see the ctime
is updated, but Samba reports the value of mtime in both mtime and
ctime (and doesn't show the change to ctime which causes the test to
fail)

root@smfrench-ThinkPad-P52:/mnt2# stat /test/out1
  File: /test/out1
  Size: 0          Blocks: 8          IO Block: 4096   regular empty file
Device: 10302h/66306d Inode: 552933716   Links: 2
Access: (0777/-rwxrwxrwx)  Uid: ( 1000/smfrench)   Gid: ( 1000/smfrench)
Access: 2023-05-09 15:49:37.000109800 -0500
Modify: 2023-05-09 15:49:37.000109800 -0500
Change: 2023-05-09 15:50:08.405799460 -0500
 Birth: 2023-05-09 15:49:36.980131061 -0500
root@smfrench-ThinkPad-P52:/mnt2# stat out1
  File: out1
  Size: 0          Blocks: 8          IO Block: 1048576 regular empty file
Device: 35h/53d Inode: 226         Links: 2
Access: (0777/-rwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2023-05-09 15:49:37.000109800 -0500
Modify: 2023-05-09 15:49:37.000109800 -0500
Change: 2023-05-09 15:49:37.000109800 -0500
 Birth: 2023-05-09 15:49:36.980131000 -0500

#  /usr/local/samba/sbin/smbd -V
Version 4.19.0pre1-GIT-3633027e49a


-- 
Thanks,

Steve
