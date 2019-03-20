Return-Path: <SRS0=fxvP=RX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FE4C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 18:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FF7D2146E
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 18:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfCTSkG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Mar 2019 14:40:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52924 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbfCTSkG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Mar 2019 14:40:06 -0400
Received: from mail-oi1-f198.google.com ([209.85.167.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <andreas.hasenack@canonical.com>)
        id 1h6g8B-0002LF-Vm
        for linux-cifs@vger.kernel.org; Wed, 20 Mar 2019 18:40:04 +0000
Received: by mail-oi1-f198.google.com with SMTP id d198so1572352oih.6
        for <linux-cifs@vger.kernel.org>; Wed, 20 Mar 2019 11:40:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=W8hiAXVmDg35iiYVJDSDWMUjAQEZXdaD3HYZJ11sVjk=;
        b=EYKOB+SloOLeqko1eGMAu3gcKueBh+fKBDPacJDq0wQOfXSkPQjCXC9abE/gSupYup
         8w9PD1XOdWmVMXMzcfoNMG1jbqR5n6aBXG78sjvKZuInv8jqDGjbnMMwipEjCCXSOr8c
         rEojxEkExag6UMyWFRwMoxjFgqceeZkjST2OBXwhzrFzdN1RDvlvf2K4JY52gVsGQ6RR
         jJ7B2MWXKFq2F1Qjve5qJs20GJ7o+e0XBHmv7ErPTy7CDmI/+DfLMHWPu0g0T8SJzX9P
         va2J0U5mccvtAmchATmOZ3Wo82Lzy31HhbYCYTA/RSgSfFUlbfWv93wj9AB6yM5n5Huz
         Nmbw==
X-Gm-Message-State: APjAAAWp3O0FXJuojk74SPlVKT/AFhciL36RQhnuO4NDB6jMgpSX3CdF
        HCr6nFA8JYG3xBtkyoODXWHPrpYiGEYaHVGZUg5WPn9xI8ZvKL0uweKnJtqjJnjePmKPWcihGgy
        W/wB7DrVPRMCN1fksafu7WLRdQhDNvHea26t+NFtAnV1xDPHloI2UxMg=
X-Received: by 2002:a9d:7207:: with SMTP id u7mr7234442otj.48.1553107202768;
        Wed, 20 Mar 2019 11:40:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyms2d4ulDpK4D0BYg1bv3S8zC9kPSWDtwd3ZvQefYC4PSQE1r/bVltKTXheScqA85NO4j9bbn7anXK30emhjg=
X-Received: by 2002:a9d:7207:: with SMTP id u7mr7234423otj.48.1553107202505;
 Wed, 20 Mar 2019 11:40:02 -0700 (PDT)
MIME-Version: 1.0
From:   Andreas Hasenack <andreas@canonical.com>
Date:   Wed, 20 Mar 2019 15:39:51 -0300
Message-ID: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
Subject: "Bad SMB2 signature for message" with kernel 5.0.0, works with 4.19.0
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

I can't mount a share as guest using SMB2 or higher when running the
5.0.0 kernel (ubuntu's 5.0.0-7.8 specifically). When I switch to a
4.19.x kernel (4.19.0-12-generic), then it works.

This is the mount command and output:
root@ubuntu:~# mount //localhost/pub /mnt -o guest
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

The share is a simple one:
[pub]
path = /pub
guest ok = yes

The server logs this:
[2019/03/20 18:24:46.245816,  0]
../../libcli/smb/smb2_signing.c:169(smb2_signing_check_pdu)
  Bad SMB2 signature for message
[2019/03/20 18:24:46.245860,  0] ../../lib/util/util.c:508(dump_data)
  [0000] 2D 60 1F CA 49 06 92 B0   69 06 60 82 42 39 21 F8   -`..I... i.`.B9!.
[2019/03/20 18:24:46.245894,  0] ../../lib/util/util.c:508(dump_data)
  [0000] 75 F8 77 09 63 D5 4A 7B   9F 91 51 93 6D 12 6F 6F   u.w.c.J{ ..Q.m.oo

Here is a dmesg output with cifs debugging enabled:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1821053/+attachment/5247960/+files/dmesg.txt

That output was from a kernel running patch
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.0/cifs-do-not-skip-smb2-message-ids-on-send-failures.patch,
just a quick attempt to see if that fixed it, but it didn't.

mount.cifs is version 6.8

Server is samba 4.10.0.

Is this a known issue?

Thanks!
