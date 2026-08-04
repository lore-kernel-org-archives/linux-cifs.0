Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FAE4457D4
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 10:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785839106; cv=none; b=EArsYB8BWs2Z7aWgR5SgAGtwt6dl05925GPUwhaBTByo1dK3pD1sTTPdcK3+oxLJJ0gZv41nw3FqjNF8PqJk446Ixcp8TziJlOoMjPSxp+vIAwdxtHumdwfwd/QcCPfC8CzTpRiCTySa7NwA4GxfUu5rSwNlU24Od6wK5P15n+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785839106; c=relaxed/simple;
	bh=y1b0WBXY9A/8hLNHUwT1zaPxZp73MKekYlsKGfNTxR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JHmjOeyR2Owo7yiq2sUjhnmgllj23ZvJMkcAEXFep3Md6UwBNkcKnc4VXf/YWUx2R7sBitqsGI/Z0aIHx7vFm/jfldEcWLR2DxsJ/CeHba/nPl1/ETg/XP3aFz5OzseaZhfNkALvYJkur+7WJxTxyKPRMliw4CknPdrmH972HX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=CK75oi8d; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="CK75oi8d"
Message-ID: <31a2fb2e-c65c-499e-885f-b2f483d07e31@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785839099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lmh0l0qcbd2UO8BtLf5u6/vXLXHDHrOupZP+qaeBu48=;
	b=CK75oi8dlzFSc1sGk1yJA2F/P1gPwsniaSphmk0lklqhv5Q7UXLD95ZsDvZwjDG5tBJETW
	AprpfJF54V08moiqwr8HBPPbssCtydZpvq8e8Y9P38qZOnphBJZ5MMyQh0sh0betO/FILQ
	bn4MopZwio1QJINqrE5/fb9gtGy15rz2kSq/XGAuaprh8ID+MJARtqL8HmjQmW4TQygthd
	yBkZGdEOzedgxbxEV6A1Bk3sBJUTOgUnuYOvOLzwadtovJJyg2Z5YEdY4XsqK8+xBW69aS
	1tOfweZns9CfT+8Cjp/v+qzBG8vk1RD0syky68Q/bP6B/VdjGjz762EcyiOgyw==
Date: Tue, 4 Aug 2026 18:24:00 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/server: check destination is open when renaming
To: Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
 <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
 <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
 <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>
 <0b0ea9a9-8784-400b-bbf6-efbbb8869dc4@samba.org>
 <4e7ac5e3-3116-4828-89c4-8e866dd267d1@chenxiaosong.com>
 <a6a6913b-7a85-48a8-ba65-13fae188c33b@samba.org>
 <8216197a-9265-487b-b2f7-be9548d4f497@chenxiaosong.com>
 <fd62c916-5915-4f6a-90a7-376b6bb963ce@samba.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <fd62c916-5915-4f6a-90a7-376b6bb963ce@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

I am very interested in contributing to smb3-posix-extensions.git. Would 
you be willing to let me try making changes to the protocol?

On 8/4/26 18:11, Ralph Boehme wrote:
> On 8/4/26 12:01 PM, ChenXiaoSong wrote:
>> Should we add these rules to POSIX-FSA?
> definitely! :)
> 
> Working on it...

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

