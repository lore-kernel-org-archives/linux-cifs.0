Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C783ACEF8;
	Mon,  6 Jul 2026 18:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783363725; cv=none; b=j1d+8af1lNSU5n5cVS7QNjwYiTGC20V9irQJ44Rhni+piSgxHcAg7sVTRflBaKIldFlMeteb+WxKuapwwwiIrTBV8RqDA9XqYfH+ScaEzKIWzQvouZB1wW19Ni515uzrNMpA/l+dIZGgT9jGfEheWkXRhDPlrSdjC2S7kKfKgHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783363725; c=relaxed/simple;
	bh=1aj10Uo094gqqEQ6hbpZPdod6vnq65pkAv5I06C91z4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=AHpxbE58XNttiXzBlPPZ0bQ3kppqzlBkvhIOmx8ji7JVhL7vydcSgO3xAnWcbzsNuy7YceBpDAifffUmpUXGIeeNoe8H5xxt7P1W4fTV8sh+3EBCU7pHaWcuWI9bNAUFtED+NCCOhAFCS3xUYK9A/+jkG2F8StYtUJrtxowP0zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cavkjbaB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cavkjbaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D651F00A3E;
	Mon,  6 Jul 2026 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783363717;
	bh=1F4cVT9XqQ98bNJa8TmYQAjrVun4eDTWcZr/fu/jPWI=;
	h=From:To:Cc:Subject:Date;
	b=cavkjbaBoGGb1Jr+J2O5K0NW7FEhyAJ4G/jmFlGMGuuyCkTKeTh65EdKmTRqBWVtY
	 f3MpTj9p1K1IHU9zgl8W03nEHdB6XnYhSNmGQ30xlQ+mJtgRGNVbDSWl64sfAnB2SN
	 siIZwd/TnlElp8b8TjFKEODlCBxRDpS31+u2DM3swWJHphnH7xcMPIhRbuYE1rYzkP
	 wgeSLh2qXISU1xD1EeWMxwXP2yIYGDkGcs4LLSyae+ejkOqp5mUt0c4q635D1SfFCr
	 Hi8FQbRTQCGY0QyDD6GnmHm3pTKOftIOzj95Ab9dAdibedSdbw+XRIDoiZc9CNxKNf
	 ESvmOVlmzMcBg==
Received: by pali.im (Postfix)
	id 11D495D7; Mon,  6 Jul 2026 20:48:34 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 00/11] cifs: Various changes
Date: Mon,  6 Jul 2026 20:48:08 +0200
Message-Id: <20260706184819.22124-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series contains various cifs changes which I sent year ago.
All those patches are rebased on top of the 7.2-rc2 and there is no new
change in them, just they are rebased for new code base.

I pushed these changes also into my git branch cifs:
https://git.kernel.org/pub/scm/linux/kernel/git/pali/linux.git/log/?h=cifs


Note that patch "cifs: Remove cifs_backup_query_path_info() and replace
it by cifs_query_path_info()" is removing these lines:

-			move_cifs_info_to_smb2(&data->fi, fi);
-			fdi = (FILE_DIRECTORY_INFO *)fi;
-			si = (FILE_ID_FULL_DIR_INFO *)fi;

And I have feeling that in this old code (which is being) removed could
be a buffer overflow as it is casting between incompatible structures.
I have not spent too much time with it as the code is begin removed.
But maybe some AI tool could be able to confirm if this is some buffer
overflow or not.


Pali Rohár (11):
  cifs: Fix and improve cifs_is_path_accessible() function
  cifs: Remove code for querying FILE_INFO_STANDARD via
    CIFSSMBQPathInfo()
  cifs: Remove CIFSSMBSetPathInfoFB() fallback function
  cifs: Remove cifs_backup_query_path_info() and replace it by
    cifs_query_path_info()
  cifs: Fix validation of EAs for WSL reparse points
  cifs: Validate presence of EA $LXMOD for WSL reparse points
  cifs: Check if server supports EAs before trying to set it for WSL
  cifs: Extend ->set_EA() callback to allow operate on reparse point
  cifs: Create native Window socket file compatible also with WSL
    subsystem
  cifs: Add support for parsing WSL symlinks in version 1 format
  cifs: Add support for creating WSL symlinks in version 1 format

 fs/smb/client/cifsglob.h   |  10 +-
 fs/smb/client/cifsproto.h  |   1 +
 fs/smb/client/cifssmb.c    |  79 +++--------
 fs/smb/client/fs_context.c |  11 +-
 fs/smb/client/fs_context.h |   3 +-
 fs/smb/client/inode.c      |  98 +-------------
 fs/smb/client/link.c       |   3 +-
 fs/smb/client/reparse.c    | 267 ++++++++++++++++++++++++++++++++-----
 fs/smb/client/smb1ops.c    |  35 +++--
 fs/smb/client/smb1proto.h  |   4 +-
 fs/smb/client/smb2ops.c    |   6 +-
 fs/smb/client/xattr.c      |   3 +-
 fs/smb/common/fscc.h       |   5 +-
 13 files changed, 306 insertions(+), 219 deletions(-)

-- 
2.20.1

