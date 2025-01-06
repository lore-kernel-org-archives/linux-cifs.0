Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A06BEEB2
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jan 2025 09:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736155447; cv=none; b=oGf0BG6amU2UlnUZpj0YGUVrC+CjpogAb8wYUXr+MvAGh2RYykhhu1GeGw2uLzqrztwLJXzJTbBRrYRyyjXE3luZa6xJdo2v0yzx+kRCeG0NMqY50bl7OIdX2hEEXZNpzn+qxApo61ig8JkrNS2WkRy+6lsBbuieLOxW5hurGTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736155447; c=relaxed/simple;
	bh=go1e6F4x7lRHFju5KcuNAqxUxAG/TKL04N7c4MOc6KU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZCti8J+VrQ66GxugUbz+DY+eiRweAGMbM+oGdnBXUjOtfTBX5tvYBN5URQHtIoLZ9+EeTHWQA0xHdTXeWGLK3XcwjuokO5tbsLJHqFzJrNhsXWWJBt2WaL/kboEshpvgAZmpopYICVicyvplgeuN2DpGLtXnFWSc9jg1E6eT2vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zH2bCbwM; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zH2bCbwM"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4362f61757fso140862235e9.2
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jan 2025 01:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736155444; x=1736760244; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GX5SU/kd2TSZ3EuamtsC8/80yfw0NsWsL7c8xc1tDKg=;
        b=zH2bCbwMp6JdUu+Qz9u2S5sLA8m8cKUZe+CkTteL/k/emBTvI8wyAE+PwJ7dPhaLkg
         VuTH/L7M2+/fCXZ6mAn4HresqfvlPHFZfDQV+wQauDAygzlHoa/YD3FptoOmlHehWthm
         fvzWgyY4Xe2YOv5YLKCGGFFoqk2oRHBvltQ2oLyndJg6AcSZoT+UrLOjKTnUlxV+CxBI
         vEl5bOl1xKpLuvjOpRrjpTRhvLx7S0NzOmA+wCMNGmT1C3zFBTDkEmMnp6N/L9jDQMFD
         zJElCgSEIyk3ONdoX9NHCTjyTDwk6MxUwC2phPZJDUgyYSRljwtyes16QtwLyNmtm1td
         rLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736155444; x=1736760244;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GX5SU/kd2TSZ3EuamtsC8/80yfw0NsWsL7c8xc1tDKg=;
        b=INLGKl7EOL9ZnPlL7/V6q/4TlVcmejAkVC2sIR/ZZRiIc90gh4R1IuqscJBY6GHqfl
         LvEc8luy9ls+AjqFAqH2WG5V5I5632Ul8/+yuMqtRKY5axqpTncerNR9MsyImDjxrtRT
         1kyPFB2Ijgc2E/gpRS7aksBhaCVB6VUT55OuvPF/lx9pOony2RFXY5ueTftiKgf3ukQS
         ZETppDgHmsBCLPr4NCdCUX23pbhnv8g8X0f61gQL0+g6+rEzAz8Nv/UmRAAIakQQ+pl2
         dra2AqcISIOnpfA2rUAI6/tgN/fzAWCMNh/IQTMj4HbISer8JaQUGi072qCutR6z2oqt
         7Osw==
X-Forwarded-Encrypted: i=1; AJvYcCUk+GRN1C5ldIeDILhJobyfvU3WTU+9FzdSqamHTPp4BiU+lZMIbrxjbSS73zJRBpcsdgwKFZDr7r0Z@vger.kernel.org
X-Gm-Message-State: AOJu0YzDgJJKF7hvpmyEl3+D9YxryUbq7G6XAqKtfJpy9CtWLX7LCp8W
	KeA0qbdg98ghkIM9tulKAMKbe+depkO3xyO+qhIZa2QRSPcwznKQuZ8XVZV5gUE=
X-Gm-Gg: ASbGncvyCXEUCNueGBh3NobQ7NY5e7i3/MYNza9fBWK8eCigCtBw5Hq8YVkLSQIbM9y
	pJMt7ztyyrgrlIs5Ibhn5kn4+jbpEFtlWr3g/bbXRF5zX+YudCd5qbWN5g0iKBSkwH3vkcAmXi9
	MMs858ZQud/FO01i0AkCFgQg4WHUoVkuYXHMEXzvqMLkfJiYKJFEd4aSUa6ufWshHQelci22o7C
	flmkEc9NjhYeU/E9VBq3CdRpnfkgjxcPX9gzWbVwEEfD/oIigL5jr5gVKaFIg==
X-Google-Smtp-Source: AGHT+IFx2lXm7TTxCwCaL3KoFUyod+c+0FVOGIvbve9KBxsmlG4U+0xq00kI18NVyoTycIppMXQBZw==
X-Received: by 2002:a05:600c:45c6:b0:42c:c28c:e477 with SMTP id 5b1f17b1804b1-43668b4808fmr439549465e9.23.1736155443819;
        Mon, 06 Jan 2025 01:24:03 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b015absm596603375e9.13.2025.01.06.01.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 01:24:03 -0800 (PST)
Date: Mon, 6 Jan 2025 12:24:00 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Steve French <stfrench@microsoft.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [cifs:for-next-next 13/13] fs/smb/client/fs_context.c:1466
 smb3_fs_context_parse_param() warn: statement has no effect 22
Message-ID: <a376beb3-c362-4b73-b2e6-9104d4df6978@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next-next
head:   8f97b4a68ea216bad142a5391e30fa63c8efce30
commit: 8f97b4a68ea216bad142a5391e30fa63c8efce30 [13/13] smb3 client: minor cleanup of username parsing on mount
config: x86_64-randconfig-161-20241220 (https://download.01.org/0day-ci/archive/20241222/202412220354.ZyCvciEy-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202412220354.ZyCvciEy-lkp@intel.com/

smatch warnings:
fs/smb/client/fs_context.c:1466 smb3_fs_context_parse_param() warn: statement has no effect 22

vim +1466 fs/smb/client/fs_context.c

8f97b4a68ea216b fs/smb/client/fs_context.c Steve French     2024-10-23  1452  		/* if first character is null, then anonymous auth */
8f97b4a68ea216b fs/smb/client/fs_context.c Steve French     2024-10-23  1453  		if (*(param->string) == 0) {
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1454  			/* null user, ie. anonymous authentication */
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1455  			ctx->nullauth = 1;
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1456  			break;
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1457  		}
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1458  
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1459  		if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) >
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1460  		    CIFS_MAX_USERNAME_LEN) {
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1461  			pr_warn("username too long\n");
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1462  			goto cifs_parse_mount_err;
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1463  		}
8f97b4a68ea216b fs/smb/client/fs_context.c Steve French     2024-10-23  1464  		ctx->username = param->string, GFP_KERNEL;
8f97b4a68ea216b fs/smb/client/fs_context.c Steve French     2024-10-23  1465  		/* streal string from caller, but set to NULL so caller doesn't free */

Typo: "streal" should be "steal".

8f97b4a68ea216b fs/smb/client/fs_context.c Steve French     2024-10-23 @1466  		param->string == NULL;


It should be = instead of ==.  It's surprising this compiles...

24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1467  		break;
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1468  	case Opt_pass:
a4e430c8c8ba96b fs/cifs/fs_context.c       Enzo Matsumiya   2022-09-20  1469  		kfree_sensitive(ctx->password);
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1470  		ctx->password = NULL;
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1471  		if (strlen(param->string) == 0)
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1472  			break;
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1473  
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1474  		ctx->password = kstrdup(param->string, GFP_KERNEL);
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1475  		if (ctx->password == NULL) {
24fedddc954ed16 fs/cifs/fs_context.c       Aurelien Aptel   2021-03-01  1476  			cifs_errorf(fc, "OOM when copying password string\n");
24e0a1eff9e2b98 fs/cifs/fs_context.c       Ronnie Sahlberg  2020-12-10  1477  			goto cifs_parse_mount_err;

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

