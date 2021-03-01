Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF53C4332D
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Mar 2021 19:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F29864E01
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Mar 2021 19:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241319AbhCATRL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Mar 2021 14:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240424AbhCATPG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Mar 2021 14:15:06 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE17EC061788
        for <linux-cifs@vger.kernel.org>; Mon,  1 Mar 2021 11:14:24 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id e2so13646210ljo.7
        for <linux-cifs@vger.kernel.org>; Mon, 01 Mar 2021 11:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=wdTXYjbD05e6VXa2B1iJxl1PbJUkf/BhoGzQ+bv2Mv0=;
        b=SMbkjnjlKaqlOiwdMSp+sZStz51mkU24PRCIRohJliS8tJXrEfQM/34nY4bffB6YyJ
         QERWT10NdNy/FJvEOkXN3dS6GHrVkPygxFKLbqoR/j6p9Xh33AD8JolYsNWMwwPcV3D3
         t0HEQZR7c2jPsPSX0rX9K3syXREurIiXfCyDC/rKj2i3kYQiB80MUgb+0ODAyZU985Mt
         OnqR7VwrKgKR7c4eCSCaR50TeBwTMwrW+zq/xKvX0uGdtq1OU/DaLTM4jZKsBsxZ6MpX
         8+KWkn67Rq/tkClPEl2n8QbFT9X7F5COV3I1BbJrDsftoldMGjfBgoL51LE2jtQp79iW
         Jrmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=wdTXYjbD05e6VXa2B1iJxl1PbJUkf/BhoGzQ+bv2Mv0=;
        b=L87k3wnVcMpYKiw0iT80EBGDWYs4dCU4T9pjU8fhCBe2AfLqz91ltPetL3Cg82xTGH
         +Ev4CoNjyzJ8ALg/E4DDxnf1AvL0bY4BvwDCZUhAJtCskGUpZhX5jxmOpxOASC3/yOUK
         8jMiT1rsT+BygIcuGjKf0eqwXyl00+SRNrRGo/spa3gjcYJtSKnJkrul7hwC0UbsStzQ
         jswggp+7ovDDSz22DGQVuxI0G3qtZjOs0v0+WiFpUDei+A3c2Wwmie2LyIdGDQtSZv/v
         bSvb9+hdlYf/6E+916F/HQw504m+wLzU6nCaN0OXngtnaJ0Qaawyoqt9Gzq/IBDpcTdt
         JRzw==
X-Gm-Message-State: AOAM532TCpjWys+0kv8h2mLZrqIBM6iyJ7L8bLRGX+3ff1mNRWuvvkzL
        4OttReWS7q9A6g/gk5mF6oWqJTlocnkmLUOFdw08YJOhgDVp3w==
X-Google-Smtp-Source: ABdhPJzv5/U51XedngLfjVxO8ZJytt71RBZG8foJh+pDSmRWnviYqXMGdopLFSHvyOulfegpBXXLyKuHRu+ONtN/8r0=
X-Received: by 2002:a2e:3818:: with SMTP id f24mr4257464lja.466.1614626063149;
 Mon, 01 Mar 2021 11:14:23 -0800 (PST)
MIME-Version: 1.0
Reply-To: pete.flugstad@gmail.com
From:   Pete Flugstad <pete.flugstad@gmail.com>
Date:   Mon, 1 Mar 2021 13:14:13 -0600
Message-ID: <CA+DQs55i4zrexVjnqi04eGFmiiL0mpQE3oGdOnU3ZLf04wrM_w@mail.gmail.com>
Subject: workaround for unexpected error on SMB posix open
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

  I have a very old (15 years) samba server appliance I need to mount
on a newer Linux client. The appliance is running Samba 3.0.25b
(kernel 2.6.22.1 if it matters)   I do not have the ability to update
the appliance at this point.  The Linux client is running kernel
3.10.62, using cifs-utils 5.9.

   We're running into this bug:
https://bugzilla.samba.org/show_bug.cgi?id=8111 when we try and mount
the appliance shares onto our Linux client.

  I'm wondering if there is any way around this without updating the
server side.  Some way to disable posix open support on the client
side, so we avoid the problem?  We've tried passing in "nounix" to the
mount.cifs, but the Linux CIFS client didn't like that.  We've tried
other combinations of specifying the protocol to use, but none seems
to work.

Thanks,
Pete
