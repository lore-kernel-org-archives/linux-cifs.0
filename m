Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234882FF65F
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 04:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784867900; cv=none; b=VQpBGt3eCYH5uQqtnqz3eQsHeao13SpmS72HTQsvUe2f0nlOUBZSQJztLPl2xmNlPoPPICHcLrlwIovwNVn837ctBUjxFP3/2TpjTZX0SdRJf2BqxT9HL/zWsNrUDnUYQ8zeY+1jp5k12za125BrxWBK6BhBmy9mib1SsujoPVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784867900; c=relaxed/simple;
	bh=nS+P3N+rcf0TGNHFy0eYQtXP9PPbze5VN3bdVv42MLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L7D6/7nYRNpoeG+YSbcDjJzEx9K8HIoQ2iUCzvfMHkAo85Uu3WVHx+/GIxUX5iaLEx6J2koJ5F/NArBR4Ry04aiBbNq3V72nr5YFB6QHSl29eG6PuXIc4mCOYAEOmO/Pugub+VUbVCJNP28T4HX9o1nKlpa0kX54mVgwwxhjwO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=QqMpcLC/; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="QqMpcLC/"
Message-ID: <7ad99c95-d1bc-4cab-9632-d00d8e7a1d1d@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784867885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1/t/UTZdlOqD7cZXTkMQ1x55KkkLhq2BUy1D6QELJQk=;
	b=QqMpcLC/t/mwaGn2qc1+1mTtFw48QpZdj5Lza39fUOfiooTSZ+JLFSVTErbptict2fOUpk
	a8wYbvnGIlepDP9HvaMMQqCiS6rXnR3CaKZcQsZZCvhI5XBRdsRM8D6vO20TFkxp9VyNQN
	HsMEeSG7ijxldPvLbz4fh5gS4RlQJY2nJDuVwaC691xPAW8Y/iCnmZ0U/RkPEz1QzACxi9
	5GzaKepu6ZcJMwa50rIRNj/iYCBVRIQ4/TUC3WbCC4F21NJo2K4EYL0hGHpTGxYhGWG6sn
	dGwNPIlEzGkwuhcxuhE4Jwn/8t8dL/J9IRQ1NzN5Q9XfyG9l03th2cozX5/qwQ==
Date: Fri, 24 Jul 2026 12:37:39 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: remove extra byte from ipc_msg_alloc() size
 calculations
To: Rosen Penev <rosenp@gmail.com>, linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260724013841.1345481-1-rosenp@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260724013841.1345481-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

No `Fixes` tag is needed. While the extra byte allocation is indeed 
unnecessary, strictly speaking this isn't a bug.

On 7/24/26 09:38, Rosen Penev wrote:
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

