Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09761C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 02:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5D7361039
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 02:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243853AbhIXCOj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 22:14:39 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:40845 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243877AbhIXCOh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 22:14:37 -0400
Received: by mail-pj1-f50.google.com with SMTP id cu17-20020a17090afa9100b0019e7708e61cso2789675pjb.5
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 19:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+DSfpXQ/WcIo0FOwCfueAMBbH+KcEJALLa1vl8lhJhU=;
        b=yPGQGIKkCJ8QD6sKTKkLDyUg8IObrbGy18DZzDs68Fu5ZfnkNXzXT2pi/3J73pEWvO
         XI0xPFWPn1Zuvt1081kl1biLlmnk0xrlp3aQyrkIHGV5e/x1pvAA320Ab6AjcS73SEmW
         duQ6xZmQ1a7hSk9Ld1cm4OC68w8DkZNnM42esdnE7eaJtEAzlWLfnccdOMEAmRoIYjon
         oxUuNfl/Rc/IBPbI9kHgYYJtMKRHM3Ap5nBNQ3d/Yre2x41H2wSs+fgFE07eLizphqST
         3oKX/KmkW2pWtHdHOE+pCmxpSjBCgMZ+NGhkHFJueE4VDPK3F37XfZoLLHkMiL8X+f0x
         TCFQ==
X-Gm-Message-State: AOAM532lt+5h3kUhrhUg7UEzLceIKikQVqJVfl0sLQse3Ho6N41USwnL
        b84uUDO5neOHy3NgUiVysuY+kOCd/dY0rw==
X-Google-Smtp-Source: ABdhPJxC13epIBxgC86Utbuby4naanf80L2VM2j4y6bnpHljJaAAZwJQq7iCnjImuH3qZumdtv9j+w==
X-Received: by 2002:a17:902:d902:b0:13d:9b9d:a5f0 with SMTP id c2-20020a170902d90200b0013d9b9da5f0mr6690687plz.25.1632449584329;
        Thu, 23 Sep 2021 19:13:04 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id c16sm6724746pfo.163.2021.09.23.19.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 19:13:04 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 0/7] a bunch of patches that have not yet been reviewed
Date:   Fri, 24 Sep 2021 11:12:47 +0900
Message-Id: <20210924021254.27096-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

These patches doesn't have reviewed-by or acked-by tags from reviewers.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>

Namjae Jeon (6):
  ksmbd: add validation in smb2_ioctl
  ksmbd: add request buffer validation in smb2_set_info
  ksmbd: check strictly data area in ksmbd_smb2_check_message()
  ksmbd: add the check to vaildate if stream protocol length exceeds
    maximum value
  ksmbd: fix invalid request buffer access in compound
  ksmbd: add validation in smb2 negotiate

Ronnie Sahlberg (1):
  ksmbd: remove RFC1002 check in smb2 request

 fs/ksmbd/connection.c |  10 +-
 fs/ksmbd/smb2misc.c   |  83 ++++++------
 fs/ksmbd/smb2pdu.c    | 288 +++++++++++++++++++++++++++++++++---------
 fs/ksmbd/smb2pdu.h    |   9 ++
 fs/ksmbd/smb_common.c |  43 +++----
 fs/ksmbd/smb_common.h |  10 +-
 6 files changed, 299 insertions(+), 144 deletions(-)

-- 
2.25.1

