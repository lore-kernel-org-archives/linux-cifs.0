Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D802620FC
	for <linux-cifs@vger.kernel.org>; Thu,  8 Jan 2026 22:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767910803; cv=none; b=aoJObmUm6C/39QPHrnOoWmhRcCIxfakaxbLfJ6LDZmuwYVW7xB9u70LRcEDd984YWP5S2zkvAi62UAZo+qhAM+Pqdlw5VbDNjFU1ND554kwcXY5z02zFZpusd06qkIysSbqemYAAraI90g0WyKtjOMB2izCYF3/1BAcLgmJHrOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767910803; c=relaxed/simple;
	bh=+wSVc2IT5bsrbZWZdITGeeRuH5v05cIZtgKBrisJhGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g7y3kdti0OyhMFW0G/Zn4EKAgRpTwnQmGtMeZJUcZa73AXQZ+75crcjV3lKWtHTo8RvKo8/AxTfI3kqg7SodQ12T8r+DHZqD+JKa69ta/7CmPc8BBtcGACnrsCZO2TrCHx80Cc3K0SvEPrtrGO0sLgg71P4pb/ID1mZ3bUeYOlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LiduMBaU; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LiduMBaU"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0d67f1877so30883625ad.2
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jan 2026 14:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767910801; x=1768515601; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3eSpvqBcCMdUnYFu5r+IbcRJ+Ycs9RPex6ZaryNeYwM=;
        b=LiduMBaUtvatD5wq2FLyHAQk1vgB0NTDSSHFfstiRLFFpeeuvjpy5QSiIWnFq3iZ/p
         yfUCwHBzhDfDMsWPBOuP9UN4JeKF+OHhZ+B5Ss6q7J5VKkBCMDIcIu7JyXaCZJNAsqlm
         aYlLpNhVXNVsnqws5yLkCuA8tWKvBKvDQdeLzluerI3ZIqJdnSVKNMLTJZoRLNCEQkqw
         mb58YRIaGvYsERKsn5x7t2cO73A8YCtbN9+6Lsqw7UM5OUo/kWb0eErE7gdWP47uaxrF
         pgpiDPCYHD8CNEqnwKHkOcnTV4Wpw7q8QazYcRc9xiWWhfXE/NS8yAwA3xa2aRS8JS0Q
         cVAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767910801; x=1768515601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3eSpvqBcCMdUnYFu5r+IbcRJ+Ycs9RPex6ZaryNeYwM=;
        b=Lnru9Q1oaktO0yDU8uIOtOC7zoHJvrE5gUrQqZ39L7oPKGip1SmZC+wbqT9FglQlPH
         LhMPkrB5ARJ8Qz0jhFT0msTF7LSHt1bkGDvP9YwJnUA6TSXk4wWhiM8q4DkFLXxnuBUp
         nTKQINXf0evd67LBlnHzBc4jyeo5svLhv9ux+gScR4QES7JIc1qFe9Qx2Xq84ig8JT3I
         +aGGisoY2RkQNj/Tq1dZz4oIyHMcZelpTlcNuA3NWgdImZOJMzZARcnjvM+AMg4eIY3p
         235H4fmDLWes2eZxscgOOMXmvhchA6E4+BoEhM6JmInL2c4L/7F56qCrjbq8zksi4axa
         zhQw==
X-Forwarded-Encrypted: i=1; AJvYcCV8HcxkN4ngBI6ZHMRTuHjxmNH/BRIuDgoRlhvPZe7/bXGmi0tf0PkRZtT1owMyDfp+GfHcpkNPw5KD@vger.kernel.org
X-Gm-Message-State: AOJu0YwhfogfOdlJx9RfxvMnaCC2m0VdTfpGRHdU9zYEyyBDXTkG2X7I
	+hKhLN4GHTOrE6r1x9P9ClVaF/cbq9FVRHjO28zYWJ5f/g5+xVIVPtEMGw2gTyBDc8ay2NgJ+ym
	wBrHNB5bplP1s/qLuILLww0TPFUdDDNQ=
X-Gm-Gg: AY/fxX7v3FewgBkPrfPxO1rIEvRAQx2euGTQvqmy38qzVhl2kvQPyZzdVNInK9ujYv/
	gFPgyUngF+kssiO8oSzi5qEF9YqVIm+whnQW3f3mhtF1tVML0hEaxEPUzU1olSYfXRxQrGTmdIq
	znff0w93jcofuVGD6PIyv3enoFw/wdYBBvsJgxbHoJxxbZ3hul39d1hPccoXqhbFFgF2hQpbN8q
	9smlpUePziZR965yV3FfpJPRdXBwkogaCXkeEfnSDCLDIz3uahP0CKU4HKoYr7Cylw8Bs4=
X-Google-Smtp-Source: AGHT+IE6kkegFDt+9XCzD+S56azqAPTIJarvZtVAkqkfUkoYB3glBC/TJm42hBLD2pQUlnWfdjMc3cigjDPJ1b82sgo=
X-Received: by 2002:a17:902:fc43:b0:2a0:ccdb:218d with SMTP id
 d9443c01a7336-2a3ee442824mr75598785ad.17.1767910801242; Thu, 08 Jan 2026
 14:20:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1767621882.git.lucien.xin@gmail.com> <d5e0dce5e52d72ed2e1847fe15060aa62e423510.1767621882.git.lucien.xin@gmail.com>
 <0df97c1d-aa75-4472-aad6-33eaa919ce28@redhat.com>
In-Reply-To: <0df97c1d-aa75-4472-aad6-33eaa919ce28@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 8 Jan 2026 17:19:49 -0500
X-Gm-Features: AQt7F2oQeSaDlFSlRPZRuDsHDmuOmu--yt6QSCtiFGQnIoBOFFX8SGhuo0gGWpA
Message-ID: <CADvbK_eVM5T3u7hiXR=S3ydHCAneCP_wLM7Q4Tc=D6eJ9tv4sA@mail.gmail.com>
Subject: Re: [PATCH net-next v6 02/16] net: build socket infrastructure for
 QUIC protocol
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, 
	David Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, 
	John Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, 
	"D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 9:40=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 1/5/26 3:04 PM, Xin Long wrote:
> > +static int quic_net_proc_init(struct net *net)
> > +{
> > +     quic_net(net)->proc_net =3D proc_net_mkdir(net, "quic", net->proc=
_net);
> > +     if (!quic_net(net)->proc_net)
> > +             return -ENOMEM;
> > +
> > +     if (!proc_create_net_single("snmp", 0444, quic_net(net)->proc_net=
,
> > +                                 quic_snmp_seq_show, NULL))
> > +             goto free;
> > +     return 0;
> > +free:
>
> Minor nits: I think an empty line before the label makes the code more
> readable, and I would prefer #if IS_ENABLED() over #ifdef.
>
Will replace all #ifdefs with #if IS_ENABLED().

Thanks.
> Other than that:
>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
>
