Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6603358B8
	for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 15:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764258878; cv=none; b=JCXr7sAo13bIgHMJhfTH9hUPSxJ/ukDP/UYa5S7bOLQ/b53vnOGPCyCYj7up8ijxUfVZCC4o7+M3RKPQDm03J2bLJK0pGZk0fCUbFycTGm0ty+pdvimhkolfdPI88Chw7sH4NhhC/DyGFaQsmyZnj+ysE6L/4CpCBGnHLt6E3Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764258878; c=relaxed/simple;
	bh=MwSAMeojLPnHQYAWzfGJ71lWIIucI3gfYfC0Awk0ei4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q6gsqV0+bCbMdPeiVJk7uLDxFvoxUQ5QYpJFaQ+AX7i5mVPl/jeY3+utlVvPlkxau6443lgEVsj80Bs216UoUO3cYC1sEB/KA/K1kmFsheRe1EQBX/6i+OlysgUSVYsCIG/JswNkVFdiwTA5ZUzGC2jATZnGw2ztB3I0tmhErAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=iRlWwmb2; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="iRlWwmb2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=MwSAMeojLPnHQYAWzfGJ71lWIIucI3gfYfC0Awk0ei4=; b=iRlWwmb28BlmUPOI4ErnS20d8I
	MtFoMnKM9uFhhnYDRQzCxylDpeAxB+BPT3VgZYHRUwkrVIgUrhMtOZw3cZbmZdvwDT1ggKhu+tYDD
	553QREIxaw0hk2JQvJF0Ja0jJU5uCrxfQejY5BwC144QIga6QTFhKdCTS5fj+LZjv0EuY1yCrqTkZ
	Yz/69yFLslx/96l/+VcJaGYu3P6v5L6I4/CWXdqcSeq5+F4kd48A2tl86faLCt7JxONzqBhVDItp3
	LNngWssl5CqM6foHGmw5NjL63B7N6IH5pP/Ci/8EDwrlZJv46V11yHxvMP4DFRYd1ILzM4MVre8c6
	zqg/mG2+bGE70HOsiPQ07wiWsrmB+UpBx1pfMliIWtuQJBIPdoqoWXMvkibljievHra2n5CiIqoNd
	epPzjxDRJ5pJhYtBEI+yQhVbIrgAb8P1xkEW3limGyniG5ZQHQ00o6hfz6sGqL0mdBpaf3PVE+q9F
	t3N/c0ksYwkxbtfzdqtBQ33K;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vOeKI-00G1J2-2S;
	Thu, 27 Nov 2025 15:54:34 +0000
Message-ID: <bd2237e6-86e7-40c8-8635-8ba6c0573cbe@samba.org>
Date: Thu, 27 Nov 2025 16:54:34 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Namjae Jeon <linkinjeon@kernel.org>
References: <cover.1764080338.git.metze@samba.org>
 <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
 <CAKYAXd8Nb6Ay1-J0GeDUCzRDWWYtRtcU-2FZ1LrX9p8soKpaKQ@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd8Nb6Ay1-J0GeDUCzRDWWYtRtcU-2FZ1LrX9p8soKpaKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.11.25 um 02:07 schrieb Namjae Jeon:
> On Wed, Nov 26, 2025 at 8:50 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> On Tue, Nov 25, 2025 at 11:22 PM Stefan Metzmacher <metze@samba.org> wrote:
>>>
>>> Hi,
>>>
>>> here are some small cleanups for a problem Nanjae reported,
>>> where two WARN_ON_ONCE(sc->status != ...) checks where triggered
>>> by a Windows 11 client.
>>>
>>> The patches should relax the checks if an error happened before,
>>> they are intended for 6.18 final, as far as I can see the
>>> problem was introduced during the 6.18 cycle only.
>>>
>>> Given that v1 of this patchset produced a very useful WARN_ONCE()
>>> message, I'd really propose to keep this for 6.18, also for the
>>> client where the actual problem may not exists, but if they
>>> exist, it will be useful to have the more useful messages
>>> in 6.16 final.
> Anyway, Applied this patch-set to #ksmbd-for-next-next.
> Please check the below issue.

Steve, can you move this into ksmbd-for-next?

Thanks!
metze

