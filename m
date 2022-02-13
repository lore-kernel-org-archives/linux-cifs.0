Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD59C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 13 Feb 2022 22:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbiBMWlP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 13 Feb 2022 17:41:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiBMWlO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 13 Feb 2022 17:41:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37D6154BD6
        for <linux-cifs@vger.kernel.org>; Sun, 13 Feb 2022 14:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644792067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wM8NYX2C/91pYDb26lsWJuJUDrbtZaRJoF+n0ZEFCl8=;
        b=WUHuwQ3XQrHlBAx5FLwLZbVqU8uVJRclnVzWRXg8eNfxB7GwTFy0TzVJu2ywDA4ll+AcBW
        1gGaXmQaczDYDW8hYlLvwMeKNTijc8TdSTZdqeGsQFq7myBILeKbeAkExxnZUfOs6lBVPE
        SCqVdMRpfW1Kx0ZQiSAKjApV9iGvisk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-dHh4327OPgmSAI_p2YTS7w-1; Sun, 13 Feb 2022 17:41:05 -0500
X-MC-Unique: dHh4327OPgmSAI_p2YTS7w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E64D4801B0C;
        Sun, 13 Feb 2022 22:41:04 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-22.bne.redhat.com [10.64.54.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 500D2103BAC7;
        Sun, 13 Feb 2022 22:41:02 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: modefromsids must add an ACE for authenticated users
Date:   Mon, 14 Feb 2022 08:40:52 +1000
Message-Id: <20220213224052.3387192-2-lsahlber@redhat.com>
In-Reply-To: <20220213224052.3387192-1-lsahlber@redhat.com>
References: <20220213224052.3387192-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When we create a file with modefromsids we set an ACL that
has one ACE for the magic modefromsid as well as a second ACE that
grants full access to all authenticated users.

When later we chante the mode on the file we strip away this, and other,
ACE for authenticated users in set_chmod_dacl() and then just add back/update
the modefromsid ACE.
Thus leaving the file with a single ACE that is for the mode and no ACE
to grant any user any rights to access the file.
Fix this by always adding back also the modefromsid ACE so that we do not
drop the rights to access the file.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsacl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index ee3aab3dd4ac..40cda87ce384 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -949,6 +949,9 @@ static void populate_new_aces(char *nacl_base,
 		pnntace = (struct cifs_ace *) (nacl_base + nsize);
 		nsize += setup_special_mode_ACE(pnntace, nmode);
 		num_aces++;
+		pnntace = (struct cifs_ace *) (nacl_base + nsize);
+		nsize += setup_authusers_ACE(pnntace);
+		num_aces++;
 		goto set_size;
 	}
 
@@ -1613,7 +1616,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	nsecdesclen = secdesclen;
 	if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
 		if (mode_from_sid)
-			nsecdesclen += sizeof(struct cifs_ace);
+			nsecdesclen += 2 * sizeof(struct cifs_ace);
 		else /* cifsacl */
 			nsecdesclen += 5 * sizeof(struct cifs_ace);
 	} else { /* chown */
-- 
2.30.2

