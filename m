Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D711E5B9A;
	Wed, 22 Apr 2026 15:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776871000; cv=none; b=dsFquVFZAvztPPuZw2vNvRxWD57JYZcgBerk0vu1bHvP8ovIu8zcCDm2YJRTD2+DGBOdnFxZrtOkE+wNLFo2HqYeNtavzqlFm0IMZydBYy2zkxh4YGo5shwIqndkbFx32imQsED6YD5lLabwy5j/8GcJrIPrPWKlv3QZPNvQ5d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776871000; c=relaxed/simple;
	bh=++WRNWdVvI9XqJN00jR2KnSGX9arfhfB7whgd+ZnMhk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=jviNKnL12X+akCxiJj5VurZlOQ4ExVQlFOJLt34oh4cBzEBD/GKFcV8kwinHu4EU1XOsL2zPoTUQfAStpKkeuhzCXtJFdWroTOgoFdF5wcv65LbaLL/nYGCzEN6wszvaCeG+3fEzQ7pZjnQ4e9IPSAvjZb7/jQn8ClxYRtLMb1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=gJGjQBrA; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="gJGjQBrA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=hikiK6BgiZh3SrHPGBqe13W0QX/6mpmCmHyO48n62EU=; b=gJGjQBrAGxYQOc7Zp5VL7UkgUI
	ZhpZXBDord5PetOhR0azmPMTfF08g38utXC7W8MIclwZtHtM/JOdpP/YsG6InlGmlyHkjGRj0ZqpF
	X1kicPycoWFbI0coKoJnCIKpPlwsdljcukbwstuKufivAuSpaTpapxGr+sMf9sQc7xvpCVvDm3Dl0
	gMMhO6L8LNQ/4msZe80w2i01kpNH5Ze2s7CzsTlqnPTDWP6ovQyV6gn02yzBWrPh1BnGPgZ/R0Eou
	XJ91/j4aRtRdBTrSbvW7rIEsWBimW9EfzuTixgDSuVZhZLJmnTk5FA63CKiyejLH6qYnL4zMccZXk
	/v4qnv0g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1wFZJR-00000000bFy-2xGz;
	Wed, 22 Apr 2026 12:16:25 -0300
Message-ID: <1b8e686b6a08d0e620d624ff8728b985@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Steve French <smfrench@gmail.com>, Stefan Metzmacher <metze@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-cifs@vger.kernel.org,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 samba-technical@lists.samba.org, Tom Talpey <tom@talpey.com>, Linus
 Torvalds <torvalds@linux-foundation.org>, Namjae Jeon
 <linkinjeon@kernel.org>
Subject: Re: [PATCH] smb: smbdirect: move fs/smb/common/smbdirect/ to
 fs/smb/smbdirect/
In-Reply-To: <CAH2r5msb3-HiPSv+HgBknEwDXGsv0xU=TGCxHdmc-VCLKzYCmw@mail.gmail.com>
References: <20260419192018.3046449-1-metze@samba.org>
 <aehrPuY60VMcYGU8@infradead.org>
 <9cb0901c-18c5-4858-941c-3b37ee112af9@samba.org>
 <CAH2r5msb3-HiPSv+HgBknEwDXGsv0xU=TGCxHdmc-VCLKzYCmw@mail.gmail.com>
Date: Wed, 22 Apr 2026 12:16:25 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Steve French <smfrench@gmail.com> writes:

> On Wed, Apr 22, 2026 at 3:16=E2=80=AFAM Stefan Metzmacher <metze@samba.or=
g> wrote:
>>
>> Hi Christoph,
>>
>> >> diff --git a/fs/smb/Makefile b/fs/smb/Makefile
>> >> index 9a1bf59a1a65..353b1c2eefc4 100644
>> >> --- a/fs/smb/Makefile
>> >> +++ b/fs/smb/Makefile
>> >> @@ -1,5 +1,6 @@
>> >>   # SPDX-License-Identifier: GPL-2.0
>> >>
>> >>   obj-$(CONFIG_SMBFS)                +=3D common/
>> >> +obj-$(CONFIG_SMBDIRECT)             +=3D smbdirect/
>> >
>> > Why is this not in net/smbdirect/ or driver/infiniband/ulp/smdirect?
>>
>> Yes, I also thought about net/smbdirect.
>
> I would prefer to leave it in fs/smb for the time being, since it makes it
> easier to track since fs/smb/server and fs/smb/client have dependencies
> on it.   In the long run, I don't mind moving it, if it starts being
> used outside
> of smb client and server.

Please let's not break backporting any further.  Decide where it will
end up at once.  We don't want the "fs/cifs -> fs/smb/client" history
all over again.

Won't samba be using it?  If so, you could consider an user outside
fs/smb/{client,server} and then leave it in net/ instead, as hch
suggested.
