Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DDE4D112
	for <linux-cifs@vger.kernel.org>; Thu, 11 Apr 2024 23:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878351; cv=none; b=EjC+OhMGn1rQrVlY9qDBQ/1v7BPvCKV1lFCVp/Wn7KixMR8yS9uulY0NOXnwspd0+/JC5TFw5mFas9oH4wFYBCabOBb58M+5MgKoS5k2kYrxKUVIT6uyZoq435dEF4Hc283d/8KOj5N/+fFVSnMMgGJ7LjF402tNazBYDANw9Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878351; c=relaxed/simple;
	bh=HScu2phGiISqwqvCIDJ5N1hFSLxxiQTAi0+kDzjYKag=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Ol/grtCxq3DNeCTxNN7kIc/a1G2dwQmdlSbEyts2DI1JCDeYxEWhccPG2VYmsSfSzuBMJiYxOANH1240db/4sMlZpZny1yN+QCgij6ZEzbSod44I+x72IdxJQiCz2g77iLDvrmzw5DmXSASmO51TGCXamYzoENxhVJlWNw0ZRYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MDUTUCCE; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MDUTUCCE"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-434b5abbb0dso60881cf.0
        for <linux-cifs@vger.kernel.org>; Thu, 11 Apr 2024 16:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712878349; x=1713483149; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2VasArrAIi3vEOfe1gTg8tRtoHzd3HYlNfh4lwb85DE=;
        b=MDUTUCCEY6G5tVLDSgbMUYyVlf64MsmTme3RnY7F0FSWAdrJeYhRIrYowSNfuZ11gZ
         qykpVog4YxIfDaQZQwTxIsQgwmLftFD1IjEPa8WgyugAeuke1NiszU5EggS5HiwuJrGZ
         ofWlDpenp07YfQRhntQF9DcPUW33ImqiVOJa9LtnNS94BuqqneEWgq7p8FS7Z4MRql2a
         WgyFaf9MEZRd8r//daEkJWxRjIqb1HzKfkDktYilR0xxeKB6io+2ONAvC5bNQY1PLyO4
         TLgGT/Spnwvd3LTU24/ypkz2wN2k9HLcMQ2fItRdc3jWpeh5LA2RDMrsDP+Er3ISjdr8
         Jicw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712878349; x=1713483149;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2VasArrAIi3vEOfe1gTg8tRtoHzd3HYlNfh4lwb85DE=;
        b=haYRLiOcWvTiyFxZ4190vZUgxWqwMsBxMXzCp23nbfp+hCRZkht4yKRfNoE7ujtDAc
         rzCNimzQ/HDVHVydiwRMDoMdzIsx9wgzCFp2t9+ZS18dVK50tfPGcWeRg85+cl+BF1xZ
         0J1e35VcV4tX1hgccPAvZFzLM8BUvAZL3aRSi+FUTuqvSDAULCiEtAr74v2QlIAr0yyt
         CyWN/mfvtiodz5hoxwAm0RvtnRE4uunubH2P/yeAJPU4hfZgZuAkFpabRZkBeZXHY+nx
         2PzNR78SbRoliKVTH8I7Fm275uytMfmPa/bhLDjI3OyKUXRF9ZlzosgcpTga570YIMkq
         a5xA==
X-Gm-Message-State: AOJu0Yy4l5LCMbbwKAPXbjIY9nxF8inXHj7zhEN2CWQgxXik684LJRKj
	RPbM0bhCz1++1fPp0DE0UlISPjwrfB3zA6koXTq97cLjudq1wO6fj7wITxjoOnu79xgRAO0P4sn
	sRBMTQinqN+xc7aVD/kiIlxtjKWZe+wCYF8bSZ4oUvbv31zImspGV
X-Google-Smtp-Source: AGHT+IGj8YNf1zB6FYt2GlGOcgHAtQ6CVnqf0jq/5miLym51TAECttXO864KG0bmymlpPxQ8uvgzCIf1VLDEvFAYvYY=
X-Received: by 2002:a05:622a:1b94:b0:434:4a49:da75 with SMTP id
 bp20-20020a05622a1b9400b004344a49da75mr48079qtb.11.1712878348693; Thu, 11 Apr
 2024 16:32:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Chenglong Tang <chenglongtang@google.com>
Date: Thu, 11 Apr 2024 16:32:17 -0700
Message-ID: <CAOdxtTbv9g4tW4RM9N-k_4C2HevQQNW9-2_7gKcFR51cjWbHEg@mail.gmail.com>
Subject: kernel panic caused by recent changes in fs/cifs
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, developers,

This is Chenglong Tang from the Google Container Optimized OS team. We
recently received a kernel panic bug from the customers regarding
cifs.

I sent this email again with more detailed investigation we did these
days and also because the previous one was sent to the wrong address.

Here are some steps we did in order to reproduce the issue:

Deploy GKE Cluster with the same version as the customer v1.26.13-gke.11440=
00
Deploy SMB CSI Driver Daemonset:
https://github.com/kubernetes-csi/csi-driver-smb/blob/master/docs/install-c=
si-driver-v1.12.0.md
Create SMB Server on the same cluster:
https://github.com/kubernetes-csi/csi-driver-smb/tree/master/deploy/example=
/smb-provisioner
Create Pod to create Client to create a PersistentVolume on the Samba
Server in (3): https://github.com/kubernetes-csi/csi-driver-smb/blob/master=
/deploy/example/deployment.yaml
Wait and observe to see if there are any Kernel Panics in VM Instance
logs or Node that is running the Client pod goes into NotReady state.

Unfortunately (5) did not occur, therefore we were unable to reproduce
locally. I am not sure why in the customer's environment this issue is
present.

DS for CSI SMB node is:

image: gcr.io/iaas-gcr-reg-prd-ad3d/vendor/sig-storage/smbplugin:v1.12.0
and CSI SMB Controller

image: gcr.io/iaas-gcr-reg-prd-ad3d/vendor/sig-storage/smbplugin:v1.12.0
image: gcr.io/iaas-gcr-reg-prd-ad3d/vendor/sig-storage/livenessprobe:v2.11.=
0
image: gcr.io/iaas-gcr-reg-prd-ad3d/vendor/sig-storage/csi-provisioner:v3.6=
.0
Based on this it looks like this a pretty outdated version of the

SMB CSI Controller - since 1.12.0 was released Aug 11, 2023

However, our systems should be fault tolerant and not kernel panicking
/ crashing - we should investigate this as many other customers might
run into the same issue.

We are not able to swap to newer versions of kernels(currently in
v5.10 and 5.15).



The customer said the problem occurred because of the kernel update
from v5.15.133 to v5.15.146.



Here are the recent kernel changes we make in cifs:

ded3cfd smb: client: fix OOB in smbCalcSize() by Paulo Alcantara =C2=B7 4 m=
onths ago
bfd18c0 smb: client: fix OOB in SMB2_query_info_init() by Paulo
Alcantara =C2=B7 4 months ago
f47e3f6 smb: client: fix OOB in smb2_query_reparse_point() by Paulo
Alcantara =C2=B7 4 months ago
fd3951b smb: client: fix NULL deref in asn1_ber_decoder() by Paulo
Alcantara =C2=B7 4 months ago
6bbeb39 ksmbd: fix wrong name of SMB2_CREATE_ALLOCATION_SIZE by Namjae
Jeon =C2=B7 4 months ago
e5071ae smb: client: fix potential NULL deref in parse_dfs_referrals()
by Paulo Alcantara =C2=B7 4 months ago
d2bafe8 cifs: Fix non-availability of dedup breaking generic/304 by
David Howells =C2=B7 4 months ago
bb08df4 smb3: fix caching of ctime on setxattr by Steve French =C2=B7 5 mon=
ths ago
b4329a3 smb3: fix touch -h of symlink by Steve French =C2=B7 6 months ago
4968c2a cifs: fix check of rc in function generate_smb3signingkey by
Ekaterina Esina =C2=B7 5 months ago
8d725bf cifs: spnego: add ';' in HOST_KEY_LEN by Anastasia Belova =C2=B7 5 =
months ago
8e3cdab smb3: correct places where ENOTSUPP is used instead of
preferred EOPNOTSUPP by Steve French =C2=B7 7 months ago


Our first diagnosis is that we think the problem might be caused by
memory corruption. From the assembly code we can see that

chenglongtang@vm01:~/cos/src/third_party/kernel/v5.15$ echo "Code: d7
49 89 f4 48 89 fb e8 1c 42 fb d3 48 83 f8 03 72 5f 49 89 c5 8a 03 3c
5c 74 04 3c 2f 75 52 49 8b 3c 24 48 8b 05 9e d6 04 00 <48> 8b 30 e8 56
45 fb d3 85 c0 75 64 48 89 df be c0 0c 00 00 e8 55" |
scripts/decodecode
Code: d7 49 89 f4 48 89 fb e8 1c 42 fb d3 48 83 f8 03 72 5f 49 89 c5
8a 03 3c 5c 74 04 3c 2f 75 52 49 8b 3c 24 48 8b 05 9e d6 04 00 <48> 8b
30 e8 56 45 fb d3 85 c0 75 64 48 89 df be c0 0c 00 00 e8 55
All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:   d7                      xlat   %ds:(%rbx)
   1:   49 89 f4                mov    %rsi,%r12
   4:   48 89 fb                mov    %rdi,%rbx
   7:   e8 1c 42 fb d3          call   0xffffffffd3fb4228
   c:   48 83 f8 03             cmp    $0x3,%rax
  10:   72 5f                   jb     0x71
  12:   49 89 c5                mov    %rax,%r13
  15:   8a 03                   mov    (%rbx),%al
  17:   3c 5c                   cmp    $0x5c,%al
  19:   74 04                   je     0x1f
  1b:   3c 2f                   cmp    $0x2f,%al
  1d:   75 52                   jne    0x71
  1f:   49 8b 3c 24             mov    (%r12),%rdi
  23:   48 8b 05 9e d6 04 00    mov    0x4d69e(%rip),%rax        # 0x4d6c8
  2a:*  48 8b 30                mov    (%rax),%rsi              <--
trapping instruction
  2d:   e8 56 45 fb d3          call   0xffffffffd3fb4588 #if
(unlikely(strcmp(cp->charset, cache_cp->charset))) {
  32:   85 c0                   test   %eax,%eax
  34:   75 64                   jne    0x9a
  36:   48 89 df                mov    %rbx,%rdi
  39:   be c0 0c 00 00          mov    $0xcc0,%esi
  3e:   e8                      .byte 0xe8
  3f:   55                      push   %rbp
The trapping happened before the call of 0xffffffffd3fb4588 (strcmp)
and mov (%rax),%rsi is for the second argument of strcmp. And from the
backtrace I posted, we can see that rax is ffffffff00000000, which was
corrupted and that caused the segmentation fault.



We checked that it's impossible for cache_cp to be NULL and
cache_cp->charset should have a value because load_nfs_default will
definitely return a non-NULL value. That's why we believe it should be
caused by some changes related to the memory free/allocation that
corrupted the static table.



I can't narrow down anymore and am still working on it. Feel free to
share thoughts with us.



Best,



Chenglong
