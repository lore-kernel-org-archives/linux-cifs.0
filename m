Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5393AC4361A
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 22:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AEF82220F
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 22:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbgLCWHv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Dec 2020 17:07:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727832AbgLCWHv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Dec 2020 17:07:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607033185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=iYDvFu7oq+VNXfinrxVzBP1V7iQyhHiGi7O53/9TY2E=;
        b=CGv378sjySzU6hViSXWgMMjWwncxxMUiX7lc0k9i7FhdAOtwJnDiYK4VYYh/An4mIethJb
        xTKotz/WF7NkrDdb3HlUTLXAmo+D+2NCqbgnTj3f8TtOg9jS8Hzxik4sK65LJlCwUCGeQ/
        YTlgoOCMAXcmmjhov+gICOb/t5r7M6Y=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-mNJiXPKRN1eiepXcakIS-A-1; Thu, 03 Dec 2020 17:06:23 -0500
X-MC-Unique: mNJiXPKRN1eiepXcakIS-A-1
Received: by mail-pl1-f200.google.com with SMTP id 1so1964641plb.4
        for <linux-cifs@vger.kernel.org>; Thu, 03 Dec 2020 14:06:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iYDvFu7oq+VNXfinrxVzBP1V7iQyhHiGi7O53/9TY2E=;
        b=jf2o0B5YaP4tRq8goUqLlxBk0x1Zw2J6WbWRi7u9PelxMteE5dGIen0g/WKg/+JnjF
         SfoLQVZdDcUQf8/D7jKgoexjGGZ2I5BtV+V3p2ie6uVvnE4CdDRWLAE7rW5GIhKTIkqA
         SxzeaOpJL7PWFDbDfRkBg5zH9aJkSKjDMo1sh09Np6k5/EWl71PE2d41UHP+07Ac2Gr6
         7eWWnCfGbiyjoBKhjtEpkcWqYeN7LhBwX4+qr6jegeNjK87CY7prwaUMZbzttfW8TkJ+
         B6xvFp5ZLcaDqSt+x8hxBSpRd6SVLOlXYB2W2P2iC3HmvTOgDMLYm9cdMdaiwPUCbcWf
         nQ9Q==
X-Gm-Message-State: AOAM531ARppivfT6XRsMpAuECF1wGXnpEGHHM9cUrmSkr2uPBnVuhXHg
        OU4Lvg0Mve/hcwTvoZU0SDP25vA+aVw+38DAnY9Dcpg3U6WjOMuLYeHGoX9YWYutBJK0pizUnaH
        H5Dvcd9zWJGDUo54NgR4YG+O/6ZeMoXEoEffIgg==
X-Received: by 2002:a17:902:ee83:b029:da:3483:3957 with SMTP id a3-20020a170902ee83b02900da34833957mr929062pld.38.1607033182120;
        Thu, 03 Dec 2020 14:06:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz/fwijaLT/55TFevq6vVCLbmVpu2xD88bOwa1k0syU/KzRJi44jwV+UvxZJ5hU5tCMaSAgkDjhiR1b9KrAWNw=
X-Received: by 2002:a17:902:ee83:b029:da:3483:3957 with SMTP id
 a3-20020a170902ee83b02900da34833957mr929043pld.38.1607033181840; Thu, 03 Dec
 2020 14:06:21 -0800 (PST)
MIME-Version: 1.0
From:   Jacob Shivers <jshivers@redhat.com>
Date:   Thu, 3 Dec 2020 17:05:45 -0500
Message-ID: <CALe0_76k-ZTbQLMBNzKg+ZB8a2NxQ_Kf+Q9b5fovOv2svY8KjA@mail.gmail.com>
Subject: cifs.ko and gssproxy
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello all,

Is anyone working on modifying cifs.ko to work with gssproxy directly?

There were comments a few years ago about such an endeavor, but I have
not seen any further discussion in recent years.

Thanks for any information,
Jacob

