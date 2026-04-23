Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB46F3A783E;
	Thu, 23 Apr 2026 18:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776970778; cv=none; b=J9931SGt/fxGJ7ARla32Qc6tYQzy88BlxdwyfXMF8pGYsn7Ovb8XgZh7eQLEyfd0q6Ig0kZI8TCdP+YthsYkP20PSqLytuXyI+ZGdJ+exzdju+0pTI9s0BJNyCoBy0jA1lklY4zphsGr+HV+CwnjFH3zGOwwYXlLK2np93ZlP28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776970778; c=relaxed/simple;
	bh=89CpwZWpqz6tMu+rKPycm3pbZSmQA7XFPfnmi/2V8ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqZ3BP/LtxxgEDMp9nyb4KQBPLQ32L/MO1XbHN3ji0m8wCBhUCpnEZ18pKyxGlavSITN6Kqy6z2oducNV5MvbyuqO+iDfzNPjTToMGmPkIvDlbJ0CP5J5FCe0slUM8HsTJJEHbpJfJjA5b5yGQRaMUZH+B93qnWPHaGHOxMFVbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B6P9ju65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B6P9ju65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B91CC2BCAF;
	Thu, 23 Apr 2026 18:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776970778;
	bh=89CpwZWpqz6tMu+rKPycm3pbZSmQA7XFPfnmi/2V8ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6P9ju65CgdS/TxjbyJsj5gr8mme0lUX2y5Sue+pRjrxTW5DjJ2rqmWRZP0g4a6TK
	 b3W4utHhvZ+x3hLk9RVPtyuVGjSq/BtzDsG4LmqEyraqODBfHHYXMaRJBApnpUaCH2
	 7vYbLsSEghXq5PUryVx70tBbfQrlNI2JS2JvE9ddVbs8XoWJRl2vQHdFoqR9QuRGP9
	 /eHTfAqx/06VcKdeIHJ0KH8KZ2VBLZ/FW2FxNoUfyzi4aboFhPLwGOUaQZ3SmKrhpb
	 FtJiivRQx+obea2vsDIgcMVCQY1xvBziOlWmpEYBEjUn5eeHvcMBZoII1nAAYJNWjJ
	 ZGCwwG5Xa8ltw==
From: Sasha Levin <sashal@kernel.org>
To: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH v2 5.10.y] cifs: Fix connections leak when tlink setup failed
Date: Thu, 23 Apr 2026 14:59:36 -0400
Message-ID: <20260423185936.1060816-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <83e432c2-8749-aca3-b5c8-ea89edc75ae9@basealt.ru>
References: <20260423140245.195039-1-kovalev@altlinux.org> <83e432c2-8749-aca3-b5c8-ea89edc75ae9@basealt.ru>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Apr 23, 2026 at 05:41:12PM +0300, Vasiliy Kovalev wrote:
> v1 of "cifs: Fix connections leak when tlink setup failed"
> (CVE-2022-49822) is currently in queue-5.10:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.10&id=685f89e4d2b45768ca796eb22ec1a553fecbdf05
>
> Please drop it and apply v2 instead. v1 introduces a double-free for
> mntdata on the new goto error path from mount_setup_tlink() failure:
> after a successful dfs_cache_add_vol() the pointer is owned by vol_list
> (vi->mntdata), but the error: label still calls kfree(mntdata). v2 NULLs
> out mntdata after the ownership transfer.

I've dropped v1 from pending-5.10 and queued v2 in its place.

--
Thanks,
Sasha
