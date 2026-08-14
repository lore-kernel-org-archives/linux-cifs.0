Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC696346E64
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 05:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786686692; cv=none; b=GeU/qvQJIckwGyvVo0ljoZZeJOVWDGQl95bGR3p7d49ZuK9N+ELyJ3LdQNQOcChyMAxCIB2EgdRxVFxESlc1CwBGDsDmBK3sqrCjelsV+7MvI4stADT+rX/D3eDHCz6HT4pHLxw/xkn4aYBcLibics6QW+TFotpRj+uugu4gzJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786686692; c=relaxed/simple;
	bh=+cnuGNmOXJBKT9gHWONYlEjY095QdDIkRbJy7VqxjH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dWv70u01pL2VizpNsN7odolTTStWqpwjOCUVjjEMkUWQ9Kokq7k7kdse6M8RJAhTeE4GJo/0RNomyGe90gpT8J4CxWk4XZoRIqvlZWNGDVUmWiokY/EJousjTnOK+qsH36p+lh8eqN2HKdWLuhCtQDCwLP+kgY/H8bTkwrV0Eqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jSSTdTKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jSSTdTKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD681F00A3F
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 05:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786686690;
	bh=SbvJGpJjsPce5tevtVKmv0fpyob+Azm2MwdG56Kticw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jSSTdTKGYixUxneZVblsJlNZMFHIYq6llKU+WbKcl7mPKQvTJDix2ExhYjPhlN56E
	 uVr9/sJzL/GaNNWkXsIXpBC7c9Nl8xwRoOsSZG+F/WiumHldrbtfW3UW2eV46JD9KB
	 YpdmlZWkz5ajXiK2HVygD+ukJwSVSLZtECBMbZJpmQGhJD3fhb/tXUvJ3UGtyzo15Y
	 Nz8/n+1dvAWOTP+d3owEq9udkz0qgcrFM8YwkigG8og/qn9oJ3s8iivuOZ2h33b56r
	 l6kfH2WLdoJfPEvl4J+kTUgCh72EZm/p8hhgKofPUsZVPO1zhDx789/gIPP4I7w+ZX
	 FOde4cbBljEIw==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1fbe461f59so102551766b.2
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 22:51:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RosKbuC71ZmXJe6N4en0J6z1R2LdC+RsatfkyHe0sAY4YkJBbdORmvgqRNcwpqcX9H1uF9nL85MLj9Q@vger.kernel.org
X-Gm-Message-State: AOJu0YztVLc7obeAd0ch5wN5XSz98uFBayBGqKQheuR1PhceXNrIqWpC
	IcxlN/ifp/RtEVHGq+H+WTaUJLvGceYCiBweSyRlAVVNUtwQcg3JCMvYvHi+lNhhr3mqVon7q7Q
	MbhCoPgs+MaYxKfxPMU//Wa1pmhtS950=
X-Received: by 2002:a17:907:d303:b0:c15:db5c:7127 with SMTP id
 a640c23a62f3a-c212a1d684bmr124703566b.20.1786686689180; Thu, 13 Aug 2026
 22:51:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1786674373.git.tanze@kylinos.cn> <53c06a45facec8c91593ff75ee102ebabb358a9a.1786674373.git.tanze@kylinos.cn>
In-Reply-To: <53c06a45facec8c91593ff75ee102ebabb358a9a.1786674373.git.tanze@kylinos.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 14 Aug 2026 14:51:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8EEr8u9=gcn=D24DCLRWA2dPJCfc2-93qpe2eG2ix89w@mail.gmail.com>
X-Gm-Features: AUfX_mwB3AxlS4T6Bfb_hyn9T7tmETKHocznnlNdCBypembFWiAqv0cuQCUcStU
Message-ID: <CAKYAXd8EEr8u9=gcn=D24DCLRWA2dPJCfc2-93qpe2eG2ix89w@mail.gmail.com>
Subject: Re: [PATCH 1/3] smb/server: fix tree connection leak in smb2_tree_connect()
To: Ze Tan <tanze@kylinos.cn>
Cc: sfrench@samba.org, senozhatsky@chromium.org, constant.lee@samsung.com, 
	tom@talpey.comm, chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 11:37=E2=80=AFAM Ze Tan <tanze@kylinos.cn> wrote:
>
> See the procedure below:
>
>   smb2_tree_connect
>     ksmbd_tree_conn_connect
>       xa_store(&sess->tree_conns, tree_conn->id, tree_conn)
>       ksmbd_counter_inc(KSMBD_COUNTER_TREE_CONNS)
>       ksmbd_share_tree_conn_inc(sc)
>     ksmbd_iov_pin_rsp // fail
>     status.ret =3D KSMBD_TREE_CONN_STATUS_NOMEM
>     // do not disconnect tree_conn
>
> Disconnect the new tree connection if ksmbd_iov_pin_rsp() fails.
>
> Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
> Signed-off-by: Ze Tan <tanze@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
