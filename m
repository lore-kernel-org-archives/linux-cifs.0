Return-Path: <SRS0=po33=YY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE5CCA9ECB
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Oct 2019 20:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FC5C20679
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Oct 2019 20:19:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UzDLfZwp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfJaUTB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Oct 2019 16:19:01 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:44135 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfJaUTB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Oct 2019 16:19:01 -0400
Received: by mail-io1-f48.google.com with SMTP id w12so8237549iol.11
        for <linux-cifs@vger.kernel.org>; Thu, 31 Oct 2019 13:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Th2+CibBWexidRT75tQ34FfITBJLmrgNSofa0TQFmhA=;
        b=UzDLfZwp2JuQOZd6UPghG8YH+SboYgriitIjDfg3sgmDZAunGEw4wkELmKE+7n46ux
         Qw+ldj3ULIj2mmfab1Lvy+/Zqm5tkwCH3NPvpBcUYogWDn/l7jIXQ4dfwoXnPWu/n3zt
         1ij6qN/8ObPlOCp+Ijxmz3nMuRNmGyR7LcaAz7kQiAstGiIKUQClvrSHdSS5OSf1L/fi
         OYnvKLUOqS1CTF9KZGj5fLlGSuCa4M20WtuhgHHjv+5o7t8z6531PHtsQSBa4v4L8F31
         M787q3lNq4cQeNKchg+qkYZWeQ2muWCd0xQ0Kqgt5X2K6yp8XhAe7LI5jx4MNzsJpii/
         qE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Th2+CibBWexidRT75tQ34FfITBJLmrgNSofa0TQFmhA=;
        b=Bbx1wBpWQKA3oD8c520CpmicPjP4MTuws8FHzPC/KvfsTwQdgiQ3n9kbJWlKGDH0/h
         buQE+UxbJtNapETOFY3iKisXkNCU6laVCWyoO/cWVQFK1A6j+dizRlwlQbxOKN7Z5zVN
         4lh6bWS/iOYZGcUFUfZLsUFlFlZ78RyyNIMmJ0uF2bgCnwaewJgRmAlI/iuLrmbAFgkt
         DUfOSEP0ZRdVq1AsoDJptiuB24d6AdeaTdsU0nX5RvWlRoiUA8xWvWhd9m064QOvzRzx
         ZABroSDJmaVvmPdeTgxrJR0y1hcX34dFDPqpt9xL1PWEC/Q87wTzhP5ounFcr44l9Vwd
         K8cg==
X-Gm-Message-State: APjAAAWlo7DxMlqBoZE5T/lqE6yoJV6/rZIo7QmoAMTaIly+6B63Ea59
        zdKn5lwAtSYGOuj176Tkll6K+0Jc+cWC0ZLa38pdjcCv
X-Google-Smtp-Source: APXvYqwa2qY1Dnpxv/8Zp8nM/oyPWiIHtbEoyAeYbK4oxhtEHPgEAiX1qPU1pCOoljyeQQkrVvjXeABZVfqPnjEK5xA=
X-Received: by 2002:a6b:6c14:: with SMTP id a20mr6526200ioh.5.1572553138634;
 Thu, 31 Oct 2019 13:18:58 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 31 Oct 2019 15:18:47 -0500
Message-ID: <CAH2r5muCW3ow-9UkdtBK9sxRrgK92MjVQZfe6W+DS0XKYVRF9Q@mail.gmail.com>
Subject: SMB3 Buildbot regression tests added
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added xfstests 091 and 109 to the (SMB3 Linux kernel client) Azure target bucket

-- 
Thanks,

Steve
