Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B641350DE
	for <linux-cifs@vger.kernel.org>; Wed,  6 Mar 2024 15:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709739839; cv=pass; b=rOjNm4lPLDF45zRn2ycUPBAvjum1AolOuau9OigthKUkdSg+uiPuoQ54dNB7OvgMOCr55eTO7M6gKb+lsUj6aboFmm8HaO3y1/fNAXCsMlBy+9rU8HC2ku+526kWleEBV5ZWAMXpagwWcmSqMVDkvJpTvzZQxko2k10KFQfNhik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709739839; c=relaxed/simple;
	bh=aWwVbxwrXW4xgpwN4kM8nYw9UgMCI19FTHWqwVUzLrg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=p1t19e83P9l4RoIqcTI+Lw0SBXdreJhBOxB41+EH33LOTptTg2VRmqD/LOPfb/JX3oiKmDmkg3vpp/vhwAzopmMLDH2sXkbRqWSq18cBWFAg9dqXOsSw6hs5yyFz8XaoLBDR4Oig9h6oqzjBujD3zFLag5OJNsYe+2fVr1Lo3p0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=cl+4DJFw; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="cl+4DJFw"
Message-ID: <f395be9305cbe75c3171a84e45db42fe@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1709739835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tXSIYFG/4/ukT0PcZSabsVA3bH3EDgPbUhhA8fLaJds=;
	b=cl+4DJFwpFqF5jcR43+BA4DnV6lqabZZvQ+RKq7Lg26wZUqflW7OELP0rFiE3ktMamXfgc
	P5giEDphedMD0eqyS4T/VXGzYJxp9JtOBQ1/ZbH6JPFB58va91GUiA8ywDpWRNylHf1foR
	YFAMTOGjxrv0Nmb9kRuCZgS09u2s3V8ANzG80ftH2omtduapqFqPBa+0lUYzHd960xAr43
	LypI57qa8AQgVZyMbxJZEz70+0J06Goh0dniSq27qBIIJvocUo8263sxACRwd9lGbytnrF
	khW9hnV0rPE2oAXutRjM4tjD05u/JSwiLTHMXykwgX1aVDn8jnHuzPbCbmdswA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1709739835; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tXSIYFG/4/ukT0PcZSabsVA3bH3EDgPbUhhA8fLaJds=;
	b=ke6732YZqd7j1oLF26qGV4Pbaf+0BssiFpLRKi/pxAr55cyC+YHILsYLF8Xl/rHQK7wav9
	iQ87xgQBlsk2z8sGO3aw92cbv9iMM0zJ8U0MDjUp5/tAPnF/YIikjspGpbtMlh10QjZ14x
	LyNJMnwxLuZYeXV8j8vOVktJ4Ve/L5oZk+fMdSYmyKmYiUKFLcdVtfOgYXRn6fK9om31qZ
	jZ1o92WNO1oQvhdpeFwCg8XD7Of+bKtOKQvSWeDZHkJpQr0cAQor+2FVAkzbldZv7NiSeq
	uzicP0mORSqQjpBn3YTh4VNWVhFqrs+BskW/0y8BDTQjKHCiwTjmoLEkxEA5wA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1709739835; a=rsa-sha256;
	cv=none;
	b=a0EWmbWuIXk+HXLvgmK+P5ihHw37R/vOv8KLqhdK5XiFkJhgMpfIvvjBf4GN/S74f3w68K
	pAVt/BPcOV0i4zXJv7un1pLNUdIbiL6OQPitLb2tA+Dj6nrNV7OqQ0gwAFhrIZPAfwhDJc
	tFS6SA94/xxqY8lOSB+4pepTJa8189BCm/zTCrg+Y0kPMSL3QFDYuZZA9umc/nFrxJgbBH
	k+FtZLkosuydUIYBoIGZ4NukTIsPVe6GUO7zr9tk6dd8jGnS+qDGucNEHPMLCCQIpj4UbN
	JFK65CY7FzLMdkGU6G3a/cw1HxQ2Poq2D2VFF7nDHbhzb7yBX5dwwMQz/Sxc8w==
From: Paulo Alcantara <pc@manguebit.com>
To: Shyam Prasad N <nspmangalore@gmail.com>, Jan =?utf-8?B?xIxlcm3DoWs=?=
 <sairon@sairon.cz>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, tom@talpey.com,
 linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>, Stefan
 Agner <stefan@agner.ch>
Subject: Re: [PATCH 08/11] cifs: distribute channels across interfaces based
 on speed
In-Reply-To: <CANT5p=oFg28z7vTgyHBOMvOeMU=-cgQQdiZOw22j4RHO94C3UA@mail.gmail.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
 <20230310153211.10982-8-sprasad@microsoft.com>
 <4b04b2c4-b3ff-48e7-9c24-04b1f124e7fa@sairon.cz>
 <CANT5p=p4+7uiWFBa6KBsqB1z1xW2fQwYD8gbnZviCA8crFqeQw@mail.gmail.com>
 <2abdfcf3-49e7-42fe-a985-4ce3a3562d73@sairon.cz>
 <CANT5p=oFg28z7vTgyHBOMvOeMU=-cgQQdiZOw22j4RHO94C3UA@mail.gmail.com>
Date: Wed, 06 Mar 2024 12:43:51 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Shyam Prasad N <nspmangalore@gmail.com> writes:

> On Wed, Feb 28, 2024 at 2:52=E2=80=AFPM Jan =C4=8Cerm=C3=A1k <sairon@sair=
on.cz> wrote:
>>
>> Hi Shyam,
>>
>
> Hi Jan,
> Apologies for the delay.
>
>> On 27. 02. 24 17:17, Shyam Prasad N wrote:
>> > These messages (in theory) should not show up if either multichannel
>> > or max_channels are not specified mount options.
>>
>> That shouldn't be the case here, I checked with the user and he's not
>> doing anything fishy himself (like interfering with the standard mount
>> utilities), and the userspace tools creating the mounts should not be
>> setting any of these options, which I confirmed by asking for his mounts
>> list:
>>
>> //192.168.1.12/folder on /mnt/data/supervisor/mounts/folder type cifs
>> (rw,relatime,vers=3Ddefault,cache=3Dstrict,username=3Duser,uid=3D0,nofor=
ceuid,gid=3D0,noforcegid,addr=3D192.168.1.12,file_mode=3D0755,dir_mode=3D07=
55,soft,nounix,mapposix,rsize=3D4194304,wsize=3D4194304,bsize=3D1048576,ech=
o_interval=3D60,actimeo=3D1,closetimeo=3D1)
>> //192.168.1.12/folder on /mnt/data/supervisor/media/folder type cifs
>> (rw,relatime,vers=3Ddefault,cache=3Dstrict,username=3Duser,uid=3D0,nofor=
ceuid,gid=3D0,noforcegid,addr=3D192.168.1.12,file_mode=3D0755,dir_mode=3D07=
55,soft,nounix,mapposix,rsize=3D4194304,wsize=3D4194304,bsize=3D1048576,ech=
o_interval=3D60,actimeo=3D1,closetimeo=3D1)
>
> Hmmm.. That seems like a bug.

Yes.  I see a couple of issues here:

(1) cifs_chan_update_iface() seems to be called over reconnect for all
dialect versions and servers that do not support
FSCTL_QUERY_NETWORK_INTERFACE_INFO, so @ses->iface_count will be zero in
some cases and then VFS message will start being flooded on dmesg.

(2) __cifs_reconnect() is queueing smb2_reconnect_server() even for SMB1
mounts, so smb2_reconnect() ends up being called and then call
SMB3_request_interfaces() because SMB2_GLOBAL_CAP_MULTI_CHANNEL is mixed
with CAP_LARGE_FILES.
