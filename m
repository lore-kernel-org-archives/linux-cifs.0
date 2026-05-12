Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53872347C7;
	Tue, 12 May 2026 00:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778545111; cv=none; b=X5pI2ZTBJcHZSs9eA6p2fSFMN2cECnFuFf4iia6s5KV2EQ4fIfnrDfwyejwMh3cSaZm+HxVMWtuCr18PDoIi1jmU7pjl27bImQzFzkmHq+u07nxyvuFjQOolYpZyf4RORfJVCYLIJkTxV7gV2MrtPY3IoA6IsNtAfahGgkrE90w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778545111; c=relaxed/simple;
	bh=PDhwn6OrwqgCLcbPNdS6brDF05+Vs69+E+2bq3tWI+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kd7lERFQk8SOrCSQAab3gjkvu6O/w8GVvtruH5FhINIcIL1FXKkRgDm4ry2L2sIs7ALFeRrfRJOHnAULt2ZtT17ugpqhCZsc8nT3m8QlKl3Db52WZGPAwAWGOsooFRAj0XYd+LD/amtxIJtjOzAISOwuGetgfC2ltFtZD+xRSyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hK4iNkYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hK4iNkYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA88C2BCB0;
	Tue, 12 May 2026 00:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778545111;
	bh=PDhwn6OrwqgCLcbPNdS6brDF05+Vs69+E+2bq3tWI+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hK4iNkYNyDDF2KQ1oAUXpGFb8YTJL27QMBGmf7fD1WON5KspRBawSw47QVOuAwfg0
	 aA16ZqrTOm94JxVunT+DVx1k9yuQIkDAU793KxowAlOo3F56P0si6NG8kPotlFTzQF
	 i6iPQJxMce1Nd56lsvyzOGJvWybXoWmBuYXz4n3QrN1FOqLZxyI4x5MQQkN3PVLRJs
	 XuAj9gjmQQ7aq6fARQ1gyOzhzZenqlv6dUkzsa70KK5u9I9Vx25sWEVnomYPdK8C7d
	 y3NaUmiC0aD4/wYAh8QQyMK+eG/+OKBoS+A6J4tZVrkdHerlErslpIM0Zw/hQK46ZM
	 nsR12ht/eUT9A==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: Re: [PATCH 6.6.y] ksmbd: make ksmbd thread names distinct by client IP
Date: Mon, 11 May 2026 20:17:57 -0400
Message-ID: <20260511220000.stable-reply-item008@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511124625.52768-1-mengferry@linux.alibaba.com>
References: <20260511124625.52768-1-mengferry@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, May 11, 2026 at 08:46:25PM +0800, Ferry Meng wrote:
> [backport needed for 6.6-stable to close a residual
>  active_num_conn leak. ...]

I think its needed for 6.12 too?

-- 
Thanks,
Sasha
