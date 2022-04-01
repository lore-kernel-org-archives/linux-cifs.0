Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3E4C4332F
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 16:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349065AbiDAQrM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Apr 2022 12:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349680AbiDAQqx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Apr 2022 12:46:53 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E61174BB3
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 09:30:42 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 918EA7FC23;
        Fri,  1 Apr 2022 16:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1648830641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CG2zwHhVfZ573PBghlhgxWW0gcR67KSLHZxD5FMx47Q=;
        b=DGj0akri1d/zrkOONj/LRn53s3u+i2vDHVW+v2IY1AL70NTuuDrG2LQTVf+Uaz8Zs7fPS9
        QYl3SVyuiYappLZldgkeXWY8jbRDc7rXLHfSP+LXC4FBBY0NJPoODIF/Kb24ccl+8MqzQP
        aflC/D8ZDXUs0CvLPE7T9MUDU1UPJV45kZr61A4PX8nWtROyoPMD8sC1mGzL2M+CQac3Pl
        0Edadj4IOvZXn2C+s3NGwByvo9QGC1oeBvS7uOcq9JPaYOpee0LOlplOYeOe8iwlefij4y
        v9oSsd1KvOa7Mut5d/2aCVm+0vdo1L7/ElsYNJp+SgHME1zUTpLbnfLF/mT40A==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 1/2] cifs: fix potential race with cifsd thread
In-Reply-To: <CANT5p=qBK9wUaxxbEHmaqQ1J=dNC+5=HuxOzyPyhCr0uLzoYGQ@mail.gmail.com>
References: <20220331180151.5301-1-pc@cjr.nz>
 <CANT5p=qBK9wUaxxbEHmaqQ1J=dNC+5=HuxOzyPyhCr0uLzoYGQ@mail.gmail.com>
Date:   Fri, 01 Apr 2022 13:30:37 -0300
Message-ID: <87ee2gg40i.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> Oh. Did I miss these?

Yep :-)
