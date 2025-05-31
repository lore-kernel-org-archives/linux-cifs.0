Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68832AD18
	for <linux-cifs@vger.kernel.org>; Sat, 31 May 2025 06:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748673770; cv=none; b=A/1xwpnArs01EuPDOKiomN712pKofmAvsG97L79PzLNCmlRrjbLV8TvAESCmRSEEOq2J8slzBoKZAphB79XFQDDev2yF1iR1RxnOVX9icvuEYbGgYj6AVu0W4l0VD0JcknByseaE34fAVJhcVLhYpQMjAqcY/E0mB6p+93uRJA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748673770; c=relaxed/simple;
	bh=sS0uM3OhD+hbKtDAxEcPpSLLBNKZpTuOFifPOdZQeg8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=uuLRP96hV8qLcHQ/J+axKJS8ZFwl2uTKpozJ1qt3qJKgqBUriHGtAugeR4ciISG9+Q0OO0RzUzEw/frbz/m0+kLQhuw21YcRHQ2IxSpdmyjdC1fbfnFhBPb/mVt/jDrUKnrj1Xgy32y27gnVhz4JJn9i6B4x/2XZKN1Q1uNQd+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Qh1aAlnf; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qh1aAlnf"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5532e0ad84aso3456067e87.2
        for <linux-cifs@vger.kernel.org>; Fri, 30 May 2025 23:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748673766; x=1749278566; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a2m15VUME4+FlDz3MvYLB14GmsNobVUlvHe9heHpESw=;
        b=Qh1aAlnfwxGfld6utHuF8fMtLyxESwLQ8RpNZCnIKo4Me50Chow91ELlFHyszO99mz
         f2B5ww9DquSjjzIXkt2jGUkCpnJOlZ1AzDEebc/UNO2Cbcgr7hySkoMKxdLV6Zq3O5ba
         3kWy+zCEiL3yhko3zd+8L8X0ssxHfmPSo9gUlX5qsswVM/YEVo29h59CiC3tNs7Pvx8p
         cdBrEW/JEd9yQSk2U/9hRZ9kSdaNaRW/qWjahjY8dn8f/lGzx2AdSkVySVM8Iv69DubR
         c2WhJaH03K4CS3J3YogK+PpC1f1BphggZ9Q3JGrrEZXOJ5brGzOwxONdqxzTVJLFiYzD
         2k3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748673766; x=1749278566;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a2m15VUME4+FlDz3MvYLB14GmsNobVUlvHe9heHpESw=;
        b=jA6AgXq1FVfJjiakBjYtp1h9pJiv+IZwFw5CURvG8QDYFcpSecmBnhUP9L83zBs6zp
         6RhZXVDnPiaIN2jHrQJmrU29pfxgNBBSBQwkDpXkgKKMHtOOapSOCex8sj8f3yl20eWW
         qhzgopSJrtWSCfx8+nDbCKqoyFp8C4xixFgQVb00C9rRcTNT+1IVoHNn7o7KP0hNUOUK
         2K+WAMRmr3/ZhD2KVjCg8XQwS5YCO+B4Ui6ftc6Je+jF2awyl1gEVYzhU126xwmdjvun
         awbG6aHKOCgd4g6bKodTavCcngu+9v15xm2CAL0Gam5mcDY1XIzCkdtUpXutc+H31E61
         O54Q==
X-Gm-Message-State: AOJu0Yy/O07V0YgpaGDxP9WX31YuLgRDgIh9OIHaw2tVg+eELP5Aae7E
	Eg0traNHo8yBZMFux5jpp3zXdLbV8WZD5igTB5aGlpIHmzDFXLxXPR8VUddV01GpBpn+FeSgtX6
	dF+ff
X-Gm-Gg: ASbGncuJfNrLTT6ucP6l2RHHYC8DguAfOn0GQV1kpggj18kI7wNvrfubh5e1wm68tf1
	F9Z0wVSnaICP1ld61iQ25HlexyAGB42zE2RIvvZIZ/nfhj/lzFfrscWy0mcoiT+g/5q7+WdL7FK
	O725C7mmvzvWVHhQ+kvwrkTAa1179iXdQKmKxm3Jk2QMaOHCwxpdWcHrqnTuvtF4kvB6INiDUgi
	S9uGhQQLU2YA+mUKRkV2gzzFOUZtMThinqYGR+23cLMAh4vhg2Aj/4selloQF+35OrS1x+2B+9g
	E/c0ii/7yMCaXmT8BBd0cmBJqG6x5RIRydZYeAzDbMaRhWcbrHq4xq0HsyUMfA==
X-Google-Smtp-Source: AGHT+IGz4Y80wNCkxBdVwE9TpP5iSxy5f/Fwd0NgHHXaMpWOOgka8rE4osTnkNNc0oYaqIz+tIEJiQ==
X-Received: by 2002:a05:6512:104f:b0:553:2450:5895 with SMTP id 2adb3069b0e04-55342f5212emr334553e87.4.1748673766096;
        Fri, 30 May 2025 23:42:46 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5533791cf64sm941767e87.199.2025.05.30.23.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 23:42:45 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sat, 31 May 2025 08:42:44 +0200
Subject: [PATCH] RFC: ksmbd: provide MODULE_VERSION()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org>
X-B4-Tracking: v=1; b=H4sIAOOkOmgC/x3MQQ5AMBBA0avIrE3SVoi4iliUTplQpBNCxN01l
 m/x/wNCkUmgyR6IdLLwtiboPINhsutIyC4ZjDKlKguNs4TeodziBcPmjoWQvPXGaVtXg4UU7pE
 8X/+07d73A8tmnBRkAAAA
X-Change-ID: 20250531-ksmbd-sysfs-module-efaf2d1a86ca
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Rosen Penev <rosenp@gmail.com>, Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.14.2

Adding MODULE_VERSION("1.0") to ksmbd makes /sys/modules/ksmbd
appear even when ksmbd is compiled into the kernel.

Adding a version as a way to get a module name is documented in
Documentation/ABI/stable/sysfs-module.

This is nice when you boot a custom kernel on OpenWrt because
the startup script does things such as:

[ ! -e /sys/module/ksmbd ] && modprobe ksmbd 2> /dev/null
if [ ! -e /sys/module/ksmbd ]; then
    logger -p daemon.error -t 'ksmbd' "modprobe of ksmbd "
    "module failed, can\'t start ksmbd!"
     exit 1
fi

which makes the script not work with a compiled-in ksmbd.

Since I actually turn off modules and compile all my modules
into the kernel, I can't change the script to just check
cat /lib/modules/$(uname -r)/modules.builtin | grep ksmbd
either: no /lib/modules directory.

We define the string together with the version number for
the netlink, as they probably should be in tandem. Perhaps
this is a general nice thing to do.

An option would be to change the script to proceed and
just assume the module is compiled in but it feels wrong.

Cc: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 fs/smb/server/ksmbd_netlink.h | 1 +
 fs/smb/server/server.c        | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index 3f07a612c05b40a000151cef1117b918dc5da9ea..9ae6be7c7b116ab29277074089f2305e2b243594 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -58,6 +58,7 @@
 
 #define KSMBD_GENL_NAME		"SMBD_GENL"
 #define KSMBD_GENL_VERSION		0x01
+#define KSMBD_GENL_VERSION_STRING	"1.0"
 
 #define KSMBD_REQ_MAX_ACCOUNT_NAME_SZ	48
 #define KSMBD_REQ_MAX_HASH_SZ		18
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index ab533c6029879fe8a972ebc85efc829ef0e0dcd3..332e3e39dc613d8a9077da0745eb1fb7a30b6bb5 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -632,5 +632,7 @@ MODULE_SOFTDEP("pre: aead2");
 MODULE_SOFTDEP("pre: ccm");
 MODULE_SOFTDEP("pre: gcm");
 MODULE_SOFTDEP("pre: crc32");
+/* MODULE_VERSION() Makes /sys/module/ksmbd appear when compiled-in */
+MODULE_VERSION(KSMBD_GENL_VERSION_STRING);
 module_init(ksmbd_server_init)
 module_exit(ksmbd_server_exit)

---
base-commit: 0ff41df1cb268fc69e703a08a57ee14ae967d0ca
change-id: 20250531-ksmbd-sysfs-module-efaf2d1a86ca

Best regards,
-- 
Linus Walleij <linus.walleij@linaro.org>

