Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A314F1BC46
	for <linux-cifs@vger.kernel.org>; Sun, 22 Feb 2026 07:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771745975; cv=none; b=RTdgYyvxMN7ljo6zzAb7IDdhWb+iaFXz6LqeJ+d9xyC9uotU+/UNoRLmsWT0Qah0NFji2v4HXkCatUPgShd7IIFJrAs+v1kkyjLITur2D5NrDd0CJ0vei7tv0ofHKFxGuZWgedy0wpFmOmntYA1pR9PSJPys7wcoinvgO9V539U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771745975; c=relaxed/simple;
	bh=W1Pig409ZWhNmtNEMStLv3QYK/cEldC4JoIFapPwJR8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=sYs1X3l7Jr1/LGKf2u1f0FalvEjJRnWmPuCdVf0GmtaFmAOVAp4eZfzpPPaUYMHo4FsMegC97iXcuGlul5XkQNmdxB0eNXSKt0OcvXMRzI45pjq4cHScikEpOboAr00hoenlK1E6sgYpbylW2nDYn0cLw9jW0g9Hv4T7FBUTAuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=NUPO8lKP; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="NUPO8lKP"
Message-ID: <5481d68d-9864-457c-9589-3bfd4cb6a54d@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1771745969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X0kHTmN95TPUA0g0FujgocC5Lpguo5X+nPPS3b8RQFg=;
	b=NUPO8lKPWh6Np0vmB7jWiYM1+v1QY/DNY+MR9SpaXRHumAvU7D3h5YSVvk9xNhur6YLtFx
	cDH/Za/6ErI9AXyrCycea2EcMK5UToeYUn9mxCknxNpsYC6ddQrY+ek2qoYKeU1KgEXD9Y
	rbDOR/vFGUNT5FBICDIHv2HGpJk3sAvhcPkNwFC+uC1leWBZAFuOVWZvDHY4MkVX/pXwM2
	41DqmyjRumxRk/7ulG8opBCJFfiz0F6lXSrBEdWZqJ9xTMiA+NpUXy+NkomF8m0QiVnORS
	SBitKiXCZRkUGB2Nx/ct6tE+T2WM+vbTyThBFXS3xYyHlRb1Eb9wJZSVqEezYg==
Date: Sun, 22 Feb 2026 15:39:21 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH v3 0/5] smb: move duplicate definitions into common header
 file, part 2
To: Namjae Jeon <linkinjeon@kernel.org>, smfrench@gmail.com,
 zhang.guodong@linux.dev
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org,
 ZhangGuoDong <zhangguodong@kylinos.cn>
References: <20260216082018.156695-1-zhang.guodong@linux.dev>
 <CAKYAXd_MuUe9R4vnkmGEkWxG7endJFqGDiEprLcvgJDixakX2A@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAKYAXd_MuUe9R4vnkmGEkWxG7endJFqGDiEprLcvgJDixakX2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae and Steve,

In server-side create_posix_rsp_buf(), there is the following comment:

  * SidBuffer(44) contain two sids(Domain sid(28), UNIX group sid(16)).
  * Domain sid(28) = revision(1) + num_subauth(1) + authority(6) +
  *                  sub_auth(4 * 4(num_subauth)) + RID(4).
  * UNIX group id(16) = revision(1) + num_subauth(1) + authority(6) +
  *                     sub_auth(4 * 1(num_subauth)) + RID(4).

However, according to the SID description in the link below (Link[1]), 
the relative identifier (RID) seems to be the last subauth item 
(consistent with the client-side posix_info_sid_size()). Should we 
remove RID(4)? Please let me know if my understanding is incorrect.

Link[1]: 
https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers#sid-architecture

Thanks,
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
On 2026/2/20 09:27, Namjae Jeon wrote:
>> ZhangGuoDong (5):
>>    smb: move smb3_fs_vol_info into common/fscc.h
>>    smb: move some definitions from common/smb2pdu.h into common/fscc.h
>>    smb: move file_basic_info into common/fscc.h
>>    smb: introduce struct create_posix_ctxt_rsp
>>    smb: introduce struct file_posix_info
> For patches 0004 and 0005, please move the complete definition to the
> common header instead of a partial split. So we should also use a
> flexible array member for this, and ensure that all related code is
> updated to handle the flexible array correctly.
> Thanks.
