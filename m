Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986ECC433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 08:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DED664F51
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 08:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhBDIMZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Feb 2021 03:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbhBDIMX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Feb 2021 03:12:23 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4978C0613ED
        for <linux-cifs@vger.kernel.org>; Thu,  4 Feb 2021 00:11:42 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id b187so2300339ybg.9
        for <linux-cifs@vger.kernel.org>; Thu, 04 Feb 2021 00:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Fw+wH8EUYv1di9oBpN6mosm3H2wk3jr37Tr6OKE9+nM=;
        b=JRsDQWAH5dTIpgWO2LvtbJh61T831nzGqkO8KRfuFZhHqYyzbUAyywG2UEIiebymYr
         NEkHjTsslxq5RQcMJXUlojl3+KZ6M7r+y4x06Z3eRkmYUd1yAaYsjVKENJyuEvxhWNmG
         McndSRWt6MxerRBQjOOyldt9Eo3jwlNq8fi/Ytb6d9+LHEROd8Knuw1yIx+/mcmgp8KJ
         bTCpo23QQ4Qfh/oQn26zXCEv/Ttk/e/R8Eq3K6Nq0swUTM/LcptsqFn92JOKC7YMiJ93
         n0/GuDEi2Wj11S0GZLAy00QtGTjUUw2EwPFGsTXJDEhk72FpsDnY6kEWHhUkiKKearQp
         M+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Fw+wH8EUYv1di9oBpN6mosm3H2wk3jr37Tr6OKE9+nM=;
        b=Dj3WBq6cJQ0ogXtusWaUAu/oX9Mkq4MJVUC288VKSyI7ZR1zS2YjNbUf//pF0H63rs
         SpWdbm7sslROxJOrH+UDI7Jn7LiWNiTIeAXP2kLdm5J4ZDyaOdD1tbHhBquk3ucOksSu
         Am7F1Aqz5k+tlVkCipcS6Bg6kNdDx3LLXORDao8DVi4Eq7ftKb6YM9VFUx1SvmrhgPoo
         E/QxB265huL4HzGaEgKd6wvaGSp1x47k2V0XOdMu1R24IGZsvdRurO5iWUWwhSBL80Zy
         1uRMGh2MyHE+ZwXUbo3DjkFmJ9sWZm+JZfrsWdsMDojypm4qE5CTdABPyJfV7dOHExQi
         55uw==
X-Gm-Message-State: AOAM533jnBS1VJh2zA9ZGlRsZy9QERRQLWZ3W8y/dA9Oukn63OFgjkoE
        wVCUXM7aZcwA8j/vVSqdB9nmqyBAxPGBgOdh6Tw=
X-Google-Smtp-Source: ABdhPJx5RcgrHQA88jnkS9hyBcVTQrKDseDlS9ssOLElKSzmOFHSTmWL2PzBqIEEuM16BlRMpsbM20BXPL+jfXH7HCc=
X-Received: by 2002:a25:ce92:: with SMTP id x140mr10514638ybe.327.1612426302117;
 Thu, 04 Feb 2021 00:11:42 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 4 Feb 2021 00:11:31 -0800
Message-ID: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
Subject: [PATCH 4/4] cifs: Reformat DebugData and index connections by conn_id.
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

-- 
Regards,
Shyam
