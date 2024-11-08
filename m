Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB9E1D0F4F
	for <linux-cifs@vger.kernel.org>; Fri,  8 Nov 2024 22:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731105558; cv=none; b=QqA/ik3bpAmfbQHHo7uY8hCcyDDBRmPalyw08LwNv1+I23DFwv/ibW97SyvowTMIUPcihQJ7c5QEmaNOt8Zg16C6dFcV/1/eWLhhLriYoNLDLAjIXUjAd8Avh+hBvXHRhUviEeCdAuiYCR0L7iI3tOxiwR7BGPNq1oPI23dLK/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731105558; c=relaxed/simple;
	bh=DABa36Ib1Zbu9WXg2N540pvl1xvrg7W3Xj6llmAfhyE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P6jWEHdeWh/ZqLfL2bwTwhDbdEB5MHT+KI+e6xf4IUTrd5gMZSpENNvZ+W/4XdiHkuU6XUU+LkO+KzEE9+DBEjVLIBD1yp9NFi5hCSK25fh1AyI+a32TmU2vHTH/kahlwHGV7mdVjGdHqciOn55M7fwqxKRT2r2iGiy+F2+hnT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RMBpfvPz; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RMBpfvPz"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539ebb5a20aso3115270e87.2
        for <linux-cifs@vger.kernel.org>; Fri, 08 Nov 2024 14:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731105555; x=1731710355; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdRIVTqRIZ7H/hWGZkp1Rs0AGSd81T7pZoiKswMip9U=;
        b=RMBpfvPzkUB4J4TvpAT6vQgaVABhbvtFMT8LSUur5nYF0FcZ/5TTxHTgeJ9bx5D+Hk
         1FIVRDSLcEYymCmMzvxOgg/fdeT7DAk41Ak8u2iffISuzlwYiLt8CoYljgqe4CMmIZal
         d5GZilGMULFWXiFIKFgioHaoYQgXlanBax+Tvv+/0g0dKmmpVcSTxFNGs3tHOV0IrzRX
         6+U+fCrwKLqrOuC/etZ8kn51AlF/M8gllX4egSRFi7BBVozZxjx84Ja8lb7kOnEeZxl4
         OAM6Krk0lP+l8DKuIkPNQOPL2K52ASVHQGgn3RuCV1+IbUnWqkD+NcvdPYU3h661PhFg
         SqlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731105555; x=1731710355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kdRIVTqRIZ7H/hWGZkp1Rs0AGSd81T7pZoiKswMip9U=;
        b=wZGRhZ/KlpClTAOYgt1QnfQPNWJp0n0p3scxv7E7qaERpux/VQ3YuGFy4AyvWajALq
         S3aoKLxsZndZBlfIMBdWc44CBV4ScYkZtpEFJFUbTZmQdZWODl9Hl0UT14uvySNpx3ff
         KbHBTrocg0Oe2UYR6pIlUrznL5Kv8o03m8i3GD85CrJs3wipMpv65EgcNMiDc4KFYKSB
         Ar+udnn1v3URPK76W9KXwOwM+bVEO+9SUTrgbOfSIX4wpRlMnPoBaqsTBdAIUbKRu319
         YrrC/mDrUTnM3Vt0C3FoWv8D442XF9IvkFuix51YZqs7tLQU7RYf3LpiMxWUU3tWGoaK
         K1CA==
X-Gm-Message-State: AOJu0YxNDOc89F3NZj2mxwLzCH3RSBq4UVAfMLwcNSiOhVr40acmTVWP
	597hwq2Hhr98Guea3AwJaA5TCrpV9JA0tngyC3kt7lq6aqV9IqIh9EWAVw+Wb8HSKhlHR2UN2lZ
	9zGsmvMQe1JADyhCpQPclH0aIUac=
X-Google-Smtp-Source: AGHT+IEnCBUX20L+AGL0ZdvMzMKDo+iOIvAWdxywEnGiL3UK6lIOPmCE7Vgs+YSU2Rjk6n/X1szEzeM68yz3GAwbsxQ=
X-Received: by 2002:a05:6512:3b9b:b0:534:5453:ecda with SMTP id
 2adb3069b0e04-53d862d3f93mr2578940e87.23.1731105554960; Fri, 08 Nov 2024
 14:39:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241108222906.3257172-1-paul@darkrain42.org>
In-Reply-To: <20241108222906.3257172-1-paul@darkrain42.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 8 Nov 2024 16:39:03 -0600
Message-ID: <CAH2r5muDRhy2gsy7kz9GHC3maGxcxAcam8B3pgCmnS8xcEQX1w@mail.gmail.com>
Subject: Re: [PATCH 0/5] SMB cached directory fixes around reconnection/unmounting
To: Paul Aurich <paul@darkrain42.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The perf improvement allowing caching of directories (helping "ls"
then "ls" again for same dir) not just the perf improvement with "ls
"then "stat" could be very important.

Did this series also address Ralph's point about missing requesting
"H" (handle caching) flag when requesting directory leases from the
server?

On Fri, Nov 8, 2024 at 4:35=E2=80=AFPM Paul Aurich <paul@darkrain42.org> wr=
ote:
>
> The SMB client cached directory functionality has a few problems around
> flaky/lost server connections, which manifest as a pair of BUGs when
> eventually unmounting the server connection:
>
>     [18645.013550] BUG: Dentry ffff888140590ba0{i=3D1000000000080,n=3D/} =
 still in use (2) [unmount of cifs cifs]
>     [18645.789274] VFS: Busy inodes after unmount of cifs (cifs)
>
> Based on bisection, these issues started with the lease directory cache
> handling introduced in commit ebe98f1447bb ("cifs: enable caching of
> directories for which a lease is held"), and go away if I mount with
> 'nohandlecache'.  I started seeing these on Debian Bookworm stable kernel
> (v6.1.x), but the issues persist even in current git versions.  I think t=
he
> situation was improved (occurrence frequency went down) with
> commit 5c86919455c1 ("smb: client: fix use-after-free in
> smb2_query_info_compound()").
>
>
> I'm able to reproduce the "Dentry still in use" errors by connecting to a=
n
> actively-used SMB share (the server organically generates lease breaks) a=
nd
> leaving these running for 'a while':
>
> - while true; do cd ~; sleep 1; for i in {1..3}; do cd /mnt/test/subdir; =
echo $PWD; sleep 1; cd ..; echo $PWD; sleep 1; done; echo ...; done
> - while true; do iptables -F OUTPUT; mount -t cifs -a; for _ in {0..2}; d=
o ls /mnt/test/subdir/ | wc -l; done; iptables -I OUTPUT -p tcp --dport 445=
 -j DROP; sleep 10; echo "unmounting"; umount -l -t cifs -a; echo "done unm=
ounting"; sleep 20; echo "recovering"; iptables -F OUTPUT; sleep 10; done
>
> ('a while' is anywhere from 10 minutes to overnight. Also, it's not the
> cleanest reproducer, but I stopped iterating once I had something that wa=
s
> even remotely reliable for me...)
>
> This series attempts to fix these, as well as a use-after-free that could
> occur because open_cached_dir() explicitly frees the cached_fid, rather t=
han
> relying on reference counting.
>
>
> The last patch in this series (smb: During umount, flush any pending leas=
e
> breaks for cached dirs) is a work-in-progress, and should not be taken as=
-is.
> The issue there:
>
> Unmounting an SMB share (cifs_kill_sb) can race with a queued lease break=
 from
> the server for a cached directory.  When this happens, the cfid is remove=
d
> from the linked list, so close_all_cached_dirs() cannot drop the dentry. =
 If
> cifs_kill_sb continues on before the queued work puts the dentry, we trig=
ger
> the "Dentry still in use" BUG splat.  Flushing the cifsiod_wq seems to he=
lp
> this, but some thoughts:
>
> 1. cifsiod_wq is a global workqueue, rather than per-mount.  Flushing the
>    entire workqueue is potentially doing more work that necessary.  Shoul=
d
>    there be a workqueue that's more appropriately scoped?
> 2. With an unresponsive server, this causes umount (even umount -l) to ha=
ng
>    (waiting for SMB2_close calls), and when I test with backports on a 6.=
1
>    kernel, appears to cause a deadlock between kill_sb and some cifs
>    reconnection code calling iterate_supers_type.  (Pretty sure the deadl=
ock
>    was addressed by changes to fs/super.c, so not really an SMB problem, =
but
>    just an indication that flush_waitqueue isn't the right solution).
> 3. Should cached_dir_lease_break() drop the dentry before queueing work
>    (and if so, is it OK to do this under the spinlock, or should the spin=
lock
>    be dropped first)?
> 4. Related to #3 -- shouldn't close_all_cached_dirs() be holding the spin=
lock
>    while looping?
>
>
> Lastly, patches 2, 3, and 5 (in its final form) are beneficial going back=
 to
> v6.1 for stable, but it's not a clean backport because some other importa=
nt
> fixes (commit 5c86919455c1 ("smb: client: fix use-after-free in
> smb2_query_info_compound()") weren't picked up.
>
> Paul Aurich (5):
>   smb: cached directories can be more than root file handle
>   smb: Don't leak cfid when reconnect races with open_cached_dir
>   smb: prevent use-after-free due to open_cached_dir error paths
>   smb: No need to wait for work when cleaning up cached directories
>   smb: During umount, flush any pending lease breaks for cached dirs
>
>  fs/smb/client/cached_dir.c | 106 ++++++++++++++++---------------------
>  1 file changed, 47 insertions(+), 59 deletions(-)
>
> --
> 2.45.2
>
>


--=20
Thanks,

Steve
