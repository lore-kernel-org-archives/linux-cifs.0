Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.65.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF351EF091;
	Sun, 12 Oct 2025 15:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.155.65.254
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760283285; cv=none; b=sBrrt+Ah/dLU18ThRyPmqFb6AmHyrFpcd0aOORnDd7qMb3HMk5f7F1JsRG2FrtGL7Rh0T95ee/02LBLinLMY9J8MOsX8wHbHRjqN8ImGEs9qCgI1ZQ+a0skV705U8Bx2alolJ704Ss1MfX8m6tf/y4nDl79XTIrDXe2hQRVIPbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760283285; c=relaxed/simple;
	bh=rFEmoy7d0Mmlnjo9o3/eglsjDXhVOxYL8WXs9SOdLzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LYYNMc/3mlrdOsIshRXBXvl+AVQLmcCkdeUG69hGwsHPEjB4TK7CdlqJFYumaKJeqEEF3Q0z9jTfuuDRmESpzPYg4Is35HKXiR9y/lmrtfyLgQDUXwCl3N/XRAhwpRirvgjxx64in+oFc4wJlYsHLrmoWfuZkXftB71OvCPXe6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.155.65.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz7t1760283240t1d9f9c2c
X-QQ-Originating-IP: DQzoWmT303r8f2j4nzHEzqyFNwEkd5RQW5qPYqwS4Aw=
Received: from [192.168.0.103] ( [220.202.230.216])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:33:59 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 16739186247763136303
Message-ID: <7A6DE7EAED2A073C+7e132ed4-089d-4fff-873c-de03ea76c4c4@chenxiaosong.com>
Date: Sun, 12 Oct 2025 23:33:58 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/22] smb: move SMB1_PROTO_NUMBER to common/cifsglob.h
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 stfrench@microsoft.com, metze@samba.org, pali@kernel.org,
 linkinjeon@kernel.org, smfrench@gmail.com, sfrench@samba.org,
 senozhatsky@chromium.org, tom@talpey.com, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com,
 zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
 <2AC3F0FD2E1F3D39+20251012150915.2992220-7-chenxiaosong@chenxiaosong.com>
 <d03c64d2-46c0-42d8-8f88-28669e921c95@wanadoo.fr>
Content-Language: en-US
From: chenxiaosong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <d03c64d2-46c0-42d8-8f88-28669e921c95@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: NbgfBr2LDT8MT9/MG+Eb31ZCS8dttLVn+rgzVnUJBIZPjPV5fMtdfwS8
	qaF/e4g/QqAtaEePFU4/PA1yGddj5gRil5c8DEXfnnPz7SZk3z9wQVsyHVQsukhpcPkAaL9
	FKkSpywvj9g/VcfXYrXFkXbO+1EvOk6UATEEJi4Y0aCSjKYseAZwhWOkrJjS8VjtNal/CdB
	OJikMW+Qe6nDjXZMzhdPlEyifkrsK8PUXoM3cjwgSOAGWg6dDXEEn11i7GJjk2oDiLdDKtj
	WZk7mz22mVBKEC9pHTQkW+9iudherg879L9gQEAvfjFK8G1hY+WxJ+Vbxqdf6OzTg8cdv8N
	hMXuybOxgcISx51Ea4GRfAtoOM96/nVUUu50OV88tT9mbd2873Dv1COjenif3DuyiJ2vlEM
	pujdXe1BSLHq3ROaGzB6gyrSVKQfhtiT3ENBXsx+6BV7vMr0hbK3plocwugrLubxDft0nfV
	eHRD0XrFe35vQKhaFKNO4oEH/RviLvCWpwNQP6rPVuk0zpnVXZKGgQ2rxgjKvakUoiG2/Xl
	3vj1c/4vdTnDGtYIa+ZPGyAbMZBJH51ujq+BXrxYgqAxbyIYlAJkQ/J6jsqbO96J9bR8oOT
	qN3wQUvzyaUlbiunRljfz9Q/Y/D1wGNj0JAv4f//60c80geCRGIWp9DOG2rjRQLcPoAlysm
	vrROB38bPo0O1ob06SQsW9jlAzVbegFgViuH3YF0ZGNG3zyS5v+cAFkgCDQxwAS8iLtEhiz
	4ZYfXUgdzOVlGCaBaE9q9vBTNl34nEwaK5QGwUsoA4+7OcVCZakdhxg4PnnLd6Ezq/P2WqJ
	bjzj3FFhoj3+2ER8hVlhbxkIvktADfZ6QOQcsFacJb0RIZO4ipRdN2yu2HMjz0riQQUKh+a
	vasB2OwmC48o4jVo1K3uCM3Ogmg5XXNZabWLyNvXVKFk1r/3KDTe9ZCMODzC5QvsMj1kF/F
	lQlDkeiTbSYOx1gxOt+qtInjzeqwXv0znbi1601CuteSYV0ZlAAr4m/QOaCeNzcEyj/6KC+
	nq8OygEAlfPYiyCDcsxAFbBnhYmMAGiFMzZGgEWEl5R4aOyoVmh3XuLfO64icCcz+/7ddW8
	o4ksUpNURf3bzPyMoqJOl8=
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

Yes, "cpu_to_le32()" should not be present, I'll send v2 patchset.

Thanks for reply.

On 2025/10/12 23:21, Christophe JAILLET wrote:
> Le 12/10/2025 à 17:08, chenxiaosong@chenxiaosong.com a écrit :

>>       /* does it have the right SMB "signature" ? */
>> -    if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff)) {
>> +    if (*(__le32 *) smb->Protocol != cpu_to_le32(SMB1_PROTO_NUMBER)) {
> 
> Should this be SMB1_PROTO_NUMBER?
> (without cpu_to_le32())
> 
> CJ
> 


