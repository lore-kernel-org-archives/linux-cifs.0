Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE277C7EE2F
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Jun 2023 15:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238591AbjFLP0P (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239839AbjFLP0F (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Jun 2023 11:26:05 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE87310FA
        for <linux-cifs@vger.kernel.org>; Mon, 12 Jun 2023 08:25:57 -0700 (PDT)
Message-ID: <a38028f0fbc7d6abb1f118f110537f21.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1686583555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kctYlrDJSBi/RMyFyKmZJEmpX8yp+0+NBlXXKahXv1w=;
        b=RtZQz7K1nN0Pa2i+PME5SDfhoO7sYU8p7Bnl4xK/TlXC2Cm2iwG3AqQltTTCJa8N7Jf1Hw
        JdwXYMdF/V+XX4X83IZUq0B2hwdspBntTdMylply6JIhOCAB6DqBVyYxVdUOv4oti1PI/N
        xRWT+uqOp6brrPCYviBNQIZN44KNYd9E+XI0ojahMIsNe3Hwo+oddF2Bs3qfRJPYeDWx2f
        TZPOde6p+b7OBY2vK2mz+ZpREFSbWoNuYtWgjtlf4ZmErbjk01zDsxAeYrbeYtXRSM41e0
        /fNiKnmL0XPrSXEpIUKbH4ZXdf7tWOn3BmMEwVP617R6h/B39D602ZI6CgXpHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1686583555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kctYlrDJSBi/RMyFyKmZJEmpX8yp+0+NBlXXKahXv1w=;
        b=BY/XdLG900lR65k+EFzy3K7to5gS8ZlZ29HFTblw5dQNBaYu4UOgI1ypd074DgFtfE5enq
        yZUyxJcScs2a16CB9rLApjd8fN91kiXoPB/KLyPulNPmB/GTrkoEM5oAxUsr5L+gCYk36b
        QyVC+yGJrC476PpcEDz6NmGOWWMrUm2sj84VTYv4LMgpNujUIQzd88+vWzziM6bWYyDptG
        QVfgqvjfhgmvgeVCcrUgYbTcssLurNyroi/30Zaabm1NTSca8uI029fE9h0c6iuxuADfUD
        NPpS/NSVxlfR/KQU5DxF7HFNiJJMWTrqlpxwyo/neXheLTeWmgjVJ5sJ0t4Unw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1686583555; a=rsa-sha256;
        cv=none;
        b=gEdIN09RW82LfwBJR7zkVJ5r0iZgCRKrUx+YaAOkxpULxdCmORBc+7HqN+L0qvIdFjU+hz
        NCxf5vQzWI+E4e6lV5zKyFdoSmJg7iWeAruNvhGtfLk/3q9CwU/vDO/C1UVQOfaMy0j0zC
        +RiTavtkMzYdDdGypqyVOArGDGbnQQfbaQCG8lYI1caqoYK1C5xkE0bnq45V4EnpyD0JND
        gD//mzkp0V98t/1stu7ZSqoVR/Qij/Q/SPi3TuUw0/j++yhGNBAZtK0LjB0O4OmI7G7D7X
        qvorjVOgEmB/3qCYyINgUYxRTRUn2J1OR5UH8tsZRSCEW7IrfSM9G0DZqZq7Yw==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, tom@talpey.com,
        Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
In-Reply-To: <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
Date:   Mon, 12 Jun 2023 12:25:49 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> I had to use kernel_getsockname to get socket source details, not
> kernel_getpeername.

Why can't you use @server->srcaddr directly?
