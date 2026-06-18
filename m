Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A07346E57
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781803111; cv=pass; b=kRyZpsVMT+5Dtzw1P8m6tc1eaxIuD7AOX8Sr9ELfbSZIxU0D0QwvvlF06c796HKgWWwgbGmDYElo3TOgxxbm5mGrOSyW+2z53SD2wkRFe+hX/F8wF7ox/zaLdKgwVV1Qug5RaX4et1P8DVHK2hvcQAbTTQPLHTAtDRLqxMEnuws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781803111; c=relaxed/simple;
	bh=22MQfcZxyxQbURyQpiHPq1M1IO68LhtsIBcxMYN9GjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bH4/pLg6nTCfvTpJMNF5nsOUiJiqn4scjx37OOLJ/Aa+9BrcQ9ZdMPM8QHfuJTR3Q8lBrN/2ieZnKvNb2ataN0lT+ZzJ+bBH8a3a5m8du/K5ClsNgdcTdG6ef0XbmO2BvyTU95vrC+aQXzglRebwYeZMM/v2glz/jl91sEUswbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aw9sIlit; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aw9sIlit"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8ce3876a50cso12226726d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 10:18:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781803109; cv=none;
        d=google.com; s=arc-20240605;
        b=ArT8Ahyn2/UA9rWHAFDZufHC0TUWZ/RJVvbL0StV0ajW1hejgOh7bWbNX8AmrMdk4t
         R9i/4T+DHPyEFzhVGOP+ULRaTZj3XmpJVgW/Yg2USwVNDxssiGbNqdUt1PCkW/yqsCRX
         xknEEZ59DRlKmvyYFNebq2/z7Wvh3yWya2T/F0r2jq2w8/M9uOG1qosD2dFEusuMUaZ7
         b3N178iowiAv1AnbrORkdFAO4I86q/xAfB1TrUUdA+pO8pj65jjIRGF6XypPrVuC/byb
         rxuhLCHxe635+1MX9c9IJvfYlTzwV0EPBcmhJrcPGiinrOyb5Jb0C2+0oZi2DEFtOxFi
         YG8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JNsq8yfmhbN3NWGX0vUrRxF8RTZcApo54OlB91rRZzI=;
        fh=0arFOlhmDBfb5vRRMDXROiA+nzYMMZxHCMm53/VR26c=;
        b=RtW755HGCIUihxLWBa8y3n7qnZLyrRTeK2DMMhQ8nth2q5DRv+HaQlPjGPaNJ1JxYU
         UxHX/MUycXlEiwaze1dgOQLr7i5/DROWfnlTTQG0+RljJOP5EH4K/a4MIBfbscx1YwkW
         v4CNUo8T2pLgD6Oc15cxwzthkHZptZRsOUg79moSzqBBNj4XZ2FiJHYuzzJacmtMSeED
         GTZTImccU1vg2qPNsT5/mwPOy8HJsmSL6EVVjHAagAVz15mKWJZYuODJxh9TVV5JLOHg
         nFvQTHsKwjdQKzuueC2ySKHk9+dXd4Asz7ypo1iWut5GqOH04IqR/iaaHKL+b78D47hb
         Q7ag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781803109; x=1782407909; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JNsq8yfmhbN3NWGX0vUrRxF8RTZcApo54OlB91rRZzI=;
        b=aw9sIlitQMmmZtUJCoXmz7WrkDRZY91ReU5BMsh285JAYKG3vnO9DZ3lZViQsdNS2J
         trq9qHtlbcNXywlBtP4Eg1597jxXElq5x0Et6jHGb3/VMD+atzSODbRikew0UDyhz9ZF
         6q65SaF/k+r6qJXQ1dBu6co064UcRC7FxLJxTw9piXe0RyaebmiE6F7n2HVDe5Q/RAy0
         EELndRHU0ikdYCWzikM+XJEBx1GyhIOVfgmb6Gd0WHmgfXqBtwvV0CkKnWXBx85C9wwA
         qN8y3HZpUfU2BPbU44QfBYpG+S6jWBldPTv/wXex8aZrD0k7GPxwwJT3Ndru+Fq40RMA
         zJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781803109; x=1782407909;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JNsq8yfmhbN3NWGX0vUrRxF8RTZcApo54OlB91rRZzI=;
        b=OuicWbVnsQospgl7gDBs9eidkoIDupUe8KkNXexC3Vi9pQgmH/iFggWg6V+3U7ZFC/
         JLPP6Izx+otx6cX1qe/Kn6UqzJWqEEoSSnoxTVTObTuXA7aOReQs72e5W7KbCSq49htC
         zTbB2/yQsxpWFWNkB/tUISq4AkFCekx+H0sUYjF0nFDeEHeH4yvzdT22SGOHiBAxYUmR
         37+NAijmWXH9PKbAoDx/Qo03XNvQYiEvA+Sc02qutoyNr5pzbcSZ27dV0iHeJLKrz3un
         LhPHLhbgRr9g7aUBJssRdrAmGqukup30jIgQ0dstOIzd7aruR8iiJqWO160RSvlgxLNm
         soUw==
X-Gm-Message-State: AOJu0Yz7VkpMoe3yAEUyfcHddhRxByYAUwYNg/7Ko/BWSBn5UzrXbyyL
	4aBwQJMIXdpSnoYCWZr15S32W3C+9C+3inNzd7yBCiVrkV9+nO0+2wKdLHH/utqBRGrX2NE5lWx
	aFN85H0lZxmmKOB+uiTMWpy/g3sjSnik=
X-Gm-Gg: AfdE7ckXNf0i0ERSDbgBtnYpvlJLi8kW44uEaEw5wH4/QA9RRgTa6kXV3MlbaHZXa/6
	SMo5SqEaxJdH1Y9TwMoNOsq633ezVApHy9+vaT4+0MrCj5lQ9Rhcsf0CGbj/qL8ZKpFof7gZJok
	fSbNeEgL4YcupUyWoqcf7eO0k3+0+uJ+hr2FzNdWN6I3r9uxhYfDkBO5IlJDnD7nLiFDP+cRI3D
	gLEcoe+eMtRt2mKSBB8ZiKtIf88yJeDaoGClRWnQ7jgIO/w+6BOTwecPBYEXjAwiPp1x8bzEwgR
	RfPQOViyZkKfUAyle9lx0ORDmqPxDGXnnfW0gW6WOiBqLg52E8kTtaL1yil4bkzlo8fIcspIOWv
	AhgnoAEO+P16yxbpIw+cPQtpoMZSUOhcnD6Eisr9B2j4aAnPg3I3XX+wAnuNeKlV9neyZD0Cb0C
	kZa0VdcUEXA5A=
X-Received: by 2002:ad4:5f0f:0:b0:8dd:69a7:d60 with SMTP id
 6a1803df08f44-8de3bfeb526mr2773136d6.0.1781803102697; Thu, 18 Jun 2026
 10:18:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1781768474.git.zzhan461@ucr.edu> <590ab8fd378a195174f33902b71ffb926b610a46.1781768474.git.zzhan461@ucr.edu>
In-Reply-To: <590ab8fd378a195174f33902b71ffb926b610a46.1781768474.git.zzhan461@ucr.edu>
From: Steve French <smfrench@gmail.com>
Date: Thu, 18 Jun 2026 12:18:10 -0500
X-Gm-Features: AVVi8CdGL8Bw6xdlWhDu2V19VOc7ZyFakoBkEQYHfvuFNHiyYWyyqE_4BrWBfCE
Message-ID: <CAH2r5ms5JC-OCf3EqEAH21RWWOrrxyeFF_V9+DiC6xG0vBd0Bw@mail.gmail.com>
Subject: Re: [PATCH smb 1/1] smb: client: fix double-free in SMB2_flush() replay
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	yuantan098@gmail.com, zcliangcn@gmail.com, bird@lzu.edu.cn, zzhan461@ucr.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending testing and
additional review

On Thu, Jun 18, 2026 at 10:31=E2=80=AFAM Ren Wei <n05ec@lzu.edu.cn> wrote:
>
> From: Zhao Zhang <zzhan461@ucr.edu>
>
> SMB2_flush() keeps its response buffer bookkeeping across replay
> attempts. If a replayable flush response is received and the retry then
> fails before cifs_send_recv() stores a replacement response, flush_exit
> will free the stale response pointer a second time.
>
> Reinitialize resp_buftype and rsp_iov at the top of the replay loop so
> cleanup only acts on response state produced by the current attempt.
> This fixes a double-free without changing replay handling for successful
> requests.
>
> Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay =
flag set")
> Cc: stable@vger.kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Assisted-by: Codex:GPT-5.4
> Signed-off-by: Zhao Zhang <zzhan461@ucr.edu>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
>  fs/smb/client/smb2pdu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 958ca0753774..2d7b147f2892 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -4433,6 +4433,8 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon=
 *tcon, u64 persistent_fid,
>
>  replay_again:
>         /* reinitialize for possible replay */
> +       resp_buftype =3D CIFS_NO_BUFFER;
> +       memset(&rsp_iov, 0, sizeof(rsp_iov));
>         flags =3D 0;
>         server =3D cifs_pick_channel(ses);
>
> --
> 2.47.3
>
>


--=20
Thanks,

Steve
