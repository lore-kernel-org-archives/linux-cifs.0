Received: from mta0.migadu.com (out-64.mta0.migadu.com [91.218.175.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C26376BC1
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 06:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786689906; cv=none; b=M9hgM3SUGNsGSGJxjU0FE4ArOr68u6VQ3i7NB62Klx1exGwV2WgfY3a277WTrcWHuaettkNT5/f+S++iei/6gNuuJrfYihb8aFF1QueW+VATW2ACOdLOIXKEDmyk+Xu1J1s0+L0XWz+Uaa2D8hPSjzZw0SCRU2pGApGj6KAk0jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786689906; c=relaxed/simple;
	bh=0FGXVRwgTWSgbH3+4HgWUbwGip1o2lj0f6uS+eyYqPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MmY+KalgoEy5xIN64ecZUil0Ibr1RJXAmAUs3bfIis9ZhLX4ziim4rs194asOvmMxeY4ZzpFIZ2+bwLFzEWlDU+dlyN6j9QA0ypqjus0Z0GL5ZAdGt9yThkLNlHni2uZHGI+09bpNAiedL4q0+lrbFrCwi0OUkglAXwpYggPMas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=kEePFy9t; arc=none smtp.client-ip=91.218.175.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="kEePFy9t"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0FGXVRwgTWSgbH3+4HgWUbwGip1o2lj0f6uS+eyYqPg=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786689899; v=1; x=1787294699;
 b=kEePFy9tw1D0Ki+H/dco/N6vNPJ/NA07viW8uQzS1lsjqtga+/baoK4z7UsRsqmW1D0lwAhG
 ORo7Ona4kcNN2Jka70hC4tmL9J6d2Lv9JNShj2F8GPKNXF+YY3IRSLqXe3S5MdtqAigNvf1cDzH
 oqu1P6+IIyTE5hnaxxZNnKPlYn1OFo4Rx6aYYf/VQGUjPk76OLYpUOjtBQve6GKGlUYUFw8Rnv/
 OUMU4NT0/m/+naB3bQlYs0Umdf1o7pfdPZA6Daq4fDXh+8NAV/MTF4A+Kec//qN0gHkEpepH4D1
 FHRBzEn0tqu5nX7lxuMMn//xTpUnZIZUbQ9itfUqby4vg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [172.21.20.206] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id fc515a86bebfea45;
	Fri, 14 Aug 2026 06:44:49 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <7829f6cd-c365-4fd6-a45a-b2368db71a76@chenxiaosong.com>
Date: Fri, 14 Aug 2026 14:44:46 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] smb/server: check create_proc_shares() failure
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ze Tan <tanze@kylinos.cn>, sfrench@samba.org, senozhatsky@chromium.org,
 constant.lee@samsung.com, tom@talpey.comm, linux-cifs@vger.kernel.org
References: <cover.1786674373.git.tanze@kylinos.cn>
 <82181632662a23ecc9a3b8b2321982071037a288.1786674373.git.tanze@kylinos.cn>
 <CAKYAXd9-mkdArzM573FPUo0cS8ZuuY21OgMMQ5d9kLOknzy26w@mail.gmail.com>
 <d7cb5234-fd5c-49cf-82ab-590b5a1e902c@chenxiaosong.com>
 <CAKYAXd_tBUao9wk-hkayPpNxVPbJzPRTDRVH4PvmSUu_UxL=Ew@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd_tBUao9wk-hkayPpNxVPbJzPRTDRVH4PvmSUu_UxL=Ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Okay, tanze will update the patch, and he will send other fix patches 
together.

On 8/14/26 14:40, Namjae Jeon wrote:
> I think it would be sufficient to just print error message using pr_warn().

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

