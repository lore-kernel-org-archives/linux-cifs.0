Return-Path: <SRS0=zBrE=SU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB9BAC10F0E
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 19:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EA5E206B6
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 19:38:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tyu0ZrVK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389853AbfDRTii (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Apr 2019 15:38:38 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:33129 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729641AbfDRTii (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Apr 2019 15:38:38 -0400
Received: by mail-lj1-f177.google.com with SMTP id f23so2912962ljc.0
        for <linux-cifs@vger.kernel.org>; Thu, 18 Apr 2019 12:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=mEJ0TiLDCN0K/h6Bb3Kky25184ZiLfGd/rxuC3NmyQs=;
        b=tyu0ZrVKbEshrbtfz/fdcwRapkG4UjvHAe6dJZ04t6xoUmfFLb9A1DBjSDhe5741XS
         XiDYX+6LWQkHjyoaKmxOaERQeh12qU7lIPhCi1SNadlsZVW5/FRw2gq9MBBPZVTsnL0o
         1EjkUjNxIpt9B7sXL8HLSzaAhuIXG0C6g0pnwmeZV8JCBNrr3EAPg6GSJK7CGQTGQlCp
         LoXEBLuoJX1BgJqFW70j4fBBq+VzDjlUQ6ZA9eL2aBZSKkE68+4PgsVaujcmM51+9zkJ
         ggAzr+uRuWpsIXccirUjhC7NaJuQ5vraF5RtRMZ1pTrPKXkhbz+Z9AGLePjGHx8iAGdp
         yCtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=mEJ0TiLDCN0K/h6Bb3Kky25184ZiLfGd/rxuC3NmyQs=;
        b=X1PXjTZB2xYql2Ym0M+6uiE1Ai5IUZDfQwkr9J+azYfmC8aeGlJL1e/bgme0k9/Mdy
         i2ZFMeUL3fsd2Zyh3KGsrrJPqCQeCHCo1VclUtRRztsjVdu80qXLGAHHsR9BfH23rpdH
         qzbQ32PXGlo6sZLGiqEPCbtc01lzsyM0kePBOn8ZSqjGVtAyLOWffaX/Er76aox1gGbD
         NMYffKgNUh0/l4X/fYfxT2XSo+0z02fOcT5BoHwm/lDIfo9ctjD588GkFx40ri1aTG0T
         t466TSP6bDfjAzcOcRWSQyasqQ9xnnoP0geGWx93PCeBGB0zEk37SAM6CMloXMbxoK8W
         jz7Q==
X-Gm-Message-State: APjAAAUEn2ERYLMAKUguXwHVYsqsREbG97y8zXE+/4gOCjFlByA1gq9D
        EGJyr/h4E7pogemhJuj4Ybe51mrZjnqfpPM2m5BIdRM=
X-Google-Smtp-Source: APXvYqxzi23DyKw82rtIFLPKa8JTOtmgIzOfe55fm7bnRsvmD/O2Rdo+GgLq+37DDw1Yw2f1455ae7Rjjq3V65dmEI8=
X-Received: by 2002:a2e:5bdb:: with SMTP id m88mr52053611lje.9.1555616315892;
 Thu, 18 Apr 2019 12:38:35 -0700 (PDT)
MIME-Version: 1.0
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 18 Apr 2019 12:38:24 -0700
Message-ID: <CAKywueQmp3yLuzz8+6WfC2MoT05xVGRDSSAeBQUiwpSaeY9NYw@mail.gmail.com>
Subject: smbinfo: Add bash completion support for smbinfo.
To:     linux-cifs <linux-cifs@vger.kernel.org>,
        Kenneth Dsouza <kdsouza@redhat.com>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please review the patch from Kenneth + my changes squashed:

https://github.com/piastry/cifs-utils/commit/dfe497f9f51983147a7caa69f62bb6648ea507ec

Useful for a better command line experience.

--
Best regards,
Pavel Shilovsky
