Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DD8384242
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 23:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777158138; cv=none; b=lWRqiSEcp6RIF7nIycr8JjbOu6/wwhPiWOVO8uUi0xPQ40o60Y73x8qtCcJOUUqyoFEW8FynL8TGt6QpiTQlC35KUFNo8557fAlP1hdExxmlryzq5Ubxob/z8kYOqos7eZfWghUNtktxfkiBUxRsoQ/KQQG5E8KXNRILSG6EvSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777158138; c=relaxed/simple;
	bh=lgAscZeGJEajWb71MvQbKXc3Yrehk0mCapJuqOJ7b+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bDx88V9VuU9FY3RE2VDxAXJBXS2tqigh9vNPpFk+JZYfu2LQDcmmmi6Q79osLLFaEei4WqjsUHB221v39bU5eLz2LiVhy2fgnAYNQnr+uI68NbrJtOnMUebwu9P7ucmwn/vgHnf2eCIIKs9LNKrFoH15MiKaOEP/kTyWyjuVlF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=VnTc4KLH; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="VnTc4KLH"
Message-ID: <5af92cc7-9767-41a7-8791-ee87687e6df3@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1777158130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1nWeSSW4zE1n0Zzv3OlprkdpOlEx9r50j2O2xYOVRqk=;
	b=VnTc4KLH7yoQTCa16k+93DtpfTl77CY8CtXiWVJNZ0R+MVP9PKUrLx2J0juZP2uk8QLwwU
	k+Rpy04m+x+1P4wvy4WM08qov10+Uf67EDE2BlRTJDMMEBQ229HPXcGKa+cVcsyEt338bM
	rO5zHhElY1XUiTmnnkgqdq/VWewyKREk3+HOzdSmrN/W5Wy4/7HFCyU0/D9Ak+w76q+ljz
	Rlu69YQfKP09xTfvYX5F0EUzy6zuE1brtQ+5h0NBuVjA1tFWUR36h+BsZrpPQsvZv38+CB
	K9AtkBSX1r38pQZbdKK79Uw7rOb4JvUoyLVyvI+MJvvdAKNYr/M44hz7KBmfeA==
Date: Sun, 26 Apr 2026 07:01:53 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/client: fix unaligned reads in wsl_to_fattr()
To: Steve French <smfrench@gmail.com>, Youling Tang <youling.tang@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com,
 chenxiaosong@chenxiaosong.com, gregkh@linuxfoundation.org,
 linux-cifs@vger.kernel.org, Youling Tang <tangyouling@kylinos.cn>
References: <20260423055915.695024-1-youling.tang@linux.dev>
 <CAH2r5muDQM93tWbEtjbYsUVjnQcERKhCHjwmJJmjcA54ZxUS6A@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAH2r5muDQM93tWbEtjbYsUVjnQcERKhCHjwmJJmjcA54ZxUS6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Some older architectures require strict alignment, we will set up 
virtual machine environments for testing.

On 2026/4/25 05:41, Steve French wrote:
> Were you able to reproduce this bug with a test?
