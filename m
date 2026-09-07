Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384363043DB
	for <linux-cifs@vger.kernel.org>; Mon,  7 Sep 2026 23:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788822062; cv=none; b=QMrXrNwOYjwogKeiIAhTszdX3dgDyqbAvUP4V6pj/m+qH1fPRr5tRPUIMLNYjnvLurZjLyzDudazMdngNpTZPkScCMsJmu9ODBA/QqaoQMxCYl6Q+999zdFTXo2Z1wja5HLIceJhHbA6HyN8+f969usEv3yTgIkOYt/1KM/FRwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788822062; c=relaxed/simple;
	bh=FhDGlsmibDDb4ftfTcaZFCfOIdXAGfv6KGdOuxn4Ww4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cumVKC/lExs0vDLpzw7j5n8GGgg3mQdgLEENlL52cMQYY3C79NB+3jXMLNXqW1/FrrRQHk0zifOPv7aKQBXMSftOd9IeVZVwn1oS+AsORLLKIjGmCjtEOClWqHQ2qR6BDb1vpAYyRyPXNyZ7dN+Jwa3c4G/swe/LZgms+LIDzDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YnpoRCp8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YnpoRCp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202601F00A3D
	for <linux-cifs@vger.kernel.org>; Mon,  7 Sep 2026 23:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788822061;
	bh=PX+PF6Pn17SWhjBweuUcg+2Nwy0ktQaf/Kz1R4n5GAE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YnpoRCp88N40Bx+abjk+P9aymmwIZJoRjadwIMlMnIPOuy3J3WAL1GezE3BZB7841
	 URBidqQV2AcRhrKRWBXmcCii0vNCqnWoMsjU+PA66VOyavDTk+dlAeslBkup4wWfpl
	 mO+A0EZcC0dJYjfCpJ/EZfkG5yZC72T8DjFcu83xLdc9bBNme8biDfTK4YqW9pLKlI
	 3UuL4yBOjIgRI4QjmTLBNfIP/pGc/Ajz91dHWZch+NXi89GkAQpPUtpCbiYaf5Z/ZM
	 +47yrtd8BIy0g4lNSMFV/ssmAbk7u8CmiJ4X2lWo34ND+H+QAODWFuBNMeUsYYJfxy
	 ThT1wfbX90XVg==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c20e70a0962so496296566b.2
        for <linux-cifs@vger.kernel.org>; Mon, 07 Sep 2026 16:01:01 -0700 (PDT)
X-Gm-Message-State: AFuF++nYF8XHtWma9wDheVJP6A9PiT6+MhsTljm6VocftzGABuhClY3A
	AxTu8EgR3TaovcboZ8l2W8eOIohZBg7+Jw5PbjrcJTN9THhcdP1A1AqYpk28rx/GE+hdZqQZ9Yb
	JISx8Ih7gPRETr1hygsM1a0n6LQcTFb8=
X-Received: by 2002:a17:907:c16:b0:c25:2d27:5652 with SMTP id
 a640c23a62f3a-c260c9d1affmr1740826466b.11.1788822059805; Mon, 07 Sep 2026
 16:00:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260906200517.725015-1-pc@manguebit.org> <20260906200517.725015-6-pc@manguebit.org>
In-Reply-To: <20260906200517.725015-6-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 8 Sep 2026 08:00:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-5rqr0osjZx3Vu-076oB4X3uB11=Y4fue_s3Si0iSxmQ@mail.gmail.com>
X-Gm-Features: AcwNN1Vnn_qMlVY3OP4Y951aknIl1vqM1jADHiDUO2zZMo8IbwZtrFLf6NlnG7w
Message-ID: <CAKYAXd-5rqr0osjZx3Vu-076oB4X3uB11=Y4fue_s3Si0iSxmQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/7] smb: client: fix file type corruption in posix_reparse_to_fattr()
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 5:05=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> Setting the file type in cf_mode without clearing the existing S_IFMT
> bits first is wrong as it corrupts the file type when cf_mode already
> has type bits set (e.g. S_IFREG | S_IFCHR =3D=3D S_IFLNK).
>
> Use a local ftype variable to collect the new file type and apply it
> after validation succeeds, clearing S_IFMT and setting the new type in
> a single assignment.  This avoids stripping cf_mode on malformed
> reparse points where the function returns false early.
>
> Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40mangu=
ebit.org
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
