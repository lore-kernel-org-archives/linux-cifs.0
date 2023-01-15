Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7148C63797
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Jan 2023 23:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjAOX6R (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 Jan 2023 18:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjAOX6Q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 15 Jan 2023 18:58:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AFDCC27
        for <linux-cifs@vger.kernel.org>; Sun, 15 Jan 2023 15:58:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41BB9B80B94
        for <linux-cifs@vger.kernel.org>; Sun, 15 Jan 2023 23:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB054C433D2
        for <linux-cifs@vger.kernel.org>; Sun, 15 Jan 2023 23:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673827092;
        bh=3YiLP3i8PHzfgpXmclcD7p6Osxhm1tySeUPX+y6jaGQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=aH07N84s00drkpZYgFX8DQZl3D8cwJ/xVFy7yncOEVNXVD3WuQRxx0t9LtDvnMPo5
         n8g5ekYA0NCfcueaqilAJlwKAgNASbkTxS/Lhmk1ff1RTb0igj9gwuEHEMjUMIWBzu
         Sg1flMKOkcAj7Pi4cEDJ4jQKxQ8apcr6i02rGufpDj0cJotdnhU5bffdbVEDh6PSGc
         AMHIvh6w/9OaN6Hqh4W7FRsTRcI4xmtfhM21DDpflOCuGYwAmFiomvakYKESWjBtlx
         mdgr43gCNH7qC6btoYtCgEiDtNy38hP77hULJefRXpkjC54AtQ5gy99+rey/27BWHC
         Iu2sHNO5WoHPg==
Received: by mail-ot1-f52.google.com with SMTP id f88-20020a9d03e1000000b00684c4041ff1so5628547otf.8
        for <linux-cifs@vger.kernel.org>; Sun, 15 Jan 2023 15:58:12 -0800 (PST)
X-Gm-Message-State: AFqh2ko4Kuzmh+BxrvAH0EUWE65S0W4G6zfRpBZr+aEw+vLoyQ/io3Lr
        xfhfP1ZmnVXMKzCS1M15D29ugCcdKeu3KSwGhwE=
X-Google-Smtp-Source: AMrXdXss0w09Xi5QhIXKr/uAWro9Gefop7SuHOyVflUNs6SNZmHBifRLe6hL4Ztkqr1dNU94uETdp8heVWHC/hOh+g4=
X-Received: by 2002:a9d:1b70:0:b0:675:b92f:e059 with SMTP id
 l103-20020a9d1b70000000b00675b92fe059mr5886127otl.327.1673827092045; Sun, 15
 Jan 2023 15:58:12 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6802:191:b0:48f:4f77:6cb1 with HTTP; Sun, 15 Jan 2023
 15:58:11 -0800 (PST)
In-Reply-To: <20230111163901.2030281-1-mmakassikis@freebox.fr>
References: <20230111163901.2030281-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 16 Jan 2023 08:58:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-8LJ=eS_tje22tdZHzGyVZGbwFXPau6OV0oy1vh17wEA@mail.gmail.com>
Message-ID: <CAKYAXd-8LJ=eS_tje22tdZHzGyVZGbwFXPau6OV0oy1vh17wEA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: do not sign response to session request for guest login
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-01-12 1:39 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> If ksmbd.mountd is configured to assign unknown users to the guest account
> ("map to guest = bad user" in the config), ksmbd signs the response.
>
> This is wrong according to MS-SMB2 3.3.5.5.3:
>    12. If the SMB2_SESSION_FLAG_IS_GUEST bit is not set in the SessionFlags
>    field, and Session.IsAnonymous is FALSE, the server MUST sign the
>    final session setup response before sending it to the client, as
>    follows:
>     [...]
>
> This fixes libsmb2 based applications failing to establish a session
> ("Wrong signature in received").
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
