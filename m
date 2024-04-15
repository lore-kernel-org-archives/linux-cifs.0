Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A47071B4B
	for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 13:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713186811; cv=none; b=gyAMSEv4tA1xkZOsXuVDqNjmvda8ZwCLFywG/UaM+RAAfy7o2N6Y64whbgRxqEItrUW0Beuh8lrpqMi1aSpZ11j68yPLwGGVPfKMPcqi5BZaEZGmFfCxngBpAH+WZC43Nl0cx4KhVDjW7xidY11aoj1m8u4GL34XLMqqGzrT9vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713186811; c=relaxed/simple;
	bh=IRqU7aEnWTQgD4PWqWv2bfzgmlFYiJYt10aBiZiWwgI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=re6x5upmYfGpX3YeTDwfrE8AsetnkZzhVxDoPz5ztsxqi0AcRIHWl0igXBqOXKPo+MZPZbGR15r5cm9fW1ZN1uGJBKu/kb9XqgXUep/3QvhcqBaHUFDhWiISD8kxP2Jvgh6WVpXBrbSTrWnzYtL4T8ruVYUCrfM/j/1djqcGA74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b=uSYflAHW; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b="uSYflAHW"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4187731a547so3289415e9.0
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 06:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1713186805; x=1713791605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dUTLBv7vFXfCalqFQ7tCWodMlG+9YsOcV0PKdvpTKMg=;
        b=uSYflAHWpb3ZYe7fxTX9K6kiMqWmkQkfSM/Y7ahpsdiq+L0Ku0I88es1rh8Qmwvz/p
         G4INaMiMcwQQ/D/ERdZ2e/kxg8AVn15Uc8bGN2aKk8M6BQ3yn4h58iMxxpEzrIhcZkPQ
         fis++s2lNrdDQm5tJcvCuzD4VnPIuVd9U0pvtVq6DC/2SUjpkTzTXM8bYY8pHQwoqR0s
         WhDDAYjxR8oXj5/wkyLz+bptl8Wu44mkZddchYJ+fhgYj2xYIWwdo9sAhUF3QY+Or2qI
         CR+zImuk5iKT+iQStPaPhALoHVljCyBwdeb1mvpoJETToxFVSa3hGVBkPHVoCT7tXW4I
         CHNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713186805; x=1713791605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dUTLBv7vFXfCalqFQ7tCWodMlG+9YsOcV0PKdvpTKMg=;
        b=udVYhVjY5AOLSbzPndHgCXMkEXWjtytw5buzzSc/3lujtsWsmpmCo6uHGu+zO9ehqR
         JhnPn59LGD/DRBsohYiG0EoZnOOflPgu+NegL4duvHhXEif34veHjwr5kwrYWqKMLoCj
         3ymxE8hzP1ZqOUMmfhx/+GFeOrHKAsvK/6bm9AYEJScrGBtSdKNhrBsW24Hh2ErDNw/Z
         +T0/vNjdsB9cvIOLjYUxZ4HFumPSGwk1th6ocSU24+Te/a/xAey20QmzInWHQ0iITaP9
         pcMwQPOOZdy1ZG2jDbMsuQsU6oXTTctBPxm27ht4DObPOUqDhambw54U+MI1Dms8Fq+0
         ZIvg==
X-Gm-Message-State: AOJu0Yy35FneiNq/Jfi+u1VoOCEWHYKVmLzi0r5iRoYQkFY0ownj53Vn
	SNq2vxonVwTEbr59ZLPSjKAerg5EoYp+pdE/QhPEuJ9HYgomoUKOvo+ylS6Pjt4=
X-Google-Smtp-Source: AGHT+IElLqfICeVJfs66TfES7e8sckKhzB/iGutZFrWaT6RIgLsM3LsFmxL62pm5sTTKvv/MWTHPNg==
X-Received: by 2002:a05:600c:1553:b0:418:4bec:151f with SMTP id f19-20020a05600c155300b004184bec151fmr3073675wmg.33.1713186804819;
        Mon, 15 Apr 2024 06:13:24 -0700 (PDT)
Received: from odysseia.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id q4-20020adff504000000b0034635bd6ba5sm12018389wro.92.2024.04.15.06.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 06:13:24 -0700 (PDT)
From: Marios Makassikis <mmakassikis@freebox.fr>
To: linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org,
	mmakassikis@freebox.fr
Subject: [PATCH v2] ksmbd: clear RENAME_NOREPLACE before calling vfs_rename
Date: Mon, 15 Apr 2024 15:12:48 +0200
Message-Id: <20240415131247.2162106-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAKYAXd_8b00geiawuUQ3F4htQvucjH7KGpbOFV1Js7Pwf-JQig@mail.gmail.com>
References: <CAKYAXd_8b00geiawuUQ3F4htQvucjH7KGpbOFV1Js7Pwf-JQig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

File overwrite case is explicitly handled, so it is not necessary to
pass RENAME_NOREPLACE to vfs_rename.

Clearing the flag fixes rename operations when the share is a ntfs-3g
mount. The latter uses an older version of fuse with no support for
flags in the ->rename op.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
v2 change:

fix checkpatch warning:
  WARNING: Block comments use a trailing */ on a separate line

 fs/smb/server/vfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 22f0f3db3ac9..51b1b0bed616 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -754,10 +754,15 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 		goto out4;
 	}
 
+	/*
+	 * explicitly handle file overwrite case, for compatibility with
+	 * filesystems that may not support rename flags (e.g: fuse)
+	 */
 	if ((flags & RENAME_NOREPLACE) && d_is_positive(new_dentry)) {
 		err = -EEXIST;
 		goto out4;
 	}
+	flags &= ~(RENAME_NOREPLACE);
 
 	if (old_child == trap) {
 		err = -EINVAL;
-- 
2.34.1

