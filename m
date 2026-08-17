Received: from mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8826A2C3255
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 01:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786930828; cv=none; b=jkJR0p3OY9VLhe4nKbKrVvaDFY7fQEs7iYwnhdYm7Yq3B7Z6BT00Kt116P3SVgK5BJ0kX4b4mCQ7Zax+L0F9K7nWUDTnhlSEYJQuwZ5gYcGYJCqsCluEmh+yfve4fd57S82IuGf+UgwwjR432fvpcXfDI8H+49dGkVn7jd7MkTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786930828; c=relaxed/simple;
	bh=ecSozL1HT7k3CfKWhmOPnjpxmtlBVYVVnL1xugcLScM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bslyD6qFgHVXHP2O84AQOMERhHPICksU+QaQus30JSkYwiNwJL8AwyLMqbqn3P+l75hAyg2uHz7pcgBjfw2d2kHtUxK4TSBi4AN2G4vm+IrqIj1KAnWWF1dzP3uQdjl7t08pPxlrJ1018ohsboPeOEQOFuBSWZgg3YLLDTdSeeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=J5BRF6SU; arc=none smtp.client-ip=91.218.175.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="J5BRF6SU"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ecSozL1HT7k3CfKWhmOPnjpxmtlBVYVVnL1xugcLScM=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786930821; v=1; x=1787535621;
 b=J5BRF6SUHeceHfItydnKkx0zqm1htplj7h3mY/+HbDxmaOgNRuxqYiwksgPwoj8DbceiVJfU
 hb1T3tozlx8g4mrxaYNYH1wIm0xBknuyzOeurFMtqhZXHDosnXRa1rYwlWvPchr2yg3Pk055lG/
 n3IP86Wpv8iF1aRDhg0j9kYq5jOyPaHKyb9XsSGMqiAuwPkUSXTlpFPDhnpz2uCgubbXKCOmgxQ
 mxY3p4uM0HagQBCUaQuenNdLfCIcMkMGB9ohOArepsXmEpVBL4Ylz70R02Xc27aEEVi9JrUWmf4
 Az5pdnnZLv2IiJCP6Eov5d98nsWyojzM6GiZGyGhl8U/w==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [172.21.20.206] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 41c890f4da0038b6;
	Mon, 17 Aug 2026 01:40:11 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <e5395194-8f37-4641-b3f7-66138ec30338@chenxiaosong.com>
Date: Mon, 17 Aug 2026 09:40:04 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ksmbd: bound smb_check_perm_dacl() ACE walks by
 DACL size
To: Hang Nan <2122295973@qq.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
References: <8970140c-1de1-4989-b32c-ea485be00b79@chenxiaosong.com>
 <20260812103945.82495-1-2122295973@qq.com>
 <tencent_4A67129F3CE9202D7F81A4FF94115D64DB0A@qq.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <tencent_4A67129F3CE9202D7F81A4FF94115D64DB0A@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 8/12/26 18:39, Hang Nan wrote:
> smb_check_perm_dacl() validates that the DACL fits inside the NT
> security descriptor, but then bounds its two ACE walks by the
> remaining NTSD length (acl_size) rather than the DACL's declared
> size (pdacl_size).
> 
> When pdacl->size is smaller than the trailing NTSD buffer, bytes
> after the declared DACL boundary - still inside the stored security
> descriptor - are parsed as ACEs during access checks.  A crafted
> DACL can place an access-granting ACE beyond pdacl->size, and the
> current code accepts it during SMB2_CREATE access validation, while
> parse_dacl() and smb_inherit_dacl() stop at pdacl_size.
> 
> Bound both ACE walks by pdacl_size to match the DACL boundary
> semantics used elsewhere in the server.
> 
> Validation (KUnit, UML, x86_64, KASAN; first KUnit tests for
> fs/smb/server, see follow-up patch):
> - ksmbd_dacl_walk_must_stop_at_declared_size (semantic harness):
>    with the current code the ACE placed after pdacl->size is
>    selected and access is granted; with the fix the same sample
>    is denied (EACCES).
> - ksmbd_smb_check_perm_dacl_boundary (drives the real function):
>    passes with the fix; fails with the fix reverted (rc == 0).
> - ksmbd-for-next-next (rebased, base e9d76059ff03), x86_64
> 
> Fixes: 8f0541186e9a ("ksmbd: fix heap-based overflow in set_ntacl_dacl()")
> Signed-off-by: Hang Nan<2122295973@qq.com>

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

