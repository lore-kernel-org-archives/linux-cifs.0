Return-Path: <SRS0=fkjb=YJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C60ECE599
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Oct 2019 20:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC50D21848
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Oct 2019 20:52:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="HWdZcriU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388251AbfJPUwK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Oct 2019 16:52:10 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58530 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387460AbfJPUwK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Oct 2019 16:52:10 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 9A19820B71C6; Wed, 16 Oct 2019 13:52:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9A19820B71C6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1571259129;
        bh=d+Ysm+jyrNC1lniKfbvqDsEbq72HSSw3e1BvBRMGO6w=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=HWdZcriUfiUZvg7neKyFFitW1RWYsRucNa0yUzPfWIJPuODaofcUyWqognnCc8neq
         9j/ZAE2BRNh1WKSsoSps4/W+JN5CLVvNgNg26rQk71x8NDQYe7AEkzt1aZ8VSmULaq
         lQNbLdRfQGlbU7rzTSP7+Z91VCxNeIE4jxdZ/AYs=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH 0/7] cifs: smbd: Improve reliability on transport reconnect
Date:   Wed, 16 Oct 2019 13:51:49 -0700
Message-Id: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

Long Li (7):
  cifs: Don't display RDMA transport on reconnect
  cifs: smbd: Invalidate and deregister memory registration on re-send
  cifs: smbd: Return -EINVAL when the number of iovs exceeds
    SMBDIRECT_MAX_SGE
  cifs: smbd: Add messages on RDMA session destroy and reconnection
  cifs: smbd: Return -ECONNABORTED when trasnport is not in connected
    state
  cifs: smbd: Only queue work for error recovery on memory registration
  cifs: smbd: Return -EAGAIN when transport is reconnecting

 fs/cifs/cifs_debug.c |  5 +++++
 fs/cifs/file.c       | 19 +++++++++++++++++--
 fs/cifs/smbdirect.c  | 36 +++++++++++++++++++++---------------
 fs/cifs/transport.c  |  7 +++++--
 4 files changed, 48 insertions(+), 19 deletions(-)

-- 
2.17.1

