Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B141DA4E
	for <linux-cifs@vger.kernel.org>; Tue, 19 Aug 2025 02:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755571649; cv=none; b=aZ6g8LZ4TaQSm1S/ZgNlu2hoWlYIQzcjAqJciEgpxcZDJg6ITru68QifMSN14fAToQkb8Kp/jf52OBR+QCBD/1VxwA+RKFjD4x1O1MBR80Jp0b576sh+m06MN3tesm+W49Tr777rZ+jO5u1zO3Nryihz9l89AgUZtJmY3lh2918=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755571649; c=relaxed/simple;
	bh=887WRRVjnbigM/7ON7rCWHqrq9BjliCaN3UdiEL0QlQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s+TZCzW7IdTgQNYo8LTOWWSZYuvtXGkolwmosHheRxduVzadVqpfL5wBdZSPbxPWtJK2r8dh4aQuEHCWG5EfRT7iCcGMauvs1A/qrDiaiu5sKUkKIP8C7LPoCEd3ep/eHLQOSCCK8j4HbrlcyVnyvSAR+6jRcPdDoq/3n7R97bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXMeXLXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXMeXLXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9810CC4CEED
	for <linux-cifs@vger.kernel.org>; Tue, 19 Aug 2025 02:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755571649;
	bh=887WRRVjnbigM/7ON7rCWHqrq9BjliCaN3UdiEL0QlQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bXMeXLXFVqudH21ps9kG1uh+2rEJ27oOpMjNQRjyNGfGdxTXu+Vb2zqP2Yx0msSA4
	 Xfs8DZ+oboGi6gDIam9+3f8igdThn9JgaSLjEgFrkRlt6gontj72rx66ZoSX0ONQXV
	 R/ZKWUbUNuZDdVD8de44sYAMtsREcmGX74dulKlzD8cA+XzD1o7CfdNHDT+s068ZBB
	 AFm/sC9eMODw+BWoWrtez6fmR9PyjaIFk7tuzQInsWJj7PGJ0WddGsNPD+FKCE5owk
	 BfUdOUugzSrKeHE/Xtl4VkVD/o0ipC23Piumm4xQDZMedLO9V28fKIlQ4HklJE6SHM
	 s31NmYpX3ikcQ==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-afcb7a3ee3cso739389966b.2
        for <linux-cifs@vger.kernel.org>; Mon, 18 Aug 2025 19:47:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVnxwvuGhkWC4VuFszj3CP64aFwK1MQj9gkaRZdaPQXD17LpnamdubdrEEHZgJJwmLGtrkETkk3r/st@vger.kernel.org
X-Gm-Message-State: AOJu0Yzotn7covIVg22I0lsKM/svoRPrKoiy4QMO4wVlFcti2dAwFoST
	SkSC3mPDLgXDy4MnGewE6bDMXKlzOWKOv8r2N+MYtQcBBWZ2mqW1guOFErmOhXp91tPUKMjzGXE
	/5+WJAUnD8Frm95Ge5NBIoRx6r19UHh8=
X-Google-Smtp-Source: AGHT+IHbcgWIgLjwxnP6ifJJwJ8gLsF1v1Haocw3LiHwz9NZgkZd1CGGhSk0Nr5I39m+rB1kDDc1373wFlHrNpJrAR0=
X-Received: by 2002:a17:907:7fa1:b0:ad8:87ae:3f66 with SMTP id
 a640c23a62f3a-afddd249ab4mr76817766b.60.1755571648234; Mon, 18 Aug 2025
 19:47:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c2d9d516-d203-44ff-946d-b4833019bfd5@samba.org>
In-Reply-To: <c2d9d516-d203-44ff-946d-b4833019bfd5@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 19 Aug 2025 11:47:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd99qOQ7HX++=KbaL0H3S1Pg2XFwKvdWUeEvre6vMYkqew@mail.gmail.com>
X-Gm-Features: Ac12FXxcs2VEwEzvZfhRHqupBYtvU5gx39PYmQL27Uj8B2pQoDtTYsGb0_SCO3g
Message-ID: <CAKYAXd99qOQ7HX++=KbaL0H3S1Pg2XFwKvdWUeEvre6vMYkqew@mail.gmail.com>
Subject: Re: Current state of smbdirect patches
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	Samba Technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 5:25=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi,
>
> I'm at the point where server/transport_rdma.c only has there
> local structures:
>
> struct smb_direct_device {
>          struct ib_device        *ib_dev;
>          struct list_head        list;
> };
>
> static struct smb_direct_listener {
>          struct rdma_cm_id       *cm_id;
> } smb_direct_listener;
>
> struct smb_direct_transport {
>          struct ksmbd_transport  transport;
>
>          struct smbdirect_socket socket;
> };
>
> All others are moved to smbdirect_socket.h.
>
> For the client I'm almost there I just need to
> finish the move of struct smbd_mr.
>
> Should I post all patches including the ones already in for-next and ksmb=
d-for-next-next?
> But resorted, first all fs/smb/common/smbdirect/ patches, then
> all fs/smb/client patches and finally all fs/smb/server patches.
>
> Maybe we want a smbdirect-for-next branch, which could be a shared ground=
 for
> for-next (client) and ksmbd-for-next[-next] (server)?
>
> So how should I post what I have?
The simplest way is to put the client/server's smbdirect patches on
top of #for-next.
Because you are changing the /common directory together and it would
be nice if it was merged and tested in linux-next.
>
> metze
>
