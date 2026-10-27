Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069053;
	b=FSgwWh/EvklkAaUgtNKdt+8rp1thQXonJGkrLEi/gt1oPL3JQU8ttw41y+j8vN7wBMCJ
	 bPcf5z8eTiLi5HUzUUVKzK5dbTPRUFHHMF8TzutmgjlTdRk7l7WUYjrehA2Vs6GZ+u6sY
	 Mj6Q79IIL4RMu8La/SFr+YzWT5cMRQmQOcM140RnLO1aWs+vTiOgua75NFvw5UWgXTPIc
	 o8M0UqTclFtCdZ6vQqZjcc+HQZk68AnMRZ/KUjwclr7m/1ZPQsieQtLGzkEcUttz1s5Zr
	 lJttjX2Y0tgujQPI15yy1UPvDhv+1Crak1sdAFX0tPrwy69Aq2IfsvRgzCHN/XbmoAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069053;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=I2Pn6xRJYEBPJmWug/edeMipFZTmZSxh0VD/dkwMazw=;
	b=BxRPkIWUEjQ8ZJdaTatcZfLfxKdV1atTpAOtqykLvKEGrDrPfg+ZPQ/0TAsz5rYSsnHM
	 Kdg6sexMGWHUDei/MzQb5bDib/BWaUhvW4Lq+bJiC8JhYU+3UIesj+TpGCmy4o8t+GI93
	 i58eDyE31UBIJFKM9DAgNL8CNPFwV2hPDgwptqJHB0B11W2ErW3Z1EmQC/aoaCoQiDQZf
	 2CEo0ZuQvnL8v1+1vVL2alpfaZrb+7MPnCEP4cTrT/LL/Y/9OcPwSrMwDixWitVZsgdgQ
	 /4Fb3NcTJqLt54oTCCP/qnDZzkfb2njHvEs2qc+L8ewhPUcHduDwYSy+qfIcfKMAhHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkmh+LGv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63AB606A31B
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 02:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkmh+LGv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA9C1F01828
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 02:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793069052;
	bh=I2Pn6xRJYEBPJmWug/edeMipFZTmZSxh0VD/dkwMazw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kkmh+LGviL+8CjjEtjV/aE9szaodjPsQWw4eXioA31QOwUTD7zQMMND+iNF3tskAW
	 mUaZaArRpPO3Nqms1Mls2Lqnr3xKtxkRNElRMEmAPpjs8B5daoX0k8YovD9K1nsI1F
	 xXqSUL0ofXoSVXTC0aFuU+GK8R8iMSvJz9ElIRf/qJ8syKanEQ1EABeZFzhBKvKghe
	 CVv3ibMUunImTjjfcx8TaJT0PIf2ezwwQ/YAn+92tm9ViuxsIFndWOsDcfShu0fHQP
	 rHpRWDJxM8JNzFjWrwmlL0PYiwuaiAYOQ8Nh1AMkBzKP0S3rQ5etaF2Ttpjhk4NV8J
	 Hxx8IXJrbWXsw==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c169ae1cb26so74880466b.1
        for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 19:44:12 -0700 (PDT)
X-Gm-Message-State: AFq9FYIZBlUbUn2PHEOkagwxlPNVeU2uzmWJ4m6bIp0fVgXS65R9NBAh
	B9U0uNydaMw+Y+xX5dCn6ZMLOisi2EHjVW8eIO6AojaAhWbKnkdwBNUk0FWEcoJGm0tLnjwDeIy
	HaDoSj9vK7CxHawfGmbrQi0fURe4NKh8=
X-Received: by 2002:a17:907:3f88:b0:c2e:62af:b6fe with SMTP id
 a640c23a62f3a-c49a71ff750mr110811266b.8.1793069051228; Mon, 26 Oct 2026
 19:44:11 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026004644.239554-1-pc@manguebit.org>
In-Reply-To: <20261026004644.239554-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 27 Oct 2026 11:43:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-0pD0cSc1aN3rfutb+HuWx-hOC=kiFjJmHEN6-_jbpSw@mail.gmail.com>
X-Gm-Features: AclHuK_RWwFxHNp00nLUu2mkpDKyXyJdgtDIjGxzidPUsBjisouYxgCMHa6raJY
Message-ID: <CAKYAXd-0pD0cSc1aN3rfutb+HuWx-hOC=kiFjJmHEN6-_jbpSw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: don't resurrect an exiting tcon from cached
 dir workers
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 9:46=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> cfids_laundromat_worker() bumps tcon->tc_count for every expired open
> cfid and queues cached_dir_offload_close() without checking whether the
> tcon is already being torn down.  Racing with the final cifs_put_tcon(),
> the tcon comes back from zero and gets torn down twice:
>
>   T1                                  T2
>   cifs_put_tcon()
>    --tc_count =3D=3D 0, TID_EXITING
>    tconInfoFree()
>     free_cached_dirs()
>      cancel_delayed_work_sync()       cfids_laundromat_worker()
>                                        ++tc_count =3D=3D 1
>                                        queue_work(serverclose_wq)
>     kfree(tcon->origin_fullpath)
>     kfree(tcon)
>                                       cached_dir_offload_close()
>                                        close_cached_dir()  [UAF]
>                                        cifs_put_tcon()
>                                         tconInfoFree()     [double free]
>
> cached_dir_lease_break() also bumps tc_count without tc_lock, racing with
> the laundromat's locked update.
>
> Take the tcon reference through a helper that refuses once the tcon is
> TID_EXITING or its refcount has dropped to zero.  Queued put_work and
> close_work then always hold a tcon reference, so tconInfoFree() can't
> run before they finish and free_cached_dirs() doesn't need to flush any
> workqueue.  If the laundromat can't get a reference, put the cfid back on
> the dying list for free_cached_dirs() to free; its handle goes away with
> the tree connection.
>
> The lease break path finds the tcon on ses->tcon_list under
> cifs_tcp_ses_lock, so it can't see TID_EXITING, but it now takes tc_lock.
>
> Fixes: 3fa640d035e5 ("smb: During unmount, ensure all cached dir instance=
s drop their dentry")
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
