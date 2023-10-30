Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE76DC4167D
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 12:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbjJ3Moy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 08:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbjJ3Mox (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 08:44:53 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67C8E4
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 05:44:48 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-5a7dd65052aso42784917b3.0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 05:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698669888; x=1699274688; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q04qqdKbeEkIqUyUsEnHcJqYgaf4/t4f8VkrXwbnJcU=;
        b=FfxEZ3gLbOhTUknc13ZGEllFTdlYToNxY2lpeLd7txeHSBfbF8fsmb4o4XyLXhlDrZ
         MgjNdC504Q/3SKezKsM7d6yNi2cqAqSw/FCZA8ikrmg5oPhWkfP/MD2ULK49Lg3MhdhF
         83IEB01FgTy4sMonk4BKsYqdnlHm/pbtfxkeOvEzLYBmUuXQi39Ns29nnVbS4iPWEC8x
         eBtqGKvAXh8oyZb7WsiNURxBHuGHUt2ujQ1Yvh9LOG5cZqt2r05WR0g3aJuUkTbW9+Io
         0fVSHP0P1sTpKCqepM2reaLV2dMNYBli/62jM1OLeHpINhV7CK5tsmh0PCROKN7Xrs8Z
         5cdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698669888; x=1699274688;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q04qqdKbeEkIqUyUsEnHcJqYgaf4/t4f8VkrXwbnJcU=;
        b=O+04HK3BihinMbnvjYpfCq+p7uX1+BosfnYRQoLHl2RJ3Qj73UigQpTcfH4je1lIDv
         alcjg1KHFqhNFb2Z9JLtDdu4yysFx/cuLTAEXbUjmrRy31d+xrZUd7xJwc0PcYPYAhYs
         OJq7SJ2tKcraHpFKQWFvr6CpfmuMRAtRZHc8Pz59so1rHcFZ5lAKeqTz0w9NvDl4bP0u
         kMF92ZODtG998evsahQjg8kja1bbN6YF2EtOZI238QdqAzABG1zW9hXtGjd3YsoomHs1
         s2YoLrYOH1VTWBGv3+Xdbcl/QA0vPHznFezzX9bPCN0EK+Goi3Zq824AItPVicfQKH3t
         G96w==
X-Gm-Message-State: AOJu0YxBhFSRZ/opnExRLsSrrCiLpySTm+WngqcKE8wahyBpHrzfK1uD
        kehF5po4/xRlo1ynSaarXyxuFTFue7+xyahhO7w=
X-Google-Smtp-Source: AGHT+IHcPvuXEvM4Rk3X0WzvMc+8NiarIQH5HKR8gMUZQzibhTfNwRt15CMfQzJuNfXZV5/zoRWfGEpI3P7fdwjVrsM=
X-Received: by 2002:a81:aa12:0:b0:570:28a9:fe40 with SMTP id
 i18-20020a81aa12000000b0057028a9fe40mr8778059ywh.5.1698669887887; Mon, 30 Oct
 2023 05:44:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvxf3j6aXGdzh8b7cRYJ=fHvjfkv=aHPStJRYR+x8auiA@mail.gmail.com>
In-Reply-To: <CAH2r5mvxf3j6aXGdzh8b7cRYJ=fHvjfkv=aHPStJRYR+x8auiA@mail.gmail.com>
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Mon, 30 Oct 2023 18:14:36 +0530
Message-ID: <CAGypqWydCTT5M6T_0k4y1jPVZyiOtsFGBxdQfHVDSfx_v-dX7A@mail.gmail.com>
Subject: Re: New SMB3.1.1 command
To:     Steve French <smfrench@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Also another minor patch to clarify some of the unused CreateOptions flags
>
>    See MS-SMB2 section 2.2.13
+/* FILE_OPEN_REMOTE_INSTANcE cpu_to_le32(0x00000400) should be zero, ignored */
INSTANcE should be corrected to INSTANCE
