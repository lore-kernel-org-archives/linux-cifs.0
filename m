Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB611EA65;
	Wed, 11 Jun 2025 01:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749605499; cv=none; b=bL8xecHVju34MKcUdLWaQWyWeO45v52Tw9JKI3eJtO9ToLNVUpPkZCfopE9P9wmSDsIpiwILRE7sNQFMIAVrmbYF5TtAZkIkxpfBzLmxae5VYJwPbIjxUgoBlQR4dpsaCdZXJf4B+6TkOrUMqKJrlj3A06HKw1ZIGM0KicWkWuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749605499; c=relaxed/simple;
	bh=a5ZvgIfN3OKxFjLTf2AnMkbOIVrM7et3+35m+Z/toVQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=OrJx2uKLULjLO3L8yxqwSSMATyGngmmKzjZbPJsbMPO93NatFz1OPGeWiEV/zokdpWrenU8yxIrHnvWk7B94C84j8E65UgFjILLlBAWk8iPSyWMqv4eeDuESj/2A7LzYtrv/h8IyZ8XMboFg3fITH7P5G1d2JF5Xss3LcqNRDs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYGA0xzl; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYGA0xzl"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-32add56e9ddso49589921fa.2;
        Tue, 10 Jun 2025 18:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749605494; x=1750210294; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vraTKiNI8477CY05dFluHmdT9xg40IS+eMCdDurmLVQ=;
        b=PYGA0xzlRcT3xxVYXJm4C4y0zk+yxCqAIwYuZRabKdQEjV+YJSWp8xiDRS5MWVm+8Y
         JG2j+3MNmhu847j5I2jbZtuMmjgzjYxVGqwxNLypOB8gDHe15SuDXJq7fsUa0LeNvqgv
         mDqCrnVbShHUAgYzmRgAJE+wLsjKF+AOIGELCvx5Shj9UZjopF/oG9+4wf99QI7EnZVm
         GzL4MiTUkvyzlzxFNF8XTdlmYgfO+vloXig6aA26dFSyihImm1C+nJYW5eKsb57bso0T
         h6o0s0NsITauGEWzr2ylwQesMsz2rd7F97+jt0lT3HOGHEr4FPI+wdpXzPVYbS6Vj2/d
         5edA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749605494; x=1750210294;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vraTKiNI8477CY05dFluHmdT9xg40IS+eMCdDurmLVQ=;
        b=BJG8dXfJ/s4aFWu25Wm4WsccTlm+nLH5QX+Fpv81f6v2yi4L5o1M6yf6qa2N3AWA0L
         oskdJj2oOMyTFYgiNCdxh7/7i0IoOuGNV/an7leyg2CzN43G9GOb3mi4d8Jj3oSOpzqe
         W6RTnM3Rd52AdAk14DklsBw+trypwv4c6R/Tkx5UDvK3f0srO91mmZwk3Brr14dv1RKE
         kMGBZPHBvAMEfDKWATSLfb+O03dxM3Qc2/MHhyglQceQapDf6zK17TqAvyZnUEegCQR2
         sMk/pavYvmwcxXrk5QT3xgkBryhVHDhQI4+E2iFEKBd7R9Fp7mfFAzRCPv5gKLfyiD7o
         INwg==
X-Forwarded-Encrypted: i=1; AJvYcCWdykWdP/9Czr/qLrDDK3Y12Od1edARSo5CgAPtZsGKamDrTcgMsT75wTb1SNQGz/P69qAOcCunDF74HpQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkKI6P4nsJM1H8e3xFGuUykzm9vcoGCArJDpsS5J8uvK9k777U
	gNPe3ymzUMsS5QPlSmyqGOPqnLOfbtg2CiumioiYFM75lEj8eehhdR4KHa5AVLuTnRzzWml1P4O
	PkQkVKPY1ofA3O0J2dJZC4d8ob3pT5mFpO+c5
X-Gm-Gg: ASbGnctBc7A4vAfiWJACVwoyfZyfFKiC9hlgdocTD/v8wlHgyDKbnecLx1ELC9TuGkb
	KlulAfKDWG8fIoVAfuzl9ubidsAqg3BT+NCWJsJQPDa0d+yfXt91CGxQpFwCNaV5RXDpMU3wiWV
	gZVK2n/REJXk8CGE7xOmHHQ0EGqjBeYj5zxGNjXyX9KJQie3KSMm+IwtXyoXG78g7OCpQhO5iQW
	g7GIg==
X-Google-Smtp-Source: AGHT+IE4rW7D/o8QA3IDLlv5DmCcDPwX0EnbcKt6buiNsiHyuUDZPtlMGLIrt5C7qvE23puW3c5nLgzUJcd/ebf9X7I=
X-Received: by 2002:a2e:bc11:0:b0:32a:8bf4:3a81 with SMTP id
 38308e7fff4ca-32b22285b8dmr2578301fa.5.1749605493624; Tue, 10 Jun 2025
 18:31:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 10 Jun 2025 20:31:22 -0500
X-Gm-Features: AX0GCFtn3fjSd3bm0PUue66pR4M9D8LAwg1yDVZX5nsDQ7DwECVdOQclinbY2h4
Message-ID: <CAH2r5mt_wPk99ns95oV1tjo62VEmw+zCkoxY=8otNNhV=pnX1A@mail.gmail.com>
Subject: [ANNOUNCE] cifs-utils release 7.4
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Cc: Pavel Shilovsky <piastryyy@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

A new update, version 7.4, of cifs-utils has been released today.
Users of cifs-utils version 7.3 on older kernels are encouraged to
update to 7.4 since it includes a fix for a mount problem with version
7.3 of cifs-utils on older kernels when using namespaces.

Links:

webpage: https://wiki.samba.org/index.php/LinuxCIFS_utils
tarball: https://download.samba.org/pub/linux-cifs/cifs-utils/
git: git://git.samba.org/cifs-utils.git
gitweb: http://git.samba.org/?p=cifs-utils.git;a=summary


Detailed list of changes since version 7.3 was released
----------------------------------------------------------------
Enzo Matsumiya (1):
      mount.cifs: retry mount on -EINPROGRESS

Henrique Carvalho (1):
      cifs.upcall: correctly treat UPTARGET_UNSPECIFIED as UPTARGET_APP

Paulo Alcantara (1):
      cifs.upcall: fix memory leaks in check_service_ticket_exits()

Pavel Shilovsky (1):
      cifs-utils: bump version to 7.4

Z. Liu (2):
      getcifsacl, setcifsacl: use <libgen.h> for basename
      cifscreds: use <libgen.h> for basename



-- 
Thanks,

Steve
