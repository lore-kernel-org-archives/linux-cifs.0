Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA6BC77B75
	for <linux-cifs@archiver.kernel.org>; Thu, 18 May 2023 00:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjERAdr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 20:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjERAdq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 20:33:46 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D603E26B9
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 17:33:45 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-643557840e4so1542442b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 17:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684370025; x=1686962025;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=at2g84mc++hb0Q7pVD2+L4TOpM5yJOcgXuwx6qRa8UI=;
        b=PWEf3r5xpxcii8Z7Q6O45NqzF3Zbr6wJ2t+Ow0/xdpfTU2yQyD5ZTUwVLZRyfx96jA
         tKjxBstT7EApL0b/Ha3g3Tku6z298OQi/NDZ3hoAshTmbSd3KU9DrJTXYYnXg7htyjam
         +3fYLNBYHLy11s0EDsFcOAOF+iQvb/GMadArk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684370025; x=1686962025;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=at2g84mc++hb0Q7pVD2+L4TOpM5yJOcgXuwx6qRa8UI=;
        b=QD1MtsNIVSFZ0MGgcdHW0AKj+aHq0SPUcCKZJ1uwxbUEPfAeOdXlGjpRrt8UKjmxZ+
         P0n1F2HZlvjSmd0vwURDVi0ESA+6H2RFZbMyR3PNX5BDZXeaM5Wsn2m1GJTk2zOPykXX
         +74WHvnWZcX/FysflKTvtFnrCGqA7JZqMDelHbDev2UgqJVSnEOseQIaob0MLlMgcipW
         baC9JQ3JUJjdiQyfICEM8CSUsgiUzPssUGFecj3JZ+c5Ewoau5PcamucvQ/Lsk0ntzD/
         MtdB3rAeqTKmnK3lJTGbB/Ls5WsMg6f5XhZ4A4Cz4z8v2gpR7ptuCrF9gMhBur/+x0hJ
         OfeQ==
X-Gm-Message-State: AC+VfDz0sCFG/q481tih37AsM1d962sVU9EUxVaKYH3ZNdZY1DnKF41v
        LzboO3o9vRThdOdQX4zMTnD2hw==
X-Google-Smtp-Source: ACHHUZ5jGJKNMUDRQ8f01tzSEz4EKrPRTJ7t297xYHtjVallkF4pFuKVXEiKEc0ithD1T+s/eIGbXQ==
X-Received: by 2002:a05:6a00:1749:b0:643:980:65b with SMTP id j9-20020a056a00174900b006430980065bmr2317382pfc.2.1684370025340;
        Wed, 17 May 2023 17:33:45 -0700 (PDT)
Received: from google.com ([110.11.159.72])
        by smtp.gmail.com with ESMTPSA id b20-20020aa78714000000b0062dbafced27sm129512pfo.27.2023.05.17.17.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 17:33:44 -0700 (PDT)
Date:   Thu, 18 May 2023 09:33:40 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Hex Rabbit <h3xrabbit@gmail.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        linkinjeon@kernel.org, sfrench@samba.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH] ksmbd: fix slab-out-of-bounds read in
 smb2_handle_negotiate
Message-ID: <20230518003340.GD20467@google.com>
References: <20230517095951.3476020-1-h3xrabbit@gmail.com>
 <20230517110505.GB20467@google.com>
 <20230517111325.GC20467@google.com>
 <CAF3ZFef4gmEVZR5riwdB1bkB4CccziGw3g18cyz7Sim4xw+ZDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF3ZFef4gmEVZR5riwdB1bkB4CccziGw3g18cyz7Sim4xw+ZDw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/05/17 19:45), Hex Rabbit wrote:
>    The out-of-bounds access is triggered by `req->DialectCount` memory
>    access,
>    sender can construct a malformed packet that only has a single 
>    `smb2_negotiate_req.StructureSize` field after the smb2 header.

Oh, I see, is that what you did in your reproducer?

>    Referring to the payload I showed below, since the function is 
>    assuming that the entire `smb2_negotiate_req` structure is presented, 
>    it will read above the `StructureSize` field (2400) and trigger KASAN. 
>    So check against `smb2_buf_len` first will ensure entire structure 
>    is inside the buffer, hope this make sense!
>    ```
>    00000000: 0000 0042 fe53 4d42 4000 0000 0000 0000  ...B.SMB@.......
>    00000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
>    00000020: 0000 0000 0000 0000 0000 0000 0000 0000  ................
>    00000030: 0000 0000 0000 0000 0000 0000 0000 0000  ................
>    00000040: 0000 0000 2400                                              
>    ....$.
>    ```
>    sorry for not providing full symbolized stack trace first

Thanks for clarifications. Maybe would be nice to have some of these
lines in the commit message.

>    Call Trace:
>    dump_stack_lvl (lib/dump_stack.c:107)
>    print_report (mm/kasan/report.c:352 mm/kasan/report.c:462)
>    kasan_report (mm/kasan/report.c:574)
>    smb2_handle_negotiate (fs/ksmbd/smb2pdu.c:1060)

I'm still puzzled by smb2_handle_negotiate+0x35d7/0x3e60 in the original
stack trace. 0x35d7/0x3e60 certainly doesn't translate to "start of the
function" to me, but what do I know :)
