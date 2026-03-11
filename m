Received: from mxchg03.rrz.uni-hamburg.de (mxchg03.rrz.uni-hamburg.de [134.100.38.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603DF3BB9F9;
	Wed, 11 Mar 2026 08:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.100.38.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773218928; cv=none; b=TbIJ4VWjto03JKKaOOV0BjEpuBEPdMwzdqMrs4KAvX0H2/8R/aybmy9/B1bl6wmRVBwL9uePwxQ0UuQNaakKRJ1uIa6YsCl+I/1RszXX9ol1oEqXbRogOnRseVg+C6yGyEz0tc7riRBy2MMrn643SvV8xcgLfX51QaWPc7pB3ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773218928; c=relaxed/simple;
	bh=j8tBRSYPCHgSUQaB+NGCtEs7bGqnmStgyYssECNdGxc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ipG5DJ3rY6bDdlAGHD5ldguLRsMu/IKRlySxtB8WF3zoRII+iNBNGbn35zowWNsDPKTDQysa2yJQkWj2JQVXG2YKSFpaclga1dpjfraEIS2SMJrudqSVo/mVM/7wRq5Sdw9FRsCilHYqqBjRSPTrIi8zGgWuzuol4/ve5ifrvpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de; spf=pass smtp.mailfrom=uni-hamburg.de; dkim=pass (2048-bit key) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.b=QJdpPxdc; arc=none smtp.client-ip=134.100.38.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.b="QJdpPxdc"
Received: from mxchg03.rrz.uni-hamburg.de (mxchg03.rrz.uni-hamburg.de [134.100.38.113])
	by mxchg03.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4fW4Cn5HFSz2xKt;
	Wed, 11 Mar 2026 09:48:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-hamburg.de;
	s=rrzs003; t=1773218917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j8tBRSYPCHgSUQaB+NGCtEs7bGqnmStgyYssECNdGxc=;
	b=QJdpPxdc9zeD2hjlf/oeH/KQJ+xr9XhPKFBHFHF3iXiPZLa27osulyiqZdhIV9hWP1ArP+
	0hgI3UBE2jjAGms07MUx6zuaRiMehyvkLTYZknt8JP1syaEqgxRP+Teco5snKTjRLxm0UM
	uocb9AeDlazQyNpWj8rifbSWOunnPDn1kno4yE/n7i97HqKs8XJoRuRww8SVswZhdLbCht
	7aXFJY+oW8OQOrrRU/voMhMrWFnjEnTEUF8Jd6JYIdfKEQNXN7rE2MI3NbGadapGaxFR+t
	nIOE+MR33ng4Y+w0hpxoRHHrsjVnI2xZH9hcLp8R/4ur5tIjZpvcISXXqH/uaw==
Received: from exchange.uni-hamburg.de (EX-S-MR06.uni-hamburg.de [134.100.84.89])
	by mxchg03.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4fW4Cn3k1Nz2xKr;
	Wed, 11 Mar 2026 09:48:37 +0100 (CET)
Received: from plasteblaster (80.187.125.159) by EX-S-MR06.uni-hamburg.de
 (134.100.84.89) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 11 Mar
 2026 09:48:37 +0100
Date: Wed, 11 Mar 2026 09:48:36 +0100
From: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
CC: Steve French <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
	<regressions@lists.linux.dev>, <stable@vger.kernel.org>
Subject: Re: [REGRESSION] failure to reconnect on SMB server restart with
 custom TCP port (not 445): Host is down (at least since 6.6.95)
Message-ID: <20260311094836.5ba141a3@plasteblaster>
In-Reply-To: <20260311091653.358b213a@plasteblaster>
References: <20260310235642.6d9798f4@plasteblaster>
	<c66p7dr6vlujvnwczbnrmqx7monkdgdnm4rwewm76aibn7jza3@d3uik74dei72>
	<20260311091653.358b213a@plasteblaster>
Organization: =?UTF-8?B?VW5pdmVyc2l0w6R0?= Hamburg
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: EX-S-MR06.uni-hamburg.de (134.100.84.89) To
 EX-S-MR06.uni-hamburg.de (134.100.84.89)
X-Rspamd-UID: b647a2
X-Rspamd-UID: 781cd0

Am Wed, 11 Mar 2026 09:16:53 +0100
schrieb "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>:

> Do you need a confirmation with 7.0.0-rc3? I guess the picture is clear
> enough as-is. I've started a build and can give a short follow-up later.

I can confirm that the unmodified patch works with 7.0.0-rc3 in my
setup.


Alrighty then,

Thomas

--=20
Dr. Thomas Orgis
HPC @ Universit=C3=A4t Hamburg
