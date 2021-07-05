Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5838CC07E99
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Jul 2021 14:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3413661958
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Jul 2021 14:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhGEOki (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Jul 2021 10:40:38 -0400
Received: from mx.cjr.nz ([51.158.111.142]:16170 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231366AbhGEOki (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 5 Jul 2021 10:40:38 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 0E1B180862;
        Mon,  5 Jul 2021 14:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1625495879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qo27ODdabZ4oTbG/c87uu3N/UBK94IVOSuABSGxa8SU=;
        b=vsKADVqx4EJO9tCMrwtfFilLzSLg+AproB8FK3peeIF3ZavcdK4ghzCOxP1WBT/EBvsfL6
        rbieXg4fY9cCnAqOB7aeC4C6Y5w3ZLVSSZHScjREi+riKTbl8fEieWAvux06dhzMSUORgj
        /HCA0ET2Gr7wRle5qDJkZqV22WFjiO8h/IOQrFNKsImIgBSh8QP68ETzIt8Lq4R0SCYzNv
        eFgfhWsiV605oOKO29Rsg5pvO218I8u+Aey2Y5cKPS/bcIlxv4B74F9qJ0SzwCnfg98Lwc
        UtVcNHghRlwHenCWTkNvBdns0yJ6yWd4LEr3GmKuLyI3t8+QhFzqPCIehJWOnQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: Re: [PATCH] cifs: include regular shares to the list of unshared
 tcp servers
In-Reply-To: <87im1powxn.fsf@suse.com>
References: <20210702171710.406-1-pc@cjr.nz> <87im1powxn.fsf@suse.com>
Date:   Mon, 05 Jul 2021 11:37:55 -0300
Message-ID: <87a6n0967w.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> writes:

> Paulo Alcantara <pc@cjr.nz> writes:
>> We need to make regular shares to also not share tcp servers because
>> we might have both regular and dfs mounts connecting to same server.
>
> So with this change we never reuse tcp connections, and nosharesock
> because the default mount option for all cases. We might as well remove
> all the code for searching/matching/reusing tcp connection, smb session,
> tree connects.

Sounds like a good idea, yes.  Of course, if we really want to do this
regardless CONFIG_CIFS_DFS_UPCALL, it would probably be better off doing
it in a separate series.

> That doesn't seem good. If dfs connections are made with the nosharesock
> flag they should not be reused already no?

The previous version only made sure to not share tcp servers among DFS
shares, however, we must do it for all shares when we have
CONFIG_CIFS_DFS_UPCALL option enabled.

Without this change, the following would occur:

mount //dfsroot/dfs (new tcp)
mount //dfsroot/share (reuse tcp because


	rc =3D mount_get_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
	/*
	 * If called with 'nodfs' mount option, then skip DFS resolving.  Otherwis=
e unconditionally
	 * try to get an DFS referral (even cached) to determine whether it is an =
DFS mount.
	 *
	 * Skip prefix path to provide support for DFS referrals from w2k8 servers=
 which don't seem
	 * to respond with PATH_NOT_COVERED to requests that include the prefix.
	 */
	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
	    dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb), ctx-=
>UNC + 1, NULL,
			   NULL)) {
		if (rc)
			goto error;
		/* Check if it is fully accessible and then mount it */
		rc =3D is_path_remote(cifs_sb, ctx, xid, server, tcon);
		if (!rc)
			goto out;
		if (rc !=3D -EREMOTE)
			goto error;
	}

would get executed in cifs_mount() and we only set nosharesock after that)

With this patch:

mount //dfsroot/dfs (new tcp)
mount //dfsroot/share (new tcp)
