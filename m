Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A375546C829
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 08:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790584283; cv=none; b=IaZTqfQE67Q25e7klIM/LehujYKGH4601L3n4nP0FnZUOvSIbWLda9tRX8T8xAtRCxaWVQlkeI+q2RdV6m55tUK39KCPQjYbhtMDd8qyPdtlQ80ZF9rpS5YrV1Ap6XomIr9g5N+Vbo4sq6ZSMFVZrvmQ2zeYT3WN7jk+nsL4Mfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790584283; c=relaxed/simple;
	bh=QY8AiHa5a5xDI2FeLUO12vjI4tOHT7nmIIga6h7zrtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mSg0kHDdVxNcnyxQO+CVdF7BomLKC403TQ/SZAUe9u2JRm0nQRtrKHvJ3mZsGxP8S07/x9vA5elNsrbmvav9Lnt8k5mMvVrG17nNDj8vFuz8Prp1W3n5+bX60L5qW/p5KUQrsub+PlCe5JXtYVfHhAsC68KWVdM2hRfkJuy2/Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZniHdIMG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZniHdIMG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790584279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RYAimctrHSECgl0kUvcluADIyXSquCvgmaPtjlf2kfY=;
	b=ZniHdIMGCfGwEBkXTXRWOm33hAOIRn5ZsMQiUnEQESLpuFRBl5W8fgwvUhEpVPrIWtO5FZ
	Kh9tRcA06IguzsqJHLsk4QBlda65qsTO7u/28XPYf6btV+EXA41oPs+6NDGLMcHz1xsZ9F
	eauUdAoxrTabNux2Dhf0VIWWKHYavcg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-532-t4pSzWqfPAKqwMRRmJHl_A-1; Mon,
 28 Sep 2026 04:31:14 -0400
X-MC-Unique: t4pSzWqfPAKqwMRRmJHl_A-1
X-Mimecast-MFC-AGG-ID: t4pSzWqfPAKqwMRRmJHl_A_1790584271
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8A19190FEEE;
	Mon, 28 Sep 2026 08:31:09 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.32.43])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A86A41956087;
	Mon, 28 Sep 2026 08:31:03 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 1/3] x86/purgatory: Compile purgatory with -D__NO_FORTIFY and -D__DISABLE_EXPORTS
Date: Mon, 28 Sep 2026 10:30:53 +0200
Message-ID: <20260928083055.104266-2-thuth@redhat.com>
In-Reply-To: <20260928083055.104266-1-thuth@redhat.com>
References: <20260928083055.104266-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

A subsequent patch will add #include <linux/string.h> to <crypto/sha2.h>
to use memzero_explicit() there. This will introduce a conflict with the
purgatory code: purgatory.c includes both, the <crypto/sha2.h> header and
the arch/x86/boot/string.h header. The latter provides its own prototypes
for a lot of string functions which clash with the fortified macros
from <linux/string.h>, causing the compiler to emit errors like this:

 In file included from .../linux/include/linux/string.h:383,
                  from .../linux/include/crypto/sha2.h:10,
                  from .../linux/arch/x86/purgatory/purgatory.c:14:
 .../linux/include/linux/fortify-string.h:576:63: error: expected identifier or ‘(’ before ‘{’ token
   576 |                              p_size_field, q_size_field, op) ({         \
       |                                                               ^
 .../linux/include/linux/fortify-string.h:644:27: note: in expansion of macro ‘__fortify_memcpy_chk’
   644 | #define memmove(p, q, s)  __fortify_memcpy_chk(p, q, s,                 \
       |                           ^~~~~~~~~~~~~~~~~~~~
 .../linux/arch/x86/purgatory/../boot/string.h:11:7: note: in expansion of macro ‘memmove’
    11 | void *memmove(void *dst, const void *src, size_t len);
       |       ^~~~~~~
 .../linux/include/linux/fortify-string.h:208:9: error: expected identifier or ‘(’ before ‘__builtin_choose_expr’
   208 |         __builtin_choose_expr(__is_constexpr(__builtin_strlen(p)),      \
       |         ^~~~~~~~~~~~~~~~~~~~~
 ./linux/arch/x86/purgatory/../boot/string.h:23:15: note: in expansion of macro ‘strlen’
    23 | extern size_t strlen(const char *s);
       |               ^~~~~~

To avoid the problem, let's compile the whole code in the purgatory with
-D__NO_FORTIFY, so <linux/string.h> can properly be included from headers
like <crypto/sha2.h> in the purgatory, too.

When compiling/linking with the LLVM tools, and CONFIG_CFI=y, there is
an additional problem during linking:

 ld.lld: error: undefined symbol: __memset
 >>> referenced by string.c
 >>>               arch/x86/purgatory/purgatory.ro:(__UNIQUE_ID_addressable___memset_5)
 ld.lld: error: undefined symbol: __memmove
 >>> referenced by string.c
 >>>               arch/x86/purgatory/purgatory.ro:(__UNIQUE_ID_addressable___memmove_6)

This can be fixed by moving the -D__DISABLE_EXPORTS to the general CFLAGS
of the purgatory, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/x86/purgatory/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 5ce1d42630000..fad91ea28fe71 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -11,8 +11,6 @@ $(obj)/string.o: $(srctree)/arch/x86/boot/compressed/string.c FORCE
 $(obj)/sha256.o: $(srctree)/lib/crypto/sha256.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
-CFLAGS_sha256.o := -D__DISABLE_EXPORTS -D__NO_FORTIFY
-
 # When profile-guided optimization is enabled, llvm emits two different
 # overlapping text sections, which is not supported by kexec. Remove profile
 # optimization flags.
@@ -37,6 +35,7 @@ PURGATORY_CFLAGS := -mcmodel=small -ffreestanding -fno-zero-initialized-in-bss -
 PURGATORY_CFLAGS += -fpic -fvisibility=hidden
 PURGATORY_CFLAGS += $(DISABLE_KSTACK_ERASE) -DDISABLE_BRANCH_PROFILING
 PURGATORY_CFLAGS += -fno-stack-protector
+PURGATORY_CFLAGS += -D__DISABLE_EXPORTS -D__NO_FORTIFY
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
 # in turn leaves some undefined symbols like __fentry__ in purgatory and not
-- 
2.55.0

