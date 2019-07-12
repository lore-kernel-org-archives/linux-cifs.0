Return-Path: <SRS0=Efbp=VJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410CFC742A5
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jul 2019 07:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F85B2084B
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jul 2019 07:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfGLH4o convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Jul 2019 03:56:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:35030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726073AbfGLH4o (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 12 Jul 2019 03:56:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3C345AFCD;
        Fri, 12 Jul 2019 07:56:43 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Paulo Alcantara <paulo@paulo.ac>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH] cifs: fix crash in cifs_dfs_do_automount
In-Reply-To: <20190711034658.21485-1-lsahlber@redhat.com>
References: <20190711034658.21485-1-lsahlber@redhat.com>
Date:   Fri, 12 Jul 2019 09:56:41 +0200
Message-ID: <87lfx34reu.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ronnie,

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> RHBZ: 1649907
>
> Fix a crash that happens while attempting to mount a DFS referral from the same server on the root of a filesystem.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/connect.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8ad8bbe8003b..9b0f9f346c5b 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -4484,11 +4484,13 @@ cifs_are_all_path_components_accessible(struct TCP_Server_Info *server,
>  					unsigned int xid,
>  					struct cifs_tcon *tcon,
>  					struct cifs_sb_info *cifs_sb,
> -					char *full_path)
> +					char *full_path,
> +					int added_treename)
>  {
>  	int rc;
>  	char *s;
>  	char sep, tmp;
> +	int skip = added_treename ? 1 : 0;
>  
>  	sep = CIFS_DIR_SEP(cifs_sb);
>  	s = full_path;
> @@ -4503,7 +4505,13 @@ cifs_are_all_path_components_accessible(struct TCP_Server_Info *server,
>  		/* next separator */
>  		while (*s && *s != sep)
>  			s++;
> -
> +		/* if the treename is added, we then have to skip the first
> +		 * part within the separators
> +		 */

Nitpicking (Steve can probably fix this when he applies) but comment
style should be

/*
 * foo
 */


> +		if (skip) {
> +			skip = 0;
> +			continue;
> +		}
>  		/*
>  		 * temporarily null-terminate the path at the end of
>  		 * the current component
> @@ -4551,8 +4559,7 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb_vol *vol,
>  
>  	if (rc != -EREMOTE) {
>  		rc = cifs_are_all_path_components_accessible(server, xid, tcon,
> -							     cifs_sb,
> -							     full_path);
> +			cifs_sb, full_path, tcon->Flags & SMB_SHARE_IS_IN_DFS);

Just FYI this flag is just set in SMB1. Can we test this change in the buildbot?

>  		if (rc != 0) {
>  			cifs_dbg(VFS, "cannot query dirs between root and final path, "
>  				 "enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
> -- 
> 2.13.6
>
>

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 21284 (AG Nürnberg)
