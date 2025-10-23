Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85014184
	for <linux-cifs@vger.kernel.org>; Thu, 23 Oct 2025 22:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761259791; cv=none; b=OJKFj51VjAozS2NvuKB2KML2GnBjBo1HlKUG/OVWeRBHD9oV1+pHbLPyT0sEk6wZue/ivmzJeRylmeRNakQA0ny3QAzO1xBe4c9VlQLfnsMMUkNeAs9YXh2KPgZY5qBHniXC1bhdK/tTo+/V75/RsCw0gOxr+4nqVJihKEYO318=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761259791; c=relaxed/simple;
	bh=Axqzc4/0G4P/n0/y73ddY7I+lR0OxWCCX0ToDqiYmvk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=kp1uxujsNwdDRyURqS4oUuz0zhYvUGQNA+FakWLrVS63oXDVtArtp0jDEZtZKBKNmWOkqWewMN06bfxiSluP5qD9bjtZmRAFxhDtTCe9qZbvfYFgl/DHHOkhqW02d7GlxxVfKIucBm29BFjP4b3ryAuXdxHMpG8phA0BmSsFNSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wjrg7wX/; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wjrg7wX/"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-592f3630b69so1744615e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 Oct 2025 15:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761259788; x=1761864588; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HVKb2UzigaoUmXmZK34DM55zsTcarwtjDVQjMijNV9M=;
        b=wjrg7wX/EwBb2X3xWRF7zLpAjwrlB6bci5BN7n6rK9iIG/l+JriscT0YcdP7cJ9tJJ
         yqlbXx388Xj8YF98GXXI3iyps8mwb7BOMs5jsiHnZpjz09Eq6Zuzdnm9GID/4pJisf3G
         iog8teIZMRozpdwAxiTIJmi+hIZjeF4hXwJpcE9fedjmjbzNComPgVvm4AiQGcSl0rxo
         yqFIMJt9zCJjwawu6qEPiRQmKuQylD9z9ra+S4fuMWSL9RdhoBqfuYr83gkYk+kNI8KG
         JlOvI7p56ih2SJacsKddQSNNXj0FxxD1ctvJ3lsgJgy+0LK4DjDQ0ozcJPBXU9SQrNwn
         jEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761259788; x=1761864588;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HVKb2UzigaoUmXmZK34DM55zsTcarwtjDVQjMijNV9M=;
        b=sv0WKM+lZ+3ufzoq4b7oJagtk1G74PyrBUCjwY8lKqC+SOvdQtS97MYrn2TD0Ifk6E
         RhDFw6feZwR4SPZK4R4bbZUtB6vmrM127YyEjtzEjYvHf9pJUQTw1I6enIRGorMUxcZm
         TfnZjDjqiS+Is4Yca38Ca44y8M9/lBD6WIA3FtCbpf49VTgFCQvbvYCgmaC3f8Y/DN0s
         CNEW3yk9cLDdrgL4ik23xVK3xwIrY4RkMbCNdjHu9aJwCwtpz6Rx3o5NgHhZIYTTajYB
         W/oHK1LdnIrtbjUcINTDbnsv29Yg1OdrSO8UNqfFJ/ujMweiXtJ9zq1/SRSkY845xryv
         u5yg==
X-Gm-Message-State: AOJu0YzuQdZ9VYSu7md8ntMI215jhCpkfIZjvnXjgq9tkIydmd2BKk/p
	CG1O4syJlLazeBAWkB8u8HVNZhjnAKI5cKEmFHcPORwx4FkKNlBiRjsOZqZUULNqBpY=
X-Gm-Gg: ASbGnctlnBtRATauQwmQ0vRjmT1f78ZrRrhpeFgfBKx61guf5/z9ZDIQcO0RNUmrzRh
	8p6n16DErRVu/u28TFkigq+LlVaYL6fQOOJbNfFg8f1GBL6rL13xKs7ZnhHm4ZUVI+0zZjybPjl
	UgGzbkGX9vhr/cfRa8TD7DzIkE8uh06YQJu3OfMHlPPwM4J9xIY40xV70iXsNQJj4mSx/m1US6S
	MNwo9e0CfomZgeHehK27j886AgvLYAP9MSxPIoPAkGwTNClJPxXGlfpg6v8YaWSJAZdhwLm2WCd
	RLKg6WN6JhwIow/i/HpX4kfo+LNaxTF0cIDLR38fDSsHXhDcw6nVdzMVV4qckwDOaWcLFFS2Vl3
	IQw3fvksLtdYQmJ5QeaAIbDxlqnX/weVwoK5pKdIv8SuRSKsS7v657PeyttjeZYAEhmHqx7NfL4
	FrXtvsWKh8wQc=
X-Google-Smtp-Source: AGHT+IE4HAZ3PHjk6A+IYGl2s7sGCiNVb8tSJ3VUY6QmKzJrMnnxi5/X65j1adfczDoKBfW55JH4Uw==
X-Received: by 2002:a05:6512:63da:10b0:591:eaeb:f917 with SMTP id 2adb3069b0e04-591eaebfe3amr3041390e87.30.1761259787608;
        Thu, 23 Oct 2025 15:49:47 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-592f4cd1e29sm1078025e87.35.2025.10.23.15.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 15:49:47 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 24 Oct 2025 00:49:44 +0200
Subject: [PATCH v2] RFC: ksmbd: Create module_kobject if builtin
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251024-ksmbd-sysfs-module-v2-1-acba8159dbe5@linaro.org>
X-B4-Tracking: v=1; b=H4sIAAex+mgC/32NQQ6CMBBFr0Jm7RhaRYkr72FY1HYKE4GajjYS0
 rtbOYDL95L//gpCkUngUq0QKbFwmAvoXQV2MHNPyK4w6Fo3dXNQ+JDp7lAW8YJTcO+RkLzx2in
 TnqyBMnxG8vzZoreu8MDyCnHZPpL62b+5pFChPrbWq9qb9uyuI88mhn2IPXQ55y8YUXlVtQAAA
 A==
X-Change-ID: 20250531-ksmbd-sysfs-module-efaf2d1a86ca
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Rosen Penev <rosenp@gmail.com>, Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.14.2

Adding a call to lookup_or_create_module_kobject() to ksmbd
makes /sys/modules/ksmbd appear even when ksmbd is compiled
into the kernel.

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

An option would be to change the script to proceed and
just assume the module is compiled in but it feels wrong.

If this approach is acceptable I am happy to generalize this
to something that any module that wants a /sys/modules/foo
file can use to get just that.

I can think of other ways to just create a dummy dir in
/sys/modules but it is probably unwise if someone would later
actually add a parameter or version string to the module and
get unpredictable bugs. It's probably better like this if
we do this thing.

Cc: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Changes in v2:
- Adding MODULE_VERSION() just to get /sys/module/ksmbd was wrong.
- Try this other approach to call lookup_or_create_module_kobject()
  if and only if ksmbd is compiled in.
- Link to v1: https://lore.kernel.org/r/20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org
---
 fs/smb/server/server.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 40420544cc25a2f7767695641e85d126022a30f9..f12ec149899664efdc9587db749dc8a1d6ccfdae 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -588,8 +588,24 @@ static int __init ksmbd_server_init(void)
 	if (ret)
 		goto err_crypto_destroy;
 
+	if (IS_BUILTIN(CONFIG_SMB_SERVER)) {
+		static struct module_kobject *mk;
+
+		/*
+		 * All this does is assure that /sys/module/ksmbd comes
+		 * into existence if ksmbd is compiled in so that userspace
+		 * can rely on its existence to identify that ksmbd is
+		 * available.
+		 */
+		mk = lookup_or_create_module_kobject(KBUILD_MODNAME);
+		if (!mk)
+			goto err_workqueue_destroy;
+	}
+
 	return 0;
 
+err_workqueue_destroy:
+	ksmbd_workqueue_destroy();
 err_crypto_destroy:
 	ksmbd_crypto_destroy();
 err_release_inode_hash:

---
base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
change-id: 20250531-ksmbd-sysfs-module-efaf2d1a86ca

Best regards,
-- 
Linus Walleij <linus.walleij@linaro.org>

