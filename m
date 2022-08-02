Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB12C00140
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Aug 2022 13:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbiHBNwI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Aug 2022 09:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbiHBNwI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Aug 2022 09:52:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED510248DC
        for <linux-cifs@vger.kernel.org>; Tue,  2 Aug 2022 06:52:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9010E373DF;
        Tue,  2 Aug 2022 13:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659448324; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Cu9xubEI5RbyNK2s6B879IvxPzy4XVrIWPiIz4ZOlk=;
        b=KEy/ggheJEMRxnBBV7MKSwrZVf7KCYzCAgnW5L597fGaZPsD0Blyho+QXtXtyBP9Wmjm5x
        WEK+lQwShjA+0jQuHh+527sD48ldf2azomavUcfi7YpGSBnf+h6hnMFsPPbf5mfIrwisuo
        wXyd1iYSxcN9g01q0Pm/HFgg8ZBaJD4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659448324;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Cu9xubEI5RbyNK2s6B879IvxPzy4XVrIWPiIz4ZOlk=;
        b=6OZkmj0tyPlKd8jw4HSftRitzo+05QWfzH7Z3MhCi5jcG9I40tEj/cmqlXi6OXZAOKq3cC
        UyrcR/xljxkQnGAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0B5591345B;
        Tue,  2 Aug 2022 13:52:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NtFCLwMs6WL+ZAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 02 Aug 2022 13:52:03 +0000
Date:   Tue, 2 Aug 2022 10:52:01 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     Rowland Penny <rpenny@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Rename "cifs" module to "smbfs"
Message-ID: <20220802135201.4vm36drd5mp57nvv@cyberdelia>
References: <20220801190933.27197-1-ematsumiya@suse.de>
 <012fa69c76bac824c2e2dcc8dfaf9250723e502b.camel@samba.org>
 <20220801201438.5db6emf6iddawrfl@cyberdelia>
 <cc925d11-df62-fd92-f21f-4aca10e3a68d@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <cc925d11-df62-fd92-f21f-4aca10e3a68d@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 08/01, Tom Talpey wrote:
>On 8/1/2022 4:14 PM, Enzo Matsumiya wrote:
>>On 08/01, Rowland Penny wrote:
>>>On Mon, 2022-08-01 at 16:09 -0300, Enzo Matsumiya via samba-technical
>>>wrote:
>>>>Hi,
>>>>
>>>>As part of the ongoing effort to remove the "cifs" nomenclature from
>>>>the
>>>>Linux SMB client, I'm proposing the rename of the module to "smbfs".
>>>
>>>Hi, this has absolutely nothing to do with myself, but Linux used
>>>'smbfs' before it started to use 'cifs', so you are going back to an
>>>old term. This could be confusing.
>>
>>Hi Rowland, I'm aware of that. I had nothing to do with either
>>(choosing initial "smbfs" nor "cifs"), but, IMHO, I think it should've
>>stayed "smbfs". And TBH this is the most coherent name, of all
>
>I dug around the old tarballs and it looks like fs/smbfs was pulled from
>the kernel after 2.6.36, in early 2011. This was different from fs/cifs,
>which entered the kernel much earlier, so they previously coexisted.
>
>I don't think the name ambiguity is very important, but I do wonder if
>git might uncover some conflicts, when a previously removed directory
>suddenly reappears with new content? There wasn't a lot in fs/smbfs
>though.

I haven't considered that.
Doing a "git log --follow -- fs/smbfs" does show the older commits for
before the previous migration/rename:

----
commit 1e20c73a2935be2d9f19ebc63ddee1afccc42b07
Author: Enzo Matsumiya <ematsumiya@suse.de>
Date:   Mon Aug 1 15:05:23 2022 -0300

     smbfs: rename directory "fs/cifs" -> "fs/smbfs"

     Update fs/Kconfig and fs/Makefile to reflect the change.

     Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>

commit be9eee2e8b87e335531a3ae13abb8d26e834c438
Author: Christoph Hellwig <hch@infradead.org>
Date:   Sun Oct 10 05:36:29 2010 -0400

     smbfs: use dget_parent

     Use dget_parent instead of opencoding it.  This simplifies the code, b=
ut
     more importanly prepares for the more complicated locking for a parent
     dget in the dcache scale patch series.

     Note that the d_time assignment in smb_renew_times moves out of d_lock,
     but it's a single atomic 32-bit value, and that's what other sites
     setting it do already.

     Signed-off-by: Christoph Hellwig <hch@lst.de>
     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
=2E..
----

I don't know if that would cause a real problem though, someone more
experienced with renaming modules/directories could provide their
opinion.

Could we have an empty commit between old commits and the new rename to
serve as a marker maybe?

>Either way, I think the module name is the question here, and it doesn't
>have to be the same as the directory. I still prefer smbfs.
>
>Another possibility for the directory is "ksmb", which might rhyme with
>the server, and keep it close alphabetically too? OTOH it might be
>confusing to have two similar names.

My original idea of "ideal" was to have:

fs/smbfs/
fs/smbfs/common
fs/smbfs/client
fs/smbfs/server

Which aligns with e.g., drivers/nvme/ that has host/ and target/ subdirs
to accomodate client and server code. This would make things way more
manageable given the quantity of shared code between cifs.ko and
ksmbd.ko.

Another option is:
fs/smbfs_client/
fs/smbfs_common/ (already existing)
fs/smbfs_server/

But, personally, I'm not really a fan of the underscores.

My 2c only though.
Thoughts?

>And sorry but I hate the idea of adding "-client". Should we rename
>ksmbd to smb-server?? I don't think so.

Agreed.

>Tom.

Cheers,

Enzo

>>available/known choices; you know the protocol (SMB), you know it isn't
>>tied to any SMB version ("cifs", or "smb3" as sometimes suggested or
>>used (as a module alias)), it's a Linux filesystem module ("FS").
>>
>>Also the "fs/smbfs_common" directory was renamed as recent as last year
>>(from "cifs_common") (cf. commit 23e91d8b7).
>>
>>>Rowland
>>
>>Thanks for the input, though. As an RFC patch, I'm waiting for more
>>feedback and suggestions.
>>
>>
>>Cheers,
>>
>>Enzo
>>
>>>>
>>>>As it's widely known, CIFS is associated to SMB1.0, which, in turn,
>>>>is
>>>>associated with the security issues it presented in the past. Using
>>>>"SMBFS" makes clear what's the protocol in use for outsiders, but
>>>>also
>>>>unties it from any particular protocol version. It also fits in the
>>>>already existing "fs/smbfs_common" and "fs/ksmbd" naming scheme.
>>>>
>>>>This short patch series only changes directory names and
>>>>includes/ifdefs in
>>>>headers and source code, and updates docs to reflect the rename.
>>>>Other
>>>>than that, no source code/functionality is modified (WIP though).
>>>>
>>>>Patch 1/3: effectively changes the module name to "smbfs" and create
>>>>a
>>>>=A0=A0=A0=A0=A0=A0 "cifs" module alias to maintain compatibility (a war=
ning
>>>>=A0=A0=A0=A0=A0=A0 should be added to indicate the complete removal/iso=
lation
>>>>of
>>>>=A0=A0=A0=A0=A0=A0 CIFS/SMB1.0 code).
>>>>Patch 2/3: rename the source-code directory to align with the new
>>>>module
>>>>=A0=A0=A0=A0=A0=A0 name
>>>>Patch 3/3: update documentation references to "fs/cifs" or "cifs.ko"
>>>>or
>>>>=A0=A0=A0=A0=A0=A0 "cifs module" to use the new name
>>>>
>>>>Enzo Matsumiya (3):
>>>>=A0 cifs: change module name to "smbfs.ko"
>>>>=A0 smbfs: rename directory "fs/cifs" -> "fs/smbfs"
>>>>=A0 smbfs: update doc references
>>>>
>>>>=A0Documentation/admin-guide/index.rst=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0=A0 2 +-
>>>>=A0.../admin-guide/{cifs =3D> smbfs}/authors.rst=A0=A0 |=A0=A0 0
>>>>=A0.../admin-guide/{cifs =3D> smbfs}/changes.rst=A0=A0 |=A0=A0 4 +-
>>>>=A0.../admin-guide/{cifs =3D> smbfs}/index.rst=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0.../{cifs =3D> smbfs}/introduction.rst=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0=A0 0
>>>>=A0.../admin-guide/{cifs =3D> smbfs}/todo.rst=A0=A0=A0=A0=A0 |=A0 12 +-
>>>>=A0.../admin-guide/{cifs =3D> smbfs}/usage.rst=A0=A0=A0=A0 | 168 ++++++=
+++-------
>>>>--=20
>>>>=A0.../{cifs =3D> smbfs}/winucase_convert.pl=A0=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0Documentation/filesystems/index.rst=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0=A0 2 +-
>>>>=A0.../filesystems/{cifs =3D> smbfs}/cifsroot.rst=A0 |=A0 14 +-
>>>>=A0.../filesystems/{cifs =3D> smbfs}/index.rst=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0.../filesystems/{cifs =3D> smbfs}/ksmbd.rst=A0=A0=A0=A0 |=A0=A0 2 +-
>>>>=A0Documentation/networking/dns_resolver.rst=A0=A0=A0=A0 |=A0=A0 2 +-
>>>>=A0.../translations/zh_CN/admin-guide/index.rst=A0 |=A0=A0 2 +-
>>>>=A0.../translations/zh_TW/admin-guide/index.rst=A0 |=A0=A0 2 +-
>>>>=A0fs/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 6 +-
>>>>=A0fs/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 2 +-
>>>>=A0fs/cifs/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 34 ----
>>>>=A0fs/{cifs =3D> smbfs}/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 | 108 +++++------
>>>>=A0fs/smbfs/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 34 ++++
>>>>=A0fs/{cifs =3D> smbfs}/asn1.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/cifs_debug.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 72 ++++----
>>>>=A0fs/{cifs =3D> smbfs}/cifs_debug.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 4 +-
>>>>=A0fs/{cifs =3D> smbfs}/cifs_dfs_ref.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0=A0 2 +-
>>>>=A0fs/{cifs =3D> smbfs}/cifs_fs_sb.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/cifs_ioctl.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/cifs_spnego.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 4 +-
>>>>=A0fs/{cifs =3D> smbfs}/cifs_spnego.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 0
>>>>=A0.../cifs_spnego_negtokeninit.asn1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/cifs_swn.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/cifs_swn.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 4 +-
>>>>=A0fs/{cifs =3D> smbfs}/cifs_unicode.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/cifs_unicode.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/cifs_uniupr.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/cifsacl.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 6 +-
>>>>=A0fs/{cifs =3D> smbfs}/cifsacl.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/cifsencrypt.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/cifsglob.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0 26 +--
>>>>=A0fs/{cifs =3D> smbfs}/cifspdu.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 6 +-
>>>>=A0fs/{cifs =3D> smbfs}/cifsproto.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 10 +-
>>>>=A0fs/{cifs =3D> smbfs}/cifsroot.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/cifssmb.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0 14 +-
>>>>=A0fs/{cifs =3D> smbfs}/connect.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0 36 ++--
>>>>=A0fs/{cifs/cifsfs.c =3D> smbfs/core.c}=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0 49 ++---
>>>>=A0fs/{cifs =3D> smbfs}/dfs_cache.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 2 +-
>>>>=A0fs/{cifs =3D> smbfs}/dfs_cache.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/dir.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 2 +-
>>>>=A0fs/{cifs =3D> smbfs}/dns_resolve.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/dns_resolve.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/export.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 8 +-
>>>>=A0fs/{cifs =3D> smbfs}/file.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 |=A0 16 +-
>>>>=A0fs/{cifs =3D> smbfs}/fs_context.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 20 +--
>>>>=A0fs/{cifs =3D> smbfs}/fs_context.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/fscache.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/fscache.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 6 +-
>>>>=A0fs/{cifs =3D> smbfs}/inode.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0 10 +-
>>>>=A0fs/{cifs =3D> smbfs}/ioctl.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0=A0 6 +-
>>>>=A0fs/{cifs =3D> smbfs}/link.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 2 +-
>>>>=A0fs/{cifs =3D> smbfs}/misc.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 |=A0 14 +-
>>>>=A0fs/{cifs =3D> smbfs}/netlink.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/netlink.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/netmisc.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 2 +-
>>>>=A0fs/{cifs =3D> smbfs}/nterr.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/nterr.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/ntlmssp.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 2 +-
>>>>=A0fs/{cifs =3D> smbfs}/readdir.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 4 +-
>>>>=A0fs/{cifs =3D> smbfs}/rfc1002pdu.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/sess.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 |=A0 10 +-
>>>>=A0fs/{cifs =3D> smbfs}/smb1ops.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 4 +-
>>>>=A0fs/{cifs =3D> smbfs}/smb2file.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 2 +-
>>>>=A0fs/{cifs =3D> smbfs}/smb2glob.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/smb2inode.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 2 +-
>>>>=A0fs/{cifs =3D> smbfs}/smb2maperror.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/smb2misc.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/smb2ops.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0 32 ++--
>>>>=A0fs/{cifs =3D> smbfs}/smb2pdu.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0 22 +--
>>>>=A0fs/{cifs =3D> smbfs}/smb2pdu.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/smb2proto.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/smb2status.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/smb2transport.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0=A0 2 +-
>>>>=A0fs/{cifs =3D> smbfs}/smbdirect.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/smbdirect.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 2 +-
>>>>=A0fs/{cifs =3D> smbfs}/smbencrypt.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/smberr.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs/cifsfs.h =3D> smbfs/smbfs.h}=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
|=A0 12 +-
>>>>=A0fs/{cifs =3D> smbfs}/trace.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/trace.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/transport.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0=A0 4 +-
>>>>=A0fs/{cifs =3D> smbfs}/unc.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/winucase.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0=A0 0
>>>>=A0fs/{cifs =3D> smbfs}/xattr.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0 18 +-
>>>>=A091 files changed, 414 insertions(+), 417 deletions(-)
>>>>=A0rename Documentation/admin-guide/{cifs =3D> smbfs}/authors.rst (100%)
>>>>=A0rename Documentation/admin-guide/{cifs =3D> smbfs}/changes.rst (73%)
>>>>=A0rename Documentation/admin-guide/{cifs =3D> smbfs}/index.rst (100%)
>>>>=A0rename Documentation/admin-guide/{cifs =3D> smbfs}/introduction.rst
>>>>(100%)
>>>>=A0rename Documentation/admin-guide/{cifs =3D> smbfs}/todo.rst (95%)
>>>>=A0rename Documentation/admin-guide/{cifs =3D> smbfs}/usage.rst (87%)
>>>>=A0rename Documentation/admin-guide/{cifs =3D> smbfs}/winucase_convert.=
pl
>>>>(100%)
>>>>=A0rename Documentation/filesystems/{cifs =3D> smbfs}/cifsroot.rst (85%)
>>>>=A0rename Documentation/filesystems/{cifs =3D> smbfs}/index.rst (100%)
>>>>=A0rename Documentation/filesystems/{cifs =3D> smbfs}/ksmbd.rst (99%)
>>>>=A0delete mode 100644 fs/cifs/Makefile
>>>>=A0rename fs/{cifs =3D> smbfs}/Kconfig (72%)
>>>>=A0create mode 100644 fs/smbfs/Makefile
>>>>=A0rename fs/{cifs =3D> smbfs}/asn1.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_debug.c (96%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_debug.h (98%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_dfs_ref.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_fs_sb.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_ioctl.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_spnego.c (98%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_spnego.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_spnego_negtokeninit.asn1 (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_swn.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_swn.h (95%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_unicode.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_unicode.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifs_uniupr.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifsacl.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifsacl.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifsencrypt.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifsglob.h (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifspdu.h (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifsproto.h (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifsroot.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/cifssmb.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/connect.c (99%)
>>>>=A0rename fs/{cifs/cifsfs.c =3D> smbfs/core.c} (98%)
>>>>=A0rename fs/{cifs =3D> smbfs}/dfs_cache.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/dfs_cache.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/dir.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/dns_resolve.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/dns_resolve.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/export.c (91%)
>>>>=A0rename fs/{cifs =3D> smbfs}/file.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/fs_context.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/fs_context.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/fscache.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/fscache.h (98%)
>>>>=A0rename fs/{cifs =3D> smbfs}/inode.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/ioctl.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/link.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/misc.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/netlink.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/netlink.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/netmisc.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/nterr.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/nterr.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/ntlmssp.h (98%)
>>>>=A0rename fs/{cifs =3D> smbfs}/readdir.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/rfc1002pdu.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/sess.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smb1ops.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smb2file.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smb2glob.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smb2inode.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smb2maperror.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smb2misc.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smb2ops.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smb2pdu.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smb2pdu.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smb2proto.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smb2status.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smb2transport.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smbdirect.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smbdirect.h (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smbencrypt.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/smberr.h (100%)
>>>>=A0rename fs/{cifs/cifsfs.h =3D> smbfs/smbfs.h} (97%)
>>>>=A0rename fs/{cifs =3D> smbfs}/trace.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/trace.h (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/transport.c (99%)
>>>>=A0rename fs/{cifs =3D> smbfs}/unc.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/winucase.c (100%)
>>>>=A0rename fs/{cifs =3D> smbfs}/xattr.c (98%)
>>>>
>>>
>>
