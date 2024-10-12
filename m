Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E30D517;
	Sat, 12 Oct 2024 08:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728723225; cv=none; b=uTjahVwEtLlM2YeqNQeedqcApWsX0jM/K+T6PdOg5oYZELBu6mgJ2E0bhXiO6ldgzQ1wjl5StE+5nZO6KT+MteE/ocB1ppIgvEL+J6lWtBYywv1eppoSmNGyb44Icf699iZYjguYNk+jSogH+RCs50BYgJzFtcncLtv802XnCaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728723225; c=relaxed/simple;
	bh=/OoY6xvI/5m2JRxXEl7Hmm9CfxwT6gT9p8SXvk4YVp4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l3PFdtPrC9SAihL+MvXm2VJyV7HUTKk6xxMSMFCi5sXdHlT2N3I00CrwE8XYr7lJcSyOzaVYxXKQsUPVza7qnymeK1oDDuByPvZCcumLZW3gRzjOY1oZ1TNGaLBL5q/YsqXYdLPVb+wQdynOtPFu9YSGjUvaAJNRLNRujnNsuZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V04ItqHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V04ItqHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBE7C4CECF;
	Sat, 12 Oct 2024 08:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728723225;
	bh=/OoY6xvI/5m2JRxXEl7Hmm9CfxwT6gT9p8SXvk4YVp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V04ItqHiE0BQ0kW/2vURrtUY27YN0kIPdGouZAlaJNZOlI2nWqTmVVZ7CIHJkoMRo
	 /eBwMkRa0J0/lJEzQ19WoB/LcqbpY+pkfZOX/iZcHuaDHBTugWv/mroiuXsYPDC5An
	 gbAey7TyK/ARLYs7WbVdGWKrC/E63mT+bb5xsIgY06kitEeJA2xET4juWiaXTkj23e
	 qxI9vBoH55s31nXQI4AUM2OwXrXzxL0fbq/tmMci7aYxaUdSP50BEKYiLalUGa0wwj
	 uVspSfws5ZzbQXLz7EnjfwN4ZWxFWunxyhtdhZs7PY8RIUZu1EegwKugF1buTgpYbD
	 /9PtvrMhmQfSQ==
Received: by pali.im (Postfix)
	id 7FD8B7BD; Sat, 12 Oct 2024 10:53:38 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] Allow to choose symlink and socket type
Date: Sat, 12 Oct 2024 10:52:45 +0200
Message-Id: <20241012085252.560-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241006100046.30772-1-pali@kernel.org>
References: <20241006100046.30772-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series improves choosing reparse format when creating new
special files.

Changes since v1:
* Instead of new -o reparse= mount option is now a new -o symlink= mount
  option for choosing symlink type during creation, and new option
  -o nonativesocket for choosing socket type

Pali Rohár (7):
  cifs: Add mount option -o symlink= for choosing symlink create type
  cifs: Add mount option -o reparse=none
  cifs: Add support for creating native Windows sockets
  cifs: Add support for creating NFS-style symlinks
  cifs: Improve guard for excluding $LXDEV xattr
  cifs: Add support for creating WSL-style symlinks
  cifs: Validate content of WSL reparse point buffers

 fs/smb/client/cifsfs.c     |   4 +
 fs/smb/client/cifsglob.h   |  36 +++++++
 fs/smb/client/connect.c    |   4 +
 fs/smb/client/fs_context.c |  82 +++++++++++++++
 fs/smb/client/fs_context.h |  19 ++++
 fs/smb/client/link.c       |  60 ++++++++---
 fs/smb/client/reparse.c    | 201 +++++++++++++++++++++++++++++++------
 fs/smb/client/reparse.h    |   2 +
 8 files changed, 364 insertions(+), 44 deletions(-)

-- 
2.20.1

