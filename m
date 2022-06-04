Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4014C43334
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Jun 2022 19:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbiFDTgg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 4 Jun 2022 15:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiFDTgf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 4 Jun 2022 15:36:35 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C879D
        for <linux-cifs@vger.kernel.org>; Sat,  4 Jun 2022 12:36:34 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 538E97FC02;
        Sat,  4 Jun 2022 19:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1654371392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XHoxlynIrSNYOhgddv+8t2qe3DjKjccevwhUZgJjW1w=;
        b=HF7C9bRl2E4Z9umFmf485X4wgNSyRWlTHHFYwsrQu55CyfhqRJfmqzSh5Bu1Kwc8sYvrsL
        +/YxSFsHDkQTI+IAnLoJt3E9fk7Z2JmMPTpIgU1jfgFZvEeKTdt7hag2QXflV8fLA9/10y
        XcwLvbS8DQGcf6NIZn4l2VbBMM6Mo8idVc/c0tGS4lxONFJSoxP96rnBzuOpRk0cXxP02s
        8HsVCLvp2b4Xx/xxmxa0bbEGLUUhdCOR+OPwHDbeTojS7bR98aplPmlIO8I6wXwkmzIbh/
        MTSvM6GAAlo/NFIeQ3iZ26eJHodQ5ZP+ws/4tYYqywSly7kdEVTKaHiHXSeyrA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Satadru Pramanik <satadru@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Failure to access cifs mount of samba share after resume from
 sleep with 5.17-rc5
In-Reply-To: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
References: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
Date:   Sat, 04 Jun 2022 16:36:27 -0300
Message-ID: <87k09wz0ec.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Satadru,

Thanks for providing all requested files off-list.  With that, I ended
up with below changes that should fix your issue.  Please let us if it
works.

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 12c872800326..325423180fd2 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1086,7 +1086,7 @@ struct file_system_type cifs_fs_type = {
 };
 MODULE_ALIAS_FS("cifs");
 
-static struct file_system_type smb3_fs_type = {
+struct file_system_type smb3_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "smb3",
 	.init_fs_context = smb3_init_fs_context,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index dd7e070ca243..b17be47a8e59 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -38,7 +38,7 @@ static inline unsigned long cifs_get_time(struct dentry *dentry)
 	return (unsigned long) dentry->d_fsdata;
 }
 
-extern struct file_system_type cifs_fs_type;
+extern struct file_system_type cifs_fs_type, smb3_fs_type;
 extern const struct address_space_operations cifs_addr_ops;
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 35962a1a23b9..eeb2a2957a68 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1211,8 +1211,12 @@ static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void
 		.data = data,
 		.sb = NULL,
 	};
+	struct file_system_type **fs_type = (struct file_system_type *[]) {
+		&cifs_fs_type, &smb3_fs_type, NULL,
+	};
 
-	iterate_supers_type(&cifs_fs_type, f, &sd);
+	for (; *fs_type; fs_type++)
+		iterate_supers_type(*fs_type, f, &sd);
 
 	if (!sd.sb)
 		return ERR_PTR(-EINVAL);
