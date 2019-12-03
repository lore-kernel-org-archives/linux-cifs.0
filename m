Return-Path: <SRS0=JIor=ZZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D61C432C0
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Dec 2019 03:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4DA4206E1
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Dec 2019 03:07:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ee4IFCAz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfLCDHr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 2 Dec 2019 22:07:47 -0500
Received: from mail-il1-f172.google.com ([209.85.166.172]:34559 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbfLCDHq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 2 Dec 2019 22:07:46 -0500
Received: by mail-il1-f172.google.com with SMTP id w13so1814141ilo.1
        for <linux-cifs@vger.kernel.org>; Mon, 02 Dec 2019 19:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=aWxpOiIQ/Y/5zfPc2pZkD3w649HYW4jfhPdsFDHmASM=;
        b=ee4IFCAzRNl23Sm7P2kX9vyq8Qp9c2lJhqMZCiF8hEL1ze+I57Mw7uP4vbvt4OF04E
         Jscqtde26FD3AQ4H1hcyZjueUFJ8C3wmZ2mFIggUtR3vq6mOAeKmWrBqnU7StguIER4L
         bmGCmXl9PK1k7ACf9PMs1iipqYP8GVYyJ1m9ViSFfcqj5c+4XLnLBKBUr6IepTIG7ImU
         5SKR1VR6YKjdQCghA70tV10Q1QPCCbhVi2R0O1rZA5SvuVAO59EZkXxbKohCzd0SCTIQ
         qIIzqXM+VarByfPIOr26XW5CiPGSSjMMU29vD+eTAHovAtfZboOOJeQJPI27qMwKyc0u
         HKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=aWxpOiIQ/Y/5zfPc2pZkD3w649HYW4jfhPdsFDHmASM=;
        b=DbNxxrS5bg3oYZZLQM0fSui+edMAdYhXhKLR3xjJsttKc8lEwBe7FippWgkPMxZ1/p
         6wdjmJPfshTVNBtlwe23xdq74dJrnefqAFvzPmJr9hU9HRoIJmyzAuGppuNPw2r0qc2R
         py3fYdU8L3E2ovELcKuTWZ8lZ9I2dSjR+d3hcA/DZ1inO0iGvvM0ffBVGbvCXZcPNx2h
         kLEJpkVxBbL128kYfrLhwOxseCr6GQPEmz+e2Zq/Rp4l6kAVLhBJRUCibZzfxQdgT38u
         pQgctvhlsDRmfmuRUC1qoqTc16s5WhDVPvSBl4a2PQF5hAfFRahVwXwodrFZD0KvafGs
         tVlw==
X-Gm-Message-State: APjAAAVPGxkokPaTNJBcOqIr/O2a8/KjrWOhM+EVa5pOnLAcFbbZr/Xa
        bcRHkB1vnOVxhIy/TGCzeWhxP6u8r1U0QXFjv8gkG535
X-Google-Smtp-Source: APXvYqzuPhfR+1d5QvMz7AOXBnhD/7aDXc2x+sSZ8DCxqM2v0uza7VWF/AgTcPZVfWvFRliCljf9ed/Wl8E29iiAO2g=
X-Received: by 2002:a92:1553:: with SMTP id v80mr2823968ilk.49.1575342466268;
 Mon, 02 Dec 2019 19:07:46 -0800 (PST)
MIME-Version: 1.0
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 3 Dec 2019 13:07:35 +1000
Message-ID: <CAN05THS0S-fRFMMJzhrdozs6VRbXHAZigSK2KVu=sjhQ6eDNXA@mail.gmail.com>
Subject: FileIndex in FSCC FileIdFullDirectoryInformation
To:     Interoperability Documentation Help <dochelp@winse.microsoft.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Dochelp,

I am looking at MS-FSCC for the FileIdFullDirectoryInformation
responses.
The description of FileIndex is as:
===
FileIndex (4 bytes): A 32-bit unsigned integer that contains the byte
offset of the file within the
parent directory. For file systems in which the position of a file
within the parent directory is not
fixed and can be changed at any time to maintain sort order, this
field SHOULD be set to 0 and
MUST be ignored.<107>

Footnote for <107> is :
===
<107> Section 2.4.18: When using NTFS, the position of a file within
the parent directory is not fixed
and can be changed at any time. Windows 2000, Windows XP, Windows
Server 2003, Windows Vista,
Windows Server 2008, Windows 7, and Windows Server 2008 R2 set this
value to zero for files on
NTFS file systems.


Is this list of OSs where FileIndex == 0 for NTFS complete?
I am testing against Windows2016 with a share on NTFS and it returns
FileIndex==0 also.
Can you check and clarify?


regards
ronnie sahlberg
