Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C22C001E0
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jul 2023 02:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjGXCXH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 23 Jul 2023 22:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjGXCXB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 23 Jul 2023 22:23:01 -0400
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81921180;
        Sun, 23 Jul 2023 19:22:49 -0700 (PDT)
X-QQ-mid: bizesmtp78t1690164714tc9b5fmw
Received: from localhost.localdomain ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 24 Jul 2023 10:11:53 +0800 (CST)
X-QQ-SSF: 01400000000000F0I000000A0000000
X-QQ-FEAT: SFhf6fKhx//3yTay0+eQ1D+CKKeJtzJ6HaCq9pMrGhb8UPerUVao+UuD5kIip
        lL/PYV/QIGEXFgV+1O16DTphm6WGyKJap0KhiXLDOZBPEQ98qzlHcPNq4PjyN+7EBpurmj6
        VR7hFD0g8LWUkFgs5el/o/M3DIdpH0ZRsYybLpHcrcTyjZAuiMYZhjI2V2H1O/C4pF2BiCZ
        TDknNgiFf65NuW7WxNODlePQTgYLocjNnGN1/ikAmS4saFysEYRc4yaEhgqTbrp7y4wSQAN
        Cx+/mT0fPuXQ1f7lGyLKfBCa4tbqWBSJMd0XchQuHdzdgJV0fI7QN3cJT7FD28l+ALQ5OJO
        99tKVrxgEcRK/it0pOoMU0BX6JP2JoSgoEji/JB0q/krdKRGJc=
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10104321948773929990
From:   Winston Wen <wentao@uniontech.com>
To:     Steve French <sfrench@samba.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/2] cifs: fix charset issue in reconnection
Date:   Mon, 24 Jul 2023 10:10:55 +0800
Message-Id: <20230724021057.2958991-1-wentao@uniontech.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The patch 1 make load_nls() take a const char * as parameter so
we can reuse a nls's name without cast:

    ses->local_nls = load_nls(ctx->local_nls->charset);

The patch 2 do the charset fix in cifs.

--
Winston Wen (2):
      fs/nls: make load_nls() take a const parameter
      cifs: fix charset issue in reconnection

 fs/nls/nls_base.c        | 4 ++--
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/cifssmb.c  | 3 +--
 fs/smb/client/connect.c  | 5 +++++
 fs/smb/client/misc.c     | 1 +
 fs/smb/client/smb2pdu.c  | 3 +--
 include/linux/nls.h      | 2 +-
 7 files changed, 12 insertions(+), 7 deletions(-)


