Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBC919D07E
	for <linux-cifs@vger.kernel.org>; Fri,  3 Apr 2026 22:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775254096; cv=pass; b=SkZmSSb2EPEIlWHbkK11imumNr6JfAlBhcFvdh84wNZEbFK5k1q8DPJL9M0Q+p47U9/2W6SoXsNg8Cj8PvV7NShq3kZhoRV8p+lBNZCCVNPCPla0EcbFEyYi498B7+MzhxdPWi0iv1BPPOVLgPP5ep3/X3dEHZXuIuh9/jMfhf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775254096; c=relaxed/simple;
	bh=DFlu6ze1Hq2q32DLSYjoeQQ7PjRKqnq4Gl84HZoXMpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n49B3Spn0JrbHr4B7+xt3pxWhan0NRPKJQOsyLmFKJZJ82tEfcqndKfBFlaXZDsix/+p0Bx+Q8GmdRnV46NTryM8dphXP+WmDgw70LpgpkfosUPhdpnMOXSVphSvrowOrippX/zIJl+PntrcgDDfGoPu2ZD6E5O83S4PKwXsHZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DjcLZVla; arc=pass smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DjcLZVla"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cb3bae8d3eso228236985a.1
        for <linux-cifs@vger.kernel.org>; Fri, 03 Apr 2026 15:08:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775254093; cv=none;
        d=google.com; s=arc-20240605;
        b=atkn3pQ89bQUb5XQow+ZARW7ruhgBHvWRiamkDr1+TQ6R9JMm8px7sMjhYBPVmJgnF
         Qw0vfMsI23FucyW9eTmqAB6fmg8dbON6zUpDmAEV1DWvrCGyq/Os3xUoDCb9NTXywals
         9Md73aALE9p1T/ih00bpA1q6suX8QDnj0nd1Un38uAP4w2EY0N5f5zEb3STRgT9RgB79
         Sh+2bFah2d1TWmuV41mkuoVqMH5MicRIxhFVSsoQhb7u/U5HiHQdpGh2gB9xdCWww6pN
         AY3FNnZRvxV+RuSS0qd494Z4Bjs+lahU03hVytap82wPvpHO8k2mSiakQZ8ONFN4DvtD
         dS4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AKROJXjJPhUjciddyxsVuQAbKsS9k11GMKuBGRCHbuY=;
        fh=STxk5tZTBJnKwDHzzHeBghlYU7Ns4pqEp83rU6Q9mbE=;
        b=eBEx3doF7iYWdZoVyCfpL945oHFrW7GqDbFx73K4jECx5OUF67y4ME4pOHlg5mC4RF
         c71NMjjlnCJUxx3s43i8R6CT6SDyiNwl7HTyENgxKtCPcpCRixgxtm/JJ+yQ5/Y2Go/+
         Jt3GPUFbSROSubOal1gw8vm56tsoS73lPVh6LgV5cyrCXjvWi0pAhfDEv6urXhgm9qH1
         /T9heUCXrpKR5LR2XkwdipeG1R9YaEp1BOwFoTj7Qs9HeIjdmOFfvnLdZqhVgFSKDuc9
         GE6FXPK50TUCptE3HKS2ci8aXIxzutXFohOJ6jahGSYcylKd6eu4sYuNJldFfOq/iQ5o
         uWCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775254093; x=1775858893; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AKROJXjJPhUjciddyxsVuQAbKsS9k11GMKuBGRCHbuY=;
        b=DjcLZVlaQq1EOyW11Bd2dn6L3CXB5HErFfuYF6UpHIQW5HddkS7b9btWbWdzXqkZpE
         wCdFICPXk2Pi99qVDwKVMPhj8CosveQPsyqzX/5JdWq3OR453SnovPhb46+tcksoCly4
         fADees3E5zpTb7NX/FR6n2ffkXSSmAyeh/UBw0e+iSXU9iqA/CN60i2SyMNQrg2eI+o7
         hq79fE8jHVh+pVdJtbfvdMbFUEK2rjuChNU3ucCBB2eU8rlq6tphLyQraBGx00obSFr9
         CYi0JdU2pNoePYXB3MPd/P54gBk6v+kfmO550L1vtVAB43W2BWKSzfXhT6zvDd0sECl+
         KuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775254093; x=1775858893;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AKROJXjJPhUjciddyxsVuQAbKsS9k11GMKuBGRCHbuY=;
        b=m3y/lucoK0fPM140MYf+O14F9V43XUoqBbHfdb1saWeA793zQMFihcoriXI+SAKu3M
         POLtIizJvvd5Hlp0dtHoILt7dUMis4GVVzv026p7fsyJlsR2IMnheY7sk4uaHazndr+k
         fLKZnPQdD2RytweJXAdoTOMKZ0D2L2x1w8jifS5GtN0QM8Q1bWrcbgJJqOse1cYAZi+5
         rw0nqISEeEHmQhsYjcIUMamJ82rUzBBGH5Mf6u4y0a2CnreXoCRDvSOPqXv4DK00Cixr
         3XgQK0ki+C6F6fYoaiL9+1vozYPMqdASLfzSUT3kb+xHOO5+grYZdOoELmYLSdRcby06
         CTuw==
X-Forwarded-Encrypted: i=1; AJvYcCUlck3YZfF3OHhGbVpjET9sPSaIS4HrCfe8cqp6ujfxlbzWYScYmbY4bfrMp6EGoKc6CJiriD/5Bi6x@vger.kernel.org
X-Gm-Message-State: AOJu0YwTVwa3g8LRWcHterIgPZz4uIGkz+utEkGzv3iEcZzCcaTX9RW/
	zg2w6oAFz8eVJV93BUT0WcMGrAhR8R1Dodtt5xa3378LGTlNoMXeq24bR/vnogqVZ6xV3i9ffq6
	jnqz49Ajv8dytof3rqk0n2uJ6epzpelfYzFGI
X-Gm-Gg: ATEYQzxJGTTT+CKxVQ7e0nbOSP6uVNiSdIw28OIVJDaB7y8P9S6+1Aawg6wOM/7tlnb
	IBb4hz0eOn8kH5sHpOtK3qF3XHEVQM/oF2y/SxCkiTlOkZPTyR0V6TjCBtHZxILM+7PcYsqFI49
	92ybd9vu6hqx4/S1OaU4NpBam6+esnblnf8VA6ELPAAeaDCve+iQSRGyQ0N+8g4kFHxH0fw2FED
	hG6awyrX0kYMaR/V0oVNA4PPN6DW+5SLbCvgl+PBZ1lCEpc58L+ryVIaD1HIJ+qMAus/uogZ9UK
	rcIHv3WJm3ld1j5meKvsHXYkoQZt3cczIu4pi1VacEbsMfK9P7lTnB2uWeyEiTaJHc+45RBdDRu
	SomIeAUPZiIMXGHsiRy0aN5BIFObfFSrFkf9tWs1yh+lGzW0yTVcuLng4RyN4MKtT9wa+xp6pWK
	fs7+tQc4S7B9TUSBUQ0LGSow==
X-Received: by 2002:a05:620a:2946:b0:8cf:e933:d069 with SMTP id
 af79cd13be357-8d41e248d43mr673450085a.49.1775254093101; Fri, 03 Apr 2026
 15:08:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <69ce4dd2.170a0220.23bcc5.dd88@mx.google.com>
In-Reply-To: <69ce4dd2.170a0220.23bcc5.dd88@mx.google.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 3 Apr 2026 17:08:01 -0500
X-Gm-Features: AQROBzD-SSZU04rHQdnqBFRJdOF5QFdSPO490kt5ULWbCiX1ikOeqIIoTGm0uwA
Message-ID: <CAH2r5mvwpjo-m=pDoVmdkYPhHpj8LceFHGHNjqrtgjUSrkVjiw@mail.gmail.com>
Subject: Re: [BUG] Linux Kernel CIFS Client SMB2_open_free KFENCE Double-Free
To: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>, Tom Talpey <tom@talpey.com>, 
	Paulo Alcantara <pc@manguebit.org>, Steve French <sfrench@samba.org>, 
	Bharath SM <bharathsm@microsoft.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This doesn't make sense - the suggested solution is:

   Alternatively, add `memset(open_iov, 0, sizeof(open_iov))` at the
`again` label in `smb2_unlink()`.

But it is already there.  Am I missing something? This doesn't look
real.  See line 1219 inside smb2_unlink() function in smb2inode.c

1211 again:
1212         oplock =3D SMB2_OPLOCK_LEVEL_NONE;
1213         server =3D cifs_pick_channel(tcon->ses);
1214
1215         memset(rqst, 0, sizeof(rqst));
1216         memset(resp_buftype, 0, sizeof(resp_buftype));
1217         memset(rsp_iov, 0, sizeof(rsp_iov));
1218
1219         memset(open_iov, 0, sizeof(open_iov));

On Thu, Apr 2, 2026 at 6:14=E2=80=AFAM ven0mfuzzer <ven0mkernelfuzzer@gmail=
.com> wrote:
>
> Linux Kernel CIFS Client SMB2_open_free KFENCE Double-Free
>
>   1. Vulnerability Title
>
> Linux Kernel CIFS Client SMB2 Compound Request KFENCE-Confirmed Double-Fr=
ee Vulnerability (ksmbd)
>
>   2. High-Level Overview
>
> This report describes the same double-free vulnerability in the Linux ker=
nel CIFS client as crash_001 (KASAN detection), now independently confirmed=
 by KFENCE (Kernel Electric-Fence). When the CIFS client sends a compound `=
CREATE + CLOSE` request (e.g., via `smb2_unlink()`), a malicious server or =
MITM can return `STATUS_IO_TIMEOUT` in the CREATE response, causing a retry=
 loop. On the error-path of the retry, `SMB2_open_free()` is called a secon=
d time on an already-freed `cifs_small_rq` mempool object (448 bytes), prod=
ucing a double-free.
>
> The KFENCE detection provides additional forensic detail over the KASAN r=
eport in crash_001: precise timestamps, exact object lifetime (27.5 seconds=
), exact slab cache name (`cifs_small_rq`), and confirmation that both free=
s are issued by the same task =E2=80=94 ruling out any race condition. This=
 is a deterministic, single-threaded double-free.
>
> This vulnerability was discovered using ven0mfuzzer, our custom-designed =
MITM-based network filesystem fuzzer developed by our team. Following the c=
ommon syzkaller practice, we submit the kernel crash trace as the primary r=
eproduction artifact.
>
>   3. Affected Product and Version Information
>
> Product: Linux Kernel (upstream mainline)
> Affected Component: `fs/smb/client/smb2inode.c` =E2=80=94 `smb2_unlink()`=
 (line 1186)
> Supporting Components:
> - `fs/smb/client/smb2pdu.c` =E2=80=94 `SMB2_open_free()` does not null fr=
eed pointer (line 3244)
>
>   Tested Versions (confirmed vulnerable)
> - Linux kernel 6.19.0 (mainline, commit `44331bd6a610`, gcc 11.4.0, built=
 2026-02-13)
> - Linux kernel 6.12.74 (LTS, used in Google kernelCTF COS target)
>
>   Affected Version Range
> All kernels from approximately 6.0 through 6.19 (current mainline at time=
 of report) with SMB2 compound replay support are believed affected.
>
>   Affected Distributions and Products
>
>  |  Vendor / Product  |  Notes  |
>  | --- | --- |
>  |  Red Hat Enterprise Linux (RHEL 9.x)  |  Ships kernels >=3D 5.14 with =
backported SMB2 compound replay  |
>  |  Ubuntu (22.04 LTS, 24.04 LTS)  |  HWE kernels 6.x include vulnerable =
code  |
>  |  SUSE Linux Enterprise Server (SLES 15 SP5+)  |  Kernel 6.x based  |
>  |  Debian (Bookworm, Trixie)  |  Kernels 6.1+  |
>  |  Fedora (39+)  |  Kernels 6.5+  |
>  |  Amazon Linux 2023  |  Kernel 6.1 LTS based  |
>  |  Google ChromeOS / COS  |  kernelCTF target, confirmed vulnerable on 6=
.12.74  |
>
>   4. Root Cause Analysis
>
>   4.a. Detailed Description
>
> This is the same root cause as crash_001: `smb2_unlink()` calls `SMB2_ope=
n_free()` twice on the same stack-local `open_iov` array pointer. The first=
 free occurs during normal cleanup after `compound_send_recv()` returns `-E=
AGAIN` (due to `STATUS_IO_TIMEOUT`). The retry loop (`goto again`) reuses t=
he same `open_iov` array without clearing it. If `SMB2_open_init()` fails o=
n the second iteration (due to reconnect state), the `err_free` label calls=
 `SMB2_open_free()` again on the stale pointer.
>
> The KFENCE report captures all three critical events:
>
> 1. Allocation at `smb2_unlink+0x470` =E2=80=94 `SMB2_open_init` allocates=
 the CREATE request buffer
> 2. First free at `smb2_unlink+0x5db` =E2=80=94 normal cleanup after `comp=
ound_send_recv` (line 1263)
> 3. Invalid second free at `smb2_unlink+0x81c` =E2=80=94 `err_free` label =
(line 1289)
>
>   4.b. Code Flow
>
> ---
> smb2_unlink()                    [fs/smb/client/smb2inode.c:1186]
>   again:
>     SMB2_open_init()             =E2=86=90 allocates cifs_small_rq object=
 (448B)
>     compound_send_recv()         =E2=86=90 server returns STATUS_IO_TIMEO=
UT =E2=86=92 -EAGAIN
>     SMB2_open_free(&rqst[0])    =E2=86=90 FIRST FREE (line 1263), does NO=
T null open_iov[0]
>     goto again
>   again:
>     memset(rqst, 0, ...)         =E2=86=90 clears rqst[] but NOT open_iov=
[] (stale pointer!)
>     SMB2_open_init()             =E2=86=90 fails (connection being reconn=
ected) =E2=86=92 rc !=3D 0
>     goto err_free
>   err_free:
>     SMB2_open_free(&rqst[0])    =E2=86=90 SECOND FREE of already-freed bu=
ffer!
> ---
>
>   4.c. KFENCE Crash Trace
>
> This vulnerability was discovered by ven0mfuzzer. The following kernel tr=
ace is submitted following syzkaller's common practice of providing the raw=
 crash trace as the primary reproduction evidence:
>
> ---
> : VFS: Signing Key   d8 d6 c0 c2 b7 56 41 83 e9 d7 b5 fd 2c df 47 62
> [ 1087.254230] CIFS: VFS: ServerIn Key  5b 78 90 2a f0 90 67 84 da 43 e8 =
f1 a8 43 eb 91
> [ 1087.254673] CIFS: VFS: ServerOut Key 93 3a 5d ae db 4a 4b fb 24 4b c5 =
b8 f9 e3 47 29
> [ 1087.258673] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiat=
e failed: -22
> [ 1087.259195] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc =
=3D -5
> [ 1087.259715] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 1087.260125] BUG: KFENCE: invalid free in mempool_free+0xde/0x130
> [ 1087.260125]
> [ 1087.260556] Invalid free of 0xffff8881f5cc4e40 (in kfence-#97):
> [ 1087.260893]  mempool_free+0xde/0x130
> [ 1087.261124]  cifs_small_buf_release+0x41/0x70
> [ 1087.261392]  SMB2_open_free+0x78/0x1b0
> [ 1087.261631]  smb2_unlink+0x81c/0x8d0
> [ 1087.261870]  __cifs_unlink+0x830/0x1890
> [ 1087.262134]  vfs_unlink+0x2f0/0xbd0
> [ 1087.262369]  filename_unlinkat+0x345/0x6d0
> [ 1087.262628]  __x64_sys_unlinkat+0xc4/0x130
> [ 1087.262886]  do_syscall_64+0x111/0x690
> [ 1087.263125]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [ 1087.263427]
> [ 1087.263531] kfence-#97: 0xffff8881f5cc4e40-0xffff8881f5cc4fff, size=3D=
448, cache=3Dcifs_small_rq
> [ 1087.263531]
> [ 1087.264219] allocated by task 1881 on cpu 0 at 1059.756104s (27.508113=
s ago):
> [ 1087.264648]  mempool_alloc_noprof+0x18a/0x2c0
> [ 1087.264919]  cifs_small_buf_get+0x36/0x80
> [ 1087.265210]  __smb2_plain_req_init+0x4b/0x1140
> [ 1087.265487]  SMB2_open_init+0x1ae/0x37f0
> [ 1087.265735]  smb2_unlink+0x470/0x8d0
> [ 1087.265974]  __cifs_unlink+0x830/0x1890
> [ 1087.266226]  vfs_unlink+0x2f0/0xbd0
> [ 1087.266460]  filename_unlinkat+0x345/0x6d0
> [ 1087.266717]  __x64_sys_unlinkat+0xc4/0x130
> [ 1087.266975]  do_syscall_64+0x111/0x690
> [ 1087.267214]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [ 1087.267514]
> [ 1087.267618] freed by task 1881 on cpu 0 at 1087.241106s (0.026511s ago=
):
> [ 1087.268109]  mempool_free+0xde/0x130
> [ 1087.268352]  cifs_small_buf_release+0x41/0x70
> [ 1087.268620]  SMB2_open_free+0x78/0x1b0
> [ 1087.268858]  smb2_unlink+0x5db/0x8d0
> [ 1087.269091]  __cifs_unlink+0x830/0x1890
> [ 1087.269293]  vfs_unlink+0x2f0/0xbd0
> [ 1087.269481]  filename_unlinkat+0x345/0x6d0
> [ 1087.269687]  __x64_sys_unlinkat+0xc4/0x130
> [ 1087.269895]  do_syscall_64+0x111/0x690
> [ 1087.270086]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [ 1087.270327]
> [ 1087.270417] CPU: 0 UID: 0 PID: 1881 Comm: rm Tainted: G    B          =
     6.19.0-g44331bd6a610-dirty #5 PREEMPT(lazy)
> [ 1087.270900] Tainted: [B]=3DBAD_PAGE
> [ 1087.271061] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> [ 1087.271561] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 1087.723901] CIFS: VFS: \\10.0.0.2 RFC 1002 unknown response type 0x8
> [ 1087.739764] CIFS: VFS: \\10.0.0.2\IPC$ validate protocol negotiate fai=
led: -11
> [ 1087.740391] CIFS: VFS: \\10.0.0.2\IPC$ reconnect tcon failed rc =3D -5
> [ 1087.746271] CIFS: VFS: generate_smb3signingkey: dumping generated AES =
session keys
> [ 1087.746842] CIFS: VFS: Session Id    02 00 00 00 00 00 00 00
> [ 1087.747238] CIFS: VFS: Cipher type   1
> [ 1087.747464] CIFS: VFS: Session Key   71 85 72 ad 7c b4 da e7 cf dc c0 =
ae 3a 07 98 19
> [ 1087.747888] CIFS: VFS: Signing Key   88 3f d1 03 8b 13 17 97 88 be 52 =
23 9b 8d a9 ed
> [ 1087.748463] CIFS: VFS: ServerIn Key  0e 28 bd af 95 9d 5d e4 34 0a d5 =
de a6 9a 74 0d
> [ 1087.749077] CIFS: VFS: ServerOut Key ba a1 76 7c c0 b9 32 db 27 09 85 =
1a e7 7d cf 65
> [ 1087.754602] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiat=
e failed: -13
> [ 1087.755289] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc =
=3D -5
> [ 1087.758970] CIFS: VFS: smb2_get_data_area_len: invalid data area (off=
=3D10608 len=3D24)
> [ 1087.759770] CIFS: VFS: \\10.0.0.2\fuzzshare Malformed ioctl resp: len =
24 offset 10608
> [ 1087.760271] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiat=
e failed: -5
> [ 1087.760742] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc =
=3D -5
> [ 1087.764494] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiat=
e failed: -22
> [ 1087.765178] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc =
=3D -5
> [ 1088.197368] CIFS: VFS: Bad protocol string signature header 420053fe
> [ 1088.198145] CIFS: VFS: Bad SMB detected. The Mid=3D16
> [ 1088.198652] 00000000: 420053fe 00010040 00000000 000a0005  .S.B@......=
.....
> [ 1088.199364] 00000010: 00000001 00000000 00000010 00000000  ...........=
.....
> [ 1088.200070] 00000020: 00000776 00000004 00000002 00000002  v..........=
.....
> [ 1088.459625] CIFS: VFS: \\10.0.0.2 RFC 1002 unknown response type 0x42
> [ 1089.503269] CIFS: VFS: generate_smb3signingkey: dumping generated AES =
session keys
> [ 1089.503705] CIFS: VFS: Session Id    02 00 00 00 00 00 00 00
> [ 1089.504013] CIFS: VFS: Cipher type   1
> [ 1089.504229] CIFS: VFS: Session Key   d6 56 c8 0b 7a 8f 2c 81 4a 9a 16 =
b8 ef a6 df 50
> [ 1089.504575] CIFS: VFS: Signing Key   b6 36 17 ad 2f 1d d5 d6 21 0a 98 =
37 50 9a 31 08
> [ 1089.504914] CIFS: VFS: ServerIn Key  b6 c4 17 a9 16 ed 60 72 14 1b 64 =
6b d5 20 5f f2
> [ 1089.505485] CIFS: VFS: ServerOut Key e1 8c 7f af 9e 04 ed 2c 67 47 63 =
68 e4 eb 9e 2b
> [ 1089.718373] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiat=
e failed: -22
> [ 1089.719252] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc =
=3D -5
> [ 1090.142104] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiat=
e failed: -5
> [ 1090.142986] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc =
=3D -5
> [ 1090.353639] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiat=
e failed: -22
> [ 1090.354254] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc =
=3D -5
> [ 1091.057267] CIFS: VFS: \\10.0.0.2\IPC$ validate protocol negotiate fai=
led: -22
> [ 1091.058141] CIFS: VFS: \\10.0.0.2\IPC$ reconnect tcon failed rc =3D -5
>
> ---
>
> Key forensic facts from KFENCE:
> - Object size: 448 bytes, cache `cifs_small_rq`
> - Object lifetime: 27.5 seconds (alloc at 1059.756s, first free at 1087.2=
41s)
> - Time between frees: 0.027 seconds (deterministic, single-threaded)
> - Both frees from same task (PID 1881, `rm`) =E2=80=94 no race condition =
involved
>
>   4.d. Relationship to crash_001
>
> crash_001 detected the same double-free via KASAN. This KFENCE detection =
(crash_008) is an independent confirmation of the same root cause with addi=
tional forensic data. Together they provide overwhelming evidence that the =
bug is real, deterministic, and affecting both KASAN and KFENCE instrumenta=
tion paths.
>
>   4.e. Suggested Fix
>
> Null out the pointer in `SMB2_open_free()` after releasing the buffer:
>
> ---
> void SMB2_open_free(struct smb_rqst *rqst)
> {
>     int i;
>     if (rqst && rqst->rq_iov) {
>         cifs_small_buf_release(rqst->rq_iov[0].iov_base);
> +       rqst->rq_iov[0].iov_base =3D NULL;
>         for (i =3D 1; i < rqst->rq_nvec; i++)
>             if (rqst->rq_iov[i].iov_base !=3D smb2_padding)
>                 kfree(rqst->rq_iov[i].iov_base);
> +       rqst->rq_nvec =3D 0;
>     }
> }
> ---
>
> Alternatively, add `memset(open_iov, 0, sizeof(open_iov))` at the `again`=
 label in `smb2_unlink()`.
>
>   5. Discovery Method and Reproduction
>
>   5.a. Discovery
>
> This vulnerability was discovered using ven0mfuzzer, a custom-designed MI=
TM-based network filesystem fuzzer developed by our team. The fuzzer operat=
es by positioning an AF_PACKET/TCP transparent proxy between a Linux kernel=
 filesystem client (VM-A) and its server (VM-B), then mutating network prot=
ocol messages in-flight. We designed ven0mfuzzer specifically for this clas=
s of network filesystem vulnerabilities.
>
> Following the common syzkaller practice, we submit the kernel crash trace=
 as the primary reproduction artifact. The trace above was captured with KF=
ENCE enabled on kernel 6.19.0.
>
>   5.b. Reproduction Setup
>
> ---
> VM-A (CIFS client) =E2=94=80=E2=94=80SMB2=E2=94=80=E2=94=80=E2=96=BA Host=
:44446 (MITM proxy) =E2=94=80=E2=94=80TCP=E2=94=80=E2=94=80=E2=96=BA Host:4=
4445 =E2=94=80=E2=94=80hostfwd=E2=94=80=E2=94=80=E2=96=BA VM-B:445 (ksmbd)
> ---
>
> Trigger condition: Any `unlink` operation on a CIFS mount while the MITM =
injects `STATUS_IO_TIMEOUT` (`0xC00000B5`) in CREATE responses followed by =
a forced reconnect.
>
> ---
> Reported-by: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
> Link: https://github.com/KernelStackFuzz/KernelStackFuzz
>


--=20
Thanks,

Steve
