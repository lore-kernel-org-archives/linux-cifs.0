Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793299415;
	b=bbQ7+0HONTragjkvvmUXY8KjC89QWQR/iLn445ss83SvQlPyygQbj3CuIHE1kj/lefnh
	 u1+IRcSwT0mPGXW2r1Zu3dOJiQNyKMiN+jJBXX/mEDGDsiN8n21HVjoVBcSbkjdT4HrYI
	 dPl+OJkGRzUy9gbnz2Wm0eZg+d9H+tZe9Z+3ZC5uJMdKzvXXFK6oIi/jALVMQsAdFEtQV
	 hU/Q4CwWq6X4iYEKdfWaXQR1/DLHMs2xwkfumakjHsY3NMIIga0ismIljqu8uvOcrrKZD
	 ZWNOiuraBovHksCwAePUhSdbyU628qEwF0jL58/Zz21nX1YN9AcOGZtzw3lD0XavVXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793299415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=1BHs+G9e3OgtXmtk1ACo8hydXduqgmL4bvZzrFJrBIM=;
	b=iX5z1CIt8rbpQxZj5TCo9glNKeNgsByvFTajcNOv0+A83P8WlDywAsIZwQVY8/Vk/sVC
	 13x4qJkSoiL/6RWwAkwT5gXvRp1ij30Djaci/iam52UvENP4anr5w8meshQpqtNgs4c2y
	 iOefnDiGdBt+8YiGG3WfDTpDmhjmsWFwrT8y44Tv4uzDaaCQ2Ix5yHdYWSSKkqDei7ezf
	 PGYHLdmzFnI77M/2cxyX1VeBRFtA4peDnncW91kcn9W6A5Slul47CbsQI6VIYmFEVCluE
	 ymkswhiEXK67X4ljJm27ONOQ51BbOWQWOnwZFD0YjJKrlyf/L7Jz74utpFGgu7TPfaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="O/BaePmU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC14606A31D;
	Thu, 29 Oct 2026 18:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O/BaePmU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21821F01816;
	Thu, 29 Oct 2026 18:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793299414;
	bh=1BHs+G9e3OgtXmtk1ACo8hydXduqgmL4bvZzrFJrBIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/BaePmU7Hlrn5kmtLjQmWp2PEyE2YGhYG8XZl4YZElCpU1ha2U7LXRp1xKPcLdLF
	 kOHelr2q03VPTIgJRXuDNSlByS14Pqg3g2w/h5CC7QYL6z2NhK+Hl376mooaegun7s
	 DWcmtg6HpgzTwncRatxk3hONlv8o4z/B4JuEqodpPZNCiYIy7e4YiZ7+Fdf45U10l/
	 UwALTaVhUOrFmeVDkarcS9Gdh0lnY7QnikjMJZ4mP4YIot36DDiPb0ZPumntFsEvbL
	 G9CFUrSd5aJK11YfJPcK/d67XdC3OKKP1TSs1gDNkpMjYFiDhteVy+do2bviwwpMd+
	 E42ljSufH7dEA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?=EC=9D=B4=EC=84=B1=ED=98=84?= <ihopenre@gmail.com>
Subject: Re: Backport request: ksmbd and smbdirect fixes merged in 7.4-rc
Date: Thu, 29 Oct 2026 14:43:08 -0400
Message-ID: <2026-10-29-1-daily-reply-0001-ksmbd-smbdirect-backport-request@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CANTrAmxiBn6GT+N5qivdf=xtGg6yFksK5qN_PhpoNdxXDSpikA@mail.gmail.com>
References: <CANTrAmxiBn6GT+N5qivdf=xtGg6yFksK5qN_PhpoNdxXDSpikA@mail.gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> 1) 4ca76b89917a ("smb: smbdirect: don't wait for
> RDMA_CM_EVENT_DISCONNECTED in smbdirect_socket_destroy_sync()")
>    328c7e307e84 ("smb: smbdirect: release failed pending sockets of a listener")
>    5c171c90c446 ("smb: smbdirect: don't hand out already failed
> sockets in smbdirect_socket_accept()")
>
>    Trees: 7.3.y and 7.2.y (Fixes: dc691b91ad16, first released in 7.1).

Queued for 7.3 and 7.2.

> 2) 68f410faedaf ("ksmbd: wait for negotiation before receiving another PDU")
>
>    Trees: all supported stable trees that contain dc8289f91238

Queued for 7.3, 7.2, 6.18, 6.12, 6.6, 6.1 and 5.15.

> 3) ef85bad39cf2 ("ksmbd: reject FSCTL_SET_ZERO_DATA on a directory handle")
>
>    Tree: 7.3.y (Fixes: 25e414db7033, first released in 7.3).

Queued for 7.3.

-- 
Thanks,
Sasha
