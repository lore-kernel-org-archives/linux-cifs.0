Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1AAE571
	for <linux-cifs@vger.kernel.org>; Tue, 19 Nov 2024 00:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731977738; cv=none; b=WJbZFN3uJ2llrdamEudlJLluHoNbZ0zse5GxdxhbVAfJFPRKX/VsSu62+L2tUFnH9vgXl0BbsMsaLOilr0w3JxgBKVKMS7TdYQuJ+M7FVbHsLKNFZEyRkWq0sTvh2DheCUvoiqLse8tb2XuEcnAZ70ouc6bdN4D/ca/q/YpxVH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731977738; c=relaxed/simple;
	bh=1R8w/76/nE5A7V5RW4j4p8/AHjZlXpXPcsJ9KDFBiZs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fGvMiESBlO5ZwoyoT3h0k5Sfw1PttNRhtP9ofSBvdPJSX2N7o4ZFTB/q3cty+MPaeDkMJ3McAmF3YJBrXYaHKWUcgkzSzEIDKzggM3ZXk/4jyrnm8fcxsVbWvYqhCVqfyykN6/9AY3iCKjW1azmyi3SuPGqXwzHuVDsoW9UrOIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WV9uyIvY; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WV9uyIvY"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-539ee1acb86so2487479e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 16:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731977735; x=1732582535; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOyKqhcylriWH9dIhOAKgPB/qt/75/qvZBqeLYt7tg8=;
        b=WV9uyIvYXSq0OjLfkTdBS9tvkKiuNx1h/buHsXCHPC9Hdcoyx32aILFUOfk6azJPnT
         Coy6btrLrljMHASvEaFKxvxr74n6fw1d70H/ZD8gCjlcw0QUb1wxHExPW5YkYJMB/g2M
         PzlYwwJ5ASWmBGp62ElWTDDZm8eZnFIRW/FuPXaI7t2L8OdrTzkYjT83p1jotdcAaUNr
         nholnktXIQouJJtbhfhCWJvEhqonUZhQtvExSIS3R9rbFhLRIBEREvmDvmmiyjbElLCr
         U7V/6RIz5Xp35QBaOhK6XHz53jYgSGkRApQ7mwq4hh5qVjFvyQo61qr+bSzcMGHm0Ggq
         kZig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731977735; x=1732582535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nOyKqhcylriWH9dIhOAKgPB/qt/75/qvZBqeLYt7tg8=;
        b=bQjuVOUhhOA7KJ63K+Ro9igGaWs3cLeZtTFEesqNx0ZPXE4L+XIlidIK8Kh0WWVYEx
         mmnTe9x+Kv6ph9TKDSMylBmieqFP/FMNV51tvM7g3PL3BU5dy0so8kMGbv2nJSbDw+fQ
         tyveZNPjAIouZJSkhP7dpX/aRxngajRA2VEJj5jlniwJLhw91InAHqdUfttqIbSdvtg7
         5J8h8GozknfYtDM+YNG/8nCYYRwEkwxpC0UsY+ZJ6R24et725vD5++myUgqlolX2kKTo
         32dtwiiAWHpD+YfaEnFXLqfjK4aVZFqE78QCZ0Q0rJOozmWBLc6dHF4uQJEAhMG54YwX
         SnWg==
X-Gm-Message-State: AOJu0YyLkSCDiMdC2kytJZUdoJo0V6yT677RptbwdMXxaG1IP4dEyCQB
	hmYviaMynRGCEpuSo2BW2tHThrpDLncbw57VOYJJCscDgEF1UygQzhzglkdnMBHPTy9QSNRNNB6
	6TrOV9J31mKeATHjUCpUZRW78E5ha6rQ1
X-Google-Smtp-Source: AGHT+IEsMIy6uL1RqonEA9gxv+pJcuzKpqvxwQPxWB6/QttZ7mJIvfzH65o0nMzgjk1elHbqNtBQwamezbKRncraFqA=
X-Received: by 2002:a05:6512:3e0c:b0:53b:1fe4:3fb9 with SMTP id
 2adb3069b0e04-53dab3b09cdmr6061241e87.49.1731977734465; Mon, 18 Nov 2024
 16:55:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118215028.1066662-1-paul@darkrain42.org>
In-Reply-To: <20241118215028.1066662-1-paul@darkrain42.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 18 Nov 2024 18:55:23 -0600
Message-ID: <CAH2r5msFodKYc5EMtvQF-hC94qH=GrMhSixmwB7RbkGP-Q48UQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] SMB cached directory fixes around reconnection/unmounting
To: Paul Aurich <paul@darkrain42.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks like you dropped the patch:
"smb: No need to wait for work when cleaning up cached directories"

Otherwise for the four remaining patches, looks like the first patch
stayed the same (trivial comment change).

Can you remind me which of these three changed:

  smb: Don't leak cfid when reconnect races with open_cached_dir
  smb: prevent use-after-free due to open_cached_dir error paths
  smb: During unmount, ensure all cached dir instances drop their dentry

On Mon, Nov 18, 2024 at 3:53=E2=80=AFPM Paul Aurich <paul@darkrain42.org> w=
rote:
>
> v2:
> - Added locking in closed_all_cached_dirs()
> - Replaced use of the cifsiod_wq with a new workqueue used for dropping c=
ached
>   dir dentries, and split out the "drop dentry" work from "potential
>   SMB2_close + cleanup" work so that close_all_cached_dirs() doesn't bloc=
k on
>   server traffic, but can ensure all "drop dentry" work has run.
> - Repurposed the (essentially unused) cfid->fid_lock to protect cfid->den=
try
>
>
> The SMB client cached directory functionality can either leak a cfid if
> open_cached_dir() races with a reconnect, or can have races between the
> unmount process and cached dir cleanup/lease breaks that all lead to
> a cached_dir instance not dropping its dentry ref in close_all_cached_dir=
s().
> These all manifest as a pair of BUGs when unmounting:
>
>     [18645.013550] BUG: Dentry ffff888140590ba0{i=3D1000000000080,n=3D/} =
 still in use (2) [unmount of cifs cifs]
>     [18645.789274] VFS: Busy inodes after unmount of cifs (cifs)
>
> These issues started with the lease directory cache handling introduced i=
n
> commit ebe98f1447bb ("cifs: enable caching of directories for which a lea=
se is
> held"), and go away if I mount with 'nohandlecache'.
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
> Paul Aurich (4):
>   smb: cached directories can be more than root file handle
>   smb: Don't leak cfid when reconnect races with open_cached_dir
>   smb: prevent use-after-free due to open_cached_dir error paths
>   smb: During unmount, ensure all cached dir instances drop their dentry
>
>  fs/smb/client/cached_dir.c | 228 +++++++++++++++++++++++++------------
>  fs/smb/client/cached_dir.h |   6 +-
>  fs/smb/client/cifsfs.c     |  14 ++-
>  fs/smb/client/cifsglob.h   |   3 +-
>  fs/smb/client/inode.c      |   3 -
>  fs/smb/client/trace.h      |   3 +
>  6 files changed, 179 insertions(+), 78 deletions(-)
>
> --
> 2.45.2
>
>


--=20
Thanks,

Steve
