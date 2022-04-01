Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B33C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 07:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiDAHTA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Apr 2022 03:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343811AbiDAHS6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Apr 2022 03:18:58 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E8B25D5D2
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 00:17:09 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w25so1856265edi.11
        for <linux-cifs@vger.kernel.org>; Fri, 01 Apr 2022 00:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=NJyf0CuoPqcXJ2oGnSkxx1LS41PWsZs6RqQtBoD1boc=;
        b=qe7ttZFmKZuis1ypGOuDNkw3z9zpzHXf1AeMPQAnY75XnnM3HDasBbpIwHJYGWQGfR
         cbFZVaXOZvMiQiHd1Hqz8MyzTh1A2u1oksH6OAFuIXCdX5s/Tk1/gCxjiSNIoraBqXAn
         zYRR4TP7MGax+Yf1G/9RVxR/Xv+BShAeqCV2/aH6sA93GwhwQLD6FhmgC6lZJhaJdmjm
         jNaza0JxGf+zFZexw/+l1TIk+inB95bh22Czv6Nt15BQjXMfiKSjbnidCnehQUGZLgI6
         6v5mbol/NtzhZ6lSr9JF1UtCt3ocuuCXcaP8GPi+ZJqVQTYapT4Dx1kJhc+J/zTQTd9j
         NV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NJyf0CuoPqcXJ2oGnSkxx1LS41PWsZs6RqQtBoD1boc=;
        b=rUWKdVcOBXBIdwwqQedmUjY0ycQ2cYe7a78WzJQ7Q83SjY+d13W/inmVuqmdsyVq2Z
         FQMcOLX15RjU7aYBjiSqTUGpLwB+aKsHpoJqmVPfU8RsOBbCdjf+65V7kX2uHjb+NS/0
         LS8HRfXxnyJwQ3/S+XZ7iyitJwEMS6enpW0z1cIifsL1LB681YmHjoVT3eH/uRve4ky1
         hdsNQqK42Mto6M+8x1M2ebQnqvQslNM39ute5PBVa67mNvoZtryjhzWfVzaDLtfGIgOd
         88dHJ+D0u627C7lGZ+x9fjfq62qszt2v+tMihZh2+TmkANyJHbAOaAjetUmwJIrc6t/T
         WkAw==
X-Gm-Message-State: AOAM533gsLTQcJRY+tFBE5cfk1FmEp052APE0j+GqNnh5lZAkzLhAz+A
        raXkP5JtV9Kf7/aYFgCIX5g9yNjB8COLMNxbfjKbxonT5THx4g==
X-Google-Smtp-Source: ABdhPJxBQxO38HzC5a06leMgOMhgDDPeCOYkXEKkcIOJ1UddKHhDlmRFK5SOesjptzZhIH+KICff16IX3k4ljogqVu8=
X-Received: by 2002:a05:6402:348b:b0:419:172c:e2aa with SMTP id
 v11-20020a056402348b00b00419172ce2aamr19835671edc.261.1648797427960; Fri, 01
 Apr 2022 00:17:07 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 1 Apr 2022 12:46:56 +0530
Message-ID: <CANT5p=r5N3h4F31Oi-GrrZBr4c86LmO+voGTn=x1QkbP=881Qg@mail.gmail.com>
Subject: [PATCH] cifs: release cached dentries only if mount is complete
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

This is a fix for a bug seen during mount failure during my testing.
Ronnie has reviewed it. But will be good if you can review it too.

https://github.com/sprasad-microsoft/smb3-kernel-client/commit/fcd5a7da1f616a7134bc4fb4e329e8f085f63801.patch

-- 
Regards,
Shyam
