Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0579DC433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E498C610EA
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhJAMGn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354266AbhJAMGm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:06:42 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8FEC061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=1xIhith6qdeG6Me+xiem9N7veeAYqNV0OvCOvctxFz4=; b=InvYDEmWhzShH/g67lJigBLiz4
        cWq86wI/JC8JuBArJg+dnbL1GywKx1YD19msTzwEstLlv9vkNoVfenBRsCt7QRYR5CNIskHBXGzqB
        JeFWk+xTXEWSR0Mb0f+4HXR/fXgl6kP6F9api0hrLPq2DSfbY2EZsWvaDmJyaW33HbnxYiSXBATRF
        lS55UVSmvHYvWj5GLIF+9loCs9fmz1fKOfT/hz+YmWNU/lDBQBNlqCseq1SO+zJ0U6ZoGuWn0v9+d
        15z0Sp+vFBokpMZZeu0RwyL+uByFJtCWP6EFkQuhgvZMAmLGGh5MsCgqUiClzf2LwY8GYyYqHRXA4
        XoW8GLAbNFJsZpjG+Nml2mbqpYmtKN9TPXyULFEw+4jSROiUOYfc15rbMEFJLyhdnFsfeH2M7cqTC
        KJpk2s/JezHiByd9KkywWnA2BcviW8A0h1a+DByRd9agdqTjlSjOhdIuI4iis7uyOws7O8SCbIbKi
        iQQMTGYWxmoFfOI3v69O8ABO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHHc-0013Z3-It; Fri, 01 Oct 2021 12:04:56 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>
Subject: [PATCH v5 00/20] Buffer validation patches
Date:   Fri,  1 Oct 2021 14:04:01 +0200
Message-Id: <20211001120421.327245-1-slow@samba.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

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

v5:
  - remove PDU size validation from ksmbd_conn_handler_loop()
  - add PDU size validation to ksmbd_smb2_check_message()
  - fix compound non-related request handling

Hyunchul Lee (1):
  ksmbd: add buffer validation for SMB2_CREATE_CONTEXT

Namjae Jeon (9):
  ksmbd: add the check to vaildate if stream protocol length exceeds
    maximum value
  ksmbd: add validation in smb2_ioctl
  ksmbd: use correct basic info level in set_file_basic_info()
  ksmbd: add request buffer validation in smb2_set_info
  ksmbd: check strictly data area in ksmbd_smb2_check_message()
  ksmbd: add validation in smb2 negotiate
  ksmbd: remove the leftover of smb2.0 dialect support
  ksmbd: remove NTLMv1 authentication
  ksmbd: fix transform header validation

Ralph Boehme (10):
  ksmbd: use ksmbd_req_buf_next() in ksmbd_smb2_check_message()
  ksmbd: use ksmbd_req_buf_next() in ksmbd_verify_smb_message()
  ksmbd: remove ksmbd_verify_smb_message()
  ksmbd: add ksmbd_smb2_cur_pdu_buflen()
  ksmbd: use ksmbd_smb2_cur_pdu_buflen() in ksmbd_smb2_check_message()
  ksmbd: check PDU len is at least header plus body size in
    ksmbd_smb2_check_message()
  ksmdb: use cmd helper variable in smb2_get_ksmbd_tcon()
  ksmdb: make smb2_get_ksmbd_tcon() callable with chained PDUs
  ksmbd: make smb2_check_user_session() callabe for compound PDUs
  ksmdb: move session and tcon validation to ksmbd_smb2_check_message()

 fs/ksmbd/auth.c       | 205 ---------------------
 fs/ksmbd/connection.c |   9 +-
 fs/ksmbd/crypto_ctx.c |  16 --
 fs/ksmbd/crypto_ctx.h |   8 -
 fs/ksmbd/ksmbd_work.h |   1 +
 fs/ksmbd/oplock.c     |  41 ++++-
 fs/ksmbd/server.c     |  19 +-
 fs/ksmbd/smb2misc.c   | 164 ++++++++++-------
 fs/ksmbd/smb2ops.c    |   5 -
 fs/ksmbd/smb2pdu.c    | 411 ++++++++++++++++++++++++++++++------------
 fs/ksmbd/smb2pdu.h    |  11 +-
 fs/ksmbd/smb_common.c |  68 +++----
 fs/ksmbd/smb_common.h |   5 +-
 fs/ksmbd/smbacl.c     |  21 ++-
 fs/ksmbd/vfs.c        |   2 +-
 fs/ksmbd/vfs.h        |   2 +-
 16 files changed, 496 insertions(+), 492 deletions(-)

-- 
2.31.1

