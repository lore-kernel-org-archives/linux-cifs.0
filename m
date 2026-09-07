Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D91409285
	for <linux-cifs@vger.kernel.org>; Mon,  7 Sep 2026 07:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788765102; cv=pass; b=jgGb2cnCb1nJNhAqpC4uANNbdQq838wxEGxyStIAgNdGgPKqisWsEEzGvh+P/Pk/EIcnHshSd8ByotymoBwB1PXqZvb35jYjz/RWmg5HhALLRvxKzWACYXpO3eYmSiKKcvNvpcYHQfhTfvVT3wjH4Zu3lpNjtgAC7ymZZbJiCv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788765102; c=relaxed/simple;
	bh=xpfhj9CqQGw1djvMgAWRKBm9LL12W7qpx9muQpgeWuc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iyB3wMLqdmdfoqOOsth/qK1sKRRroikppmHr12GcoINvJz9rr9UKOncKSp0EiOlvDgRH7uggVqLsgOCFJGGmhIS81ed0t+UFXPWBtPt5dByMpEG+MOsZW6DvQdukuT1FEE1b9/CrF1Y8CKPaHiuaPxmDs/kbVVWP+Wo36OqQ4cs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PfdDe1HZ; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfdDe1HZ"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a7fa3a442bso2277929a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 07 Sep 2026 00:11:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788765098; cv=none;
        d=google.com; s=arc-20260327;
        b=o5Bpq/igDhtBvuC0LkrUIDBDv499azvIFJ+d+kPvWTuQi0vEyrhSuoErfyibPmCDhe
         Az1fIWWMH1HK0apMYgL12vGjhEiPAbAS0ztG2WZRwvnnn2KP0dJRnLTZYX5iKxiRnwZD
         5qnXmdun1ODNICIUAF380Yr6+NCGgM71G6bVvjDAo5UkWxgtuNHmFyO22Qge4HZxP/Q8
         8m8Y/gS7TOj3/f1qXrXs5RP/iczeZU5OZaVARQNveR7DJn+hUv9v/Ti3b6B+S1J92Y59
         GYmPtFyMu+2ikj40bfL3jRORgA+NHwii5LdxURMBiPBFIdEY+b7nu65Cc90HRa6BcQ0o
         eHVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4GfJX1pNhwe4TJ2PBeXgP41xA4dsYWvA53kiqlN6MDI=;
        fh=+COPTarNgDCUo7gHKBqeMM/i9KuaOCB8/urm1oz4rWk=;
        b=bN5Af89EO0kMkZQGK7l1TlKDa840v/qV79jEzH4MWbd7E3Fy87gev85LZv1lCQpRBE
         v4fhTb1wfEhHzcWWQ5t6R9a1ds9LA4D1D4ckBH+B0Ib/XVKEgD6QG/pca0zNiz2TQY4S
         4s53R9PLQnB/sXxSz/ioUYT5k3Q3MbFgHKgZdH+NSEHBLW6z7aGVF/K8E9+0zQH/E0ob
         EOUwBjTfQO34vmtU9AmIBn1O4Klsxl48NDsFqutHbjz7VH3012+pqUOe/Mm1f3If81Ye
         1W5uoUdbwjSo4qrX6m+kNHgj2qpg2vfxAn3lSwyCgcSJhVr2eZ3683yLHMQ4GMMMyYCW
         xE0g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788765098; x=1789369898; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4GfJX1pNhwe4TJ2PBeXgP41xA4dsYWvA53kiqlN6MDI=;
        b=PfdDe1HZv27a+vrllpcHa4gBqsqRieGp3DliYTXonzHWPCXZklHHfOAfyvcJ1ESAJ/
         WnoDS9PD0OHqSkg/jc4vIc2zWlii09e4np5KCQKg+krlMQQ66XSrMGEtOYj1u0L+z1D9
         Fhtd3eaArDdPldnVbCbeDFQA6CeuJAyXR3tTthuH4Pqsf1Rz6XgKMM6MruEurFIizxNP
         IAHUYpn58KmXgkfkj0/TdAbSNyk3D1fOKSOdkqnpeltgpMkRr9g3VRpGXAky/BSlTI3G
         1WFAJBSLgc7JhBZERq/rHzX1CqPQNxJ6cIUnUv0L0F1gykd6D4/jdBmqOo+AAWIRL4XZ
         2hgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788765098; x=1789369898;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4GfJX1pNhwe4TJ2PBeXgP41xA4dsYWvA53kiqlN6MDI=;
        b=FGRAhNaYhsum2dNDWFMauQyY0oZL8/oNaA00x0V/1S1LbYEcbYNWhEPIMpGnpmt5Ll
         5bkYu7tUHH6oICHr1w8dJO2/FcD/5Gz+M5grdQyAlzYKCzVdT7SERplS8CIUvrMV/+11
         jFNTX3hZlP8MoOnfLQF4H4M+vV8XqUlPqNiXQWzgCgfoZXT6DwlmKrOQw6VnoTMjRW/o
         AnlqKGicb18GNQeHhjwE1P8IGsYH19E4dZono+NJOeITaM1SxWmAZ6hnCJHmuMsPesW3
         Wc+f7OIXJd0O2iHpl6btl8IyFAYWYS6KfXA0n785jssATKPzH3IunsRFAdYzSHL7CGrt
         b/rQ==
X-Forwarded-Encrypted: i=1; AKwUvBwi54wX6a1aqQCwZm+QKbgUKYobNo8Cr6omYfGaHhNVhncuRlg9WawGPfXYj94rd6+HASSQ+ZajovXf@vger.kernel.org
X-Gm-Message-State: AFuF++kOXzX2sZVWrZYoEeG0Ch2uGyVtlWQ2JnOSgdcbqe5tK89slZXm
	ZionmgnGR//cPf6tgyzeYrJB0nStU4qlb7bi7GErXD1gXZBwULof+ubAt0IP92+l6aJpipMY6RH
	GaVHr7XT5N2jktSh9Sr3EzY2YHVR5H/w=
X-Gm-Gg: AYBFou1CWyRqsO+RBM/sgsQXwmDFH33LWMnFavDZDGWk3Ug+z5ZwZTevdJImmA3EEjO
	xpYLkN5FVxyepqa5+izUJQgYbzqi+njCiPGCuobtf6EbE2mM1NxyZU3kxZxTzVLTjvElkjL4ahi
	aRTaxOKDS9bpqR7y6ypHTIiin4ZhY490Nxq/l34IG5Zzef8BNZmE2wCTkqMMc0f/m8dGiKKmVA/
	feVkhbBp69O8p/xCnf8YzCeqsdmjkO8ErEu9iIAFxcQE7Bbbauj3SNuzYRoxcMhRfRkPjRASY2e
	Ev8GEDJZPudqsFYlBABXfPJ2G2HSlnlByauBWifugl4=
X-Received: by 2002:a05:6402:c2d1:b0:6a7:ee54:f8a7 with SMTP id
 4fb4d7f45d1cf-6a7ee550028mr4476218a12.43.1788765097908; Mon, 07 Sep 2026
 00:11:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902182814.25700-1-kmehltretter@gmail.com> <9aa7600f65742727d7588941599394c3@manguebit.org>
In-Reply-To: <9aa7600f65742727d7588941599394c3@manguebit.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 7 Sep 2026 12:41:26 +0530
X-Gm-Features: AcwNN1UH2ngQE7-DydmyO5TJ_x5T5DxE21r6DRk7WzLm3yShVABj0CylMJygn7I
Message-ID: <CANT5p=qyU-cdf4RSX0Ab7B9ZcqzLd2BY5h-_X_kq35C_K3A69g@mail.gmail.com>
Subject: Re: [PATCH] smb: client: pin DFS superblock in iterator callback
To: Paulo Alcantara <pc@manguebit.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 10:27=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Karl Mehltretter <kmehltretter@gmail.com> writes:
>
> > tcon_super_cb() stores a raw superblock pointer, but __cifs_get_super()
> > takes its active reference only after iterate_supers_type() has dropped
> > s_umount and its passive reference. Concurrent DFS automount expiry can
> > therefore free the superblock before cifs_sb_active() uses it.
> >
> > A deterministic KASAN test reproduces the race as:
> >
> >   BUG: KASAN: slab-use-after-free in cifs_sb_active+0x77/0x80
> >
> > The same test passes with this change applied.
> >
> > Take the active reference in the callback while iterate_supers_type()
> > still holds s_umount shared. cifs_put_tcp_super() remains the matching
> > release.
> > ...
>
> Applied.
>

I'm not sure that taking a ref on the superblock is a good idea.
Can we find a way to do this in a synchronous way in cifs_sb_kill?

--=20
Regards,
Shyam
