Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39801A275
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 01:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764035295; cv=none; b=FeW/qqd2OL/xRavrqOlOTVcVr0BnMKLdcWnJq0eprCeATna5qEBsup7vVLRUpDaULGjU6ptcamIUoeuWXfD2pO1fXVRBmuI6fBj7FBPV5kmsnC6tRNB7Akl6uDD9XIXI5yZSamy827aDTHkNok8gKApbR8W+AgkMpHrqGzsgOr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764035295; c=relaxed/simple;
	bh=sgbAXSFoCv53etQexP+31n/852shHtDHRPzKhDBQ81s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QULWAkCvcnYKX4gqzuFSE6adRZF2ml9d+6aqbuhv8pHk41Z6aVsb6JACuWcVtPPHmKP8Xszni8FyCUXauzGD5edJKIuw0fV9wsFMPo10BdZoMmeHutem0fjW30zaEKHGTuPTSXCATx/uQ5U4MsB2Z4Q9plHO1NkB4LktJszip6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXfkkD37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXfkkD37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5351FC19422
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 01:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764035295;
	bh=sgbAXSFoCv53etQexP+31n/852shHtDHRPzKhDBQ81s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AXfkkD37dFntrz4/0BAcJPZ/l17oQvSExe1ulu7/2ObjYFGNjwKJg9ATHW2Bv7+b7
	 dfwnbMdPhw6Y8lciHNYUr7OArUTXch9tNN9YxtZ93qUJ7WITgPgTiGDdIe1IWCCM41
	 F/KxzF4C5437Q/L7zfMGydXWFzTxCmQHNEC6BXQkEQZi1jXqNqmiFM6cz6PCgKoYfd
	 u3ms3Ei9si4pxPaZlg+ENNghEyTNJlIsPn5ufiwD+ZxYjxQ0M2MAJnEzWiH1R2Ksta
	 RoLvj9lRnKTgcAGBM/ETQXHNbnqZ2povVEsVN0nXrEU9EcakBPK2zEnoNnQBCW7h2+
	 iT7MI6+lg0MSQ==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64088c6b309so8200581a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 17:48:15 -0800 (PST)
X-Gm-Message-State: AOJu0Yxc+EWphobB3WaXC8hU1jxioSxTZjVMgMCNRPMYbd1pS8EVpUhq
	+WRYQDzsNmWcjN2r6fb8m2pd1RVxEFtQWZOgzA/mjUEsoE3GlC25mWLRnmAc/LzcJ3Y6RZhCGQy
	qCS1H7qy5V23BOt6Vpc/us5oXPP2dLJQ=
X-Google-Smtp-Source: AGHT+IG3CiYyBjDDsjFkxj2L3SzUmU6ps8jhuWzviDsLWwyZzqk54TnDWLMV5ilrcmlE1i8xnwMriIm3CC6abO8Na8Y=
X-Received: by 2002:a05:6402:4444:b0:645:d437:f1d with SMTP id
 4fb4d7f45d1cf-645d437100bmr4126732a12.16.1764035293807; Mon, 24 Nov 2025
 17:48:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764016346.git.metze@samba.org> <b15108255ca908620251451408b14f3bfadf5e8d.1764016346.git.metze@samba.org>
In-Reply-To: <b15108255ca908620251451408b14f3bfadf5e8d.1764016346.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 25 Nov 2025 10:48:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-F=cOfBLi69QdTfTqU4ggXcAGZ3wVMrXur18=c5XOUMw@mail.gmail.com>
X-Gm-Features: AWmQ_bn53i0UPQNjc6bzO8JYOrRtDrMVPSr3mwX4R8c8znAHHoNqSSHVs1F_oJk
Message-ID: <CAKYAXd-F=cOfBLi69QdTfTqU4ggXcAGZ3wVMrXur18=c5XOUMw@mail.gmail.com>
Subject: Re: [PATCH 3/4] smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
 checks in recv_done() and smb_direct_cm_handler()
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2025 at 5:42=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Namjae reported the following:
>
> I have a simple file copy test with windows 11 client, and get the
> following error message.
>
> [  894.140312] ------------[ cut here ]------------
> [  894.140316] WARNING: CPU: 1 PID: 116 at
> fs/smb/server/transport_rdma.c:642 recv_done+0x308/0x360 [ksmbd]
> [  894.140335] Modules linked in: ksmbd cmac nls_utf8 nls_ucs2_utils
> libarc4 nls_iso8859_1 snd_hda_codec_intelhdmi snd_hda_codec_hdmi
> snd_hda_codec_alc882 snd_hda_codec_realtek_lib snd_hda_codec_generic
> rpcrdma intel_rapl_msr rdma_ucm intel_rapl_common snd_hda_intel
> ib_iser snd_hda_codec intel_uncore_frequency
> intel_uncore_frequency_common snd_hda_core intel_tcc_cooling
> x86_pkg_temp_thermal intel_powerclamp snd_intel_dspcfg libiscsi
> snd_intel_sdw_acpi coretemp scsi_transport_iscsi snd_hwdep kvm_intel
> i915 snd_pcm ib_umad rdma_cm snd_seq_midi ib_ipoib kvm
> snd_seq_midi_event iw_cm snd_rawmidi ghash_clmulni_intel ib_cm
> aesni_intel snd_seq mei_hdcp drm_buddy rapl snd_seq_device eeepc_wmi
> asus_wmi snd_timer intel_cstate ttm snd drm_client_lib
> drm_display_helper sparse_keymap soundcore platform_profile mxm_wmi
> wmi_bmof joydev mei_me cec acpi_pad mei rc_core drm_kms_helper
> input_leds i2c_algo_bit mac_hid sch_fq_codel msr parport_pc ppdev lp
> nfsd parport auth_rpcgss binfmt_misc nfs_acl lockd grace drm sunrpc
> ramoops efi_pstore
> [  894.140414]  reed_solomon pstore_blk pstore_zone autofs4 btrfs
> blake2b_generic xor raid6_pq mlx5_ib ib_uverbs ib_core hid_generic uas
> usbhid hid r8169 i2c_i801 usb_storage i2c_mux i2c_smbus mlx5_core
> realtek ahci mlxfw psample libahci video wmi [last unloaded: ksmbd]
> [  894.140442] CPU: 1 UID: 0 PID: 116 Comm: kworker/1:1H Tainted: G
>     W           6.18.0-rc5+ #1 PREEMPT(voluntary)
> [  894.140447] Tainted: [W]=3DWARN
> [  894.140448] Hardware name: System manufacturer System Product
> Name/H110M-K, BIOS 3601 12/12/2017
> [  894.140450] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> [  894.140476] RIP: 0010:recv_done+0x308/0x360 [ksmbd]
> [  894.140487] Code: 2e f2 ff ff 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc
> cc cc cc 41 8b 55 10 49 8b 75 08 b9 02 00 00 00 e8 ed f4 f2 c3 e9 59
> fd ff ff <0f> 0b e9 02 ff ff ff 49 8b 74 24 28 49 8d 94 24 c8 00 00 00
> bf 00
> [  894.140490] RSP: 0018:ffffa47ec03f3d78 EFLAGS: 00010293
> [  894.140492] RAX: 0000000000000001 RBX: ffff8eb84c818000 RCX: 000000010=
002ba00
> [  894.140494] RDX: 0000000037600001 RSI: 0000000000000083 RDI: ffff8eb92=
ec9ee40
> [  894.140496] RBP: ffffa47ec03f3da0 R08: 0000000000000000 R09: 000000000=
0000010
> [  894.140498] R10: ffff8eb801705680 R11: fefefefefefefeff R12: ffff8eb74=
54b8810
> [  894.140499] R13: ffff8eb746deb988 R14: ffff8eb746deb980 R15: ffff8eb84=
c818000
> [  894.140501] FS:  0000000000000000(0000) GS:ffff8eb9a7355000(0000)
> knlGS:0000000000000000
> [  894.140503] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  894.140505] CR2: 00002d9401d60018 CR3: 0000000010a40006 CR4: 000000000=
03726f0
> [  894.140507] Call Trace:
> [  894.140509]  <TASK>
> [  894.140512]  __ib_process_cq+0x8e/0x190 [ib_core]
> [  894.140530]  ib_cq_poll_work+0x2f/0x90 [ib_core]
> [  894.140545]  process_scheduled_works+0xd4/0x430
> [  894.140554]  worker_thread+0x12a/0x270
> [  894.140558]  kthread+0x10d/0x250
> [  894.140564]  ? __pfx_worker_thread+0x10/0x10
> [  894.140567]  ? __pfx_kthread+0x10/0x10
> [  894.140571]  ret_from_fork+0x11a/0x160
> [  894.140574]  ? __pfx_kthread+0x10/0x10
> [  894.140577]  ret_from_fork_asm+0x1a/0x30
> [  894.140584]  </TASK>
> [  894.140585] ---[ end trace 0000000000000000 ]---
> [  894.154363] ------------[ cut here ]------------
> [  894.154367] WARNING: CPU: 3 PID: 5543 at
> fs/smb/server/transport_rdma.c:1728 smb_direct_cm_handler+0x121/0x130
> [ksmbd]
> [  894.154384] Modules linked in: ksmbd cmac nls_utf8 nls_ucs2_utils
> libarc4 nls_iso8859_1 snd_hda_codec_intelhdmi snd_hda_codec_hdmi
> snd_hda_codec_alc882 snd_hda_codec_realtek_lib snd_hda_codec_generic
> rpcrdma intel_rapl_msr rdma_ucm intel_rapl_common snd_hda_intel
> ib_iser snd_hda_codec intel_uncore_frequency
> intel_uncore_frequency_common snd_hda_core intel_tcc_cooling
> x86_pkg_temp_thermal intel_powerclamp snd_intel_dspcfg libiscsi
> snd_intel_sdw_acpi coretemp scsi_transport_iscsi snd_hwdep kvm_intel
> i915 snd_pcm ib_umad rdma_cm snd_seq_midi ib_ipoib kvm
> snd_seq_midi_event iw_cm snd_rawmidi ghash_clmulni_intel ib_cm
> aesni_intel snd_seq mei_hdcp drm_buddy rapl snd_seq_device eeepc_wmi
> asus_wmi snd_timer intel_cstate ttm snd drm_client_lib
> drm_display_helper sparse_keymap soundcore platform_profile mxm_wmi
> wmi_bmof joydev mei_me cec acpi_pad mei rc_core drm_kms_helper
> input_leds i2c_algo_bit mac_hid sch_fq_codel msr parport_pc ppdev lp
> nfsd parport auth_rpcgss binfmt_misc nfs_acl lockd grace drm sunrpc
> ramoops efi_pstore
> [  894.154456]  reed_solomon pstore_blk pstore_zone autofs4 btrfs
> blake2b_generic xor raid6_pq mlx5_ib ib_uverbs ib_core hid_generic uas
> usbhid hid r8169 i2c_i801 usb_storage i2c_mux i2c_smbus mlx5_core
> realtek ahci mlxfw psample libahci video wmi [last unloaded: ksmbd]
> [  894.154483] CPU: 3 UID: 0 PID: 5543 Comm: kworker/3:6 Tainted: G
>     W           6.18.0-rc5+ #1 PREEMPT(voluntary)
> [  894.154487] Tainted: [W]=3DWARN
> [  894.154488] Hardware name: System manufacturer System Product
> Name/H110M-K, BIOS 3601 12/12/2017
> [  894.154490] Workqueue: ib_cm cm_work_handler [ib_cm]
> [  894.154499] RIP: 0010:smb_direct_cm_handler+0x121/0x130 [ksmbd]
> [  894.154507] Code: e7 e8 13 b1 ef ff 44 89 e1 4c 89 ee 48 c7 c7 80
> d7 59 c1 48 89 c2 e8 2e 4d ef c3 31 c0 5b 41 5c 41 5d 41 5e 5d c3 cc
> cc cc cc <0f> 0b eb a5 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
> 90 90
> [  894.154510] RSP: 0018:ffffa47ec1b27c00 EFLAGS: 00010206
> [  894.154512] RAX: ffffffffc1304e00 RBX: ffff8eb89ae50880 RCX: 000000000=
0000000
> [  894.154514] RDX: ffff8eb730960000 RSI: ffffa47ec1b27c60 RDI: ffff8eb74=
54b9400
> [  894.154515] RBP: ffffa47ec1b27c20 R08: 0000000000000002 R09: ffff8eb73=
0b8c18b
> [  894.154517] R10: 0000000000000001 R11: 0000000000000001 R12: 000000000=
0000009
> [  894.154518] R13: ffff8eb7454b9400 R14: ffff8eb7454b8810 R15: ffff8eb81=
5c43000
> [  894.154520] FS:  0000000000000000(0000) GS:ffff8eb9a7455000(0000)
> knlGS:0000000000000000
> [  894.154522] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  894.154523] CR2: 00007fe1310e99d0 CR3: 0000000010a40005 CR4: 000000000=
03726f0
> [  894.154525] Call Trace:
> [  894.154527]  <TASK>
> [  894.154530]  cma_cm_event_handler+0x27/0xd0 [rdma_cm]
> [  894.154541]  cma_ib_handler+0x99/0x2e0 [rdma_cm]
> [  894.154551]  cm_process_work+0x28/0xf0 [ib_cm]
> [  894.154557]  cm_queue_work_unlock+0x41/0xf0 [ib_cm]
> [  894.154563]  cm_work_handler+0x2eb/0x25b0 [ib_cm]
> [  894.154568]  ? pwq_activate_first_inactive+0x52/0x70
> [  894.154572]  ? pwq_dec_nr_in_flight+0x244/0x330
> [  894.154575]  process_scheduled_works+0xd4/0x430
> [  894.154579]  worker_thread+0x12a/0x270
> [  894.154581]  kthread+0x10d/0x250
> [  894.154585]  ? __pfx_worker_thread+0x10/0x10
> [  894.154587]  ? __pfx_kthread+0x10/0x10
> [  894.154590]  ret_from_fork+0x11a/0x160
> [  894.154593]  ? __pfx_kthread+0x10/0x10
> [  894.154596]  ret_from_fork_asm+0x1a/0x30
> [  894.154602]  </TASK>
> [  894.154603] ---[ end trace 0000000000000000 ]---
> [  894.154931] ksmbd: smb_direct: disconnected
> [  894.157278] ksmbd: smb_direct: disconnected
>
> I guess sc->first_error is already set and sc->status
> is thus unexpected, so this should avoid the WARN[_ON]_ONCE()
> if sc->first_error is already set and have a usable error path.
>
> While there set sc->first_error as soon as possible.
>
> Fixes: e2d5e516c663 ("smb: server: only turn into SMBDIRECT_SOCKET_CONNEC=
TED when negotiation is done")
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  fs/smb/server/transport_rdma.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdm=
a.c
> index e2be9a496154..97b6f68dbf8e 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -231,6 +231,9 @@ static void smb_direct_disconnect_rdma_work(struct wo=
rk_struct *work)
>         struct smbdirect_socket *sc =3D
>                 container_of(work, struct smbdirect_socket, disconnect_wo=
rk);
>
> +       if (sc->first_error =3D=3D 0)
> +               sc->first_error =3D -ECONNABORTED;
> +
>         /*
>          * make sure this and other work is not queued again
>          * but here we don't block and avoid
> @@ -241,9 +244,6 @@ static void smb_direct_disconnect_rdma_work(struct wo=
rk_struct *work)
>         disable_delayed_work(&sc->idle.timer_work);
>         disable_work(&sc->idle.immediate_work);
>
> -       if (sc->first_error =3D=3D 0)
> -               sc->first_error =3D -ECONNABORTED;
> -
>         switch (sc->status) {
>         case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
>         case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
> @@ -284,9 +284,13 @@ static void smb_direct_disconnect_rdma_work(struct w=
ork_struct *work)
>         smb_direct_disconnect_wake_up_all(sc);
>  }
>
> +#define __SMBDIRECT_SOCKET_DISCONNECT(__sc) smb_direct_disconnect_rdma_c=
onnection(__sc)
>  static void
>  smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
>  {
> +       if (sc->first_error =3D=3D 0)
> +               sc->first_error =3D -ECONNABORTED;
> +
>         /*
>          * make sure other work (than disconnect_work) is
>          * not queued again but here we don't block and avoid
> @@ -296,9 +300,6 @@ smb_direct_disconnect_rdma_connection(struct smbdirec=
t_socket *sc)
>         disable_work(&sc->idle.immediate_work);
>         disable_delayed_work(&sc->idle.timer_work);
>
> -       if (sc->first_error =3D=3D 0)
> -               sc->first_error =3D -ECONNABORTED;
> -
>         switch (sc->status) {
>         case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
>         case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
> @@ -639,7 +640,11 @@ static void recv_done(struct ib_cq *cq, struct ib_wc=
 *wc)
>                         return;
>                 }
>                 sc->recv_io.reassembly.full_packet_received =3D true;
> -               WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_NEGOTIATE_N=
EEDED);
> +               if (SMBDIRECT_CHECK_STATUS_WARN(sc, SMBDIRECT_SOCKET_NEGO=
TIATE_NEEDED)) {
> +                       put_recvmsg(sc, recvmsg);
> +                       smb_direct_disconnect_rdma_connection(sc);
> +                       return;
> +               }
This will result in the following warning...

[  309.560964] ------------[ cut here ]------------
[  309.560973] expected[NEGOTIATE_NEEDED] !=3D RDMA_CONNECT_RUNNING
first_error=3D0 local=3D192.168.0.200:445 remote=3D192.168.0.100:60445
[  309.561034] WARNING: CPU: 2 PID: 78 at transport_rdma.c:643
recv_done+0x2fa/0x3d0 [ksmbd]
[  309.561086] Modules linked in: cmac nls_utf8 ksmbd(OE) libdes
nls_ucs2_utils libarc4 nls_iso8859_1 snd_hda_codec_intelhdmi
snd_hda_codec_hdmi snd_hda_codec_alc882 snd_hda_codec_realtek_lib
rpcrdma snd_hda_codec_generic intel_rapl_msr intel_rapl_common
snd_hda_intel intel_uncore_frequency rdma_ucm
intel_uncore_frequency_common snd_hda_codec ib_iser intel_tcc_cooling
x86_pkg_temp_thermal intel_powerclamp snd_hda_core libiscsi
snd_intel_dspcfg coretemp scsi_transport_iscsi ib_umad
snd_intel_sdw_acpi ib_ipoib i915 kvm_intel rdma_cm snd_hwdep kvm
mei_hdcp iw_cm snd_pcm ib_cm snd_seq_midi ghash_clmulni_intel
drm_buddy snd_seq_midi_event aesni_intel ttm drm_client_lib
snd_rawmidi eeepc_wmi rapl drm_display_helper asus_wmi intel_cstate
snd_seq sparse_keymap snd_seq_device platform_profile wmi_bmof mxm_wmi
joydev input_leds cec mei_me acpi_pad mei rc_core snd_timer
drm_kms_helper snd i2c_algo_bit soundcore mac_hid sch_fq_codel msr
parport_pc ppdev nfsd lp auth_rpcgss parport nfs_acl lockd binfmt_misc
grace drm sunrpc ramoops
[  309.561362]  pstore_blk efi_pstore pstore_zone reed_solomon autofs4
btrfs blake2b_generic xor raid6_pq mlx5_ib ib_uverbs ib_core
hid_generic usbhid uas hid usb_storage mlx5_core ahci r8169 i2c_i801
i2c_mux i2c_smbus mlxfw realtek libahci psample video wmi [last
unloaded: ksmbd]
[  309.561463] CPU: 2 UID: 0 PID: 78 Comm: kworker/2:1H Tainted: G
      OE       6.18.0-rc5+ #1 PREEMPT(voluntary)
[  309.561479] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
[  309.561483] Hardware name: System manufacturer System Product
Name/H110M-K, BIOS 3601 12/12/2017
[  309.561490] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
[  309.561567] RIP: 0010:recv_done+0x2fa/0x3d0 [ksmbd]
[  309.561604] Code: 63 4c 24 20 83 f8 11 77 08 48 8b 14 c5 40 a8 77
c1 49 89 d9 4d 89 f8 48 c7 c6 d0 b4 77 c1 48 c7 c7 30 19 78 c1 e8 46
4f 44 d9 <0f> 0b 4c 89 e7 4c 89 f6 e8 09 f9 ff ff 4c 89 e7 e8 41 f3 ff
ff 5b
[  309.561613] RSP: 0018:ffff9c9740c2fd78 EFLAGS: 00010282
[  309.561623] RAX: 0000000000000000 RBX: ffff8d501df434a0 RCX: ffff8d50eed=
1cec8
[  309.561630] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff8d50eed=
1cec0
[  309.561636] RBP: ffff9c9740c2fda0 R08: 0000000000000003 R09: 00000000000=
00001
[  309.561642] R10: 454e5b6465746365 R11: 5f45544149544f47 R12: ffff8d501df=
40c10
[  309.561648] R13: 0000000000000000 R14: ffff8d507d681cc0 R15: ffff8d501df=
43420
[  309.561654] FS:  0000000000000000(0000) GS:ffff8d5151bd5000(0000)
knlGS:0000000000000000
[  309.561662] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  309.561668] CR2: 00005604c9ee18e8 CR3: 0000000199c40006 CR4: 00000000003=
726f0
[  309.561676] Call Trace:
[  309.561681]  <TASK>
[  309.561691]  __ib_process_cq+0x8e/0x190 [ib_core]
[  309.561759]  ib_cq_poll_work+0x2f/0x90 [ib_core]
[  309.561841]  process_scheduled_works+0xd4/0x430
[  309.561858]  worker_thread+0x12a/0x270
[  309.561870]  kthread+0x10d/0x250
[  309.561883]  ? __pfx_worker_thread+0x10/0x10
[  309.561893]  ? __pfx_kthread+0x10/0x10
[  309.561907]  ret_from_fork+0x11a/0x160
[  309.561916]  ? __pfx_kthread+0x10/0x10
[  309.561929]  ret_from_fork_asm+0x1a/0x30
[  309.561952]  </TASK>
[  309.561957] ---[ end trace 0000000000000000 ]---

>                 sc->status =3D SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
>                 enqueue_reassembly(sc, recvmsg, 0);
>                 wake_up(&sc->status_wait);
> @@ -1725,7 +1730,8 @@ static int smb_direct_cm_handler(struct rdma_cm_id =
*cm_id,
>
>         switch (event->event) {
>         case RDMA_CM_EVENT_ESTABLISHED: {
> -               WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RDMA_CONNEC=
T_RUNNING);
> +               if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKE=
T_RDMA_CONNECT_RUNNING))
> +                       break;
>                 sc->status =3D SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
>                 wake_up(&sc->status_wait);
>                 break;
> --
> 2.43.0
>
