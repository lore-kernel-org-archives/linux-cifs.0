Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E523C4332F
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Dec 2022 14:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiLHOhi convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Dec 2022 09:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiLHOhf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Dec 2022 09:37:35 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E967998EB4
        for <linux-cifs@vger.kernel.org>; Thu,  8 Dec 2022 06:37:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1670510248; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=WGApT2pjVLO1Oh1zhXCM5PCVdYE9cQrYUqO2dGf7owUq+e4nkd1JPl8otU7tyodp3oJ0mxo4cu1ozCYjyoxS2jcloMPIQIN2loiLlqP2shrqsmkAS7uW/KdfnmuIi9dCb2AIxTm1u2kvSNMvF4cusQ5yDShEG+fPoUUZE9KtCg0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1670510248; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=fE2eNoycUgwMonuSawbWtVQycMzmPI84vxYtU+cPL88=; 
        b=KDQ/gGbALgHDmweDKeP08Kh3HD67kXb8mJercfKAxDHbUu+NCza6STNZE5/LmArPVuqTOGH3kGAKV1S2We3r6JlBe4IOGXrQ0t0WZD6+0W+aIcR1gD+4RnIlu6CE15Hk4ZUq6IzYtqmxPG9ymLBTstL+yv2DJvChFig84o3ZtRE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=business@elijahpepe.com;
        dmarc=pass header.from=<business@elijahpepe.com>
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1670510246336179.21975604112652; Thu, 8 Dec 2022 06:37:26 -0800 (PST)
Date:   Thu, 08 Dec 2022 06:37:26 -0800
From:   Elijah Conners <business@elijahpepe.com>
To:     "Steve French" <smfrench@gmail.com>
Cc:     "linux-cifs" <linux-cifs@vger.kernel.org>
Message-ID: <184f22b79b2.e9886f4b3844359.8233249662719515971@elijahpepe.com>
In-Reply-To: <CAH2r5mtSWPg7gwa5L79jyAwas3k2eMjqp0YTJ-wJi+fshc-9tA@mail.gmail.com>
References: <184ea71e92a.115993f353574592.7325889929528068981@elijahpepe.com> <CAH2r5mtSWPg7gwa5L79jyAwas3k2eMjqp0YTJ-wJi+fshc-9tA@mail.gmail.com>
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
> Paulo mentioned that this doesn't compile if config cifs root enabled 
Is this about the arpa/inet.h import?
