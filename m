Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8549331986C;
	Tue,  9 Jun 2026 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781014272; cv=none; b=Sx6uBN5a9qXWnRj2InWhcK+BS5xqMlSkFLZkwBvyYcn+lthvUVtRqdHWuUXGfl7rtR1wuGVfDp1IYk/dqeoc8P2QN9Fbc2K4fD3mnva0AEGKkDJ+bibIYhsDCaTrZT0gos/81u3kU+FxwX16aGHL8Iq32KDg1wTGCRy1gx9UHeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781014272; c=relaxed/simple;
	bh=KSRebOOzDBTm8UqGYcutr/I+JuUwHV+6lmOraLzLFsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxaLMOT4FY0LOES6G3IhAPFXozQ1MC8V3QCxbuPC5dRJoeXT/641/ijly/9Fa7mzxu3EYYz73WMmEQynzP2y1Xeg88kr9T6WF8pjmQktgNOIjHGdUBvMUhQPmoneKpXmXLY1JdR7ss2mjSaypQUY5hXplbZ3O8+QIKXENiWl85g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SuhcvxFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SuhcvxFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B2F1F00893;
	Tue,  9 Jun 2026 14:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781014271;
	bh=KSRebOOzDBTm8UqGYcutr/I+JuUwHV+6lmOraLzLFsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SuhcvxFQPh3gg1NkIv92D+Zdeegi7nQEwsDrLQULupZ4BBMHsx+97/RqHmeQ6IaAb
	 uOKMIIqr1KePH3qI4lT4jNr5RIksIhRu3lRijH+pDGh22aHAwt9RyuEBVbojojz8uZ
	 rb0EFKkdid7liRN+R9pb9Q/OBGf75BbgT7fqiUyopvWi5L4hntvvLyzvW4QKLrTH7x
	 5foMMF1Z3PIOf3H1WWJebSXWnwl9Tbx07j/9tNeZ2N2kU0NlHpJMhp9gtWX4UpCS6s
	 iyjhJENx7l0pZnGL6nd791T52BUP+drBElPtDtIFFUpJhZ/5/HHugMfFl0W/OO37LC
	 HLbyWUULj5VSw==
From: Chuck Lever <cel@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>,
	Roland Mainz <roland.mainz@nrubsig.org>
Subject: Re: [cifs:for-next-next 15/16] fs/smb/client/cifsfs.c:1204:22: error: use of undeclared identifier 'FS_XFLAG_CASEFOLD'
Date: Tue,  9 Jun 2026 10:11:07 -0400
Message-ID: <20260609141108.90414-1-cel@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <202606091825.Fvo4zzYp-lkp@intel.com>
References: <202606091825.Fvo4zzYp-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 6/9/26 6:24 AM, kernel test robot wrote:
> >> fs/smb/client/cifsfs.c:1204:22: error: use of undeclared identifier 'FS_XFLAG_CASEFOLD'

FS_XFLAG_CASEFOLD and FS_XFLAG_CASENONPRESERVING are defined by
"fs: Add case sensitivity flags to file_kattr", the foundational
patch of the case-sensitivity series. That patch adds the two
macros to include/uapi/linux/fs.h and folds them into
FS_XFLAG_RDONLY_MASK in include/linux/fileattr.h.

The cifs consumer ("cifs: Implement fileattr_get for case
sensitivity") landed in for-next-next without that prerequisite,
so the identifiers are undeclared. The failure reproduces under
both clang and gcc because the macros are simply absent, not
because of any arch- or compiler-specific construct.

Steve, the cifs patch should not be applied ahead of its
dependency. Either base for-next-next on the branch carrying
"fs: Add case sensitivity flags to file_kattr", or drop the cifs
patch until that patch lands. The full series is intended to be
merged together for this reason.

No fix is needed in the cifs patch itself.
