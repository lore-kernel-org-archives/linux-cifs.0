Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D55B1C8FA6;
	Sun, 15 Sep 2024 19:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726429556; cv=none; b=ojxZ2LAuQgBzVenEdeJYppaL67AGUMzSLfLPfT4vjldwFQOLqK4780wNqNrYj6NCZhXEZZgbREdM6800DZgp9toIMJfbmKWwFAdVfxY2/CcuNgkI07TJvNw+63tkzdb/jLxi6+AlS2WPvDWnHPdSYoQebBOWP2s5KcI0jsgs0rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726429556; c=relaxed/simple;
	bh=HclElrmg3hy8k67tn/YH6FGa6YDj21hBYAJBNd6TKPY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kib2DrxxohYU59HAYiHUbMKZD4bcAqOiaDBbLLY7WO7XxcuTSMTTB5EbEbN9TSv2J/D1Ye3kbQMZRaAzggv9IimGzOYpAtQ/7apfc2lr7QmiURdAJbXoKU92FpYszdztxcb39BXRLw5BI3xkalWtn0fL9Oe1Lf5K4Vll95JDWqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKo+X6r6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKo+X6r6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD6CC4CEC3;
	Sun, 15 Sep 2024 19:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726429555;
	bh=HclElrmg3hy8k67tn/YH6FGa6YDj21hBYAJBNd6TKPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKo+X6r6vd11nrL+jV6DpVe7XuvSwsqan6Es7E9TyQq6lihH2YsHH6MCNJ8BUtFmp
	 rD6AMlULQaq8DienUVQNSfJMP2NxMH2ykGrP5tiMkJFrjBO6QPLuDk5F4Tjy/TVa4V
	 12VzAKW6BIJd0HfFzpwL6wZF+P9qIUmh9t209XKVKTrzdx1vs+LzSyUAeFW5gFqJBC
	 S1LkuJ0ZJTabEesb5fyBHdYIYNmGGuiv/6LISGja1ZxEsoXdPnfjqfEcqe5wTmEi6x
	 d7JF6rp+N+/kq25LrG0c3041EEGTEBvY4MSx+NpDBVgATMcavnAgyW6R14bEwWNfcI
	 HaNbMFgcghk1Q==
Received: by pali.im (Postfix)
	id 2832A7BC; Sun, 15 Sep 2024 21:45:50 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] cifs: Improve client SFU support for special files (2)
Date: Sun, 15 Sep 2024 21:45:41 +0200
Message-Id: <20240915194545.14779-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240912120548.15877-7-pali@kernel.org>
References: <20240912120548.15877-7-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Per Steve's request I'm re-sending changes from PATCH 6/7 and
PATCH 7/7 from patch series "cifs: Improve client SFU support for
special files" (Sep 12, 2024). There is no functional change, just split
and reorder.

All changes are:
* Use ARRAY_SIZE() instead of magic value 2
* Patch for SFU symlinks (original 6/7) is the first one
* Patch for SFU fifo/sockets is after symlinks and is split into other
  tree independent patches (socket, fifo and comments), so every one can
  be applied separatetely or dropped if would not be acceptable.

Pali Rohár (4):
  cifs: Add support for creating SFU symlinks
  cifs: Fix creating of SFU socket special files
  cifs: Fix creating of SFU fifo special files
  cifs: Update SFU comments about fifos and sockets

 fs/smb/client/cifspdu.h    |  6 ---
 fs/smb/client/cifsproto.h  |  4 ++
 fs/smb/client/cifssmb.c    |  8 ++--
 fs/smb/client/fs_context.c | 13 ++++---
 fs/smb/client/link.c       |  3 ++
 fs/smb/client/smb1ops.c    |  2 +-
 fs/smb/client/smb2ops.c    | 79 +++++++++++++++++++++++++++++---------
 7 files changed, 80 insertions(+), 35 deletions(-)

-- 
2.20.1

