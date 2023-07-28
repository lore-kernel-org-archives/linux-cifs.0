Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74487C0015E
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 20:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjG1UEL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 16:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjG1UEL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 16:04:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0094F423B
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 13:04:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3B3E121940;
        Fri, 28 Jul 2023 20:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690574648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wughusw82XgwXZ/L8JbifNBfMO2a5/oor99wycA218=;
        b=Rt3qyzCznRqGg84/eYcfqxyVu4ri+h/E7f/wgNL4nIhx0rhYME6k2Qr53ciNTHEwRiEN1P
        uEpwHQqX4oqfJKXLeNqBvI0MkACuwwyE/PNb6nBKxY3a98tYsh+liTOt/LNmLw8Wglt5uN
        gKVL54XVmnSWCM/09fH82jM5UQwU4CA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690574648;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wughusw82XgwXZ/L8JbifNBfMO2a5/oor99wycA218=;
        b=HOLuRtQQ+/+NhLyp+IHzKbWqrp8ULT76cuT1eLqu+YqtihLV6SvmuTxgB2ODvKd6RWITyS
        8f/GecJiVK+1QIAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C08DE133F7;
        Fri, 28 Jul 2023 20:04:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dEwEIzcfxGRmLwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 28 Jul 2023 20:04:07 +0000
Date:   Fri, 28 Jul 2023 17:04:05 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 7/8] smb: client: reduce stack usage in
 smb2_query_symlink()
Message-ID: <20230728200405.ghihnnsbnhrutypl@suse.de>
References: <20230728195010.19122-1-pc@manguebit.com>
 <20230728195010.19122-7-pc@manguebit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230728195010.19122-7-pc@manguebit.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 07/28, Paulo Alcantara wrote:
>Clang warns about exceeded stack frame size
>
>  fs/smb/client/smb2ops.c:2974:1: warning: stack frame size (1368)
>  exceeds limit (1024) in 'smb2_query_symlink' [-Wframe-larger-than]
>
>Fix this by allocating a qs_vars structure that will hold most of the
>large structures.
>
>Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
>---
> fs/smb/client/smb2ops.c | 43 ++++++++++++++++++++++++++---------------
> 1 file changed, 27 insertions(+), 16 deletions(-)
>
>diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>index d6a15d5ec4d2..9136c77cd407 100644
>--- a/fs/smb/client/smb2ops.c
>+++ b/fs/smb/client/smb2ops.c
>@@ -2970,6 +2970,14 @@ parse_reparse_point(struct reparse_data_buffer *buf,
> 	}
> }
>
>+struct qs_vars {
>+	struct smb_rqst rqst[3];
>+	struct kvec rsp_iov[3];
>+	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
>+	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
>+	struct kvec close_iov;
>+};

I think structs qs_vars, qr_vars, and qi_vars should be a single "struct
query_vars" instead of having 2 repeated + 1 very similar differently
named structs around.

Then for smb2_query_info_compound() you use only io_iov[0].

And later on, maybe even embed such struct in "struct cop_vars"
(smb2inode.c) to avoid even more duplicate code.

Other than that,

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>

for this and all the other patches in this series.


Cheers,

Enzo

>+
> static int
> smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
> 		   struct cifs_sb_info *cifs_sb, const char *full_path,
>@@ -2979,16 +2987,14 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
> 	__le16 *utf16_path = NULL;
> 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
> 	struct cifs_open_parms oparms;
>+	struct smb_rqst *rqst;
> 	struct cifs_fid fid;
>+	struct qs_vars *vars;
> 	struct kvec err_iov = {NULL, 0};
>+	struct kvec *rsp_iov;
> 	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
> 	int flags = CIFS_CP_CREATE_CLOSE_OP;
>-	struct smb_rqst rqst[3];
> 	int resp_buftype[3];
>-	struct kvec rsp_iov[3];
>-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
>-	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
>-	struct kvec close_iov[1];
> 	struct smb2_create_rsp *create_rsp;
> 	struct smb2_ioctl_rsp *ioctl_rsp;
> 	struct reparse_data_buffer *reparse_buf;
>@@ -3002,17 +3008,22 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
> 	if (smb3_encryption_required(tcon))
> 		flags |= CIFS_TRANSFORM_REQ;
>
>-	memset(rqst, 0, sizeof(rqst));
>-	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
>-	memset(rsp_iov, 0, sizeof(rsp_iov));
>-
> 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
> 	if (!utf16_path)
> 		return -ENOMEM;
>
>+	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
>+
>+	vars = kzalloc(sizeof(*vars), GFP_KERNEL);
>+	if (!vars) {
>+		rc = -ENOMEM;
>+		goto out_free_path;
>+	}
>+	rqst = vars->rqst;
>+	rsp_iov = vars->rsp_iov;
>+
> 	/* Open */
>-	memset(&open_iov, 0, sizeof(open_iov));
>-	rqst[0].rq_iov = open_iov;
>+	rqst[0].rq_iov = vars->open_iov;
> 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
>
> 	oparms = (struct cifs_open_parms) {
>@@ -3032,8 +3043,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>
>
> 	/* IOCTL */
>-	memset(&io_iov, 0, sizeof(io_iov));
>-	rqst[1].rq_iov = io_iov;
>+	rqst[1].rq_iov = vars->io_iov;
> 	rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
>
> 	rc = SMB2_ioctl_init(tcon, server,
>@@ -3050,8 +3060,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>
>
> 	/* Close */
>-	memset(&close_iov, 0, sizeof(close_iov));
>-	rqst[2].rq_iov = close_iov;
>+	rqst[2].rq_iov = &vars->close_iov;
> 	rqst[2].rq_nvec = 1;
>
> 	rc = SMB2_close_init(tcon, server,
>@@ -3103,13 +3112,15 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>
>  querty_exit:
> 	cifs_dbg(FYI, "query symlink rc %d\n", rc);
>-	kfree(utf16_path);
> 	SMB2_open_free(&rqst[0]);
> 	SMB2_ioctl_free(&rqst[1]);
> 	SMB2_close_free(&rqst[2]);
> 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> 	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
>+	kfree(vars);
>+out_free_path:
>+	kfree(utf16_path);
> 	return rc;
> }
>
>-- 
>2.41.0
>
