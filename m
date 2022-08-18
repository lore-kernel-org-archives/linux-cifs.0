Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA23C00140
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Aug 2022 16:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344738AbiHRQYU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Aug 2022 12:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344773AbiHRQX6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Aug 2022 12:23:58 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEA5C5786
        for <linux-cifs@vger.kernel.org>; Thu, 18 Aug 2022 09:21:22 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id cd25so836985uab.8
        for <linux-cifs@vger.kernel.org>; Thu, 18 Aug 2022 09:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=AEqOwroMB9DrIpzZbrcXQrY+3mRzpaNkX6QZ74Bceuk=;
        b=EwTfJWv0LqcKjNNl5GP4hgiu7OHdYVld0dAGmPBl77tC++H0C0UEzhzDxRwDWkFgcJ
         VNhms85yjF1/cVTWgltZuNZJXQql1OgUGr66O+A682sC9MC1tlq+6pyw/R51dJbZNmBE
         7H04ZoIAqfN738ioP3IWhpnEtwlRvKyC92J8OzvgyMU1fwgbE+suf5NX1AZm+kXfKJ4C
         37UEL4MBtlha1RzgX4IuxLm+iUKR3ZYlOxueCwWMkA1eZrr3G7yA6nX3g+74j5nSjVG3
         H9Zkmxh5R+9XuuCcJDmjODtsrfgsP0jsIFHbf7cQ3RN1d0DuHHeY4g7pEtTJfsvbF9bR
         suKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=AEqOwroMB9DrIpzZbrcXQrY+3mRzpaNkX6QZ74Bceuk=;
        b=QM+xogAF8lt8cGDQHRfcLVfjnXvY/rAfAzBMU7/eeDRwF1JNBbOPEaOVnCu9d16i9v
         TSYXr3klNd86HkUdRBRKBgX9eQNL42RQ5HJhd9HBMbk47oQsbIFD1xKzMnP2gEVH6eQ7
         0/5HZABE1GpWVdXOL01QX9rxVcvzkqPUiZBL+Upb/UuP3L5ezWO0mgHntB0C9tFaPqj1
         lHPpm7pMkT0wQK6cJ7biF5TZrYMebBl1nxQo2oC4JVICuv7Xj4ThAgPFSjeustU4LHME
         u72lPvBQJSkm3yqTou7OxOB+z7AucTiitV653BfGdN67XiY3NxIM6b7jY8WYTTrMyZ60
         1GFg==
X-Gm-Message-State: ACgBeo2wkZKgTfcQuK2jZhUGpA/bBdVb5KSfIg/0fgofdKBLX41T4DAV
        Vl1E97jQ1rPwJyXoeO55ti+W4+IIqRiOX4JgioY8Fpbp+pw=
X-Google-Smtp-Source: AA6agR5vn5KLb3sueUZ8LCnN0BmzADGmJtktDxrb8AFOZ3DNdoCbZvF+hu4vJqkUsLOBC8USXPK3M1fkJssNLQYUKRE=
X-Received: by 2002:a05:6130:10b:b0:37f:a52:99fd with SMTP id
 h11-20020a056130010b00b0037f0a5299fdmr1385264uag.96.1660839660692; Thu, 18
 Aug 2022 09:21:00 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 18 Aug 2022 11:20:49 -0500
Message-ID: <CAH2r5mupcJD89SP4SqOmTLSABQ0kStyWF9EU-eMEuyZ_uA7G9w@mail.gmail.com>
Subject: mount.cifs man page
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I was looking at the mount.cifs man page, which is missing
documentation for some mount options, and also could be made less
confusing by moving some of the less commonly needed mount options.

Are there good examples (of better written man pages) that we could
borrow ideas for a a breakdown by section, etc. ?

-- 
Thanks,

Steve
