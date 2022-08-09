Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E72C25B0C
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Aug 2022 02:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiHICMh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 22:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiHICMg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 22:12:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7696918B09
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 19:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660011154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L9pb8XpAZo2T2JOXX4BO8Nz9PSwDrlA0iAyjtKJ6KSE=;
        b=FbW4RcS3SncS2Ve3FSzR1mO35TXtpwtyVR6zRlR1JWTQ6imQxU4DjbW5T0fn5clG6u/QPt
        N7dydmDmV4erv6fJtyY4yMlfSYzP42AfoUV8q7McfupfoCkyIZQZ76yqrRI3JEJVm4H1Gg
        YerNANyeZ7nej9yIGAbJInIE4JcouKA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-jAkWa0_jNMy7GgwK_j362A-1; Mon, 08 Aug 2022 22:12:31 -0400
X-MC-Unique: jAkWa0_jNMy7GgwK_j362A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE6C128084EC;
        Tue,  9 Aug 2022 02:12:30 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-16.bne.redhat.com [10.64.52.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B17294585;
        Tue,  9 Aug 2022 02:12:29 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 8/9] cifs: don't unlock cifs_tcp_ses_lock in cached_dir_lease_break()
Date:   Tue,  9 Aug 2022 12:11:55 +1000
Message-Id: <20220809021156.3086869-9-lsahlber@redhat.com>
In-Reply-To: <20220809021156.3086869-1-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Unlock it from the caller, which is also where the lock is taken.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 1 -
 fs/cifs/smb2misc.c   | 4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 5f2d01833f1e..9d221f0bf976 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -389,7 +389,6 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			  smb2_cached_lease_break);
 		queue_work(cifsiod_wq,
 			   &cfid->lease_break);
-		spin_unlock(&cifs_tcp_ses_lock);
 		return true;
 	}
 	return false;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index d3d9174ddd7c..2cc038aca5bc 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -640,8 +640,10 @@ smb2_is_valid_lease_break(char *buffer)
 				}
 				spin_unlock(&tcon->open_file_lock);
 
-				if (cached_dir_lease_break(tcon, rsp->LeaseKey))
+				if (cached_dir_lease_break(tcon, rsp->LeaseKey)) {
+					spin_unlock(&cifs_tcp_ses_lock);
 					return true;
+				}
 			}
 		}
 	}
-- 
2.35.3

