Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792469176;
	b=Xc5lwfoIyvDKVr+FNgrOs6MLSWNCxQ601WT88ifQ3jDayyJBSEfNi42lUdQcm/zWu63c
	 FLB770cQmpKYrRBsw67zE9QLpVDDbtGfF1XyOtryljy/qpsXESq8PCiiJUBbxovtvmjtN
	 QMabR1WZ/EJJjPr7Xtt2UV+0Kwn4Sz7NXX9VKFtBPkm/qpwpMtcfoU7ufSVlvARPi12lX
	 kEzCwxV7fDpjQUETgdHjgOUk9l9BO1aRHYw1QcBPjO3pVZPFtV2oMaxuq2Q6gJIuSmPZs
	 CDjEkIQyjPQ4NKiE34t21pvJ5P0J1N8vSYcVjsYbGUKmHbxeQhx5rjOpQu7buRKd20Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792469176;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=X94iF6WQ9utJc+Qff8l5eUqC4oEFwLu3u0KuYxIiRHM=;
	b=zk2pESMmrFDnknXmmrlvKm/mijQveBEf2UtjRfEz0q9IgAzxuGp3/o57ryInX6bS7ivW
	 oa4HRfbJ/czWw/r0dZdpBGusM41lL4hWhjVa7qSIAycJzuTdqW4Y31Jm06kNMJUgWC9gG
	 M6pdbUr1dizFmlg3htUmxHqxRkT3NNuUe3LdFP+0gJtwLlChGqjbPeXvjLWO8tRZey87o
	 PtAV9XyoQ3y+n7pHTURyrS0RQCxuvEFykhDGIiw5qGI09sqWRQFiiiEJYqxIVngYP3x6S
	 3eZCM4EZ2rtQufgkf4BBFePDMUYyC962oRW7vMvzQUnGGPjYY1V0s264P4Y5wg8pzbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA82B606A31A
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 04:06:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA82B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-81447a16061so6479441a34.3
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 21:06:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792469175; x=1793073975;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=X94iF6WQ9utJc+Qff8l5eUqC4oEFwLu3u0KuYxIiRHM=;
        b=gRELs2yV1/Nv+wm2obpM4c1aoapjK/bY7U00OP8oa4vJ6IF+RgU1cp+C0AcL8/STy5
         J7/Uvgf0s8POTtlWjkDvM5fhHG90c1q04GTb9ieWVXoD8fNk5uk3LfU951qUr4PijxUh
         crIdIuUN3uiztHLj4JeMSlPYoCYxwsz38o19TXEi/8wjxO7UoFLz+jAjxr7f3ccsHIrH
         iIAvCcW84IXYw2GxzPPM9uLqGMXGYdFh4hVN+ljlvaA+vgOx390+WIYT/l0C8jpRs769
         ORxLknSFIRkWLt3KIfuBYuSRLoKMLyIkMhq05tvvJuqxeFsRYhGK/wblrwWfRg+76re0
         tEMA==
X-Forwarded-Encrypted: i=1; AKwUvBxsPxj+xxkZteDBn2pqUIszCEJjCCHDke4O7g9JliEDbZ40wlWZBlKmkG5K4TwuFX+aVAUqwMh3hV3Q@vger.kernel.org
X-Gm-Message-State: AFq9FYIOi2yrEVwgM667kKIRbpe+T47ESZZ5Ga1SUhosGHAcGLtb2liy
	tkn+XOONLlePFDyVQZOZB1MOtMUZFO8AxoUVJhZCT/sgZUuAwNq/HptGwWTeB3Wr3/krDMjbK1r
	svijKlsWjGScrCXpdceLNB5M2IAVVZ6XA1MqnDWO+AgHUbU0ZDae5wywiCWM=
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1707:b0:4c4:5f5b:6918 with SMTP id
 5614622812f47-53cd1cbc0edmr7852445b6e.16.1792469174897; Mon, 19 Oct 2026
 21:06:14 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:06:14 -0700
In-Reply-To: <8bb0534e33a5f5d152d2b1768d1fd7c6@manguebit.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad6e8b6.f84f00d0.6bdd.0010.GAE@google.com>
Subject: Re: [syzbot] [cifs?] KASAN: slab-use-after-free Read in cifs_crypto_secmech_release
From: syzbot <syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com>
To: pc@manguebit.org
Cc: bharathsm@microsoft.com, linkinjeon@kernel.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	samba-technical@lists.samba.org, sprasad@microsoft.com, 
	syzkaller-bugs@googlegroups.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"

> #syz test: git://git.manguebit.org/linux.git cifs-fixes

This crash does not have a reproducer. I cannot test it.

