Return-Path: <SRS0=gUrR=WZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406F8C3A59F
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Aug 2019 05:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0660C22CF5
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Aug 2019 05:02:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HGUOE0/G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbfH2FCl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Aug 2019 01:02:41 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35419 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfH2FCl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Aug 2019 01:02:41 -0400
Received: by mail-pl1-f195.google.com with SMTP id gn20so1014312plb.2;
        Wed, 28 Aug 2019 22:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=LgMi/tOCGdx9z9EgjX0DOVGstnnLhYUUExXCPTNrvk4=;
        b=HGUOE0/GrUyV2OTY2CITe3OSYyiH1ZaPEVlYKIDE6D3wUi4KNgXz2F3Nw1NPJQvuQY
         4q0hLcS6BC46Ir4eIlxdKcYm7KyFAIivvMpj+HTTjqwCNiKCrCdjcuICwnfZsUujsQEi
         WvC5l3hqCtW/udICeHHBV1BnYq30TNVsRU14MTPKf1sUA9Ntw4ycWulsHVnyjj9ifCLI
         yMPwWCnJrEx1ATI7rb75NRu0PGxbI0p46fNrYW73tEzdOcm96sd5vatezLa1lDGNDg+m
         RqePAZfocxBvODzP9EvUraPX4W/GFY0k2GwTzUYFExEO511lgm6je1sK5cu9yDDP7dRM
         74ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=LgMi/tOCGdx9z9EgjX0DOVGstnnLhYUUExXCPTNrvk4=;
        b=jFblr3vrJ1ZSkVTTsAv6U9Xg6BGeoq/SkJObooCOuTa4TMmriN87rXimQu/pgtObu0
         ToLYrY4FhjKgN6Tb/7gO9dh7eHA0n0rmlXpBZNeQayrrIZGfrk/t3+jQ1wj6ngRC2qrY
         iC3hPVpTddYAG3g06Crc6BVwVLRLO9l0xVaXIz95RoNGsC+v+9BOqAOKM60IyuA0CA1m
         xV3ZEv7der4rpKt8iAneic/ELNWXjx3zeYA31CI7Tjjan15VgvMYWKnItbSzV3wlOhYt
         zibKB7UEwRYG8U2w/Of+aICWZ3bsITAUsH9B4VxynqM/yvFNgE64nYktKeywydrqCNVX
         lSSg==
X-Gm-Message-State: APjAAAXkw6/g2AdqzBvqFdi9o6YSkZr8JEhmwh77onO+en5GUCVfSb0T
        /iDJy40tVtox7uip/1uqWmI=
X-Google-Smtp-Source: APXvYqy2pYPQdzCT1BPAq+ZAXzjpkv7FaF1klfsNhhpKdjsKim7tOECfA/6XxqQTcmXrjMzD4/wGQg==
X-Received: by 2002:a17:902:ff0c:: with SMTP id f12mr1164440plj.67.1567054960830;
        Wed, 28 Aug 2019 22:02:40 -0700 (PDT)
Received: from localhost ([39.7.51.95])
        by smtp.gmail.com with ESMTPSA id s7sm1635703pfb.138.2019.08.28.22.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 22:02:40 -0700 (PDT)
Date:   Thu, 29 Aug 2019 14:02:37 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: build_path_from_dentry_optional_prefix() may schedule from invalid
 context
Message-ID: <20190829050237.GA5161@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

Looking at commit "cifs: create a helper to find a writeable handle
by path name":

->open_file_lock scope is atomic context, while build_path_from_dentry()
can schedule - kmalloc(GFP_KERNEL)

       spin_lock(&tcon->open_file_lock);
       list_for_each(tmp, &tcon->openFileList) {
               cfile = list_entry(tmp, struct cifsFileInfo,
                            tlist);
               full_path = build_path_from_dentry(cfile->dentry);
               if (full_path == NULL) {
                       spin_unlock(&tcon->open_file_lock);
                       return -ENOMEM;
               }
               if (strcmp(full_path, name)) {
                       kfree(full_path);
                       continue;
               }
               kfree(full_path);

               cinode = CIFS_I(d_inode(cfile->dentry));
               spin_unlock(&tcon->open_file_lock);
               return cifs_get_writable_file(cinode, 0, ret_file);
       }

       spin_unlock(&tcon->open_file_lock);

Additionally, kfree() can (and should) be done outside of
->open_file_lock scope.

	-ss
