Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB9F3D091E;
	Sun,  3 May 2026 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777832272; cv=none; b=Rf/lraHVlO8FmuCzS4y12hrq5UZtVqAE3KxZj+MdYtNidWq5c4tLuTT4PBQqMg/gOp0dAENFfyok3JuECeMaQL0bVCqg2h5dvHuoK0TU04+0xrI/XsF30e4tUXuiUrn8qrvMnU/wnXJ3exhfOnFRONCKXh+rKapzAHK2tfMzgXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777832272; c=relaxed/simple;
	bh=K2ZsK7aHnkiscMKQuW5eEQeMVLWjvtX361I1jQXLeYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wwcm7J+97JVquNZiKW0NQKByPNH/B6NPg3+WWViC8smGqt1NUkIqWujMRd+wSIVdIYB3wr5aEHQvANnNfZY9N53RL5M/k9BdJAkZVm/chYWs8VTKO/Q50Gl5FDLU71N3vRI7VQtw9PWRfitO+Xl9MJ1DQgUNkfLQ3YH/DYluunc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvZAmaKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvZAmaKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E34C2BCB4;
	Sun,  3 May 2026 18:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777832272;
	bh=K2ZsK7aHnkiscMKQuW5eEQeMVLWjvtX361I1jQXLeYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvZAmaKTMW+BFgsE/O93gul4+5v696+j0jt41AU7VzK5jdHc4weXI7vRotpD6NCT9
	 OvrO+SdL+WDqK10eCX2uymjpnGVDREw3JF4fqVRtGUOpvJsH5Fxf13EDJDFyonLbMO
	 jiOkDwfgZkvtPC/WbBRVnOyHqy7W4Yvo9H/vHsVU1kmKeKldpe0cWVwuyR//gJgtEK
	 cJjah13Qy9z39aDYklwtsqxOI3rGfjqmO30mVGCGyO8Kjp4zW77ZLFZDuFFoxdGOD7
	 GZXXCAC4BAZdurGpgCzmLTZxnA5avrhgnYBGBvP45nc8JDyITgyaVoT4sojMj+8Rb5
	 a/MjxKTIF6neA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Kai Aizen <kai.aizen.dev@gmail.com>
Subject: Re: [PATCH 6.6.y] ksmbd: add chann_lock to protect ksmbd_chann_list xarray
Date: Sun,  3 May 2026 14:17:48 -0400
Message-ID: <20260503143410.item002-ksmbd-66@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501225152.90136-1-kai.aizen.dev@gmail.com>
References: <20260501225152.90136-1-kai.aizen.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, May 02, 2026 at 01:51:50AM +0300, Kai Aizen wrote:
> From: Namjae Jeon <linkinjeon@kernel.org>
>
> [ Upstream commit 4f3a06cc57976cafa8c6f716646be6c79a99e485 ]
>
> ksmbd_chann_list xarray lacks synchronization, allowing use-after-free in
> multi-channel sessions (between lookup_chann_list() and ksmbd_chann_del).
>
> Adds rw_semaphore chann_lock to struct ksmbd_session and protects
> all xa_load/xa_store/xa_erase accesses.

Thanks for the backport. Unfortunately I'm holding off on queuing this
(and the 6.1.y / 5.15.y siblings) for now.

The backport is faithful to upstream, but on closer review the upstream
commit 4f3a06cc5797 itself does not fully cover the race: there are
xa_for_each() / xa_empty() / xa_load() call sites that remain unprotected
after the patch. Shipping just this commit to the LTS trees would leave
the same UAF window open.

--
Thanks,
Sasha
