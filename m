Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53854C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Oct 2021 05:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3115D60200
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Oct 2021 05:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhJNFFP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Oct 2021 01:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhJNFFL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Oct 2021 01:05:11 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F848C061570
        for <linux-cifs@vger.kernel.org>; Wed, 13 Oct 2021 22:03:07 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id i24so20959779lfj.13
        for <linux-cifs@vger.kernel.org>; Wed, 13 Oct 2021 22:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=O8TLFgk57XdbkaQ4K/PPceaDpsS47PDJl+JgDGaSbYI=;
        b=UIycxm1WApCja1yFA7p7Jg7iiVnnOrCahSgoIkA/47on2A2HjdP/OCxX6WhcQyGrXX
         6Cn9gm++erEa9v5smR1emCcnlZ868cck2F9cmg833cvJ69RYLy93mybnW/A3t7Ur0b8h
         bPF+tDZ3HckNzoZStdy5Tzcez7XHxdvoMZ9ddrNzIQIvn+tCCDDrS2+2dJT+Kc/u7SyC
         dspFd3QlFwA51ENC7u8OlL4BY8zzr6gP60PKLOa+sELB+C/8lx5jh8EAOnxnTSO5uJHv
         43FEhlUpXkCDcfRYgPjmXZ+h/ZHsNQhz40u/lYHx3k0Z90iCvJCSHXrJYDZyrrIjZb9e
         YANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=O8TLFgk57XdbkaQ4K/PPceaDpsS47PDJl+JgDGaSbYI=;
        b=PoioRMUEWTW+GQuIOYDWT/dmmjqo9zs4gQZcz4bX/hNWDgWikFJNWL5d6+EgqAvGk0
         PGQ0D4zOIhsDllz32d9dnu+k1F2aduLqYJEVCcrOm/n6jwnY13rG7UmrjCBreUFZqMaW
         ehqr3v6v+EMoa3ZYSN44BqIKYCAat9aXdmvGEPvf1s/COGseN2ZKq1K4H+67Ba3zSaBs
         KgG30i44ZQ9+V7CpeGTTvjqExyYcXUN1Py/Oqcykd1MfNYF/KbAEVxAslrt704zD2mov
         IVLvdh1eiyFe0tsIQgcpn/gyHqsKcu+mlB4XGO4ZvWchaM0IFTekdIXfNATJg5hTVLlq
         xTeA==
X-Gm-Message-State: AOAM530vCNJvcr9RYD+7BwKV1DPG1ycgu8cPvzRnrtw9baVsUpi3lNfj
        ovdtN66RJ414sxG3fzuKsUUGL187erjqOfvHgjrubxi7XlI=
X-Google-Smtp-Source: ABdhPJzKZ0r1DX1brzjTu2rkJ+e/RtJEqrdgYWqmcDUstNHQqpH8bY5e3PnwiLkv0QO6xzCdsopEGqWVSnLQ6nomKeI=
X-Received: by 2002:a2e:a26c:: with SMTP id k12mr3830289ljm.23.1634187785313;
 Wed, 13 Oct 2021 22:03:05 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Oct 2021 00:02:54 -0500
Message-ID: <CAH2r5ms_S9WsLNnQ=AYE7Ykss5+VCfeFtL01VVqt6tp=CY5sRw@mail.gmail.com>
Subject: Ksmbd and max credits
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thinking about the patch "ksmbd: improve credits management"
(https://github.com/smfrench/smb3-kernel/commit/bf8acc9e10e21c28452dfa067a7d31e6067104b1)

Hyunchul noted in the description:
"Windows server 2016 or later grant up to 8192 credits to clients at once."

I noticed that SMB2_MAX_CREDITS is defined as 8192 in
fs/ksmbd/smb2pdu.h.  Isn't this a little low, although I see Samba
default to it as well.

Was thinking that that is roughly equivalent to 64 8MB writes, or 128
4MB writes.   Although Samba defaults to 8192 max credits as well, for
Samba it is configurable (via "smb2 max credits" in smb.conf).
Should it be configurable?  What do more current Windows servers
default to as the max?


-- 
Thanks,

Steve
