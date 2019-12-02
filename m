Return-Path: <SRS0=UnI2=ZY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2937BC432C0
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Dec 2019 12:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 040452070A
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Dec 2019 12:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfLBMZU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 2 Dec 2019 07:25:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:39768 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727354AbfLBMZU (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 2 Dec 2019 07:25:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B54A1AFA7;
        Mon,  2 Dec 2019 12:25:18 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: Re: [PATCH] CIFS: Fix NULL-pointer dereference in
 smb2_push_mandatory_locks
In-Reply-To: <20191128001839.5926-1-pshilov@microsoft.com>
References: <20191128001839.5926-1-pshilov@microsoft.com>
Date:   Mon, 02 Dec 2019 13:25:17 +0100
Message-ID: <878snuud76.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel Shilovsky <piastryyy@gmail.com> writes:
> Currently when the client creates a cifsFileInfo structure for
> a newly opened file, it allocates a list of byte-range locks
> with a pointer to the new cfile and attaches this list to the
> inode's lock list. The latter happens before initializing all
> other fields, e.g. cfile->tlink. Thus a partially initialized
> cifsFileInfo structure becomes available to other threads that
> walk through the inode's lock list. One example of such a thread
> may be an oplock break worker thread that tries to push all
> cached byte-range locks. This causes NULL-pointer dereference
> in smb2_push_mandatory_locks() when accessing cfile->tlink:

reviewing late but this makes sense.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
