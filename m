Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A08C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 18:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbiCGS74 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Mar 2022 13:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbiCGS7z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Mar 2022 13:59:55 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D054E388
        for <linux-cifs@vger.kernel.org>; Mon,  7 Mar 2022 10:59:01 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 0C70A7FC42;
        Mon,  7 Mar 2022 18:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1646679539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tPsSDyi001VRuYuOCAY/XhKw5EoUkT0naEkLXgOeRgQ=;
        b=fWg2i8PqP7qLATXKTFFoV5GBGNESJir+JeB5ysgh3SgJTuX8FL0LD5B64NNTAsqOMVosNp
        QHMgYDUp3dqygHX0eXya/bWgJhqUahB95sUnBHKeYRkW6lJJVRLJnCk3VJ5n4spjMtkiBD
        ZmZb22csoP8zws5puUM9jEjenPXgJc5cPCAj/0dE7c8NzAfJ9dmQwCAOw7opwnjloq3Nhv
        8F5yga3aE4Hng8Nql22hhE98nPE94AFus9V/aYf30dz0KLgCQ1ptx6z6w6ZlMK64Dr6uNM
        JnPLDvp/yGVrgAkZuVDpw079PW+qaMez4k1Rdc7lAPXbyXRiXTKg2f8dMEDHVQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: [PATCH][SMB3]Adjust cifssb maximum read size
In-Reply-To: <CACdtm0ad+byeGwcpAmLCJWoyyXjJeu=6ZX=QODa0fgxs4X-iyA@mail.gmail.com>
References: <CACdtm0ad+byeGwcpAmLCJWoyyXjJeu=6ZX=QODa0fgxs4X-iyA@mail.gmail.com>
Date:   Mon, 07 Mar 2022 15:58:54 -0300
Message-ID: <87h789bndd.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rohith Surabattula <rohiths.msft@gmail.com> writes:

> Hi All,
>
> When session gets reconnected during mount then read size in super
> block fs context gets set to zero and after negotiate, rsize is not
> modified which results in incorrect read with requested bytes as zero.
>
> Attaching 2 patches, one for releases before 5.17 and other for latest.
> Please take a look.

LGTM.  Thanks Rohith!

Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
