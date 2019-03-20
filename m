Return-Path: <SRS0=fxvP=RX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE15C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 02:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DDBF20854
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 02:20:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dJnOx6/Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfCTCUf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Mar 2019 22:20:35 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:45015 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfCTCUf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Mar 2019 22:20:35 -0400
Received: by mail-pf1-f181.google.com with SMTP id a3so718373pff.11
        for <linux-cifs@vger.kernel.org>; Tue, 19 Mar 2019 19:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=kI/VJEefOKkhX5A+DiwzkG57XHtXfHJkWk78ZBrhuEQ=;
        b=dJnOx6/YpIkWob3/lAsPG2Zn/Lc9CWSHLZpdEl+1Fi5RCPKStCGn2o4aHtgfqyFX0I
         qwUxypoGyTnJcbnrwyCfNq269z0pB3NowhGEpW53Ums3RBI/rE/RD7R0PlxbJK+K7zuW
         eziMsL0ruKGrGsgtN3WB+xUCKAWIxegtBAkAP1V7y+1G3HSxM0kwsfQP+RQe/YC5vePf
         Op+c3iGWZnoJF+6LXd5rl9D94jNMcjwQ/Jjlk/xSe2hQcolxxrN9OmHOxuTLMZiF+YEM
         B27P/xahD+ilQ/KBuF312QMfgvtSCe11SodFEv/qZskpX3Q7VNg28hGcvdt1sCoLZhjn
         7k+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kI/VJEefOKkhX5A+DiwzkG57XHtXfHJkWk78ZBrhuEQ=;
        b=Q579oF2KKEPtA7JnprKxEdFoq8lTa4kaVrX15kDFDiAhcYyqJL0XBzL95OHloPhv0f
         jdqn8FZN+WTn/q1h1L7V29Viy1uncO++9qRAfxgXXBJh5Cq1PjbNRUWvOfQ1COLlNCKN
         sswich0b4zy6QSCQmdpFBoWnaHaOZ9sZW8RNrBMyUsUEQQIJT7voZYFCGjz02le/tJJc
         UQtDSILu1uEL99Scl3PTvgkiVo6Ox2c66m46QirkWYi3QCTGRHjK9zyXiKQ1lM+jaB7N
         DjfbmhpG9lXinG+vhIRqdtnrVSjBuatXom/ASU6gEqw5G+4AmdNYfA49MeIjtzltOgit
         UrAA==
X-Gm-Message-State: APjAAAUOqXFBCL9BD7+Yoe3WPz6AcvRKG2dVRca3NYG6f3NXHNYidNgv
        5a/wkXR5w0Zt3bvS9P6OfaRJ7a1mtqgxOrx3HQJUkQ==
X-Google-Smtp-Source: APXvYqwMNVGrsQFZzSSctfp+BtZ05Qb+uL2qQCkIHEoRIdrDfpVIu6PbT76ur6UTrn0xCoMAsLvihpYx4NvZDVKBISY=
X-Received: by 2002:a17:902:e090:: with SMTP id cb16mr5093282plb.32.1553048434508;
 Tue, 19 Mar 2019 19:20:34 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 19 Mar 2019 21:20:22 -0500
Message-ID: <CAH2r5msUqScwN99iUnyEKBYOic4fMCpnjFmc=dfaJJax0XnxdA@mail.gmail.com>
Subject: Buildbot cifs/smb3 testing improvements
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Just added 2 more tests (339 and 450) to the cifs-testing group of
automated 'buildbot' tests, and 3 more tests to the Azure group (339,
450, 451), and thought it would be a good time to recap the progress

We now execute:
- 89 xfstest subtests in the 'cifs-testing' group (various servers),
some repeated with various configurations.  This is about 3x more
tests than were executed  four months ago when the buildbot was setup
and we had our first successful runs.
- 17 tests in the 'DFS' group
- 78 in the Azure testing group.  Just in this month we have added 14 tests.

Our goal is to continue to add tests as we fix more bugs and add more
cifs/smb3 features to reduce the possibility of regressions (it has
already been useful for that and caught a few potential regressions
before merges).   This is very exciting, and made possibly by good
work by Ronnie, Paulo and Aurelien.




-- 
Thanks,

Steve
