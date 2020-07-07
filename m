Return-Path: <SRS0=GU4v=AS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910A0C433DF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 20:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 625F3206E2
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 20:34:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ofgwMqvG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgGGUeW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jul 2020 16:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbgGGUeV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Jul 2020 16:34:21 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B15C061755
        for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2020 13:34:21 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id x8so15211072ybl.9
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2020 13:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=kFPtBp2z2J80TGNsXlDuOtbMWozUBeFLAaSp2vzNxvY=;
        b=ofgwMqvGAdHkzjs49RNoBErYljSct7Z5DabOVwGUV72+QLCIRYhJpl6JviDluHcYvH
         /nZ+ZG20djsNjVyQ3y27TF0LWiRyATSOSMc1GZ8K+ZQUoD4HdZl0fjE/+TnjtkXWhB0d
         kyUvuJGLKEnBIwZdo9QZCCEYvNcSMHM12d9HJFhr7YFUgMEpxkFX5rZK6UbkkA8EXujo
         o9VWg6mNWqIg5/XrA73mXnppj2K6OlIOvquZPTU4taphb5vyJx08GqH1cIG+3UQEX4Ug
         GqzpQxiYPHzgA8GqaeKRfwVnMD1gQhI+PQrzweW7VJSVWVAymsEEKzJT9Esr3CfUtjM0
         RtVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kFPtBp2z2J80TGNsXlDuOtbMWozUBeFLAaSp2vzNxvY=;
        b=somCB0lTwmE+Vyf2k/edWonWzw2hDfFxw047ifgVbC+ufC1puKERKCvaVVBzeeX4WU
         yrzjU/oZx6Gwt/reDwbzpUG/U4d3tzan0rGs3nBY+h1evwn76OVapIork6sBLcZWQt+S
         e3etVug2IkBo0SClF2f6n/qGbzx3hhpMKR22DXs2rRpaQrJHSks/ClmqiSHvkRndjYwA
         xymnI9kA+wczt8yDgTDcl8/tgKsmO2aSjssjcwBfwRGlR9XABKvQ3JU/ll4LITVZneV1
         cHycJ5VrczTcAfN4MAK5BZ27E94aHKwGUmaqrXDZnoIj5WqYdG+ODEFlqQP0WpZBTnvr
         84sQ==
X-Gm-Message-State: AOAM531OX/oH+vmc2S+QTUOcvjix+23Q6yOpnSPgCJB9H1LkGNV9HEnU
        S2csQVDBdf1iQV7v1/A6bePt9TODgpOcChseLAlBxhTxPcc=
X-Google-Smtp-Source: ABdhPJxG3aZNRqlna1Bv9AWhUozF1fs95CGqEwny6x3an4kP7hDyOQPz4N8ddtk1NbUlswCR0gDOTFvZqPesAdewAu4=
X-Received: by 2002:a25:880e:: with SMTP id c14mr95026028ybl.376.1594154060756;
 Tue, 07 Jul 2020 13:34:20 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 7 Jul 2020 15:34:10 -0500
Message-ID: <CAH2r5mua630UJzeBR6zRhdkTEc_HoD8=q9PZ5inL9fDR4RQsBQ@mail.gmail.com>
Subject: added more xfstests to buildbot
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

With recent fixes over the past few releases, I was able to add 8 more
tests to the Azure test group on the buildbot today.

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/258

Regression testing continues to improve.

-- 
Thanks,

Steve
