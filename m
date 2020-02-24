Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85ED9C35671
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C30E20828
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:15:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="RJZWCkCl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgBXNPr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:15:47 -0500
Received: from hr2.samba.org ([144.76.82.148]:41842 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgBXNPr (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:15:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:To:From:CC;
        bh=aLcRs5N88qrCXswR1F3toBdOgSIvOo3ZhHNcGVi5gxA=; b=RJZWCkClaiRs9lE1UDgBUCF6o9
        ggLU1gXfDXNJMLny7aG2GsWRWLUO7BrmUxfoXHSLnsf7JFvtRxjVYeBhinK4ZMkYFutJ99dLEVAYq
        opD84esi2J4tC2GIKFfpYPzHsAeDBdoECRRnKEXINWKjeE0TDbSrz1RNnVo8csxg7NnrGlerCg/Wc
        iV+k7yoZABNYRYCIFVSs9DBQg46vB9M8BxYFj0r6RBbjD5V4ohTlrGZMDE7Ht1UhUoeVBOb6XxMWh
        SOTURlcSxPZO2HYJRTW9+4mredFZySTHGa3jZAuqEj3dRiO6YXWl7IfRWKvU7oxWE+BX6Xf2Yle56
        qSY4YaSzfyLw2YBdZzzOwbwwbffkiooL2o2rncQjj2J52/+h3umoBm/PRW/hBC3wvWfBV5rhfKeJp
        T8p39YUCunOZIgnwKVw8thMX5rVRsXw7v/ebO7WPLqUR5+UsrTA33d4ZGICDjmDUa5EwreoTXj/Ld
        LambesqEHGa4zkUy+olc5Xhc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaL-00061e-PJ
        for linux-cifs@vger.kernel.org; Mon, 24 Feb 2020 13:15:45 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Subject: [PATCH v1 00/13] Avoid reconnects of failed session setups on soft mounts
Date:   Mon, 24 Feb 2020 14:14:57 +0100
Message-Id: <20200224131510.20608-1-metze@samba.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Commit b0dd940e582b6a6 ("cifs: fail i/o on soft mounts if sessionsetup errors out")
didn't fix the whole problem. New i/o requests still try reconnects on the wire.
But we need to avoid that in order to avoid locking out the user account.

The first patches consolidate the retry/reconnect handling between SMB1
and SMB2/3.

Then we map STATUS_ACCOUNT_LOCKED_OUT also to -EACCES, as it's the
follow up of STATUS_LOGON_FAILURE when the wrong password was used too
often.

Finally if we get -EACCES for a session setup on a soft mount, we'll
turn the session into a CifsInvalidCredentials state and return
-EKEYREVOKED for all i/o on the session, without trying to reconnect
the network connection.

In future we could add ways to recover such sessions.
cifs_demultiplex_thread() is already prepared for that.
I tested this with a trivial /proc/fs/cifs/ResetInvalidCredentials
to reset all sessions, but I don't think that's something that
should be used in production.

For now the only way out is 'umount' (as before).

metze

