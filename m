Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387E428A2A1
	for <linux-cifs@vger.kernel.org>; Thu, 13 Feb 2025 18:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472129; cv=none; b=pF2TyoopPeOpf8dnLCt8E+6VV/2cLl+MRJ8lB4hKhwQYhYGra90oKSmVlWpYSmTBGz6Mgabl/yNyDDl0FnJP16UNiYvrnUakua5X8aYMC8UEbbvKXwM2mnPJJD+alHpb/9BvodB2kM2OxG90WbhAxHgoxUCZaVWF1liK/rm821c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472129; c=relaxed/simple;
	bh=gy5zwCLRO817ywDriNr3rGU8ZQEH7GXIIvfZSTxTidg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnJrRQnxZn9MXuAQhFeHkw1T+FDxYA/MbbFHG/I94r0tyKSwCWGBBCZkxjxOPmGDwtVL0YPIVI7goTjM/OjMRQ4IDIbcejqiX0on/9ul5AGYTQAKdr4hOADpsE7rwxFjPJx1cw+UVOTmIXntFvhyblIN1t1UEAR1VVLCE4krfBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOXM9HHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOXM9HHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497EFC4CED1;
	Thu, 13 Feb 2025 18:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739472128;
	bh=gy5zwCLRO817ywDriNr3rGU8ZQEH7GXIIvfZSTxTidg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TOXM9HHydPUVgkTxt4B5bfW2QpBXbupu+nlDD+u0tjWqhk5DgZEdMDACGE3iX0++9
	 jUDT/bGTx3idc/T0ZDnxgBczh4FSp7mTWuntKQDGebjNcS0qa2VOPhd3AAdQuVxOCh
	 IoWaEveow5iHnEDASPsLWnDSy9I2tHKOI+pMQTgbge0q5/Yvbn29l0G7PL5EwlmOxt
	 K0OCHZpGlycdQP/RHeGQz2mW7e27Z39VSYBHIzsjGg8nM+Xt8bXiuRqikm/64u5Aq1
	 xyShvKd3nwUdBN5FAkd2NBdwUv3I8qNs+dbteqDex1ZSDtFeAcPe5vBsKjUfl5P9wY
	 dWPrPWjHd7mlQ==
Received: by pali.im (Postfix)
	id AA17C732; Thu, 13 Feb 2025 19:41:55 +0100 (CET)
Date: Thu, 13 Feb 2025 19:41:55 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
Message-ID: <20250213184155.sqdkac7spzm437ei@pali>
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali>
 <92b554876923f730500a4dc734ef8e77@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ycoyzggb6r26imri"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92b554876923f730500a4dc734ef8e77@manguebit.com>
User-Agent: NeoMutt/20180716


--ycoyzggb6r26imri
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wednesday 12 February 2025 19:19:00 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > On Wednesday 12 February 2025 17:49:31 Paulo Alcantara wrote:
> >> Steve,
> >> 
> >> The commit 438e2116d7bd ("cifs: Change translation of
> >> STATUS_PRIVILEGE_NOT_HELD to -EPERM") regressed getcifsacl(1) because it
> >> expects -EIO to be returned from getxattr(2) when the client can't read
> >> system.cifs_ntsd_full attribute and then fall back to system.cifs_acl
> >> attribute.  Either -EIO or -EPERM is wrong for getxattr(2), but that's a
> >> different problem, though.
> >> 
> >> Reproduced against samba-4.22 server.
> >
> > That is bad. I can prepare a fix for cifs.ko getxattr syscall to
> > translate -EPERM to -EIO. This will ensure that getcifsacl will work as
> > before as it would still see -EIO error.
> 
> Sounds good.

Now I quickly prepared a fix, it is straightforward but I have not
tested it yet. Testing requires non-admin user which does not have
SeSecurityPrivilege privilege configured. Could you check if it is
fixing this problem?

--ycoyzggb6r26imri
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-cifs-Reports-EIO-for-getxattr-system.cifs_ntsd_full-.patch"
Content-Transfer-Encoding: 8bit

From c9032ef054acd0a92ea641dc33a7b62a5833e00c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Thu, 13 Feb 2025 19:37:29 +0100
Subject: [PATCH] cifs: Reports -EIO for getxattr(system.cifs_ntsd_full)
 privilege error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 438e2116d7bd ("cifs: Change translation of STATUS_PRIVILEGE_NOT_HELD
to -EPERM") globally changed translation of STATUS_PRIVILEGE_NOT_HELD
status code from -EIO to -EPERM which is more appropriate errno code.

Unfortunately it broke getcifsacl utility when called by user which does
not have SeSecurityPrivilege privilege, which is required to fetch SACLs.

Userspace utility getcifsacl expects that kernel reports privilege error
for system.cifs_ntsd_full xattr as EIO errno, not as EPERM errno.

When privilege error via EIO errno is detected then getcifsacl request
security descriptor without SACLs via system.cifs_acl xattr. This is
allowed also without SeSecurityPrivilege privilege.

This change fixes the errno returned by getxattr(system.cifs_ntsd_full)
call, as required by backward compatibility for getcifsacl utility.
With this change EIO is returned as before the mentioned commit.

Fixes: 438e2116d7bd ("cifs: Change translation of STATUS_PRIVILEGE_NOT_HELD to -EPERM")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/xattr.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index 58a584f0b27e..11207979c630 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -331,6 +331,20 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 			rc = PTR_ERR(pacl);
 			cifs_dbg(VFS, "%s: error %zd getting sec desc\n",
 				 __func__, rc);
+			if (rc == -EPERM && handler->flags == XATTR_CIFS_NTSD_FULL) {
+				/*
+				 * Report STATUS_PRIVILEGE_NOT_HELD error (signaled by -EPERM)
+				 * to userspace as EIO errno for system.cifs_ntsd_full xattr.
+				 * This is backward compatibility for old version of getcifsacl
+				 * utility which is doing fallback from system.cifs_ntsd_full xattr
+				 * to system.cifs_acl xattr when user does not have privilege to
+				 * fetch SACL and expects that kernel reports insufficient privilege
+				 * error via EIO errno (instead of EPERM errno).
+				 */
+				rc = -EIO;
+				cifs_dbg(FYI, "%s: error changed to %zd for compatibility\n",
+					 __func__, rc);
+			}
 		} else {
 			if (value) {
 				if (acllen > size)
-- 
2.20.1


--ycoyzggb6r26imri--
