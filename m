Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3442036FE;
	Sat, 12 Apr 2025 17:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744478943; cv=none; b=CbwcP0ldFnkySElx/Dh0A2qhIJcOgIacMRVleQSSEQTCRJsmJ5b0t7QxWWnA5RgidvvrQz0gfQFzPn2x0KDLsqnuXoAyZRF3Po248YYoaaXupmZeF/9p74wJdzmhekWbUJqqHieHAgAYeuO1Zua2CiYQDnrjLPm67i9cS1WK2gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744478943; c=relaxed/simple;
	bh=LPrLvMW9OoNawWIpU77rN51+ZMt61xjgbmveRZDoYHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=shVOUvo/IKIZuwOe0nYnQKSRvzshQ8TVj7hBAIJu4WQSeQY9LiM+VWN7kE4EpuNnpp64Dd8LWmWLAj9V8hb7nzKFNYwNvrouiXTwIyz3G4tG5M+2upT7VRPVao4ZgLDPEdfNVVJHghmAqVPQzZKLZWC5PZewQAiJ0colqi8O8nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lk6nTOCR; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lk6nTOCR"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-30bfd4d4c63so26621611fa.2;
        Sat, 12 Apr 2025 10:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744478939; x=1745083739; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDiG+6xdqRbUOLVmNuhQUP52newOAwJWhhpLEwuQ91c=;
        b=Lk6nTOCRoVKhvlqkasqdjcdmOf9PY20Ya1i1Q/X3Cn7YztKagheleFeK0D2trE1IcK
         xcLjlb53HUy3wL4FpEWJPsU6j2hcL/VZUjnNmnTaOMOIQf3nwBLEN8iuPQ5I4aPSsj8z
         zWUaCVOfK+50rojwlBrlrZXB6Do8+md2rYUERnoW8uWzG0R+Sm3/v1HzWqFfTHHDFnBX
         mHC2+vI5gwhLNopYYQbrHEP4KULxW8yT5vwVzhaN17zVcLu2/o2+llHOMI71mzmNrKnB
         yDS/a2xHOTfrvQ7Gd8gPIbk+Df1thGKPWvR8lOjq7gbqPWvCyeBpbv0fZRQKCctlYxRr
         gv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744478939; x=1745083739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MDiG+6xdqRbUOLVmNuhQUP52newOAwJWhhpLEwuQ91c=;
        b=cC6w6H5a9PLCXaSq6h/dy+zP/LS8Jt1FoeiIESNOpVaiGDsthKydc4pRQL5rLSFhXi
         U3FBcMfXw0d5eoCUrhBJjAPB2Tmp9aQXtyBZ5+qGBtUnPn0E8ey/C3inQvT4B3Qyrb1Z
         DM/+2x3gufALjkndaS2vmzD1DlXMR4xD7lIx7A9bl0FqulMtcllAXdqB0Gwjg1vroQml
         M/dM6ApeUvXmQO2JtI6RZL5kIK43K/q1syjMpJ1RIEuwPJmCUvCJEEcbh3MvuVjm/I4T
         8Mc38FyIUztXwvp7e/WrYD254Zr35Rm76Ejw0ZHRGcEOntPrxKRFjeS49fEVoub/7Ghe
         5HjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUp9PtE7jttOc0pXyDLKL/udBdKUAHXqAooQrLaLaMlSagqiATeU8KgIrkQCkG3BuZDthje9/KmaKyi@vger.kernel.org, AJvYcCX5FMDKwY/0aFzSSAXR2AbBpvyW1HWJ6lRhtXtj5j5z4tRcwDA4OH5CKoQPz2wqZ6IMyZ5L63/mdFhr5WDM@vger.kernel.org, AJvYcCXfacWJkOX6Szg1jg6CfsxnYdLKKf1zrV0IGJlubm62gr55fEl2G4BUqVAXCdJi2LY6KAosl4iKFzYv@vger.kernel.org
X-Gm-Message-State: AOJu0YwiYSi/2d7NnToH6qcCzcq2OuBtkEe3SAW48CfQTtHrK1ZNRtaM
	ZrlYJCU25MRDC8JeI3/7vdS0sVzPSewv0vMZz3EGLhGucd3Y0+IKLpNrDNrm1jIOKqyBKVa9L7b
	TBVxWTK2Ja9v/Iij+Csi7k3/4Fwg=
X-Gm-Gg: ASbGncsD3xBi9w4G/vGc7FXlJvh5fvaqrapw6PSqxLy+3o21V8gypiadOfDjn2xqfXl
	4Iv9HAP/oDAt1SeTo1RS8bRWdaMFL25XUb661sAQpLSsuxF1Gzyq6hOa+NcUa46vFul+qt8JTH7
	MFgc0hUvwjdsbCpfgwOWNbbGoZI/bYHK3TEr90X3oPK2Umbo3mKZfsBR7s
X-Google-Smtp-Source: AGHT+IFVggQxTTXpC7zivVqxEk6y33BjyM3QBWZBfrp373JRrkJwyYiFaYuiO/rTPSf8IEKCAE1jenNJvHCgwUvAGp0=
X-Received: by 2002:a2e:a815:0:b0:30b:b908:ce06 with SMTP id
 38308e7fff4ca-31049a1a6bfmr23257451fa.19.1744478938598; Sat, 12 Apr 2025
 10:28:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mu7Wf0n9ZmnhAAWetKRiUczHv+odYHj5bBg6a=G1y2kcQ@mail.gmail.com>
 <20250411070724.13959-1-kuniyu@amazon.com>
In-Reply-To: <20250411070724.13959-1-kuniyu@amazon.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 12 Apr 2025 12:28:46 -0500
X-Gm-Features: ATxdqUHtM3Ytv5cuRYdq4XKxpQ3YkROQffJy0mEtBNkLxhrlCVW2skBqW_fkPa8
Message-ID: <CAH2r5msMZ9j2Uugjex8DzT+uQWsoj5Q0NECMgx3wJFpCEaeo8w@mail.gmail.com>
Subject: Re: [PATCH 0/2] cifs: Revert bogus fix for CVE-2024-54680 and its
 followup commit.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: bharathsm@microsoft.com, ematsumiya@suse.de, kuni1840@gmail.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-net@vger.kernel.org, pc@manguebit.com, samba-technical@lists.samba.org, 
	sprasad@microsoft.com, tom@talpey.com, wangzhaolong1@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have tentatively merged the two revert patches into cifs-2.6.git
for-next but still hoping for any review comments for those more
expert in the network lockdep code.

Let me know when the fix to core/sock.c is upstream

On Fri, Apr 11, 2025 at 2:07=E2=80=AFAM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> From: Steve French <smfrench@gmail.com>
> Date: Wed, 2 Apr 2025 22:19:36 -0500
> > I can run some regression tests with these two patches, but it would
> > be very helpful if the original patch authors could comment (Wang and
> > Enzo), and since this apparently relies on a fix to the network stack
> > (the LOCKDEP fix) it would be helpful if any opinions from the network
> > devs.
> >
> > For a complex issue like this it is important to have at least some
> > Tested-by or Reviewed-by for these two, because I was having trouble
> > reproducing the various reported problems on Ubuntu (or our Fedora
> > test VMs), and the refcount issues are more complicated they seem.
> > Let me know if anyone has reviewed these two patches or tested them.
>
> Hi Steve,
>
> The lockdep fix was merged on the networking side and will be sent to
> the mainline this week.
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3D0bb2f7a1ad1f
>
> As you mentioned Fedora, I tried ksmbd and created a repro script that
> works on a single host.
>
> On my Fedora VM, I ran the prep & reproducer scripts and successfully
> triggered the issue on cifs-2.6.git/for-next with/without reverts.
>
> I hope this helps you reproduce the issue and verify the patch on your
> Fedora test VM.
>
> Please let me know if there's anything I can help.
>
> Thanks!
>
>
> Prerequisite:
>
> 1. On VM, the user is expected to be root
> 2. ffa1e7ada456 needs to be reverted (as it stopped lockdep during
>    boot on my VM)
> 3. .config is created based on x86_64_defconfig
>
> ---8<---
> make defconfig
> ./scripts/config -m CONFIG_CIFS -m CONFIG_SMB_SERVER -e CONFIG_PROVE_LOCK=
ING
> make olddefconfig
> make -j $(nproc)
> ---8<---
>
>
> Prep:
>
> This script builds ksmbd-tools and installs it and cifs-utils,
> iproute (for ss), and iptables-legacy (for iptables).
>
> ---8<---
> #!/bin/bash
>
> #
> # Build and install ksmbd-tools
> # See https://github.com/cifsd-team/ksmbd-tools?tab=3Dreadme-ov-file#buil=
ding-and-installing
> #
> dnf install -y git gcc pkgconf autoconf automake libtool make meson ninja=
-build gawk libnl3-devel glib2-devel
> git clone https://github.com/cifsd-team/ksmbd-tools.git
> cd ksmbd-tools
> ./autogen.sh
> ./configure --with-rundir=3D/run
> make
> make install
> cd ~/
>
>
> #
> # CIFS client
> #
> dnf install -y cifs-utils
>
>
> #
> # Networking utilities
> #
> dnf install -y iproute iptables-legacy
> ---8<---
>
>
> Reproducer:
>
> ---8<----
> #!/bin/bash
>
> function show_sk_mod_ref()
> {
>     ss -tan | grep 445
>     lsmod | grep cifs
> }
>
> set -x
>
>
> #
> # Share /root/server
> #
> mkdir server
> touch server/a.txt
> ksmbd.addshare --add --option "path =3D /root/server" --option 'read only=
 =3D no' server
> ksmbd.adduser --password test root
> modprobe ksmbd
> ksmbd.mountd
>
>
> #
> # Mount /root/server as /root/client
> #
> mkdir client
> mount -t cifs -o vers=3D3.0,echo_interval=3D1,user=3Droot,password=3Dtest=
 //127.0.0.1/server /root/client
>
>
> #
> # Drop FIN packet from CIFS client
> #
> iptables -A OUTPUT -p tcp --dport 445 -j DROP
>
>
> show_sk_mod_ref
>
>
> #
> # Unmount /root/client
> #
> until umount client; do
>     sleep 1
> done
>
> show_sk_mod_ref
>
>
> #
> # Unload module, and then lockdep will complain.
> #
> until rmmod cifs; do
>     show_sk_mod_ref
>     sleep 3
> done
>
>
> show_sk_mod_ref
> ---8<---
>
>
> FWIW, here's output of the repro including console output.
>
> ---8<---
> Fedora Linux 41 (Container Image)
> Kernel 6.15.0-rc1-00011-gf78f3365efed on an x86_64 (console)
>
> fedora login: root
> Last login: Fri Apr 11 06:20:39 on console
> [root@fedora ~]# ./repro.sh
> + mkdir server
> + touch server/a.txt
> + ksmbd.addshare --add --option 'path =3D /root/server' --option 'read on=
ly =3D no' server
> [ksmbd.addshare/831]: INFO: No user database
> [ksmbd.addshare/831]: INFO: Wrote `/usr/local/etc/ksmbd/ksmbd.conf'
> [ksmbd.addshare/831]: INFO: Wrote `/usr/local/etc/ksmbd/ksmbd.conf'
> [ksmbd.addshare/831]: INFO: Added share `server'
> [ksmbd.addshare/831]: INFO: Ignored lock file
> + ksmbd.adduser --password test root
> [ksmbd.adduser/832]: INFO: Wrote `/usr/local/etc/ksmbd/ksmbdpwd.db'
> [ksmbd.adduser/832]: INFO: Wrote `/usr/local/etc/ksmbd/ksmbdpwd.db'
> [ksmbd.adduser/832]: INFO: Added user `root'
> [ksmbd.adduser/832]: INFO: Ignored lock file
> + modprobe ksmbd
> + ksmbd.mountd
> [ksmbd.mountd/835]: INFO: Started manager
> + mkdir client
> + mount -t cifs -o vers=3D3.0,echo_interval=3D1,user=3Droot,password=3Dte=
st //127.0.0.1/server /root/client
> [  113.929225] Key type cifs.idmap registered
> [  113.930423] CIFS: Attempting to mount //127.0.0.1/server
> [  113.993548] mount.cifs (843) used greatest stack depth: 11208 bytes le=
ft
> + iptables -A OUTPUT -p tcp --dport 445 -j DROP
> + show_sk_mod_ref
> + ss -tan
> + grep 445
> ESTAB  0      0               127.0.0.1:34814          127.0.0.1:445
> LISTEN 0      0                       *:445                    *:*
> LISTEN 0      0                       *:445                    *:*
> ESTAB  0      516    [::ffff:127.0.0.1]:445   [::ffff:127.0.0.1]:34814
> + lsmod
> + grep cifs
> cifs                 1175552  2
> cifs_md4               12288  1 cifs
> cifs_arc4              12288  2 cifs,ksmbd
> nls_ucs2_utils          8192  2 cifs,ksmbd
> + umount client
> [  121.064583] CIFS: VFS: \\127.0.0.1 has not responded in 3 seconds. Rec=
onnecting...
> + show_sk_mod_ref
> + ss -tan
> + grep 445
> FIN-WAIT-1 0      145             127.0.0.1:34814          127.0.0.1:445
> LISTEN     0      0                       *:445                    *:*
> LISTEN     0      0                       *:445                    *:*
> ESTAB      0      516    [::ffff:127.0.0.1]:445   [::ffff:127.0.0.1]:3481=
4
> + lsmod
> + grep cifs
> cifs                 1175552  1
> cifs_md4               12288  1 cifs
> cifs_arc4              12288  2 cifs,ksmbd
> nls_ucs2_utils          8192  2 cifs,ksmbd
> + rmmod cifs
> rmmod: ERROR: Module cifs is in use
> + show_sk_mod_ref
> + ss -tan
> + grep 445
> FIN-WAIT-1 0      145             127.0.0.1:34814          127.0.0.1:445
> LISTEN     0      0                       *:445                    *:*
> LISTEN     0      0                       *:445                    *:*
> ESTAB      0      516    [::ffff:127.0.0.1]:445   [::ffff:127.0.0.1]:3481=
4
> + lsmod
> + grep cifs
> cifs                 1175552  1
> cifs_md4               12288  1 cifs
> cifs_arc4              12288  2 cifs,ksmbd
> nls_ucs2_utils          8192  2 cifs,ksmbd
> + sleep 3
> + rmmod cifs
> [  127.142558] Key type cifs.idmap unregistered
> + show_sk_mod_ref
> + ss -tan
> + grep 445
> FIN-WAIT-1 0      145             127.0.0.1:34814          127.0.0.1:445
> LISTEN     0      0                       *:445                    *:*
> LISTEN     0      0                       *:445                    *:*
> ESTAB      0      516    [::ffff:127.0.0.1]:445   [::ffff:127.0.0.1]:3481=
4
> + lsmod
> + grep cifs
> cifs_md4               12288  0
> cifs_arc4              12288  1 ksmbd
> [root@fedora ~]# [  127.414391] ------------[ cut here ]------------
> [  127.414940] DEBUG_LOCKS_WARN_ON(1)
> [  127.414950] WARNING: CPU: 62 PID: 0 at kernel/locking/lockdep.c:237 hl=
ock_class+0x5f/0x70
> [  127.416185] Modules linked in: cifs_md4 ksmbd cifs_arc4 nls_ucs2_utils=
 [last unloaded: cifs]
> [  127.417066] CPU: 62 UID: 0 PID: 0 Comm: swapper/62 Not tainted 6.15.0-=
rc1-00011-gf78f3365efed #3 PREEMPT(voluntary)
> [  127.418158] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> [  127.419312] RIP: 0010:hlock_class+0x5f/0x70
> [  127.419745] Code: ef 90 e8 c4 8f 4d 00 85 c0 74 23 8b 05 ba 8c bf 01 8=
5 c0 75 19 90 48 c7 c6 13 fb a1 82 48 c7 c7 cc 76 a0 82 e8 92 b4 f7 ff 90 <=
0f> 0b 90 90 90 31 c0 c3 cc cc cc cc 0f 1f 44 00 00 90 90 90 90 90
> [  127.421622] RSP: 0018:ffa0000000d60c20 EFLAGS: 00010086
> [  127.422146] RAX: 0000000000000000 RBX: ff11000100b12b38 RCX: 000000000=
0000027
> [  127.422890] RDX: ff1100081fd97c08 RSI: 0000000000000001 RDI: ff1100081=
fd97c00
> [  127.423624] RBP: ff11000100b12100 R08: ff1100083fe6e0e8 R09: 00000000f=
fffbfff
> [  127.424365] R10: ff1100081eca0000 R11: ff1100083fe10cf8 R12: ff1100010=
0b12b60
> [  127.425099] R13: 0000000000000001 R14: 0000000000000000 R15: 000000000=
00424ac
> [  127.425827] FS:  0000000000000000(0000) GS:ff1100089c5bb000(0000) knlG=
S:0000000000000000
> [  127.426657] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  127.427259] CR2: 00007f714e3ab0d8 CR3: 0000000002c4c006 CR4: 000000000=
0771ef0
> [  127.428004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  127.428738] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 000000000=
0000400
> [  127.429465] PKRU: 55555554
> [  127.429753] Call Trace:
> [  127.430012]  <IRQ>
> [  127.430231]  __lock_acquire+0x21d/0x1730
> [  127.430631]  ? __lock_acquire+0xa4f/0x1730
> [  127.431054]  lock_acquire+0xbd/0x2d0
> [  127.431427]  ? tcp_write_timer+0x5a/0x120
> [  127.431846]  ? lock_acquire+0xbd/0x2d0
> [  127.432244]  ? call_timer_fn+0x71/0x260
> [  127.432651]  ? __pfx_tcp_write_timer+0x10/0x10
> [  127.433116]  _raw_spin_lock+0x2b/0x40
> [  127.433506]  ? tcp_write_timer+0x5a/0x120
> [  127.433915]  tcp_write_timer+0x5a/0x120
> [  127.434317]  ? __pfx_tcp_write_timer+0x10/0x10
> [  127.434776]  call_timer_fn+0x9d/0x260
> [  127.435154]  __run_timers+0x1f9/0x300
> [  127.435538]  ? find_held_lock+0x2b/0x80
> [  127.435933]  ? tmigr_handle_remote_up+0x1a6/0x370
> [  127.436422]  timer_expire_remote+0x36/0x50
> [  127.436852]  tmigr_handle_remote_up+0x2a5/0x370
> [  127.437327]  ? find_held_lock+0x2b/0x80
> [  127.437726]  ? tmigr_handle_remote+0x88/0xd0
> [  127.438157]  ? lock_release+0xc6/0x290
> [  127.438530]  ? __pfx_tmigr_handle_remote_up+0x10/0x10
> [  127.439037]  __walk_groups.isra.0+0x1a/0x70
> [  127.439464]  tmigr_handle_remote+0xa0/0xd0
> [  127.439892]  ? kvm_clock_get_cycles+0x18/0x30
> [  127.440343]  handle_softirqs+0xbd/0x3b0
> [  127.440738]  __irq_exit_rcu+0xa1/0xc0
> [  127.441111]  irq_exit_rcu+0x9/0x20
> [  127.441469]  sysvec_apic_timer_interrupt+0x6f/0x80
> [  127.441968]  </IRQ>
> [  127.442198]  <TASK>
> [  127.442428]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [  127.442965] RIP: 0010:pv_native_safe_halt+0xf/0x20
> [  127.443469] Code: 56 7a 00 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d c5 af 12 00 fb f4 <=
c3> cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
> [  127.445348] RSP: 0018:ffa000000028fee0 EFLAGS: 00000206
> [  127.445882] RAX: 0000000000004e63 RBX: ff11000100b12100 RCX: 000000000=
0000000
> [  127.446619] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8=
12f81df
> [  127.447348] RBP: 000000000000003e R08: 0000000000000001 R09: 000000000=
0000000
> [  127.448077] R10: 0000000000000001 R11: 0000000000000080 R12: 000000000=
0000000
> [  127.448805] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000=
0000000
> [  127.449541]  ? do_idle+0x1df/0x250
> [  127.449905]  default_idle+0x9/0x10
> [  127.450266]  default_idle_call+0x85/0x1e0
> [  127.450687]  do_idle+0x1df/0x250
> [  127.451032]  cpu_startup_entry+0x24/0x30
> [  127.451441]  start_secondary+0xf8/0x100
> [  127.451846]  common_startup_64+0x13e/0x148
> [  127.452276]  </TASK>
> [  127.452516] irq event stamp: 20078
> [  127.452869] hardirqs last  enabled at (20078): [<ffffffff822ef523>] _r=
aw_spin_unlock_irq+0x23/0x40
> [  127.453787] hardirqs last disabled at (20077): [<ffffffff822ef262>] _r=
aw_spin_lock_irq+0x42/0x50
> [  127.454659] softirqs last  enabled at (20062): [<ffffffff8129b31e>] ha=
ndle_softirqs+0x2ee/0x3b0
> [  127.455536] softirqs last disabled at (20069): [<ffffffff8129b541>] __=
irq_exit_rcu+0xa1/0xc0
> [  127.456394] ---[ end trace 0000000000000000 ]---
> [  127.456858] BUG: kernel NULL pointer dereference, address: 00000000000=
000c4
> [  127.457553] #PF: supervisor read access in kernel mode
> [  127.458069] #PF: error_code(0x0000) - not-present page
> [  127.458584] PGD 0
> [  127.458802] Oops: Oops: 0000 [#1] SMP NOPTI
> [  127.459231] CPU: 62 UID: 0 PID: 0 Comm: swapper/62 Tainted: G        W=
           6.15.0-rc1-00011-gf78f3365efed #3 PREEMPT(voluntary)
> [  127.460448] Tainted: [W]=3DWARN
> [  127.460754] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> [  127.461924] RIP: 0010:__lock_acquire+0x220/0x1730
> [  127.462393] Code: 15 41 09 c7 41 8b 44 24 20 25 ff 1f 00 00 41 09 c7 8=
b 84 24 a0 00 00 00 45 89 7c 24 20 41 89 44 24 24 e8 03 b9 ff ff 4c 89 e7 <=
44> 0f b6 b8 c4 00 00 00 e8 f3 b8 ff ff 0f b6 80 c5 00 00 00 88 44
> [  127.464288] RSP: 0018:ffa0000000d60c28 EFLAGS: 00010046
> [  127.464825] RAX: 0000000000000000 RBX: ff11000100b12b38 RCX: 000000000=
0000027
> [  127.465538] RDX: ff1100081fd97c08 RSI: 0000000000000001 RDI: ff1100010=
0b12b60
> [  127.466245] RBP: ff11000100b12100 R08: ff1100083fe6e0e8 R09: 00000000f=
fffbfff
> [  127.466964] R10: ff1100081eca0000 R11: ff1100083fe10cf8 R12: ff1100010=
0b12b60
> [  127.467689] R13: 0000000000000001 R14: 0000000000000000 R15: 000000000=
00424ac
> [  127.468415] FS:  0000000000000000(0000) GS:ff1100089c5bb000(0000) knlG=
S:0000000000000000
> [  127.469228] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  127.469810] CR2: 00000000000000c4 CR3: 0000000002c4c006 CR4: 000000000=
0771ef0
> [  127.470530] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  127.471249] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 000000000=
0000400
> [  127.471968] PKRU: 55555554
> [  127.472248] Call Trace:
> [  127.472505]  <IRQ>
> [  127.472723]  ? __lock_acquire+0xa4f/0x1730
> [  127.473144]  lock_acquire+0xbd/0x2d0
> [  127.473510]  ? tcp_write_timer+0x5a/0x120
> [  127.473920]  ? lock_acquire+0xbd/0x2d0
> [  127.474306]  ? call_timer_fn+0x71/0x260
> [  127.474714]  ? __pfx_tcp_write_timer+0x10/0x10
> [  127.475182]  _raw_spin_lock+0x2b/0x40
> [  127.475568]  ? tcp_write_timer+0x5a/0x120
> [  127.475987]  tcp_write_timer+0x5a/0x120
> [  127.476391]  ? __pfx_tcp_write_timer+0x10/0x10
> [  127.476850]  call_timer_fn+0x9d/0x260
> [  127.477231]  __run_timers+0x1f9/0x300
> [  127.477614]  ? find_held_lock+0x2b/0x80
> [  127.478017]  ? tmigr_handle_remote_up+0x1a6/0x370
> [  127.478511]  timer_expire_remote+0x36/0x50
> [  127.478937]  tmigr_handle_remote_up+0x2a5/0x370
> [  127.479406]  ? find_held_lock+0x2b/0x80
> [  127.479795]  ? tmigr_handle_remote+0x88/0xd0
> [  127.480238]  ? lock_release+0xc6/0x290
> [  127.480628]  ? __pfx_tmigr_handle_remote_up+0x10/0x10
> [  127.481146]  __walk_groups.isra.0+0x1a/0x70
> [  127.481575]  tmigr_handle_remote+0xa0/0xd0
> [  127.481994]  ? kvm_clock_get_cycles+0x18/0x30
> [  127.482441]  handle_softirqs+0xbd/0x3b0
> [  127.482837]  __irq_exit_rcu+0xa1/0xc0
> [  127.483217]  irq_exit_rcu+0x9/0x20
> [  127.483569]  sysvec_apic_timer_interrupt+0x6f/0x80
> [  127.484054]  </IRQ>
> [  127.484282]  <TASK>
> [  127.484506]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [  127.485032] RIP: 0010:pv_native_safe_halt+0xf/0x20
> [  127.485525] Code: 56 7a 00 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d c5 af 12 00 fb f4 <=
c3> cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
> [  127.487401] RSP: 0018:ffa000000028fee0 EFLAGS: 00000206
> [  127.487939] RAX: 0000000000004e63 RBX: ff11000100b12100 RCX: 000000000=
0000000
> [  127.488671] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8=
12f81df
> [  127.489399] RBP: 000000000000003e R08: 0000000000000001 R09: 000000000=
0000000
> [  127.490120] R10: 0000000000000001 R11: 0000000000000080 R12: 000000000=
0000000
> [  127.490846] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000=
0000000
> [  127.491570]  ? do_idle+0x1df/0x250
> [  127.491926]  default_idle+0x9/0x10
> [  127.492272]  default_idle_call+0x85/0x1e0
> [  127.492687]  do_idle+0x1df/0x250
> [  127.493028]  cpu_startup_entry+0x24/0x30
> [  127.493437]  start_secondary+0xf8/0x100
> [  127.493830]  common_startup_64+0x13e/0x148
> [  127.494257]  </TASK>
> [  127.494494] Modules linked in: cifs_md4 ksmbd cifs_arc4 nls_ucs2_utils=
 [last unloaded: cifs]
> [  127.495352] CR2: 00000000000000c4
> [  127.495697] ---[ end trace 0000000000000000 ]---
> [  127.496168] RIP: 0010:__lock_acquire+0x220/0x1730
> [  127.496635] Code: 15 41 09 c7 41 8b 44 24 20 25 ff 1f 00 00 41 09 c7 8=
b 84 24 a0 00 00 00 45 89 7c 24 20 41 89 44 24 24 e8 03 b9 ff ff 4c 89 e7 <=
44> 0f b6 b8 c4 00 00 00 e8 f3 b8 ff ff 0f b6 80 c5 00 00 00 88 44
> [  127.498505] RSP: 0018:ffa0000000d60c28 EFLAGS: 00010046
> [  127.499036] RAX: 0000000000000000 RBX: ff11000100b12b38 RCX: 000000000=
0000027
> [  127.499755] RDX: ff1100081fd97c08 RSI: 0000000000000001 RDI: ff1100010=
0b12b60
> [  127.500478] RBP: ff11000100b12100 R08: ff1100083fe6e0e8 R09: 00000000f=
fffbfff
> [  127.501203] R10: ff1100081eca0000 R11: ff1100083fe10cf8 R12: ff1100010=
0b12b60
> [  127.501901] R13: 0000000000000001 R14: 0000000000000000 R15: 000000000=
00424ac
> [  127.502617] FS:  0000000000000000(0000) GS:ff1100089c5bb000(0000) knlG=
S:0000000000000000
> [  127.503433] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  127.504012] CR2: 00000000000000c4 CR3: 0000000002c4c006 CR4: 000000000=
0771ef0
> [  127.504741] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  127.505464] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 000000000=
0000400
> [  127.506182] PKRU: 55555554
> [  127.506467] Kernel panic - not syncing: Fatal exception in interrupt
> [  127.508092] Kernel Offset: disabled
> [  127.508527] ---[ end Kernel panic - not syncing: Fatal exception in in=
terrupt ]---
> ---8<---



--=20
Thanks,

Steve
