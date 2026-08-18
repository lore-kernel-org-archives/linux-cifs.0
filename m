Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653A6331ED4
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787039013; cv=none; b=fPLGQZLqhg5kuRMuv3UnZ7meZNq3n8r2uCDUf9C5cXBcxlM7YbTQf9cWFAEnGzTjAEd+dbuyRQyBU9wOVzYJAAYIskJ2f2r7g8nU9VG0d4DrSrDTYFSOjyQgZXCdEwQk5yAFwoAMlr9ZgKJbvmFg2yiVjKp1mcAADV/oY3k+5us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787039013; c=relaxed/simple;
	bh=FHHLAtsZQvQ2KzX9kTvT/uf50awMn7hIw+dD87XF+g4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D01YAmU79O/3RCYEroXbsyhkPhHdXyx88mQRUBAtQT8hHqrxfwK0x+m9VT1y3zjCQIBUKN4T5+yX6ypbt/6qmyoIwlEGodGcGw+xVsdFPSZnAIx2SGdPC2+oMs2v2lMl6puRhKBOncK5s94dRrox1ozPoHbpmdaXfVuU/GUPZJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gfBqhxot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gfBqhxot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E30B1F00A3D
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787039012;
	bh=FHHLAtsZQvQ2KzX9kTvT/uf50awMn7hIw+dD87XF+g4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gfBqhxot6FSZlnIVzLbuC6JuLl7TyFyhK5KFu8uSxGB2bW784JTIfQf64npjlZsK9
	 ux/Ou5qzFfuz/hGGDmPZsPUwdKS1k4Q8S2sahaj8Oj6Maw+aLrj67t9NYKmgWlY0Qv
	 KK/zyLoSULmnK5o7iSyg4NjuTAUAjz7OEVTl6McYUulZUFyrQIyCQ879G3dkHiPCxJ
	 LF2elOWVOcOnhnpWWXGI9ncGyM2cqwCmQAnzl6ybQAdTtfIdPPOIzRZIE9uGBaNKFi
	 ED5h39ZWIUPVzWf4JJU9KeuS2kj66+1ZU2Arw9BpWUwtIU7rmiVf6t5VuEPLP6pmvH
	 udjbRsPAxESAw==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6a0a4aa99bdso6188409a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:43:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro2gNiGmKvzBKVZvR8dBbZ1klNQ6IggslUxPruGH6M+o141/bCRxnePHsDpIdxdhSpurw2XQ1HCRQmq@vger.kernel.org
X-Gm-Message-State: AOJu0YysKSPOQ6qlal3ylFcFc3IFL2SDg9NTu+oAcifxBznvK1VAhc4V
	+NbfFFh7v33fvqiE8OH16McDdj+h4vPiP5I8ll/T6lzjGCYwXBsPIIXXdmkmf0cqaeZRK+9Yx9p
	f+AsHLGmhzppnSxK4C3xV27cdbJkAryo=
X-Received: by 2002:a05:6402:11d1:b0:6a3:72bc:7bc6 with SMTP id
 4fb4d7f45d1cf-6a38a98f490mr14742334a12.17.1787039010790; Tue, 18 Aug 2026
 00:43:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818030635.3007590-1-wozizhi@huaweicloud.com>
In-Reply-To: <20260818030635.3007590-1-wozizhi@huaweicloud.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 16:43:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8R5W+-NVp0Mkqr2XcYoq70jKwvsefF9Bviu00xWh140w@mail.gmail.com>
X-Gm-Features: AcwNN1V__hXTSp5jWvAJRkMu-V8VnMILsQWvRn9_RMdu41BYZaOYSnvHFG9OSqU
Message-ID: <CAKYAXd8R5W+-NVp0Mkqr2XcYoq70jKwvsefF9Bviu00xWh140w@mail.gmail.com>
Subject: Re: [PATCH] Revert "cifs: remove all cifs files before kill super"
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	wangzhaolong@fygo.io, mszjaas@qq.com, wozizhi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 12:13=E2=80=AFPM Zizhi Wo <wozizhi@huaweicloud.com>=
 wrote:
>
> From: Zizhi Wo <wozizhi@huawei.com>
>
> This reverts commit 6d9a4aaaa8b2612b5ef9d581e2f286a458b71ee1.
>
> First, directly flushing fileinfo_put_wq in that commit cannot guarantee
> that all in-flight I/O has run its cleanup_work on system_dfl_wq and
> subsequently called queue_work(fileinfo_put_wq, ...). Flushing only the
> latter workqueue may therefore miss puts that have not yet been queued, s=
o
> the fix is not reliable in the first place. Moreover, this fix flushes
> inside cifs_umount(), which means the busy-dentry warning can still be
> triggered when umount_check() is called inside kill_anon_super(), because
> kill_anon_super() is executed before cifs_umount().
>
> Second, commit 75f5c412fa86 ("smb: client: fix busy dentry warning on
> unmount after DIO") already drains both serverclose_wq and fileinfo_put_w=
q
> in cifs_kill_sb(), before kill_anon_super(). By adding a per-superblock
> outstanding-rreq counter, it guarantees that all cleanup_work for this sb
> have run, and thus all relevant cfile puts are queued on fileinfo_put_wq
> or serverclose_wq.
>
> Third, no path between those drains and cifs_umount() can queue new work
> onto either workqueue. In the "cifs_sb->root =3D=3D NULL" path there are =
no
> file-related workers either, so that case is safe as well.
>
> Therefore the busy-dentry and null-ptr-deref problems cannot arise, and
> the flush added by commit 6d9a4aaaa8b2 ("cifs: remove all cifs files befo=
re
> kill super") is redundant and can be removed.
>
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Will apply it to #for-next.
Thanks!
