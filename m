Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DCA632
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 10:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790505100; cv=none; b=igghwE6sWR55nW+vdSuesOfkVcdg6XRWjTE0TuRuCGQPdQW6RAwfCMcGMtQ2GdGZxE/a21gZdzeMIXm5l8NKuBg9XBdYe7C4xBcl3DqwoxtdpQfPwAzQ+zkVTMHm42/4jc8efsJadbNZV1WO+UDaqaryCRgfj4Vlr239dueAX/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790505100; c=relaxed/simple;
	bh=StkCes5zuBuklQRBb36jTxpcInqoawJHSc/HfmZadrE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bD8HW47BsnO004DuC9BxS5eoX5TvYO2SqgKFFqwdrccIy7bYgRFWDzzViv2f3C/huMfRjY3sdk/+ZVSVClnujhpk9e+jpVAjqhI8PZ/SiJh8rlEiFN1PVWwY7eqmsl1BKZMmGGoEurP6ZqLmXxu4dEBGaRC4Fy2V0ONnfa5LuCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e540SDoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e540SDoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376141F000FF
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 10:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790505099;
	bh=iCC94HONGBqqGOJ5/HF33KB59/H3exOfhAouviK5e/s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=e540SDoROqBKpaikAmdn7bpqIP5cRbfq3Ji3giov69yMDC1WNx47EPirwYdSb42Yo
	 wujSn0+CdyuCOzs3HSHe5/reZ5+KOpZHbIuQKshGyyaGGqpULEsCxup/WZLgzrxbmL
	 Qr3+Gya9IXhCJnthWbYGBeXDgBZp9KSX7hg/33TfQajdzFt1EtJ0ctJoDlrauzk22B
	 +sAl7wcaokBJm++dQfXxo+nCnrb+ZQNj3ModjBBp9BnbqSiUzVkAeTL3fWoWdz3P5M
	 e6Oy36kOB75ZxCYo1jU9q+EIavMb9PT+/NK09qQai7U2mpHZ3PleDqRSaErlJUKz4z
	 ML+Eda2oLfEbQ==
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aaea1cb2e4so2449332a12.2
        for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 03:31:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy20o1f8/KUyubpdcge/fooANrOJ7BHbUoeYJVjYYaus4iSJO8mWrpO5xzLABYisZWYhudt55RZFAeb@vger.kernel.org
X-Gm-Message-State: AFuF++mLGoLPrSk5YNF3tQXgyiypW2dMDdb5TJPTBlhJYRK16oFHeR1O
	1QXNLq6RZ6L7QNy1mfGU7VEeI6BbIfm83RQdvgHLDgzQgIYfzDOFeStm5gptUvZTDa2VisMpV9T
	rWLB6RZfvwf0J3obL2pCo6CtcIKEAfss=
X-Received: by 2002:a17:906:4fc6:b0:c24:b11a:46fc with SMTP id
 a640c23a62f3a-c2ac23ca0b6mr872368766b.22.1790505097851; Sun, 27 Sep 2026
 03:31:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926090518.78547-1-chenxiaosong@chenxiaosong.com> <20260926090518.78547-8-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260926090518.78547-8-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 27 Sep 2026 19:31:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8A3GB7QPUvevFaGOA2MNWcy++6nyEJTkhUnwqjUHdfhg@mail.gmail.com>
X-Gm-Features: AclHuK8OaHTuMSy54oj2veAzL6-1LPXJ2vJix045GyMrDRwmLvb7hCdQBQUzLZ4
Message-ID: <CAKYAXd8A3GB7QPUvevFaGOA2MNWcy++6nyEJTkhUnwqjUHdfhg@mail.gmail.com>
Subject: Re: [PATCH 07/12] smb/server: save simple notify events
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: tom@talpey.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> +static void
> +ksmbd_notify_queue_event(struct ksmbd_notify *notify,
> +                        struct ksmbd_notify_event *event)
> +{
> +       ksmbd_debug(NOTIFY, "Queueing notify event, action %u, name %s\n",
> +                   event->action, event->name);
> +
> +       spin_lock(&notify->lock);
> +       list_add_tail(&event->list, &notify->events);
> +       notify->num_events++;
Could we put a per-open limit on the memory used by notify->events?

> +       spin_unlock(&notify->lock);
> +}
