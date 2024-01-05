Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5299620DD8
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jan 2024 10:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pGEyir9o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=01KIMb+QFWE2VDoFR2VYNUsb/DYyyLi34QbgKeWt7hM=; b=pGEyir9oMHQ7kwa6XArxZHrOYz
	z2q6/UsBxH/mCrtY7eubtVK17kYAm1Zl9tVwRXwlcXCRfZ0m4bCHMo9TtOHQ3KObUkKe1FA9+ld1l
	OauIx/eAKMLTWfKHyesgiyfrlWltoln4ZxNTr9q7TdJRdp9otIwXk1xanC8YWFbMANNlhme18+ayu
	BT2tP3NfIOuqPmKoqx8OPxToGLpCzhemG7lrBovswzFXUhmCrkMCABunhUUaTH1TkgVad27RFYgFQ
	t1pIHXhw6gyN/3mqpTvovghx2+/+QagXjdFvceajUjH+aA1QeniG8YVJZU7gMFX29VCe2U8CyxUtm
	At4lBzpFcE194/rOxyRaDKjCbU+7s1eB1seW3H+DfVzxVhekTN8AwKX6fpPHxTxOR/FDD8h+Eu3MF
	Tu84ogU7vzu24WBxUj4LJKD+e97KmEIOY3O4O3GC+/y2JKX+Iq0MIjXeJ4DwhIDTxfYPb1t7Jf6UR
	WmiFzzFX7ywB5kCtgzAEXptj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rLhat-006awL-25;
	Fri, 05 Jan 2024 10:38:27 +0000
Message-ID: <aee2e001-a1a6-4524-a897-de293ef1c034@samba.org>
Date: Fri, 5 Jan 2024 11:38:27 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] smb: client: retry compound request without reusing
 lease
Content-Language: en-US, de-DE
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@manguebit.com>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, sprasad@microsoft.com,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 sfrench@samba.org, Meetakshi Setiya <msetiya@microsoft.com>,
 bharathsm.hsk@gmail.com
References: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
 <20231229143521.44880-2-meetakshisetiyaoss@gmail.com>
 <7e61ce96ef41bdaf26ac765eda224381@manguebit.com>
 <CAFTVevWC-6S-fbDupfUugEOh_gP-1xrNuZpD15Of9zW5G9BuDQ@mail.gmail.com>
 <c618ab330758fcba46f4a0a6e4158414@manguebit.com>
 <62eb08fb-b27f-4c95-ab29-ac838f24d70f@talpey.com>
 <CANT5p=qqUbqbedW+ccdSQz2q1N-NNA-kqw4y8xSrfdOdbjAyjg@mail.gmail.com>
 <242e196c-dc38-49d2-a213-e703c3b4e647@samba.org>
 <CANT5p=oFxQEB5G4CzVuJBkg76Fu-gqxKuFdYJ8NCnGkS-HhFJA@mail.gmail.com>
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CANT5p=oFxQEB5G4CzVuJBkg76Fu-gqxKuFdYJ8NCnGkS-HhFJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Shyam,

>> Maybe choosing und using a new leasekey would be the
>> way to start with and when a hardlink is detected
>> the open on the hardlink is closed again and retried
>> with the former lease key, which would also upgrade it again.
> 
> That would not work today, as the former lease key would be associated
> with the other hardlink. And would result in the server returning
> STATUS_INVALID_PARAMETER.

And that's the original problem you try to solve, correct?

Then there's nothing we can do expect for using a dentry pased
lease key and live with the fact that they don't allow write caching
anymore. The RH state should still be granted to both lease keys...

metze

