Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5AC3A1681
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 05:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783663173; cv=none; b=m3uj1FqBYE5VwduJoAJ6qDafst2TacLE0oJE9cPS1InKFKSjNvSLWMutDvWTqYErm7CU0MxLbNnblGl+RWeqzZCgK/pzvvLE+NfsVDZn8TsLte3i/YPaOqF5UGNcgLX/0/oQtDdtTwYoAX2f0rP2dx2ygAp5PRjotCpkYrnOXz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783663173; c=relaxed/simple;
	bh=1h6GXioNfYe/yc7x07/dHIakMYHbB2dhewOaCouW9B4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ZEIqH/Hza91iWGlazkPCLMVDci/0yLd6r4L8XB4ylECYwcx+KDDoKE35X+gPY3Tt0zquL0CFZVM4qZCQRpLzqG9yLx8tMn8QrUvNUA17H2UJcYAnzbCRd0oQc3qIr9MMDRdMjPXvTjaMP96XM/uZqMyRMEEhFYuBDDGJhRO3kiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FfaZxFm+; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FfaZxFm+"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47ddf7b09aaso329355f8f.3
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 22:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783663168; x=1784267968; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1h6GXioNfYe/yc7x07/dHIakMYHbB2dhewOaCouW9B4=;
        b=FfaZxFm+8F+V0Jy5XGiHgbX+xeGhZtw6q1SURl99lTzELpn1guf5Kic6NYnwNU3dL4
         elc/wvEpAXs3tITe7vU01rvpp/NNx9gVVXQ1OQiqCUzn/YUxtuAgSOsUywV4AGcvkc/J
         Heo7ELJPqoNfDnoUokl3kTDNOfIGveIaxf62sRiaS1lFeuHve7rV3DkmoGtPjdFW0kyN
         85kR8kVudnJIYTU4TYLqX+GSrqYBEC7N4zm/43UK1YfpU5D+VTBhiHPbXUZ2rNA8+Bps
         EhzALyrN+kiYFPNrzQvBEKeDVziIh1X4HOPZaNnSKE5prkbhU3intO4XCwz//dC0I4u+
         Le4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783663168; x=1784267968;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1h6GXioNfYe/yc7x07/dHIakMYHbB2dhewOaCouW9B4=;
        b=BIh83LN2qTfIrTaycUps9HbsTvhONPTqgT3M3OFgJU/lfb1NWlKxo+vDXkDzDQ+fBj
         BcaILbV3lVn/t7o4VIIafR75xD+OBtzyZ7sVR4Szrp5AJuhDEpe7xhkfPMHVP9y+xIIb
         fq8xpV/QXAaiGBzF4c5rGDi3HoqD36LdXJfCtdFajRO+5zhd2e8pBmhjslzcVRXt9X3U
         3i8Y/FgmTIvOYr61wP2bTdJy+mTEbytp35XKWjRmB5ZIUhgqSpjhah4kM9wfDHz2t2kF
         dFnhM2q10lzH7ND8KnO8uqpUMAIhZkT5BrlOLmNX0f5yFVA7De34oQ1OOQGiIGtfQ9ju
         TiTw==
X-Forwarded-Encrypted: i=1; AHgh+RpfIA5JbNdIyYdl3NCnQIXU8YoLbq+y1wIXFhBQ3kwJBs9Bw1LaP7YmXYNPC2J3iHFH9+eGO9zX8Qbl@vger.kernel.org
X-Gm-Message-State: AOJu0YwEd2wXqFm/0iXyiEbqndJpLM47lZhptP/3siBYDrTgmxxqixJW
	3Z6hjsOgSA9aePPO3lGN/l64zj8jgta12+AECLoo0AR3racDV+dlX57LLaSAEQ==
X-Gm-Gg: AfdE7cms2ijAjNgaRJwLM2D6BCHVqq5VMH+e2mUsz+M4rOniSL8O4DEfbV3OjvIfUDg
	hNNYPkBxoeIBohqU/yuqypgqCaS4QawbtR30rY6ddCTjoJ/Q+8J3oHz6InGBxG1WTnIk/UK4iMz
	Nf1gbHrrgJcaJFRwQXdYCOzi+66bJSKgFcZji/y9m0qEBsNK4pIv0uOskE8WkdxepboPUVX0Ok/
	15ZKc7TP5gnHfMWKwYMy1L/jM5JqWBQz9VKe9Sl4i/4qt6RWkuCE836aV0C5JnfsvS+2/0h7CVy
	ID+3fzSnDqLTxZT+n9IceR4v8L9tHNfDdEFXFEqmgAT5BmzNMwyPNZL5ABHXIfjY37zvjOI5GWO
	/0epxsi6N0bJNGgQ+YP63uKPOjnt7qrPlF23jKxkh/oYpFv82xnNVGIAGAT1AhDwyLwlppanCoD
	LSn2d3zJ+uiP02MilwNLboDsW1hzRS6EzfSw==
X-Received: by 2002:a05:6000:4382:b0:47d:df96:c9f4 with SMTP id ffacd0b85a97d-47df071e22fmr10501817f8f.10.1783663168184;
        Thu, 09 Jul 2026 22:59:28 -0700 (PDT)
Received: from smtpclient.apple ([82.67.171.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039bcdasm59486961f8f.21.2026.07.09.22.59.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jul 2026 22:59:27 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 4/6] ksmbd: defer CHANGE_NOTIFY completion instead of
 STATUS_NOT_IMPLEMENTED
From: =?utf-8?Q?Ga=C3=ABl_Blivet?= <gael.blivet@gmail.com>
In-Reply-To: <cb3e2376-88ae-4020-9417-ff925cadd8c0@chenxiaosong.com>
Date: Fri, 10 Jul 2026 07:59:16 +0200
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 linux-cifs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <36FFCEFB-8E41-4EB6-B835-0B440C9F4A52@gmail.com>
References: <20260709000618.66534-1-g.blivet@me.com>
 <20260709000618.66534-5-g.blivet@me.com>
 <cb3e2376-88ae-4020-9417-ff925cadd8c0@chenxiaosong.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)

Hi ChenXiaoSong,

Because cancel_fn runs under conn->request_lock, smb2_cancel() holds it =
as a spinlock while walking async_requests, so cancel_fn can=E2=80=99t =
sleep. ksmbd_conn_write() takes conn->srv_mutex and can block on the =
actual socket write too, so calling it there directly would mean =
sleeping under a spinlock.

smb2_notify_cancel_fn() only does the non-sleeping parts inline (list =
removal, freeing cancel_argv, releasing the async id), same as =
smb2_remove_blocked_lock() elsewhere in this file, and pushes the actual =
response send to a workqueue.

> Le 9 juil. 2026 =C3=A0 11:24, ChenXiaoSong =
<chenxiaosong@chenxiaosong.com> a =C3=A9crit :
>=20
> Hi Ga=C3=ABl and Namjae,
>=20
> Do you think it would be better to send STATUS_CANCELLED in =
smb2_notify()?

