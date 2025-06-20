Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB71A21D3D2;
	Fri, 20 Jun 2025 23:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750463094; cv=none; b=SoTihREfxzf/TJH8S245LJKGekXryO/ln9v+mXoszOcUcQaES4AnFn/EJw8OIaxQ6+7cDDAPILqoQk/1zICVExyrremayo2tX2e7McSLRm/T2lhPfX9t1a53bKTisbvlkkUsaQX1tnBsJsFEzlEgvmaq5PPrbMkNmanpOteKfgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750463094; c=relaxed/simple;
	bh=T90MUGSlco0UoAnzZfBTyp6ZPCWArFV09xqtCxO87H4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=RWzKvB3MZNyLChCKvdOPb2ovFpQ2cyIpNYAfaEt4+2KtB9mw0MKo19HDXMPQvRfB1+EieggsQTh64JeWWJH//3cK9gV8QDsFQgom4tJ7PRoPb3Uyk6HXVUrqMhKUCGu1kaHzfkVKOfEscEhXwRwJVM6F9YpuPTXzT7q0m4VgW6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=6KkcE3dX; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="6KkcE3dX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DPgRqm36d5695GyQUzzZjg+tl4av1utpIQu5zELySI4=; b=6KkcE3dXbfxTFV1a6iJ0TkVFUM
	mf5L+hyvLTkY1WiAWhBj/UmtcpHRc0g+bruNlRMR2RpejmJzqVXtWk4TpdkOYYezurbFEjPlYuwB+
	9z8VwIHkRAD/XzkInxGWKF/yTdOtYNkLzLxv99wnplxertJBYR0rT+p14r0avwMgII/iTq+/bWk6G
	4LbpBEfoTm7klJqiY3XRbYaIjZ35r43+llLgIwJRSYfGGAtHN3jEML/5RjWGespjCIyaoV457fZy3
	A3+pXkz8gVRBHamczlbNU7qG/J+sAdPq1Ji/tJU85Oz0Ej0E/xiKmH7zSe8MeWpkf+0ZufXr+k8uj
	IytNXLPQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uSlPR-00000000MIc-3iBO;
	Fri, 20 Jun 2025 20:44:42 -0300
Message-ID: <26e59412fa2c70efad5f9c585bfc198f@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>, Steve French
 <sfrench@samba.org>, Remy
 Monsen <monsen@monsen.cc>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix lstat() and AT_SYMLINK_NOFOLLOW to work on
 broken symlink nodes
In-Reply-To: <20250610213404.16288-1-pali@kernel.org>
References: <20250610213404.16288-1-pali@kernel.org>
Date: Fri, 20 Jun 2025 20:44:37 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Score: 1.1 (+)

Pali Roh=C3=A1r <pali@kernel.org> writes:

> Currently Linux SMB client returns EIO for lstat() and AT_SYMLINK_NOFOLLOW
> calls on symlink node when the symlink target location is broken or cannot
> be read or parsed.
>
> Fix this problem by relaxing the errors from various locations which pars=
es
> information about symlink file node (UNIX SMB1, native SMB2+, NFS-style,
> WSL-style) and let readlink() syscall to return EIO when the symlink targ=
et
> location is not available.

Please, don't.  We still want those validations for the other types of
symlinks.  The problem is just that cifs.ko can't handle absolute
symlink targets in the form of '\??\UNC\srv\share\foo', while Windows
client can.  They are still valid symlink targets, but cifs.ko doesn't
know how to follow them.

The following should do it and then restore old behavior

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index bb25e77c5540..11d44288e75a 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -875,15 +875,8 @@ int smb2_parse_native_symlink(char **target, const cha=
r *buf, unsigned int len,
 			abs_path +=3D sizeof("\\DosDevices\\")-1;
 		else if (strstarts(abs_path, "\\GLOBAL??\\"))
 			abs_path +=3D sizeof("\\GLOBAL??\\")-1;
-		else {
-			/* Unhandled absolute symlink, points outside of DOS/Win32 */
-			cifs_dbg(VFS,
-				 "absolute symlink '%s' cannot be converted from NT format "
-				 "because points to unknown target\n",
-				 smb_target);
-			rc =3D -EIO;
-			goto out;
-		}
+		else
+			goto out_unhandled_target;
=20
 		/* Sometimes path separator after \?? is double backslash */
 		if (abs_path[0] =3D=3D '\\')
@@ -910,13 +903,7 @@ int smb2_parse_native_symlink(char **target, const cha=
r *buf, unsigned int len,
 			abs_path++;
 			abs_path[0] =3D drive_letter;
 		} else {
-			/* Unhandled absolute symlink. Report an error. */
-			cifs_dbg(VFS,
-				 "absolute symlink '%s' cannot be converted from NT format "
-				 "because points to unknown target\n",
-				 smb_target);
-			rc =3D -EIO;
-			goto out;
+			goto out_unhandled_target;
 		}
=20
 		abs_path_len =3D strlen(abs_path)+1;
@@ -966,6 +953,7 @@ int smb2_parse_native_symlink(char **target, const char=
 *buf, unsigned int len,
 		 * These paths have same format as Linux symlinks, so no
 		 * conversion is needed.
 		 */
+out_unhandled_target:
 		linux_target =3D smb_target;
 		smb_target =3D NULL;
 	}
