Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59F939A806
	for <linux-cifs@vger.kernel.org>; Fri, 10 Apr 2026 20:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775853045; cv=none; b=XppXV6r9INpyjHZ3lCZaqadG11WsEgcSWu+a2hbIinhaUunbZMMecLIboJO3SeOu3pu6PfnQDrPircoLAZydc1v3NIbXPNTsHEGiWec1eewTancJMdY3HUvuduw9r/Z9gvrP5NGSEdeCtd89i3mqHTSY8ldOfnsHTqiyYZS/w90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775853045; c=relaxed/simple;
	bh=ibPpFG+JWegHejWrQmbnNB9IckCZmAtGVHIgsFZLFPw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=fx3VHx4XPkfAvcoEjt/Br2QPPpk1csROfU+53ofd9Ry42qHEfF4tUjCSMU2fnMwcEm7Hdi2MGp69RZpoY+quU9XC+Tsfqb/Z/FeVI/X5sa5EYKn55pgWFBgQVryJLiWh8PB1FSsTfo6oMa/+LSCmmrfujqA0qcYSNQ7GvzmguqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=O9cxclr0; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="O9cxclr0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YrkZNPjJ2sw7nJ4CS7UCQHOPesbuNnoXfqSX/LlpfAk=; b=O9cxclr0NnK9a7Iejbros6fmxm
	0T6ePKdlp5kvdsp8kyM2tsKRFgyW2cIMhPkVw18YJ18Q3jR/iJtxv08F81DZTFxoLc9kqKV9QVKsV
	CSqpY5zTdTgpbtzr1PxTUWG/N+C8jmqCtngo/70Htp0j4NbJmduhiy0JpI6oR72x5W7hyE2PWOAL7
	J5niyPFLSLgTdTkih4ELvOWaRQSwmf7VAZF1dIXHyexurBubMGbVU1NPno5Y21cSELDx97bMRP8bD
	vW/92hXFDlAKY1rqaX6xrEhgkZf2RonKwx6FdHgnE/FQW9eWl9/jdsdAoyn7eWu8AeXxnghT+J1iH
	HSk6AsaA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1wBIUq-00000002a1G-0JTe;
	Fri, 10 Apr 2026 17:30:32 -0300
Message-ID: <6eec11ccb0a36ab828a99efd45354a92@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Cc: metze@samba.org, Namjae Jeon <linkinjeon@kernel.org>, Steve French
 <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Ruikai Peng
 <ruikai@pwno.io>, Sergey Senozhatsky <senozhatsky@chromium.org>,
 security@kernel.org
Subject: Re: [PATCH 0/2] SMB Direct: double-free of send_io on ib_post_send
 failure in batch flush path
In-Reply-To: <cover.1775838249.git.metze@samba.org>
References: <cover.1775838249.git.metze@samba.org>
Date: Fri, 10 Apr 2026 17:30:31 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Stefan Metzmacher <metze@samba.org> writes:

> here are the real patches for the changes already tested by
> Ruikai Peng for the double-free problem reported, see:
> https://lore.kernel.org/linux-cifs/CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com/
>
> I prepared a branch that can replace ksmbd-for-next.
> The 2 changes are rebased below the smbdirect.ko changes,
> I resolved the conflicts and made sure the problem is also solved in
> the new common code. This in for-7.1/smbdirect-ko-20260410-v12
> at commit: 274b415378bbd0cf6fde1a719e264cee2eefc06f
> git fetch https://git.samba.org/metze/linux/wip.git for-7.1/smbdirect-ko-20260410-v12
> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-7.1/smbdirect-ko-20260410-v12
> I made sure each commit compiles fine...
>
>
> Stefan Metzmacher (2):
>   smb: client: avoid double-free in smbd_free_send_io() after
>     smbd_send_batch_flush()
>   smb: server: avoid double-free in smb_direct_free_sendmsg after
>     smb_direct_flush_send_list()
>
>  fs/smb/client/smbdirect.c      | 8 ++++++++
>  fs/smb/server/transport_rdma.c | 8 +++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
