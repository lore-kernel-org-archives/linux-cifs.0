Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583B52DA750
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 12:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769086099; cv=none; b=QDijGU9Vz1g7dI4dq2DWDU0e6atGeYHYstDPgl9A3JltdRDpairkj9JxKKLjvwGKlVBDLBWk5PtfkLY6sfGjahoAqdMRXHXvd/+Ph2JQcR9c2Lv+Fr9VoZXv61ZIbFuyY5wblZ1Vn+ubFhYM1vgBJL6EdwiGavEQLwBg9fbAJ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769086099; c=relaxed/simple;
	bh=2/WHl849NuQcFQNDU9fJWdHP7W9CnumSpRjicgxIwJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o6615g1rAsmsAcjMJUKXsGm4bg/jcL+V4cz7tu87twbVgCrfaHEI0B+8BbpgFl1lumfIjBbxAByRnqRkH3TkML/mf8ZZOJMesk0qxXOpoonouvdFS8GwX71EeKI9R5wQadm1Rj3BqZ+Chjd0a7n3fN7Z15sm7tBtVIUUnuM8770=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GWKV8a1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GWKV8a1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDC4C4AF0B
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 12:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769086099;
	bh=2/WHl849NuQcFQNDU9fJWdHP7W9CnumSpRjicgxIwJM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GWKV8a1uG3eCbcQgjsRHAgHx3eGuuwuru6/wnGfIhD+bJblht/SDkp070KyJ/8mUO
	 5cMsJRTTkfNQwfjutza7pRSvpqbQdJ4gKMbYqOpZcihD0G8U2v+OecC2e7dqQTq+Nv
	 k2e4Uy/fRjq8m0lxTvayToRgfObvOaw6GO08lv4QFO5PP3rqRIDigW2wOJtvl/EQeL
	 0yhQsu6XTouOIuLubcY0uzsBDWvCl16L0qzVF/kbV5gvgC+EISOjp7PcDDWPuo9lpt
	 kUQ2+LOd6YWg9Yil8AkBcmM/zwG1YFXR8IX5SKBG0qCoVrfiB1cDf8aAHCYUsWAPT8
	 yUcOZvQ8iJd0Q==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-65807a2012fso1573010a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 04:48:18 -0800 (PST)
X-Gm-Message-State: AOJu0YyLI3em1xucIoDKZIWsaOMp4O+xNT0U/2WiWUfQgyl2cSJWSC5g
	4Nl1HJvlOccVNKV9bjLaNlO0OPgTen5PzO+ID4lc2GEHY5qohd90e6kmxtCO//fxlraXXLs3DEj
	Z4baq0zbuArCnLXLswx1x67UGQnfo3I4=
X-Received: by 2002:a05:6402:2681:b0:658:1917:af4d with SMTP id
 4fb4d7f45d1cf-6581917b121mr2795893a12.9.1769086097539; Thu, 22 Jan 2026
 04:48:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1769024269.git.metze@samba.org> <27b48512bb652a9e1662c9321971f42c88084c4c.1769024269.git.metze@samba.org>
In-Reply-To: <27b48512bb652a9e1662c9321971f42c88084c4c.1769024269.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Jan 2026 21:48:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9uZ30n6QTufjYHGdwnYrdoYX8YB9o=ACtSF44Strb7Cw@mail.gmail.com>
X-Gm-Features: AZwV_Qgmhy9wuuNuBBrza1C0UMtqzGxmzhHUz2khZKvtLa8SFvErauE3nsmyxNk
Message-ID: <CAKYAXd9uZ30n6QTufjYHGdwnYrdoYX8YB9o=ACtSF44Strb7Cw@mail.gmail.com>
Subject: Re: [PATCH 06/19] smb: server: fix last send credit problem causing disconnects
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	stable@vger.kernel.org, Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2026 at 4:51=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> When we are about to use the last send credit that was
> granted to us by the peer, we need to wait until
> we are ourself able to grant at least one credit
> to the peer. Otherwise it might not be possible
> for the peer to grant more credits.
>
> The following sections in MS-SMBD are related to this:
>
> 3.1.5.1 Sending Upper Layer Messages
> ...
> If Connection.SendCredits is 1 and the CreditsGranted field of the
> message is 0, stop processing.
> ...
>
> 3.1.5.9 Managing Credits Prior to Sending
> ...
> If Connection.ReceiveCredits is zero, or if Connection.SendCredits is
> one and the Connection.SendQueue is not empty, the sender MUST allocate
> and post at least one receive of size Connection.MaxReceiveSize and MUST
> increment Connection.ReceiveCredits by the number allocated and posted.
> If no receives are posted, the processing MUST return a value of zero to
> indicate to the caller that no Send message can be currently performed.
> ...
>
> This problem was found by running this on Windows 2025
> against ksmbd with required smb signing:
> 'frametest.exe -r 4k -t 20 -n 2000' after
> 'frametest.exe -w 4k -t 20 -n 2000'.
>
> Link: https://lore.kernel.org/linux-cifs/b58fa352-2386-4145-b42e-9b4b1d48=
4e17@samba.org/
> Cc: <stable@vger.kernel.org> # 6.18.x
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
