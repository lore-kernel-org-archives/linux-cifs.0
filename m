Return-Path: <SRS0=yfkL=4J=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643D5C35647
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Feb 2020 14:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD4CF24650
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Feb 2020 14:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="DT3S/9Zt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgBUOIH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:08:07 -0500
Received: from mx.cjr.nz ([51.158.111.142]:17530 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728392AbgBUOIH (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 21 Feb 2020 09:08:07 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 414CC80877;
        Fri, 21 Feb 2020 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1582294085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GaPPealyMlupKFIiYvvWkGnvaV1vAqe2AzcDFX9dgEo=;
        b=DT3S/9ZtOopJxgdJnyVE+HfVGKvHq/RowsNb8uK7ezKaNFUhb0u7ZnPKteCY0jiVon99rn
        Nv8FeexFSz7IWNeDWm2kqyramAAjYh7/akqCn+F5fCoI4tjiYzcKDXTMYCyY1bysJPD8q6
        8VgDKc5radwyWSV+kZy0nJ69/DBXmBKIw9nL6u3o+Ri2wZbTdTnnkTX1jnDGrwlybLDada
        HNRN6AJJFBGsWWc2ZAd0J6RV9rXz9wwpwLpp0uwEZTKI4dDbrqE3hSrL0EO09L7s34HWvO
        7ByH+KfVNB//RZ3Q/K8pyaKeBuR6VP6xZ9mS46zcOMRVOPAj75xZrKOXSSqVaw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: Re: [PATCH] cifs: fix rename() by ensuring source handle opened
 with DELETE bit
In-Reply-To: <20200221101906.24023-1-aaptel@suse.com>
References: <20200221101906.24023-1-aaptel@suse.com>
Date:   Fri, 21 Feb 2020 11:08:01 -0300
Message-ID: <874kvk6njy.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aurelien Aptel <aaptel@suse.com> writes:

> To rename a file in SMB2 we open it with the DELETE access and do a
> special SetInfo on it. If the handle is missing the DELETE bit the
> server will fail the SetInfo with STATUS_ACCESS_DENIED.
>
> We currently try to reuse any existing opened handle we have with
> cifs_get_writable_path(). That function looks for handles with WRITE
> access but doesn't check for DELETE, making rename() fail if it finds
> a handle to reuse. Simple reproducer below.
>
> To select handles with the DELETE bit, this patch adds a flag argument
> to cifs_get_writable_path() and find_writable_file() and the existing
> 'bool fsuid_only' argument is converted to a flag.
>
> The cifsFileInfo struct only stores the UNIX open mode but not the
> original SMB access flags. Since the DELETE bit is not mapped in that
> mode, this patch stores the access mask in cifs_fid on file open,
> which is accessible from cifsFileInfo.
>
> Simple reproducer:
>
> 	#include <stdio.h>
> 	#include <stdlib.h>
> 	#include <sys/types.h>
> 	#include <sys/stat.h>
> 	#include <fcntl.h>
> 	#include <unistd.h>
> 	#define E(s) perror(s), exit(1)
>
> 	int main(int argc, char *argv[])
> 	{
> 		int fd, ret;
> 		if (argc != 3) {
> 			fprintf(stderr, "Usage: %s A B\n"
> 			"create&open A in write mode, "
> 			"rename A to B, close A\n", argv[0]);
> 			return 0;
> 		}
>
> 		fd = openat(AT_FDCWD, argv[1], O_WRONLY|O_CREAT|O_SYNC, 0666);
> 		if (fd == -1) E("openat()");
>
> 		ret = rename(argv[1], argv[2]);
> 		if (ret) E("rename()");
>
> 		ret = close(fd);
> 		if (ret) E("close()");
>
> 		return ret;
> 	}
>
> $ gcc -o bugrename bugrename.c
> $ ./bugrename /mnt/a /mnt/b
> rename(): Permission denied
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/cifsglob.h  |  7 +++++++
>  fs/cifs/cifsproto.h |  5 +++--
>  fs/cifs/cifssmb.c   |  3 ++-
>  fs/cifs/file.c      | 19 ++++++++++++-------
>  fs/cifs/inode.c     |  6 +++---
>  fs/cifs/smb1ops.c   |  2 +-
>  fs/cifs/smb2inode.c |  4 ++--
>  fs/cifs/smb2ops.c   |  3 ++-
>  fs/cifs/smb2pdu.c   |  1 +
>  9 files changed, 33 insertions(+), 17 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
