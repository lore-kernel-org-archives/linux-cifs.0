Return-Path: <SRS0=N3pp=6E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527A4C3815B
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Apr 2020 09:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3046320CC7
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Apr 2020 09:20:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qD7dU5/9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgDTJUo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Apr 2020 05:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTJUo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Apr 2020 05:20:44 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A99AC061A0C
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2020 02:20:44 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 72so1019882otu.1
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2020 02:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+o2MubV5Cdgqye2zDT1wZ/fa3KJxNdquL3qHQXEaxGs=;
        b=qD7dU5/9pqX/YzMqf/28Qxo5sXrWTBq5FmNTpw5B49+Lfcuc7A+xWvbkvNCw/8ldxe
         TOT3SIm5GlAvxAs5tHm5fhA8Sl7N0JA2rFj1zv3fvUQunlbS6tCQl/RWMNqntr/WFrBq
         E2ZjAgWmUNoxZAo4uP+M3Nhn/vqVA1uzpZS5fPUYZmJjvgWrO5f0LYp4AHLm/Iyx9HHU
         6HFUT17t8P/W4V0MCL3cXfIa9O/CqS3D4JoKiIN04OXGsE+Ezir79+Vkbn8sDdt2vuYW
         bvYhroBcq6utYPUFXfKEh+ASD+F59GcgpufKTwJzYEK2cFPLEX6OVGN/dghb70AzF3yT
         OMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+o2MubV5Cdgqye2zDT1wZ/fa3KJxNdquL3qHQXEaxGs=;
        b=rIYOylXFQ9tKoh7io4lGAm9tHx4prjtGUQd+l6540nw5bKb1aovh/Aw8vUT1iSdQUJ
         Fgq+8GGSXP2jaJpjgIRBqPkGdXuvZ2jAAOwpx4Q9bkiUGrbZ7Am88m4hhhC9bDMX7pkZ
         jowSFTfu21NkuTLmTVI8DMJ5Q40SwrmoBpqH6ZnqxKtGKAASyqBqv2urAzvP5AlUBugo
         oXi3OFtemPB2UESbAPW2kOeGxfC+h2in5wW2vaCEGtY8CvT7B/soSy4oPsGa54D4du7m
         WkcRSYSJ0ImyF5oa6SpgZUj4b58djTQ2YsFbomwnDKBqXUVLhU5AzWvnfrbAv7ttJ6fC
         u/dg==
X-Gm-Message-State: AGi0PuaBBKbK96kCVk2Ng4O54Xjd914qlRJMIu4KZSNDSo8fu6hxO8Fx
        twtGg3IW//u9TTBHhI2PI2RGDZveELqmHc1+wxo=
X-Google-Smtp-Source: APiQypKXdJw5i6XzFACdmaDWlJCa2X2rKsHLET7z47zC6cKsLFZ01xBg0+Kx5BuOSOQEtoJWMP+kvP8uYo1Dba9oz9M=
X-Received: by 2002:a05:6830:3150:: with SMTP id c16mr8287505ots.251.1587374443720;
 Mon, 20 Apr 2020 02:20:43 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?5Lq/5LiA?= <teroincn@gmail.com>
Date:   Mon, 20 Apr 2020 17:20:32 +0800
Message-ID: <CANTwqXDyh0Vvc=bgCMafGFLtheDtn31=ffDkg++2qn+RWq=vMQ@mail.gmail.com>
Subject: [BUG] fs: cifs : does there exist a memleak in function cifs_writev_requeue
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all:
 When reviewing the code of function cifs_writev_requeue, wdata2
allocated in while loop.
however,  if wdata2->cfile is NULL, the loop break without release
wdata2, there exists a memleak of wdata2?

static void
cifs_writev_requeue(struct cifs_writedata *wdata)
{
......
      wdata2 = cifs_writedata_alloc(nr_pages, cifs_writev_complete);
    // allocate wdata2
      if (!wdata2) {
             rc = -ENOMEM;
             break;
      }

      for (j = 0; j < nr_pages; j++) {
          wdata2->pages[j] = wdata->pages[i + j];
          lock_page(wdata2->pages[j]);
          clear_page_dirty_for_io(wdata2->pages[j]);
      }

      wdata2->sync_mode = wdata->sync_mode;
      wdata2->nr_pages = nr_pages;
      wdata2->offset = page_offset(wdata2->pages[0]);
      wdata2->pagesz = PAGE_SIZE;
      wdata2->tailsz = tailsz;
      wdata2->bytes = cur_len;

      wdata2->cfile = find_writable_file(CIFS_I(inode), false);
      if (!wdata2->cfile) {
            cifs_dbg(VFS, "No writable handles for inode\n");
            rc = -EBADF;
            break;                         // break without release wdata2.
      }
      ......
      }  while (i < wdata->nr_pages);

      mapping_set_error(inode->i_mapping, rc);
      kref_put(&wdata->refcount, cifs_writedata_release);
 }
