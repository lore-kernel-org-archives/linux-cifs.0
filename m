Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065AAC07E95
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 21:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E40E961CB0
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 21:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhGGVl4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 17:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbhGGVl4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jul 2021 17:41:56 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB2FC061574
        for <linux-cifs@vger.kernel.org>; Wed,  7 Jul 2021 14:39:15 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i20so5681293ejw.4
        for <linux-cifs@vger.kernel.org>; Wed, 07 Jul 2021 14:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=g1vae1LG3FtwFOOixlY8qORrKvBAmcy0KxE/TDC1jC8=;
        b=k6GlaBGZFtLaspd2Yl/ab0P7fBh5zlwMPermxEKJ4CLJT5z9y5I7Iv31PqyzCfN/Bx
         aiTWtD1VNSXN45b1aCbcd/9YtHb2dWVrnoSU5szGsf8s+9WbXjajck36jFSDHKYMyIy1
         MwSJWUcnm12POrMlLTaNG3R0xKAEs4qU96yKnQjKO9rttTHjM88LDIb6hbJOMKqb3bC+
         wAFCHpdboyLFgZTxaNmrpUqLwO43Q/zDlIYyIVnp6Z0OGic20L0bLCPsquUsNZuxPjMz
         forOaJdqef6loHD6x2wgYTMWohN8Swath+DPHbaIqyxWQY3HGzCyxKlstEdL7g/1+Slc
         J+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=g1vae1LG3FtwFOOixlY8qORrKvBAmcy0KxE/TDC1jC8=;
        b=hjhjp56K2ZW2p05MUnDa49iSwYku1Fjmcj9G+ovC4dd/paGosdOyZHx259Adow6A9b
         kVWhQYY7M/YN+ooGxeRVfhGUwsUYS9qEGqBEsO0gGBP8BNXa4kiA+cTJDRaQUYE9ap4F
         2yNDW48LkJPXWdUFMGC4xNtzZWsqBDro8HP1TNDGXSUWE9f4aao+5/WaGr6gs0+VBGjl
         9anrOAFLi+Xiayec8DPlBMHyh6r1W5IX/QueIdDuvCGXzyXvN7KUEJ4dWfvLnoUqbH3Q
         XscPLRZHGJD+86ojU882L/kV+cBRhhmtAzKUbSDqQ61qRn+i4ixd+j9fXlGlFAYvERnm
         ySAg==
X-Gm-Message-State: AOAM533FPBHqWqMNpMDHfMq4JZ5KE8esAvXBAzPg7BVRJ1lR/xn+0ieN
        ZZAt98ktAMngMw/joj9nRSVmqVsTASEkzNvTnSd+PWBgg3g=
X-Google-Smtp-Source: ABdhPJxrIy4scqPm/dIjxCrAXKhbDoj6r5AJXbeKIT39cQ/BXSn1lC/q4I3FjNz5VZkYJpMDKS/qCvVr4aFhhTdwiMc=
X-Received: by 2002:a17:907:94d5:: with SMTP id dn21mr25662856ejc.124.1625693954218;
 Wed, 07 Jul 2021 14:39:14 -0700 (PDT)
MIME-Version: 1.0
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 8 Jul 2021 07:39:02 +1000
Message-ID: <CAN05THRJwQkqNQEZ5L8Bb070kJgFqxDxxc73w_eUk4QVr-RYog@mail.gmail.com>
Subject: Summer of code
To:     Stelios Malamas <smalamas02@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Stelios,

How is the project going?


regards
ronnie sahlberg
