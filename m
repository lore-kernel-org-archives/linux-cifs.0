Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E16C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 08:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 435BB61357
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 08:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244582AbhI2Iqw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 04:46:52 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:34797 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244459AbhI2Iqw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 04:46:52 -0400
Received: by mail-pg1-f170.google.com with SMTP id 133so1999366pgb.1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 01:45:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jlCBKzDevIlm8CuYVuOrJh5B4SCvpcpwW09LiYgYvXM=;
        b=qaCtjcSyXRW6hJPto8Tp+WRiRvwCsUNFkjpX1aT+8qbIzpDnk8WmZagzHwxgVNMbOg
         aTa5CKtK55z6UqV/JPk0FJUycpE2WGT56erlTcNja9xV4t76KCDP4hS4t8WM0jWY7Jmd
         WpVUl1/wHtNW36ZXt2IfrXCTzXlG4Giup3hWeLN500MiExP0C8ckyn5elNblZ048QppA
         Mxdvw57OMPRNnDjA4BZBMtTj9SxdirYK4xbY9VtAlm6Ncw71p78RLd6fAqTKhRpf97rr
         5oWmeSqLaqrPQ1ujiHOhsTnJxIeL7fGAm6aItF/vmi7zff8dFH6/PUn95DxCsdMkiNOo
         9LZA==
X-Gm-Message-State: AOAM531+JL1/iReTcAn9DeLdqBuUfpPvewg5dtrIB1FR/2Pu+wOtkCNc
        oAPaa08ZesW844YAhRLYec41Gw8lVP10ug==
X-Google-Smtp-Source: ABdhPJxLeaSxpcwLexj6cCyJxtC+9eoo+sKGEQj04LnCeva6fWDqulHjwBLJR+vr7wcZ8JIaIONCrA==
X-Received: by 2002:a62:dd0a:0:b0:44b:bd85:9387 with SMTP id w10-20020a62dd0a000000b0044bbd859387mr4123279pff.49.1632905111003;
        Wed, 29 Sep 2021 01:45:11 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id q3sm1912344pgf.18.2021.09.29.01.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 01:45:10 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v4 0/9] ksmbd: a bunch of patches that is being reviewed
Date:   Wed, 29 Sep 2021 17:44:52 +0900
Message-Id: <20210929084501.94846-1-linkinjeon@kernel.org>
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

v3:
  - add buffer check for ByteCount of smb negotiate request.
  - Moved buffer check of to the top of loop to avoid unneeded behavior when
    out_buf_len is smaller than network_interface_info_ioctl_rsp.
  - get correct out_buf_len which doesn't exceed max stream protocol length.
  - subtract single smb2_lock_element for correct buffer size check in
    ksmbd_smb2_check_message().

v4: 
  - use work->response_sz for out_buf_len calculation in smb2_ioctl.
  - move smb2_neg size check to above to validate NegotiateContextOffset
    field.
  - remove unneeded dialect checks in smb2_sess_setup() and
    smb2_handle_negotiate().
  - split smb2_set_info patch into two patches(declaring
    smb2_file_basic_info and buffer check) 

Hyunchul Lee (1):
  ksmbd: add buffer validation for SMB2_CREATE_CONTEXT

Namjae Jeon (8):
  ksmbd: add the check to vaildate if stream protocol length exceeds
    maximum value
  ksmbd: add validation in smb2_ioctl
  ksmbd: use correct basic info level in set_file_basic_info()
  ksmbd: add request buffer validation in smb2_set_info
  ksmbd: check strictly data area in ksmbd_smb2_check_message()
  ksmbd: add validation in smb2 negotiate
  ksmbd: remove the leftover of smb2.0 dialect support
  ksmbd: remove NTLMv1 authentication

 fs/ksmbd/auth.c       | 205 ------------------------
 fs/ksmbd/connection.c |  10 +-
 fs/ksmbd/crypto_ctx.c |  16 --
 fs/ksmbd/crypto_ctx.h |   8 -
 fs/ksmbd/oplock.c     |  41 +++--
 fs/ksmbd/smb2misc.c   |  98 ++++++------
 fs/ksmbd/smb2ops.c    |   5 -
 fs/ksmbd/smb2pdu.c    | 364 ++++++++++++++++++++++++++++++------------
 fs/ksmbd/smb2pdu.h    |  10 +-
 fs/ksmbd/smb_common.c |  44 +++--
 fs/ksmbd/smb_common.h |   4 +-
 fs/ksmbd/smbacl.c     |  21 ++-
 fs/ksmbd/vfs.c        |   2 +-
 fs/ksmbd/vfs.h        |   2 +-
 14 files changed, 412 insertions(+), 418 deletions(-)

-- 
2.25.1

