Return-Path: <SRS0=Wu2L=U5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C45C06508
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Jun 2019 23:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 520B7208C3
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Jun 2019 23:03:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uMcisYKr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfF3XDW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 Jun 2019 19:03:22 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36452 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727203AbfF3XDW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 30 Jun 2019 19:03:22 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so5577711pfl.3
        for <linux-cifs@vger.kernel.org>; Sun, 30 Jun 2019 16:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PrYSjdUDeYA+tm4/f+Dc9Fw5cvrHx54IHkr0k28cMow=;
        b=uMcisYKratZkHmYH0MKYm4+RQr/QHpLQ6TiMgLrCt/qPccJmv31hXjVkUJ/KHbAhhT
         1DToVyXyQlfnSEm4vd0oeM7SHNbPxEGqlqjSxerqC0PXmfrWNC/hoBJb+VPOnxCn1lhi
         iKGZ4ELPpr1xhnxsT0y+3CM1SLI18kyMgDSaCdQlT0wWRoMVn5fj5jvG6YM/3PiCa7+i
         5PnGRNcKdjF0nlCNEN948dq0FjTFayCipLt+asdMGouUbfUorqe6r5+IlNwok5B10xEU
         OeQ8JpoxAXhMSjQmf76jmY8pZ/QpqapO5mULeKut6zp1HUTEZsVMdiFzvWR+06ubyoPi
         2D7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PrYSjdUDeYA+tm4/f+Dc9Fw5cvrHx54IHkr0k28cMow=;
        b=LV5sDvJBLrIjrlTYc9M/ve9gqOdarST7aYLOWVdYywkhMnhMni5BTQPeluO3r1V9bN
         U2jWDH+nFVL8YRJBOqz4FUjuEyYWf0lYZYZRDy0zp4lvQVCX0MAPlZTau5e/7+EP2ZgV
         ra2Rm4gYNEytB14636xY3Sga6jMpisFWzn9IfhkKnCbhvZqTk2+rv4LrHZ3cA1xGDVnv
         sYzT+S4xzff3KOpcfybLGqTgFVrUHYmtFfrlYoVmRxFKquJ9UZ+tNyJVwziq/TOVQJ4d
         QTKGBlffkGm4oW7DNsJymdBOTjX8UJolF1ubX2gDZRJaA5yrl6kXG7PeliDn/RjtjfDa
         8iSQ==
X-Gm-Message-State: APjAAAWreTtS3eKEphGALs4g/FA4Xu3H5TXjFfhMsbRdE4xkyFxpWJb4
        lz3t+KwblttzYt6hSwjTkBnnSIW/9Kg2XLb6+XkRqAqW
X-Google-Smtp-Source: APXvYqyNAmEhgtBUpd2VlKF6xlS8Vf9eCnybk/EiOi11xW2SQLaMFFR0lAxCzmgcr7I0rER4FL9Yy+3hGtAjsmipgyk=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr26364180pjb.138.1561935801781;
 Sun, 30 Jun 2019 16:03:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtSKQtFRNHpiiPDqCwGGLNgooj_1zZiyG=5N+cpA0bQ2w@mail.gmail.com>
 <20190629180446.GA14534@roeck-us.net>
In-Reply-To: <20190629180446.GA14534@roeck-us.net>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 30 Jun 2019 18:03:09 -0500
Message-ID: <CAH2r5muQ8ga5EaCj5ccswJGOpood8HFKTsMDS_1chG-SKkQ9Bg@mail.gmail.com>
Subject: Re: [PATCH][CIFS] simplify code by removing CONFIG_CIFS_ACL ifdef
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix merged into cifs-2.6.git for-next

thx

On Sat, Jun 29, 2019 at 1:04 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Mon, Jun 24, 2019 at 01:47:16AM -0500, Steve French wrote:
> > SMB3 ACL support is needed for many use cases now and should not be
> > ifdeffed out, even for SMB1 (CIFS).  Remove the CONFIG_CIFS_ACL
> > ifdef so ACL support is always built into cifs.ko
> >
> > Signed-off-by: Steve French <stfrench@microsoft.com>
>
> This patch results in:
>
> cifs/cifsacl.c:36:15: error: variable 'cifs_idmap_key_acl' has initializer but incomplete type
>  static struct key_acl cifs_idmap_key_acl = {
>                ^~~~~~~
> fs/cifs/cifsacl.c:37:3: error: 'struct key_acl' has no member named 'usage'
>
> if CONFIG_KEYS=n and CONFIG_CIFS!=n (eg arm:nhk8815_defconfig).
>
> Guenter



-- 
Thanks,

Steve
