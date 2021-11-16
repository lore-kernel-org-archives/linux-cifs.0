Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06CEC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 16:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A17E61391
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 16:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbhKPQpn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Nov 2021 11:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235813AbhKPQpm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Nov 2021 11:45:42 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB504C061570
        for <linux-cifs@vger.kernel.org>; Tue, 16 Nov 2021 08:42:44 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z5so30702570edd.3
        for <linux-cifs@vger.kernel.org>; Tue, 16 Nov 2021 08:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O6hqoCgsnDpjhHFqnzKNR046K7aAjfKcaLJ2N3hqKnU=;
        b=YS+YQ5OI6lB6p+EZ5hU3pdQiK3607TS4EYF/FFQ17+PniLW28P7/lDW/1UII4Zp+Cf
         Ug4GmDA2RfRHIpP8bxgHDkZjmFlb1mebOdwNKxYt4G40H72EIoxGy7xY1IVIrJKeMi9E
         XxXj6cLb5IxmpK9qMztoPyNyzhK8DPC03uZJU3b/bk02agbpqgxBZGdXye46Y3V9wAN1
         Pp1GWkkfcfHwVFWMHoLVofsob0MINzsB4/mhuJuH9PhrmNs/GmF9mfwqPsE57g/oVoga
         Y2UrJ2/i9m2hBsGP+KKdHwtc5bHjck6uYphY76H+tuHaSATc2tcML9FGE2G+coYVCpX9
         9EJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O6hqoCgsnDpjhHFqnzKNR046K7aAjfKcaLJ2N3hqKnU=;
        b=DbJHP9HbDHNk+046zme1Op55DS58r08EMIooalIkiBsPQDLkxtjzietVUIHK4QLHPk
         r6xriv6OfLlxc4ojeIJd8Mz1e8yyjH0n1KCm7qigcgxFrWmlHqvXqhGK+EWYtqqtSJeY
         COMsM5RErYJixPlUv0LTsC5RnV2g0zDCsseyWCEofkPZQldsYCyEOBvZ0aLpakwIQW+m
         QRZvri34b0zA/Cm1dDi2hB3EBSZITPrgE2Qn8MWbYbBA8hOdU/B0SQe+7n40a0qwmDDl
         RCUFYHs2PSKHnXi151u8/gQPy8SQU0E3DKHh68zZ3lIggmDU+9IMOZuLRnkYz0Z49Qbu
         6kMQ==
X-Gm-Message-State: AOAM530tbC/pN+BAe0o6wtPYN/gr+F26aSG48yYmfs/kpUmy2iGCI3TE
        CS54jmOyc5BIiw+j7gHMMYcm7Iv2aj85PxRT+2I=
X-Google-Smtp-Source: ABdhPJyqOD+XZtyQyEa7/42LTKd2L9tmcNwpuXvvDkZOQL0mP4Is3GZgLxp++MypQtze7ITgVSjmuLR3UgEsCyyyyUI=
X-Received: by 2002:a17:906:4c56:: with SMTP id d22mr11359484ejw.1.1637080963366;
 Tue, 16 Nov 2021 08:42:43 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msH=b0UCkxfXsCEHpqQxkcvJ68qUSD+cy6JeMYi17zsHA@mail.gmail.com>
 <87a6i415ms.fsf@cjr.nz>
In-Reply-To: <87a6i415ms.fsf@cjr.nz>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 16 Nov 2021 22:12:32 +0530
Message-ID: <CANT5p=p800shbvtRW6SYpfsp1c7p68i=XS1jT8sigZ6ydtZ=QQ@mail.gmail.com>
Subject: Re: [PATCH] trivial coverity cleanup from multichannel series
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Nov 16, 2021 at 8:59 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Looks good,
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>


Looks good.
But is this the only such occurrence?
-- 
Regards,
Shyam
