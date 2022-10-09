Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B8AC433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Oct 2022 17:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiJIRy6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Oct 2022 13:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiJIRy5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Oct 2022 13:54:57 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6545810FDE
        for <linux-cifs@vger.kernel.org>; Sun,  9 Oct 2022 10:54:56 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id z197so2104426iof.2
        for <linux-cifs@vger.kernel.org>; Sun, 09 Oct 2022 10:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IBh62/aTZrNHpsBn0GWFOFXp6hkgA+v74AXJWJlRAe4=;
        b=AlM14uxD0zJIby+AuM6IPVzvs0jlyBrrtWrTzbjEwxsmoG5QES/mhDgFEIYnmEexF8
         J8t+kJWhKSemt21k0ZI0+RecnDeZ6fjXBiipPN5hcvGzLQfcq2YA6um+QwBMbXplhujk
         Y+V+arWe0r6DEGQg6xHsQ+BUujI4ZsJ6IjiCEUrDu5Iqh3QMe+n2lB0VXQjmjaYFa2BR
         fHIs7Kf8VTZY0MhNGZrxM3jNcLaLbM2oqHRTFrJMOKkjgBtgDfWHug/ENuQk3C3cZ45z
         tVNT46lBgGkY3eErlvO1k3fVrH8eoFMBU9Od7OPMgoGk+56MO6aL2Q7VfNsOnz1HN0bv
         4Anw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IBh62/aTZrNHpsBn0GWFOFXp6hkgA+v74AXJWJlRAe4=;
        b=MfDRY4y1NCyu7KZbhQRjtn1oHs/Y3DeuR368xsRmAOGMIzj6/A2PxKeteU2jwH6b7l
         47L8IWDAig6vvyLLiToABDyIiL22qZBx+oE88dWQuaubt3LOAiA0ByHq7EZDOgdP7xa6
         /I08cEKjqL/Huu6rIcli3ncp1fqCmahMMcn5qu9man4lzgeRTTL4R/wpoXOyvBB+yzGb
         cqZo1+przolSDcBSsYxkS/TbV951gTSzs4CH95GRs/kmcAxnZjXNNrFagk+OtU9ursyI
         XqbSWCF0m0v7i/8KF7u2qMVckpe22W2eT94YBGrzJqRvz+xFChCjngLSVgDI7IydiL41
         eScg==
X-Gm-Message-State: ACrzQf3xRRxBNqkfc+aSB3tSbsjMx8hH7it8XQNrXjUusOzA7qaHeAEf
        iU+X4GADyoy/TqfYTxwxl8IXX2bZcC/6MnV07k4=
X-Google-Smtp-Source: AMsMyM6+5I1HujcVeiR30JYkG/a1sIXccqqolNT9PrT1k3AKJ9sMNhHRurm1MLkD60gWwdRMApMcI1fNbYiYjyV2L5U=
X-Received: by 2002:a05:6638:2385:b0:35a:623b:b2ca with SMTP id
 q5-20020a056638238500b0035a623bb2camr7678513jat.24.1665338095698; Sun, 09 Oct
 2022 10:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <20221006043609.1193398-1-lsahlber@redhat.com> <20221006043609.1193398-2-lsahlber@redhat.com>
In-Reply-To: <20221006043609.1193398-2-lsahlber@redhat.com>
From:   =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Date:   Sun, 9 Oct 2022 19:54:45 +0200
Message-ID: <CA+5B0FM0t5vF8oHCbhc8Cj3vQ6eUas3WPFH7d0RmqC2c+TRAbQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix skipping to incorrect offset in emit_cached_dirents
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Make sure you're not re-introducing the bug where the first few files
are missing when mounting the root of a Windows drive.

See fix https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/cifs/smb2ops.c?id=0595751f267994c3c7027377058e4185b3a28e75

And bug https://bugzilla.samba.org/show_bug.cgi?id=13107

Cheers,
