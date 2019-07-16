Return-Path: <SRS0=queM=VN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F417C7618F
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jul 2019 21:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55F162173E
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jul 2019 21:16:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dhl0sCWr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfGPVQs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Jul 2019 17:16:48 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:34372 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfGPVQr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Jul 2019 17:16:47 -0400
Received: by mail-pf1-f170.google.com with SMTP id b13so9717885pfo.1
        for <linux-cifs@vger.kernel.org>; Tue, 16 Jul 2019 14:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=5S6eiAmV3NT1SytfONKW5EdeU8ssaTCjrO3aFhWH5cw=;
        b=dhl0sCWr8em9ml9CdYVSs3cP6I81CvN31ubxybtuRY5fGSru1npxq8YX505kTV2ube
         oEZiYg2dT1FJ8CxUMMOsHfzBCm68dRjpY1WilK2hK/8mfe1C9F9vcJobVlybXoaISK/b
         Q66wGMNOWWNeIXgax+62bHfTEK44s2z2Y9KIfrh08RbOKIszcL6Fmk6gFf+I+RNTqDlw
         B+AXmgb0zoLU507BpThhPjJYMOMZh38nbqLpvJMbigy8FgOjN9SyvT8eX1dBvBNzDtxv
         sSVojV/yfk+U2k+6cXjkOEo5zsm8jQEReTOCABCJ4FSfO61mhEJ2LGcdmyYgsAse8/L8
         yNFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=5S6eiAmV3NT1SytfONKW5EdeU8ssaTCjrO3aFhWH5cw=;
        b=P9r3U5VB8Su+e87GvmnH3759qeI2EFV0tgMx/OfSad7CAwflHYQUNL3mYGpFyhR5Tl
         oOfo90eXaCraT1YAfMSjN4YtmxFjn77/+M7vukbl6FMUsJu4Im8yYZ6NWF22MN7ij8t7
         sRAnD91F6UhCkaI9NG0f51y9FhrvAT7WWjs3us1sQuZ3Qbql/bciyKUIQPWF4k3taAGC
         /F8+B97WMBDUtyXjJjbCUA2FkFmwWRgXi7DfjbTx/d29514XXIeW3IPV3jF0LYRAjTnQ
         zkISkaqiM0kqH7ak/PzlsSORkR7oUf856iu4rITAaH9jj5eUufFOA83oKWMdJlkT3vnD
         ZEKA==
X-Gm-Message-State: APjAAAV7YJIrEFwiM8Jr6uq/Ou87kZbiMZmWDEDOeZAmyt3H27qplOCu
        kuR3qt5wYPPM9XbIqb0rwQ29ukyea/BF/09biPz75Frm2y8=
X-Google-Smtp-Source: APXvYqwYG6N1MzA3n1X7AOFIqmJ1dXY99b+MFzYeaJTb7w9apjHkHraMLxvoItxuTIdLygfaULmte6mE/805IaGPNCc=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr38218326pjb.138.1563311806738;
 Tue, 16 Jul 2019 14:16:46 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 16 Jul 2019 16:16:35 -0500
Message-ID: <CAH2r5msmRPK46t+U8K5c04xSeyvPsEOSGK_AGCnafUNc3mPhLg@mail.gmail.com>
Subject: setattr and writing out dirty pages
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We always flush data out of the local cache on any set attribute change

(see line 2434 of fs/cifs/inode.c)
       rc = filemap_write_and_wait(inode->i_mapping);


which seems too aggressive since it only needs to be done on ATTR_SIZE
and ATTR_MTIME changes.

With Ronnie's recent patch we also do an smb3 flush request when last
write time changes (to work around the problem where the timestamps
(set e.g. by "cp -p") can be reset to current time on close otherwise.

-- 
Thanks,

Steve
