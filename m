Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D131A262D;
	Fri, 21 Aug 2026 01:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787274233; cv=none; b=LM6weUVDQ8/tBrSusCXfOYnQNo5vcfSH9ZertjXIYo77vzo6wxNFXSnVWazvdSQtvG8idYZUEgsdGul1HvVV30v3VY4npwNvLqg9cE3mOVlQC+mL02lhSTpTevd7Bs/9t8aHHOs2JxzRuCL+8x0rJL3QHmhEvrmAstgg4c+E2hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787274233; c=relaxed/simple;
	bh=vHlmQXt+2dpTWS+ko3KiwTPNlY/HHn5EObw0ePEsdwI=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=pExBqRELw6LpErgbGqevTZRTvIPKDJKQUjaInY/dx9m8gNYk2HJZs5pvQ3TX+amV4nQ24tfSxjrXJhvRzxv6/n5ZDKHyzXI5674Ku9wFdIDr++KMgAQQKmWdniMQrXGPUIVkd+jZ6mwWdmH9l2G/Gt/r0P5Kik9dxTewRbRmZ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=bPH4E9Ii; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="bPH4E9Ii"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:Subject:Cc:To:From:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=U6tX4rHjnCbEkmPOoaEfILDywWT/zgnW3sX0ar/qAjc=; b=bPH4E9Ii73rwoJWqnYYesFEIhU
	hZNKY88pzFaWPNkzMcDf91jw8rYbfDGFyyYsVgrcNcs0HSHjZoq0tdQIsiYI2bBXWpUBzy72TQRY0
	EJ9jqLtgHmd/ADYVTuHzms29Y1m9xWRaK0jJXm2y/4BSV08wQzsfCcwQjqIGVZCFAxJYBhWQyW7x7
	qWLiSQ7xZe2GUsQoeOSg4oDJzUMaQjFNq1udSiuG36n6hTVKxXFcz7AAAZpvMGUEbts7GQdNCldfP
	XFPJsDf8wwF12yJgYucsI7gllKOJR8v90kOX3/oJh7WxJ0fIIg8M69xjgpOFCKNSl3YAOUBD6SCUj
	oEox6hHQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wxDfX-00000000N6b-39Gu;
	Thu, 20 Aug 2026 22:03:39 -0300
Message-ID: <87d3741519271261fe69701617b20dd9@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, David Howells
 <dhowells@redhat.com>, Steve French <smfrench@gmail.com>, Steve French
 <sfrench@samba.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Al
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, samba-technical@lists.samba.org,
 linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] smb: client: replace Steve French as CIFS maintainer
Date: Thu, 20 Aug 2026 22:03:39 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Could you please pull this?=C2=A0 It updates the CIFS Maintainer record to
replace Steve French with myself and Namjae.

Thanks,
Paulo
----------------------------------------------------------------
The following changes since commit 8d3ae59288f1e7d58d76558a6ee96d533bc5019f:

  Linux 7.2 (2026-08-16 14:32:26 -0700)

are available in the Git repository at:

  https://git.manguebit.org/linux.git tags/cifs-maintainer-switch-7.3-rc1

for you to fetch changes up to 934753d26f1ed7fadeedf1b9e7df6fe75de303e8:

  MAINTAINERS: Replace Steve French as CIFS maintainer (2026-08-20 21:32:00=
 -0300)

----------------------------------------------------------------
CIFS Maintainer switch

----------------------------------------------------------------
Paulo Alcantara (1):
      MAINTAINERS: Replace Steve French as CIFS maintainer

 CREDITS     | 5 +++++
 MAINTAINERS | 7 +++----
 2 files changed, 8 insertions(+), 4 deletions(-)
