Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C857C23C8C5
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 11:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761306421; cv=none; b=bGZ03cMz0WR7uQszV4WXY7J0cxawh7gGk/0kzCWeYDgsldvXtCyLBbHO0ti49IM32Hm8nEIH6RSZaelmahsirFGF/UmzGmE+X4i93d2g3gG0ZwO7H2Ax94FPdJM7FXhfAj2ZFMOvdndxQDf5bx4n2fxQnG5L38D3ajv5m8WHY+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761306421; c=relaxed/simple;
	bh=MmeONkxXlPsJgIEMCCJC4aSIZe2aYBbzAd8U2kia6LE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nmx6fGKzuvlzPU4/5QkX0fRv1YUqTkkVrLZaaybL/BbtGWtx9E4Zbl+u2nV7G3hEQALFhNIT2IohuTlBoGHALJK9Gal7i63Tvj5PFwJzIjV6dWsnF4w1ukLb7foS9U1+P7WMMqpERGesc9yWBiu5o8uprEfjGyM5ID8IuB6wObk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d9mVv1mV; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d9mVv1mV"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-63e18829aa7so2807771a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 04:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761306418; x=1761911218; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NRP35b1b+UBMkRRLzY7iPXJLpOFH1Wz8LQbrADhc838=;
        b=d9mVv1mVEle3bs/IUdFbOs7+hNsPaUsZTL+5Pw6LQ0DaN5IKdMIUib6nSZ2c3eGqRb
         QYapwVn3iYF5/pVvcsYl9Virj+nyp+5HIelRyKviJAWGt6+XSaew0P1oeWYehqiMa1sg
         b1bQcjW5R83XhLQkP2AIZDWxBOrKjtUIBaM/fhn8jTl9pUvpSS2sSQ1OvP+6LBUXnPnQ
         6Yu5XJrCLjvipkZHAdo4Quen8x1DemWeIw1xyfGgXE96OJ7pBcpfjvHkoVYMTlt7hb4d
         VVtALUfQRTpFgJ4+wnOBbvN7hTwA+jCGDxF8EMXpwU6JOWBKH8zi2DeYa6Sxfw7etL8r
         1w+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761306418; x=1761911218;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NRP35b1b+UBMkRRLzY7iPXJLpOFH1Wz8LQbrADhc838=;
        b=BSPcYCSeG/snOI5PHs/4I9jWOgrO7qXNKjTkbocZvixuqsnwglpyewS+/CjNsUsE1c
         iwkqhujhQKvAllsgRORSHV9N/6e9n97nQJCCLXTUdjo2q9Jfqj03doVLwdDX8kT5fCib
         RbVWeezvSGQcUzPnzCl5x0XWxrF7f5WEDGMduCOdYOMX7om3i6JQran1xuGtOgVwCLsW
         8dTr0v/Wpy6E0yVdcpE3R4RSSvXba4dys5vhGg3/Dw7PZIgAJI7EFzT7CSopQ5QCPPMc
         ofRSwXf1v2q+KMk/Riu6RasXoPLn4uGcIwiWqN1zZicZ23Dvx1OPr3wSk3BPfiUh0J1m
         vy1A==
X-Forwarded-Encrypted: i=1; AJvYcCVnjK1J/3FGqaFjuF/KMwR5VOgbp0L59QEt1vYYWwVMcCYxXq18+N7RCTH9RCyofxWQpQyt7A5+T4iJ@vger.kernel.org
X-Gm-Message-State: AOJu0YxKToMbJ2nIRkIIP4COUFMn9UHaGpgZBNONS+iOernCXQ7pqGPY
	kLebFqr99PW/x5CBxQQd8i0rxqlzITKEOs0NVZF5Q99CR0q8Tk8i9h7BvKOBkReB9HwHiBhyoxP
	iAAg9A9r7VJV/LxKdiT+hKMsBMDIuvD8=
X-Gm-Gg: ASbGncut/LYRl8rYni41v3yeg6VNS0QKmQdx7/zeyE/vDnSudqFf7e8FLdQwmx6oqc/
	GE4npbdA+4rIYPKAqIOk5uCIT+bqTvUTR+qQBK9YYEEKc3IXuLcts8cmTNh5Nr6ChQp8Kz3U5M2
	e8DC8gYjyYQGi/NvYn/9f/+ssf3udKZtS+00O1K+pre3+8cpTCNI+ZdWWvawY/x4ewpAlSwpvS+
	A6tKLd+Y1a4gzcvZfdUyIAL2Mct6RNNn2/zqufE98T5gbIUpM3EpGFcDcQ=
X-Google-Smtp-Source: AGHT+IGA8I6y0Cw7blQgfDxeUz1mWG0BjY+v+2yie+nx8LjBnbFnttBDYInVj6mcfQc3cVXMxe07XE8mHTPAwQFHCqs=
X-Received: by 2002:a05:6402:1ecd:b0:63c:6d2d:8dd0 with SMTP id
 4fb4d7f45d1cf-63c6d2d8fcemr20191554a12.22.1761306417816; Fri, 24 Oct 2025
 04:46:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251022234321.279422-1-pc@manguebit.org> <1837802.1761204083@warthog.procyon.org.uk>
In-Reply-To: <1837802.1761204083@warthog.procyon.org.uk>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 24 Oct 2025 17:16:46 +0530
X-Gm-Features: AS18NWBBJlA7zXHYqEsJ_39hlS_6yFu5lUgA4qafLcN47TpOoB2SV5jEtE-M5P8
Message-ID: <CANT5p=oXTjGTfDffYwvHkZ5g32C0QMzitthbBdk0R5XJaM=Gzg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix cifs_close_deferred_file_under_dentry()
To: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>, smfrench@gmail.com, Anoop C S <anoopcs@samba.org>, 
	Xiaoli Feng <xifeng@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 12:58=E2=80=AFPM David Howells <dhowells@redhat.com=
> wrote:
>
> Paulo Alcantara <pc@manguebit.org> wrote:
>
> > The dentry passed in cifs_close_deferred_file_under_dentry() could
> > have been unhashed from its parents hash list and then looked up
> > again, so matching @cfile->dentry with @dentry would no longer work.
> > This would then fail to close the deferred file prior to renaming or
> > unlinking it.
> >
> > Fix this by matching filenames instead of dentry pointers.
> >
> > This problem can be reproduced with LTP rename14 testcase:
> >
> >   rename14 0 TINFO : Using /mnt/1/ltp-a5w7It6Osi/LTP_renffzJE1 as
> >   tmpdir (unknown filesystem)
> >   rename14    1  TPASS  :  Test Passed
> >   rename14 0 TWARN : tst_tmpdir.c:347: tst_rmdir:
> >   rmobj(/mnt/1/ltp-a5w7It6Osi/LTP_renffzJE1) failed:
> >   unlink(/mnt/1/ltp-a5w7It6Osi/LTP_renffzJE1/.__smb0021) failed;
> >   errno=3D2: ENOENT
> >   <<<execution_status>>>
> >   initiation_status=3D"ok"
> >   duration=3D5 termination_type=3Dexited termination_id=3D4 corefile=3D=
no
> >   cutime=3D0 cstime=3D587
> >   <<<test_end>>>
> >   INFO: ltp-pan reported some tests FAIL
> >   LTP Version: 20250930-14-g9bb94efa3
> >          ##############################################################=
#
> >               Done executing testcases.
> >               LTP Version:  20250930-14-g9bb94efa3
> >          ##############################################################=
#
> >   -------------------------------------------
> >   INFO: runltp script is deprecated, try kirk
> >   https://github.com/linux-test-project/kirk
> >   -------------------------------------------
> >   rm: cannot remove '/mnt/1/ltp-a5w7It6Osi/LTP_renffzJE1': Directory no=
t empty
> >
> > Reported-by: Anoop C S <anoopcs@samba.org>
> > Fixes: 93ed9a295130 ("smb: client: fix filename matching of deferred fi=
les")
> > Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Xiaoli Feng <xifeng@redhat.com>
> > Cc: linux-cifs@vger.kernel.org
>
> Reviewed-by: David Howells <dhowells@redhat.com>
>
>

Hi Paulo,

AFAICT this would just be a problem only for __cifs_unlink as it drops
the dentry before the call to cifs_close_deferred_file_under_dentry.
Why not just move the call to cifs_close_deferred_file_under_dentry to
before where the dentry is dropped?

--=20
Regards,
Shyam
