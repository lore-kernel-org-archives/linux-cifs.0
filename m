Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDD83DC4B3
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 15:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773241839; cv=none; b=Ds4QEh5C5iiNylhNDW+BGkIri6Nt8bVH6s8mbCPM9e5AWhH0jj7kymesE6uJoStt8A63d8j+z6u58AM6HqbLa1qO88xB+69zjaUWPnqXE2hJ6ir6wvpZhjfnIlLNfs3eoHwsogJ6PQZufiTGfs+gRTl7QA/3gMzKmLDvgjXcHbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773241839; c=relaxed/simple;
	bh=vuoTPZ4olNZ3JgU6ufr998sJTi6pH1xyPtM9jca3G2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O9dh7tG9m6Ym0FWmauHPyqI1WdJ4ZyGZUkSGfEY5Xr1EjtIhw9GagpsqnJ07aNitbaw9ei5f5lj97D5jTzCyD8zJj7pTj5Oi/r0XP6iNVVvtZw8Dt5snosUTIQPRxLuXopuRpjk5gqRmtbBWFkMs7X1MTz2ddq2ySMg5+ZqE4Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=FEG92/Ug; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="FEG92/Ug"
Message-ID: <e7835ff7-36cf-45a5-9e38-066fb181ab22@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1773241829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jcly24vkei79ITCaxMTwElqF3W80V9wFWNWJJFCxJRg=;
	b=FEG92/UgJigg2/32bj5XkodSiyWnZ2c57ne7HJlLRU9WlcbRpULa/H/PIGC52SH/B3wX/5
	/TUk2/EfBM5M19XY/IvGNwpOBSFhhaqnptHduPCrkqk0UEYtTTTlwFbHDGocorQpxrvlHb
	DJ4UCFk2HAPM2zX9UK7DjW5TTTtogFAiS9x++wMdqAlj+BcgNv7SEj2xi5t4geyaKa6BrI
	JXgaRJzlWBBSSzCH1FabOgItllb3/mdWOaGQ8UpqgqGnO+sMAhV7229862gzIoKQL5r9vE
	yiWcGinRTozlbj86WJXQtm0+sOAMCbkvJOR6ehBnZ0QwTyKh3PntwUHgUag/7w==
Date: Wed, 11 Mar 2026 23:09:36 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb: client: fix open handle lookup in cifs_open()
To: Paulo Alcantara <pc@manguebit.org>, smfrench@gmail.com
Cc: David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
References: <20260311144055.523527-1-pc@manguebit.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260311144055.523527-1-pc@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There is a typo here: "defeered", it should be "deferred".

在 2026/3/11 22:40, Paulo Alcantara 写道:
> +	/* hard link on the defeered close file */

