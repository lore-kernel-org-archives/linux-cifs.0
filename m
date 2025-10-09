Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8626F219A81;
	Thu,  9 Oct 2025 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760024701; cv=none; b=ouv6VJFe3zs+pUZhj0cUS+i2PeVnsYTQbahfpzL31k1k/G0PkgLA2WVjRB7cw7OkwzBYzcYjvInqLTVcV8G2ppXsgEK7ljUjCd8dMk8T0Q+eU+d0NtKzYFaycbke/H0NBUdyYsFTvDTxeZEq/b2QHL1nDz2XwhpILz5kVUdCz2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760024701; c=relaxed/simple;
	bh=L+1beT2sVZT8FwjX5hNzlFMiYqv6I9DZ/WvvRnrSpkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BIDKXinILs8sAMow5wOibousy5wXSZyA0g7oI2jSzfQU/HmStDl6k75/XjcBa5mLD3bWxlGyQGXgQtf1aAHgl75I71q8OdKO0PMeGhvdNUgtEqlHcMOKtk0U5ZSq/Q7CwNgNckstsyCgVNlDfVeXzAqAdVvfSa1NVnZqO2FthyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=NoUSVkmF; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="NoUSVkmF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760024696; x=1760629496; i=markus.elfring@web.de;
	bh=uw6zp63KqgTpfwl7B+C7Y/hQXKRp9D8vBKFf/pUuzt0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=NoUSVkmFYq49Mj7C4FDDygsN5Eby61zB3SfSHIQVjDFZaR7Dgqt/hoMp7h9gVK7R
	 dB4L36IjL6T8IlM4/pnpBNVFsNGbcvlZjr5lC4/Kw31u5cgnGazQM0i8Vv8jsi5YG
	 J99/2b1PixoN3YxYoCJPpB4iPfgZHe1xhZ7LVlCI32u2F0nWaZAJVwJ2aVZ0t9Yqx
	 e1zm9PoKTRE+Qa13a789w/b7bGVGM0lhNnckVMZsFkaeIY54yua7V5Dq9mOLjdJKD
	 ayIdfGDpAsNUWOauhS+pKErH9S8N0VY8A7HzUX63ciF74TNwMzy6tUr3llJHZBHSa
	 oJlDhi7F7Ov+B+8QTg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.255]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MCogs-1uy7Ng0qoq-0019hg; Thu, 09
 Oct 2025 17:44:56 +0200
Message-ID: <ccb38a9b-4192-4863-9b29-497b55d99a6a@web.de>
Date: Thu, 9 Oct 2025 17:44:54 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: Simplify a return statement in
 get_smb2_acl_by_path()
To: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <5b95806a-e72e-4d05-9db8-104be645e6e5@web.de>
 <CAH2r5mvg=kqPyA2nYF=Nhjr3vkt4dT1R4p-Bk_MBQtddjx_EhA@mail.gmail.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CAH2r5mvg=kqPyA2nYF=Nhjr3vkt4dT1R4p-Bk_MBQtddjx_EhA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Js6CDt2FYqGvH0BfsRaWoLLf4UsarHP1mdUGUYaF3fL4wXPf5sq
 oLNSmMXsZFG07cyUF23qvOKGkFOtIj7iioqBJqt3E/vWKoTDSZTgM88ofXnhLaBgdXlmsGt
 NTSOL1EEVwCJWTtJlMWKsuhgqSaFA+IhOa3sTmnmtWwdtCJRkmvxm7dPunZwj8Ku3oVRDCO
 mMwq9xJWzXYuHWtqLUduA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Nr9f/KY866s=;OCBFr7cUYYnrKSclx1CMm4qCJzT
 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

> As pointed out by the kernel test robot a few minutes ago, this patch
> would introduce a regression (uninitialized rc variable in free_xid
> macro), so will remove this patch from for-next.

Will this (clang) compiler report be reconsidered once more under other ci=
rcumstances?


=E2=80=A6>> +++ b/fs/smb/client/smb2ops.c
>> @@ -3216,9 +3216,8 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb=
,
>>
>>         utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
>>         if (!utf16_path) {
>> -               rc =3D -ENOMEM;
>>                 free_xid(xid);
>> -               return ERR_PTR(rc);
>> +               return ERR_PTR(-ENOMEM);
>>         }
>>
>>         oparms =3D (struct cifs_open_parms) {
=E2=80=A6

Can it be that the uninitialized rc variable would not really matter for
the adjusted statements in such an if branch?

Regards,
Markus
