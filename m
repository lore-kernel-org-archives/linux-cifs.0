Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0951ECD13D3
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Sep 2023 05:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239714AbjIRFyu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Sep 2023 01:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239830AbjIRFyk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Sep 2023 01:54:40 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3511CC4
        for <linux-cifs@vger.kernel.org>; Sun, 17 Sep 2023 22:54:34 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-50306b2920dso1571442e87.0
        for <linux-cifs@vger.kernel.org>; Sun, 17 Sep 2023 22:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695016472; x=1695621272; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XFPB7YTZHuCv7g+y23P1ZCSd9abcdlqFjaZJLhuN+A0=;
        b=l5wa0P4vm/ltHocRuF2pu/pc3aqDYJmpZlUjcHPnVOr0y6rYwe5cDuHdu+U1q/fiLX
         n6vNCcOOwIqrPTbDSdCGBUeP2BfZIS9BsbKLqhHW4Ys+ve/rw3CSNFEmeo8yXJ0R1LRE
         NwdAFp44u5gWLR7mn8S4EmY7zyYD0/txd/hXPQbh7vVEbDZQ1TG7yFXM1eRxFy7o2gJ0
         ZqlT1f7/fZBX1DgY0wE0x5FjxCFbSJ3Y0V4B1EqnR3gs9DKPC+YBDSD6PaVM9PpvV9CL
         1Lt+y/CbSfInyE9hUCix8W3PO6tu0PJm3uOdWkxU1JERyk5lZv2Dp2UV09nD+A3F+2x9
         n1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695016472; x=1695621272;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XFPB7YTZHuCv7g+y23P1ZCSd9abcdlqFjaZJLhuN+A0=;
        b=UwIZJdcaVdajMWUL6suPvgT2b2z1kAQVoUEpGizjkFPGS5wddDsXeH2HqaacV5PoPI
         cDH/nZxN6SBE5gOs4YTzWb8ak9MW0lHLZ4lLGSgYHmZpQ0WXdqqke4xkSIq8+ZIXUUIr
         +AN1gRRJLOjfI0iZYl8xfnzz1BshPIBMowu/GGv5wl9yt0cN+UoG15KAtO7087lHjqUX
         /TBRUaiWfcu2g91WiFAA9wtXuNu30lCJr/ZtzTAAzNBkUe5s2CkdCvBRE+SLZV6bsfhm
         eZPop9wb7wjCKEtmQtVK4GoEiBhKuaHaMAyLRfQ8aSh8krFGfH0ulKLQkbpoTHFSVfoq
         6qJg==
X-Gm-Message-State: AOJu0Yx1xHxheUtFVsCVSmIpllEUuJrjyjDAOK6BltHvGRCPjFUIEtiv
        bYR22lveV9WYHlRtnQpnClohHyH/4ggemsuTfVuL5/xh8ik=
X-Google-Smtp-Source: AGHT+IFdpNdxPMZyVL2MSF/irRMwXXkFhkgxiVEkbICG+jTu8UvBHAexUqMVQKlypXZnZtDfEPCcYuWJgidI86OWSZE=
X-Received: by 2002:a05:6512:1188:b0:4fe:3291:6b50 with SMTP id
 g8-20020a056512118800b004fe32916b50mr3867142lfr.7.1695016471906; Sun, 17 Sep
 2023 22:54:31 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 18 Sep 2023 00:54:20 -0500
Message-ID: <CAH2r5muPM81OK0qva6do8j68KrVDwXN6oQS0KNbS-5ap+KEmgQ@mail.gmail.com>
Subject: Linux client handling reparse points incorrectly with reading directory
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Volker mentioned a problem with the Linux client translating reparse
points from querydir output (e.g. "ls -l" with POSIX extensions when
symlinks are present).  I was able to repro this to current Samba from
current cifs.ko when mounted with "posix" mount option.

"ls -l" returns "No such file or directory" for the reparse points in
the directory (Samba server reports symlinks as reparse points when
POSIX extensions enabled)

-- 
Thanks,

Steve
