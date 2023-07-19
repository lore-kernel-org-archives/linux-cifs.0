Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2712C001B0
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Jul 2023 12:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjGSMKa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Jul 2023 08:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjGSMK3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Jul 2023 08:10:29 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE81CD
        for <linux-cifs@vger.kernel.org>; Wed, 19 Jul 2023 05:10:27 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4fb7373dd35so947911e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 19 Jul 2023 05:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689768625; x=1690373425;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vmaonLwle4iGjmO5RX6rjiBnY8idmNLRJP/wTo8xvVo=;
        b=mwjCenXp83Uql07Ak2pVse3O74g0ttg8mKLQrSQD51WFX/FE0zkVgVjxmvjewUwz/k
         cI/rwGttTFblmod+o1NCom6B14i8QayK2EreixoPJRhXu0/RwU27uYIsgW9FsBqXVydX
         wvwr9Gp+zeDAylC6NdUfaI7zZPQjkaYFnTgnVWyCrl4xngd/lS/HMxsOCNvzN7q6Sp4D
         VenWJkqObYX3ZVnzy9ZhCfe++N1GoqAtPt0TUFl6bDOSjP8Q2FqgDJDyDPQrFBfX8yeR
         4dDvwBt6J6aOE3TGbwfoyLAqpKigWFMHohqlWNJMX54ScX0tYc7hCwNRdvY9xs3RBnKw
         j97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689768625; x=1690373425;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vmaonLwle4iGjmO5RX6rjiBnY8idmNLRJP/wTo8xvVo=;
        b=Ezzu89tvkDb7zs/eMETnH+/D8NhNaCKOdo6/5J65wkEa113Vr+t56/P+Aj7KRH5vUv
         zZ6V/je4nf5ivhgIKhJe8b2oP2plY+GMayYN6noSi4/0QFQgfkYXwKMS1Zrf3mmetANg
         LAFF8dHsBhFk1uFbwjh76svaDUKu95xeXl+pUIgAwnn9G7dMYOkpd8bi6HPZzFc1hENT
         LgA4biMPA3PSWDUtdedn2rNzZUuYS8JVgZc9/1zVBo97NE6r4EwLRJWLRgSGJg/KK2u5
         3xJwRn36l7e1rMEWso+m7Sr/vAco6zQDcWuYjqsVoL46h8OKx03J/KsPwu0l4hlO+zWL
         dMJA==
X-Gm-Message-State: ABy/qLb+2ZokpbYEekhY+A4C1t/bNQXuRzzavbQefOqwH6IO1LhegUTU
        9xGoZHaciSUMxwSmxUuPPL/fjOL7WDyXnorWwxXx0AbK/yA=
X-Google-Smtp-Source: APBJJlG7Lw6mIND90XtHrN1BDAb0YIzapA5qVMPkqpavcT3fr13o5aBlH9hdmfXgBITy7sGV9RHB/IRo+ZMkENyygJg=
X-Received: by 2002:a05:6512:130c:b0:4f8:6e50:d6d0 with SMTP id
 x12-20020a056512130c00b004f86e50d6d0mr476391lfu.31.1689768625244; Wed, 19 Jul
 2023 05:10:25 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 19 Jul 2023 17:40:14 +0530
Message-ID: <CANT5p=po=GSwj+bD_-uFWZ0r_ww5XbaV1pAauZecbmuzShmcpw@mail.gmail.com>
Subject: Potential leak in file put
To:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Bharath SM <bharathsm.hsk@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, Tom Talpey <tom@talpey.com>,
        Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

cifs.ko seems to be leaking handles occasionally when put under some
stress testing.
I was scanning the code for potential places where we could be
leaking, and one particular instance caught my attention.

In _cifsFileInfo_put, when the ref count of a cifs_file reaches 0, we
remove it from the lists and then send the close request over the
wire...
        if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
                struct TCP_Server_Info *server = tcon->ses->server;
                unsigned int xid;

                xid = get_xid();
                if (server->ops->close_getattr)
                        server->ops->close_getattr(xid, tcon, cifs_file);
                else if (server->ops->close)
                        server->ops->close(xid, tcon, &cifs_file->fid);
                _free_xid(xid);
        }

But as you can see above, we do not have return value from the above handlers.
What would happen if the above close_getattr or close calls fail?
Particularly, what would happen if the failure happens even before the
request is put in flight?
In this stress testing we have the server giving out lesser credits.
So with the testing, the credit counters on the active connections are
expected to be low in general.
I'm assuming that the above condition will leak handles.

I was thinking about making a change to let the above handlers return
rc rather than void. And then to check the status.
If failure, create a delayed work for closing the remote handle. But
I'm not convinced that this is the right approach.
I'd like to know more comments on this.

-- 
Regards,
Shyam
