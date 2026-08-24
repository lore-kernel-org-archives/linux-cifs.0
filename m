Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3897F28D8D0;
	Mon, 24 Aug 2026 22:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787611543; cv=none; b=F/BpSka6sZunXyng4z3PvTApMHDbeAqZIp2zlbVI9eCCA+GKoriKfttyDqpEMkHHRGjF1uUY60JE4DHIQxqyAJi6WTNb2dax3+v5UZKnwDTvmKdU7fQQYk86DA61mTRl73lawkm8GNhY+grBTeQpDVdGMYUn40cPdaKI2Wbwyy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787611543; c=relaxed/simple;
	bh=gf/9mf61wiN9APyv0/VDfFTYMkwHmwEtz2+bP9toEOg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Ra9tPQQZIyRvqPfxiQj3Yz83CzwrNjLkQ0m9sgaSaOACjnjf4sHsJPz+euY5HG2rdyt3oFy8OQlO+14hB03KMccgeANZ5iunAwkJiZ9hb3bFLjZa92+TcVL7bhUmEBMv1nPaBKilIVZC5OeRFukZlfPOrlLplqnmtnqPXuSdx28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=PNkJtxls; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="PNkJtxls"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=gf/9mf61wiN9APyv0/VDfFTYMkwHmwEtz2+bP9toEOg=; b=PNkJtxlsb4Qmn1H8KuCF1gLCLG
	1HcZFbot1vqTNC34L3MVWOEXJOERzhU8Q8ZMaIfvV/JmsTbqfTGmJQiiqsloM+pSvGb/4fdVpgCts
	j6+fgKgEXR15c8rCoNhnO+8GNSLeJO7Q0/df1a4JBSJ4dO+AKGYEjVxKekpGUOTnbYYVaPIQ7vHaB
	ebSNnmBZ/rApSzt0fVwOgliZMxRWjVOPvPoZ/m4jziWRNHEKpBtxnEDCBU4e1ZOqFpG275SKC9fNN
	JcxjOUVi94o6dWvlSbQDbc0AdQqEqy/mNeOrQx8t/EKxFld3IA8Ouvdafvu4v9C5Juf3+O8eOw+0J
	TZToveNQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wydQB-00000000bIQ-2liv;
	Mon, 24 Aug 2026 19:45:39 -0300
Message-ID: <29dba9c0231e36829219259338bfa18c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 00/11] cifs: Various changes
In-Reply-To: <20260822133112.s3qd7z7u4m7xfv5n@pali>
References: <20260706184819.22124-1-pali@kernel.org>
 <20260821214722.q7rkflclyyugdxll@pali>
 <CAKYAXd-pq4SXp4252h8tM7WO0ARRzMgpHs==N=30snzfO-JzCw@mail.gmail.com>
 <20260822133112.s3qd7z7u4m7xfv5n@pali>
Date: Mon, 24 Aug 2026 19:45:39 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Saturday 22 August 2026 22:28:26 Namjae Jeon wrote:
>> On Sat, Aug 22, 2026 at 6:47=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org=
> wrote:
>> >
>> > Hello, could you look at other of changes in these series?
>> > Steve already merged few of them and others I have rebased (cleanly) on
>> > top of v7.2 release and pushed to my cifs branch:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/pali/linux.git/log/?h=
=3Dcifs
>> Okay, I will check them. BTW, Do you know why Steve only picked a few pa=
tches?
>
> It was late -rc cycle and I wrote to Steve that all changes could wait
> for next merge window.

Steve asked me to review the remaining patches while ago and I didn't
have time to do so.

Please rebase it against #cifs-next and then resend.
