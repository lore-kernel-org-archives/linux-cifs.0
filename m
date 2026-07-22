Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEA6238171
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 01:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784683718; cv=pass; b=NsoIncGSX6txLqg4Dz7fy/3VDhTM4wJpXX3MK+IYtdY6D0RdGRhQ07sd6a52aen+WDi2cuWDNoPBuIBSOdtCRFJflMzY7yaQ+M9S80EGwG6Kp2Gf2X3QFlWThDb+5GgVLF07xQwKpFqUlr3DMPoB+ND+SDxtpHUHAX3N2AW44/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784683718; c=relaxed/simple;
	bh=P7X0nNOqNHJWssqEbwn7YD7lUemRgxFbvO7ehXaG4K8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mnecR7l9wUszQc60/ZgQoaHSAFoqsJgF9c0whU1LnYdlEQmYDXbN5zL/8tLgcgW1h+CZHM00xbEKHcWtxhWIYw4jyqso8yfg55g9BvaI25HxG2I/jpid4ypEv5j/H+GXOpHTsBvuHS+9pBBr+gmgIETOVkacaRNHMqUmKn97YbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GaOyGWk2; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GaOyGWk2"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-902e4af2d9dso59514436d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 18:28:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784683715; cv=none;
        d=google.com; s=arc-20260327;
        b=FS7OOvCoGV096mVzL25bbbcPtkqGABRBzPPy5P4rfdoYFaso7UChU7TFzXWdBKsS+a
         KkBbZUKMXE9scRJ+BLiRtzAiGRVx/XXEVfEl2V5e8EwBhtylMFGhhO3SB/hnHAzaBX3M
         GcSIX/A4RJPb6kr6j84x3rUb+0lY1klDyuZeZEDdxaeW6XZEYprAOXOEfd8WFMYVLUhO
         oPkqhU8+B4lgEb9LsQLffo1iJ51P2VKmPH0RK9InQ+6N6ZrxajfZIZRccBMHqVBO3Nz6
         2OxJpFRjKNnvrEb6rjewKz3UbrEqJkyYUYN6GxWPLHeHioiSDZkRYW3bT5+DvttY6Uta
         tHjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cc+H7x15d6b7z4zTF7m3gupjIX7TzfHxlD6KLbrDcC8=;
        fh=X/tRp+EVM9Zkpblyc+5O5SDSK1U3jjktf5a89XnPo9w=;
        b=BCZ9uozuQP9haubkljfeF3CoSHBgGg/KdmapwXqHhj0s3mMCIeqML0kKvvhKVuFP0m
         KDpnU9CzWDALiKyMjzxU8JAg+sHzzFPymiso2hmJclDqePj+bUx4cLP/O6tDVdfTjUjZ
         X1ymTQeInC4qqcWqoCUWIzB/1pVlHhxmqvXHuJ7vVxLp3BGYHZVyxJwhaLwVjnTlVPM9
         sQb5Al04czGaXhCgF1k06+6pT1EHkHwc7onNZEUoGN6SlbVH8/ttO53RnifwWwEGUTyG
         QiSitbYC+b69fNxmLXC2fAbKOmcPtQQynG54mdUJRRcBvjX8DPY/V1P2Nzc/e+hbsVsa
         2gUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784683715; x=1785288515; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cc+H7x15d6b7z4zTF7m3gupjIX7TzfHxlD6KLbrDcC8=;
        b=GaOyGWk2gUOX5AxGF4AWrl9fuprR3xKJFeIpH1w1nsJK/7g3WoePSXoXTH6N8PrOLF
         GY2CxjxbvblhMf4g8/m4WYK9uXVqA01Q33yJZjnBy5tP3dyJ8T/roQkX/bz4N1JlmIM5
         9GWeJK5k9YAuNiN4yQ4Af3/fzuwIALtpyQJsJNMtjintO1ZYYugtpxM5BQVf+zlYIk6z
         t/KUhaLNxVuVybD5MDeWsF0t98c4kpYbEnk9SeVgSPhhH2b+qrcAnIFGbM/BDhyJl9Ch
         VInu9iYUCeyYnY+30tfWs+ZqsgfbvUQxTwAT4PToPVDZwM4I86AW8gBP0vbStVeCObk2
         w3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784683715; x=1785288515;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cc+H7x15d6b7z4zTF7m3gupjIX7TzfHxlD6KLbrDcC8=;
        b=Mg+TW4yDknar99X55oG4X6toacsWSiDD/7lzmWaVYgjTQYJ1pOeIU8UnTckFHYqPKU
         oju06i7NrH0r7Z9+CpXnGVtcOGbe5EnWCY+/382RQy890+vcWzydwm8zkHAqp4TFkz1H
         dGX29s1OVGowcpCJgaD/dfdNDA6Hk99bz9CAhLwW71/+Snih4AY3NdX95AwbuUcSb8so
         YJORcLlNlCvCVxNDoT16MulFJtpMI9b9t8cLCs1qf65sDmZ7QnVQRfyTlLCEhITnoH9u
         jBvMYdXtCQ2+YqAlOuy9q/qXJvq49bqOgX225m/ucJI8ce0fK2cvCzGnk6v9i+p/N6yM
         q2dw==
X-Gm-Message-State: AOJu0Yx3kWrUIUyCCUqSeHNSvnJFE9wLBr+KQKAeu3ntQxt2GkEK3QQx
	+/BEnnxboKot2d9nAeaJC8z3EkWh0Yr4i3eOG4UiUDBO3YBdYkeVScAEzbPzNanx8C3Yq4nxaBu
	seo3n0lqetP123aCav/rRldF7BUZVIqg=
X-Gm-Gg: AR+sD11cyLZnwlAC162r6LBuB22N7Bd4gth+YGlFDQi8NtXsIjSKWwgkHNOf4go4msn
	JFlbiiK2Gk844snvyEEzDO3UK/HVeBAhwQzIuy2DoFgHg5cqrKTJDfqhluEynuqekBd3veutuUf
	xTgEiI2TKM3sZlrbDZEZlbz+vIACRHhmmwBbNacv26cyTIly9TnKiRRSej/jMCjCr8pSy7mSkvC
	aDppBXFbzvLvWoG7cUOgHCCKLNmqF5LOTOL70fT4j+Q7s2zXNAsIxey7//psEoFXArMKlJL348O
	uFQuz5XoRXBP9FIxiqAN87e7BOCeoC8TLTZWjmL5NG/nWGVxsFQgXvHvA7k+vZntTWmRTIzeR7+
	zFT2uPESUofKchAT4/S6nvb9bCBBmld7sTOUM21QgaLbObbJHI6bozZRxLCJPXHCx7Qbbounpt1
	Jt
X-Received: by 2002:ad4:5c8e:0:b0:904:2439:cc73 with SMTP id
 6a1803df08f44-907b9c23fc3mr24224366d6.30.1784683715591; Tue, 21 Jul 2026
 18:28:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260721235552.1839780-1-sorenson@redhat.com>
In-Reply-To: <20260721235552.1839780-1-sorenson@redhat.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 21 Jul 2026 20:28:24 -0500
X-Gm-Features: AUfX_my-cg_NF3ISLOIudmPgU7LWv-Fe6j72gYPYcWIYTc3PtlRgpJo5acXHoB0
Message-ID: <CAH2r5murna29cwOYicOf-=-QPBDssgbwu8sYyogGTe_TS40d0g@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] cifs: fix readdir stale size bug and
 deferred-close reference leak
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending more reviews and test=
ing

On Tue, Jul 21, 2026 at 7:16=E2=80=AFPM Frank Sorenson <sorenson@redhat.com=
> wrote:
>
> This series fixes two bugs in the cifs/smb3 client: a race where
> readdir overwrites cached file sizes with stale server directory
> metadata, and a pre-existing reference leak in the deferred-close
> drain paths.
>
> Patch 1 fixes a bug where stat() returns the wrong file size after a
> write+close or rename against Windows Server.  Windows Server's directory
> enumeration metadata (EndOfFile) lags behind the actual file state
> immediately after a modification.  If a concurrent readdir() runs during
> that lag, it overwrites the correctly cached i_size with the stale server
> value; a subsequent stat() within the actimeo window then returns the
> wrong size.  Both the write+close and rename cases share the same root
> cause.  The bug does not reproduce against Samba or with actimeo=3D0.
>
> The fix adds cifsInodeInfo->time_last_write, stamped at writable close
> and at truncate.  is_size_safe_to_change() blocks readdir from updating
> i_size within acregmax jiffies of that timestamp.  When a size update is
> blocked and the server value differs from the cached one, the attribute
> cache is invalidated, forcing a fresh QUERY_INFO on the next stat().
> time_last_write is refreshed at the actual server close in
> smb2_deferred_work_close() and the cifs_close_deferred_file*() drain
> paths to ensure the protection window is anchored to the real close time
> when closetimeo > 0.
>
> Testing
> -------
> Reproduces against Windows Server 2022 with SMB 3.1.1 with multiple
> concurrent threads; does not reproduce against Samba or with actimeo=3D0.
> A reproducer exercising concurrent write+close+stat and rename+stat with
> concurrent readdir was run for 50,000+ iterations without hitting the bug=
.
>
> A reproducer is available at https://github.com/fsorenson/cifs_cache_race=
_repro/
>
>
> Patch 2 addresses a pre-existing reference leak in the deferred-close
> drain paths; when cancel_delayed_work() succeeds but the subsequent
> kmalloc_obj() for the processing list fails, the cancelled work's
> cifsFileInfo reference is silently dropped without calling
> _cifsFileInfo_put(), leaking the reference and the open server handle.
>
> The fix saves the affected cfile and calls _cifsFileInfo_put() after
> releasing the lock.
>
>
> v4: add memory barrier comments required by checkpatch; fix pre-existing
>     cifsFileInfo reference leak on kmalloc failure in deferred-close
>     drain paths (patch 2)
> v3: replace CIFS_INO_LOCK serialization approach with time_last_write
>     tracking; single patch covered both observed symptoms
> v2: fix malformed patch
>
> Frank Sorenson (2):
>   cifs: prevent readdir from changing file size due to stale directory me=
tadata
>   cifs: fix cifsFileInfo leak on kmalloc failure in deferred close drain =
paths
>
>  fs/smb/client/cifsfs.c   |  1 +
>  fs/smb/client/cifsglob.h |  1 +
>  fs/smb/client/file.c     | 69 ++++++++++++++++++++++++++++++++++++++++++=
+----
>  fs/smb/client/inode.c    |  6 ++++
>  fs/smb/client/misc.c     | 72 ++++++++++++++++++++++++++++++++++++++++++=
+------
>  5 files changed, 135 insertions(+), 14 deletions(-)
>
> --
> 2.55.0
>
>


--=20
Thanks,

Steve
