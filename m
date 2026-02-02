Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1B6239567
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 16:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770048936; cv=pass; b=c4dmU+AJaJfqH/AYNKcZlpXj0s1ruo9WeSrak5WAE+Qi0sRRWdmfcJBJh7Dj12m1Tvr1tW8wilbFQnyE8fFYotJkAIlT+Gv2g3z1aQp9oLQDldDdwrcX6fWdeLjqxRN8OJWGI4LAG/8aQe628YVQ1gpjdoIzPL6TkL2t8Aenjt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770048936; c=relaxed/simple;
	bh=eeWoH0/KlbllwOWw5CrmLSBbrEZqtgjUIK7zsMbs800=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RLycrsIrXJBYgLTSeEPel77oKGsxcztPJyLS6lz8sSB30iLJrFitlnm3KthtqgA84EJgKL5U4JliMIjJtBc4Kgz/TNhANh2klaYxr1X9bno3MVhHSim5Sjv2DVc6S5YBwJnuTlODG+NZlGC3Rync+zpL5ZTWIDQs9Ydk4jsXg9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0ehr1K3; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0ehr1K3"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8947ddce09fso37230796d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 02 Feb 2026 08:15:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770048934; cv=none;
        d=google.com; s=arc-20240605;
        b=k3hC6siANYANel8slIQR3KklYc1sN6rjeQbcwbl4ZYFmFxKl7IxkNW3v0L/UZ4GwRd
         xYw3cTpk2oPKjZFOR7JnINrI9DD+phd7oYotWwZgZf/76j6W/bvdRhWhrQ6khMidYPvx
         FB0qLMXkvNhH896m6XRl5xFkGW3oS1VCpVGGOH4z5ausNg8DOsWKmHK8ie7PYUpBL5KO
         7LJWMBNjZL5AtmAhne5n67iDsd86vYMMPyw50QmbHHkr2c/5H+ZqN7F8iPhh9y+0tI1i
         Ux8FxLiu14fKgJi5AFXPvkjh+2mI13DgUIcr59k5O1JseJnPlJtfSAZ7zef/SZBUxuns
         +HJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JOH2AilO71Z6Fomv1qkktp7tU0+wyYw3E9dNqAMCyYs=;
        fh=5bY6Nrv7xGpOAapXxpXrT4ddOst2WVF+G7Ybn5VrFGE=;
        b=d9oUofHkOLO9MpZGbMEwAHvLVTqbUxjTOfAOIOPfztg85dmBnBT/kLZIZCNzAbb/GV
         LnR3Bv6sE5BBKCZr4KCR/fVfKMRNqjBBuna/R4zVZx/+6I4G0zuKhUD6aPW3Ddl0FAT6
         mb9j20KfOqr92gNQhdHK49cxtxSKc+Zk0NZb1pws4mObhDnT+kgwmfFuXs7uP8G6qnRk
         srL/py/CQvD3dPWdXs7dkf+G5PQQUS65LxICIiKtZJ4QqNaRivqGi2jbaSVYP7mf8rcn
         bce1sSkPRCUK/0AVywFxgzwgdzrxr1CU4wTiU/f2LdN6GEiDv1J7Zg8EUaHlNUHO0Rwm
         0qDA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770048934; x=1770653734; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JOH2AilO71Z6Fomv1qkktp7tU0+wyYw3E9dNqAMCyYs=;
        b=g0ehr1K3f0eVYfQQ+6q5rcg/PHyyeCUHd0Q2S4meOPpYopp8BF80cltIEFp9Vl8aP1
         p9mIYQL/41f2bh5UrPHt9ivquTAx1K/Q4OrphBV5+xO7A8vbLuN5T5KCOxDcnO7gFmFH
         /G7kAV6gFynaPre9prfucdiRQORvsTKGH6p9yHL2Wa7or7s3PMvZqZb+OjzASRYoOMWr
         opFZF0temkNhgdcfLr8jf4FdMtVMup7lYKONbNTOypukvX+aX65lDEDKjVyA3cgMjbHa
         aM/p1Qizmw4KNx2oRIV1DnQcMTDAUlc4bXNE11wWfK45i0NxruhIHZv8ZsivaOl+DCo+
         /HBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770048934; x=1770653734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JOH2AilO71Z6Fomv1qkktp7tU0+wyYw3E9dNqAMCyYs=;
        b=SFBeKFsVouJrJazuiNBK2GOGdjdgVEU9C2QdVKxJ3B9a0Ug2uuBVZaQtMlWzyTIN4G
         7U0MJ1Z89OpGnH9875yY6AACCTke2rbyXHARqb6BvQNS8sY8DCca7EM0PxTaHRScqP8q
         Piwh4ph5yBlrWY+lbvW+hd/WADugbGnOgSf6IZVN6CZlBWfclQk1mQgVUcMQhtX0XXn0
         Vqu6TOxuioRPh3VhHsoSVzWFdOXGsmeuffjFUil+pznlqQAMIhytDhgRVtT5Qa46E7Bw
         SsQg3JHiTbS/ujkElpawBePVhxMj95usdgxchsWLrFrjQ5ja3LeDTrj2uH4F7oOfYy0Q
         Q4wg==
X-Forwarded-Encrypted: i=1; AJvYcCWezoTC4G629Ay/d7bqDZcII/glb1MrCBjMIa2n26NeR1/xnohfCDdpA1S2vJ8DhZL5QIbw+nTi2UZW@vger.kernel.org
X-Gm-Message-State: AOJu0YyrjN6VMwzaehl3CrF1fjHo/HGD7QL+d+OPBNGlF1TriRnoUEVm
	GiHyHnirDvVoHucNuiVwyQewGshmTZMXqinOxhr/DISb8DxIcXD039hZGfb/AM66f2AjNSRJTRB
	MDWGwPMgrb8DfShoC2Xr2F8VTCyOxJaU=
X-Gm-Gg: AZuq6aJ2lZdW+B5S+hplflN3MDCiT9PIRxGmxpzMHKQwoBDuPpaeishGSCGvY1s+u6V
	W70oelVfe8EVbbE8wV3K25VAwX/pJ2PaGsWxrSpZByL3MVTgNm0ajbx3B+CWYVwMLO1KDqXM3tz
	Xhpik+h1MPuT5r9WQN1OinLmkUWYLCw9sT3wCzK5qoQpcNQ/hHX3sfu6PaTwPXI9Q2noGgt31Ax
	1ObTVQb3EYOPFkh0sTev8//0vtNVY8YOMWfclD4UFA/z/0LdIBfwQNIHI+9DVqodElJ4QSwfPqo
	HEx0dpgailbW0W+RyFMnh//02iTeGW4WhX+GMGcl9yKuLPFTARR/Idhux1G9b2pDOBuTkDX18Tp
	9Ip/oCJs1B0aXMT4yfTkNWtAhKWesoGgxZqeGlUHjHObCv/GKEZfdgylti0Jg6tF0qlUM/0reyq
	hhVEwyNmT1SQ==
X-Received: by 2002:a05:6214:80b:b0:895:5dd:3d5a with SMTP id
 6a1803df08f44-89505dd3e5dmr57384726d6.45.1770048933605; Mon, 02 Feb 2026
 08:15:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260202094906.1933479-1-chenxiaosong.chenxiaosong@linux.dev>
 <20260202094906.1933479-2-chenxiaosong.chenxiaosong@linux.dev> <2462953.1770046588@warthog.procyon.org.uk>
In-Reply-To: <2462953.1770046588@warthog.procyon.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Mon, 2 Feb 2026 10:15:22 -0600
X-Gm-Features: AZwV_QjsvnLniH2t63zZff2XejuDhmxfym1jyw2wGEbH9fnQGZrqEwzvvdQ2huU
Message-ID: <CAH2r5mtdBSbmXZ=KNypbnQir3gwMitBqrXJZOGjC9NmDhv1LiA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] smb/client: fix memory leak in SendReceive()
To: David Howells <dhowells@redhat.com>
Cc: chenxiaosong.chenxiaosong@linux.dev, linkinjeon@kernel.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org, 
	nspmangalore@gmail.com, henrique.carvalho@suse.com, 
	meetakshisetiyaoss@gmail.com, ematsumiya@suse.de, pali@kernel.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged updated patch into cifs-2.6.git for-next

On Mon, Feb 2, 2026 at 9:36=E2=80=AFAM David Howells <dhowells@redhat.com> =
wrote:
>
> chenxiaosong.chenxiaosong@linux.dev wrote:
>
> > From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> >
> > Reproducer:
> >
> >   1. server: supports SMB1, directories are exported read-only
> >   2. client: mount -t cifs -o vers=3D1.0 //${server_ip}/export /mnt
> >   3. client: dd if=3D/dev/zero of=3D/mnt/file bs=3D512 count=3D1000 ofl=
ag=3Ddirect
> >   4. client: umount /mnt
> >   5. client: sleep 1
> >   6. client: modprobe -r cifs
> >
> > The error message is as follows:
> >
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   BUG cifs_small_rq (Not tainted): Objects remaining on __kmem_cache_sh=
utdown()
> >   ---------------------------------------------------------------------=
--------
> >
> >   Object 0x00000000d34491e6 @offset=3D896
> >   Object 0x00000000bde9fab3 @offset=3D4480
> >   Object 0x00000000104a1f70 @offset=3D6272
> >   Object 0x0000000092a51bb5 @offset=3D7616
> >   Object 0x000000006714a7db @offset=3D13440
> >   ...
> >   WARNING: mm/slub.c:1251 at __kmem_cache_shutdown+0x379/0x3f0, CPU#7: =
modprobe/712
> >   ...
> >   Call Trace:
> >    <TASK>
> >    kmem_cache_destroy+0x69/0x160
> >    cifs_destroy_request_bufs+0x39/0x40 [cifs]
> >    cleanup_module+0x43/0xfc0 [cifs]
> >    __se_sys_delete_module+0x1d5/0x300
> >    __x64_sys_delete_module+0x1a/0x30
> >    x64_sys_call+0x2299/0x2ff0
> >    do_syscall_64+0x6e/0x270
> >    entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >   ...
> >   kmem_cache_destroy cifs_small_rq: Slab cache still has objects when c=
alled from cifs_destroy_request_bufs+0x39/0x40 [cifs]
> >   WARNING: mm/slab_common.c:532 at kmem_cache_destroy+0x142/0x160, CPU#=
7: modprobe/712
> >
> > Link: https://lore.kernel.org/linux-cifs/9751f02d-d1df-4265-a7d6-b19761=
b21834@linux.dev/T/#mf14808c144448b715f711ce5f0477a071f08eaf6
> > Fixes: 6be09580df5c ("cifs: Make smb1's SendReceive() wrap cifs_send_re=
cv()")
> > Reported-by: Paulo Alcantara <pc@manguebit.org>
> > Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Reviewed-by: David Howells <dhowells@redhat.com>
>


--=20
Thanks,

Steve
