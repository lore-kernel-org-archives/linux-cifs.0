Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0ADAC433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 14:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B285460F9B
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 14:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhIZONy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 26 Sep 2021 10:13:54 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:37600 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbhIZONx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 26 Sep 2021 10:13:53 -0400
Received: by mail-pl1-f172.google.com with SMTP id j14so9926486plx.4
        for <linux-cifs@vger.kernel.org>; Sun, 26 Sep 2021 07:12:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lKzSMOtDJgCQmEZpZxoIamue2VEdKi8EZahRa0SDfQg=;
        b=MD/HYYp3DmsLn9c9b+sZJfw67FjzlksYnTzlrsOv/wD1x9yLv7woQKaqLlT6HoBal5
         DzdMhZpYDI/QKZPoT0PS0znSg4sgG+aB89SrHVAtkdmohx9y1jWYiPFhW/TL4cNer9xL
         Kio2y5ikW1DPLSLrJr9cJveZVSYaRhyF6L+B4sVBmp8Jtuy3LPecIm497sDz+Za3pAkt
         YqfxyxNKD2lJEfikJII3B0YhjGJrimJShosK/Rnn5VBIum2wk6tTx1g8TuMKnc9srYV1
         68shqzTRzLsNBjzkVL8pdgh8utIwzZ7k/ot7Fo/y/T7JG+wKB1SABx3dwTagj7QHgz95
         +sPw==
X-Gm-Message-State: AOAM53257W+bGdlhmiDqRn9P9+M1Dcu3NmS8gaFD231s1K6sdXE7AIae
        1BX9j2FXKV4i40kOfJPPcWEL3glWRRytOw==
X-Google-Smtp-Source: ABdhPJz2JvnAXmMhSe49C3kyh3yZkPVeQBPr+r2aXdW+hD4oMUbSCqZvh6GYN3zWlBaE0xHutUoA/Q==
X-Received: by 2002:a17:90a:384a:: with SMTP id l10mr13758638pjf.168.1632665537019;
        Sun, 26 Sep 2021 07:12:17 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id g3sm16521742pgf.1.2021.09.26.07.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 07:12:16 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 0/5] ksmbd: a bunch of patches
Date:   Sun, 26 Sep 2021 22:55:38 +0900
Message-Id: <20210926135543.119127-1-linkinjeon@kernel.org>
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

Namjae Jeon (5):
  ksmbd: add the check to vaildate if stream protocol length exceeds
    maximum value
  ksmbd: add validation in smb2_ioctl
  ksmbd: add request buffer validation in smb2_set_info
  ksmbd: check strictly data area in ksmbd_smb2_check_message()
  ksmbd: add validation in smb2 negotiate

 fs/ksmbd/connection.c |  10 +-
 fs/ksmbd/smb2misc.c   |  98 +++++++-------
 fs/ksmbd/smb2pdu.c    | 295 ++++++++++++++++++++++++++++++++----------
 fs/ksmbd/smb2pdu.h    |   9 ++
 fs/ksmbd/smb_common.c |  38 ++++--
 fs/ksmbd/smb_common.h |   4 +-
 fs/ksmbd/vfs.c        |   2 +-
 fs/ksmbd/vfs.h        |   2 +-
 8 files changed, 321 insertions(+), 137 deletions(-)

-- 
2.25.1

