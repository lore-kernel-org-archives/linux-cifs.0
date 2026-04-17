Received: from hua.moonlit-rail.com (hua.moonlit-rail.com [45.79.167.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359DC19995E;
	Fri, 17 Apr 2026 00:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.167.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776387091; cv=none; b=Mvcal70y8P021xMGxcx+Z+0inKk6opE5oCIx1zmuvXLCENLcLIta3dS/rvYQ3r8IL5HOrNN6ig+7IJGyN/6b4lask/vqhHunfz48j79HEgc6nwQCVLIMMyvwrMjT2BJke16kYCjvGmBTm5TXhKZe+Tzp4f+Cjg2SoWGnhNMXBx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776387091; c=relaxed/simple;
	bh=XvKkcg+3HNqHDFUAErIbVbEPgdoU+vXQm4LyM3ANA9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nl+ySnn6LTJ50wHmfahIWqbgTTEFikKnOEdqgCFKcQR+YtRzWFcHIOc3DFioQlP1oFx8fa5+rZd+2HZFKjf+wBc7tKw709ib3SDvNz6XX0ZaEPEtx4ngokA35+gWDZyv/gsrTwcOov01MfcELEUyMS/AJwS+8hf6lfcPFj+uB0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com; spf=pass smtp.mailfrom=moonlit-rail.com; dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=WwvSvVf/; dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=fTyVNIll; arc=none smtp.client-ip=45.79.167.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="WwvSvVf/";
	dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="fTyVNIll"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=rsa2021a; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cMP1D1wINluhiAcRAfUUc39DZhfXLEzbsXa49S35Nsc=; t=1776387089; x=1778979089; 
	b=WwvSvVf/Vagk9YJuFdSuBw9Jsw5U20qWu85yUOrBbeBjSg/vFjw467jFoRASfvsGZj6VfkCed9M
	zfkXBDrRphoJxq8boF2I8HvBYOZehFHRNxRsaiYbxsNUPaEc7Jc5gAfP4C7QKcf6aIJTExiJFTW0v
	S+qA4MBt6gv84v4zOGldtlh24xt3nYmX8ySPmJLFx688QGUFHxJCvL6x7Zm2zZZjHuJQ62UtZIhVP
	WzjIiGio/505oMv3XPNm3ufYu26216JfpUwYxsJiYDIt97doHDaX2Xv+ogQIx9LDFr2k95Hlx6w/I
	IoIq+5cK4GAmM0alis18AE4E/429hsPfJuYw==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=edd2021a; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cMP1D1wINluhiAcRAfUUc39DZhfXLEzbsXa49S35Nsc=; t=1776387089; x=1778979089; 
	b=fTyVNIll87sHj4Jrkb+KZo9uNAhPUUj+QqYQ7Xo5wN/nHhXf3yuR5XggIa3fL/XbmSHL24+ngS3
	oRvLvxIuJAQ==;
Message-ID: <543303e1-8d40-480f-846c-ec9287e3bc2d@moonlit-rail.com>
Date: Thu, 16 Apr 2026 20:51:28 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] in Linux 7.0: empty CIFS mount point with vers=1.0
To: Paulo Alcantara <pc@manguebit.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Cifs <linux-cifs@vger.kernel.org>
References: <f758f4ff-4d54-4244-931d-38f469c3ff14@moonlit-rail.com>
 <9271841dd415d9d0b42ab91c575a1f91@manguebit.org>
From: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
Content-Language: en-US, en-GB
In-Reply-To: <9271841dd415d9d0b42ab91c575a1f91@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Paulo Alcantara wrote:
> "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com> writes:
>> When mounting a CIFS share with vers=1.0, the mount "succeeds" (is added
>> to /proc/mounts) but the mountpoint is completely empty.
> 
> Thanks for the report.
> 
> Does the following fix your issue
> 
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c

Yes, tested.  This fix works fine for me.

Thanks, Paulo

Kris

