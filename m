Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A1CC48BDF
	for <linux-cifs@archiver.kernel.org>; Sun, 20 Jun 2021 14:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72A9760FDB
	for <linux-cifs@archiver.kernel.org>; Sun, 20 Jun 2021 14:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhFTOJD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 20 Jun 2021 10:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhFTOJC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 20 Jun 2021 10:09:02 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C1EC061574
        for <linux-cifs@vger.kernel.org>; Sun, 20 Jun 2021 07:06:48 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m15-20020a17090a5a4fb029016f385ffad0so5853369pji.0
        for <linux-cifs@vger.kernel.org>; Sun, 20 Jun 2021 07:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ipimp-at.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=MIZ4IrXwklzlgHap85uS8XNy6DOxw0AKw1+AJlAIzmg=;
        b=d5XebYlxy5kTvPeITKsr52Ctmig5wUd/mM2bBppI33toL96BZMv2jXvfoQdhQxQ/RY
         G7wI6Hgyc6KtDUZunQ3kW0+SS38bIIkNKU9NYJtPj1VKaV9Rf5sWsQGyeKRS0jNibNDR
         armNYr2svM2unbn8SmKi0ZSotwfSxz/1qkQNCMhy2V/ZjbMEmlpqGdg2ypLTQN2xB5dO
         vM+REfNSb+1YV86sPiCI7KrLIQr86IF9scrractSTfPP7CxJAcF21WWAuXYBFwr2JHje
         ouGRxv/azRMoCpjHYYpGfEccsayfoT4/OeZS7xx/MND7y6q6AjL9otEqtTfwD7Auo+xx
         qtHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=MIZ4IrXwklzlgHap85uS8XNy6DOxw0AKw1+AJlAIzmg=;
        b=jFPXRzNIdDSzixSGGatJoJVRIOQGsLrrPdqB8IG1glGU5XF32TffS3i1+p4GZZ0elt
         ZBQKYSGRsp+P7yMru8ZRNQp0zQcWOv0B3q5CsRw4HK52n5zj5Zf8gN2w3Cy+2FNVtYNB
         EA/hfkI5w6pQPM8x6hBeYiB/Y9yvMA1vCput+jDocNCiBGfX8QO3AqGhg67WW3hGLdp2
         qhhXXd2NLv4cHlyL98mihKehutbKW1JLKWWgadw2d35nTzIBV2CA7OuAUZq2sE011sOc
         zPL4loncryOrnJdsoRFXX++PiRmgHVfIF/8x45xc6DynyzpOjaMgetmlAWZv2dfDgQ0T
         TTyg==
X-Gm-Message-State: AOAM533UqhiVQXDFUKB+UL+wtrvZzmgcnYXhdhuq1oKa5NqfnrEiNqLW
        f6yQ5xsa0/JgKT10wNeS7nstfVAxsWNZsPi1cy0Ja3FQRWJcngjs
X-Google-Smtp-Source: ABdhPJznwJYkKLJYVY1xVEmaupB4VFudefFritGGDIWZy1bVgU6NmWPeDjsTFgs19Md0TXcKywiax6f48Bpn+xYeRgY=
X-Received: by 2002:a17:90a:8407:: with SMTP id j7mr3030319pjn.13.1624198008257;
 Sun, 20 Jun 2021 07:06:48 -0700 (PDT)
MIME-Version: 1.0
From:   Kim Henriksen <kh@ipimp.at>
Date:   Sun, 20 Jun 2021 16:06:37 +0200
Message-ID: <CAC3UJ6mbUA1Q2wDKgjoXuyp3GuCHWMv7vfhypX9az5KtX-_z+w@mail.gmail.com>
Subject: Problem storing credentials with pam_cifscreds on desktop systems
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I wish to store CIFS credentials during login on a desktop, but I've
hit a brick wall, and my google foo has failed me.

When I login via the desktop environment no CIFS credentials are
available, but it works fine using SSH.

I have tried with Ubuntu 20.04 and Fedora 34, but same result.

This is how my Fedora installation is configured:

pam_cifscreds.x86_64      6.11-3.fc34

I have added these lines to: /etc/pam.d/{gdm-password,login,sshd}

auth          optional      pam_cifscreds.so debug
session     optional      pam_keyinit.so force revoke
session     optional      pam_cifscreds.so host=<myserver> debug

From the journal log when logging in can see the credentials gets stored:

gdm-password][3362]: pam_cifscreds(gdm-password:session): credential
key for \\<myserver>\<myuser> added
sshd[2835]: pam_cifscreds(sshd:session): credential key for
\\<myserver>\<myuser added

But I can't see the CIFS credentials in my desktop session:

$ keyctl show
Session Keyring
 882498672 --alswrv   1000  1000  keyring: _ses
1026128626 --alswrv   1000 65534   \_ keyring: _uid.1000

But when I login using SSH they are there:

$ keyctl show
Session Keyring
 145928652 --alswrv   1000  1000  keyring: _ses
1026128626 --alswrv   1000 65534   \_ keyring: _uid.1000
 802829928 ----sw-v      0     0   \_ logon: cifs:a:<myserver>

I'm not totally sure, but I think the problem in general is related to
this: https://github.com/systemd/systemd/issues/1299

-- 
Mvh.
Kim Henriksen
