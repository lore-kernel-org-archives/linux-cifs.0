Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD41C433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Oct 2022 19:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiJDTI5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Oct 2022 15:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJDTI4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Oct 2022 15:08:56 -0400
X-Greylist: delayed 484 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Oct 2022 12:08:55 PDT
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768E2558E0;
        Tue,  4 Oct 2022 12:08:55 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id CAACC8079F;
        Tue,  4 Oct 2022 18:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1664909946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=myIGBnfBacIG2+HWik5iZ7600MHQKUlDlQPLoFbcxX8=;
        b=Z+jJ47GsoCRk3wbcpVcQrV8XfZWlkR8lL3oB+/fogM5z1dR3mNRIGwP6ReWz4Lk0YeX36e
        oGdtEMAT8m0M6/KP5Eauwre+fIEIQy7QlUOqvW0PnlZU0P+sIYADe+5Ww2ypWiMEIdeLFc
        HfJPAl6ItKbFOw2BLBfqyDCRVhtVonxNbHSdqyZA115hohF29tSGJgiaiXgSd9CU678qUs
        a4G8tdM2eaNljBM+NjnoW4vpJFVt8snRqpZ2Mqx4pfoJ+UCGk0agmC+MaITtN2QRuWA7dn
        vOZZqOBdquVN5yEHr5AF3Un+bhHl1GbTIMdqC4QECmYOhknIIypGzvL6CUzzTg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com, kernel-janitors@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cifs: remove initialization value
In-Reply-To: <20221004062333.416225-1-usama.anjum@collabora.com>
References: <20221004062333.416225-1-usama.anjum@collabora.com>
Date:   Tue, 04 Oct 2022 15:59:55 -0300
Message-ID: <87o7ur4dp0.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Muhammad Usama Anjum <usama.anjum@collabora.com> writes:

> Don't initialize the rc as its value is being overwritten before its
> use.
>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>  fs/cifs/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
