Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD0B39060C
	for <linux-cifs@vger.kernel.org>; Sat,  4 Jul 2026 08:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783155158; cv=none; b=afRaA/hNkyQgh8UpqkYFagVp+mU+4JvRL+olpLuC2382uQQ7artMEOvc6jkIydtfhz4D/+usCvO4tPn6qsDhphFUf+MfzW4ZhDlN6UPZ/BRzQK2wgXoSdgCet72AZ1A2WIkD83J8QQQ4UaphMteCLnBVqmMZ6xk3LAZuVYyGRHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783155158; c=relaxed/simple;
	bh=9mTCxXbAcoXRCkf1hKCRF0hXkB3Pkee5TXgIso8Oy58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gJ39FY4SEs30/dC85YSp0oiFpkmQ5zanQvrT6KojEnRpJzkGMtj7TUa79p2SLJNXKQ06O1BY8ZqpbKnXI6uDSewdtOw+uGCTUN+FXD0jbUXTr02WR4OGLo+Vjnq7Av4oGnfv5EAco7BtwNKQqPJkJV80ODgwXAIT4j1z+/u/tOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JEI378Cy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JEI378Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FC01F00A3F
	for <linux-cifs@vger.kernel.org>; Sat,  4 Jul 2026 08:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783155156;
	bh=9mTCxXbAcoXRCkf1hKCRF0hXkB3Pkee5TXgIso8Oy58=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JEI378CyVPe8Sy7Xbj/Ln+dQQ3oWtHShWtL4rUWniqL26X4lXV9Fy8HsjlpiDHlI4
	 P74Oskhrs12RnS6Mkn1NfrP9w/X6wlo6uimJHFCzVw03yGh98a8QWdy1OC5KDPyl8q
	 1a3OqInbyKZhr77f2Fym4nUKWSZsQbFq48vok5lfQPL5PKx6IF0/Kqakd7DLx73gE4
	 SDYNYZ4rOGU9Tgdf3B+1L0w3wySS2HgfrbCY5ML2imCzbLB+jPjwdhnntXyrZWYAyK
	 UfghArxihfackqsfShWnzYiIEstASOLB+InMVnk2EbjwmXLt2k+mojm85IWHRHJATw
	 cBJG1/rq6BTcA==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c12629c937eso153318666b.3
        for <linux-cifs@vger.kernel.org>; Sat, 04 Jul 2026 01:52:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoO/C4DIVbDxuqL1e8EnEFmISoWXfOIVMNO6z/y8oBOXulPyYK4mtP9IJmPMK3bzhybVcRoK+Vuhwgi@vger.kernel.org
X-Gm-Message-State: AOJu0YyJBQ6TzCyY41LZmaprOJLafCi6rEUjqK/1mCeUt0X0t5P7DR1i
	+W5SSnLId9i9n6FWJg+9bDZzTDGPK2nngOLrtTyPnqizKTu6JPBuIwjTpiuGo/lv9OB9EeU/9Ea
	H/npr8msp9ThivTA3cBDXNAP2C5mRw6I=
X-Received: by 2002:a17:906:ba85:b0:c12:508a:2b49 with SMTP id
 a640c23a62f3a-c12e6b764demr68633066b.33.1783155155643; Sat, 04 Jul 2026
 01:52:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702110522.911411-1-chenxiaosong@chenxiaosong.com> <20260702110522.911411-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260702110522.911411-3-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 4 Jul 2026 17:52:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8F_2ZTFc5eUmo2xS_irPnsmFmEq9OKhGSSY-Ra=b882w@mail.gmail.com>
X-Gm-Features: AVVi8CdmJ03_60pvmC80eSTPwT21UaCDvQrkAzmF7VCUmFu42REGu9L_PRa7T3U
Message-ID: <CAKYAXd8F_2ZTFc5eUmo2xS_irPnsmFmEq9OKhGSSY-Ra=b882w@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb/server: preserve compound prefix for async
 interim responses
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 8:06=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Windows clients can issue a related compound request such as CREATE
> followed by CHANGE_NOTIFY. ksmbd defers CHANGE_NOTIFY and sends
> STATUS_PENDING through the async interim response path. That path only
> built a response for the current command, so responses generated for
> earlier commands in the compound chain were dropped.
>
> This means the client never receives the CREATE response that contains
> the file id used by the pending notify request. Windows Explorer can
> then stall when navigating away from the directory until the connection
> is torn down and the pending notify requests are cleaned up.
>
> When sending STATUS_PENDING for an async command, copy the completed
> compound response prefix before appending the async interim error
> response. Final async completions such as STATUS_CANCELLED and
> STATUS_NOTIFY_CLEANUP remain standalone async responses.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Could you please take a look at the three smbtorture failures caused
by this patch?

smb2.compound.compound-padding
smb2.compound_async.write_write
smb2.compound_async.read_read

Thanks.
