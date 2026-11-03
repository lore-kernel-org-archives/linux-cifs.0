Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793676502;
	b=13XiuSVlE3laQkClb/DMn+/5kQ7sE5E2h6ojeTIUFA1ZFhCm6QxNvyI9QvFW4UCR8uCZ
	 KQ3Jy+PKjTVXcPbMUErKPp4N0xwNi1Vx8USsev40a1pqGFjJJhA8Q3MZ31NRyYFGzemDi
	 aXDkbz0HY73hLtzvQ5dlEerANaEsJRj0zhY1zV5QTcD8Na7F9pTuIIKviCIQfRGb/UPKD
	 dQWynFgW2BqtOoXgLUJDcMVI8SvPXVEfMNgzJkCbpE7NFZc9zhtC2RSAy4ZSwsO/hKEmW
	 FlMPYDPfkS5lIPByrhiUyaOx0CY4vKpER2yKaFsyWC6zYam8PPZ3GTDLIKnGOdwJ5pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793676502;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:CC:Subject:User-Agent:
	 In-Reply-To:References:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=KieO/cUIAjxhrfiEXimiRoy/ejkQDz3J+h9ldk1OAZU=;
	b=U6tRyuDR0nsmyz+hq+eBp6SQlecdP1+CFkQDjlx6bRkH6qdulb9klIAFDvnTG0WP/MS8
	 dpOg3IMOV5Ba/s//q0E4pVw1FlLwQ2iYDmgr3C9Ux0UN1m52/KYRf4sr3fkaZQJtU5Gk8
	 WmhL2cZUBqx+f6+8Eyc/PHTSqb8P2npDWA1N2jtdFAlzG2a7CmypAxvOTVsy0tJIz4S5i
	 EyP0jaJQF8Jje5clj1UV3W0iRwk3KShntSxrC/1cpd/FsjyR8/Rrw/u9znPhY0bOg2K14
	 yJL4VSiW3gUC3UXTbb5QKdu7GRxJ48X/2stcDKfCaZO1fAQ/kVoxixGdbIK7gysT/Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	arc=none smtp.remote-ip=91.218.175.10
Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9CB606A326
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 03:28:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF9CB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KieO/cUIAjxhrfiEXimiRoy/ejkQDz3J+h9ldk1OAZU=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793676493; v=1; x=1794281293;
 b=Zglr5uM6e+3Cu6k7TW29DK2n7/xUe2H3FzkVtbbwes8rbbg2Xg5JdjJyFnVDoeHF+enb36tF
 ulAxGHpFBocdZ4p800DJrrVAaeVsXPgg6LF/fuEa/ibpzm+ldIT2ZDDLOJSn869b2xtCACty+E9
 EY72og6+OUiIfQvqdRoEaTm33fsbSXJH4eQPkEEdZDs1BmIJP9TCsG0BvMGpGww0I6QfGNS15Dv
 vqP3mEQkQmdWJCwS3SBkbaKPepsyDT4V6lGEJlItsOL24fQygVmAzAqgXp1NSTQEGQDLCUiDnRM
 qwSH2v0w8rn3F/EhkRK5x8qNSTUWgpyceZLLKG6/uH0XQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id aec3a21a1cec08f1;
	Tue, 03 Nov 2026 03:28:12 +0000
X-Mizu-Trace-ID: aec3a21a1cec08f1
X-Migadu-Flow: FLOW_OUT
Date: Tue, 03 Nov 2026 11:28:06 +0800
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
CC: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <lsahlber@redhat.com>,
 Hyunchul Lee <hyc.lee@gmail.com>, linux-kernel@vger.kernel.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v2] ksmbd: require NUL-terminated EA names
User-Agent: Thunderbird for Android
In-Reply-To: <179367599474.14819.859478551395391125@stu.pku.edu.cn>
References: <179367391951.8187.2063761250230294066@stu.pku.edu.cn> <c02b4586-522d-49bb-87d6-69277b45add3@chenxiaosong.com> <179367599474.14819.859478551395391125@stu.pku.edu.cn>
Message-ID: <B21FE1B0-FF69-4AD5-9B9B-3D0AA4208A10@chenxiaosong.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

No need to send v3=2E v2 looks lood=2E When Namjae applies the patch using =
b4, this tag will be included automatically=2E


On November 3, 2026 11:19:54 AM GMT+08:00, Yifan Zhang <yfzhang23@stu=2Epk=
u=2Eedu=2Ecn> wrote:
>Thanks=2E I will add:
>
>Suggested-by: Namjae Jeon <linkinjeon@kernel=2Eorg>
>
>in the next revision=2E
>
>Regards,
>Yifan

ChenXiaoSong <chenxiaosong@chenxiaosong=2Ecom>
Chinese Homepage: https://chenxiaosong=2Ecom
English Homepage: https://chenxiaosong=2Ecom/en
