Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A874CC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FF9C61284
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbhJBNOH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbhJBNOH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 09:14:07 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3410BC0613EE
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=PL5cMQjWVZMWF5DFXnCkGcrbNUGlz5WUau8iM0ri+s4=; b=ctxpBhcEN7swo6ECs739W7V4zc
        2XtGPynrTh6ApsxEd2e/fTN8nafj0ADorvkyKCm3qsNoGunLT1YHqSNxTL6v4Z55H8R1krsmwA1zS
        fEva1YsY8o53V+oLcENikOv4ce5X5fjJ+JU9Da1UUdByaJb6eG9KGIizlF+az7JuKrV/kSCEN6h2E
        yP3bQkcJIQ/ZqKzvqkMmX9LOJldvBdA4C9lOl2CPLAIn5oBBH+1/zMHq9+GlYWYsBRXljXwKlq0Nq
        q/NouyNs6eHg6xAAp9DmaepdIz8mqtIDEK/GbuU8n6oVY+vhGg+AJjwF6X8mLsI9KMUz7CNrkeIwJ
        u6RjclIvt3IXUYa02YTGpe0YLDHl5uo2LejRT+VqiqWVWcjLH+tkFrHlWf4pknnOI/M6DCGgu/T7c
        iY6qg2++/DXHTZQ3jWaHc38+403LZkqIGT6rJK0TKCB7qVh/u5dfENhl6dVaAKusl6mvTGPXe5UhL
        01JxarXyfWawxav2dSljPsSM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeoN-001DcY-4r; Sat, 02 Oct 2021 13:12:19 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>
Subject: [PATCH v6 00/14] Buffer validation patches
Date:   Sat,  2 Oct 2021 15:11:58 +0200
Message-Id: <20211002131212.130629-1-slow@samba.org>
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

v6:
  - check we can access ProtocolId in ksmbd_verify_smb_message()
  - optimize tcon and session check functions for compound related PDUs
  - drop patch that broke SMB1 negprot
  - check credits after fully validating PDU size

Namjae Jeon (4):
  ksmbd: add the check to vaildate if stream protocol length exceeds
    maximum value
  ksmbd: add validation in smb2_ioctl
  ksmbd: check strictly data area in ksmbd_smb2_check_message()
  ksmbd: remove the leftover of smb2.0 dialect support

Ralph Boehme (10):
  ksmbd: use ksmbd_req_buf_next() in ksmbd_verify_smb_message()
  ksmbd: check buffer is big enough to access the ProtocolId field
  ksmbd: use ksmbd_req_buf_next() in ksmbd_smb2_check_message()
  ksmbd: use ksmbd_smb2_cur_pdu_buflen() in ksmbd_smb2_check_message()
  ksmbd: check PDU len is at least header plus body size in
    ksmbd_smb2_check_message()
  ksmdb: use cmd helper variable in smb2_get_ksmbd_tcon()
  ksmdb: make smb2_get_ksmbd_tcon() callable with chained PDUs
  ksmbd: make smb2_check_user_session() callable for compound PDUs
  ksmdb: move session and tcon validation to ksmbd_smb2_check_message()
  ksmdb: validate credit charge after validating SMB2 PDU body size

 fs/ksmbd/connection.c |   9 ++-
 fs/ksmbd/ksmbd_work.h |   1 +
 fs/ksmbd/server.c     |  46 +++++++----
 fs/ksmbd/smb2misc.c   | 152 +++++++++++++++++++-----------------
 fs/ksmbd/smb2ops.c    |   5 --
 fs/ksmbd/smb2pdu.c    | 178 +++++++++++++++++++++++++++++-------------
 fs/ksmbd/smb2pdu.h    |   2 +-
 fs/ksmbd/smb_common.c |  22 +++---
 fs/ksmbd/smb_common.h |   4 +-
 fs/ksmbd/vfs.c        |   2 +-
 fs/ksmbd/vfs.h        |   2 +-
 11 files changed, 256 insertions(+), 167 deletions(-)

-- 
2.31.1

