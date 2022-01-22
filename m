Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018F7C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Jan 2022 08:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiAVIg7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Jan 2022 03:36:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57228 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbiAVIg6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 Jan 2022 03:36:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71921608C1
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jan 2022 08:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EC5C004E1
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jan 2022 08:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642840617;
        bh=A9uXV9KcJZkEa//qx3MhXuaY+XtN4aaQUmgdh+UnF6I=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Vv4dXpATdU5sB02SJcusuYcBv0PSgDWcN2tDCCBG74+REfjzbSupy1zC+OnX0KG6B
         4lEKRMKAMiBZGCEBfi4wo5l78ec+XUFXxWsAzGuqn5d3nLODTGOeai5H7bDMqh+NWP
         ikKBrkxnDHLprBMXepKTY9xfe5Iru2RwdYEOC/Sp+NLDm3zoPL7KkUzYVjNNA0v9K5
         ptzBDAFU+nvW8dF2IrlVeP13ZNoDLyjRZSbOM56rNiRvMjPRCrNY461MInb2/gHSPQ
         iUM4oqQzHan1uS0LyXVRc+Hu2YdX8/VXLAvtVKVIRE8e8+BCWqBmoi0WlD0qLBc9Mx
         iHuo+OjVZ0d/w==
Received: by mail-yb1-f181.google.com with SMTP id m6so34470254ybc.9
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jan 2022 00:36:57 -0800 (PST)
X-Gm-Message-State: AOAM5335bpGoAdTkYnqTyYOUeXynI49lFmpb68mWG3oIHSUPHTgeV/1g
        79oE5vmT7KGM6gt8ob/iUxQhE0gf5iCBbJ9MK9k=
X-Google-Smtp-Source: ABdhPJyJBmHxX8L23NOwpAJJAQXxd2SXaQuXsdYW6JfPZ0wEWZpB79XCIwTX823VsDgO4NMZ0+nutDz8htSXf+vUPXM=
X-Received: by 2002:a5b:58d:: with SMTP id l13mr11412546ybp.475.1642840616963;
 Sat, 22 Jan 2022 00:36:56 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:b08e:b0:127:3295:9956 with HTTP; Sat, 22 Jan 2022
 00:36:56 -0800 (PST)
In-Reply-To: <20220120121011.213873-1-hyc.lee@gmail.com>
References: <20220120121011.213873-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 22 Jan 2022 17:36:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-W5-z_v=bwJ6i4JaHVXzqihccKBhRU4pndW-EG-XZGNA@mail.gmail.com>
Message-ID: <CAKYAXd-W5-z_v=bwJ6i4JaHVXzqihccKBhRU4pndW-EG-XZGNA@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: smbd: validate buffer descriptor structures
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-20 21:10 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Check ChannelInfoOffset and ChannelInfoLength
> to validate buffer descriptor structures.
> And add a debug log to print the structures'
> content.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
