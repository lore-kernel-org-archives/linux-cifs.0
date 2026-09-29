Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DA18C1F;
	Tue, 29 Sep 2026 06:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790662820; cv=none; b=ncTs5zFjROCmQmP2tByNzn3y3H5yMVLCDbnyPn5cgOx/X8olAHwbzcAcgHZDdYL9svr9Q3SGJwWGjtfhatUTChUNAfWCPXTea4rS1lRwjlw4sWkHigzm44QJFJ3pUD9HjITRxu21uaMm3zSPdKFJnoWVLk2qS3Mn/9KKEx07t7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790662820; c=relaxed/simple;
	bh=DiDjwLgUJ2Ga1RJ/uPunNLpMVJhlYSR0X/a/1aZUwzE=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=eb6ywL+mobBHALFDVDYgXZ0a0oDWp69yKsgQ/Ka7+GO7P+t1q25AJuFYtLQzCoBBRLzSx5lj52oxQKriqptgBnZjcvaOqAqJ2xj1qYCn8xDHahlpVuvJClzbTLG+LRU35DO1TfNXrPBDOSdZEPJeFqz30nK0Kh4yQPeyDhSZ8Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn; spf=pass smtp.mailfrom=stu.pku.edu.cn; dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b=KGs3PoTh; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b="KGs3PoTh"
Received: from smtpclient.apple (unknown [IPV6:240e:305:1b9d:c000:ac22:2543:5288:8f9b])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f7471ea5;
	Tue, 29 Sep 2026 14:20:10 +0800 (GMT+08:00)
From: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: [PATCH] smb: client: fix WARN_ON_ONCE() on malformed NFS reparse
 points
Message-Id: <5B8D9C32-9B93-49DB-B817-B6921BC0737F@stu.pku.edu.cn>
Date: Tue, 29 Sep 2026 14:19:59 +0800
Cc: Ralph Boehme <slow@samba.org>,
 Steve French <stfrench@microsoft.com>,
 linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
To: Paulo Alcantara <pc@manguebit.org>,
 Namjae Jeon <linkinjeon@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-HM-Tid: 0aa0ebd21ad803a1kunmde6cf84d229a07
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGE9OVkxNHklOSB8fQ05IQlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0seQUhLTkFKGUIfQRhLS0tBGhhJSUFJTk9IQU5JQ0NBQx
	1CGVlXWRYaDxIVHRRZQVlPS0hVSktISk5MTlVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=KGs3PoTh+CHd3oEK/for3YnbviNUM7TPswaFQYM4Of18QA/NwPkakAX/Xsel90JA5XvhswD/Y1HycOgsLMg2BGM0DL6nIHos5vpO5INtTTT5sIAC9GaKAb34to1aOnG9ltDZih7TvKRqKZ/GTMnRG0e+FtUqdpLaT1uLjiiSdN8=; c=relaxed/relaxed; s=default; d=stu.pku.edu.cn; v=1;
	bh=ybllncL2MRfyw/3gcGbfE8GCLH4Ev9bS9SqdG450J68=;
	h=date:mime-version:subject:message-id:from;

posix_reparse_to_fattr() re-checks fields taken straight from an
on-the-wire reparse_nfs_data_buffer and hits WARN_ON_ONCE() when
ReparseDataLength is too short or does not match the inode type, or
when the NFS inode type is unknown.

A malicious or buggy server can trigger any of the four warnings
with a plain stat() on a single name: parse_reparse_nfs() reports
the problem and rejects the buffer (-EIO or -EOPNOTSUPP), but
reparse_info_to_fattr() still builds the inode attributes from the
rejected buffer via cifs_open_info_to_fattr(), and
posix_reparse_to_fattr() warns on the very same server-controlled
data.  With panic_on_warn this takes the whole system down.

parse_reparse_nfs() already logs each of these conditions, so fail
quietly instead of warning, without changing the existing error and
fallback behaviour.

Triggered on v6.13+ with panic_on_warn=3D1 by stat()ing a name for
which the server returns a CREATE response carrying
SMB2_CREATE_FLAG_REPARSE_POINT and FILE_ATTRIBUTE_REPARSE_POINT and
answers the following FSCTL_GET_REPARSE_POINT with an NFS reparse
buffer holding an unknown inode type (e.g. 0xdeadbeef):

  CIFS: VFS: parse_reparse_nfs: unhandled inode type: 0xdeadbeef
  ------------[ cut here ]------------
  WARNING: fs/smb/client/reparse.c:1267 at
  cifs_reparse_point_to_fattr+0xd4e/0x1080
  CPU: 0 UID: 0 PID: 896 Comm: stat Tainted: G  N  =
7.3.0-rc4-00537-ga3ff15db6820
  ...
  Call Trace:
   cifs_open_info_to_fattr+0xa87/0x1520
   reparse_info_to_fattr+0x5d1/0xdc0
   cifs_get_fattr+0xa1d/0x1910
   cifs_get_inode_info+0xc0/0x310
   cifs_lookup+0x3a8/0xbd0
   ...
   vfs_fstatat+0x77/0xe0
   __do_sys_newfstatat+0x97/0x120

Cc: stable@vger.kernel.org
Fixes: 6a832bc8bbb223 ("fs/smb/client: Implement new SMB3 POSIX type")
Signed-off-by: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
---

Hi Paulo, Namjae,

found this while testing a CIFS client against a server under my
control, so I'm sending the fix directly.  Some notes that did
not belong in the commit message:

Still present in mainline v7.3-rc5 as of 2026-09-29; the code
shape first shipped in v6.13.  A numbered recipe for the trigger
described in the commit message, on a v6.13+ client with
panic_on_warn=3D1:

  1. mount a CIFS share from a server you control;
  2. answer the client's SMB2 CREATE for some name with
     STATUS_SUCCESS, SMB2_CREATE_FLAG_REPARSEPOINT and
     FILE_ATTRIBUTE_REPARSE_POINT;
  3. answer the following FSCTL_GET_REPARSE_POINT with an NFS
     (IO_REPARSE_TAG_NFS) reparse buffer whose InodeType is none
     of the NFS_SPECFILE_* values, e.g. 0xdeadbeef;
  4. stat() that name.

Shrinking ReparseDataLength below sizeof(InodeType), or setting
InodeType to NFS_SPECFILE_CHR/BLK with a wrong trailing length,
reaches the other three warnings the same way.

I verified the warning fires with the recipe above on
7.3.0-rc4-00537-ga3ff15db6820 and never fires with the patch
applied, while the parse-time messages still appear.

 fs/smb/client/reparse.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 3a27773186ae4..e6ed00bc114c5 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1232,25 +1232,26 @@ static bool posix_reparse_to_fattr(struct =
cifs_sb_info *cifs_sb,
 	if (buf =3D=3D NULL)
 		return true;
=20
+	/*
+	 * parse_reparse_nfs() has already validated this buffer and
+	 * reported anything wrong with it, but reparse_info_to_fattr()
+	 * still builds attributes from the rejected buffer, so fail
+	 * quietly on server-controlled data instead of warning.
+	 */
 	if (le16_to_cpu(buf->ReparseDataLength) < =
sizeof(buf->InodeType)) {
-		WARN_ON_ONCE(1);
 		return false;
 	}
=20
 	switch (le64_to_cpu(buf->InodeType)) {
 	case NFS_SPECFILE_CHR:
-		if (le16_to_cpu(buf->ReparseDataLength) !=3D =
sizeof(buf->InodeType) + 8) {
-			WARN_ON_ONCE(1);
+		if (le16_to_cpu(buf->ReparseDataLength) !=3D =
sizeof(buf->InodeType) + 8)
 			return false;
-		}
 		ftype =3D S_IFCHR;
 		fattr->cf_rdev =3D reparse_mkdev(buf->DataBuffer);
 		break;
 	case NFS_SPECFILE_BLK:
-		if (le16_to_cpu(buf->ReparseDataLength) !=3D =
sizeof(buf->InodeType) + 8) {
-			WARN_ON_ONCE(1);
+		if (le16_to_cpu(buf->ReparseDataLength) !=3D =
sizeof(buf->InodeType) + 8)
 			return false;
-		}
 		ftype =3D S_IFBLK;
 		fattr->cf_rdev =3D reparse_mkdev(buf->DataBuffer);
 		break;
@@ -1264,7 +1265,6 @@ static bool posix_reparse_to_fattr(struct =
cifs_sb_info *cifs_sb,
 		ftype =3D S_IFLNK;
 		break;
 	default:
-		WARN_ON_ONCE(1);
 		return false;
 	}
 	fattr->cf_mode =3D (fattr->cf_mode & ~S_IFMT) | ftype;
--=20
2.43.0=
