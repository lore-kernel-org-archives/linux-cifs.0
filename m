Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9D6C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Nov 2021 01:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBF7C61215
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Nov 2021 01:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhKHBtV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 20:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbhKHBtV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 20:49:21 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C3BC061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 17:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=Qs7JgvxyRoa75jZgDBWxPDfa+kvEALR1hIN1+tLJiNQ=; b=y6nzqElwkXh+lALPyzX8mfygt/
        sqHzKeQ3xYUcal/7CxcN0pJgd4A59eFc/jR5F1EA/c89lG1G1MijyfllhZRQsijZ4vs900vZqsH9S
        0IvGGrDcv7O35cQVcCrptNE7FzsnHBDMxKFj0tidZSVGUwVY/pWCxoEzmoc8/neXTIIsu5X//kVgh
        2gcK+YJi3AOW9seKg6VO2yRlXZXv//+DpaIqZp5zfiv5Vb062qS9gVzRHLN45EKhwUpt/Zbi22jms
        /rl2XSeF6FUnQn92Ju3fxZiuaOehUrQved8ANtrw5AONFIaTKFiHP8a01XySShRdJbMgXgkCsDmW8
        Eky482N96eVkWL4cz0TcphN3pKILqm32Uc2utCuNeEJGptn5AT66berIUoEPX83pXhSmDn5DTxQ7L
        ghiHxKb5ThUSr9qSTwkyzfjTKiiOLjiZawjoM+fL2pVx2obuDSY8pmK/wqWtladwbQt4AUW0LKzTG
        Eed+F7ro/JQfyfXd1jmZtNz3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mjtk2-005hYG-3r; Mon, 08 Nov 2021 01:46:34 +0000
Date:   Sun, 7 Nov 2021 17:46:30 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Julian Sikorski <belegdol@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Permission denied when chainbuilding packages with mock
Message-ID: <YYiBdmhpfWa7l86J@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
 <YYhI1bpioEOXnFYf@jeremy-acer>
 <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com>
 <YYhXjG46ZZ1tqpxJ@jeremy-acer>
 <CAH2r5mvrPj5b460CeRT9+MNc1fOzwMixqsCN82v8KP_d+bgO2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mvrPj5b460CeRT9+MNc1fOzwMixqsCN82v8KP_d+bgO2w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Nov 07, 2021 at 04:50:21PM -0600, Steve French wrote:
>That is interesting ... and weird.   Why would POSIX allow doing
>something write related (fsync) without write permission?

It's not POSIX, it's Linux :-).

It also operates on meta-data, so if the buffer cache
has any pending changes on a read-only fd, then fsync(fd)
will flush them.

man 2 fsync.

..
        As well as flushing the file data, fsync() also  flushes  the  metadata
        information associated with the file (see inode(7)).

I think cifsfs needs to keep track of the file modes
and silently return success on a read-only fd even
if mounted without nostrictsync.
