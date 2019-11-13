Return-Path: <SRS0=3kj9=ZF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB90C43331
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 01:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A536222C1
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 01:11:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="JaUT76es"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKMBL3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Nov 2019 20:11:29 -0500
Received: from mx.cjr.nz ([51.158.111.142]:48048 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbfKMBL3 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 12 Nov 2019 20:11:29 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 77E4C81354;
        Wed, 13 Nov 2019 01:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1573607486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uZEQRbM/obvQw2d02TXsXsliBHOvXePVFSDZ+2A5iIU=;
        b=JaUT76esqFPJdrfaGT1Q3JGlzLFUG6z64XxP874x2CT8v46h70GevfLTDg3dt58RekB1nK
        BBl99ufDEHW64XtIdt+acM6fTu7k2k0jtHyaOl6lvKO+H+Z1CjxBLwVdQDzR67djCOdSqR
        iG1rmRPuKDNULzmzhmlidPB+M7BAB8Tv3XHMYArSB6d3uvOmeLHlOHfHRunslCYn/Ups5y
        NhX5IDSgVAvblUYKHz3SmQGO38GuSKTnaUqdTWWCOKRAMGVgF0tmrOEN3eHvE4fnVPkg1x
        Ncl3hqXIK6YkiuSwjpSUaGXrFuwTQy1Y3gVUUUrFGwnx88a+ICOuM57sYO/PJg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Matthew Ruffell <matthew.ruffell@canonical.com>,
        linux-cifs@vger.kernel.org
Cc:     sfrench@samba.org
Subject: Re: PROBLEM: DFS Caching feature causing problems traversing
 multi-tier DFS setups
In-Reply-To: <05aa2995-e85e-0ff4-d003-5bb08bd17a22@canonical.com>
References: <05aa2995-e85e-0ff4-d003-5bb08bd17a22@canonical.com>
Date:   Tue, 12 Nov 2019 22:11:20 -0300
Message-ID: <87imnooa13.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Matthew,

Thanks for the report.

Matthew Ruffell <matthew.ruffell@canonical.com> writes:

> We have come across a problem where kernels 5.0-rc1 and onwards cannot mo=
unt
> a multi tier DFS setup, while kernels 4.20 and below can mount the share =
fine.
>
> The DFS tiering structure looks like this:
>
> Domain virtual DFS (i.e. \\company.com\folders\share)
> |-- Domain controller DFS (i.e. \\regional-dc.company.com\folders\share)
> =C2=A0=C2=A0=C2=A0 |-- Regional DFS Server (i.e. \\regional-dfs.company.c=
om\folders\share)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |-- Actual file server (i.e. \=
\regional-svr.company.com\share)
>
> On the 5.x series kernels, after getting the DFS referrals list through t=
o the
> Regional DFS Server, which responds with the correct server/share, instea=
d of
> going to the Actual file server, the kernel backtracks from the Regional =
DFS
> Server back to the Domain controller and requests the share there. Of cou=
rse,
> this share does not exist on the Domain controller, as it only exists on =
the
> Actual file server, and the connection dies.

I've got some DFS cache patches[1] and haven't sent them yet due to lack
of time and testing. Those contain a lot of important fixes but none of
them seem to fix the issue you're having -- thus I won't ask you to
apply them on top.

Instead, could you please try below changes?

Thanks,
Paulo

[1] https://git.cjr.nz/linux.git/log/?h=3Dcifs-dfscache

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3991d6c8f255..9158d5d14ac9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4777,6 +4777,15 @@ static int is_path_remote(struct cifs_sb_info *cifs_=
sb, struct smb_vol *vol,
 }
=20
 #ifdef CONFIG_CIFS_DFS_UPCALL
+static inline void set_root_tcon(struct cifs_tcon *tcon,
+				 struct cifs_tcon **root)
+{
+	spin_lock(&cifs_tcp_ses_lock);
+	tcon->tc_count++;
+	spin_unlock(&cifs_tcp_ses_lock);
+	*root =3D tcon;
+}
+
 int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 {
 	int rc =3D 0;
@@ -4878,18 +4887,10 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct=
 smb_vol *vol)
 	/* Cache out resolved root server */
 	(void)dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb),
 			     root_path + 1, NULL, NULL);
-	/*
-	 * Save root tcon for additional DFS requests to update or create a new
-	 * DFS cache entry, or even perform DFS failover.
-	 */
-	spin_lock(&cifs_tcp_ses_lock);
-	tcon->tc_count++;
-	tcon->dfs_path =3D root_path;
+	kfree(root_path);
 	root_path =3D NULL;
-	tcon->remap =3D cifs_remap(cifs_sb);
-	spin_unlock(&cifs_tcp_ses_lock);
=20
-	root_tcon =3D tcon;
+	set_root_tcon(tcon, &root_tcon);
=20
 	for (count =3D 1; ;) {
 		if (!rc && tcon) {
@@ -4926,6 +4927,15 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct =
smb_vol *vol)
 			mount_put_conns(cifs_sb, xid, server, ses, tcon);
 			rc =3D mount_get_conns(vol, cifs_sb, &xid, &server, &ses,
 					     &tcon);
+			/*
+			 * Ensure that DFS referrals go through new root server.
+			 */
+			if (!rc && tcon &&
+			    (tcon->share_flags & (SHI1005_FLAGS_DFS |
+						  SHI1005_FLAGS_DFS_ROOT))) {
+				cifs_put_tcon(root_tcon);
+				set_root_tcon(tcon, &root_tcon);
+			}
 		}
 		if (rc) {
 			if (rc =3D=3D -EACCES || rc =3D=3D -EOPNOTSUPP)
