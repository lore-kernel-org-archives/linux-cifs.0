Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BB12D1F7B
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 16:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447758; cv=none; b=lqNmjb69Q91fBdScHiMH5epQ0JGp5UM2xMl+aQBCVuVAjZFz6DGONLMtR/2wrTZd+72W97soi1KxqnD7JWoe7UCDfswchw2nmhGNVPubsFZXGKxHSzyMBp4lxNmyZyZ2HXxq9BCHobIgB26lu9MR2gvv/FeFmU3aqjmjnpc25kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447758; c=relaxed/simple;
	bh=h2Lm2hUVA2sBcFgfbXb/PYOwQQXuy6IBlBfxH8qb7pM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P4v7qhVvjVP/vrTy+HMc3EMlwDyOjDLqr/whRcTV7PtSc/jJihiGUW1hhBB2OKo5jr8Rl9/EFfjGKpZoiNx4Ap0XJxN+f3vooyBKo59Csb0b6X/0WI3tEARoUKvs0tKxl46Z6z0ch2baObMDGv6MINwt8xa7NHtIrQJeZ7iSU8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F4b4SZ7y; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F4b4SZ7y"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-63fd17f0cbfso1080841d50.2
        for <linux-cifs@vger.kernel.org>; Thu, 06 Nov 2025 08:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762447756; x=1763052556; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g6iYVeSXGcvyjM3JRpKgymOulFAzcTMHYkSiEoEtsfI=;
        b=F4b4SZ7ycXm0VM6B3vWK+tHFg5rHyYH+BzLW9BO9UrO0JnGBrJFvzRdzLau88Y4XX8
         JQvfUEzDVJsYvsBNSOeU3Ho/vRhL5zke/dkB7bOOioJ5AurqsqCYHlfbKrATNQXowIY0
         WcCy3CCCU+uzvR2POei1XLnJp4PMTIAdhQ8GCiYo4h3EJIt070CieEBPJKrzqbefestQ
         wWgAKDZ3L7Rh5WJmUOMtV2FCIjXTc+4fGWNtLtx76C+Dr54zASeHtgN1csatvsDDT8nW
         farBajgw2/XwQ1gESFsdZgYK1yW/KCGwd0rcULZaujBTxso4M8lQV5F91XEUyuz/l44h
         EHng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447756; x=1763052556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g6iYVeSXGcvyjM3JRpKgymOulFAzcTMHYkSiEoEtsfI=;
        b=dKag/s7qk9nfntn8maBWp94XxiZdrYYWvcKkH/d0iyrRXUHqOZV1wcRyYac0cmp6Hj
         sfYbyjrb5Q66xh/Z8UIKmO3tvrxbajxlSXQNnh38kqFxsFgUY3+8jIL+60c3LW0YqjdE
         ZXwlENQsaZ4htUKN/dHbu7GECrnVVifPw3zOMRindDDNe0HPf1j1TrQRsMN3WpDkGaWJ
         ntLs+yHgDyyo1UtmfSV++6jCpU+GJ4hj9i6+7HZAO8vYiJE2L9jfRL9aFuLAS08acvXK
         HwnhWKK1rtYl8fMRHtRqR17oWIwdxzyfTpO5DJ5o0MdDDdGe5lAjpS/Sj6QBGO3EWYh4
         V6yA==
X-Forwarded-Encrypted: i=1; AJvYcCUU/PsZwUcL6uXPPicopaSRqNEmqaWmAURpnV2RWrhkDVbp3mL1H+gfG7tY5Z+JgKXX3x//fc+5StSW@vger.kernel.org
X-Gm-Message-State: AOJu0YwsolnZ81D+jlslqXtG8xxUIm9uts7qMZgUqLoHiZW7mq2EfLhC
	TX8dLMrXeV+JQzG5z+03B7Ac1c5HhCJOiqOk5N8PhyYWVN2WWCMciWjqBbWnevXPg/iR0KVYI1B
	Q+SD9GhNn5F/nJLOT2QQ9lCiNp7OPTZw=
X-Gm-Gg: ASbGncvJOih6DFQTTmGKrVynRBRJ5XI2hsGIn3M7z96PdzknwktXgOkYYbYFbEoiPf4
	NYnLA0Wk3IG8o5eGa+4JxQW4fdCPlTngrRAzGaANmUgyjs/CCJ1SDkddIPhesd5RWsN9XKK/uGM
	s9p99kZlBX4oRhJgi0bXcaZmsu3I+zounW2qd/1X9x50NyPpn00XojBRBpnbi8sJ5GBgF5V/zNg
	cHlj0F8ZQOZX0SOfFsqJk8nL09QRisI/BX7F/z3rujO5qR4+YDSeboQffwBvtM=
X-Google-Smtp-Source: AGHT+IFuQscTf1NKDL3o3cWSZTy+neN3OAbiMdwFj3WMpUjZkafWQt3dxUJHr9QhP3lHIv2uV81wVbawW4tE2w3IVhU=
X-Received: by 2002:a05:690e:258c:b0:63f:a727:8403 with SMTP id
 956f58d0204a3-640c433e12dmr10987d50.38.1762447755719; Thu, 06 Nov 2025
 08:49:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
 <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
 <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
 <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com>
 <10023.1762446142@warthog.procyon.org.uk> <CAGypqWySt7j6-zsNX+gSNgVeC1JwcO2zY-D7UNhjquDAPN_JqA@mail.gmail.com>
In-Reply-To: <CAGypqWySt7j6-zsNX+gSNgVeC1JwcO2zY-D7UNhjquDAPN_JqA@mail.gmail.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Thu, 6 Nov 2025 08:49:04 -0800
X-Gm-Features: AWmQ_bnaqN8grlu8nB6FnJq6jTMXA4LI-L1T7nRtopov8Hy966K0hCcG47evX50
Message-ID: <CAGypqWyEZ1m21=3UB7CQt6HGX5ncRau+abMXTJ8NSVrRhPHGmw@mail.gmail.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
To: David Howells <dhowells@redhat.com>
Cc: Mark A Whiting <whitingm@opentext.com>, henrique.carvalho@suse.com, 
	Enzo Matsumiya <ematsumiya@suse.de>, Steve French <smfrench@gmail.com>, 
	Shyam Prasad <nspmangalore@gmail.com>, Paulo Alcantara <pc@manguebit.org>, 
	"Heckmann, Ilja" <heckmann@izw-berlin.de>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 8:46=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.com>=
 wrote:
>
> On Thu, Nov 6, 2025 at 8:22=E2=80=AFAM David Howells <dhowells@redhat.com=
> wrote:
> >
> > Bharath SM <bharathsm.hsk@gmail.com> wrote:
> >
> > > We are noticing the similar behavior with the 6.6 kernel, can you
> > > please submit a patch to the 6.6 stable kernel.
> >
> > What range of kernels is this patch aimed at?  Pre-netfslib conversion =
cifs
> > only?
>
> By looking at changes I think it can be applied to Pre-netfslib conversio=
n
> as most of these functions were removed after that.


But I do notice following warnings with patch:

[Thu Nov  6 16:47:23 2025] ------------[ cut here ]------------
[Thu Nov  6 16:47:23 2025] WARNING: CPU: 7 PID: 61031 at
/home/azureuser/jammy/fs/smb/client/file.c:2855
cifs_extend_writeback+0x3f8/0x5b0 [cifs]
[Thu Nov  6 16:47:23 2025] Modules linked in: cifs(OE) cmac nls_utf8
cifs_arc4 nls_ucs2_utils cifs_md4 netfs tls nvme_fabrics xt_conntrack
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_owner xt_tcpudp
nft_compat nf_tables libcrc32c nfnetlink binfmt_misc nls_iso8859_1
kvm_amd ccp kvm irqbypass crct10dif_pclmul crc32_pclmul
polyval_clmulni polyval_generic ghash_clmulni_intel sha256_ssse3
sha1_ssse3 joydev aesni_intel hid_generic hid_hyperv crypto_simd
serio_raw cryptd hv_netvsc hid hyperv_drm hyperv_keyboard dm_multipath
scsi_dh_rdac scsi_dh_emc scsi_dh_alua sch_fq_codel efi_pstore
ip_tables x_tables autofs4 [last unloaded: cifs(OE)]
[Thu Nov  6 16:47:23 2025] CPU: 7 PID: 61031 Comm: test.sh Tainted: G
      W  OE      6.8.0-1041-azure #47~22.04.1-Ubuntu
[Thu Nov  6 16:47:23 2025] Hardware name: Microsoft Corporation
Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1
08/23/2024
[Thu Nov  6 16:47:23 2025] RIP: 0010:cifs_extend_writeback+0x3f8/0x5b0 [cif=
s]
[Thu Nov  6 16:47:23 2025] Code: 0f 84 8a 00 00 00 45 31 e4 45 89 e6
41 83 fc 0e 0f 87 38 01 00 00 4e 8b b4 f5 58 ff ff ff 4c 89 f7 e8 0c
60 79 de 84 c0 75 02 <0f> 0b 31 f6 4c 89 f7 41 83 c4 01 e8 d8 61 79 de
4c 89 f7 e8 40 83
[Thu Nov  6 16:47:23 2025] RSP: 0018:ffffcb4512a3f8c8 EFLAGS: 00010246
[Thu Nov  6 16:47:23 2025] RAX: 0000000000000000 RBX: ffffcb4512a3fa68
RCX: 0000000000000026
[Thu Nov  6 16:47:23 2025] RDX: 0000000000000000 RSI: 0000000000000006
RDI: fffff4c8c7532a40
[Thu Nov  6 16:47:23 2025] RBP: ffffcb4512a3f9d8 R08: 0000000000000048
R09: 0000000000000001
[Thu Nov  6 16:47:23 2025] R10: 000000000003acc0 R11: 0000000000000001
R12: 0000000000000007
[Thu Nov  6 16:47:23 2025] R13: 0000000000000000 R14: fffff4c8c7532a40
R15: 000000000000a8d5
[Thu Nov  6 16:47:23 2025] FS:  0000715b39af7740(0000)
GS:ffff89825fd80000(0000) knlGS:0000000000000000
[Thu Nov  6 16:47:23 2025] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
[Thu Nov  6 16:47:23 2025] CR2: 00007832fd266428 CR3: 0000000185532005
CR4: 0000000000b70ef0
[Thu Nov  6 16:47:23 2025] Call Trace:
[Thu Nov  6 16:47:23 2025]  <TASK>
[Thu Nov  6 16:47:23 2025]  ? srso_alias_return_thunk+0x5/0xfbef5
[Thu Nov  6 16:47:23 2025]  ? __mod_memcg_lruvec_state+0xae/0x180
[Thu Nov  6 16:47:23 2025]  ? __entry_text_end+0x1026c9/0x1026cd
[Thu Nov  6 16:47:23 2025]  cifs_writepages_region+0xabf/0xb80 [cifs]
[Thu Nov  6 16:47:23 2025]  cifs_writepages+0xf8/0x120 [cifs]
[Thu Nov  6 16:47:23 2025]  do_writepages+0xd1/0x1b0
[Thu Nov  6 16:47:23 2025]  ? __xa_set_mark+0x65/0x90
[Thu Nov  6 16:47:23 2025]  filemap_fdatawrite_wbc+0x75/0xa0
[Thu Nov  6 16:47:23 2025]  __filemap_fdatawrite_range+0x54/0x70
[Thu Nov  6 16:47:23 2025]  filemap_write_and_wait_range+0x51/0xb0
[Thu Nov  6 16:47:23 2025]  cifs_flush+0x82/0x110 [cifs]
[Thu Nov  6 16:47:23 2025]  filp_flush+0x3c/0x90
[Thu Nov  6 16:47:23 2025]  filp_close+0x15/0x30
[Thu Nov  6 16:47:23 2025]  do_dup2+0x8a/0xe0
[Thu Nov  6 16:47:23 2025]  ksys_dup3+0xa6/0x110
[Thu Nov  6 16:47:23 2025]  __x64_sys_dup2+0x29/0xd0
[Thu Nov  6 16:47:23 2025]  ? srso_alias_return_thunk+0x5/0xfbef5
[Thu Nov  6 16:47:23 2025]  x64_sys_call+0x1dfe/0x20a0
[Thu Nov  6 16:47:23 2025]  do_syscall_64+0x7c/0x160
[Thu Nov  6 16:47:23 2025]  ? srso_alias_return_thunk+0x5/0xfbef5
[Thu Nov  6 16:47:23 2025]  ? audit_reset_context.part.0.constprop.0+0x2a9/=
0x310
[Thu Nov  6 16:47:23 2025]  ? srso_alias_return_thunk+0x5/0xfbef5
[Thu Nov  6 16:47:23 2025]  ? syscall_exit_to_user_mode_prepare+0x117/0x160
[Thu Nov  6 16:47:23 2025]  ? srso_alias_return_thunk+0x5/0xfbef5
[Thu Nov  6 16:47:23 2025]  ? syscall_exit_to_user_mode+0x81/0x220
[Thu Nov  6 16:47:23 2025]  ? srso_alias_return_thunk+0x5/0xfbef5
[Thu Nov  6 16:47:23 2025]  ? do_syscall_64+0x88/0x160
[Thu Nov  6 16:47:23 2025]  ? srso_alias_return_thunk+0x5/0xfbef5
[Thu Nov  6 16:47:23 2025]  ? srso_alias_return_thunk+0x5/0xfbef5
[Thu Nov  6 16:47:23 2025]  ? irqentry_exit_to_user_mode+0x7b/0x220
[Thu Nov  6 16:47:23 2025]  ? srso_alias_return_thunk+0x5/0xfbef5
[Thu Nov  6 16:47:23 2025]  ? irqentry_exit+0x1d/0x30
[Thu Nov  6 16:47:23 2025]  ? srso_alias_return_thunk+0x5/0xfbef5
[Thu Nov  6 16:47:23 2025]  entry_SYSCALL_64_after_hwframe+0x78/0x80
[Thu Nov  6 16:47:23 2025] RIP: 0033:0x715b3991508b
[Thu Nov  6 16:47:23 2025] Code: 73 01 c3 48 8b 0d a5 4d 10 00 f7 d8
64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa
b8 21 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 75 4d 10 00
f7 d8 64 89 01 48
[Thu Nov  6 16:47:23 2025] RSP: 002b:00007ffcee3015d8 EFLAGS: 00000246
ORIG_RAX: 0000000000000021
[Thu Nov  6 16:47:23 2025] RAX: ffffffffffffffda RBX: 000057ee9a27ff10
RCX: 0000715b3991508b
[Thu Nov  6 16:47:23 2025] RDX: 000057ee8d0734d4 RSI: 0000000000000001
RDI: 000000000000000a
[Thu Nov  6 16:47:23 2025] RBP: 00007ffcee301660 R08: 0000715b399d1460
R09: 000000000000000a
[Thu Nov  6 16:47:23 2025] R10: 0000000000000000 R11: 0000000000000246
R12: 0000000000000009
[Thu Nov  6 16:47:23 2025] R13: 0000000000000007 R14: 000000000000000a
R15: 0000000000000007
[Thu Nov  6 16:47:23 2025]  </TASK>
[Thu Nov  6 16:47:23 2025] ---[ end trace 0000000000000000 ]---
