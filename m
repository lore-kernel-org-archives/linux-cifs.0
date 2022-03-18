Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73D9C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Mar 2022 17:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbiCRRQS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Mar 2022 13:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbiCRRQS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Mar 2022 13:16:18 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BB610661A;
        Fri, 18 Mar 2022 10:14:59 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id bn33so12119892ljb.6;
        Fri, 18 Mar 2022 10:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=FZMk1ix4XIuWfpGs1FppUJm9YWSTbpi3Jqa4aZR3Fq8=;
        b=Uem8BC9g0IhfcqKWAOTk7em8o0MDuLrGnBSL+MPCvtEj3VxZCUCeMMMMUAeXb343AR
         JblmLcmtLSNUURJQ2qidIAr82GpkNU0B2GsVbx+Ln+PWKMb6CyJFwCAgoNfp10qI/kQH
         4lLLGVENlO+r30jTykkrKEL0Zlb0/tPXryBT8gFEqSTvT32PiCdA+I8f4X4wnuxpdIum
         uOSswd+fHjRWRtfOGhcP7DSAQ+pwATgJtKP8Fhxnpjb8eIt5Y2ypEHZgZvifydJ9zkot
         MfFw3E8iBIeEFL6LJjKywpkzmh4l5E/4hXBeMqGS3uY5oqSqtQSza0/Q3UPMg3VqySF9
         uEkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=FZMk1ix4XIuWfpGs1FppUJm9YWSTbpi3Jqa4aZR3Fq8=;
        b=YGdlzqp+qacftbVyvUJYikz86IpopwZO/d4yEVeCJO1+1X6B4DnvuQ3ougtIpD9dCp
         zDgIjCMQUE6vlltCpMT0fhgKOXGOOjgcADxiIRkWMRnn69j+Dy0cijYFbt16J/sMKyL2
         cpWbMK7xJoLuMv1fAhKGGxxqK6Fluq9VwTglYbA4AzmSOS/NgDr5OtAeMcWo4K8Q2eYY
         rla/Ktxf0cAwObaaDXduGa8L8i681c/U7EEqFSu2LHPQwtLMSbm3bRv6MHmCVu8Tqdhs
         QXSlK00//oqhhlKKPX5XtlAKsDaIXzOYcoP0pr57IOX+CS11m2ZkkIffODnfrBpmvuAE
         L3sw==
X-Gm-Message-State: AOAM533PDF9K/Q6+BJT8BXryv23A1cT30wd2ac/ztGOxlkgAM5VC5Dhb
        QdvPSXvr74J49sCodS2HFUFznq6eIgiOaZCIPyo5MWvTtZI=
X-Google-Smtp-Source: ABdhPJx0BlIOREgDP6HiEqhIa+fXB+UPg//JiJTFVe6AT7ngcPPf8duS6zgAOniXSXVVBpO92pNE1RaEmJJARFY1TWM=
X-Received: by 2002:a2e:9dcf:0:b0:247:f8eb:90d5 with SMTP id
 x15-20020a2e9dcf000000b00247f8eb90d5mr6592267ljj.23.1647623696692; Fri, 18
 Mar 2022 10:14:56 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 18 Mar 2022 12:14:45 -0500
Message-ID: <CAH2r5mvgGMBOXhSvDw67aUoHLoEeDFh-hAUfHmdFsEptMkT+LA@mail.gmail.com>
Subject: [GIT PULL] smb3 fix
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
09688c0166e76ce2fb85e86b9d99be8b0084cdf9:

  Linux 5.17-rc8 (2022-03-13 13:23:37 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.17-rc8-smb3-fix

for you to fetch changes up to e3ee9fb22652f228225c352bd4fabec330cac5f0:

  smb3: fix incorrect session setup check for multiuser mounts
(2022-03-16 22:48:55 -0500)

----------------------------------------------------------------
Small fix for regression in multiuser mounts

Will wait for 5.18-rc for the additional improvements
suggested by Ronnie to make the server and session status
handling code easier to read
----------------------------------------------------------------
Steve French (1):
      smb3: fix incorrect session setup check for multiuser mounts

 fs/cifs/connect.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
Thanks,

Steve
