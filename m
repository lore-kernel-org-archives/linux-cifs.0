Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255EAC433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 01:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD4C360E98
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 01:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhKDBgy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Nov 2021 21:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhKDBgx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Nov 2021 21:36:53 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79545C061714
        for <linux-cifs@vger.kernel.org>; Wed,  3 Nov 2021 18:34:16 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id d21so8769330lfg.7
        for <linux-cifs@vger.kernel.org>; Wed, 03 Nov 2021 18:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=2xSiPmaaY3nwmwq2M1AVpBl1qKKCGd8yyUvtsynOkao=;
        b=Vjvb9OLuU2KgKOx/Kxcet6cIM1ICSeB+s5Tte8N7e1z45VpMt+zl3EW+DgRGi1qvlU
         lXgUdRTwRIjNCjJVi6OUMbIZaF+++ihYjLAN9eFh0L0qEHoKQ3tKVWIGiZFTmYfCXc6S
         DftCy0JyzO0FJ0E2cab8SuJtcqFLmPwTwJECCd00o52Y3v/kDDUsKBwsL7i4VfPXyzl8
         D9CzJ/jfdISo/wi6dBcZ/+TpoHTyW09BE5xYW9ZKVyTNpOF5GQFA25McUXLFLMqLij13
         gYZ1+3yTz1sJCUp+KZj6poeH0JeRWvjnJ/swc2XIoGK6RkiTXVAOYLc4IN3Jk1oBwdOw
         CJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=2xSiPmaaY3nwmwq2M1AVpBl1qKKCGd8yyUvtsynOkao=;
        b=dEspPH/JbzQ+5EZRNs20HxTd8jXoGqmR98dIZBDzXoWQmva+J6y7kznc+imXFSkV5g
         +2YOrXKlo2MgtXGFUO0WfFnOnIoq7m4JmpP3wQt+qi8fkI2jBUWXQUMVy31xXQ31h9Z7
         JnKGarlvxpp363pt/ITd8U/g9LxfkPChLQyLpXGIx9ufZ1iIwVaS39GMo14kJmC5Awbg
         3Cmid+XtXIQK/FpsXll3V4E3vQZEMmpr9GvUXL1B6VGY9HiPA2X15efJkUl+z0vHxtpw
         70Jxj1chr43Aq852JqCbXNPeOftdldVbgm1YR2TengbW1eps8vGM1pVESyPIZsaxcRf/
         riwg==
X-Gm-Message-State: AOAM530dXNMz7CVCvsRLnKco4QpRlulPGaFsf9tSLeUegkZbaPeR8vEY
        bHCQcekxoaKw/6xF0WJvj4uaZwR/tjqQG3lrenNkFtztU3U=
X-Google-Smtp-Source: ABdhPJwaCAQ7jA6LrKm2QLORtjhL5i9Yv/yqXix0YCsDDJMavpVRxvcvFkugjeLj43RbxOSPtUbEwTUMu8EUckDKBN8=
X-Received: by 2002:a05:6512:3763:: with SMTP id z3mr44997895lft.601.1635989654412;
 Wed, 03 Nov 2021 18:34:14 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 3 Nov 2021 20:34:02 -0500
Message-ID: <CAH2r5mtfC9kQiZBx82mP5EEWj_qZ3GEB_Fh=sXW2_qAVKe5YLw@mail.gmail.com>
Subject: netfs and folios
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

With the recent merge of the folio patch set it will be VERY important
to understand its impact on cifs.ko and what we can do to better
optimize our readahead, caching and memory management to integrate
with the new features of netfs and folios (and also Dave's fscache
improvements)

See https://lwn.net/Articles/868598/

Ideas (and patches) welcome ...

-- 
Thanks,

Steve
