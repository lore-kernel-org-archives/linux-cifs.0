Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FC4C352A1
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Dec 2022 02:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiLGCwB convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Dec 2022 21:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLGCwA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Dec 2022 21:52:00 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032CF54745
        for <linux-cifs@vger.kernel.org>; Tue,  6 Dec 2022 18:51:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1670381517; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=QTULXVl3rjHAs0feke4JnsHk92jfjktu5iXEg+F/PmGYkkzXIVAlpZzibkbmTq8rGhiZScRlzAcN7ax0xJUzIVuUC0HwasZkqB8pu1a73cSHyZSLPVjsE4VxAmZZq/Mk5k3BGBZ+XMusS56AuzByVwDFVMAd383CD6ZHjNyI7mg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1670381517; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=LIQh4lWIJ3KTrPvBNejec6IsGVCPC9aUSFmLjEMLnCw=; 
        b=bVeXzawsiqxdWoVnjCGADgMZ0vChtKL3LqBxpg3VrXgyB1KJr5I3mP+hEetN4nKQTcIwLmnTFStXs7R+ErLyoDVUG6sODLuCs07N4cDJFls/ynHtkIe8YNmnYzmIPOpuWNWsJhV6blGjCG9iYDCjUdfS6+x7vHJ+7D4UcYcLqW8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=business@elijahpepe.com;
        dmarc=pass header.from=<business@elijahpepe.com>
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 16703815153191020.9933551013826; Tue, 6 Dec 2022 18:51:55 -0800 (PST)
Date:   Tue, 06 Dec 2022 18:51:55 -0800
From:   Elijah Conners <business@elijahpepe.com>
To:     "Steve French" <smfrench@gmail.com>
Cc:     "linux-cifs" <linux-cifs@vger.kernel.org>
Message-ID: <184ea7f3229.f779c2443575501.2430157242177376145@elijahpepe.com>
In-Reply-To: <CAH2r5mtagKhCc_TxJfjVkuO92A9Nk6x3K39WAarzoHhyD_ZZyw@mail.gmail.com>
References: <184ea71e92a.115993f353574592.7325889929528068981@elijahpepe.com> <184ea74a423.cde30bf83574815.2767044741831621097@elijahpepe.com> <CAH2r5mtagKhCc_TxJfjVkuO92A9Nk6x3K39WAarzoHhyD_ZZyw@mail.gmail.com>
Subject: Re: [PATCH v4] cifs: add ipv6 parsing
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> Can you make sure what the patch of yours that I committed is ok otherwise 
Just took a look at git.samba.org, looks good. Braces fix also looks solid.
