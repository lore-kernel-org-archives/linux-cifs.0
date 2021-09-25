Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B424C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 13:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55B7560EE5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 13:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245011AbhIYNSa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 09:18:30 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:33394 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbhIYNSa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 09:18:30 -0400
Received: by mail-pf1-f181.google.com with SMTP id s16so11448331pfk.0
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 06:16:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QFcSmBDBuSV5kFF0eQo6E2LKc3Ts8RyOo14lNjAFqDw=;
        b=ui9sFyEBV3LdLiQ6pqSfzBClglofZDtlOu+eitio1o82jX8Zrjc+INy5FT0O3VT5fj
         9890KlmRlveZjT1C7nEGXm/pfLuDpQAnAnCn3fU0aZicn0LfS13dc8pv9qiZVbC6xYb8
         ihd9xpFFA1SlGbhWsbv2J2csFfggpzIBJkq64Q598FmDlqPQt8nF9/El8equDe9vsWcw
         hMKVbI3pZLkrZUUsr75bBcjyfTEmgeS/LjC/U3aolXX0ybS5+F8lf/N0IizgDGkwGTBY
         ttlzYByVzq99pCRUuQynO0NNt6dsVh970WVzMgGbPU2k1qeKAWgLczf3ZGJlwiOGaKht
         Eycg==
X-Gm-Message-State: AOAM5320w6ATae0zh9L4MoR8M0DdebbNmDfI0SOBV8I4mY2TIT9nvyAS
        9+6KtBmdEp4TkXRKI/uYVqIJLh+j4M9S2Q==
X-Google-Smtp-Source: ABdhPJwSr0MvHakRFVC21oKfR8qsW+BcfxsmRQ8FW+s12zJpTO6GNJDxzCk+jhWI3PthPOHPyCG6Hg==
X-Received: by 2002:a63:3483:: with SMTP id b125mr8254365pga.35.1632575815543;
        Sat, 25 Sep 2021 06:16:55 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id x8sm4714698pjf.43.2021.09.25.06.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 06:16:55 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 0/7] ksmbd: a bunch of patches
Date:   Sat, 25 Sep 2021 22:16:18 +0900
Message-Id: <20210925131625.29617-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>

v2:
  - update comments of smb2_get_data_area_len().
  - fix wrong buffer size check in fsctl_query_iface_info_ioctl().
  - fix 32bit overflow in smb2_set_info.

Namjae Jeon (6):
  ksmbd: add the check to vaildate if stream protocol length exceeds
    maximum value
  ksmbd: add validation in smb2_ioctl
  ksmbd: add request buffer validation in smb2_set_info
  ksmbd: check strictly data area in ksmbd_smb2_check_message()
  ksmbd: fix invalid request buffer access in compound
  ksmbd: add validation in smb2 negotiate

Ronnie Sahlberg (1):
  ksmbd: remove RFC1002 check in smb2 request

 fs/ksmbd/connection.c |  10 +-
 fs/ksmbd/smb2misc.c   |  87 ++++++------
 fs/ksmbd/smb2pdu.c    | 300 ++++++++++++++++++++++++++++++++----------
 fs/ksmbd/smb2pdu.h    |   9 ++
 fs/ksmbd/smb_common.c |  43 +++---
 fs/ksmbd/smb_common.h |  10 +-
 fs/ksmbd/vfs.c        |   2 +-
 fs/ksmbd/vfs.h        |   2 +-
 8 files changed, 310 insertions(+), 153 deletions(-)

-- 
2.25.1

