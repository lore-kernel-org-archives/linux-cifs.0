Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DCBC3A5A7
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Dec 2022 05:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbiLFFLr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Dec 2022 00:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiLFFLq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Dec 2022 00:11:46 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8FD1AF3C
        for <linux-cifs@vger.kernel.org>; Mon,  5 Dec 2022 21:11:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1670303502; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=CGn335XR3cGMsRXe+g1oQ7iuaAF2+CSD6SkVTUxZVqGYHf0gcQhjWQx5z5+VsMP6fCgKBOYLdPr78fkbSwbQjkquwpdzNQQVDARMuctmj/xWmFBMGVxQjr1K/ZZ9O6ZnLY8uDpe9Fr1oOJxGXq/OwCtc7uAuFBy0JqfxuJfOJDI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1670303502; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ZCYDS5/8cHphWSjAc0lWftfZXmg+FqRsBHnECoFgw/c=; 
        b=e92JTzKY4gzal5Ebgp6MPaDOOVVj/X+JGYdVX5Fw4doL7pTQGwcJFJpGmIG8CnXbF8QOxtIodOUze3FmfHyMDhtwhqiWYJtZpxtqmYdbLtFibwq74mxsK303axlJotQMA8a7o+UerEy8o43PKJIFcgD/hoIt6HLImP/8jyJzF88=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=business@elijahpepe.com;
        dmarc=pass header.from=<business@elijahpepe.com>
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1670303501586320.83611412010157; Mon, 5 Dec 2022 21:11:41 -0800 (PST)
Date:   Mon, 05 Dec 2022 21:11:41 -0800
From:   Elijah Conners <business@elijahpepe.com>
To:     "Steve French" <smfrench@gmail.com>
Cc:     "linux-cifs" <linux-cifs@vger.kernel.org>
Message-ID: <184e5d8cd04.f37aaa493388081.3079516632009633036@elijahpepe.com>
In-Reply-To: <CAH2r5mvYhYfO10U8QbRVsx03VUnudv-hcQvtqyw4Qt+4ugGT9A@mail.gmail.com>
References: <184e4ae599e.dafedd623365931.2204914765704117230@elijahpepe.com> <184e4fef6ac.ef8cabb03371505.6462526642609891535@elijahpepe.com> <CAH2r5mvYhYfO10U8QbRVsx03VUnudv-hcQvtqyw4Qt+4ugGT9A@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix tabbing
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> wasn't this problem introduced in your previous patch?  Why not merge
> them together since this is a cleanup for the tab problem in the
> previous patch
Thank you. I've merged the patches together.
