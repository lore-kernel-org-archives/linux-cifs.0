Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBD2C4167B
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58A3D23A21
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgLGXk7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:40:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41138 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbgLGXk7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:40:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=z8pHPwQGKYhO8aZaybiUT340sSB8Ofs1rPJmX7LrnHk=;
        b=CW3fpnhreKNrkXwnGAfgj5K000gCD8xI4hkHB9P6Onm8uDAlVmiScvueDAzr8ZS9qNMBJz
        rPzHgjet5HpD6SlAcboffHX2bP39dtBSZsa+kYTpeH+9hEl6lQWRqb4s7mVhFcHkAwzk2E
        0YyVnTPfcdJvnzMxr8pGo5w/9dFTU/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-gnZwiW2yO6GwEqCQJQ_sXw-1; Mon, 07 Dec 2020 18:39:31 -0500
X-MC-Unique: gnZwiW2yO6GwEqCQJQ_sXw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A0091935780;
        Mon,  7 Dec 2020 23:39:30 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A51C75D6D5;
        Mon,  7 Dec 2020 23:39:29 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 03/21] cifs: move the enum for cifs parameters into fs_context.h
Date:   Tue,  8 Dec 2020 09:36:28 +1000
Message-Id: <20201207233646.29823-3-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c    | 57 ------------------------------
 fs/cifs/fs_context.h | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 57 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 35bc1f56f053..17e9e95d54e5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -73,63 +73,6 @@ extern bool disable_legacy_dialects;
 /* Drop the connection to not overload the server */
 #define NUM_STATUS_IO_TIMEOUT   5
 
-enum {
-	/* Mount options that take no arguments */
-	Opt_user_xattr, Opt_nouser_xattr,
-	Opt_forceuid, Opt_noforceuid,
-	Opt_forcegid, Opt_noforcegid,
-	Opt_noblocksend, Opt_noautotune, Opt_nolease,
-	Opt_hard, Opt_soft, Opt_perm, Opt_noperm, Opt_nodelete,
-	Opt_mapposix, Opt_nomapposix,
-	Opt_mapchars, Opt_nomapchars, Opt_sfu,
-	Opt_nosfu, Opt_nodfs, Opt_posixpaths,
-	Opt_noposixpaths, Opt_nounix, Opt_unix,
-	Opt_nocase,
-	Opt_brl, Opt_nobrl,
-	Opt_handlecache, Opt_nohandlecache,
-	Opt_forcemandatorylock, Opt_setuidfromacl, Opt_setuids,
-	Opt_nosetuids, Opt_dynperm, Opt_nodynperm,
-	Opt_nohard, Opt_nosoft,
-	Opt_nointr, Opt_intr,
-	Opt_nostrictsync, Opt_strictsync,
-	Opt_serverino, Opt_noserverino,
-	Opt_rwpidforward, Opt_cifsacl, Opt_nocifsacl,
-	Opt_acl, Opt_noacl, Opt_locallease,
-	Opt_sign, Opt_ignore_signature, Opt_seal, Opt_noac,
-	Opt_fsc, Opt_mfsymlinks,
-	Opt_multiuser, Opt_sloppy, Opt_nosharesock,
-	Opt_persistent, Opt_nopersistent,
-	Opt_resilient, Opt_noresilient,
-	Opt_domainauto, Opt_rdma, Opt_modesid, Opt_rootfs,
-	Opt_multichannel, Opt_nomultichannel,
-	Opt_compress,
-
-	/* Mount options which take numeric value */
-	Opt_backupuid, Opt_backupgid, Opt_uid,
-	Opt_cruid, Opt_gid, Opt_file_mode,
-	Opt_dirmode, Opt_port,
-	Opt_min_enc_offload,
-	Opt_blocksize, Opt_rsize, Opt_wsize, Opt_actimeo,
-	Opt_echo_interval, Opt_max_credits, Opt_handletimeout,
-	Opt_snapshot, Opt_max_channels,
-
-	/* Mount options which take string value */
-	Opt_user, Opt_pass, Opt_ip,
-	Opt_domain, Opt_srcaddr, Opt_iocharset,
-	Opt_netbiosname, Opt_servern,
-	Opt_ver, Opt_vers, Opt_sec, Opt_cache,
-
-	/* Mount options to be ignored */
-	Opt_ignore,
-
-	/* Options which could be blank */
-	Opt_blank_pass,
-	Opt_blank_user,
-	Opt_blank_ip,
-
-	Opt_err
-};
-
 static const match_table_t cifs_mount_option_tokens = {
 
 	{ Opt_user_xattr, "user_xattr" },
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 1ac5e1d202b6..3a66199f3cb7 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -53,6 +53,103 @@ enum cifs_sec_param {
 	Opt_sec_err
 };
 
+enum cifs_param {
+	/* Mount options that take no arguments */
+	Opt_user_xattr, Opt_nouser_xattr,
+	Opt_forceuid, Opt_noforceuid,
+	Opt_forcegid, Opt_noforcegid,
+	Opt_noblocksend,
+	Opt_noautotune,
+	Opt_nolease,
+	Opt_hard, Opt_nohard,
+	Opt_soft, Opt_nosoft,
+	Opt_perm, Opt_noperm,
+	Opt_nodelete,
+	Opt_mapposix, Opt_nomapposix,
+	Opt_mapchars,
+	Opt_nomapchars,
+	Opt_sfu, Opt_nosfu,
+	Opt_nodfs,
+	Opt_posixpaths, Opt_noposixpaths,
+	Opt_unix, Opt_nounix,
+	Opt_nocase,
+	Opt_brl, Opt_nobrl,
+	Opt_handlecache, Opt_nohandlecache,
+	Opt_forcemandatorylock,
+	Opt_setuidfromacl,
+	Opt_setuids, Opt_nosetuids,
+	Opt_dynperm, Opt_nodynperm,
+	Opt_intr, Opt_nointr,
+	Opt_strictsync, Opt_nostrictsync,
+	Opt_serverino, Opt_noserverino,
+	Opt_rwpidforward,
+	Opt_cifsacl, Opt_nocifsacl,
+	Opt_acl, Opt_noacl,
+	Opt_locallease,
+	Opt_sign,
+	Opt_ignore_signature,
+	Opt_seal,
+	Opt_noac,
+	Opt_fsc,
+	Opt_mfsymlinks,
+	Opt_multiuser,
+	Opt_sloppy,
+	Opt_nosharesock,
+	Opt_persistent, Opt_nopersistent,
+	Opt_resilient, Opt_noresilient,
+	Opt_domainauto,
+	Opt_rdma,
+	Opt_modesid,
+	Opt_rootfs,
+	Opt_multichannel, Opt_nomultichannel,
+	Opt_compress,
+
+	/* Mount options which take numeric value */
+	Opt_backupuid,
+	Opt_backupgid,
+	Opt_uid,
+	Opt_cruid,
+	Opt_gid,
+	Opt_port,
+	Opt_file_mode,
+	Opt_dirmode,
+	Opt_min_enc_offload,
+	Opt_blocksize,
+	Opt_rsize,
+	Opt_wsize,
+	Opt_actimeo,
+	Opt_echo_interval,
+	Opt_max_credits,
+	Opt_snapshot,
+	Opt_max_channels,
+	Opt_handletimeout,
+
+	/* Mount options which take string value */
+	Opt_source,
+	Opt_user,
+	Opt_pass,
+	Opt_ip,
+	Opt_domain,
+	Opt_srcaddr,
+	Opt_iocharset,
+	Opt_netbiosname,
+	Opt_servern,
+	Opt_ver,
+	Opt_vers,
+	Opt_sec,
+	Opt_cache,
+
+	/* Mount options to be ignored */
+	Opt_ignore,
+
+	/* Options which could be blank */
+	Opt_blank_pass,
+	Opt_blank_user,
+	Opt_blank_ip,
+
+	Opt_err
+};
+
 struct smb3_fs_context {
 	bool uid_specified;
 	bool gid_specified;
-- 
2.13.6

