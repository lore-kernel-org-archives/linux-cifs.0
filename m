Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AAC3081D0
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 08:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763456346; cv=none; b=gtGrMKLJBykb0QEa7RF8qmoQH8AX4pw1G1RNIFRharaaf6jWgQRZqyZsSNEaSEa6mt4LxbYDMLdmEnFBAnSWGvKrDJ0jhjmteY0sYE/cA2iDs+kif+j6V5bXIS1PD0GffV14LhlZzuJxjoYcgNoZF3yKe6knwnVNG2RgWHmRWpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763456346; c=relaxed/simple;
	bh=x/mAy1pSvtCBQglAzNSwziWbAmyz733c9ABBqKUw2PE=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=S44/HAg8m5R4E1SnMG1Zhn880IOTTdIgAtGqqLpvYogcmC6SMR/bY+q881dN9obfehm/vACgd6y1noQ8leY8KwXHXswnmvz9O+3icg5EgtbNlhRy/AwAfweaRX3dlemCRVV0Z3E+PltyICBM3tRcIxzsAPVT0FBVhqTwmzj7aqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OZVQiB7p; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OZVQiB7p"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2984dfae043so49637965ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 00:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763456344; x=1764061144; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KUmPskdfxU4Pzdy7Qbg/7BrxTe0Dl4lbyRxjql3bTZg=;
        b=OZVQiB7pmd2G1YgOOVT4FWxMKnFDfMT7SvrFHiAiF5sclB2QJV31LHQtUuEzDmCzez
         uN7v3XL4CUU4+UHY0o2u0o9cU0+Smb6o/ZRCKZDLxaPAs70SN8LnMgSHIg7DS9vE4DHH
         Q7YWNO1vuiK3xJrPCdh1uCp/Ek2yxmnp/k1djsW31nkWoAS2/oO23Y31nKB4jasKNtZD
         Kb9/3aB4B+POxv3YeERhlinuqTbbEq/SgKz9vF3n9uzmt2wZYtsOdm4RwF2p6lMZUJTl
         Ssg3/YQffCZO9YzISt+emnEsiU7KArVdGJuDHTKSKO6vYOHlkjskiOtIo5EnlBicpdp7
         Gc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763456344; x=1764061144;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KUmPskdfxU4Pzdy7Qbg/7BrxTe0Dl4lbyRxjql3bTZg=;
        b=lMglkNiXqlTrbgMj8Y+7HKlDvk1LruJVKRDXqBdPMDyOGknr+nfAULsNZXv49fbpzG
         LB7KkAZx/GB3d+dDm8l8AQEG/9+jCZ3+yiqGm3WIYLDbQNEfGP50qthyQOyUpDoOFczL
         K9ejDpWU0slAcOn4QF6+Jzb9xA3YjgFaAfvOIao1Kofj0dq8laVk0hjp9SyZsI1vqZhO
         nrVHcZ7t6Qot5ztDSpqDbT2ug0P/Hiz4kb5emUgucuK1rpby18QdsM+8X1xzmci9JujK
         vtc/7iMmM+0o6B6rs45hnjVH3REBUmCh9f2obvJjmenBj5z+Wbh3TltNjyFFK8SS+sYw
         AIvg==
X-Gm-Message-State: AOJu0YzAK73Q5VQboakz10QgQHucD8eZ0JWyncO6tgnpVio25jTiKi+x
	SjmHthuPP+hnx0nYqqM6T6Dl9yGruBe3oP72m2yQFEsqBRlc+RCToGRV6F/1dA==
X-Gm-Gg: ASbGncu3rcnwGLjmI6HB7iopVXf8hCCq3lTBBT3zjC8ZhPazZApj+8Z2InORxIPHTSt
	NdcjUWsq80JMImQPQVWEJpUBf4ZXyBm5RTvo+ptfa5e2bGlOyGN+vn7lHLErC5fwEZjC0G8JuKU
	T45o17pwj1NVK/64S9U5yOXhHpVps0n17k0XjUIZUhENW8e6K+nfjMaIae9U/YAlKhGzmHLkC68
	dzMzgFKWm13x7Szz49l6MkKJ0GW9V8y88DikP90CcV3G0vnZ/kX7neQf536H6gY//sc2+NJC/Qw
	/wRv5bnPCpVR7XupN7udc2Gu1UKeL1d0ZHCWi16kFNjbBKuaWskcJKMZGf9UfLom3Ih349a6MEl
	Ca2nBqfMKd6ymp4jFiAVKap4rCVujsUTeXdZ1m4/7BgA0/CHJdlsl6RhwHOwLO7XZZUQt/0T9AB
	09NAn4NuJjW6B672jYsVTNbK+M745Fu/wlwodR1h9OH5WWT1NZz+PH7iiGEA+ZlA8=
X-Google-Smtp-Source: AGHT+IHgh6PA6G1apHM+ako1vThMywJAXh+PHpqQQ44eccqRbaXMC9mM8B44cHmHC93roIZ9Q9hyzA==
X-Received: by 2002:a17:902:e551:b0:295:6427:87e4 with SMTP id d9443c01a7336-2986a750a0emr193171945ad.40.1763456344102;
        Tue, 18 Nov 2025 00:59:04 -0800 (PST)
Received: from ?IPV6:2405:201:31:d869:97fc:5352:f5a:57af? ([2405:201:31:d869:97fc:5352:f5a:57af])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c249806sm165613565ad.44.2025.11.18.00.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Nov 2025 00:59:03 -0800 (PST)
Message-ID: <01e16af7-4f76-40eb-89c2-79386850d756@gmail.com>
Date: Tue, 18 Nov 2025 14:28:59 +0530
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <69155df4.a70a0220.3124cb.0016.GAE@google.com>
Subject: Re: [syzbot] [cifs?] memory leak in smb3_fs_context_fullpath
Content-Language: en-US
From: shaurya <ssranevjti@gmail.com>
In-Reply-To: <69155df4.a70a0220.3124cb.0016.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

#syz test: 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 0f894d09157b..975f1fa153fd 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1834,6 +1834,12 @@ static int smb3_fs_context_parse_param(struct 
fs_context *fc,
      ctx->password = NULL;
      kfree_sensitive(ctx->password2);
      ctx->password2 = NULL;
+    kfree(ctx->source);
+    ctx->source = NULL;
+    if (fc) {
+        kfree(fc->source);
+        fc->source = NULL;
+    }
      return -EINVAL;
  }

