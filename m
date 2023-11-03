Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F430C4332F
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Nov 2023 20:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378250AbjKCUcd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Nov 2023 16:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377822AbjKCUcc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Nov 2023 16:32:32 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D724718B
        for <linux-cifs@vger.kernel.org>; Fri,  3 Nov 2023 13:32:28 -0700 (PDT)
Message-ID: <3117a7bb50531c6f47f44b41a3404d02.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1699043546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GdtF9tnUWvVdIZvFli+jXu0JyDwWGwKXV5cBQwUe6CI=;
        b=Dsi1zDHKjLe4u2wxmk3xl/zuCIxxpoMk/Sk4iRrnxYmCMI/nC6J0PF4FresrbgLddtWo7W
        IOeZSnVeewoSeEOiL3SUCNkfINPt8ePkQiYPQua/rwWqCH7+gULlDjtor/z+wQdFoCgNER
        70wWbQBfid0S8LhH+sLQRNup/pmMJ1EhmMgy5RKg9dRASIxLXsJacxKsqK4AZKkt846c3F
        T+P7JY71L+qYhohJXGWrM968YHeiGs+HCkUr/JTj9lwlEP1Y4P6ahvdfoewPzlEHFg4s0a
        jQjdgWjLf8SBW+GN+6jue6Cp5aszNEXZ6IhxHIRKdG4BLXdjNJSfLlWSUPtAcg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699043546; a=rsa-sha256;
        cv=none;
        b=VJMxwkce5kGMAszk6TmUoQsCzWcf3ek5HXut5QkoxsXHWQ6o/kuZ+zFLpRontwI8CPYGIR
        v02fvGbAFnCPfYy5nSwV+2677J23bhtnGTAxEc8wZecE4UhRfWvtiP23KleGoMcPtUaqBw
        gScmlMEZi1i/c+M1FSbRKUwPKC57zXUa+zNCPPuuymSC1d4is3o3actzpAtHXpHdjyHjZ6
        jHOjDA38/g9CuJJP2TCzcdA/Egp0MgScNx1aqOr7g9kz+uNDz4RZROIS3gZlQFFWY5JiA2
        Y/nk1PfW1peJE5DiI6kYdocgbinrIrGLEa5vwugwxNrVTyARMywsTtiLSOBQoQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1699043546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GdtF9tnUWvVdIZvFli+jXu0JyDwWGwKXV5cBQwUe6CI=;
        b=IRMtkSNpkaCx+B3N3994kCdnALe4XHElw+Oo5mmNcQcmwtZckCkeNhK4AmX1oIGqcRGvuE
        WDR2RKwBSpuRE+Xi0d9JnjH79zJRKg9/crU3cbY56yjSqsHjp40t9xS1nGd/XmyWy6p5Wb
        FTVvjIIm+3hjZHKnlFkkhgyX0uYSkM7tr/1LP5h4FYjd0peF8EbNuKLdISGmDDGWcjfzQb
        +mOi3fDA2Ynd0E9WEnZ2/SuRjfaSkirIcPYEdg86MNZBiLM8+v09jqQ0Uyyks2lbJ8YM6W
        Z0LbKjUmXkni6tbWKZUBYyMS7cx7Kwxn3PNBClA5EmJw6+PVsAS3aygyUgpw7w==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Steve French <smfrench@gmail.com>
Cc:     nspmangalore@gmail.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 11/14] cifs: handle when server starts supporting
 multichannel
In-Reply-To: <CAH2r5mtSZGJJYqFK1N+uT5gcr8vkUhLdYNE_VQ3nP67XxnnpPQ@mail.gmail.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-11-sprasad@microsoft.com>
 <b709f32a96f04ff6136b69605788a2e6.pc@manguebit.com>
 <CAH2r5mtSZGJJYqFK1N+uT5gcr8vkUhLdYNE_VQ3nP67XxnnpPQ@mail.gmail.com>
Date:   Fri, 03 Nov 2023 17:32:21 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> removed cc:stable and changed
>
>> +                             cifs_dbg(VFS, "server %s supports multichannel now\n",
>> +                                      ses->server->hostname);
>
> to`
>
> +                               cifs_server_dbg(VFS, "supports
> multichannel now\n");

Looks good, thanks.

> Let me know if that is ok for you.  (See attached updated patch)

For the s/cifs_dbg/cifs_server_dbg/ change, it is.
