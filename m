Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A072F12C5
	for <linux-cifs@vger.kernel.org>; Wed,  8 Apr 2026 15:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775661533; cv=none; b=MsY246SaxL90gPZ2pLsTe/qsDiFSoHF/4vGUnGaY5GLs4bu5Rn8pGjwp7SwO3qbdwT3TN7PIFgW+D60ZgPI4HLn0HQ2IhTHiPoPdYf5mngzV6AgYa4FUSEVft+E2DFjvhsAHp3N6QVwIVIV42CzDqCOw9wzI/oVYK13iG1Yv6kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775661533; c=relaxed/simple;
	bh=GnwysdagezHMbsaP8ViG9hXyy8Fmo4jJ9pGNg9lg7X4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ufq38pqMcV5h65ydNrQYBPpJsD+44lJrPO16UFnmjCaU9N4DFmXYG+BDymuF/F68ry1B/wyNL5uc36E7aH3k55R7LtKG6+19vHNPOfiC/xhecR+hCPhp4MzRCgz6dUKVwNFgJO4UyFe6Bb84tO6/i6EMkA3zEZWYZioioyilMLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=INAU2DWY; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="INAU2DWY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=GnwysdagezHMbsaP8ViG9hXyy8Fmo4jJ9pGNg9lg7X4=; b=INAU2DWYwcZVvNRw1nn1I52tb3
	j0zT0Z2+nsuQers4+wJxEhiELKVtskv+uqpSm79mvFGwmusN1okmwJ/INJzshVGLtuD+wKE8KBTw0
	ntZDrjceNZ1CpP+rpdbnKHfFqjlS5ljeWC6/6VUVM8zPzEmAGnS5e9cXOKcXKKHuzIhB6YEWTqNV8
	8HMHBxb3wfb9gilB9BsWDMqlQU+5syBJueV0oV3MreW0Ndy6di83/37S/Ft05H/hrqX2bKctHSitx
	Vsw8RQx+SEWh61z+dQI5HvugixZcCySn1ND4THzr5ZkN0ehnHZ0FGU+ZEzIZbeKKy6MNKOIl7qL0a
	2jz6EdLjJ5Dd0sQM4PLlJYCtx7Q+HtsznYMuGuLwviXNjYt88sAx+LKsPzi0nu2WYNc58t7FkCqJg
	DtrsW5uX0Rle5rRKvC9xt8YQAH6IK4cjoIOTedssitCsGJbj+Vfy62izjZv2mXDMqtnnB5za3GxDK
	ebKzeo5hI+fw6VkT/oD0vadL;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wAUfy-00000007tVo-1xZX;
	Wed, 08 Apr 2026 15:18:42 +0000
Message-ID: <1b0cab31-e871-4ff6-9529-6e5294358479@samba.org>
Date: Wed, 8 Apr 2026 17:18:42 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SECURITY] SMB Direct: double-free of send_io on ib_post_send
 failure in batch flush path
To: Ruikai Peng <ruikai@pwno.io>
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
 tom@talpey.com, security@kernel.org, pc@manguebit.org,
 linux-cifs@vger.kernel.org
References: <CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com>
 <72ccf23d-f3e1-4e33-9eb0-4b4c9cd6d504@samba.org>
 <CAFD3drPDXtzHpRLMNcdV5cScBVTkXZgQZwkfxi24LG0ins956Q@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAFD3drPDXtzHpRLMNcdV5cScBVTkXZgQZwkfxi24LG0ins956Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hey Ruika,

> This looks good to me. Thank you for the patch.

Is this an "yes, I tested that this fixes the problem"
or "the patch looks correct from reading it"?

Thanks!
metze
