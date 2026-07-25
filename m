Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0951332E729
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 06:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784962631; cv=none; b=c7n+h8sFVURNuBkZHYUm30sV9RhmD6oI6OAufwWIe4GmSeiLKJ/WqiEr1/KdFs+y26WGJqU+amiiZj3/BfALqaIQBqh+Qt1YSxBpqZTBo8GolTIXGx5mP+uRrFgZNAXrNrpcPqcFhPBsG/EYD08chXuqlWm/2OVRqdDZ0KSkdnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784962631; c=relaxed/simple;
	bh=zeKuhCKtPVX/Wys8r52xvZCjP1j+szJI2OJpuIKLpi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=LhCRFEnJfL5eWHnADSA9sr6ABhQNBN9NYcIk7BQxYgI13h5ILvu+YMGE/DWkjfQcxx4XsXusbWfrCeguq6iCvseqZlpofsUd0F2asvygq5kcJ2Dvah/acn4kUgWM+NYE0JGv8eOX2B8yvLew2gsZIttJWJ3e+d7dM+a21hm/4WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 04edacf487f611f1aa26b74ffac11d73-20260725
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:4a47e6b2-20d3-4d15-8e6d-b37309a83898,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:4a47e6b2-20d3-4d15-8e6d-b37309a83898,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:5ef6c05e8bb270e39c806c7e9dd5610a,BulkI
	D:260724194959TZ2M46D4,BulkQuantity:1,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|136|841|850|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,Fil
	e:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DK
	R:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 04edacf487f611f1aa26b74ffac11d73-20260725
X-User: tanze@kylinos.cn
Received: from [127.0.0.1] [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 154479439; Sat, 25 Jul 2026 14:56:53 +0800
Message-ID: <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn>
Date: Sat, 25 Jul 2026 14:56:30 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: Ralph Boehme <slow@samba.org>
References: <cover.1784888897.git.tanze@kylinos.cn>
 <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
Content-Language: en-US
Cc: Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>, Jeremy Allison <jra@samba.org>,
 tom@talpey.comm, ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org
From: tanze <tanze@kylinos.cn>
In-Reply-To: <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Ralph,

For a handle opened with an SMB3 POSIX create context, the mapping in
this series is:

     Client-visible xattr        Protocol EA name        Server xattr
-----------------------------------------------------------------------
     user.foo                    foo                     user.foo
     security.capability         security.capability  security.capability
     security.xfstests           security.xfstests  security.xfstests
     trusted.foo                 trusted.foo  trusted.foo

Apart from the special native xattr mappings described above, all other
xattrs in the user namespace continue to use the existing SMB EA mapping:
the client removes "user." before sending the name,
and ksmbd adds it back when accessing the server filesystem.

This results in name collisions for the following attributes:

     Client user xattr           Protocol EA name
     ------------------------------------------------
     user.security.capability    security.capability
     user.security.xfstests      security.xfstests
     user.trusted.foo            trusted.foo

In POSIX mode, these protocol names are reserved for the corresponding
native xattrs. The client therefore rejects the colliding user.* names,
and ksmbd does not expose the corresponding user.* xattrs when EAs are
listed through a POSIX handle.

For example, EA enumeration through a POSIX handle produces the
following results:

     Server xattr                Protocol EA name Client-visible xattr
-----------------------------------------------------------------------
     user.foo                    foo                     user.foo
     security.capability         security.capability  security.capability
     trusted.foo                 trusted.foo  trusted.foo
     user.security.capability    hidden                  not returned

Without a POSIX create context, the existing behavior remains
unchanged: protocol EA names are mapped into the server's user.*
namespace, and native security.* and trusted.* xattrs are not exposed.

Thanks,
Ze

在 2026/7/24 19:49, Ralph Boehme 写道:
> On 7/24/26 12:39 PM, Ze Tan wrote:
>> Native xattrs are returned without a prefix when EAs are listed. Their
>> corresponding user.* backing xattrs are hidden in native mode.
> sorry, but I don't really understand how this is supposed to work... :)
>
> Maybe you can provide a simple table that shows the representation on 
> server, client and protocol for the relevant namespaces?
>
> From your commit message alone, I couldn't tell how the user namespace 
> is intended to be handled.
>
> Thanks!
>
>
