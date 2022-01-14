Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6069EC433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jan 2022 15:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238999AbiANPfG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jan 2022 10:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiANPfF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jan 2022 10:35:05 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C00C061574
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jan 2022 07:35:05 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id b14so12978059lff.3
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jan 2022 07:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MwJ8R2oTObTzziEZv8lw3nFHQcARiYIWZ5lFRYKxVaw=;
        b=Yf9ZU9A7sg1c2l9v0VfyzlPgLEJyl2X2c4p73K9SkP7i1KXsZQpoirnf0WBNiRAXOr
         TG6upwj50yl3W9rKrHHv5uiiTIMZX2NhR+bIhEzNNbFRWCDeLF3yT32MYFvC08dig3ZD
         f8QhPMsA0yCFnXTYK7llZIl6L+sSDzhqXlgo5Kc5szwR9lP2OD09WVpkfC88ANNxLAP4
         HIe4JEfWLtNWnzszQVa2KuQiKWxedXX03j2JoqHn8PY65uxnIi7wwpSN7udLCjR839qV
         xjAU1fHrlT57lvqXQNRHWyDjVtrwsKSP3CyWZYSLFqFPjJ/FHtSvPZjm0LmfFCny3hdV
         YJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MwJ8R2oTObTzziEZv8lw3nFHQcARiYIWZ5lFRYKxVaw=;
        b=GW/Gg1nigLAMTqBYkhglHCPVHDjuvN7SH3+FyHxxSU0S4D7Tpa6TtcT9SY1a34KoZH
         XBivJXzYohdeO7Lvk3l7sFxP0uBV5aKNAFAp9Iz5cX6odO0WhMCVU4gaHAXQp8M8cv+X
         7KQhwJA3hRw1lXSGV0fk0BlRPLRMZdezfjQVaWASFtB0xNVbbz/Zf+mSp2O/Rwr3Ug4T
         udVf1dj9eix1qwZepSpAycE3ViQIpnf/CiT1FJonk4gEUNnxWlMHvaT5pQq2I3cZ0ObQ
         ym7k8GQAJwnN6TfSjSxBVKxt+wGkLKBtlgnGUWJmXhX8jatR7pc7VLhGov11wAnoY43a
         fUzQ==
X-Gm-Message-State: AOAM532dgDLna3/Swc3BGEv2gJtPovhXXBAoYHzh8j/eNcsQaNEUkjtC
        dfmT45DXxqo2QxNZ0tuFW6T4n8Cu6TZKAgQJS7Q=
X-Google-Smtp-Source: ABdhPJyiNbNjqSwBaGfr8+OvZvW1+LbRbWTES9WZSjOrArl1/Btq4A8Rqd+++UwFANEA50L/KKBR/0G6gEkNybAPPcs=
X-Received: by 2002:a05:651c:1503:: with SMTP id e3mr4358226ljf.460.1642174503296;
 Fri, 14 Jan 2022 07:35:03 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 Jan 2022 09:34:52 -0600
Message-ID: <CAH2r5ms=ovpeBFtW6oyYe2eoFVb5tku=nyngbG2cR16yUKPqQQ@mail.gmail.com>
Subject: Multichannel patch series DFS regression narrowed down
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like this patch from the multichannel series caused the
remaining regression we have been debugging

cifs-check-reconnects-for-channels-of-active-tcons-t.patch

compare failing (with that patch)
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/3/builds/156
to without
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/3/builds/157

-- 
Thanks,

Steve
