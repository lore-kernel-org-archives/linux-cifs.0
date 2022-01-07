Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D947AC433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jan 2022 18:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiAGSji (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jan 2022 13:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiAGSjh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jan 2022 13:39:37 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C1FC061574
        for <linux-cifs@vger.kernel.org>; Fri,  7 Jan 2022 10:39:37 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id h7so18715393lfu.4
        for <linux-cifs@vger.kernel.org>; Fri, 07 Jan 2022 10:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ew0pMfk9tLa2l4sigwNVWgyRYXoTsicS3j8D7qnLrRw=;
        b=pCUhEeF8WD9AputXy+U55S9bxOTiyEYXVZUyVHQ0SAtKZ3XAnxyPGBVAoM9+mgNrFa
         Or0wkLfU8sG3BGDGCGR/1/yYkgq4vbiO9sxFkQKOPBs5YbuwFo/xDTYwSExt2piuKDfP
         rur5kDaEBjVIVObXOIk2i566dAPHnhmLLvJ2RlOjKIxx9Ag0Og8NtXaaeXdlGcRr8x37
         l34Mn58C5l3J9hFIwjkO/Y28SemV4OwTRPrmYDPJTXTbpsbN34zw2Nnbz8DZPaXkJm8N
         68M3sw0a96mR9t7GtK+I+JEr8IVBcIy1OTM9ne6SgbrS838oRUmbKYj1Y13zaUOb2Aes
         BEKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ew0pMfk9tLa2l4sigwNVWgyRYXoTsicS3j8D7qnLrRw=;
        b=tgxzdVQOnoEDWyADmif+10/6/tc1LAmlBw7kuUu9ce7WjVOy9zIKkG13cPGjGcUEre
         JVTOZr4Ca1XNLTWi/8k6EhSDLXBB7KdcXmbnmO2Na8VREC/TfuU5FaoXOWu7vAeWKtxt
         vyy9FWn8cReIgeoYmcy0Hix0MC2/CubUuD5gjbdE6w/i5tHiwgY2eFW+nOrThUDr7YNo
         aeuiulkIo08R/6C241XUoyZJTdzY52TqlZYzhA/0Q+yqNk03trIL/UkOSU4E19dQok7m
         MxFDzlBv9UWnanqyyq9zjFsAi6N0k3zc8wVJ6ftZziJ2Z+6mAQb78tmf50W+kbNgAz6k
         cXIA==
X-Gm-Message-State: AOAM5327AJ0Nh6/3jjLQOhwV+FWZb28cIyo3zAtMNmYgucy/NSK6ltVa
        5FH3SfpjOJWvasg0fXOt/0O+AijGXoueOave6x5HrIy9dTU=
X-Google-Smtp-Source: ABdhPJwuy1a5SRCVI2/7fqHnnCPYyWF/PJWU97xc9B116+1bXHzAOfyI7s45Xn0b2VTgygTkbHdGwZLjoR7Jg7YOND0=
X-Received: by 2002:a2e:9c8a:: with SMTP id x10mr48010473lji.209.1641580775584;
 Fri, 07 Jan 2022 10:39:35 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 7 Jan 2022 12:39:24 -0600
Message-ID: <CAH2r5msWYcefntP4Dks69W+Oq3DKc8qHp5mow07g49TN7fV50w@mail.gmail.com>
Subject: SMB1 regression with multichannel patches in for-next
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The buildbot passed with the first six patches in for-next

183eea2ee5ba cifs: reconnect only the connection and not smb session
where possible
2e0fa298d149 cifs: add WARN_ON for when chan_count goes below minimum
66eb0c6e6661 cifs: adjust DebugData to use chans_need_reconnect for conn status
f486ef8e2003 cifs: use the chans_need_reconnect bitmap for reconnect status
d1a931ce2e3b cifs: track individual channel status using chans_need_reconnect
0b66fa776c36 cifs: remove redundant assignment to pointer p
c9e6606c7fe9 Linux 5.16-rc8

See: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/3/builds/137

but failed for SMB1 related tests in the DFS test group when run with
the next patch: 220c5bc25d87 cifs: take cifs_tcp_ses_lock for status
checks

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/3/builds/136

Let me know if you spot anything obvious wrong with that patch.

-- 
Thanks,

Steve
