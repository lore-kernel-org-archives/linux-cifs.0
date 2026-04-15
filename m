Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2B2378D8E
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 11:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776252321; cv=none; b=qRwbyqRVtpD5gczKAhzQukjy1iFM2MkAODpls57T0dQomw5KoWZwcIxDgit/t2Lj08XTx90+rvfnAciL18S6lUwU8ATQ9zb8rbvDEV0qArZ/ALE5sfmeP0WnRrUI4HmFKhyhCGp7j3/XQxZrpB8h+3z++sRfimlQU9pgNLoNEe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776252321; c=relaxed/simple;
	bh=VQsTM+mzGxb1tEMnoq0cXierV1ZHH1kctt8ri+qeVbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APi6VQpaEn94FRqFEHkXLCMNlJvSR+k3Rt7ZOub/hCVMxwH3BMOTMh68BpcwWKZ9YiKyuG6Db0Ei0rkFnswPp0KqgoKJdLHrv6IjVmeAuwEWxzBbeO6octreysEllgSFwS5HMj86g9onB5/Bl3gt7Opvu/vlxB/l1VZQYhkRkQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZdKI6y89; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZdKI6y89"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-506a6cf8242so50631161cf.1
        for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 04:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776252319; x=1776857119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJ6fVrO3ohxiKYcaHCxp2wzI9fHSCKIoqnFp5q+kMYA=;
        b=ZdKI6y89qzlqk+Fsg6F2qBDMkDLoq5M2jjacPi4sGcCKblCMHTRdt4+emp0uvuTCae
         MKWEY5iI3TMS48uBDiAdJH8UkKxMJRW29361TJL6BEKrXY9BvrUcPa7NSBhPxvexgWlb
         EmMpTIYoHudPdz4YLkxx1oDIQ0Iyq5BDhAMjEr73RaqD/5apnqRJIrDGlfqstFE3149X
         bapskrxzkZkl9idiA3fg4Oon0lWZ/py6ymFxhZTkwBpZv3/Rls1OcxXpJt443DS7Bg9k
         nama5G8ouKPOCjCLM8ZrklHycDSw1IPxizxc0wrQoYX5ycTmMKxO4rWF/Ah1kHriNViT
         2BoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776252319; x=1776857119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BJ6fVrO3ohxiKYcaHCxp2wzI9fHSCKIoqnFp5q+kMYA=;
        b=T1BS2atMnbffgGP9Bs8SHrkuFed2W0NrwR3VLDm1lFK9gCCE4PhTVyVcX1yNgsX3bl
         cpmBA/4UrVzgmKuNkvgvP3XDvyooY1396wbVZjrHNK803UPeDvpIPPE07JDX19UMhwHG
         2WYlYc9feaKVFRMBKCN76HDv5svehY0LGeISw114yYbXThxzAcQHvWQ0qVGrpnKAmHhi
         3B0vacxbZUccb5+UbhJWDsUoQNrfPKxpoFEkYJONlAqjn48Hdk787oePRac0+jpDirg2
         UfZ7iJn8WadCrLPhmKjUCWrLJvL/m684ctGhr2fe0yI6AJ+AxALfTXMcBdrxf4nXZcUZ
         GMGg==
X-Gm-Message-State: AOJu0YwoiywhGNAvgMGMij2MrdMfvUB/kTRu5G5h5EaZYaHOf2a6mvKT
	TDyub7CYJtmC7gSOxbufjPjfAzibvSyVj8+m+mzFLbpgG+XbG+qUhJj0/Qqedw==
X-Gm-Gg: AeBDiesIKwou1WLXiFDPjP6x66uvnOIzof3xYrlaT/Z2gg4OnwSv5ohBtiMGs9uGcKE
	Ag4A+8g+vWb6Cm5IIB8ZUoLFUWjmhQ92fiye7HrcvaVd904ip9yw2zuDH56w7vgXrkO1JNu7NO7
	7B7/tZc7nz7MTKeCzQ2gDCqsuEDynxDPXupdPv3PbNDFpgUQ82AUNAuMdv3wPNZu+PNr03aqXXr
	myBEPG6zaPwHeWqxRtJNtcJEfCDTrg9dNcir6LBtMmCp8ftXycBspaee/41+IbU0FJEaVIS3DGB
	s6RtO6u4iIPiLzX5fxtqqs6puBAbf7wnWyu6Gxela2YiHvVcHiqA5TzF37cBKz+ISpjsT4NuGy1
	r0awD4AFC/3Z+OIx/+wHQrYnJu5dzMm++Ij99xklxSG3CJ5uAdTwH9q75XEe2CRxEwLmgbXozyd
	FmE1h5EplZ+kmFGCJsgXKD1b6rdmOjUC+yClxtrYfT5vKWpDJrbXtK0r0ghsFrLBlkZ/EAz2XqS
	7TMzklD1UZwOwIR+1S0PQJeilFu9coK4gn9q4esV3FcqW9BWGTp9g==
X-Received: by 2002:ac8:7d11:0:b0:509:35d1:ca37 with SMTP id d75a77b69052e-50dd5aeef70mr330727511cf.16.1776252318729;
        Wed, 15 Apr 2026 04:25:18 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e1af9dc5fsm10621191cf.16.2026.04.15.04.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 04:25:17 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 0/2] ksmbd: harden ipc_validate_msg() and smb_check_perm_dacl()
Date: Wed, 15 Apr 2026 07:24:59 -0400
Message-ID: <20260415112501.116426-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414191533.1467353-1-michael.bommarito@gmail.com>
References: <20260414191533.1467353-1-michael.bommarito@gmail.com> <CAKYAXd9EBFBcy9bJ3=sJiYVYHAYjKYqOqD53UCJ8zWKXF0sAeg@mail.gmail.com> <CAKYAXd8B78Gde_7+Ph0cSL998k4qqs_okB0jky0m5h8i25_AGQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two ksmbd hardening patches, respun from v1 [PATCH 0/3] per Namjae's
review.

Patch 1 folds v1 1/3 and 2/3 into a single response-side validation
change in ipc_validate_msg().

Patch 2 is v1 3/3 unchanged (minimum ACE size in
smb_check_perm_dacl()).  Please let me know if there's anything
on this 2/2 you want to think through or change.

Changes since v1
----------------

v1 -> v2:

  - 1/3 + 2/3 folded into a single patch (1/2) per Namjae.
  - Dropped the hard KSMBD_IPC_MAX_PAYLOAD (4096) cap on
    RPC_REQUEST and SHARE_CONFIG_REQUEST response paths.  A 4096
    cap would regress NetShareEnumAll and other NDR enumerations
    on servers with many shares -- userspace ksmbd-tools grows
    the response buffer in 4096-byte chunks via g_try_realloc().
    Use check_add_overflow() instead so functional payload size
    is unconstrained but msg_sz cannot wrap unsigned int.
    [Namjae]
  - LOGIN_REQUEST_EXT keeps the [0, NGROUPS_MAX] bound (POSIX
    semantic limit, not an IPC transport cap).  Moved the
    pr_err() into ipc_validate_msg() so the error is reported
    at the IPC boundary. [Namjae]
  - Removed the now-redundant ngroups check and pr_err() from
    ksmbd_alloc_user() in mgmt/user_config.c.  Both call sites
    (ksmbd_login_user and the SPNEGO path in auth.c) reach
    ksmbd_alloc_user() through ksmbd_ipc_login_request_ext(),
    which now rejects negative ngroups at the IPC gate. [Namjae]
  - SPNEGO_AUTHEN_REQUEST left untouched: session_key_len and
    spnego_blob_len are both __u16 so their sum cannot wrap the
    unsigned int msg_sz. [Namjae ack]
  - 2/2 (smb_check_perm_dacl minimum ACE size) unchanged from
    v1 3/3 -- no review yet.

Threading
---------

Sent --in-reply-to v1 [PATCH 0/3] cover
(Message-ID 20260414191533.1467353-1-michael.bommarito@gmail.com)
so v2 lives under the v1 thread.

Michael Bommarito (2):
  ksmbd: validate response sizes in ipc_validate_msg()
  ksmbd: require minimum ACE size in smb_check_perm_dacl()

 fs/smb/server/mgmt/user_config.c |  6 ------
 fs/smb/server/smbacl.c           | 17 +++++++++++++----
 fs/smb/server/transport_ipc.c    | 16 +++++++++++++---
 3 files changed, 26 insertions(+), 13 deletions(-)

--
2.53.0

