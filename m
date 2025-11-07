Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCA732ABD1;
	Fri,  7 Nov 2025 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762527118; cv=none; b=SkafqgOqm1oiZiAYNH2CHkLMJinaDKefO8/uBsMe86VReC9ZaRGKEM6Z7wP5/JJsz14ZDslr4Guq84K6eZlSDLF1Nliogh0oGqkf9h7t9G1c2wyMxnWq6hypP1VL+vJU4dk75IR8mA0knO64GHmMY4Z6Gi324YVW7uyCmEI2PjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762527118; c=relaxed/simple;
	bh=yY+LqNbrriJtrASwv4EJBgyPp/ul+xS6nFrrSNxOa78=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=EQu2iqKdIFsosl6vHkAc0XKHaGYmb4/GVKI0bZATISHBopJ7xw+sbF8m7MajKA95EuzBYtnB2RvIgR56nKoABOkajLzcHjb9mrOrxOpZ0S5x5ntpsKQxC6D6AuvbrKrc1WRFfcbQ4BRs6NnuCH//sg/rSmKx7OAqXcer22COEnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Mw2jgJ49; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Mw2jgJ49"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fp3+7qnkGj3SD8ZunpmtK+vZqqmCCDW44o0W2oGVpHE=; b=Mw2jgJ49ez8biiAxasIexEy7W6
	WRKyIjpx2ReCRc3Me0y1Dqif2VAtrank49xgfqoqF8WQ6WQuNzH0G47MPvBgFZpHDz1kJVgoZ+YaN
	54FacZhD8utA2W4E+KqTjLxljGw4cejmGgT2Nr7mER92KyrUCD9U0AEC2HZJv9CYNM8gcb9kzunKI
	tCGXQRPP8WaT+StEENw5TOfpuM/YImF/KRP3+6eUUZFKJieljmC0mf29lnUFeHMqr1cvpdfkE1l35
	CGUjttw9XumO8eFYGygXwlT8MTjFIYVLrNORp5Jsj/4nWM/+sx93UU0mkNk/VtA2EApCmZBBEkd+a
	WjOEgfOQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1vHNUE-0000000151N-1j2X;
	Fri, 07 Nov 2025 11:30:46 -0300
Message-ID: <f25e47415998a9d9360ac87eca7292a2@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Edward Adam Davis <eadavis@qq.com>,
 syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com
Cc: bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, ronniesahlberg@gmail.com,
 samba-technical@lists.samba.org, sfrench@samba.org, sprasad@microsoft.com,
 syzkaller-bugs@googlegroups.com, tom@talpey.com
Subject: Re: [PATCH] cifs: client: fix memory leak in
 smb3_fs_context_parse_param
In-Reply-To: <tencent_5D8667DBC6ECD2FF464349ADEEFD2EE84C06@qq.com>
References: <690da014.a70a0220.22f260.0026.GAE@google.com>
 <tencent_5D8667DBC6ECD2FF464349ADEEFD2EE84C06@qq.com>
Date: Fri, 07 Nov 2025 11:30:46 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Edward Adam Davis <eadavis@qq.com> writes:

> The user calls fsconfig twice, but when the program exits, free() only
> frees ctx->source for the second fsconfig, not the first.
> Regarding fc->source, there is no code in the fs context related to its
> memory reclamation.
>
> To fix this memory leak, release the source memory corresponding to ctx
> or fc before each parsing.
>
> syzbot reported:
> BUG: memory leak
> unreferenced object 0xffff888128afa360 (size 96):
>   backtrace (crc 79c9c7ba):
>     kstrdup+0x3c/0x80 mm/util.c:84
>     smb3_fs_context_parse_param+0x229b/0x36c0 fs/smb/client/fs_context.c:1444
>
> BUG: memory leak
> unreferenced object 0xffff888112c7d900 (size 96):
>   backtrace (crc 79c9c7ba):
>     smb3_fs_context_fullpath+0x70/0x1b0 fs/smb/client/fs_context.c:629
>     smb3_fs_context_parse_param+0x2266/0x36c0 fs/smb/client/fs_context.c:1438
>
> Reported-by: syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=72afd4c236e6bc3f4bac
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  fs/smb/client/fs_context.c | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
