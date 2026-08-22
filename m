Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDA93515E3
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 16:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787416213; cv=none; b=ajbR3dLhtI8pLhtuf8LMV3UhRg8gVOFViFg+N+ZzcJ6yaI18qCIxRFfCsBiiTQv6EIvBjl3GnhWgqHI7a6EZipEEC6qKT5ffdcLUQPiDB7mZtcCCGqzLnMFDCVEhZaTqXhE4V6bDEMH2VQAlOmihKpdRZ+QB1WUST7sa36+vm7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787416213; c=relaxed/simple;
	bh=uU9KFeI8eps0mAxZNupvNoCGBKynHuEoRJZiMvt0W6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n1If4y6kI46IlK2v87pwpYDEd9ICvmTjrrpJv/hHej8lDX6cLCSByTXPNHSHMMStgO7TZQhNEWSnYw5PTzKLpEXk6cxEshGG3DQVHPOrlNFuNlCWzslYOA8sdw+AIwuRD/xo4IQweGNIYL0oqhpJ6MO/sqGuhj7zwg2ZdWPTJrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=q0kJYUbb; arc=none smtp.client-ip=91.218.175.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="q0kJYUbb"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uU9KFeI8eps0mAxZNupvNoCGBKynHuEoRJZiMvt0W6U=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787416202; v=1; x=1788021002;
 b=q0kJYUbbgHpNbo7trazqoDDLz2sRYrqliVFCSeNF8LbuhlrHqey8ax5xzht8k7p3cerRYSY2
 3VV1FByQpRe1uoMxR+r5QAP2lkAMXt/cPznVsJq35Xgwc1V1MoMB6IX0nOmiiDCqfAchucMxYVF
 S7V3itAITjfcjF5ZPHew4aRyJTa0Oq5Sra4tJlI+zcSxmJD3H20b5GbHV2VtH8pWIMsyOnc/1ht
 Y6iiHBirpZ6GUwKIpVL2NmXdF8tMnC6VXa0QtdSyNxkPoSPwWuXG7ez6zxrnXftnWyPP44ysvej
 eSLG60y1r0eEODy2cq83WlvAafKWkLRCWGRRbdswhSiIg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.0.104] (220.202.230.161)
	by smtp.migadu.com with ESMTPS id 57fc6c7d6056bbe8;
	Sat, 22 Aug 2026 16:29:52 +0000
X-Mizu-Trace-ID: 57fc6c7d6056bbe8
X-Migadu-Flow: FLOW_OUT
Message-ID: <51fba35c-967f-46b9-8252-d433beab7129@chenxiaosong.com>
Date: Sun, 23 Aug 2026 00:29:44 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] ksmbd: refactor smb2_notify() to a blocking wait
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, tom@talpey.com,
 senozhatsky@chromium.org, slow@samba.org, gael.blivet@gmail.com,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd84UnfdQ6Ef2nqybnhdgURFo9uYpB1mHZpphFyCiMhutA@mail.gmail.com>
 <9aeb9ccf-dcd0-48a7-bc24-4b6948943f62@chenxiaosong.com>
 <CAKYAXd8JMs25fdyZhPn9KYEfv1WH297nxAV0enFHm6T+q=VTFQ@mail.gmail.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd8JMs25fdyZhPn9KYEfv1WH297nxAV0enFHm6T+q=VTFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

After this patchset, `smb2.session.expire1s/1e` are passed.

On 8/22/2026 4:48 PM, Namjae Jeon wrote:
> Can you check if smb2.session.expire1s/1e tests are passed after
> applying these patches ?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

