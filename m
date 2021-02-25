Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8DFC433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 03:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8294164DE3
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 03:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBYDe7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 22:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhBYDe7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Feb 2021 22:34:59 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9D4C061574
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 19:34:19 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id u4so6455990lfs.0
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 19:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AIAz/VfVa2e0Qx0gVKsUSt7nGxn9emJF12l3bmaFm4E=;
        b=eVzYXBiXXdF+okICAzZEV/I68zdIrHR+K+5ZM6FV6/MvGTl4KxBVlYQmwi9XHUdpZt
         UxramxJfF4Q66xqRRSQa/3zA5/QdvV+V5G9x4tO8lqeVCfXSzfYcF3W0u3oAJX3jDM3N
         UIwEStthxPJDV9vTLPca9t34KSCVcNHKS/tU9EJN4OVkA5cOgNKdal41QtR61S6XCB3l
         rv3pz+18dPwWpTpeduuYzQo5yvOlc/h2M+I10nrO2eIPwonGOCWVrzLPXldAG1IeEVci
         MSu6hRAtd51AQ3GUuxqoSrvOpwt5rtjr1rusMmU4akVBpcc7YuJN0Za3XJG3dBLp1L+I
         EjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AIAz/VfVa2e0Qx0gVKsUSt7nGxn9emJF12l3bmaFm4E=;
        b=NsC7ahpAHx9GPf7+y2rxmbXic0ihd3FyfjZmd6jto24xiNYFC+r6YYF+cGxlPgekKd
         fL6GU/5d1qXYxqRMDl9moFsfMn8sbe+IfaFfNz9TYhvmkswEyIqVMZZmZ7xAatwAQPwj
         QgavH34UF5QmOdytCQQUlqDM31skMxrmKDWOvxGoJ8VduqMf3toH1dhss6QfLrgR751O
         ixrn73DxQ03I8Ef8Z+ROvFEZfKnpcN9F/lwsXOXelrNaWqnINIS9iXtyyDfthJnvaN+8
         +sk3SGRGLBqZPIQtPAHipjhyPDIZdHTriX2GNnXi77SqDA0Q/vPLPkJEq/3wvmJqm2NC
         n7hg==
X-Gm-Message-State: AOAM531gOLRkhyDzZZ9fJEtV9R7vKR5qhVVDAy52UKXETmBo+McMKlYS
        VKuA18XyrVEjT//IVPGaQEoPROwy5gRxRDH0Yg1PWgq3B0Pv1w==
X-Google-Smtp-Source: ABdhPJziDW0rskCTrmVbS72GUNRWo+RdNLpL5QsPsCUFLAonq0cHcb86WBwcY25sWLIWemclg+hFAD/zq6e7Zwk008E=
X-Received: by 2002:a19:404f:: with SMTP id n76mr727444lfa.184.1614224057491;
 Wed, 24 Feb 2021 19:34:17 -0800 (PST)
MIME-Version: 1.0
References: <20210224235924.29931-1-pc@cjr.nz> <CAH2r5muMt3gmmtLOBxaOqqh-KfccSDDuta6ob218_w9WQZdmbA@mail.gmail.com>
 <87y2fdszy3.fsf@cjr.nz>
In-Reply-To: <87y2fdszy3.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Feb 2021 21:34:06 -0600
Message-ID: <CAH2r5mt3HTJYi=TP0YF+zPfYrN0Qj56rK0grMbodsN8Xkdny+w@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: fix DFS failover
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

git diff dfs-fixes..dfs-fixes-v2      showed no differences between
the two branches

And should we cc: Stable #5.10

On Wed, Feb 24, 2021 at 7:23 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Steve French <smfrench@gmail.com> writes:
>
> > is this series of 4 identical with
> >    https://git.cjr.nz/linux.git/commit/?h=dfs-fixes-v2
>
> Nope.  Please pull from git://git.cjr.nz/linux.git dfs-fixes



-- 
Thanks,

Steve
