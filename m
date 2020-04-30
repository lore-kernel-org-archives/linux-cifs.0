Return-Path: <SRS0=3vxN=6O=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB03AC4724C
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Apr 2020 14:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB70206D9
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Apr 2020 14:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588255503;
	bh=g24Uum1M4THSrqGNhm5O12w3DsdOF//UBnZNn3J0WaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0pOMmyd1KKaiB7wW7HrDT05dT+woMnPiX5W4WMWSIZ3YTMG4I0/KUp1gRuZBBSeu9
	 xro8xXwkkZ4w07UvuGjvZpO80lLz8njCzTmKMhcl7iY3DjN16/0zd92WVtEHPrCkz+
	 ytVyeT7Dsdl57P3Ilbh4tnr+45MTRIHcm0Kfv+vE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgD3NxF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbgD3NxE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96C6020873;
        Thu, 30 Apr 2020 13:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254784;
        bh=g24Uum1M4THSrqGNhm5O12w3DsdOF//UBnZNn3J0WaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7stsTl3kDB4X8OFp5GMArXITaI1P/2utKLujq+GrNwDKKlxmL8EkQaa9wxC6Ah47
         4reNpflKgXbDG5IRb6kqt7A7h3udSyZi6RwS9S5xjW7w4zY0Ys0mKN7KKoMtV+8yKI
         ulOA31iGQa2I9k1yVJxWTZOkvwAsUQuId183oy9I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 40/57] cifs: protect updating server->dstaddr with a spinlock
Date:   Thu, 30 Apr 2020 09:52:01 -0400
Message-Id: <20200430135218.20372-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit fada37f6f62995cc449b36ebba1220594bfe55fe ]

We use a spinlock while we are reading and accessing the destination address for a server.
We need to also use this spinlock to protect when we are modifying this address from
reconn_set_ipaddr().

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index bcda48c038821..52589ea4e3c05 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -371,8 +371,10 @@ static int reconn_set_ipaddr(struct TCP_Server_Info *server)
 		return rc;
 	}
 
+	spin_lock(&cifs_tcp_ses_lock);
 	rc = cifs_convert_address((struct sockaddr *)&server->dstaddr, ipaddr,
 				  strlen(ipaddr));
+	spin_unlock(&cifs_tcp_ses_lock);
 	kfree(ipaddr);
 
 	return !rc ? -1 : 0;
-- 
2.20.1

