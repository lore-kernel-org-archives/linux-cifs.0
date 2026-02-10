Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25ECE26AE5;
	Tue, 10 Feb 2026 08:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770711046; cv=none; b=LlCN98iffxw/4Kvm+THjEHNsdUDUIQqPw/xO1z0RNYtKDvG5wjrmXaGaThmVK11OAXbUjCjPPcSM5yL9BvV1l/IO8BwOm84NP+hwnluyAMOWgF5Hsw0EvU9LK1kml03aCYK86tsyRj9xAoGJWtlAcM3i+tjPrpdPgKL6t6cCnDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770711046; c=relaxed/simple;
	bh=sapJatrsO4t8jUpkqfz2pWJkjkQH+MfQIcOAK6eeTuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcL/n/9HocnUI+SYKhOnHpyI8D6imP2mC+PQkgZQXSHX4m/GNZ8tVPhPRnd1qpHpDNQKuApuRzYC/soVAu5VNninzsfQ1U/3UYzK2t4La0uYEXs+UhimRMX5r66B2qdJ6Zh0d08u8jamz3pCSO/GnQjE/I+W9deNYBI/8ApRqrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75BFC116C6;
	Tue, 10 Feb 2026 08:10:42 +0000 (UTC)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: bharathsm@microsoft.com,
	chenxiaosong@kylinos.cn,
	dhowells@redhat.com,
	linkinjeon@kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Rae Moar <raemoar63@gmail.com>,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com,
	linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	senozhatsky@chromium.org,
	smfrench@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com
Subject: Re: [PATCH v9 1/1] smb/client: introduce KUnit test to check search result of smb2_error_map_table
Date: Tue, 10 Feb 2026 09:10:40 +0100
Message-ID: <20260210081040.4156383-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260118091313.1988168-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260118091313.1988168-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

 	Hi ChenXiaoSong,

Thanks for your patch, which is now commit 480afcb19b61385d
("smb/client: introduce KUnit test to check search result of
smb2_error_map_table") in linus/master

> The KUnit test are executed when cifs.ko is loaded.

This means the tests are _always_ executed when cifs.ko is loaded,
which is different from how most other test modules work.
Please make it a separate test module, so it can be loaded independently
of the main cifs module.  That way people can enable all tests in
production kernels, without affecting the system unless a test module
is actually loaded.

> Just like `fs/ext4/mballoc.c` includes `fs/ext4/mballoc-test.c`.
> `smb2maperror.c` also includes `smb2maperror_test.c`, allowing KUnit
> tests to access any functions and variables in `smb2maperror.c`.
> 
> The maperror_test_check_search() checks whether all elements can be
> correctly found in the array.
> 
> Suggested-by: David Howells <dhowells@redhat.com>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/Kconfig                    | 17 ++++++++++++
>  fs/smb/client/smb2maperror.c      |  8 ++++++
>  fs/smb/client/smb2maperror_test.c | 45 +++++++++++++++++++++++++++++++
>  3 files changed, 70 insertions(+)
>  create mode 100644 fs/smb/client/smb2maperror_test.c
> 
> diff --git a/fs/smb/Kconfig b/fs/smb/Kconfig
> index ef425789fa6a..85f7ad5fbc5e 100644
> --- a/fs/smb/Kconfig
> +++ b/fs/smb/Kconfig
> @@ -9,3 +9,20 @@ config SMBFS
>  	tristate
>  	default y if CIFS=y || SMB_SERVER=y
>  	default m if CIFS=m || SMB_SERVER=m
> +
> +config SMB_KUNIT_TESTS
> +	tristate "KUnit tests for SMB" if !KUNIT_ALL_TESTS
> +	depends on SMBFS && KUNIT
> +	default KUNIT_ALL_TESTS
> +	help
> +	  This builds the SMB KUnit tests.
> +
> +	  KUnit tests run during boot and output the results to the debug log
> +	  in TAP format (https://testanything.org/). Only useful for kernel devs
> +	  running KUnit test harness and are not for inclusion into a production
> +	  build.
> +
> +	  For more information on KUnit and unit tests in general please refer
> +	  to the KUnit documentation in Documentation/dev-tools/kunit/.
> +
> +	  If unsure, say N.
> diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
> index 090bbd10623d..cd036365201f 100644
> --- a/fs/smb/client/smb2maperror.c
> +++ b/fs/smb/client/smb2maperror.c
> @@ -114,3 +114,11 @@ int __init smb2_init_maperror(void)
>  
>  	return 0;
>  }
> +
> +#define SMB_CLIENT_KUNIT_AVAILABLE \
> +	((IS_MODULE(CONFIG_CIFS) && IS_ENABLED(CONFIG_KUNIT)) || \
> +	 (IS_BUILTIN(CONFIG_CIFS) && IS_BUILTIN(CONFIG_KUNIT)))
> +
> +#if SMB_CLIENT_KUNIT_AVAILABLE && IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
> +#include "smb2maperror_test.c"
> +#endif /* CONFIG_SMB_KUNIT_TESTS */
> diff --git a/fs/smb/client/smb2maperror_test.c b/fs/smb/client/smb2maperror_test.c
> new file mode 100644
> index 000000000000..38ea6b846a99
> --- /dev/null
> +++ b/fs/smb/client/smb2maperror_test.c
> @@ -0,0 +1,45 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + *
> + *   KUnit tests of SMB2 maperror
> + *
> + *   Copyright (C) 2025 KylinSoft Co., Ltd. All rights reserved.
> + *   Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
> + *
> + */
> +
> +#include <kunit/test.h>
> +
> +static void
> +test_cmp_map(struct kunit *test, const struct status_to_posix_error *expect)
> +{
> +	const struct status_to_posix_error *result;
> +
> +	result = smb2_get_err_map(expect->smb2_status);
> +	KUNIT_EXPECT_PTR_NE(test, NULL, result);
> +	KUNIT_EXPECT_EQ(test, expect->smb2_status, result->smb2_status);
> +	KUNIT_EXPECT_EQ(test, expect->posix_error, result->posix_error);
> +	KUNIT_EXPECT_STREQ(test, expect->status_string, result->status_string);
> +}
> +
> +static void maperror_test_check_search(struct kunit *test)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(smb2_error_map_table); i++)
> +		test_cmp_map(test, &smb2_error_map_table[i]);
> +}
> +
> +static struct kunit_case maperror_test_cases[] = {
> +	KUNIT_CASE(maperror_test_check_search),
> +	{}
> +};
> +
> +static struct kunit_suite maperror_suite = {
> +	.name = "smb2_maperror",
> +	.test_cases = maperror_test_cases,
> +};
> +
> +kunit_test_suite(maperror_suite);
> +
> +MODULE_LICENSE("GPL");

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
