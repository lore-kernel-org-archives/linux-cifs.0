Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CB4C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Jul 2022 02:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbiGZClL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 22:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiGZClK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 22:41:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9109F13DC6
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 19:41:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3B16A1F97D;
        Tue, 26 Jul 2022 02:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658803268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ex0aXjVflu7g2R2lu0NPuTATxlCWb9JvGfjiNjZZQKM=;
        b=BXLVBSFNvmbekVFXX74tVekE4d2WX889pe+FiAp+rjV2gI7MjyYQsXlQ2sDE2IbbBSBP1M
        NvSt3l61ikd2hG6pTNtGlEDNjTy6DOLjr1g0g5b8cXETHSYCkvTR+EMKnFQ20Hxct64oWc
        iKibiQDLLfj+Q6UfMK5J6jX+8d7Hr0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658803268;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ex0aXjVflu7g2R2lu0NPuTATxlCWb9JvGfjiNjZZQKM=;
        b=mLJ+xBTzegW5AXMWN8vfnDzEehCRiiMq7OZ6IMHRfh/eNCflSK3afSBJ2Q+PZU+k6CROIw
        KecD2WZhReFvqvBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B040C13A12;
        Tue, 26 Jul 2022 02:41:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id srWlHENU32IADgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 26 Jul 2022 02:41:07 +0000
Date:   Mon, 25 Jul 2022 23:41:05 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [RFC PATCH v2 00/10] cifs: rename of several structs and
 variables
Message-ID: <20220726024105.5jd3uf6keus5bya5@cyberdelia>
References: <20220725223707.14477-1-ematsumiya@suse.de>
 <bec8a446-6c74-3ef7-37f0-49cd478599a6@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bec8a446-6c74-3ef7-37f0-49cd478599a6@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 07/25, Tom Talpey wrote:
>On 7/25/2022 6:36 PM, Enzo Matsumiya wrote:
>>Hi all,
>>
>>This patch set (v2) renames several cifs.ko data structures, variables, and
>>functions with the goal to improve readability of the code.
>>
>>In summary, what's been done:
>>- change from CamelCase to snake_case
>>- try to give more meaning to globals and struct members
>>- rename status fields (server, ses, tcon), define constants for the
>>   various statuses (4/11 can be shared between those structs, others are
>>   specific to each)
>>- rename of list_head variables to better represent whether they'are
>>   used as a list element ("head") or a list per se. Also tried to give
>>   more meaning to these, as "rlist", "tlist", "llist" looked confusing
>>   and, sometimes, ambiguous.
>>- remove redundant prefixes from struct members name, e.g.
>>   tcon_tlink's tl_*, smb_rqst's rq_*, cifs_fattr's cf_*, etc
>>
>>No functional changes has been made.
>>
>>I know these touch some very old code that older devs are highly used
>>to, but I see this as an improvement to reading the code for everyone.
>>
>>I'll be waiting for your reviews and feedback.
>
>Enzo, I think this effort is great. If you combine this modernization
>with refactoring SMB1 into separate files to make it easier to do
>away with entirely, I'll be even more supportive.

Tom, thanks for your feedback!
As a matter of fact, I do have a branch with SMB1 code isolated [*] and the
module renamed to "SMBFS" to modernize this module, while also keeping
it SMB-version-agnostic.

I'm sending my changes gradually so I don't have to change a lot of
things in case there's a lot of negative feedback.


[*] - current discussions:
- is "smbfs" the best module name? Steve suggested "smb3", but, again,
   this ties the module to a specific SMB version
- should SMB1 code be isolated as in source-code only or should it be a
   different object (i.e. only built through kernel config and
   "disable_legacy_dialects" wiped away)? Or even a separate module?

In any case, I'm keeping "cifs" as a module alias for SMB1 code for now,
and I think we'll need it that way for some time, but at least the
internal migration will be done by then.

>Tom.

Thanks again,

Enzo

>>v2:
>>   - remove status typedefs (suggested by Christoph Hellwig)
>>   - define status constants instead, reuse some between different
>>     structs so we don't have to create a different set of statuses
>>     for each cifs struct
>>
>>Enzo Matsumiya (10):
>>   cifs: rename xid/mid globals
>>   cifs: rename global counters
>>   cifs: rename "TCP_Server_Info" struct to "cifs_server_info"
>>   cifs: rename cifs{File,Lock,Inode}Info structs and more
>>   cifs: convert server info vars to snake_case
>>   cifs: change status and security types enums to constants
>>   cifs: rename cifsFYI to debug_level
>>   cifs: rename list_head fields
>>   cifs: rename more CamelCase to snake_case
>>   cifs: rename more list_heads, remove redundant prefixes
>>
>>  fs/cifs/Kconfig         |   2 +-
>>  fs/cifs/asn1.c          |   4 +-
>>  fs/cifs/cifs_debug.c    | 158 ++++-----
>>  fs/cifs/cifs_debug.h    |  29 +-
>>  fs/cifs/cifs_spnego.c   |   4 +-
>>  fs/cifs/cifs_spnego.h   |   2 +-
>>  fs/cifs/cifs_swn.c      |  24 +-
>>  fs/cifs/cifs_swn.h      |   8 +-
>>  fs/cifs/cifs_unicode.c  |   4 +-
>>  fs/cifs/cifs_unicode.h  |   2 +-
>>  fs/cifs/cifsacl.c       |  22 +-
>>  fs/cifs/cifsencrypt.c   |  78 ++---
>>  fs/cifs/cifsfs.c        | 124 +++----
>>  fs/cifs/cifsglob.h      | 694 ++++++++++++++++++++--------------------
>>  fs/cifs/cifsproto.h     | 172 +++++-----
>>  fs/cifs/cifssmb.c       | 356 ++++++++++-----------
>>  fs/cifs/connect.c       | 574 ++++++++++++++++-----------------
>>  fs/cifs/dfs_cache.c     | 178 +++++------
>>  fs/cifs/dfs_cache.h     |  40 +--
>>  fs/cifs/dir.c           |  16 +-
>>  fs/cifs/file.c          | 636 ++++++++++++++++++------------------
>>  fs/cifs/fs_context.c    |   8 +-
>>  fs/cifs/fs_context.h    |   2 +-
>>  fs/cifs/fscache.c       |  18 +-
>>  fs/cifs/fscache.h       |  10 +-
>>  fs/cifs/inode.c         | 530 +++++++++++++++---------------
>>  fs/cifs/ioctl.c         |  18 +-
>>  fs/cifs/link.c          |  26 +-
>>  fs/cifs/misc.c          | 185 ++++++-----
>>  fs/cifs/netmisc.c       |   4 +-
>>  fs/cifs/ntlmssp.h       |   6 +-
>>  fs/cifs/readdir.c       | 344 ++++++++++----------
>>  fs/cifs/sess.c          | 142 ++++----
>>  fs/cifs/smb1ops.c       | 182 +++++------
>>  fs/cifs/smb2file.c      |  36 +--
>>  fs/cifs/smb2inode.c     | 136 ++++----
>>  fs/cifs/smb2maperror.c  |   2 +-
>>  fs/cifs/smb2misc.c      |  72 ++---
>>  fs/cifs/smb2ops.c       | 555 ++++++++++++++++----------------
>>  fs/cifs/smb2pdu.c       | 596 +++++++++++++++++-----------------
>>  fs/cifs/smb2proto.h     |  68 ++--
>>  fs/cifs/smb2transport.c | 112 +++----
>>  fs/cifs/smbdirect.c     |  28 +-
>>  fs/cifs/smbdirect.h     |  16 +-
>>  fs/cifs/transport.c     | 236 +++++++-------
>>  fs/cifs/xattr.c         |  12 +-
>>  46 files changed, 3230 insertions(+), 3241 deletions(-)
>>
