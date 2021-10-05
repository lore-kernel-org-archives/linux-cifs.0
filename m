Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A804C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DC446126A
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhJEFF7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 01:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhJEFF7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 01:05:59 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E12C061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 22:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=Iw6WFO0iDQeCspedTuBZLZDxGxfDlxyZMrystAVjMkM=; b=rXAPut1/fSMTUWu3DDJrWab2V6
        NQS6uTM96+TeGCvPWDC4yO/OCYB0WRjefVXAjhpsuXeCO5oMzoW55DHqRtcTpDLpp2T0/MM6q8AmA
        Sc+uJcCchNxfBBQ/KvHhoxKnQKt9Wjf24dhV+beA9QtjM1kemCA8JmP3wUp3x1WlI8z5hqIqQ4k9v
        BI9T6SJBfbm5qjUYfmjTI3+denzxyP0YYMt6+QkSzhd96SEIVNfmJ+pTnEBk7HGFW9Bix+NL4E+nw
        3A/nlcHMabtaOIXsZklKdH+oidpZdvMSXUJKOyq4AWtBB1I71O1ekjfScF5qVB79wnOxFrydx9oPE
        yeqCZgO1Rh7I9OCavwOLvWt7VPLJhL17Q91307gyEovx1bjMIHbtaAwymQEJkNX91xsuOCLnUr0Y5
        ybs5OlHJ3du2u6VJCtTBoNISm5YHVPxe9lJdMtAmMebq9I49Fte8qZ9S5zzQ3uNTBdJEZZRhxfuLn
        H9VgXnHFWlkzpyZcW2wCUi47;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXccY-001Yyq-S6; Tue, 05 Oct 2021 05:04:07 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>
Subject: [PATCH v7 0/9] Buffer validation and compound handling patches
Date:   Tue,  5 Oct 2021 07:03:34 +0200
Message-Id: <20211005050343.268514-1-slow@samba.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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

v7:
  - drop header size check in ksmbd_verify_smb_message()
  - fix invalid read when accessing StructureSize2 in
    ksmbd_smb2_check_message()
  - validate credit charge after validating SMB2 PDU body size

Ralph Boehme (9):
  ksmbd: use ksmbd_req_buf_next() in ksmbd_verify_smb_message()
  ksmbd: use ksmbd_req_buf_next() in ksmbd_smb2_check_message()
  ksmbd: add and use ksmbd_smb2_cur_pdu_buflen() in
    ksmbd_smb2_check_message()
  ksmbd: check buffer is big enough to access the SMB2 PUD body size
    field
  ksmdb: validate credit charge after validating SMB2 PDU body size
  ksmdb: use cmd helper variable in smb2_get_ksmbd_tcon()
  ksmdb: make smb2_get_ksmbd_tcon() callable with chained PDUs
  ksmbd: make smb2_check_user_session() callable for compound PDUs
  ksmdb: move session and tcon validation to __process_request()

 fs/ksmbd/ksmbd_work.h |  1 +
 fs/ksmbd/server.c     | 46 +++++++++++++++++++++-------------
 fs/ksmbd/smb2misc.c   | 58 +++++++++++++++++++++++++++----------------
 fs/ksmbd/smb2pdu.c    | 39 +++++++++++++++++++++++------
 fs/ksmbd/smb2pdu.h    |  1 +
 fs/ksmbd/smb_common.c |  2 +-
 6 files changed, 101 insertions(+), 46 deletions(-)

-- 
2.31.1

