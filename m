Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FFE335BA
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 00:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052498; cv=none; b=X0Z3EIhwlI4DMDQdXSt7MQuEFMUEThB3DMznaNr3U2tkQk54xR7V2eMtpeiOJ3nW2K7PLAdZftFU4OC39xxrLwJMjsz1dvbkZqgeUYuYRmKdyLECrIseMSwFfS3N3AP21l2+y56HFPt73/u//KfPFtAr2Ss1Bxfs0cunP9llkdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052498; c=relaxed/simple;
	bh=vfJQsbxYjfUK4lXNLp4DHHv+9Do7Tlqjav0uwPJhgVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S2OwbekJmsTX2tsk6xyzGtcpUJf/ngzRNwy1MHie5h8/khyBYYxUYF6Tk3z1zza1fuaCh6yRYOCGToO9BObxW/9UKYRCIMAKhukQJSBaQ2YRTrDAivpIexYISf1JTUYL8QcSLREmuAawGHe7LXzYrv5QYpREpzmU6xb/rleRrHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=CMX2VXk3; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="CMX2VXk3"
Message-ID: <f150473b-549b-48eb-8f33-3a79e58d6547@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1781052492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=quZk+e6xPQzeJrwMYlm2pT+TJnJHXeJQjAGye8+nAs8=;
	b=CMX2VXk3IQ/hNupBQ1rqjz7xae6ymPqrrkQwN7Waa359j5jV0XE17Qf249V/yiSGhdE01G
	uubRA9Dat+wh94GzM8DXV4Q2VTENEi4HzX/s/eMjlhonuMxvSBLjvB5d5zyMZn7nj3TEH4
	nqyDu+EDqKtC0QOLAiQQMhbNNZ7LJwnQo7QtyEcsqNrbI8ovutNM8p+7ZVmaqH8CdvQ1OL
	6SpQS9EuK6sOhxhUu0sct8VYPmFDmZ3MWdCxIu3Jw5YzN5SvUsZcpvLXcSQbvTGnE4KUXI
	fA1J5Rv6Tw1hWB+sSxSLfuhFz+N5/KbciaESnVuRtAeLbOmAsEhnFchJWokbvg==
Date: Wed, 10 Jun 2026 08:45:39 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: generic/004 server bug
To: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mvP9s_KMc2G-_AsP__G0S5JCmrigOT-7U_ZNu1pLf+Q2g@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAH2r5mvP9s_KMc2G-_AsP__G0S5JCmrigOT-7U_ZNu1pLf+Q2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

To help others who run into this issue resolve it more quickly, here is 
a link to my fix patch: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4ec9c8e023c7

On 5/11/26 05:36, Steve French wrote:
> I noticed generic/004 fails to ksmbd, likely server bug since it works
> to Samba and Windows and Azure.   Test generic/004 was recently
> enabled when O_TMPFILE support was added by Paulo.
> 
> Ideas welcome on the ksmbd problem this found.
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: chenxiaosong.com
English Homepage: chenxiaosong.com/en

