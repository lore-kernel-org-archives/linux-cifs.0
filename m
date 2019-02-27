Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57625C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 07:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22D6E218E0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 07:22:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+7RKWww"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfB0HWT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 02:22:19 -0500
Received: from mail-qt1-f181.google.com ([209.85.160.181]:36246 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfB0HWT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Feb 2019 02:22:19 -0500
Received: by mail-qt1-f181.google.com with SMTP id p25so18129485qtb.3;
        Tue, 26 Feb 2019 23:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=pKbodIVwEAcda2QcL9Gz9CST4/wGs4tV1Ytz+M+lt48=;
        b=G+7RKWwwVCz8yKVgDfQAWx4igiBNLJgdE7zwzRy3ljOgk8B+k+lydhJ0X2J7tJOvHK
         O2/QtTKm5n9ljrX2fmTOcWEVkgrtlPmS5C32j4u7cUDVbpIoNUS8O/GMvtGdiSvSNz2d
         9afboNU6LOIG5d3wTsKIxlEcrYA/fiZOdDWrpyGSmI2r7vfySoGR+yK5WjXk/C35UEvo
         AB3VCbLpimjQzL1gnddZuY/a/h5qWfPHGQ3RzQLH3rduN285ovxNHXBSlzaXh9RXYs5p
         YRTRGfQH40A/mSbqTEm9DloRaX+Etc6/8Ut787D8VOkDecJSo92tJJy1BjxG9tKJXHbz
         dH4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=pKbodIVwEAcda2QcL9Gz9CST4/wGs4tV1Ytz+M+lt48=;
        b=FEP/AUYpumr2k8MsyBxYSg7zLVSfg8zMZOsDgAhQ30aIrQ5GATB9xrE4r7L7DrMmEv
         a/EHYSkEm25j1Z6wU6p7Z+f5Vs00b9vWqdGBGC09jEIgy1XQlKZE0qzteBMd48gyJVZG
         V+8D0qoee49NkdV9evAzogPLuCpJ3rQwnpUz54UDwLDa33+Kmqn1d9mQ+uVDgVnLk2G1
         rHEuEfI+sDJyYbbLeyd8o4uNUZrOi2I0SPZT868aqIY1Wlf4YLd2XTkfcnA+4ypLvqJl
         3pre3bpAxFmfZN1xqfoh4+BdvAGrEnNUxPRd5OAZy5zt0HBekP7xH9Yxj56GsJOekUrl
         mrGA==
X-Gm-Message-State: APjAAAWkoNbfbc89Lz8ZTDMn4+I6+js/amD36nadYemtKAM0JDpnYiB4
        g2u9e3dUwxNsRLbPEDDHrXdOt0kI9qs+LTaJJe9GOwMT
X-Google-Smtp-Source: APXvYqyIA9w2c9OyrAqDOOdjFHcQuc7Ux4DjxC8hTo4KU9rV7F1glvKNbAZgSqodW9eWR9KhNBr5gzt0v0p+GDEyYSs=
X-Received: by 2002:ac8:31cd:: with SMTP id i13mr513547qte.77.1551252138247;
 Tue, 26 Feb 2019 23:22:18 -0800 (PST)
MIME-Version: 1.0
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 27 Feb 2019 17:22:07 +1000
Message-ID: <CAN05THSpSLnGF84S0a0+qu=UHw8HArKbuChmP7usRqKNChNC8w@mail.gmail.com>
Subject: [LSF/MM TOPIC] Using buildbot for automated testing of CIFS.KO
To:     lsf-pc@lists.linux-foundation.org,
        linux-cifs <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Folks,

I am Ronnie Sahlberg, CIFS.KO developer at RedHat.
I want to come to LSF/MM to talk CIFS and network protocols with
colleagues in the FS world.

I have an idea for an informal talk I would like to give:
"Automated testing of kernel fs modules using buildbot. Experiences so
far in CIFS land."

This would be a practical presentation showing examples of a system we
implemented recently
for cifs.ko to have a standard set of tests to run to ensure quality
and (hopefully) avoidance
of regressions for the patches that are sent to Linus for the CIFS.KO module.

At this point we are starting to see very promising results on fixing
bugs before they hit Linus tree.
I would like to show and talk about how we set this up and why we did
it this way.

To see what it looks like right now, this is what I think will go as a
pull request when the next merge window opens:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/137
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/98

We have already started to add these kind of links in the pull
requests we send upstream.


I would like to talk about how this is set up, what our experiences
are so far, has it improved out quality and our confidence that the
patches are good?
An it would be trivial to reuse for other filesystems if you want to use it.

regards
Ronnie Sahlberg
